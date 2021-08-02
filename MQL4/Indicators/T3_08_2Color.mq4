//+------------------------------------------------------------------+
//|                                                     T3 clean.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Aqua
#property indicator_color2 C'0x00,0x5A,0xFF'
#property indicator_color3 Black

extern int T3Period = 8;
extern int T3Price = 0;
extern double b = 0.618;
extern string TimeFrame = "current time frame";
extern int BarCount = 1500;
double G_ibuf_104[];
double G_ibuf_108[];
double G_ibuf_112[];
double Gd_116;
double Gd_124;
double Gd_132;
double Gd_140;
double Gd_148;
double Gd_156;
double Gd_164;
double Gd_172;
double Gd_180;
double Gd_188;
double Gd_196;
double Gd_204;
double Gd_212;
double Gd_220;
int Gi_228;
double Gda_232[];
double Gda_236[];
double Gda_240[];
double Gda_244[];
double Gda_248[];
double Gda_252[];
double Gda_256[];
int G_time_260 = -999999;
int Gi_unused_264 = -999999;
int Gi_268;
string Gs_272;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   SetIndexBuffer(0, G_ibuf_104);
   SetIndexBuffer(1, G_ibuf_108);
   SetIndexBuffer(2, G_ibuf_112);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID);
   SetIndexStyle(2, DRAW_NONE);
   ArrayResize(Gda_232, BarCount);
   ArraySetAsSeries(Gda_232, TRUE);
   ArrayResize(Gda_236, BarCount);
   ArraySetAsSeries(Gda_236, TRUE);
   ArrayResize(Gda_240, BarCount);
   ArraySetAsSeries(Gda_240, TRUE);
   ArrayResize(Gda_244, BarCount);
   ArraySetAsSeries(Gda_244, TRUE);
   ArrayResize(Gda_248, BarCount);
   ArraySetAsSeries(Gda_248, TRUE);
   ArrayResize(Gda_252, BarCount);
   ArraySetAsSeries(Gda_252, TRUE);
   ArrayResize(Gda_256, BarCount);
   ArraySetAsSeries(Gda_256, TRUE);
   G_time_260 = Time[0];
   SetIndexLabel(0, NULL);
   SetIndexLabel(1, NULL);
   SetIndexLabel(2, "T3 Moving Average " + f0_3(Gi_268) + "(" + T3Period + ")");
   Gi_268 = f0_2(TimeFrame);
   IndicatorShortName("T3 Moving Average " + f0_3(Gi_268) + "(" + T3Period + ")");
   Gs_272 = WindowExpertName();
   if (Gi_228 != T3Period) {
      Gi_228 = T3Period;
      Gd_212 = b * b;
      Gd_220 = Gd_212 * b;
      Gd_164 = -Gd_220;
      Gd_172 = 3.0 * (Gd_212 + Gd_220);
      Gd_180 = -3.0 * (2.0 * Gd_212 + b + Gd_220);
      Gd_188 = 3.0 * b + 1.0 + Gd_220 + 3.0 * Gd_212;
      Gd_196 = 2 / ((MathMax(1, T3Period) - 1.0) / 2.0 + 2.0);
      Gd_204 = 1 - Gd_196;
   }
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double ima_12;
   int Li_0 = IndicatorCounted();
   if (Time[0] != G_time_260) f0_0();
   if (Li_0 < 0) return (-1);
   if (Li_0 > 0) Li_0--;
   int Li_8 = MathMin(BarCount, Bars - 1 - Li_0);
   for (int Li_4 = Li_8; Li_4 >= 0; Li_4--) {
      ima_12 = iMA(NULL, 0, 1, 0, MODE_SMA, T3Price, Li_4);
      Gd_116 = Gd_196 * ima_12 + Gd_204 * (Gda_232[Li_4 + 1]);
      Gd_124 = Gd_196 * Gd_116 + Gd_204 * (Gda_236[Li_4 + 1]);
      Gd_132 = Gd_196 * Gd_124 + Gd_204 * (Gda_240[Li_4 + 1]);
      Gd_140 = Gd_196 * Gd_132 + Gd_204 * (Gda_244[Li_4 + 1]);
      Gd_148 = Gd_196 * Gd_140 + Gd_204 * (Gda_248[Li_4 + 1]);
      Gd_156 = Gd_196 * Gd_148 + Gd_204 * (Gda_252[Li_4 + 1]);
      G_ibuf_112[Li_4] = Gd_164 * Gd_156 + Gd_172 * Gd_148 + Gd_180 * Gd_140 + Gd_188 * Gd_132;
      Gda_232[Li_4] = Gd_116;
      Gda_236[Li_4] = Gd_124;
      Gda_240[Li_4] = Gd_132;
      Gda_244[Li_4] = Gd_140;
      Gda_248[Li_4] = Gd_148;
      Gda_252[Li_4] = Gd_156;
   }
   for (int Li_20 = Li_8 - 1; Li_20 >= 0; Li_20--) {
      Gda_256[Li_20] = Gda_256[Li_20 + 1];
      if (G_ibuf_112[Li_20] > G_ibuf_112[Li_20 + 1]) Gda_256[Li_20] = 1;
      if (G_ibuf_112[Li_20] < G_ibuf_112[Li_20 + 1]) Gda_256[Li_20] = -1;
      if (Gda_256[Li_20] > 0.0) {
         G_ibuf_104[Li_20] = G_ibuf_112[Li_20];
         if (Gda_256[Li_20 + 1] < 0.0) G_ibuf_104[Li_20 + 1] = G_ibuf_112[Li_20 + 1];
         G_ibuf_108[Li_20] = EMPTY_VALUE;
      } else {
         if (Gda_256[Li_20] < 0.0) {
            G_ibuf_108[Li_20] = G_ibuf_112[Li_20];
            if (Gda_256[Li_20 + 1] > 0.0) G_ibuf_108[Li_20 + 1] = G_ibuf_112[Li_20 + 1];
            G_ibuf_104[Li_20] = EMPTY_VALUE;
         }
      }
   }
   return (0);
}

// B9EDCDEA151586E355292E7EA9BE516E
int f0_2(string As_0) {
   int timeframe_8 = 0;
   As_0 = StringTrimLeft(StringTrimRight(f0_1(As_0)));
   if (As_0 == "M1" || As_0 == "1") timeframe_8 = 1;
   if (As_0 == "M5" || As_0 == "5") timeframe_8 = 5;
   if (As_0 == "M15" || As_0 == "15") timeframe_8 = 15;
   if (As_0 == "M30" || As_0 == "30") timeframe_8 = 30;
   if (As_0 == "H1" || As_0 == "60") timeframe_8 = 60;
   if (As_0 == "H4" || As_0 == "240") timeframe_8 = 240;
   if (As_0 == "D1" || As_0 == "1440") timeframe_8 = 1440;
   if (As_0 == "W1" || As_0 == "10080") timeframe_8 = 10080;
   if (As_0 == "MN" || As_0 == "43200") timeframe_8 = 43200;
   if (timeframe_8 < Period()) timeframe_8 = Period();
   return (timeframe_8);
}

// BE5275EB85F7B577DA8FD065F994B740
string f0_3(int Ai_0) {
   string Ls_ret_4 = "";
   if (Ai_0 != Period()) {
      switch (Ai_0) {
      case 1:
         Ls_ret_4 = "M1";
         break;
      case 5:
         Ls_ret_4 = "M5";
         break;
      case 15:
         Ls_ret_4 = "M15";
         break;
      case 30:
         Ls_ret_4 = "M30";
         break;
      case 60:
         Ls_ret_4 = "H1";
         break;
      case 240:
         Ls_ret_4 = "H4";
         break;
      case 1440:
         Ls_ret_4 = "D1";
         break;
      case 10080:
         Ls_ret_4 = "W1";
         break;
      case 43200:
         Ls_ret_4 = "MN1";
      }
   }
   return (Ls_ret_4);
}

// 92DFF40263F725411B5FB6096A8D564E
string f0_1(string As_0) {
   int Li_20;
   string Ls_ret_8 = As_0;
   for (int Li_16 = StringLen(As_0) - 1; Li_16 >= 0; Li_16--) {
      Li_20 = StringGetChar(Ls_ret_8, Li_16);
      if ((Li_20 > '`' && Li_20 < '{') || (Li_20 > 'ß' && Li_20 < 256)) Ls_ret_8 = StringSetChar(Ls_ret_8, Li_16, Li_20 - 32);
      else
         if (Li_20 > -33 && Li_20 < 0) Ls_ret_8 = StringSetChar(Ls_ret_8, Li_16, Li_20 + 224);
   }
   return (Ls_ret_8);
}

// 001265269AEC7C79F32AB4F9E855729E
void f0_0() {
   for (int Li_0 = BarCount - 1; Li_0 >= 0; Li_0--) {
      Gda_232[Li_0 + 1] = Gda_232[Li_0];
      Gda_236[Li_0 + 1] = Gda_236[Li_0];
      Gda_240[Li_0 + 1] = Gda_240[Li_0];
      Gda_244[Li_0 + 1] = Gda_244[Li_0];
      Gda_248[Li_0 + 1] = Gda_248[Li_0];
      Gda_252[Li_0 + 1] = Gda_252[Li_0];
      Gda_256[Li_0 + 1] = Gda_256[Li_0];
   }
   G_time_260 = Time[0];
}
