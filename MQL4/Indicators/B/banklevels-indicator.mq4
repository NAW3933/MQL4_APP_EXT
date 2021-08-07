//+------------------------------------------------------------------+
//|                                                 m-BankLevels.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window
input int         StartHour            = 2;
input int         Days_Ago             = 20;
input color       ColorCurrentDay      = Green;
input color       ColorNextDay         = Lime;
input int         LineWidth            = 3;

string MyName = "BankLevel_";
datetime LastTime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   DelMyObj(MyName);
//---
   return(INIT_SUCCEEDED);
  }
int deinit()
{
   DelMyObj(MyName);
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   int i,nBar;
   datetime t1,t2, timeCurrDay;
   double price;
   string levelName;
   nBar = iBarShift(NULL,0,TimeCurrent()-Days_Ago*24*60*60);
   
   if(nBar >Bars-1) nBar = Bars-1;
   for(i=nBar; i>=0; i--)
   {
       if(TimeHour(Time[i]) == StartHour  && TimeHour(Time[i+1]) == StartHour-1)
       {
         t1 = Time[i];
         t2 = t1 + 24*60*60;
         price = Open[i];
         levelName = MyName + "CurrDay_" + TimeToString(t1, TIME_DATE|TIME_MINUTES);
         ObjectCreate(0, levelName, OBJ_TREND, 0, t1, price, t2, price);
         ObjectSetInteger(0,levelName, OBJPROP_RAY, false);
         ObjectSetInteger(0,levelName, OBJPROP_COLOR, ColorCurrentDay);
         ObjectSetInteger(0,levelName, OBJPROP_WIDTH, LineWidth);
         ObjectSetInteger(0,levelName, OBJPROP_SELECTABLE, false);
         timeCurrDay = t1-StartHour*3600;
         t1 = timeCurrDay + 24*3600;
         if(TimeDayOfWeek(Time[i]) == 5)
         t1 = timeCurrDay + 72*3600;
         t2 = t1 + 24*3600;
         price = Open[i];
         levelName = MyName + "NextDay_" + TimeToString(t1, TIME_DATE|TIME_MINUTES);
         ObjectCreate(0, levelName, OBJ_TREND, 0, t1, price, t2, price);
         ObjectSetInteger(0,levelName, OBJPROP_RAY, false);
         ObjectSetInteger(0,levelName, OBJPROP_COLOR, ColorNextDay);
         ObjectSetInteger(0,levelName, OBJPROP_WIDTH, LineWidth);
         ObjectSetInteger(0,levelName, OBJPROP_SELECTABLE, false);
         
         
       }
   }
   
   return(rates_total);
}
//====================================================================
//       IsNewBar
//====================================================================
bool IsNewBar()
{
   if(Time[0] != LastTime)
   {
         LastTime = Time[0];
         return(true);
   }
   else
         return(false);
}
//====================================================================
//   ‘ункци€ удал€ет объекты, созданные в этом индюке
//   аргумент- начало имени
//====================================================================
void DelMyObj(string myName)
{
int pos=-1;
string objName;
int    obj_total=ObjectsTotal();
         
      for(int i=obj_total-1;i>=0; i--)
      {
         objName = ObjectName(i);
         pos = StringFind(objName, myName, 0);
         if(pos!=-1) 
         {
            //Print("  ”дал€ю ", objName);
            ObjectDelete(objName);
         }
      }
return;
}
