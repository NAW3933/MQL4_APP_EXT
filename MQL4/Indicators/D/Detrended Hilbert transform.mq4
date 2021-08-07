//+------------------------------------------------------------------+
//|                                                                  |
//| original idea by John Ehlers                                     |
//| detrending idea By Perry Kaufman                                 |
//| detrendong applied is zero mean for DetrendPeriod > 1            |
//+------------------------------------------------------------------+
#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  DeepSkyBlue
#property indicator_width1  2

//
//
//
//
//

extern int    Price         = PRICE_MEDIAN;
extern double Alpha         = 0.07;
extern int    DetrendPeriod = 12;

//
//
//
//
//

double dht[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//

int init() 
{
   SetIndexBuffer(0,dht);
      DetrendPeriod = MathMax(DetrendPeriod,1);
   IndicatorShortName("Detrended Hilbert transform ("+DoubleToStr(Alpha,3)+","+DetrendPeriod+")");
   return(0);
}

//
//
//
//
//

int deinit()
{
   return(0);
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//

double work[][8];
#define _price  0
#define _smooth 1
#define _cycle  2
#define _period 3
#define _dphase 4
#define _q1     5
#define _i1     6
#define _dc     7
#define Pi 3.14159265358979323846264338327950288419716939937510
//
//
//
//
//

int start()
{
   int i,r,limit,counted_bars=IndicatorCounted();

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=MathMin(Bars-counted_bars,Bars-1);
           if (ArrayRange(work,0)!=Bars) ArrayResize(work,Bars);

   //
   //
   //
   //
   //
   
   for (i = limit, r=Bars-i-1; i>=0; i--, r++) 
   {
      if (DetrendPeriod>1)
            work[r][_price] = iMA(NULL,0,1,0,MODE_SMA,Price,i)-iMA(NULL,0,DetrendPeriod,0,MODE_SMA,Price,i);
      else  work[r][_price] = iMA(NULL,0,1,0,MODE_SMA,Price,i);
      work[r][_smooth] = (work[r][_price]+2.0*work[r-1][_price]+2.0*work[r-2][_price]+work[r-3][_price])/6.0;
      work[r][_cycle]  = (1.0-0.5*Alpha)*(1.0-0.5*Alpha)*(work[r][_smooth]-2.0*work[r-1][_smooth]+work[r-2][_smooth])+2.0*(1.0-Alpha)*work[r-1][_cycle]-(1.0-Alpha)*(1.0-Alpha)*work[r-2][_cycle];
      work[r][_q1]     = (0.0962*work[r][_cycle]+0.5769*work[r-2][_cycle]-0.5769*work[r-4][_cycle]-0.0962*work[r-6][_cycle])*(0.5+0.8*work[r-1][_period]);
      work[r][_i1]     = work[r-3][_cycle];


      //
      //
      //
      //
      //

         work[r][_dphase] = work[r-1][_dphase];      
         if (work[r][_q1] != 0 && work[r-1][_q1] != 0)
             work[r][_dphase] = (work[r][_i1]/work[r][_q1]-work[r-1][_i1]/work[r-1][_q1])/(1.0 + work[r][_i1]*work[r-1][_i1]/(work[r][_q1]*work[r-1][_q1]));
         if (work[r][_dphase] < 0.0) work[r][_dphase] = work[r-1][_dphase];
         if (work[r][_dphase] > 1.1) work[r][_dphase] = 1.1;
       
      //
      //
      //
      //
      //
       
         work[r][_dc] = work[r-1][_dc];
         double phasesum    = 0;
         double oldPhasesum = 0;
         for (int k=0; k<40; k++)
         {
            phasesum = oldPhasesum+work[r][_dphase];
               if (phasesum>=(2.0*Pi) && oldPhasesum<(2.0*Pi)) work[r][_dc] = k+1;
            oldPhasesum = phasesum;
         }
         
      //
      //
      //
      //
      //

      work[r][_period] = 0.2*work[r][_dc]+0.8*work[r-1][_period];
      dht[i] = work[r][_period];
   }
   return(0); 
}