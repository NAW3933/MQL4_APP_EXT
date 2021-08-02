//+------------------------------------------------------------------+
//|                                                       BS_RSI.mq4 |
//|                                        Copyright © 2008, masemus |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, masemus"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_minimum -0.33
#property indicator_maximum 1.33
#property indicator_buffers 2
#property indicator_color1 SlateGray
#property indicator_color2 Red

//---- input parameters
extern int TF=0;
extern int PeriodRSI=5;
//---- indicator buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
string TimeFrameStr;

//+------------------------------------------------------------------
//| Custom indicator initialization function                         
//+------------------------------------------------------------------

int init()
  {
//---- indicators
  SetIndexStyle(0,DRAW_LINE);
  SetIndexBuffer(0,ExtMapBuffer1);
  SetIndexStyle(1,DRAW_SECTION);
  SetIndexBuffer(1,ExtMapBuffer2);

switch(TF)
   {
      case 1 : TimeFrameStr="Period_M1"; break;
      case 5 : TimeFrameStr="Period_M5"; break;
      case 15 : TimeFrameStr="Period_M15"; break;
      case 30 : TimeFrameStr="Period_M30"; break;
      case 60 : TimeFrameStr="Period_H1"; break;
      case 240 : TimeFrameStr="Period_H4"; break;
      case 1440 : TimeFrameStr="Period_D1"; break;
      case 10080 : TimeFrameStr="Period_W1"; break;
      case 43200 : TimeFrameStr="Period_MN1"; break;
      default : TimeFrameStr="Current Timeframe"; TF=0;
   }
   IndicatorShortName("BS_RSI ("+PeriodRSI+","+TimeFrameStr+")");  

 
//----
   return(0);
  }

//+------------------------------------------------------------------

//| RSIFilter_v1                                                     

//+------------------------------------------------------------------
int start()
  {
   int    counted_bars=IndicatorCounted();
//----

for (int i = 0; i < 1000; i++){
   ExtMapBuffer1[i]=0;
   ExtMapBuffer2[i]=0;

   double BS_RSI;
   
   BS_RSI=iRSI(NULL,TF,PeriodRSI,PRICE_CLOSE,i);
   	
	  if (BS_RSI>50)ExtMapBuffer2[i]=1;
	  if (BS_RSI<50)ExtMapBuffer1[i]=1;
	  
	}
	return(0);	
 }




//+------------------------------------------------------------------+