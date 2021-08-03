//+------------------------------------------------------------------+
//|                                 Indicator: SIGNAL FROM ASHV1.mq4 |
//|                                       Created with EABuilder.com |
//|                                             http://eabuilder.com |
//+------------------------------------------------------------------+
#property copyright "Created with EABuilder.com"
#property link      "http://eabuilder.com"
#property version   "1.00"
#property description ""

#include <stdlib.mqh>
#include <stderror.mqh>

//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_type1 DRAW_ARROW
#property indicator_width1 4
#property indicator_color1 0xFFAA00
#property indicator_label1 "Buy"

#property indicator_type2 DRAW_ARROW
#property indicator_width2 4
#property indicator_color2 0x0000FF
#property indicator_label2 "Sell"

//--- indicator buffers
double Buffer1[];
double Buffer2[];

extern int RAVIPeriod1 = 7;
extern int RAVIPeriod2 = 65;
extern int MAperiod = 14;
double myPoint; //initialized in OnInit

void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
      Print(type+" | SIGNAL FROM ASHV1 @ "+Symbol()+","+Period()+" | "+message);
     }
   else if(type == "order")
     {
     }
   else if(type == "modify")
     {
     }
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {   
   IndicatorBuffers(2);
   SetIndexBuffer(0, Buffer1);
   SetIndexEmptyValue(0, 0);
   SetIndexArrow(0, 241);
   SetIndexBuffer(1, Buffer2);
   SetIndexEmptyValue(1, 0);
   SetIndexArrow(1, 242);
   //initialize myPoint
   myPoint = Point();
   if(Digits() == 5 || Digits() == 3)
     {
      myPoint *= 10;
     }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int limit = rates_total - prev_calculated;
   //--- counting from 0 to rates_total
   ArraySetAsSeries(Buffer1, true);
   ArraySetAsSeries(Buffer2, true);
   //--- initial zero
   if(prev_calculated < 1)
     {
      ArrayInitialize(Buffer1, 0);
      ArrayInitialize(Buffer2, 0);
     }
   else
      limit++;
   
   //--- main loop
   for(int i = limit-1; i >= 0; i--)
     {
      if (i >= MathMin(5000-1, rates_total-1-50)) continue; //omit some old rates to prevent "Array out of range" or slow calculation   
      //Indicator Buffer 1
      if(iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 2, i) > iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 3, i)
      && iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 2, i+1) < iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 3, i+1) //ASH V1 crosses above ASH V1
      )
        {
         Buffer1[i] = Low[i]; //Set indicator value at Candlestick Low
        }
      else
        {
         Buffer1[i] = 0;
        }
      //Indicator Buffer 2
      if(iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 2, i) < iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 3, i)
      && iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 2, i+1) > iCustom(NULL, PERIOD_CURRENT, "ASH V1", 0, 9, 1, 4, 0, 3, 3, 3, i+1) //ASH V1 crosses below ASH V1
      )
        {
         Buffer2[i] = High[i]; //Set indicator value at Candlestick High
        }
      else
        {
         Buffer2[i] = 0;
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+