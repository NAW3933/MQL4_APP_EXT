//+------------------------------------------------------------------+
//|                                                           mladen | 
//+------------------------------------------------------------------+
#property link      "www.forex-tsd.com"
#property copyright "www.forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  clrDeepSkyBlue
#property strict

//
//
//
//
//

enum enPrices
{
   pr_close,      // Close
   pr_open,       // Open
   pr_high,       // High
   pr_low,        // Low
   pr_median,     // Median
   pr_typical,    // Typical
   pr_weighted,   // Weighted
   pr_average,    // Average (high+low+open+close)/4
   pr_medianb,    // Average median body (open+close)/2
   pr_tbiased,    // Trend biased price
   pr_haclose,    // Heiken ashi close
   pr_haopen ,    // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased   // Heiken ashi trend biased price
};
extern double   HPPeriod   = 120;      // High pass period
extern enPrices Price      = pr_close; // Price 
extern double   K          = 1.0;      // K parameter

//
//
//
//
//

double deo[];

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
   SetIndexBuffer(0,deo);
   IndicatorShortName("Simple decyler oscillator ("+(string)HPPeriod+","+(string)K+")");
   return(0); 
}
int deinit(){ return(0); }


//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = MathMin(Bars-counted_bars,Bars-1);
         
   //
   //
   //
   //
   //
    
      for(int i=limit; i>=0; i--)
      {
         double price = getPrice(Price,Open,Close,High,Low,i);
            deo[i] = 100*K*iHp(price-iHp(price,HPPeriod,i),HPPeriod,i,1)/price;
      }       
      return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//
//

double workHp[][4];
#define  Pi 3.14159265358979323846264338327950288
#define _hpPrice 0
#define _hpValue 1

double iHp(double price, double period, int i, int instanceNo=0)
{
   if (period<=1) return(0);
   if (ArrayRange(workHp,0)!=Bars) ArrayResize(workHp,Bars); i=Bars-i-1; instanceNo*=2;
   
   //
   //
   //
   //
   //

   workHp[i][instanceNo+_hpPrice] = price;
   if (i<=2)  workHp[i][instanceNo+_hpValue] = 0;
   else  
   {          
      double angle = 0.707*2.0*Pi/period;
      double alpha = (cos(angle)+sin(angle)-1.0)/cos(angle);
         
      //
      //
      //
      //
      //
        
      workHp[i][instanceNo+_hpValue] = (1-alpha/2.0)*(1-alpha/2.0)*(workHp[i][instanceNo+_hpPrice]-2.0*workHp[i-1][instanceNo+_hpPrice]+workHp[i-2][instanceNo+_hpPrice]) + 2.0*(1-alpha)*workHp[i-1][instanceNo+_hpValue] - (1-alpha)*(1-alpha)*workHp[i-2][instanceNo+_hpValue];         
   }
   return(workHp[i][instanceNo+_hpValue]);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//
//

#define priceInstances 1
double workHa[][priceInstances*4];
double getPrice(int tprice, const double& open[], const double& close[], const double& high[], const double& low[], int i, int instanceNo=0)
{
  if (tprice>=pr_haclose)
   {
      if (ArrayRange(workHa,0)!= Bars) ArrayResize(workHa,Bars); instanceNo*=4;
         int r = Bars-i-1;
         
         //
         //
         //
         //
         //
         
         double haOpen;
         if (r>0)
                haOpen  = (workHa[r-1][instanceNo+2] + workHa[r-1][instanceNo+3])/2.0;
         else   haOpen  = (open[i]+close[i])/2;
         double haClose = (open[i] + high[i] + low[i] + close[i]) / 4.0;
         double haHigh  = MathMax(high[i], MathMax(haOpen,haClose));
         double haLow   = MathMin(low[i] , MathMin(haOpen,haClose));

         if(haOpen  <haClose) { workHa[r][instanceNo+0] = haLow;  workHa[r][instanceNo+1] = haHigh; } 
         else                 { workHa[r][instanceNo+0] = haHigh; workHa[r][instanceNo+1] = haLow;  } 
                                workHa[r][instanceNo+2] = haOpen;
                                workHa[r][instanceNo+3] = haClose;
         //
         //
         //
         //
         //
         
         switch (tprice)
         {
            case pr_haclose:     return(haClose);
            case pr_haopen:      return(haOpen);
            case pr_hahigh:      return(haHigh);
            case pr_halow:       return(haLow);
            case pr_hamedian:    return((haHigh+haLow)/2.0);
            case pr_hamedianb:   return((haOpen+haClose)/2.0);
            case pr_hatypical:   return((haHigh+haLow+haClose)/3.0);
            case pr_haweighted:  return((haHigh+haLow+haClose+haClose)/4.0);
            case pr_haaverage:   return((haHigh+haLow+haClose+haOpen)/4.0);
            case pr_hatbiased:
               if (haClose>haOpen)
                     return((haHigh+haClose)/2.0);
               else  return((haLow+haClose)/2.0);        
         }
   }
   
   //
   //
   //
   //
   //
   
   switch (tprice)
   {
      case pr_close:     return(close[i]);
      case pr_open:      return(open[i]);
      case pr_high:      return(high[i]);
      case pr_low:       return(low[i]);
      case pr_median:    return((high[i]+low[i])/2.0);
      case pr_medianb:   return((open[i]+close[i])/2.0);
      case pr_typical:   return((high[i]+low[i]+close[i])/3.0);
      case pr_weighted:  return((high[i]+low[i]+close[i]+close[i])/4.0);
      case pr_average:   return((high[i]+low[i]+close[i]+open[i])/4.0);
      case pr_tbiased:   
               if (close[i]>open[i])
                     return((high[i]+close[i])/2.0);
               else  return((low[i]+close[i])/2.0);        
   }
   return(0);
}   