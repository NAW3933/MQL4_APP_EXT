//------------------------------------------------------------------
#property copyright   "www.forex-tsd.com"
#property link        "www.forex-tsd.com"
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 10
#property indicator_color1  clrSilver
#property indicator_color2  clrSilver
#property indicator_color3  clrSilver
#property indicator_color4  clrDimGray
#property indicator_color5  clrDimGray
#property indicator_color6  clrLightGray
#property indicator_style2  STYLE_DOT
#property strict

//
//
//
//
//

enum enMaTypes
{
   ma_sma,    // Simple moving average
   ma_ema,    // Exponential moving average
   ma_smma,   // Smoothed MA
   ma_lwma    // Linear weighted MA
};
enum enColorOn
{
   cc_onSlope,   // Change color on slope change
   cc_onMiddle,  // Change color on middle line cross
   cc_onLevels   // Change color on outer levels cross
};

extern ENUM_TIMEFRAMES    TimeFrame           = PERIOD_CURRENT;    // Time frame
extern string             ForSymbol           = "";                // For symbol (leave empty for current chart symbol)
extern int                VolPeriod           = 14;                // Relative volatility index period
extern ENUM_APPLIED_PRICE VolPrice            = PRICE_CLOSE;       // Price to use
extern enMaTypes          VolStdMaMethod      = ma_sma;            // Average method for deviation calculation
extern enMaTypes          VolMaMethod         = ma_smma;           // Average method for volatility calculation
extern int                VolSmooth           = 10;                // Smoothing period 
extern enMaTypes          VolSmoothMethod     = ma_ema;            // Average method for volatility smoothing
extern double             ZoneUp              = 60;                // Upper zone limit
extern double             ZoneDown            = 40;                // Lower zone limit
extern enColorOn          ColorOn             = cc_onLevels;       // Color change :
extern color              ColorUp             = clrLimeGreen;      // Color for up
extern color              ColorDown           = clrOrangeRed;      // Color for down
extern int                LineWidth           = 3;                 // Main line width
extern bool               Interpolate         = true;              // Interpolate in multi time frame?

//
//
//
//
//

double mom[],momUa[],momUb[],momDa[],momDb[],levup[],levmi[],levdn[],trend[],shadowa[],shadowb[];
string indicatorFileName,shortName;
bool   returnBars;

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init()
{
   IndicatorBuffers(11);
   SetIndexBuffer(0,levup);
   SetIndexBuffer(1,levmi);
   SetIndexBuffer(2,levdn);
   SetIndexBuffer(3,shadowa); SetIndexStyle(3,EMPTY,EMPTY,LineWidth+3);
   SetIndexBuffer(4,shadowb); SetIndexStyle(4,EMPTY,EMPTY,LineWidth+3);
   SetIndexBuffer(5,mom);     SetIndexStyle(5,EMPTY,EMPTY,LineWidth);
   SetIndexBuffer(6,momUa);   SetIndexStyle(6,EMPTY,EMPTY,LineWidth,ColorUp);
   SetIndexBuffer(7,momUb);   SetIndexStyle(7,EMPTY,EMPTY,LineWidth,ColorUp);
   SetIndexBuffer(8,momDa);   SetIndexStyle(8,EMPTY,EMPTY,LineWidth,ColorDown);
   SetIndexBuffer(9,momDb);   SetIndexStyle(9,EMPTY,EMPTY,LineWidth,ColorDown);
   SetIndexBuffer(10,trend); 
   
       //
       //
       //
       //
       //
      
       indicatorFileName = WindowExpertName();
       returnBars        = (TimeFrame==-99);
       TimeFrame         = MathMax(TimeFrame,_Period);
       if (ForSymbol=="") ForSymbol = _Symbol;
         shortName = ForSymbol+" "+timeFrameToString(TimeFrame)+" relative volatility index ("+(string)VolPeriod+")";
   IndicatorShortName(shortName);
   return(0);
}
int deinit() { return (0); }

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
      if(counted_bars < 0) return(-1);
      if(counted_bars > 0) counted_bars--;
            int window = WindowFind(shortName);
            int limit  = MathMin(Bars-counted_bars,Bars-1);
            if (returnBars) { levup[0] = limit+1; return(0); }
            if (TimeFrame != _Period || ForSymbol!=_Symbol)
            {
               limit = (int)MathMax(limit,MathMin(Bars-1,iCustom(ForSymbol,TimeFrame,indicatorFileName,-99,0,0)*TimeFrame/Period())); 
               if (trend[limit]== 1) { CleanPoint(limit,momUa,momUb); CleanPoint(limit,shadowa,shadowb); }
               if (trend[limit]==-1) { CleanPoint(limit,momDa,momDb); CleanPoint(limit,shadowa,shadowb); }
               for(int i=limit; i>=0; i--)
               {
                  int y = iBarShift(NULL,TimeFrame,Time[i]);
                     mom[i]   = iCustom(ForSymbol,TimeFrame,indicatorFileName,PERIOD_CURRENT,"",VolPeriod,VolPrice,VolStdMaMethod,VolMaMethod,VolSmooth,VolSmoothMethod,ZoneUp,ZoneDown,ColorOn, 5,y);
                     trend[i] = iCustom(ForSymbol,TimeFrame,indicatorFileName,PERIOD_CURRENT,"",VolPeriod,VolPrice,VolStdMaMethod,VolMaMethod,VolSmooth,VolSmoothMethod,ZoneUp,ZoneDown,ColorOn,10,y);
                     momDa[i] = EMPTY_VALUE;
                     momDb[i] = EMPTY_VALUE;
                     momUa[i] = EMPTY_VALUE;
                     momUb[i] = EMPTY_VALUE;
                     levup[i] = ZoneUp;
                     levdn[i] = ZoneDown;
                     levmi[i] = (levup[i]+levdn[i])/2.0;
                     shadowa[i] = EMPTY_VALUE;
                     shadowb[i] = EMPTY_VALUE;
                     
                     if (!Interpolate || (i>0 && y==iBarShift(NULL,TimeFrame,Time[i-1]))) continue;
                  
                     //
                     //
                     //
                     //
                     //
                  
                        int n,j; datetime time = iTime(NULL,TimeFrame,y);
                           for(n = 1; (i+n)<Bars && Time[i+n] >= time; n++) continue;	
                           for(j = 1; j<n && (i+n)<Bars && (i+j)<Bars; j++)
                              mom[i+j]   = mom[i]   + (mom[i+n]   - mom[i]  )*j/n;
               }
               for(int i=limit; i>=0; i--)
               {
                  if (i<Bars-1 && trend[i] ==  1) { PlotPoint(i,momUa,momUb,mom); PlotPoint(i,shadowa,shadowb,mom); }
                  if (i<Bars-1 && trend[i] == -1) { PlotPoint(i,momDa,momDb,mom); PlotPoint(i,shadowa,shadowb,mom); }
               }
               return(0);
            }

   //
   //
   //
   //
   //

     if (trend[limit]== 1) { CleanPoint(limit,momUa,momUb); CleanPoint(limit,shadowa,shadowb); }
     if (trend[limit]==-1) { CleanPoint(limit,momDa,momDb); CleanPoint(limit,shadowa,shadowb); }
     for (int i=limit; i>=0; i--)
     {  
         double pricec = iMA(NULL,0,1,0,(int)VolStdMaMethod,VolPrice,i  );
         double pricep = iMA(NULL,0,1,0,(int)VolStdMaMethod,VolPrice,i+1);
            double dev  = iStdDev(NULL,0,VolPeriod,0,(int)VolStdMaMethod,VolPrice,i);
            double u    = (i<Bars-1) ? (pricec>pricep) ? dev : 0 : 0;
            double d    = (i<Bars-1) ? (pricec<pricep) ? dev : 0 : 0;
            double avgu = iCustomMa(VolMaMethod,u,VolPeriod,i,0);
            double avgd = iCustomMa(VolMaMethod,d,VolPeriod,i,1);
               if ((avgu+avgd)!=0)
                     mom[i]  = iCustomMa(VolSmoothMethod,100.0*avgu/(avgu+avgd),VolSmooth,i,2);
               else  mom[i]  = iCustomMa(VolSmoothMethod,50                    ,VolSmooth,i,2);            

         //
         //
         //
         //
         //
                  
            levup[i] = ZoneUp;
            levdn[i] = ZoneDown;
            levmi[i] = (levup[i]+levdn[i])/2.0;
            momDa[i] = EMPTY_VALUE;
            momDb[i] = EMPTY_VALUE;
            momUa[i] = EMPTY_VALUE;
            momUb[i] = EMPTY_VALUE;
            trend[i]   = 0;
            switch(ColorOn)
            {
               case cc_onLevels: trend[i] = (mom[i]>levup[i]) ? 1 : (mom[i]<levdn[i]) ? -1 : 0; break;
               case cc_onMiddle: trend[i] = (mom[i]>levmi[i]) ? 1 : (mom[i]<levmi[i]) ? -1 : 0; break;
               default : trend[i] = (i<Bars-1) ? (mom[i]>mom[i+1]) ? 1 : (mom[i]<mom[i+1]) ? -1 : 0 : 0;
            }                  
         
         //
         //
         //
         //
         //
         
         shadowa[i] = EMPTY_VALUE;
         shadowb[i] = EMPTY_VALUE;
         if (trend[i] ==  1) { PlotPoint(i,momUa,momUb,mom); PlotPoint(i,shadowa,shadowb,mom); }
         if (trend[i] == -1) { PlotPoint(i,momDa,momDb,mom); PlotPoint(i,shadowa,shadowb,mom); }
   }    
   return(0);
}   

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if (i>=Bars-3) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (i>=Bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i];  first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] =  from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                           second[i] = EMPTY_VALUE; }
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//

#define _maInstances 3
#define _maWorkBufferx1 1*_maInstances
#define _maWorkBufferx2 2*_maInstances

double iCustomMa(int mode, double price, double length, int r, int instanceNo=0)
{
   r = Bars-r-1;
   switch (mode)
   {
      case ma_sma   : return(iSma(price,(int)length,r,instanceNo));
      case ma_ema   : return(iEma(price,length,r,instanceNo));
      case ma_smma  : return(iSmma(price,(int)length,r,instanceNo));
      case ma_lwma  : return(iLwma(price,(int)length,r,instanceNo));
      default       : return(price);
   }
}

//
//
//
//
//

double workSma[][_maWorkBufferx2];
double iSma(double price, int period, int r, int instanceNo=0)
{
   if (period<=1) return(price);
   if (ArrayRange(workSma,0)!= Bars) ArrayResize(workSma,Bars); instanceNo *= 2; int k;

   //
   //
   //
   //
   //
      
   workSma[r][instanceNo+0] = price;
   workSma[r][instanceNo+1] = price; for(k=1; k<period && (r-k)>=0; k++) workSma[r][instanceNo+1] += workSma[r-k][instanceNo+0];  
   workSma[r][instanceNo+1] /= 1.0*k;
   return(workSma[r][instanceNo+1]);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int instanceNo=0)
{
   if (period<=1) return(price);
   if (ArrayRange(workEma,0)!= Bars) ArrayResize(workEma,Bars);

   //
   //
   //
   //
   //
      
   workEma[r][instanceNo] = price;
   double alpha = 2.0 / (1.0+period);
   if (r>0)
          workEma[r][instanceNo] = workEma[r-1][instanceNo]+alpha*(price-workEma[r-1][instanceNo]);
   return(workEma[r][instanceNo]);
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int instanceNo=0)
{
   if (period<=1) return(price);
   if (ArrayRange(workSmma,0)!= Bars) ArrayResize(workSmma,Bars);

   //
   //
   //
   //
   //

   if (r<period)
         workSmma[r][instanceNo] = price;
   else  workSmma[r][instanceNo] = workSmma[r-1][instanceNo]+(price-workSmma[r-1][instanceNo])/period;
   return(workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int instanceNo=0)
{
   if (period<=1) return(price);
   if (ArrayRange(workLwma,0)!= Bars) ArrayResize(workLwma,Bars);
   
   //
   //
   //
   //
   //
   
   workLwma[r][instanceNo] = price;
      double sumw = period;
      double sum  = period*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = period-k;
                sumw  += weight;
                sum   += weight*workLwma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}