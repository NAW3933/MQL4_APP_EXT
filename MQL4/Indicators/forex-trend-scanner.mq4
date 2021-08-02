#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Lime
#property indicator_width1 3
#property indicator_color2 Red
#property indicator_width2 3
#property indicator_color3 Green
#property indicator_width3 3
#property indicator_color4 Maroon
#property indicator_width4 3
#property indicator_color5 Lime
#property indicator_color6 Red
#property indicator_color7 Green
#property indicator_color8 Maroon

extern int Sensitivity = 1;
int g_period_80;
int g_period_84;
double g_ibuf_88[];
double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
double g_ibuf_104[];
double g_ibuf_108[];
double g_ibuf_112[];
double g_ibuf_116[];

int init() {
   ObjectCreate("Close line", OBJ_HLINE, 0, Time[40], Close[0]);
   ObjectSet("Close line", OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet("Close line", OBJPROP_COLOR, DimGray);
   SetIndexStyle(0, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(0, g_ibuf_88);
   SetIndexStyle(1, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(1, g_ibuf_92);
   SetIndexStyle(2, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(2, g_ibuf_96);
   SetIndexStyle(3, DRAW_HISTOGRAM, EMPTY, 3);
   SetIndexBuffer(3, g_ibuf_100);
   SetIndexStyle(4, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(4, g_ibuf_104);
   SetIndexStyle(5, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(5, g_ibuf_108);
   SetIndexStyle(6, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(6, g_ibuf_112);
   SetIndexStyle(7, DRAW_HISTOGRAM, EMPTY, 0);
   SetIndexBuffer(7, g_ibuf_116);
   IndicatorShortName("NS");
   return (0);
}

int deinit() {
   ObjectDelete("Close line");
   Comment("");
   return (0);
}

int start() {
   double l_icci_0;
   double l_icci_8;
   int li_16;
   ObjectMove("Close line", 0, Time[20], Close[0]);
   if (Sensitivity == 1) {
      g_period_84 = 5;
      g_period_80 = 14;
   }
   if (Sensitivity == 0 || Sensitivity == 2 || Sensitivity > 3) {
      g_period_84 = 14;
      g_period_80 = 50;
   }
   if (Sensitivity == 3) {
      g_period_84 = 89;
      g_period_80 = 200;
   }
   int l_ind_counted_20 = IndicatorCounted();
   if (Bars <= 15) return (0);
   if (l_ind_counted_20 < 1) {
      for (int li_24 = 1; li_24 <= 15; li_24++) {
         g_ibuf_88[Bars - li_24] = 0.0;
         g_ibuf_96[Bars - li_24] = 0.0;
         g_ibuf_92[Bars - li_24] = 0.0;
         g_ibuf_100[Bars - li_24] = 0.0;
         g_ibuf_104[Bars - li_24] = 0.0;
         g_ibuf_112[Bars - li_24] = 0.0;
         g_ibuf_108[Bars - li_24] = 0.0;
         g_ibuf_116[Bars - li_24] = 0.0;
      }
   }
   if (l_ind_counted_20 > 0) li_16 = Bars - l_ind_counted_20;
   if (l_ind_counted_20 == 0) li_16 = Bars - 15 - 1;
   for (li_24 = li_16; li_24 >= 0; li_24--) {
      l_icci_0 = iCCI(NULL, 0, g_period_84, PRICE_TYPICAL, li_24);
      l_icci_8 = iCCI(NULL, 0, g_period_80, PRICE_TYPICAL, li_24);
      g_ibuf_88[li_24] = EMPTY_VALUE;
      g_ibuf_96[li_24] = EMPTY_VALUE;
      g_ibuf_92[li_24] = EMPTY_VALUE;
      g_ibuf_100[li_24] = EMPTY_VALUE;
      g_ibuf_104[li_24] = EMPTY_VALUE;
      g_ibuf_112[li_24] = EMPTY_VALUE;
      g_ibuf_108[li_24] = EMPTY_VALUE;
      g_ibuf_116[li_24] = EMPTY_VALUE;
      if (l_icci_0 >= 0.0 && l_icci_8 >= 0.0) {
         g_ibuf_88[li_24] = MathMax(Open[li_24], Close[li_24]);
         g_ibuf_92[li_24] = MathMin(Open[li_24], Close[li_24]);
         g_ibuf_104[li_24] = High[li_24];
         g_ibuf_108[li_24] = Low[li_24];
      } else {
         if (l_icci_8 >= 0.0 && l_icci_0 < 0.0) {
            g_ibuf_96[li_24] = MathMax(Open[li_24], Close[li_24]);
            g_ibuf_100[li_24] = MathMin(Open[li_24], Close[li_24]);
            g_ibuf_112[li_24] = High[li_24];
            g_ibuf_116[li_24] = Low[li_24];
         } else {
            if (l_icci_0 < 0.0 && l_icci_8 < 0.0) {
               g_ibuf_92[li_24] = MathMax(Open[li_24], Close[li_24]);
               g_ibuf_88[li_24] = MathMin(Open[li_24], Close[li_24]);
               g_ibuf_108[li_24] = High[li_24];
               g_ibuf_104[li_24] = Low[li_24];
            } else {
               if (l_icci_8 < 0.0 && l_icci_0 > 0.0) {
                  g_ibuf_100[li_24] = MathMax(Open[li_24], Close[li_24]);
                  g_ibuf_96[li_24] = MathMin(Open[li_24], Close[li_24]);
                  g_ibuf_116[li_24] = High[li_24];
                  g_ibuf_112[li_24] = Low[li_24];
               }
            }
         }
      }
   }
   return (0);
}