//+------------------------------------------------------------------+
//|                                                ZoomAllCharts.mq4 |
//|                                                      nicholishen |
//|                                   www.reddit.com/u/nicholishenFX |
//+------------------------------------------------------------------+
#property copyright "nicholishen"
#property link      "www.reddit.com/u/nicholishenFX"
#property version   "1.00"
#property strict
#include <stdlib.mqh>

#define GLOBALVAR "all_charts_scale_1"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
//---
   int scale = 3;
   double _scale;
   if(!GlobalVariableGet(GLOBALVAR,_scale))
   {
      GlobalVariableSet(GLOBALVAR,(double)scale);
   } 
   else
   {
      scale = (int)_scale;
      if(scale+1 > 5)
         scale = 0;
      else
         scale++;
   }
   int total = (int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);
   long id=ChartNext(0);
   while(id>=0)
   {
      if(!ChartSetInteger(id,CHART_SCALE,scale))
         Print(__FUNCTION__+" ChartSetError ",ErrorDescription(GetLastError()));
      else
         ChartRedraw(id);
      id = ChartNext(id);
   }
   GlobalVariableSet(GLOBALVAR,(double)scale);
}
//+------------------------------------------------------------------+
