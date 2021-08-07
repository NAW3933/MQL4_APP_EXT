//+------------------------------------------------------------------+
//|                                             Spread Indikator.mq4 |
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern color LabelColor = Black;
extern string Font_style = "FixedSys";
extern int corner = 0;
extern int X_distance = 3;
extern int Y_distance = 12;

#define OBJ_NAME "SpreadIndikatorObj"

int init()
{
   ShowSpread();
}

int start()
{
   ShowSpread();
}

int deinit()
{
   ObjectDelete(OBJ_NAME);
}

void ShowSpread()
{
   static double spread;
   
   spread = MarketInfo(Symbol(), MODE_SPREAD)/10 ;
   
   DrawSpreadOnChart(spread);
}

void DrawSpreadOnChart(double spread)
{
   string s = "Spread: "+DoubleToStr(spread, 1)+" pips";
   
   if(ObjectFind(OBJ_NAME) < 0)
   {
      ObjectCreate(OBJ_NAME, OBJ_LABEL, 0, 0, 0);
      ObjectSet(OBJ_NAME, OBJPROP_CORNER, corner);
      ObjectSet(OBJ_NAME, OBJPROP_YDISTANCE, Y_distance);
      ObjectSet(OBJ_NAME, OBJPROP_XDISTANCE, X_distance);
      ObjectSetText(OBJ_NAME, s, 12, Font_style, LabelColor);
   }
   
   ObjectSetText(OBJ_NAME, s);
   
   WindowRedraw();
}