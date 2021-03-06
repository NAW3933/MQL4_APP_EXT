
#property indicator_separate_window
#property indicator_minimum -1.0
#property indicator_maximum 1.0
#property indicator_buffers 3
#property indicator_color1 DimGray
#property indicator_color2 DimGray
#property indicator_color3 Red

extern int trendPeriod = 2;
extern string timeFrame = "Current time frame";
double g_ibuf_88[];
double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
double g_ibuf_104[];
double g_ibuf_108[];
int gia_112[];
int g_timeframe_116;
string gs_120;

int init() {
   IndicatorBuffers(6);
   SetIndexBuffer(0, g_ibuf_92);
   SetIndexBuffer(1, g_ibuf_96);
   SetIndexBuffer(2, g_ibuf_88);
   SetIndexBuffer(3, g_ibuf_100);
   SetIndexBuffer(4, g_ibuf_104);
   SetIndexBuffer(5, g_ibuf_108);
   SetIndexLabel(0, NULL);
   SetIndexLabel(1, NULL);
   SetIndexLabel(2, "Trend direction & force");
   gs_120 = WindowExpertName();
   g_timeframe_116 = stringToTimeFrame(timeFrame);
   IndicatorShortName("Trend direction & force" + TimeFrameToString(g_timeframe_116) + " (" + trendPeriod + ")");
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double ld_0;
   double ld_8;
   double ld_16;
   double ld_24;
   double ld_32;
   int li_48;
   int l_index_52;
   int li_40 = IndicatorCounted();
   if (li_40 < 0) return (-1);
   if (li_40 > 0) li_40--;
   int li_44 = Bars - li_40;
   if (g_timeframe_116 != Period()) {
      li_44 = MathMax(li_44, g_timeframe_116 / Period());
      ArrayCopySeries(gia_112, 5, NULL, g_timeframe_116);
      li_48 = 0;
      l_index_52 = 0;
      while (li_48 < li_44) {
         if (Time[li_48] < gia_112[l_index_52]) l_index_52++;
         g_ibuf_88[li_48] = iCustom(NULL, g_timeframe_116, gs_120, trendPeriod, 2, l_index_52);
         g_ibuf_92[li_48] = 0.05;
         g_ibuf_96[li_48] = -0.05;
         li_48++;
      }
      return (0);
   }
   for (li_48 = li_44; li_48 >= 0; li_48--) g_ibuf_100[li_48] = iMA(NULL, 0, trendPeriod, 0, MODE_EMA, PRICE_CLOSE, li_48);
   for (li_48 = li_44; li_48 >= 0; li_48--) {
      g_ibuf_104[li_48] = iMAOnArray(g_ibuf_100, 0, trendPeriod, 0, MODE_EMA, li_48);
      ld_0 = g_ibuf_100[li_48] - (g_ibuf_100[li_48 + 1]);
      ld_8 = g_ibuf_104[li_48] - (g_ibuf_104[li_48 + 1]);
      ld_16 = MathAbs(g_ibuf_100[li_48] - g_ibuf_104[li_48]) / Point;
      ld_24 = (ld_0 + ld_8) / (2.0 * Point);
      g_ibuf_108[li_48] = ld_16 * MathPow(ld_24, 3);
      ld_32 = absHighest(g_ibuf_108, 3 * trendPeriod, li_48);
      if (ld_32 > 0.0) g_ibuf_88[li_48] = g_ibuf_108[li_48] / ld_32;
      else g_ibuf_88[li_48] = 0.0;
      g_ibuf_92[li_48] = 0.05;
      g_ibuf_96[li_48] = -0.05;
   }
   return (0);
}

double absHighest(double ada_0[], int ai_4, int ai_8) {
   double ld_ret_12 = 0.0;
   for (int li_20 = ai_4 - 1; li_20 >= 0; li_20--)
      if (ld_ret_12 < MathAbs(ada_0[ai_8 + li_20])) ld_ret_12 = MathAbs(ada_0[ai_8 + li_20]);
   return (ld_ret_12);
}

int stringToTimeFrame(string as_0) {
   int l_timeframe_8 = 0;
   as_0 = StringTrimLeft(StringTrimRight(StringUpperCase(as_0)));
   if (as_0 == "M1" || as_0 == "1") l_timeframe_8 = 1;
   if (as_0 == "M5" || as_0 == "5") l_timeframe_8 = 5;
   if (as_0 == "M15" || as_0 == "15") l_timeframe_8 = 15;
   if (as_0 == "M30" || as_0 == "30") l_timeframe_8 = 30;
   if (as_0 == "H1" || as_0 == "60") l_timeframe_8 = 60;
   if (as_0 == "H4" || as_0 == "240") l_timeframe_8 = 240;
   if (as_0 == "D1" || as_0 == "1440") l_timeframe_8 = 1440;
   if (as_0 == "W1" || as_0 == "10080") l_timeframe_8 = 10080;
   if (as_0 == "MN" || as_0 == "43200") l_timeframe_8 = 43200;
   if (l_timeframe_8 < Period()) l_timeframe_8 = Period();
   return (l_timeframe_8);
}

string TimeFrameToString(int ai_0) {
   string l_str_concat_4 = "";
   if (ai_0 != Period()) {
      switch (ai_0) {
      case 1:
         l_str_concat_4 = "M1";
         break;
      case 5:
         l_str_concat_4 = "M5";
         break;
      case 15:
         l_str_concat_4 = "M15";
         break;
      case 30:
         l_str_concat_4 = "M30";
         break;
      case 60:
         l_str_concat_4 = "H1";
         break;
      case 240:
         l_str_concat_4 = "H4";
         break;
      case 1440:
         l_str_concat_4 = "D1";
         break;
      case 10080:
         l_str_concat_4 = "W1";
         break;
      case 43200:
         l_str_concat_4 = "MN1";
      }
      l_str_concat_4 = StringConcatenate(" ", l_str_concat_4);
   }
   return (l_str_concat_4);
}

string StringUpperCase(string as_0) {
   int li_20;
   string ls_ret_8 = as_0;
   for (int li_16 = StringLen(as_0) - 1; li_16 >= 0; li_16--) {
      li_20 = StringGetChar(ls_ret_8, li_16);
      if ((li_20 > '`' && li_20 < '{') || (li_20 > '?' && li_20 < 256)) ls_ret_8 = StringSetChar(ls_ret_8, li_16, li_20 - 32);
      else
         if (li_20 > -33 && li_20 < 0) ls_ret_8 = StringSetChar(ls_ret_8, li_16, li_20 + 224);
   }
   return (ls_ret_8);
}
