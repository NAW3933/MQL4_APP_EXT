//+------------------------------------------------------------------+
//|                                   Detrended Price Oscillator.mq4 |
//|                                  Copyright © 2010, EarnForex.com |
//|                                        http://www.earnforex.com/ |
//+------------------------------------------------------------------+

/*
Detrended Price Oscillator tries to capture the short-term trend changes.
Indicator's cross with zero is the best indicator of such change.
*/

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Blue

extern int MA_Period = 14;
extern int BarsToCount = 400;

int Shift;

//---- buffers
double DPO[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorShortName("DPO(" + MA_Period + ")");
   IndicatorDigits(Digits);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, DPO);

   Shift = MA_Period / 2 + 1;

   return(0);
}

//+------------------------------------------------------------------+
//| Detrended Price Oscillator                                       |
//+------------------------------------------------------------------+
int start()
{
   // Too few bars to do anything
   if (Bars <= MA_Period) return(0);
   // If we don't have enough bars to count as specified in the input
   if (BarsToCount >= Bars) BarsToCount = Bars;
   
   SetIndexDrawBegin(0, Bars - BarsToCount + MA_Period + 1);
   
   int counted_bars = IndicatorCounted();

   // First MA_Period bars are set to 0 if we have to few bars to display
   if (counted_bars < MA_Period)
   {
      for(int i = 1; i <= MA_Period; i++)
         DPO[BarsToCount - i]=0.0;
   }
//----
   
   for (i = BarsToCount - MA_Period - 1; i >=0; i--)
   {
      DPO[i] = Close[i] - iMA(NULL, 0, MA_Period, Shift, MODE_SMA, PRICE_CLOSE, i);
   }

   return(0);
}
//+------------------------------------------------------------------+