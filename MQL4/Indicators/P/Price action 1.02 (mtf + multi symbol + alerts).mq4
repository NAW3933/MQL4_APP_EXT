//------------------------------------------------------------------
#property copyright   "copyright© mladen"
#property link        "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color3 clrSilver
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2
#property strict

//
//
//
//
//

enum enDisplayType
{
   dis_lines, // Display as colored lines
   dis_histo, // Display as colored histogram with colored lines
   dis_binary // Display as colored simple 0-1 histogram
};
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
enum enMaTypes
{
   ma_sma,  // Simple moving average
   ma_ema,  // Exponential moving average
   ma_smma, // Smoothed moving average
   ma_lwma, // Linear weighted moving average
   ma_tema, // Triple exponential moving average - TEMA
   ma_lsma  // Linear regression value (lsma)
};

extern ENUM_TIMEFRAMES   TimeFrame        = PERIOD_CURRENT;    // Time frame
extern string            ForSymbol        = "";                // Symbol to use (leave empty for current symbol)
input int                CalcPeriod       = 50;                // Calculation period
input enMaTypes          CalcMethod       = ma_lwma;           // Average type
input enPrices           Price            = pr_close;          // Price to use
input color              ColorUp          = clrLimeGreen;      // Color up
input color              ColorDown        = clrOrangeRed;      // Color down
input enDisplayType      DisplayAs        = dis_lines;         // Display as :
input bool               alertsOn         = true;              // Alerts on true/false?
input bool               alertsOnCurrent  = false;             // Alerts on current bar true/false?
input bool               alertsMessage    = true;              // Alerts message true/false?
input bool               alertsSound      = false;             // Alerts sound true/false?
input bool               alertsEmail      = false;             // Alerts email true/false?
input bool               alertsNotify     = false;             // Alerts notification true/false?
input string             soundFile        = "alert2.wav";      // Sound file
input bool               Interpolate      = true;              // Interpolate mtf true/false?


double ma[],mada[],madb[],av[],histbu[],histbd[],slope[],prices[],count[];
string names[] = {"SMA","EMA","SMMA","LWMA","TEMA","LSMA"};
string indicatorFileName;
#define _mtfCall(_buff,_y) iCustom(ForSymbol,TimeFrame,indicatorFileName,PERIOD_CURRENT,"",CalcPeriod,CalcMethod,Price,ColorUp,ColorDown,DisplayAs,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsEmail,alertsNotify,soundFile,_buff,_y)

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int OnInit()
{ 
   int lstyle = DRAW_LINE;      if (DisplayAs==dis_binary) lstyle = DRAW_NONE;
   int bstyle = DRAW_HISTOGRAM; if (DisplayAs==dis_lines)  bstyle = DRAW_NONE;
   IndicatorBuffers(8);
   SetIndexBuffer(0,histbu,INDICATOR_DATA); SetIndexStyle(0,bstyle,EMPTY,EMPTY,ColorUp);
   SetIndexBuffer(1,histbd,INDICATOR_DATA); SetIndexStyle(1,bstyle,EMPTY,EMPTY,ColorDown);
   SetIndexBuffer(2,av,    INDICATOR_DATA); SetIndexStyle(2,lstyle);
   SetIndexBuffer(3,ma,    INDICATOR_DATA); SetIndexStyle(3,lstyle,EMPTY,EMPTY,ColorUp);
   SetIndexBuffer(4,mada,  INDICATOR_DATA); SetIndexStyle(4,lstyle,EMPTY,EMPTY,ColorDown);
   SetIndexBuffer(5,madb,  INDICATOR_DATA); SetIndexStyle(5,lstyle,EMPTY,EMPTY,ColorDown); 
   SetIndexBuffer(6,slope, INDICATOR_CALCULATIONS); 
   SetIndexBuffer(7,count, INDICATOR_CALCULATIONS);
   
   indicatorFileName = WindowExpertName();
   TimeFrame         = fmax(TimeFrame,_Period); 
   ForSymbol = (ForSymbol=="") ? _Symbol : ForSymbol; 
    
   IndicatorShortName(timeFrameToString(TimeFrame)+" "+ForSymbol+" Price action with "+names[CalcMethod]+" ("+(string)CalcPeriod+")");
return(INIT_SUCCEEDED); 
}
void OnDeinit(const int reason){  }

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int OnCalculate (const int       rates_total,
                 const int       prev_calculated,
                 const datetime& time[],
                 const double&   open[],
                 const double&   high[],
                 const double&   low[],
                 const double&   close[],
                 const long&     tick_volume[],
                 const long&     volume[],
                 const int&      spread[])
{    
   int i,counted_bars=prev_calculated;
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = fmin(rates_total-counted_bars,rates_total-1); count[0]=limit;
            if (TimeFrame!=_Period || ForSymbol!=_Symbol)
            {
               limit = (int)fmax(limit,fmin(rates_total-1,_mtfCall(7,0)*TimeFrame/_Period));
               if (slope[limit]==-1) CleanPoint(limit,mada,madb);
               for (i=limit;i>=0 && !_StopFlag; i--)
               {
                  int y = iBarShift(ForSymbol,TimeFrame,Time[i]);
                     av[i]     = _mtfCall(2,y);
                     ma[i]     = _mtfCall(3,y);
                     mada[i]   = EMPTY_VALUE;
                     madb[i]   = EMPTY_VALUE;
                     histbu[i] = EMPTY_VALUE;
                     histbd[i] = EMPTY_VALUE;
                     slope[i]  = _mtfCall(6,y);
                 
                     //
                     //
                     //
                     //
                     //
                     
                     if (!Interpolate || (i>0 && y==iBarShift(ForSymbol,TimeFrame,Time[i-1]))) continue;
                        #define _interpolate(buff) buff[i+k] = buff[i]+(buff[i+n]-buff[i])*k/n
                        int n,k; datetime btime = iTime(ForSymbol,TimeFrame,y);
                           for(n = 1; (i+n)<rates_total && Time[i+n] >= btime; n++) continue;	
                           for(k = 1; k<n && (i+n)<rates_total && (i+k)<rates_total; k++)
                           {
                              _interpolate(av);
                              _interpolate(ma);
                           }                                    
              }
              for (i=limit; i >= 0; i--)
              {
                  if (DisplayAs!=dis_binary) if (slope[i]==-1) PlotPoint(i,mada,madb,ma);
                  if (DisplayAs==dis_binary)
                  {
                     if (slope[i]== 1) { histbu[i] = 1; histbd[i] = 0; }
                     if (slope[i]==-1) { histbd[i] = 1; histbu[i] = 0; }
                     ma[i] = 0;
                   }
                   if (DisplayAs==dis_histo)
                   {
                     if (slope[i]== 1) { histbu[i] = ma[i]; histbd[i] = 0; }
                     if (slope[i]==-1) { histbd[i] = ma[i]; histbu[i] = 0; }
                   }    
	            }  
   return(rates_total);
   }
            
   //
   //
   //
   //
   //
   

   if (slope[limit]==-1) CleanPoint(limit,mada,madb);
   for (i=limit; i>=0; i--)
   {
      double price = getPrice(Price,open,close,high,low,i,rates_total);
      av[i] = iCustomMa(CalcMethod,price,CalcPeriod,i,rates_total);
      ma[i] = close[i]+open[i]-2*av[i]; av[i] = open[i]-av[i];
      mada[i]   = EMPTY_VALUE;
      madb[i]   = EMPTY_VALUE;
      histbu[i] = EMPTY_VALUE;
      histbd[i] = EMPTY_VALUE;
      if (i<rates_total-1) slope[i] = slope[i+1];
            if (ma[i]<0) slope[i] = -1;
            if (ma[i]>0) slope[i] =  1;
            if (DisplayAs!=dis_binary)
               if (slope[i]==-1) PlotPoint(i,mada,madb,ma);
            if (DisplayAs==dis_binary)
            {
               if (slope[i]== 1) { histbu[i] = 1; histbd[i] = 0; }
               if (slope[i]==-1) { histbd[i] = 1; histbu[i] = 0; }
               ma[i] = 0;
            }
            if (DisplayAs==dis_histo)
            {
               if (slope[i]== 1) { histbu[i] = ma[i]; histbd[i] = 0; }
               if (slope[i]==-1) { histbd[i] = ma[i]; histbu[i] = 0; }
            }
   }   
   if (alertsOn)
   {
      int whichBar = 1; if (alertsOnCurrent) whichBar = 0; 
      if (slope[whichBar] != slope[whichBar+1])
      if (slope[whichBar] == 1)
            doAlert(" crossing zero up");
      else  doAlert(" crossing zero down");       
   }             
return(rates_total);
}

//
//
//
//
//

#define _maInstances 1
#define _maWorkBufferx1 1*_maInstances
#define _maWorkBufferx3 3*_maInstances

double iCustomMa(int mode, double price, double length, int r, int bars, int instanceNo=0)
{
   r = bars-r-1;
   switch (mode)
   {
      case ma_sma   : return(iSma(price,(int)ceil(length),r,bars,instanceNo));
      case ma_ema   : return(iEma(price,length,r,bars,instanceNo));
      case ma_smma  : return(iSmma(price,(int)ceil(length),r,bars,instanceNo));
      case ma_lwma  : return(iLwma(price,(int)ceil(length),r,bars,instanceNo));
      case ma_tema  : return(iTema(price,(int)ceil(length),r,bars,instanceNo));
      case ma_lsma  : return(iLinr(price,(int)ceil(length),r,bars,instanceNo));
      default       : return(price);
   }
}

//
//
//
//
//

double workSma[][_maWorkBufferx1];
double iSma(double price, int period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSma,0)!= _bars) ArrayResize(workSma,_bars);

   workSma[r][instanceNo+0] = price;
   double avg = price; int k=1; for(; k<period && (r-k)>=0; k++) avg += workSma[r-k][instanceNo+0];  
   return(avg/(double)k);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workEma,0)!= _bars) ArrayResize(workEma,_bars);

   workEma[r][instanceNo] = price;
   if (r>0 && period>1)
          workEma[r][instanceNo] = workEma[r-1][instanceNo]+(2.0/(1.0+period))*(price-workEma[r-1][instanceNo]);
   return(workEma[r][instanceNo]);
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSmma,0)!= _bars) ArrayResize(workSmma,_bars);

   workSmma[r][instanceNo] = price;
   if (r>1 && period>1)
          workSmma[r][instanceNo] = workSmma[r-1][instanceNo]+(price-workSmma[r-1][instanceNo])/period;
   return(workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int bars, int instanceNo=0)
{
   if (ArrayRange(workLwma,0)!= bars) ArrayResize(workLwma,bars);
   
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

//
//
//
//
//

double workTema[][_maWorkBufferx3];
#define _tema1 0
#define _tema2 1
#define _tema3 2

double iTema(double price, double period, int r, int bars, int instanceNo=0)
{
   if (ArrayRange(workTema,0)!= bars) ArrayResize(workTema,bars); instanceNo*=3;

   //
   //
   //
   //
   //
      
   workTema[r][_tema1+instanceNo] = price;
   workTema[r][_tema2+instanceNo] = price;
   workTema[r][_tema3+instanceNo] = price;
   if (r>0 && period>1)
   {
      double alpha = 2.0 / (1.0+period);
          workTema[r][_tema1+instanceNo] = workTema[r-1][_tema1+instanceNo]+alpha*(price                         -workTema[r-1][_tema1+instanceNo]);
          workTema[r][_tema2+instanceNo] = workTema[r-1][_tema2+instanceNo]+alpha*(workTema[r][_tema1+instanceNo]-workTema[r-1][_tema2+instanceNo]);
          workTema[r][_tema3+instanceNo] = workTema[r-1][_tema3+instanceNo]+alpha*(workTema[r][_tema2+instanceNo]-workTema[r-1][_tema3+instanceNo]); }
   return(workTema[r][_tema3+instanceNo]+3.0*(workTema[r][_tema1+instanceNo]-workTema[r][_tema2+instanceNo]));
}

//
//
//
//
//

double workLinr[][_maWorkBufferx1];
double iLinr(double price, int period, int r, int bars, int instanceNo=0)
{
   if (ArrayRange(workLinr,0)!= bars) ArrayResize(workLinr,bars);

   //
   //
   //
   //
   //
   
      period = MathMax(period,1);
      workLinr[r][instanceNo] = price;
      if (r<period) return(price);
         double lwmw = period; double lwma = lwmw*price;
         double sma  = price;
         for(int k=1; k<period && (r-k)>=0; k++)
         {
            double weight = period-k;
                   lwmw  += weight;
                   lwma  += weight*workLinr[r-k][instanceNo];  
                   sma   +=        workLinr[r-k][instanceNo];
         }             
   
   return(3.0*lwma/lwmw-2.0*sma/period);
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
                     haClose = (open[i]+close[i])/2.0+(((close[i]-open[i])/(high[i]-low[i]))*MathAbs((close[i]-open[i])/2.0));
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

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
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
   if (i>Bars-2) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (i>Bars-3) return;
   if (first[i+1] == EMPTY_VALUE)
         if (first[i+2] == EMPTY_VALUE) 
               { first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
         else  { second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else        { first[i]  = from[i];                          second[i] = EMPTY_VALUE; }
}

//+------------------------------------------------------------------+
//
//
//
//

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          //
          //
          //
          //
          //

          message =  StringConcatenate(ForSymbol," ",timeFrameToString(_Period)," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Price action ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsNotify)  SendNotification(message);
             if (alertsEmail)   SendMail(ForSymbol+" Price action ",message);
             if (alertsSound)   PlaySound(soundFile);
      }
}
