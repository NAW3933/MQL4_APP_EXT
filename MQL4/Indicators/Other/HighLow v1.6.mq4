//+------------------------------------------------------------------+
//|                                                      HighLow.mq4 |
//|                                                         forexmts |
//|                                                 forexmts@mail.ru |
//+------------------------------------------------------------------+
//v1.4 - added quarterly and yearly lines

#define PERIOD_Q1 3*PERIOD_MN1
#define PERIOD_Y1 12*PERIOD_MN1

#property copyright "forexmts"
#property link      "forexmts@mail.ru"
#property strict
#property indicator_chart_window

input int iWeeks = 10;     //Number of weeks
input int iMonths = 10;    //Number of months
input int iQuarters = 10;  //Number of quarters
input int iYears = 10;     //Number of years
input color cWeeks = clrBlue;    //Weekly color
input color cMonths = clrRed;    //Monthly color
input color cQuarters = clrLime; //Quarterly color
input color cYears = clrGold;    //Yearly color
input ENUM_LINE_STYLE enStyle = STYLE_DASHDOT;  //Style
input ENUM_BASE_CORNER enCorner = CORNER_LEFT_LOWER;  //Corner

MqlRates stcOldLastMN[1], stcOldLastW[1];
string asMon[13] = { "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  int x=0,y=0,v=0;
  switch(enCorner)
    {
    case CORNER_LEFT_UPPER: x = 10; y = 10; v = 1; break;
    case CORNER_RIGHT_UPPER: x = 120; y = 10; v = 1; break;
    case CORNER_LEFT_LOWER: x = 10; y = 90; v = -1; break;
    case CORNER_RIGHT_LOWER: x = 120; y = 90; v = -1; break;
    }
  
  fDrawLabel("CountW",  x, y, cWeeks, "Weeks: 0"); y += 20*v;
  fDrawLabel("CountMN", x, y, cMonths, "Months: 0"); y += 20*v;
  fDrawLabel("CountQ",  x, y, cQuarters, "Quarters: 0"); y += 20*v;
  fDrawLabel("CountY",  x, y, cYears, "Years: 0");
  return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
   {
   fDelLines(PERIOD_MN1);
   fDelLines(PERIOD_W1);
   fDelLines(PERIOD_Q1);
   fDelLines(PERIOD_Y1);
   ObjectDelete("CountW");
   ObjectDelete("CountMN");
   ObjectDelete("CountQ");
   ObjectDelete("CountY");
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
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   
   //redraw weekly lines once a week
   if (iWeeks > 0)
      {
      MqlRates stcNewLastW[1];
      if (CopyRates(_Symbol, PERIOD_W1, 1, 1, stcNewLastW) == 1)
         if (ArrayCompare(stcNewLastW, stcOldLastW) != 0)
            {
            double dHigh[], dLow[];
            datetime dtDate[];
            ArraySetAsSeries(dHigh, true);
            ArraySetAsSeries(dLow, true);
            ArraySetAsSeries(dtDate, true);
            
            //try to get all at first
            ResetLastError();
            int iTotal = iWeeks;
            int iRes1 = CopyHigh(_Symbol, PERIOD_W1, 0, iTotal, dHigh);
            int iRes2 = CopyLow (_Symbol, PERIOD_W1, 0, iTotal, dLow);
            int iRes3 = CopyTime(_Symbol, PERIOD_W1, 0, iTotal, dtDate);
            if (_LastError == 4066 || _LastError == 4054) return(rates_total);   //history is downloading
            
            if (iRes1 != iTotal || iRes2 != iTotal || iRes3 != iTotal)     //history is not enough - take all available
               {
               iTotal = (int)SeriesInfoInteger(_Symbol, PERIOD_W1, SERIES_BARS_COUNT);
               CopyHigh(_Symbol, PERIOD_W1, 0, iTotal, dHigh);
               CopyLow (_Symbol, PERIOD_W1, 0, iTotal, dLow);
               CopyTime(_Symbol, PERIOD_W1, 0, iTotal, dtDate);
               }
            
            fDelLines(PERIOD_W1);
            for (int i = 0; i < iTotal; i++)
               {
               datetime dtWeekSt = dtDate[i] - 518400;
               fDrawLine("HighW"+ITS(i+1), dHigh[i], dtDate[i], cWeeks, 1, ITS(TimeYear(dtWeekSt))+" "+asMon[TimeMonth(dtWeekSt)]+ITS(TimeDay(dtWeekSt))+" week High");
               fDrawLine("LowW"+ITS(i+1), dLow[i], dtDate[i], cWeeks, 1, ITS(TimeYear(dtWeekSt))+" "+asMon[TimeMonth(dtWeekSt)]+ITS(TimeDay(dtWeekSt))+" week Low");
               }
            stcOldLastW[0] = stcNewLastW[0];
            ObjectSetString(0, "CountW", OBJPROP_TEXT, "Weeks: " + ITS(iTotal));
            }
      }
   //redraw monthly lines once a month
   if (iMonths > 0 || iQuarters > 0 || iYears > 0)
      {
      MqlRates stcNewLastMN[1];
      if (CopyRates(_Symbol, PERIOD_MN1, 1, 1, stcNewLastMN) == 1)
         if (ArrayCompare(stcNewLastMN, stcOldLastMN) != 0)
            {
            double dHigh[], dLow[];
            datetime dtDate[];
            ArraySetAsSeries(dHigh, true);
            ArraySetAsSeries(dLow, true);
            ArraySetAsSeries(dtDate, true);
            
            //try to get all at first
            ResetLastError();
            int iTotal = MathMax(MathMax(12*iYears, 3*iQuarters), iMonths);            //how many months do we need?
            int iRes1 = CopyHigh(_Symbol, PERIOD_MN1, 0, iTotal, dHigh);
            int iRes2 = CopyLow (_Symbol, PERIOD_MN1, 0, iTotal, dLow);
            int iRes3 = CopyTime(_Symbol, PERIOD_MN1, 0, iTotal, dtDate);
            if (_LastError == 4066 || _LastError == 4054) return(rates_total);   //history is downloading
            
            if (iRes1 != iTotal || iRes2 != iTotal || iRes3 != iTotal)     //history is not enough - take all available
               {
               iTotal = (int)SeriesInfoInteger(_Symbol, PERIOD_MN1, SERIES_BARS_COUNT);
               CopyHigh(_Symbol, PERIOD_MN1, 0, iTotal, dHigh);
               CopyLow (_Symbol, PERIOD_MN1, 0, iTotal, dLow);
               CopyTime(_Symbol, PERIOD_MN1, 0, iTotal, dtDate);
               }
               
            fDelLines(PERIOD_MN1);
            int iMonthCnt = 0;
            for (int i = 0; i < iTotal; i++)
               {
               iMonthCnt++;
               if (iMonthCnt > iMonths) break;
               fDrawLine("HighMN"+ITS(i+1), dHigh[i], dtDate[i], cMonths, 1, ITS(TimeYear(dtDate[i]))+ " "+asMon[TimeMonth(dtDate[i])]+" High");
               fDrawLine("LowMN"+ITS(i+1), dLow[i], dtDate[i], cMonths, 1, ITS(TimeYear(dtDate[i]))+ " "+asMon[TimeMonth(dtDate[i])]+" Low");
               }
            
            fDelLines(PERIOD_Q1);
            int iQuarterCnt = 0;
            datetime dtDateCu = 0;
            double dHighCu = 0, dLowCu = DBL_MAX;
            for (int i = 0; i < iTotal; i++)
               {
               if (TimeMonth(dtDate[i]) % 3 == 0 || iQuarterCnt == 0)
                  {
                  if (iQuarterCnt > 0)
                     {
                     fDrawLine("HighQ"+ITS(iQuarterCnt), dHighCu, dtDateCu, cQuarters, 2, ITS(TimeYear(dtDateCu))+" "+ITS(TimeMonth(dtDateCu)/4+1)+"qtr High");
                     fDrawLine("LowQ"+ITS(iQuarterCnt), dLowCu, dtDateCu, cQuarters, 2, ITS(TimeYear(dtDateCu))+" "+ITS(TimeMonth(dtDateCu)/4+1)+"qtr Low");
                     }
                  dHighCu = 0; dLowCu = DBL_MAX;
                  dtDateCu = dtDate[i];
                  iQuarterCnt++;
                  if (iQuarterCnt > iQuarters) break;
                  }
               dHighCu = MathMax(dHighCu, dHigh[i]);
               dLowCu  = MathMin(dLowCu, dLow[i]);
               }
            
            fDelLines(PERIOD_Y1);
            dtDateCu = 0;
            int iYearCnt = 0;
            dHighCu = 0; dLowCu = DBL_MAX;
            for (int i = 0; i < iTotal; i++)
               {
               if (TimeYear(dtDate[i]) != TimeYear(dtDateCu))
                  {
                  if (iYearCnt > 0)
                     {
                     fDrawLine("HighY"+ITS(iYearCnt), dHighCu, dtDateCu, cYears, 3, ITS(TimeYear(dtDateCu))+" High");
                     fDrawLine("LowY"+ITS(iYearCnt), dLowCu, dtDateCu, cYears, 3, ITS(TimeYear(dtDateCu))+" Low");
                     }
                  dHighCu = 0; dLowCu = DBL_MAX;
                  dtDateCu = dtDate[i];
                  iYearCnt++;
                  if (iYearCnt > iYears) break;
                  }
               dHighCu = MathMax(dHighCu, dHigh[i]);
               dLowCu  = MathMin(dLowCu, dLow[i]);
               }
            stcOldLastMN[0] = stcNewLastMN[0];
            ObjectSetString(0, "CountMN", OBJPROP_TEXT, "Months: " + ITS(iMonthCnt-1));
            ObjectSetString(0, "CountQ",  OBJPROP_TEXT, "Quarters: " + ITS(iQuarterCnt-1));
            ObjectSetString(0, "CountY",  OBJPROP_TEXT, "Years: " + ITS(iYearCnt-1));
            }
      }
   //need to check for the break with current price
   if (iWeeks > 0 && high[0] > ObjectGetDouble(0, "HighW"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "HighW"+ITS(1), OBJPROP_PRICE1, high[0]);
   if (iWeeks > 0 && low[0] < ObjectGetDouble(0, "LowW"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "LowW"+ITS(1), OBJPROP_PRICE1, low[0]);
   
   if (iMonths > 0 && high[0] > ObjectGetDouble(0, "HighMN"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "HighMN"+ITS(1), OBJPROP_PRICE1, high[0]);
   if (iMonths > 0 && low[0] < ObjectGetDouble(0, "LowMN"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "LowMN"+ITS(1), OBJPROP_PRICE1, low[0]);
   
   if (iQuarters > 0 && high[0] > ObjectGetDouble(0, "HighQ"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "HighQ"+ITS(1), OBJPROP_PRICE1, high[0]);
   if (iQuarters > 0 && low[0] < ObjectGetDouble(0, "LowQ"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "LowQ"+ITS(1), OBJPROP_PRICE1, low[0]);
      
   if (iYears > 0 && high[0] > ObjectGetDouble(0, "HighY"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "HighY"+ITS(1), OBJPROP_PRICE1, high[0]);
   if (iYears > 0 && low[0] < ObjectGetDouble(0, "LowY"+ITS(1), OBJPROP_PRICE1))
      ObjectSetDouble(0, "LowY"+ITS(1), OBJPROP_PRICE1, low[0]);
   
   return(rates_total);
   }
//+------------------------------------------------------------------+
void fDrawLine(string sName, double dValue, datetime dtDate, color cCol, int iWidth, string sDescr)
   {
   ObjectCreate(0, sName, OBJ_HLINE, 0, 0, 0);
   ObjectSetDouble(0, sName, OBJPROP_PRICE1, dValue);
   ObjectSetInteger(0, sName, OBJPROP_COLOR, cCol);
   ObjectSetInteger(0, sName, OBJPROP_STYLE, enStyle);
   ObjectSetInteger(0, sName, OBJPROP_WIDTH, iWidth);
   ObjectSetString(0, sName, OBJPROP_TOOLTIP, sDescr + "\n" + DoubleToString(dValue, _Digits));
   }
//+------------------------------------------------------------------+
void fDrawLabel(string sName, int iXCoord, int iYCoord, color cCol, string sText)
   {
   ObjectCreate(0, sName, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, sName, OBJPROP_XDISTANCE, iXCoord);
   ObjectSetInteger(0, sName, OBJPROP_YDISTANCE, iYCoord);
   ObjectSetInteger(0, sName, OBJPROP_COLOR, cCol);
   ObjectSetInteger(0, sName, OBJPROP_CORNER, enCorner);
   ObjectSetInteger(0, sName, OBJPROP_FONTSIZE, 14);
   ObjectSetString (0, sName, OBJPROP_TEXT, sText);
   }
//+------------------------------------------------------------------+
void fDelLines(int iTF)
   {
   switch(iTF)
      {
      case PERIOD_MN1:
         ObjectsDeleteAll(0, "HighMN", 0, OBJ_HLINE);
         ObjectsDeleteAll(0, "LowMN", 0, OBJ_HLINE);
         break;
      case PERIOD_W1:
         ObjectsDeleteAll(0, "HighW", 0, OBJ_HLINE);
         ObjectsDeleteAll(0, "LowW", 0, OBJ_HLINE);
         break;
      case PERIOD_Q1:
         ObjectsDeleteAll(0, "HighQ", 0, OBJ_HLINE);
         ObjectsDeleteAll(0, "LowQ", 0, OBJ_HLINE);
         break;
      case PERIOD_Y1:
         ObjectsDeleteAll(0, "HighY", 0, OBJ_HLINE);
         ObjectsDeleteAll(0, "LowY", 0, OBJ_HLINE);
         break;
      }
   }
//+------------------------------------------------------------------+
string ITS(int iValue) { return(IntegerToString(iValue)); }