/*
   Generated by EX4-TO-MQ4 decompiler V4.0.224.1 []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright © 2010, NiX"
#property link      "http://www.the-forex-strategy.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Black

#include <WinUser32.mqh>

extern int Range = 6;
extern int OutputTimeFrame = 2;
extern bool FiveDigitBroker = TRUE;
extern bool DisableComment = FALSE;
extern bool RefreshWindowOnAskPriceChange = FALSE;
extern int RenderUsing1MhistoryBars = 7200;
extern string SoundSignalOnNewBar = "tick.wav";
int g_file_108 = -1;
int gi_112;
int gi_120 = 0;
double gd_124 = 0.0;
double gd_132 = 0.0;
double gd_140 = 0.0;
double gd_148 = 0.0;
double gd_156 = 0.0;
int gi_164 = 0;
bool gi_unused_168 = FALSE;
bool gi_172 = FALSE;
int gi_176;
int gi_180 = 0;
int gi_184 = 0;
int gi_188 = 400;
string gs_192;
string gs_200;
int gi_208;
int g_digits_212;
int gia_216[13];
double gd_220;
double g_bid_228;
bool gi_236 = FALSE;

void DebugMsg(string as_0) {
   if (gi_172) Alert(as_0);
}

void DebugPrint(string as_0) {
   if (gi_172) Print(as_0);
}

bool isMTready() {
   RefreshRates();
   double l_bid_0 = MarketInfo(Symbol(), MODE_BID);
   double l_ask_8 = MarketInfo(Symbol(), MODE_ASK);
   if (l_bid_0 > 0.0 && l_ask_8 > 0.0) return (TRUE);
   return (FALSE);
}

int init() {
   while (!isMTready()) Sleep(100);
   gs_200 = Symbol();
   gi_208 = Period() * OutputTimeFrame;
   g_digits_212 = Digits;
   if (Period() != PERIOD_M1) {
      Alert("Please attach the script to 1M chart only! Exiting...");
      Range = 0;
      return (0);
   }
   if (!DisableComment) {
      Comment("\nRangeBar Plugin v." + "1.02c" + " for MT4 (c)2010 NiX\n\nFor the LIVE " + Range + "pip RangeBar chart, open the OFFLINE chart for " + Symbol() + ",M" + OutputTimeFrame 
      + "\nNOTE: The live feed will not work if DLL calls are disabled!");
   }
   if (FiveDigitBroker) Range = 10 * Range;
   int li_0 = (MarketInfo(Symbol(), MODE_ASK) - MarketInfo(Symbol(), MODE_BID)) / Point;
   if (Range < li_0) {
      Alert("You have chosen a range setting that is less than your spread for " + Symbol() + ". The setting has been updated to " + li_0);
      Range = li_0;
   }
   DebugPrint("range = " + Range);
   if (Range <= 0) return (0);
   g_file_108 = FileOpenHistory(gs_200 + gi_208 + ".hst", FILE_BIN|FILE_WRITE);
   if (g_file_108 < 0) return (-1);
   gs_192 = "(C)opyright 2010, NiX";
   FileWriteInteger(g_file_108, gi_188, LONG_VALUE);
   FileWriteString(g_file_108, gs_192, 64);
   FileWriteString(g_file_108, gs_200, 12);
   FileWriteInteger(g_file_108, gi_208, LONG_VALUE);
   FileWriteInteger(g_file_108, g_digits_212, LONG_VALUE);
   FileWriteInteger(g_file_108, 0, LONG_VALUE);
   FileWriteInteger(g_file_108, 0, LONG_VALUE);
   FileWriteArray(g_file_108, gia_216, 0, 13);
   gi_112 = FileTell(g_file_108);
   int li_4 = 0;
   if (Bars > RenderUsing1MhistoryBars) {
      if (RenderUsing1MhistoryBars == 0) li_4 = Bars;
      else li_4 = RenderUsing1MhistoryBars;
   } else li_4 = Bars;
   for (gi_176 = li_4 - 1; gi_176 >= 0; gi_176--) processHistoryBar(Time[gi_176], Open[gi_176], Low[gi_176], High[gi_176], Close[gi_176], Volume[gi_176], 1);
   gi_120 = Time[gi_176 + 1];
   gi_184 = gi_120;
   while (gi_120 <= gi_184) gi_120++;
   DebugPrint("History written! lastpos: " + gi_112);
   gd_220 = NormalizeDouble(Range * Point, Digits);
   FileSeek(g_file_108, 0, SEEK_END);
   FileWriteInteger(g_file_108, gi_120, LONG_VALUE);
   FileWriteDouble(g_file_108, gd_124, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, gd_132, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, gd_140, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, gd_148, DOUBLE_VALUE);
   FileWriteDouble(g_file_108, gd_156, DOUBLE_VALUE);
   FileFlush(g_file_108);
   gi_112 = FileTell(g_file_108);
   if (gi_180 == 0) {
      gi_180 = WindowHandle(gs_200, OutputTimeFrame);
      if (gi_180 != 0) DebugMsg("Chart window detected correctly");
   }
   if (gi_180 != 0)
      if (PostMessageA(gi_180, WM_COMMAND, 33324, 0) == 0) gi_180 = 0;
   RefreshRates();
   gi_236 = TRUE;
   return (0);
}

int deinit() {
   if (g_file_108 >= 0) {
      FileClose(g_file_108);
      g_file_108 = -1;
   }
   if (!DisableComment) Comment("");
   return (0);
}

int start() {
   if (g_bid_228 != Bid) {
      g_bid_228 = Bid;
      if (gi_180 == 0) {
         gi_180 = WindowHandle(gs_200, OutputTimeFrame);
         if (gi_180 != 0) DebugMsg("Chart window detected correctly");
      }
      if (gd_124 != 0.0) {
         if (gd_140 < Bid) gd_140 = Bid;
         if (gd_132 > Bid) gd_132 = Bid;
         gd_148 = Bid;
         gd_156 += 1.0;
      } else {
         gd_140 = Close[0];
         gd_132 = Close[0];
         gd_124 = Close[0];
         gd_148 = Close[0];
         gd_156 = 1;
         gi_120 = Time[0];
      }
      if (NormalizeDouble(gd_140 - gd_132, Digits) > gd_220) {
         DebugPrint("processing...");
         processHistoryBar(gi_120, gd_124, gd_132, gd_140, gd_148, gd_156, 1, 1);
         gi_184 = gi_120;
         for (gi_120 = Time[0] + 1; gi_120 <= gi_184; gi_120++) {
         }
         if (gi_180 != 0)
            if (PostMessageA(gi_180, WM_COMMAND, 33324, 0) == 0) gi_180 = 0;
         DebugPrint("done...");
      } else {
         FileSeek(g_file_108, gi_112 - 44, SEEK_SET);
         FileWriteInteger(g_file_108, gi_120, LONG_VALUE);
         FileWriteDouble(g_file_108, gd_124, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, gd_132, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, gd_140, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, gd_148, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, gd_156, DOUBLE_VALUE);
         FileFlush(g_file_108);
         if (gi_180 != 0)
            if (PostMessageA(gi_180, WM_COMMAND, 33324, 0) == 0) gi_180 = 0;
      }
   } else {
      if (RefreshWindowOnAskPriceChange) {
         if (gi_180 != 0)
            if (PostMessageA(gi_180, WM_COMMAND, 33324, 0) == 0) gi_180 = 0;
      }
   }
   return (0);
}

void updateHistory(int ai_0, double ad_4, double ad_12, double ad_20, double ad_28, double ad_36, bool ai_44 = FALSE) {
   int li_48;
   if (g_file_108 >= 0) {
      if (ai_44) {
         FileSeek(g_file_108, gi_112 - 44, SEEK_SET);
         DebugPrint("2H_rewrite--> " + TimeToStr(ai_0, TIME_SECONDS) + " " + ad_4 + " " + ad_12 + " " + ad_20 + " " + ad_28 + " " + ad_36);
      } else {
         FileSeek(g_file_108, gi_112, SEEK_SET);
         DebugPrint("2H_-seek----> " + TimeToStr(ai_0, TIME_SECONDS) + " " + ad_4 + " " + ad_12 + " " + ad_20 + " " + ad_28 + " " + ad_36);
      }
      FileWriteInteger(g_file_108, ai_0, LONG_VALUE);
      FileWriteDouble(g_file_108, ad_4, DOUBLE_VALUE);
      FileWriteDouble(g_file_108, ad_12, DOUBLE_VALUE);
      FileWriteDouble(g_file_108, ad_20, DOUBLE_VALUE);
      FileWriteDouble(g_file_108, ad_28, DOUBLE_VALUE);
      FileWriteDouble(g_file_108, ad_36, DOUBLE_VALUE);
      FileFlush(g_file_108);
      gi_112 = FileTell(g_file_108);
      if (ad_28 > ad_4) gi_unused_168 = TRUE;
      else {
         if (ad_4 == ad_28) {
            if (ad_20 - ad_4 > ad_4 - ad_12) gi_unused_168 = FALSE;
            else gi_unused_168 = TRUE;
         } else gi_unused_168 = FALSE;
      }
      if (ai_44) {
         li_48 = ai_0;
         for (gi_120 = Time[0]; gi_120 <= li_48; gi_120++) {
         }
         FileSeek(g_file_108, 0, SEEK_END);
         FileWriteInteger(g_file_108, gi_120, LONG_VALUE);
         FileWriteDouble(g_file_108, ad_28, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, ad_28, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, ad_28, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, ad_28, DOUBLE_VALUE);
         FileWriteDouble(g_file_108, 1, DOUBLE_VALUE);
         FileFlush(g_file_108);
         gi_112 = FileTell(g_file_108);
         DebugPrint("2H_following--> " + TimeToStr(gi_120, TIME_SECONDS) + " " + ad_28 + " " + ad_28 + " " + ad_28 + " " + ad_28 + " " + 1);
         if (gi_236 && SoundSignalOnNewBar != "") PlaySound(SoundSignalOnNewBar);
      }
   }
}

void memoryBar(int ai_0, double ad_4, double ad_12, double ad_20, double ad_28, double ad_36) {
   if (gi_120 != 0) {
      gi_120 = ai_0;
      gd_156 = ad_36;
   } else gd_156 += ad_36;
   gd_124 = ad_4;
   gd_132 = ad_12;
   gd_140 = ad_20;
   gd_148 = ad_28;
   DebugPrint("## memoryBar--> " + TimeToStr(ai_0, TIME_SECONDS) + " " + ad_4 + " " + ad_12 + " " + ad_20 + " " + ad_28 + " " + ad_36);
}

void memoryBarClear() {
   gi_120 = 0;
   gd_124 = 0;
   gd_132 = 0;
   gd_140 = 0;
   gd_148 = 0;
   gd_156 = 0;
}

int processHistoryBar(int ai_0, double ad_4, double ad_12, double ad_20, double ad_28, double ad_36, int ai_44, bool ai_48 = FALSE) {
   double ld_76;
   double ld_84;
   double ld_92;
   double ld_100;
   if (ai_44 == 1 && gd_124 != 0.0) {
      DebugPrint("NB ------------> " + ad_4 + " " + ad_12 + " " + ad_20 + " " + ad_28);
      DebugPrint("MEM-----------> " + gd_124 + " " + gd_132 + " " + gd_140 + " " + gd_148);
      if (ad_20 < gd_140) ad_20 = gd_140;
      if (ad_12 > gd_132) ad_12 = gd_132;
      ad_4 = gd_124;
      DebugPrint("NB -updated----> " + ad_4 + " " + ad_12 + " " + ad_20 + " " + ad_28);
      gi_164 = ai_0;
   } else {
      DebugPrint("Recursive entry...");
      ai_0 = gi_164 + 1;
      gi_164 = ai_0;
   }
   double ld_52 = NormalizeDouble(Range * Point, Digits);
   double ld_60 = NormalizeDouble(MathAbs(ad_20 - ad_12), Digits);
   double ld_68 = NormalizeDouble(ad_28 - ad_4, Digits);
   if (ld_68 < 0.0 || (ld_68 == 0.0 && ad_28 > ad_12)) {
      if (ld_60 > ld_52) {
         ld_76 = NormalizeDouble(MathAbs(ad_20 - ad_4), Digits);
         if (ld_76 > ld_52) {
            if (ad_20 - ad_4 >= ld_52) {
               ld_84 = ad_4 + ld_52;
               updateHistory(ai_0, ad_4, ad_4, ld_84, ld_84, ad_36, ai_48);
               memoryBar(ai_0, ld_84, ad_12, ad_20, ad_28, ad_36);
               processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
               return (1);
            }
            ld_92 = ad_20 - ld_52;
            updateHistory(ai_0, ad_4, ld_92, ad_20, ld_92, ad_36, ai_48);
            memoryBar(ai_0, ld_92, ad_12, ad_20, ad_28, ad_36);
            processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
            return (1);
         }
         if (ld_76 == ld_52) {
            updateHistory(ai_0, ad_4, ad_4, ad_20, ad_4, ad_36, ai_48);
            memoryBar(ai_0, ad_4, ad_12, ad_4, ad_28, ad_36);
            processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
            return (1);
         }
         if (ld_76 < ld_52) {
            updateHistory(ai_0, ad_4, ad_20 - ld_52, ad_20, ad_20 - ld_52, ad_36, ai_48);
            if (ad_28 < ad_20 - ld_52 && ad_28 != ad_4) {
               memoryBar(ai_0, ad_20 - ld_52, ad_12, ad_20 - ld_52, ad_28, ad_36);
               DebugPrint("H2O1_exit");
            } else {
               if (ad_28 >= ad_20 - ld_52 && ad_28 != ad_4) {
                  memoryBar(ai_0, ad_20 - ld_52, ad_12, ad_20 - ld_52, ad_20 - ld_52, ad_36);
                  DebugPrint("H@O2_exit");
               } else {
                  if (ad_28 < ad_20 - ld_52 && ad_28 == ad_4) {
                     DebugMsg("Untested_178");
                     memoryBarClear();
                     return (0);
                  }
                  if (ad_28 >= ad_20 - ld_52 && ad_28 == ad_4) {
                     memoryBar(ai_0, ad_20 - ld_52, ad_12, ad_20, ad_20, ad_36);
                     DebugPrint("H@O3exit");
                  }
               }
            }
            processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
            return (1);
         }
      }
      if (ld_60 < ld_52) {
         memoryBar(ai_0, ad_4, ad_12, ad_20, ad_28, ad_36);
         DebugPrint("Unfinished bar... 9");
         return (1);
      }
   } else {
      if (ld_60 > ld_52) {
         ld_100 = NormalizeDouble(MathAbs(ad_4 - ad_12), Digits);
         if (ld_100 > ld_52) {
            if (ad_4 - ad_12 >= ld_52) {
               ld_92 = ad_4 - ld_52;
               updateHistory(ai_0, ad_4, ld_92, ad_4, ld_92, ad_36, ai_48);
               memoryBar(ai_0, ld_92, ad_12, ad_20, ad_28, ad_36);
               processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
               return (1);
            }
            ld_84 = ad_12 + ld_52;
            updateHistory(ai_0, ad_4, ad_12, ld_84, ld_84, ad_36, ai_48);
            memoryBar(ai_0, ld_84, ld_84, ad_20, ld_84, ad_36);
            processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
            return (1);
         }
         if (ld_100 == ld_52) {
            updateHistory(ai_0, ad_4, ad_12, ad_4, ad_4, ad_36, ai_48);
            memoryBar(ai_0, ad_4, ad_4, ad_20, ad_28, ad_36);
            processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
            return (1);
         }
         if (ld_100 < ld_52) {
            updateHistory(ai_0, ad_4, ad_12, ad_12 + ld_52, ad_12 + ld_52, ad_36, ai_48);
            if (ad_28 < ad_12 + ld_52 && ad_28 != ad_4) {
               memoryBar(ai_0, ad_12 + ld_52, ad_28, ad_20, ad_28, ad_36);
               DebugPrint("O2L1_exit");
            } else {
               if (ad_28 >= ad_12 + ld_52 && ad_28 != ad_4) {
                  memoryBar(ai_0, ad_12 + ld_52, ad_12 + ld_52, ad_20, ad_28, ad_36);
                  DebugPrint("O2L2_exit");
               } else {
                  if (ad_28 < ad_12 + ld_52 && ad_28 == ad_4) {
                     memoryBar(ai_0, ad_12 + ld_52, ad_12, ad_20, ad_12, ad_36);
                     DebugPrint("O2L3_exit");
                  } else {
                     if (ad_28 >= ad_12 + ld_52 && ad_28 == ad_4) {
                        DebugMsg("Untested275");
                        memoryBarClear();
                        return (0);
                     }
                  }
               }
            }
            processHistoryBar(ai_0, gd_124, gd_132, gd_140, gd_148, 1, 0);
            return (1);
         }
      }
      if (ld_60 < ld_52) {
         DebugPrint("Unfinished bar... 10");
         memoryBar(ai_0, ad_4, ad_12, ad_20, ad_28, ad_36);
         return (1);
      }
   }
   DebugPrint("END...");
   return (0);
}
