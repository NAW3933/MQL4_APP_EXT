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
#property indicator_buffers  5
#property indicator_color1   Goldenrod
#property indicator_color2   Gold
#property indicator_color3   LimeGreen
#property indicator_color4   Red
#property indicator_color5   Red
#property indicator_width3   2
#property indicator_width4   2
#property indicator_width5   2
#property indicator_style1   STYLE_DOT
#property indicator_style2   STYLE_DOT

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
double sumVqida[];
double sumVqidb[];
double sumVqi1[];
double sumVqi2[];
double Vqi[];
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
      SetIndexBuffer(0,sumVqi1); 
      SetIndexBuffer(1,sumVqi2); 
      SetIndexBuffer(2,sumVqi); 
      SetIndexBuffer(3,sumVqida); 
      SetIndexBuffer(4,sumVqidb); 
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
            
  if (trend[limit] == -1) CleanPoint(limit,sumVqida,sumVqidb);
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
         sumVqida[i] = EMPTY_VALUE;
         sumVqidb[i] = EMPTY_VALUE;
            if (FilterInPips > 0) if (MathAbs(sumVqi[i]-sumVqi[i+1]) < FilterInPips*pipMultiplier*Point) sumVqi[i] = sumVqi[i+1];
      
      //
      //
      //
      //
      //
      
      trend[i] = trend[i+1];
         if (sumVqi[i] > sumVqi[i+1]) trend[i] =  1;
         if (sumVqi[i] < sumVqi[i+1]) trend[i] = -1;
         if (trend[i] == -1) PlotPoint(i,sumVqida,sumVqidb,sumVqi);
   }
   for(i=limit; i>=0; i--)
   {
      if (MA1Period > 1) sumVqi1[i] = iMAOnArray(sumVqi,0,MA1Period,0,MA1Method,i);
      if (MA2Period > 1) sumVqi2[i] = iMAOnArray(sumVqi,0,MA2Period,0,MA2Method,i);
   }      
   manageAlerts();
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
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}
void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
         if (first[i+2] == EMPTY_VALUE) 
               {  first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
         else  {  second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else        {  first[i]  = from[i];                          second[i] = EMPTY_VALUE; }
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