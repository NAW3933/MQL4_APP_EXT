//+------------------------------------------------------------------+
//|                                                           mladen | 
//+------------------------------------------------------------------+
#property link      "www.forex-tsd.com"
#property copyright "www.forex-tsd.com"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1  clrDeepSkyBlue
#property indicator_color2  clrDeepSkyBlue
#property indicator_color3  clrSandyBrown
#property indicator_color4  clrSandyBrown
#property indicator_color5  clrSandyBrown
#property indicator_style1  STYLE_DOT
#property indicator_style5  STYLE_DOT
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2
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
enum enFilterWhat
{
   flt_prc,  // Filter the prices
   flt_val,  // Filter the main value
   flt_all   // Filter all
};

extern int          HPPeriod = 120;      // High pass period
extern enPrices     Price    = pr_close; // Price 
extern double       BandsP   = 0.3;      // Bands percent
extern double       Filter   = 0;        // Filter to use (<=0 for no filter)
extern enFilterWhat FilterOn = flt_prc;  // Filter :

//
//
//
//
//

double bandu[],bandd[],sd[],sdda[],sddb[],hp[],prices[],slope[];

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
   IndicatorDigits(7);
   IndicatorBuffers(8);
   SetIndexBuffer(0,bandu);
   SetIndexBuffer(1,sd);
   SetIndexBuffer(2,sdda);
   SetIndexBuffer(3,sddb);
   SetIndexBuffer(4,bandd);
   SetIndexBuffer(5,prices);
   SetIndexBuffer(6,hp);
   SetIndexBuffer(7,slope);
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
    
      double pfilter = Filter; if (FilterOn==flt_val) pfilter=0;
      double vfilter = Filter; if (FilterOn==flt_prc) vfilter=0;
      double angle   = 0.707*2.0*M_PI/HPPeriod;
      double alpha   = (cos(angle)+sin(angle)-1.0)/cos(angle);
      if (slope[limit]==-1) CleanPoint(limit,sdda,sddb);
      for(int i=limit; i>=0; i--)
      {
         prices[i] = iFilter(getPrice(Price,Open,Close,High,Low,i),pfilter,HPPeriod,i,0); 
         if (i>=Bars-2) { hp[i] = prices[i]; continue; }
         
         //
         //
         //
         //
         //
         
         hp[i]    = (1-alpha/2.0)*(1-alpha/2.0)*(prices[i]-2.0*prices[i+1]+prices[i+2]) + 2.0*(1-alpha)*hp[i+1] - (1-alpha)*(1-alpha)*hp[i+2];         
         sd[i]    = iFilter(prices[i]-hp[i],vfilter,HPPeriod,i,1);
         bandd[i] = (1-BandsP/100.0)*sd[i];
         bandu[i] = (1+BandsP/100.0)*sd[i];
         sdda[i]  = EMPTY_VALUE;
         sddb[i]  = EMPTY_VALUE;
         slope[i] = (i<Bars-1) ? (sd[i]>sd[i+1]) ? 1 : (sd[i]<sd[i+1]) ? -1 : slope[i+1] : 0;
         if (slope[i]==-1) PlotPoint(i,sdda,sddb,sd);
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

#define filterInstances 2
double workFil[][filterInstances*3];

#define _fchange 0
#define _fachang 1
#define _fprice  2

double iFilter(double tprice, double filter, int period, int i, int instanceNo=0)
{
   if (filter<=0) return(tprice);
   if (ArrayRange(workFil,0)!= Bars) ArrayResize(workFil,Bars); i = Bars-i-1; instanceNo*=3;
   
   //
   //
   //
   //
   //
   
   workFil[i][instanceNo+_fprice]  = tprice; if (i<1) return(tprice);
   workFil[i][instanceNo+_fchange] = MathAbs(workFil[i][instanceNo+_fprice]-workFil[i-1][instanceNo+_fprice]);
   workFil[i][instanceNo+_fachang] = workFil[i][instanceNo+_fchange];

   for (int k=1; k<period && (i-k)>=0; k++) workFil[i][instanceNo+_fachang] += workFil[i-k][instanceNo+_fchange];
                                            workFil[i][instanceNo+_fachang] /= period;
    
   double stddev = 0; for (int k=0;  k<period && (i-k)>=0; k++) stddev += MathPow(workFil[i-k][instanceNo+_fchange]-workFil[i-k][instanceNo+_fachang],2);
          stddev = MathSqrt(stddev/(double)period); 
   double filtev = filter * stddev;
   if( MathAbs(workFil[i][instanceNo+_fprice]-workFil[i-1][instanceNo+_fprice]) < filtev ) workFil[i][instanceNo+_fprice]=workFil[i-1][instanceNo+_fprice];
        return(workFil[i][instanceNo+_fprice]);
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

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
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