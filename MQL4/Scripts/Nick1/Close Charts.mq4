//+------------------------------------------------------------------+
//|                                                 Close Charts.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
void OnStart()
{
   for(long ch=ChartFirst();ch >= 0;ch=ChartNext(ch))
      if(ch!=ChartID())
         ChartClose(ch);
   ChartClose(ChartID());
}
//+------------------------------------------------------------------+