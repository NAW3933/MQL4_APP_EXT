//+------------------------------------------------------------------+
//|                                                ZoomAllCharts.mq4 |
//|                                                      nicholishen |
//|                                   www.reddit.com/u/nicholishenFX |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "www.reddit.com/u/nicholishenFX"
#property version   "1.00"
#property strict
#property script_show_inputs
#include <stdlib.mqh>

input string symbol = "EURUSD";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
//---
   long id=ChartNext(0);
   while(id>=0)
   {
      int period = ChartPeriod(id);
      if(!ChartSetSymbolPeriod(id,symbol,period))
         Print(__FUNCTION__+" ChartSetError ",ErrorDescription(GetLastError()));
      else
         ChartRedraw(id);
      id = ChartNext(id);
   }
}
//+------------------------------------------------------------------+
