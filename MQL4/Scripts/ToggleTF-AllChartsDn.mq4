//+------------------------------------------------------------------+
//|                                           ToggleTF-AllCharts.mq4 |
//|                                      Copyright 2017, nicholishen |
//|                         https://www.forexfactory.com/nicholishen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, nicholishen"
#property link      "https://www.forexfactory.com/nicholishen"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   ENUM_TIMEFRAMES next = getNext(ChartPeriod());
   for(long ch=ChartFirst();ch>=0;ch=ChartNext(ch))
      if(ch!=ChartID())
         ChartSetSymbolPeriod(ch,ChartSymbol(ch),next);
 
   ChartSetSymbolPeriod(ChartID(),_Symbol,next);
}
//+------------------------------------------------------------------+

ENUM_TIMEFRAMES getNext(ENUM_TIMEFRAMES timeframe)
{
   ENUM_TIMEFRAMES tf[]={  
                           PERIOD_MN1,
                           PERIOD_W1,
                           PERIOD_D1,
                           PERIOD_H4,
                           PERIOD_H1,
                           PERIOD_M30,
                           PERIOD_M15,
                           PERIOD_M5,
                           PERIOD_M1
                        };
   int total = ArraySize(tf);
   for(int i=0;i<total;i++)
      if(timeframe==tf[i])
         if(i==total-1)
            return tf[0];
         else
            return tf[i+1];
   return PERIOD_CURRENT;
}
