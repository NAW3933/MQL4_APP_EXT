//+------------------------------------------------------------------+
//|                                                     MA_Shade.mq4 |
//|                                                           oromek |
//|                                                oromeks@gmail.com |
//+------------------------------------------------------------------+
#property copyright "oromek"
#property link      "oromeks@gmail.com"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

extern int MA1_Period=21;
extern int MA2_Period=50;

double MA1, MA2;
double MA1_Buffer[], MA2_Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(0,MA1_Buffer);
   
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(1,MA2_Buffer);
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   
   for(int i=1; i<limit; i++)
   {
      MA1=iMA(NULL,0,MA1_Period,0,MODE_SMA,PRICE_CLOSE,i);
      MA2=iMA(NULL,0,MA2_Period,0,MODE_SMA,PRICE_CLOSE,i);
   
      MA1_Buffer[i]=MA1;
      MA2_Buffer[i]=MA2;
   }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+