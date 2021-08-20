//+------------------------------------------------------------------+
//|                                              precision trend.mq4 |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_chart_window
#property indicator_buffers  7
#property indicator_color1   clrDimGray
#property indicator_color2   clrLime
#property indicator_color3   clrLime
#property indicator_color4   clrRed
#property indicator_color5   clrRed
#property indicator_width1   3
#property indicator_width2   3
#property indicator_width3   3
#property indicator_width4   3
#property indicator_width5   3
#property strict

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
   pr_hatbiased2  // Heiken ashi trend biased (extreme) price
};
enum enColorOn
{
   cc_onApSlope,     // Change color on average slope and precision trend change
   cc_onAvTrend,     // Change color on average slope change  
   cc_onPrTrend      // Change color on precision trend
};

extern ENUM_TIMEFRAMES TimeFrame = PERIOD_CURRENT;   // Time frame
extern int       avgPeriod       = 30;            // Precison trend "period"
extern double    sensitivity     = 2;             // Precison trend sensitivity
enum  enMaTypes
      {
         ma_sma,                                  // Simple moving average
         ma_ema,                                  // Exponential moving average
         ma_smma,                                 // Smoothed MA
         ma_lwma,                                 // Linear weighted MA
         ma_slwma,                                // Smoothed LWMA
         ma_dsema,                                // Double Smoothed Exponential average
         ma_tema,                                 // Triple exponential moving average - TEMA
         ma_lsma                                  // Linear regression value (lsma)
      };
extern enMaTypes avgMaMethod     = ma_tema;       // Average method
extern int       avgMaPeriod     = 14;            // Average period
extern enPrices  avgMaPrice      = pr_hatbiased2; // Price for average
extern enColorOn colorOn         = cc_onApSlope;  // Color change on:
extern bool      arrowsVisible   = true;          // Arrows visible?
extern color     arrowsUpColor   = clrLime;       // Up arrow color
extern color     arrowsDnColor   = clrRed;        // Down arrow color
extern int       arrowsUpCode    = 233;           // Up arrow code
extern int       arrowsDnCode    = 234;           // Down arrow code
extern int       arrowsSize      = 0;             // Arrows size
extern double    arrowsGapUp     = 0.75;          // Gap for arrow up        
extern double    arrowsGapDn     = 0.75;          // Gap for arrow down
input bool       ArrowOnFirst    = true;          // Arrow on first mtf bar
extern bool      alertsOn        = false;         // Turn alerts on?
extern bool      alertsOnCurrent = false;         // Alerts on current (still opened) bar?
extern bool      alertsMessage   = true;          // Alerts should show pop-up message?
extern bool      alertsSound     = false;         // Alerts should play alert sound?
extern bool      alertsPushNotif = false;         // Alerts should send push notification?
extern bool      alertsEmail     = false;         // Alerts should send email?
input bool       Interpolate     = true;          // Interpolate in multi time frame mode?

double val[],valua[],valub[],valda[],valdb[],levelu[],leveld[],trend[],ptrend[],vtrend[],upa[],dna[],count[];
string indicatorFileName;
#define _mtfCall(_buff,_ind) iCustom(NULL,TimeFrame,indicatorFileName,0,avgPeriod,sensitivity,avgMaMethod,avgMaPeriod,avgMaPrice,colorOn,arrowsVisible,arrowsUpColor,arrowsDnColor,arrowsUpCode,arrowsDnCode,arrowsSize,arrowsGapUp,arrowsGapDn,ArrowOnFirst,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsPushNotif,alertsEmail,_buff,_ind)

//------------------------------------------------------------------
//
//------------------------------------------------------------------

int OnInit()
{
   IndicatorBuffers(11);
   SetIndexBuffer( 0, val,  INDICATOR_DATA); SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer( 1, valua,INDICATOR_DATA); SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer( 2, valub,INDICATOR_DATA); SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer( 3, valda,INDICATOR_DATA); SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer( 4, valdb,INDICATOR_DATA); SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer( 5, upa,  INDICATOR_DATA); SetIndexStyle(5,!arrowsVisible ? DRAW_NONE : DRAW_ARROW,EMPTY,arrowsSize,arrowsUpColor); SetIndexArrow(5,arrowsUpCode);
   SetIndexBuffer( 6, dna,  INDICATOR_DATA); SetIndexStyle(6,!arrowsVisible ? DRAW_NONE : DRAW_ARROW,EMPTY,arrowsSize,arrowsDnColor); SetIndexArrow(6,arrowsDnCode);       
   SetIndexBuffer( 7, trend);
   SetIndexBuffer( 8, ptrend);
   SetIndexBuffer( 9, vtrend);
   SetIndexBuffer(10, count);
   
   indicatorFileName = WindowExpertName();
   TimeFrame         = fmax(TimeFrame,_Period);
   
return(INIT_SUCCEEDED);
}
void OnDeinit(const int reason) { return; }

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
                 const int&      spread[] )
{
   int i,limit=fmin(rates_total-prev_calculated+1,rates_total-1); count[0]=limit;
      if (TimeFrame != _Period)
      {
         limit = (int)fmax(limit,fmin(rates_total-1,_mtfCall(10,0)*TimeFrame/_Period));
         if (trend[limit]== 1) CleanPoint(limit,rates_total,valua,valub);
         if (trend[limit]==-1) CleanPoint(limit,rates_total,valda,valdb);      
         for (i=limit;i>=0 && !_StopFlag; i--)
         {
             int y = iBarShift(NULL,TimeFrame,Time[i]);
             int x = y;
             if (ArrowOnFirst)
                   {  if (i<rates_total-1) x = iBarShift(NULL,TimeFrame,time[i+1]);               }
             else  {  if (i>0)             x = iBarShift(NULL,TimeFrame,time[i-1]); else x = -1;  }
                  val[i]   = _mtfCall(0,y);
   	            trend[i] = _mtfCall(7,y);
   	            valda[i] = valdb[i] = valua[i] = valub[i]  = EMPTY_VALUE;
                  upa[i]   = dna[i] = EMPTY_VALUE;
                  if (x!=y)
                  {
                    upa[i] = _mtfCall(5,y);
                    dna[i] = _mtfCall(6,y);
                  }
                     
                  //
                  //
                  //
                     
                  if (!Interpolate || (i>0 && y==iBarShift(NULL,TimeFrame,time[i-1]))) continue;
                  #define _interpolate(buff) buff[i+k] = buff[i]+(buff[i+n]-buff[i])*k/n
                  int n,k; datetime itime = iTime(NULL,TimeFrame,y);
                     for(n = 1; (i+n)<rates_total && time[i+n] >= itime; n++) continue;	
                     for(k = 1; k<n && (i+n)<rates_total && (i+k)<rates_total; k++) _interpolate(val);          
            }
            for (i=limit;i>=0 && !_StopFlag; i--)
            {
               if (trend[i]== 1) PlotPoint(i,rates_total,valua,valub,val);
               if (trend[i]==-1) PlotPoint(i,rates_total,valda,valdb,val); 
            }
   return(rates_total);
   }
     
   //
   //
   //
   
   if (trend[limit]== 1) CleanPoint(limit,rates_total,valua,valub);
   if (trend[limit]==-1) CleanPoint(limit,rates_total,valda,valdb);        
   for(i=limit; i>=0 && !_StopFlag; i--)
   {
      val[i]    = iCustomMa(avgMaMethod,getPrice(avgMaPrice,open,close,high,low,i,rates_total),avgMaPeriod,i,rates_total);
      ptrend[i] = iPrecisionTrend(high,low,close,avgPeriod,sensitivity,i,rates_total);
      vtrend[i] = (i<rates_total-1) ? (val[i]>val[i+1]) ? 1 : (val[i]<val[i+1]) ? -1 : vtrend[i+1] : 0;
          
      switch(colorOn)
      {
         case cc_onApSlope : trend[i] = (ptrend[i]==1 && vtrend[i]==1) ? 1 : (ptrend[i] ==-1 && vtrend[i]==-1) ? -1 :  0;    break;
         case cc_onAvTrend : trend[i] = (i<rates_total-1) ? (val[i]>val[i+1]) ? 1 : (val[i]<val[i+1]) ? -1 : trend[i+1] : 0; break;
         default :           trend[i] = ptrend[i]; 
      }
      valda[i] = valdb[i] = valua[i] = valub[i]  = EMPTY_VALUE;

         if (i<rates_total-1 && trend[i] != trend[i+1])
         {        
            upa[i] = (trend[i] == 1) ? (low[i]  - arrowsGapUp*iATR(NULL,0,20,i)) : EMPTY_VALUE;
            dna[i] = (trend[i] ==-1) ? (high[i] + arrowsGapDn*iATR(NULL,0,20,i)) : EMPTY_VALUE;
         }                
         if (trend[i]== 1) PlotPoint(i,rates_total,valua,valub,val);
         if (trend[i]==-1) PlotPoint(i,rates_total,valda,valdb,val);       
   }

   if (alertsOn)
   {
     int whichBar = 1; if (alertsOnCurrent) whichBar = 0;
     if (trend[whichBar] != trend[whichBar+1])
     {
        if (trend[whichBar] ==  1) doAlert(whichBar,"up");
        if (trend[whichBar] == -1) doAlert(whichBar,"down");
     }
   }        
return(rates_total);
}

//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}



//------------------------------------------------------------------
//
//------------------------------------------------------------------

void doAlert(int forBar, string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[forBar]) {
       previousAlert  = doWhat;
       previousTime   = Time[forBar];

       //
       //
       //
       //
       //

       message = timeFrameToString(_Period)+" "+_Symbol+" at "+TimeToStr(TimeLocal(),TIME_SECONDS)+" precision trend state changed to "+doWhat;
             if (alertsMessage)   Alert(message);
             if (alertsPushNotif) SendNotification(message);
             if (alertsEmail)     SendMail(_Symbol+" PRECISION TREND ",message);
             if (alertsSound)     PlaySound("alert2.wav");
   }
}

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------

void CleanPoint(int i,int bars,double& first[],double& second[])
{
   if (i>=bars-2) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,int bars,double& first[],double& second[],double& from[])
{
   if (i>=bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                          second[i] = EMPTY_VALUE; }
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------


#define _ptInstances     1
#define _ptInstancesSize 7
double  _ptWork[][_ptInstances*_ptInstancesSize];
#define __range 0
#define __trend 1
#define __avgr  2
#define __avgd  3
#define __avgu  4
#define __minc  5
#define __maxc  6
double iPrecisionTrend(const double& _high[], const double& _low[], const double& _close[], int _period, double _sensitivity, int i, int bars, int instanceNo=0)
{
   if (ArrayRange(_ptWork,0)!=bars) ArrayResize(_ptWork,bars); instanceNo*=_ptInstancesSize; int r=bars-i-1;
   
   //
   //
   //
   //
   //

   _ptWork[r][instanceNo+__range] = _high[i]-_low[i];
   _ptWork[r][instanceNo+__avgr]  = _ptWork[r][instanceNo+__range];
   int k=1; for (; k<_period && (r-k)>=0; k++) _ptWork[r][instanceNo+__avgr] += _ptWork[r-k][instanceNo+__range];
                                               _ptWork[r][instanceNo+__avgr] /= k;
                                               _ptWork[r][instanceNo+__avgr] *= _sensitivity;

      //
      //
      //
      //
      //
               
      if (i==(bars-1))
      {
         _ptWork[r][instanceNo+__trend] = 0;
         _ptWork[r][instanceNo+__avgd] = _close[i]-_ptWork[r][instanceNo+__avgr];
         _ptWork[r][instanceNo+__avgu] = _close[i]+_ptWork[r][instanceNo+__avgr];
         _ptWork[r][instanceNo+__minc] = _close[i];
         _ptWork[r][instanceNo+__maxc] = _close[i];
      }
      else
      {
         _ptWork[r][instanceNo+__trend] = _ptWork[r-1][instanceNo+__trend];
         _ptWork[r][instanceNo+__avgd]  = _ptWork[r-1][instanceNo+__avgd];
         _ptWork[r][instanceNo+__avgu]  = _ptWork[r-1][instanceNo+__avgu];
         _ptWork[r][instanceNo+__minc]  = _ptWork[r-1][instanceNo+__minc];
         _ptWork[r][instanceNo+__maxc]  = _ptWork[r-1][instanceNo+__maxc];
         
         //
         //
         //
         //
         //
         
            switch((int)_ptWork[r-1][instanceNo+__trend])
            {
               case 0 :
                     if (_close[i]>_ptWork[r-1][instanceNo+__avgu])
                     {
                        _ptWork[r][instanceNo+__minc]  = _close[i];
                        _ptWork[r][instanceNo+__avgd]  = _close[i]-_ptWork[r][instanceNo+__avgr];
                        _ptWork[r][instanceNo+__trend] =  1;
                     }
                     if (_close[i]<_ptWork[r-1][instanceNo+__avgd])
                     {
                        _ptWork[r][instanceNo+__maxc]  = _close[i];
                        _ptWork[r][instanceNo+__avgu]  = _close[i]+_ptWork[r][instanceNo+__avgr];
                        _ptWork[r][instanceNo+__trend] = -1;
                     }
                     break;
               case 1 :
                     _ptWork[r][instanceNo+__avgd] = _ptWork[r-1][instanceNo+__minc] - _ptWork[r][instanceNo+__avgr];
                        if (_close[i]>_ptWork[r-1][instanceNo+__minc]) _ptWork[r][instanceNo+__minc] = _close[i];
                        if (_close[i]<_ptWork[r-1][instanceNo+__avgd])
                        {
                           _ptWork[r][instanceNo+__maxc] = _close[i];
                           _ptWork[r][instanceNo+__avgu] = _close[i]+_ptWork[r][instanceNo+__avgr];
                           _ptWork[r][instanceNo+__trend] = -1;
                        }
                     break;                  
               case -1 :
                     _ptWork[r][instanceNo+__avgu] = _ptWork[r-1][instanceNo+__maxc] + _ptWork[r][instanceNo+__avgr];
                        if (_close[i]<_ptWork[r-1][instanceNo+__maxc]) _ptWork[r][instanceNo+__maxc] = _close[i];
                        if (_close[i]>_ptWork[r-1][instanceNo+__avgu])
                        {
                           _ptWork[r][instanceNo+__minc]  = _close[i];
                           _ptWork[r][instanceNo+__avgd]  = _close[i]-_ptWork[r][instanceNo+__avgr];
                           _ptWork[r][instanceNo+__trend] = 1;
                        }
            }
      }            
   return(_ptWork[r][instanceNo+__trend]);
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------

#define _maInstances 1
#define _maWorkBufferx1 1*_maInstances
#define _maWorkBufferx2 2*_maInstances
#define _maWorkBufferx3 3*_maInstances

double iCustomMa(int mode, double price, double length, int r, int bars, int instanceNo=0)
{
   r = bars-r-1;
   switch (mode)
   {
      case ma_sma   : return(iSma(price,(int)length,r,bars,instanceNo));
      case ma_ema   : return(iEma(price,length,r,bars,instanceNo));
      case ma_smma  : return(iSmma(price,(int)length,r,bars,instanceNo));
      case ma_lwma  : return(iLwma(price,(int)length,r,bars,instanceNo));
      case ma_slwma : return(iSlwma(price,(int)length,r,bars,instanceNo));
      case ma_dsema : return(iDsema(price,length,r,bars,instanceNo));
      case ma_tema  : return(iTema(price,(int)length,r,bars,instanceNo));
      case ma_lsma  : return(iLinr(price,(int)length,r,bars,instanceNo));
      default       : return(price);
   }
}

//
//
//

double workSma[][_maWorkBufferx1];
double iSma(double price, int period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSma,0)!= _bars) ArrayResize(workSma,_bars);

   workSma[r][instanceNo+0] = price;
   double avg = price; int k=1;  for(; k<period && (r-k)>=0; k++) avg += workSma[r-k][instanceNo+0];  
   return(avg/(double)k);
}

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

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workLwma,0)!= _bars) ArrayResize(workLwma,_bars);
   
   workLwma[r][instanceNo] = price; if (period<=1) return(price);
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


double workSlwma[][_maWorkBufferx2];
double iSlwma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSlwma,0)!= _bars) ArrayResize(workSlwma,_bars); 

   //
   //
   //

      int SqrtPeriod = (int)floor(sqrt(period)); instanceNo *= 2;
         workSlwma[r][instanceNo] = price;

         //
         //
         //
               
         double sumw = period;
         double sum  = period*price;
   
         for(int k=1; k<period && (r-k)>=0; k++)
         {
            double weight = period-k;
                   sumw  += weight;
                   sum   += weight*workSlwma[r-k][instanceNo];  
         }             
         workSlwma[r][instanceNo+1] = (sum/sumw);

         //
         //
         //
         
         sumw = SqrtPeriod;
         sum  = SqrtPeriod*workSlwma[r][instanceNo+1];
            for(int k=1; k<SqrtPeriod && (r-k)>=0; k++)
            {
               double weight = SqrtPeriod-k;
                      sumw += weight;
                      sum  += weight*workSlwma[r-k][instanceNo+1];  
            }
   return(sum/sumw);
}

//
//
//

double workDsema[][_maWorkBufferx2];
#define _ema1 0
#define _ema2 1

double iDsema(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workDsema,0)!= _bars) ArrayResize(workDsema,_bars); instanceNo*=2;

   //
   //
   //
   
   workDsema[r][_ema1+instanceNo] = price;
   workDsema[r][_ema2+instanceNo] = price;
   if (r>0 && period>1)
   {
      double alpha = 2.0 /(1.0+sqrt(period));
          workDsema[r][_ema1+instanceNo] = workDsema[r-1][_ema1+instanceNo]+alpha*(price                         -workDsema[r-1][_ema1+instanceNo]);
          workDsema[r][_ema2+instanceNo] = workDsema[r-1][_ema2+instanceNo]+alpha*(workDsema[r][_ema1+instanceNo]-workDsema[r-1][_ema2+instanceNo]); }
   return(workDsema[r][_ema2+instanceNo]);
}

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
            case pr_hatbiased2:
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