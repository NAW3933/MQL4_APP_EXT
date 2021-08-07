//+------------------------------------------------------------------+
//|                                                       ATR-BB.mq4 |
//|                                    Copyright © 2007, MQL Service |
//|                                       http://www.mqlservice.com/ |
//+------------------------------------------------------------------+
//| $Id: //mqlservice/mt4files/experts/indicators/ATR-MQLS.mq4#1 $
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MQL Service"
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
//---- input parameters
extern int AtrPeriod=14;
extern bool ShowBull = true;
extern bool ShowBear = true;
//---- buffers
double AtrBullBuffer[];
double AtrBearBuffer[];
double TempBufferBull[];
double TempBufferBear[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 1 additional buffer used for counting.
   IndicatorBuffers(4);
//---- indicator line
   if(ShowBull)
     SetIndexStyle(0,DRAW_LINE);
   else
     SetIndexStyle(0,DRAW_NONE);
   if(ShowBear)
     SetIndexStyle(1,DRAW_LINE);
   else
     SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(0,AtrBullBuffer);
   SetIndexBuffer(1,AtrBearBuffer);
   SetIndexBuffer(2,TempBufferBull);
   SetIndexBuffer(3,TempBufferBear);
//---- name for DataWindow and indicator subwindow label
   short_name=WindowExpertName()+"("+AtrPeriod+","+ShowBear+","+ShowBull+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name+" Bull");
   SetIndexLabel(1,short_name+" Bear");
//----
   SetIndexDrawBegin(0,AtrPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=AtrPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
   {
      for(i=1;i<=AtrPeriod;i++) AtrBullBuffer[Bars-i]=0.0;
      for(i=1;i<=AtrPeriod;i++) AtrBearBuffer[Bars-i]=0.0;
   }
//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      double high=High[i];
      double low =Low[i];
      double open=Open[i];
      if(i==Bars-1)
      {
        TempBufferBull[i]=high-open;
        TempBufferBear[i]=open-low;
      }
      else
        {
         double prevclose=Close[i+1];
         TempBufferBull[i]=MathMax(high,prevclose)-MathMin(open,prevclose);
         TempBufferBear[i]=MathMax(open,prevclose)-MathMin(low,prevclose);
        }
      i--;
     }
//----
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++)
   {
      AtrBullBuffer[i]=iMAOnArray(TempBufferBull,Bars,AtrPeriod,0,MODE_SMA,i);
      AtrBearBuffer[i]=iMAOnArray(TempBufferBear,Bars,AtrPeriod,0,MODE_SMA,i);
   }
//----
   return(0);
  }
//+--------- Coded by Michal Rutka @ MQL Service.com ----------------+