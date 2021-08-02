//+------------------------------------------------------------------+
//|                                                  Igel-Spread.mq4 |
//|                                Copyright © 2008, Daniel Frieling |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Daniel Frieling"
#property link      ""

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
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
   int spread = MarketInfo(Symbol(), MODE_SPREAD);
   Comment("Current spread: ",spread);
      
   return(0);
}
//+------------------------------------------------------------------+