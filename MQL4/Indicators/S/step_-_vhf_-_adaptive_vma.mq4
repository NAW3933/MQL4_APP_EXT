//+------------------------------------------------------------------+
//|                                        step vhf adaptive vma.mq4 |
//|                                        from Mladen mt5 version   |
//+------------------------------------------------------------------+
//------------------------------------------------------------------
#property link      "www.forex-station.com"
#property copyright "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1  clrDarkGray
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
   pr_tbiased2,   // Trend biased (extreme) price
   pr_haclose,    // Heiken ashi close
   pr_haopen ,    // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased,  // Heiken ashi trend biased price
   pr_hatbiased2, // Heiken ashi trend biased (extreme) price
   pr_habclose,   // Heiken ashi (better formula) close
   pr_habopen ,   // Heiken ashi (better formula) open
   pr_habhigh,    // Heiken ashi (better formula) high
   pr_hablow,     // Heiken ashi (better formula) low
   pr_habmedian,  // Heiken ashi (better formula) median
   pr_habtypical, // Heiken ashi (better formula) typical
   pr_habweighted,// Heiken ashi (better formula) weighted
   pr_habaverage, // Heiken ashi (better formula) average
   pr_habmedianb, // Heiken ashi (better formula) median body
   pr_habtbiased, // Heiken ashi (better formula) trend biased price
   pr_habtbiased2 // Heiken ashi (better formula) trend biased (extreme) price
};

input int               inpPeriod    = 14;                   // VMA period
input int               inpPeriod2   = 0;                    // VHF period (<=1 for same as VMA period
input enPrices          Price        = pr_close;             // Price    
input double            inpStepSize  = 1.0;                  // Step size (pips)
input color             ColorUp      = clrMediumSeaGreen;    // Color for up
input color             ColorDown    = clrDeepPink;          // Color for down
input color             ShadowColor  = clrGray;              // Shadow color
input int               LineWidth    = 2;                    // Main line width
input int               ShadowWidth  = 2;                    // Shadow width (<=0 main line width+3) 
  
double val[],valc[],buffer1da[],buffer1db[],buffer1ua[],buffer1ub[],shadowa[],shadowb[],avg[],prices[];
double alpha,stepSize;
int    adpPeriod;

//------------------------------------------------------------------
//  Custom indicator initialization function
//------------------------------------------------------------------ 

int OnInit()
{
   int shadowWidth = (ShadowWidth<=0) ? LineWidth+3 : ShadowWidth;
   IndicatorBuffers(10);
   SetIndexBuffer(0, val,      INDICATOR_DATA); SetIndexStyle(0,DRAW_LINE,EMPTY,LineWidth);
   SetIndexBuffer(1, shadowa,  INDICATOR_DATA); SetIndexStyle(1,DRAW_LINE,EMPTY,shadowWidth,ShadowColor);
   SetIndexBuffer(2, shadowb,  INDICATOR_DATA); SetIndexStyle(2,DRAW_LINE,EMPTY,shadowWidth,ShadowColor);
   SetIndexBuffer(3, buffer1ua,INDICATOR_DATA); SetIndexStyle(3,DRAW_LINE,EMPTY,LineWidth,ColorUp);
   SetIndexBuffer(4, buffer1ub,INDICATOR_DATA); SetIndexStyle(4,DRAW_LINE,EMPTY,LineWidth,ColorUp);
   SetIndexBuffer(5, buffer1da,INDICATOR_DATA); SetIndexStyle(5,DRAW_LINE,EMPTY,LineWidth,ColorDown);
   SetIndexBuffer(6, buffer1db,INDICATOR_DATA); SetIndexStyle(6,DRAW_LINE,EMPTY,LineWidth,ColorDown);
   SetIndexBuffer(7, avg,      INDICATOR_CALCULATIONS);
   SetIndexBuffer(8, prices,   INDICATOR_CALCULATIONS);
   SetIndexBuffer(9, valc,     INDICATOR_CALCULATIONS);
   
   stepSize  = stepSize  = (inpStepSize>0 ? inpStepSize:0)*_Point*pow(10,_Digits%2);
   alpha     = 2.0/(1.0+fmax(inpPeriod,1)); 
   adpPeriod = (inpPeriod2<=1 ? inpPeriod : inpPeriod2);
   
   IndicatorShortName("VMA  ("+(string)inpPeriod+","+(string)inpPeriod2+")");
return (INIT_SUCCEEDED);
}
void OnDeinit(const int reason) { }

//
//
//
//
//

int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int i,counted_bars=prev_calculated;
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = fmin(rates_total-counted_bars,rates_total-1); 
   
   //
   //
   //
   //
   //
   
   if (valc[limit]==-1) { CleanPoint(limit,buffer1da,buffer1db); CleanPoint(limit,shadowa,shadowb); }
   if (valc[limit]== 1) { CleanPoint(limit,buffer1ua,buffer1ub); CleanPoint(limit,shadowa,shadowb); }
   for(i = limit; i >= 0; i--)
   { 
      prices[i] = getPrice(Price,open,close,high,low,i,rates_total);
      double noise = 0, vhf = 0;
      double max   = prices[i];
      double min   = prices[i];
      for (int k=0; k<adpPeriod && (i+k+1)<rates_total; k++)
      {
          noise += fabs(prices[i+k]-prices[i+k+1]);
          max    = fmax(prices[i+k],max);   
          min    = fmin(prices[i+k],min);   
      }      
      if (noise>0) vhf = (max-min)/noise;
      avg[i] = (i<rates_total-1) ? avg[i+1]+(alpha*vhf*2)*(prices[i]-avg[i+1]) : prices[i];
      
      //
      //
      //
      //
      //
       if (i<rates_total-1 && stepSize>0)
      {
           double diff = avg[i]-val[i+1];
           val[i] = val[i+1]+((diff<stepSize && diff>-stepSize) ? 0 : (int)(diff/stepSize)*stepSize); 
      }
      else val[i]  = (stepSize>0) ? round(avg[i]/stepSize)*stepSize : avg[i]; 
      buffer1da[i] = EMPTY_VALUE;
      buffer1db[i] = EMPTY_VALUE;
      buffer1ua[i] = EMPTY_VALUE;
      buffer1ub[i] = EMPTY_VALUE;
      shadowa[i]   = EMPTY_VALUE;
      shadowb[i]   = EMPTY_VALUE;
      valc[i] = (i<rates_total-1) ? (val[i]>val[i+1]) ? 1 : (val[i]<val[i+1]) ? -1 : valc[i+1] : 0 ;
      if (valc[i] == -1) { PlotPoint(i,buffer1da,buffer1db,val); PlotPoint(i,shadowa,shadowb,val); }
      if (valc[i] ==  1) { PlotPoint(i,buffer1ua,buffer1ub,val); PlotPoint(i,shadowa,shadowb,val); } 
   }
return(rates_total);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

#define _prHABF(_prtype) (_prtype>=pr_habclose && _prtype<=pr_habtbiased2)
#define _priceInstances     1
#define _priceInstancesSize 4
double workHa[][_priceInstances*_priceInstancesSize];
double getPrice(int tprice, const double& open[], const double& close[], const double& high[], const double& low[], int i, int bars, int instanceNo=0)
{
  if (tprice>=pr_haclose)
   {
      if (ArrayRange(workHa,0)!= bars) ArrayResize(workHa,bars); instanceNo*=_priceInstancesSize; int r = bars-i-1;
         
         //
         //
         //
         //
         //
         
         double haOpen  = (r>0) ? (workHa[r-1][instanceNo+2] + workHa[r-1][instanceNo+3])/2.0 : (open[i]+close[i])/2;;
         double haClose = (open[i]+high[i]+low[i]+close[i]) / 4.0;
         if (_prHABF(tprice))
               if (high[i]!=low[i])
                     haClose = (open[i]+close[i])/2.0+(((close[i]-open[i])/(high[i]-low[i]))*fabs((close[i]-open[i])/2.0));
               else  haClose = (open[i]+close[i])/2.0; 
         double haHigh  = fmax(high[i], fmax(haOpen,haClose));
         double haLow   = fmin(low[i] , fmin(haOpen,haClose));

         //
         //
         //
         //
         //
         
         if(haOpen<haClose) { workHa[r][instanceNo+0] = haLow;  workHa[r][instanceNo+1] = haHigh; } 
         else               { workHa[r][instanceNo+0] = haHigh; workHa[r][instanceNo+1] = haLow;  } 
                              workHa[r][instanceNo+2] = haOpen;
                              workHa[r][instanceNo+3] = haClose;
         //
         //
         //
         //
         //
         
         switch (tprice)
         {
            case pr_haclose:
            case pr_habclose:    return(haClose);
            case pr_haopen:   
            case pr_habopen:     return(haOpen);
            case pr_hahigh: 
            case pr_habhigh:     return(haHigh);
            case pr_halow:    
            case pr_hablow:      return(haLow);
            case pr_hamedian:
            case pr_habmedian:   return((haHigh+haLow)/2.0);
            case pr_hamedianb:
            case pr_habmedianb:  return((haOpen+haClose)/2.0);
            case pr_hatypical:
            case pr_habtypical:  return((haHigh+haLow+haClose)/3.0);
            case pr_haweighted:
            case pr_habweighted: return((haHigh+haLow+haClose+haClose)/4.0);
            case pr_haaverage:  
            case pr_habaverage:  return((haHigh+haLow+haClose+haOpen)/4.0);
            case pr_hatbiased:
            case pr_habtbiased:
               if (haClose>haOpen)
                     return((haHigh+haClose)/2.0);
               else  return((haLow+haClose)/2.0);        
            case pr_hatbiased2:
            case pr_habtbiased2:
               if (haClose>haOpen)  return(haHigh);
               if (haClose<haOpen)  return(haLow);
                                    return(haClose);        
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
      case pr_tbiased2:   
               if (close[i]>open[i]) return(high[i]);
               if (close[i]<open[i]) return(low[i]);
                                     return(close[i]);        
   }
   return(0);
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
            { first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                          second[i] = EMPTY_VALUE; }
}




