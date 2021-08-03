//+------------------------------------------------------------------+
//|                                              smWriteRestTime.mq4 |
//|                                 Copyright © 2009.04.11, SwingMan |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009.04.11, SwingMan"
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
string sText; 
string sNameRT = "TimeSI_";
   color dColor = DeepSkyBlue;
   int xx = 5;
   int yy = 1;
   
   //---- Spread
   double dSpread = MarketInfo(Symbol(),MODE_SPREAD);
   string sSpread = "  Spread=" + DoubleToStr(dSpread,0);
   //---- TickValue
   //double dTickValue = 1.0 / MarketInfo(Symbol(),MODE_TICKVALUE);
   double dTickValue = MarketInfo(Symbol(),MODE_TICKVALUE);
   string sTickValue = "  TickVal=" + DoubleToStr(dTickValue,2);
   //---- Point
   double dPoint=Point*MathPow(10,Digits%2);
   string sPoint = "  Point= " + DoubleToStr(dPoint,Digits-1);
   //---- TickSize
   //double dTickSize = MarketInfo(Symbol(),MODE_TICKSIZE);
   //string sTickSize = "  TickSize=" + DoubleToStr(dTickSize,8);
   
   datetime currentBarTime = iTime(Symbol(), Period(), 0);   
   int iRestTime = Period()*60  - (TimeCurrent()-currentBarTime);
   
   if (iRestTime > 0) {
      string sRestTime = TimeToStr(iRestTime,TIME_MINUTES|TIME_SECONDS);   
      //string sText = windowsName;
      sText = sText + "( " + sRestTime + " )" + sSpread + sTickValue + sPoint;
      ObjectCreate(sNameRT, OBJ_LABEL, 0, 0, 0);
        ObjectSetText(sNameRT,sText,8, "Arial Bold", dColor);
        ObjectSet(sNameRT, OBJPROP_CORNER, 2);
        ObjectSet(sNameRT, OBJPROP_XDISTANCE, xx);
        ObjectSet(sNameRT, OBJPROP_YDISTANCE, yy);   
   }        
//----
   return(0);
}
//+------------------------------------------------------------------+