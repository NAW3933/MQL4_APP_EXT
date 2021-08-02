//+------------------------------------------------------------------+
//|                                                     SSL fast.mq4 |
//|                                                           mladen |
//|                                                                  |
//| initial SSL for metatrader developed by Kalenzo                  |
//+------------------------------------------------------------------+
#property copyright "www.forex-tsd.com"
#property link      "www.forex-tsd.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1  CornflowerBlue
#property indicator_width1  2
#property indicator_color2  Red
#property indicator_width2  2
#property indicator_color3  Red
#property indicator_width3  2

//
//
//
//
//

extern int    Lb              = 10;

extern string note            = "turn on Alert = true; turn off = false";
extern bool   alertsOn        = true;
extern bool   alertsOnCurrent = true;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = true;
extern bool   alertsEmail     = false;
extern string soundfile       = "alert2.wav";

//
//
//
//
//

double ssl[];
double sslda[];
double ssldb[];
double Hlv[];
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
   IndicatorBuffers(5);
   SetIndexBuffer(0,ssl); SetIndexDrawBegin(0,Lb+1);
   SetIndexBuffer(1,sslda);
   SetIndexBuffer(2,ssldb);
   SetIndexBuffer(3,Hlv);
   SetIndexBuffer(4,trend);
   return(0);
}

//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit = MathMin(Bars-counted_bars,Bars-1);
   

   //
   //
   //
   //
   //
   
   if (Hlv[limit] == -1) ClearPoint(limit,sslda,ssldb);

   //
   //
   //
   //
   //

   for(i=limit;i>=0;i--)
   {
      Hlv[i] = Hlv[i+1];
         if(Close[i]>iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_HIGH,i+1)) Hlv[i] =  1;
         if(Close[i]<iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_LOW,i+1))  Hlv[i] = -1;
      
         if(Hlv[i] == -1)
               ssl[i] = iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_HIGH,i+1);
         else  ssl[i] = iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_LOW,i+1);
         
         if (Hlv[i] == -1) PlotPoint(i,sslda,ssldb,ssl);
   }

   //
   //
   //
   //
   //
   
   if (alertsOn)
      {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1;

         //
         //
         //
         //
         //
         
         if (Hlv[whichBar] != Hlv[whichBar+1])
         if (Hlv[whichBar] == 1)
               doAlert("uptrend");
         else  doAlert("downtrend");       
   }
   
   return(0);
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

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," ssl cross ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," ssl cross "),message);
             if (alertsSound)   PlaySound(soundfile);
      }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

void ClearPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

//
//
//
//
//

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
      {
      if (first[i+2] == EMPTY_VALUE) {
          first[i]    = from[i];
          first[i+1]  = from[i+1];
          second[i]   = EMPTY_VALUE;
         }
      else {
          second[i]   = from[i];
          second[i+1] = from[i+1];
          first[i]    = EMPTY_VALUE;
         }
      }
   else
      {
         first[i]   = from[i];
         second[i]  = EMPTY_VALUE;
      }
}

//
//
//
//
//



