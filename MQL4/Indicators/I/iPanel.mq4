/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website:  Ht tp:// www. m etaq U oT e s .N E T
   E-mail : Su pPO rT@mEta Qu Otes .NET
*/

#property indicator_chart_window

int Gi_76 = 25;
int Gi_80 = 13;
int Gi_84 = 10;
int Gi_88 = 10;
int Gi_92 = 8;
//int Gia_96[] = {1, 5, 15, 30, 60, 240};
int Gia_96[] = {30, 60, 240, 1440, 10080};
int Gia_100[] = {14, 14, 6, 6, 6, 6};
int Gia_104[] = {50, 34, 14, 14, 14, 14};
//string Gsa_108[] = {"1m", "5m", "15m", "30m", "1h", "4h"};
string Gsa_108[] = {"M30", "H1", "H4", "D1", "W1"};
string Gsa_112[] = {"STOCH", "RSI", "CCI", "MACD", "EMA1", "EMA2"};
extern color Text_color=clrWhite;
extern string Corner_Settings = "0 - Left_Up, 1 - Right_Up, 2 - Left_Down, 3- Right_Down";
extern int Corner = 1;
extern string Stochastic_Settings = "=== Stochastic Einstellungen ===";
extern int PercentK = 8;
extern int PercentD = 3;
extern int Slowing = 3;
extern string RSI_Settings = "=== RSI Einstellungen ===";
extern int RSIP1 = 14;
extern int RSIP2 = 70;
extern string MACD_Settings = "=== MACD Einstellungen ===";
extern int FastEMA = 12;
extern int SlowEMA = 24;
extern int MACDsp = 6;
extern string EMA_Settings = "=== MA Einstellungen ===";
extern int shortP1 = 5;
extern int shortP2 = 8;
extern int longP1 = 26;
extern int longP2 = 52;
extern string My_Symbols = "=== Wingdings Symbole ===";
extern int sBuy = 233;
extern int sSell = 234;
extern int sWait = 54;
extern int sCCIAgainstBuy = 238;
extern int sCCIAgainstSell = 236;

int init() {
   IndicatorShortName("iPanel");
   return (0);
}

int deinit() {
   ObjectsDeleteAll(0, OBJ_LABEL);
   for (int Li_0 = 0; Li_0 < 6; Li_0++) for (int Li_4 = 0; Li_4 < 6; Li_4++) ObjectDelete("tPs" + Li_0 + Li_4);
   for (Li_4 = 0; Li_4 < 6; Li_4++) ObjectDelete("tInd" + Li_4);
   for (Li_0 = 0; Li_0 < 6; Li_0++) for (Li_4 = 0; Li_4 < 6; Li_4++) ObjectDelete("dI" + Li_0 + Li_4);
   for (Li_0 = 0; Li_0 < 6; Li_0++) for (Li_4 = 0; Li_4 < 6; Li_4++) ObjectDelete("tI" + Li_0 + Li_4);
   return (0);
}

int start() {
   ObjectCreate("Indicators", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Indicators", "iPanel_INDICATORS", 8, "Arial Bold", Text_color);
   ObjectSet("Indicators", OBJPROP_CORNER, Corner);
   ObjectSet("Indicators", OBJPROP_XDISTANCE, 5);
   ObjectSet("Indicators", OBJPROP_YDISTANCE, 5);
   for (int Li_0 = 0; Li_0 < 6; Li_0++) 
   {
      ObjectCreate("tper" + Li_0, OBJ_LABEL, 0, 0, 0);
      ObjectSetText("tper" + Li_0, Gsa_108[Li_0], Gi_92, "Arial Bold", Text_color);
      ObjectSet("tper" + Li_0, OBJPROP_CORNER, Corner);
      ObjectSet("tper" + Li_0, OBJPROP_XDISTANCE, Li_0 * Gi_76 + 45);
      ObjectSet("tper" + Li_0, OBJPROP_YDISTANCE, Gi_88 + 6);
   }
   for (int Li_4 = 0; Li_4 < 6; Li_4++) 
   {
      for (int Li_8 = 0; Li_8 < 6; Li_8++) {
         ObjectSet("tPs" + Li_4 + Li_8, OBJPROP_CORNER, Corner);
         ObjectSet("tPs" + Li_4 + Li_8, OBJPROP_XDISTANCE, Li_4 * Gi_76 + Gi_84);
         ObjectSet("tPs" + Li_4 + Li_8, OBJPROP_YDISTANCE, Li_8 * Gi_80 + Gi_88 + 6);
      }
   }
   for (Li_8 = 0; Li_8 < 6; Li_8++) 
   {
      ObjectCreate("tInd" + Li_8, OBJ_LABEL, 0, 0, 0);
      ObjectSetText("tInd" + Li_8, Gsa_112[Li_8], Gi_92, "Arial Bold", Text_color);
      ObjectSet("tInd" + Li_8, OBJPROP_CORNER, Corner);
      ObjectSet("tInd" + Li_8, OBJPROP_XDISTANCE, Gi_84 - 5);
      ObjectSet("tInd" + Li_8, OBJPROP_YDISTANCE, Li_8 * Gi_80 + 27);
   }
   for (Li_4 = 0; Li_4 < 6; Li_4++) 
   {
      for (Li_8 = 0; Li_8 < 6; Li_8++) {
         ObjectCreate("dI" + Li_4 + Li_8, OBJ_LABEL, 0, 0, 0);
         ObjectSetText("dI" + Li_4 + Li_8, " ", 10, "Wingdings", Goldenrod);
         ObjectSet("dI" + Li_4 + Li_8, OBJPROP_CORNER, Corner);
         ObjectSet("dI" + Li_4 + Li_8, OBJPROP_XDISTANCE, Li_4 * Gi_76 + (Gi_84 + 35));
         ObjectSet("dI" + Li_4 + Li_8, OBJPROP_YDISTANCE, Li_8 * Gi_80 + 27);
      }
   }
   for (Li_4 = 0; Li_4 < 6; Li_4++) 
   {
      for (Li_8 = 0; Li_8 < 6; Li_8++) {
         ObjectCreate("tI" + Li_4 + Li_8, OBJ_LABEL, 0, 0, 0);
         ObjectSetText("tI" + Li_4 + Li_8, "    ", 9, "Arial Bold", Goldenrod);
         ObjectSet("tI" + Li_4 + Li_8, OBJPROP_CORNER, Corner);
         ObjectSet("tI" + Li_4 + Li_8, OBJPROP_XDISTANCE, Li_4 * Gi_76 + (Gi_84 + 15));
         ObjectSet("tI" + Li_4 + Li_8, OBJPROP_YDISTANCE, Li_8 * Gi_80 + Gi_88);
      }
   }
//   for (Li_4 = 0; Li_4 < 6; Li_4++)
     for (Li_4 = 0; Li_4 < 5; Li_4++)
   {
      if (iStochastic(NULL, Gia_96[Li_4], PercentK, PercentD, Slowing, MODE_SMA, 0, MODE_MAIN, 0) > iStochastic(NULL, Gia_96[Li_4], PercentK, PercentD, Slowing, MODE_SMA,
         0, MODE_SIGNAL, 0)) ObjectSetText("dI" + Li_4 + "0", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
      else {
         if (iStochastic(NULL, Gia_96[Li_4], PercentK, PercentD, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0) > iStochastic(NULL, Gia_96[Li_4], PercentK, PercentD, Slowing, MODE_SMA,
            0, MODE_MAIN, 0)) ObjectSetText("dI" + Li_4 + "0", CharToStr(sSell), Gi_92, "Wingdings", Red);
         else ObjectSetText("dI" + Li_4 + "0", CharToStr(sWait), 10, "Wingdings", Khaki);
      }
   }
//   for (Li_4 = 0; Li_4 < 6; Li_4++)
   for (Li_4 = 0; Li_4 < 5; Li_4++) 
   {
      if (iRSI(NULL, Gia_96[Li_4], RSIP1, PRICE_TYPICAL, 0) > iRSI(NULL, Gia_96[Li_4], RSIP2, PRICE_TYPICAL, 0)) ObjectSetText("dI" + Li_4 + "1", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
      else {
         if (iRSI(NULL, Gia_96[Li_4], RSIP2, PRICE_TYPICAL, 0) > iRSI(NULL, Gia_96[Li_4], RSIP1, PRICE_TYPICAL, 0)) ObjectSetText("dI" + Li_4 + "1", CharToStr(sSell), Gi_92, "Wingdings", Red);
         else ObjectSetText("dI" + Li_4 + "1", CharToStr(sWait), Gi_92, "Wingdings", Khaki);
      }
   }
//   for (Li_4 = 0; Li_4 < 6; Li_4++)
   for (Li_4 = 0; Li_4 < 5; Li_4++) 
   {
      if (iCCI(NULL, Gia_96[Li_4], Gia_100[Li_4], PRICE_TYPICAL, 0) > 0.0) {
         if (iCCI(NULL, Gia_96[Li_4], Gia_100[Li_4], PRICE_TYPICAL, 0) > iCCI(NULL, Gia_96[Li_4], Gia_100[Li_4], PRICE_TYPICAL, 1)) {
            ObjectSetText("dI" + Li_4 + "2", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
            continue;
         }
         ObjectSetText("dI" + Li_4 + "2", CharToStr(sCCIAgainstBuy), Gi_92, "Wingdings", Red);
      } else {
         if (iCCI(NULL, Gia_96[Li_4], Gia_100[Li_4], PRICE_TYPICAL, 0) < 0.0) {
            if (iCCI(NULL, Gia_96[Li_4], Gia_100[Li_4], PRICE_TYPICAL, 0) < iCCI(NULL, Gia_96[Li_4], Gia_100[Li_4], PRICE_TYPICAL, 1)) {
               ObjectSetText("dI" + Li_4 + "2", CharToStr(sSell), Gi_92, "Wingdings", Red);
               continue;
            }
            ObjectSetText("dI" + Li_4 + "2", CharToStr(sCCIAgainstSell), Gi_92, "Wingdings", Lime);
         } else ObjectSetText("dI" + Li_4 + "2", CharToStr(sWait), 10, "Wingdings", Khaki);
      }
   }
//   for (Li_4 = 0; Li_4 < 6; Li_4++)
   for (Li_4 = 0; Li_4 < 5; Li_4++) 
   {
      if (iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_MAIN, 0) > 0.0) {
         if (iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_SIGNAL,
            0)) {
            ObjectSetText("dI" + Li_4 + "3", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
            continue;
         }
         if (iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_SIGNAL,
            0)) {
            ObjectSetText("dI" + Li_4 + "3", CharToStr(sSell), Gi_92, "Wingdings", Red);
            continue;
         }
         ObjectSetText("dI" + Li_4 + "3", CharToStr(sWait), Gi_92, "Wingdings", Khaki);
      } else {
         if (iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_MAIN, 0) < 0.0) {
            if (iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_SIGNAL,
               0)) {
               ObjectSetText("dI" + Li_4 + "3", CharToStr(sSell), Gi_92, "Wingdings", Red);
               continue;
            }
            if (iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, Gia_96[Li_4], FastEMA, SlowEMA, MACDsp, PRICE_CLOSE, MODE_SIGNAL,
               0)) {
               ObjectSetText("dI" + Li_4 + "3", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
               continue;
            }
            ObjectSetText("dI" + Li_4 + "3", CharToStr(sWait), Gi_92, "Wingdings", Khaki);
         }
      }
   }
//   for (Li_4 = 0; Li_4 < 6; Li_4++)
   for (Li_4 = 0; Li_4 < 5; Li_4++) 
   {
      if (iMA(NULL, Gia_96[Li_4], shortP1, 0, MODE_EMA, PRICE_CLOSE, 0) > iMA(NULL, Gia_96[Li_4], shortP2, 0, MODE_EMA, PRICE_CLOSE, 0)) ObjectSetText("dI" + Li_4 + "4", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
      else {
         if (iMA(NULL, Gia_96[Li_4], shortP1, 0, MODE_EMA, PRICE_CLOSE, 0) < iMA(NULL, Gia_96[Li_4], shortP2, 0, MODE_EMA, PRICE_CLOSE, 0)) ObjectSetText("dI" + Li_4 + "4", CharToStr(sSell), Gi_92, "Wingdings", Red);
         else ObjectSetText("dI" + Li_4 + "4", CharToStr(sWait), Gi_92, "Wingdings", Khaki);
      }
   }
//   for (Li_4 = 0; Li_4 < 6; Li_4++)
   for (Li_4 = 0; Li_4 < 5; Li_4++) 
   {
      if (iMA(NULL, Gia_96[Li_4], longP1, 0, MODE_EMA, PRICE_CLOSE, 0) > iMA(NULL, Gia_96[Li_4], longP2, 0, MODE_EMA, PRICE_CLOSE, 0)) ObjectSetText("dI" + Li_4 + "5", CharToStr(sBuy), Gi_92, "Wingdings", Lime);
      else {
         if (iMA(NULL, Gia_96[Li_4], longP1, 0, MODE_EMA, PRICE_CLOSE, 0) < iMA(NULL, Gia_96[Li_4], longP2, 0, MODE_EMA, PRICE_CLOSE, 0)) ObjectSetText("dI" + Li_4 + "5", CharToStr(sSell), Gi_92, "Wingdings", Red);
         else ObjectSetText("dI" + Li_4 + "5", CharToStr(sWait), Gi_92, "Wingdings", Khaki);
      }
   }
   return (0);
}