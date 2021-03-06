//+------------------------------------------------------------------+
//|                                              #MTF_Supertrend.mq4 |
//|                      Copyright © 2017, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "MTF SuperTrend | Copyright © 2017"
#property link      "http://fxprosystems.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Lime
#property indicator_color2 Magenta

//---- input parameters
/*************************************************************************
PERIOD_M1   1
PERIOD_M5   5
PERIOD_M15  15
PERIOD_M30  30 
PERIOD_H1   60
PERIOD_H4   240
PERIOD_D1   1440
PERIOD_W1   10080
PERIOD_MN1  43200
You must use the numeric value of the timeframe that you want to use
when you set the TimeFrame' value with the indicator inputs.
---------------------------------------
PRICE_CLOSE    0 Close price. 
PRICE_OPEN     1 Open price. 
PRICE_HIGH     2 High price. 
PRICE_LOW      3 Low price. 
PRICE_MEDIAN   4 Median price, (high+low)/2. 
PRICE_TYPICAL  5 Typical price, (high+low+close)/3. 
PRICE_WEIGHTED 6 Weighted close price, (high+low+close+close)/4. 
You must use the numeric value of the Applied Price that you want to use
when you set the 'applied_price' value with the indicator inputs.
**************************************************************************/

extern int TimeFrame=0;
double TrendUp[];
double TrendDown[];
int st = 0;
//extern int SlowerEMA = 6;

double ExtMapBuffer1[];
double ExtMapBuffer2[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   SetIndexStyle(0, DRAW_LINE, 1,3);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1, DRAW_LINE, 1,3);
   SetIndexBuffer(1, ExtMapBuffer2);
   
   /*SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 159);
   SetIndexBuffer(0, TrendUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 159);
   SetIndexBuffer(1, TrendDown);*/
   
   /*for(int i = 0; i < Bars; i++) {
      TrendUp[i] = NULL;
      TrendDown[i] = NULL;
   }*/
   //---- name for DataWindow and indicator subwindow label   
   switch(TimeFrame)
   {
      case 1 : string TimeFrameStr="Period_M1"; break;
      case 5 : TimeFrameStr="Period_M5"; break;
      case 15 : TimeFrameStr="Period_M15"; break;
      case 30 : TimeFrameStr="Period_M30"; break;
      case 60 : TimeFrameStr="Period_H1"; break;
      case 240 : TimeFrameStr="Period_H4"; break;
      case 1440 : TimeFrameStr="Period_D1"; break;
      case 10080 : TimeFrameStr="Period_W1"; break;
      case 43200 : TimeFrameStr="Period_MN1"; break;
      default : TimeFrameStr="Current Timeframe";
   }
   IndicatorShortName("Supertrend("+st+") ("+TimeFrameStr+")");

return(0);

  }
   
  
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   /*for(int i = 0; i < Bars; i++) {
      TrendUp[i] = NULL;
      TrendDown[i] = NULL;
   }*/
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   datetime TimeArray[];
   int    i,shift,limit,y=0,counted_bars=IndicatorCounted();
    
// Plot defined timeframe on to current timeframe   
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame); 
   
   limit=Bars-counted_bars;
   for(i=0,y=0;i<limit;i++)
   {
   if (Time[i]<TimeArray[y]) y++; 
   
 /***********************************************************   
   Add your main indicator loop below.  You can reference an existing
      indicator with its iName  or iCustom.
   Rule 1:  Add extern inputs above for all neccesary values   
   Rule 2:  Use 'TimeFrame' for the indicator timeframe
   Rule 3:  Use 'y' for the indicator's shift value
 **********************************************************/  
 
 ExtMapBuffer1[i]=iCustom(NULL,TimeFrame,"Supertrend",0,y);
 ExtMapBuffer2[i]=iCustom(NULL,TimeFrame,"Supertrend",1,y);
  } 
//----
   return(0);
  }
//+------------------------------------------------------------------+