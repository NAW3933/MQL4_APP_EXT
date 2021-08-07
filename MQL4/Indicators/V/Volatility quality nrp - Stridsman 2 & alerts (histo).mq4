//+------------------------------------------------------------------+
//|                                           Volatility quality.mq4 |
//|                                                                  |
//|                                                                  |
//| Volatility quality index originaly developed by                  |
//| Thomas Stridsman (August 2002 Active Trader Magazine)            |
//|                                                                  |
//| Price pre-smoothing and filter added by raff1410                 |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_separate_window
#property indicator_buffers  2
#property indicator_color1   clrLimeGreen
#property indicator_color2   clrRed
#property indicator_width1   2
#property indicator_width2   2
#property indicator_minimum  0
#property indicator_maximum  1

//
//
//
//
//

extern int            PriceSmoothing         = 5;
extern ENUM_MA_METHOD PriceSmoothingMethod   = MODE_LWMA;
extern int            MA1Period              = 9;
extern ENUM_MA_METHOD MA1Method              = MODE_SMA;
extern int            MA2Period              = 200;
extern ENUM_MA_METHOD MA2Method              = MODE_SMA;
extern double         FilterInPips           = 2.0;
extern bool           alertsOn               = true;
extern bool           alertsOnCurrent        = false;
extern bool           alertsMessage          = true;
extern bool           alertsSound            = false;
extern bool           alertsEmail            = false;
extern bool           alertsPushNotification = false;
extern string         soundfile              = "alert2.wav"; 

//
//
//
//
//

double sumVqi[];
double sumVqi1[];
double sumVqi2[];
double Vqi[];
double histu[],histd[];
double trend[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   IndicatorBuffers(7);
      SetIndexBuffer(0,histu); SetIndexStyle(0,DRAW_HISTOGRAM);
      SetIndexBuffer(1,histd); SetIndexStyle(1,DRAW_HISTOGRAM);
      SetIndexBuffer(2,sumVqi1); 
      SetIndexBuffer(3,sumVqi2); 
      SetIndexBuffer(4,sumVqi); 
      SetIndexBuffer(5,Vqi); 
      SetIndexBuffer(6,trend);
      PriceSmoothing=MathMax(PriceSmoothing,1);
   return(0);
}
int deinit() { return(0); }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
         double pipMultiplier = MathPow(10,_Digits%2);
         
   //
   //
   //
   //
   //
            
  for(int i=limit; i>=0; i--)
   {
      if (i==(Bars-1))
      {
         Vqi[i]    = 0;
         sumVqi[i] = 0;
         continue;
      }
      
      //
      //
      //
      //
      //
      
         double cHigh  = iMA(NULL,0,PriceSmoothing,0,PriceSmoothingMethod,PRICE_HIGH ,i);
         double cLow   = iMA(NULL,0,PriceSmoothing,0,PriceSmoothingMethod,PRICE_LOW  ,i);
         double cOpen  = iMA(NULL,0,PriceSmoothing,0,PriceSmoothingMethod,PRICE_OPEN ,i);
         double cClose = iMA(NULL,0,PriceSmoothing,0,PriceSmoothingMethod,PRICE_CLOSE,i);
         double pClose = iMA(NULL,0,PriceSmoothing,0,PriceSmoothingMethod,PRICE_CLOSE,i+1);
         
         double trueRange = MathMax(cHigh,pClose)-MathMin(cLow,pClose);
         double     range = cHigh-cLow;
      
            if (range != 0 && trueRange!=0)
               double vqi = ((cClose-pClose)/trueRange + (cClose-cOpen)/range)*0.5;
            else      vqi = Vqi[i+1];

      //
      //
      //
      //
      //
         
         Vqi[i]      = MathAbs(vqi)*(cClose-pClose+cClose-cOpen)*0.5;
         sumVqi[i]   = sumVqi[i+1]+Vqi[i];
            if (FilterInPips > 0) if (MathAbs(sumVqi[i]-sumVqi[i+1]) < FilterInPips*pipMultiplier*Point) sumVqi[i] = sumVqi[i+1];
      
      //
      //
      //
      //
      //
      
      trend[i] = trend[i+1];
      histu[i] = EMPTY_VALUE;
      histd[i] = EMPTY_VALUE;
         if (sumVqi[i] > sumVqi[i+1]) trend[i] =  1;
         if (sumVqi[i] < sumVqi[i+1]) trend[i] = -1;
         if (trend[i]== 1) histu[i] = 1;
         if (trend[i]==-1) histd[i] = 1;
   }
   for(i=limit; i>=0; i--)
   {
      if (MA1Period > 1) sumVqi1[i] = iMAOnArray(sumVqi,0,MA1Period,0,MA1Method,i);
      if (MA2Period > 1) sumVqi2[i] = iMAOnArray(sumVqi,0,MA2Period,0,MA2Method,i);
   }      
   manageAlerts();
   return(0);
}
//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------
//
//
//
//
//

void manageAlerts()
{
   if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1;
      if (trend[whichBar] != trend[whichBar+1])
      {
         if (trend[whichBar] == 1) doAlert(whichBar,"up");
         if (trend[whichBar] ==-1) doAlert(whichBar,"down");
      }         
   }
}   

//
//
//
//
//

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

       message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," - volatility quality Stridsman trend changed to ",doWhat);
          if (alertsMessage) Alert(message);
          if (alertsEmail)   SendMail(StringConcatenate(Symbol()," volatility quality Stridsman "),message);
          if (alertsPushNotification)  SendNotification(message);
          if (alertsSound)   PlaySound("alert2.wav");
   }
}