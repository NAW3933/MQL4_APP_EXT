/*
   Generated by EX4-TO-MQ4 decompiler V4.0.223.1a []
   Website: http://purebeam.biz
   E-mail : purebeam@gmail.com
*/
#property copyright "Copyright ? 2008, FOREXflash Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_minimum 0.0
#property indicator_maximum 30.0
#property indicator_buffers 8
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 White
#property indicator_color4 Lime
#property indicator_color5 Red
#property indicator_color6 White
#property indicator_color7 Red
#property indicator_color8 Lime

extern bool ShowText = TRUE;
extern int Corner = 1;
double gd_84;
double gd_92;
double g_ibuf_108[];
double g_ibuf_112[];
double g_ibuf_116[];
double g_ibuf_120[];
double g_ibuf_124[];
double g_ibuf_128[];
double g_ibuf_132[];
double g_ibuf_136[];
int g_shift_140 = -1;

int init() {
   /*string ls_0 = "2009.07.06";
   int l_str2time_8 = StrToTime(ls_0);
   if (TimeCurrent() >= l_str2time_8) {
      Alert("The trial version expired! Contact forexflash@gmail.com");
      return (1);
   }*/
   SetIndexBuffer(0, g_ibuf_108);
   SetIndexBuffer(1, g_ibuf_112);
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_NONE);
   SetIndexBuffer(2, g_ibuf_116);
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(2, 159);
   SetIndexLabel(2, "TickDiffNone");
   SetIndexBuffer(3, g_ibuf_120);
   SetIndexStyle(3, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(3, 159);
   SetIndexLabel(3, "TickDiffNeg");
   SetIndexBuffer(4, g_ibuf_124);
   SetIndexStyle(4, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(4, 159);
   SetIndexLabel(4, "TickDiffPos");
   SetIndexBuffer(5, g_ibuf_128);
   SetIndexStyle(5, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(5, 159);
   SetIndexLabel(5, "DivergenceNone");
   SetIndexBuffer(6, g_ibuf_132);
   SetIndexStyle(6, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(6, 159);
   SetIndexLabel(6, "DivergenceBullish");
   SetIndexBuffer(7, g_ibuf_136);
   SetIndexStyle(7, DRAW_ARROW, STYLE_SOLID);
   SetIndexArrow(7, 159);
   SetIndexLabel(7, "DivergenceBearish");
   IndicatorDigits(0);
   IndicatorShortName("VSA?TickDifferenceSignals&Divergence");
   if (ShowText == TRUE) draw_objects();
   return (0);
}

int deinit() {
   ObjectsDeleteAll(0, OBJ_LABEL);
   return (0);
}

int start() {
   int l_shift_4;
   if (ShowText == TRUE) draw_objects();
   for (int li_0 = 0; li_0 < iBars(Symbol(), PERIOD_M1); li_0++) {
      l_shift_4 = iBarShift(Symbol(), Period(), iTime(Symbol(), PERIOD_M1, li_0), TRUE);
      if (g_shift_140 != l_shift_4) {
         gd_84 = 0;
         gd_92 = 0;
         g_ibuf_108[l_shift_4] = 0;
         g_ibuf_112[l_shift_4] = 0;
      }
      if (l_shift_4 != -1) {
         if (iClose(Symbol(), PERIOD_M1, li_0) > iClose(Symbol(), PERIOD_M1, li_0 + 1)) gd_84 += iVolume(Symbol(), PERIOD_M1, li_0);
         if (iClose(Symbol(), PERIOD_M1, li_0) < iClose(Symbol(), PERIOD_M1, li_0 + 1)) gd_92 += iVolume(Symbol(), PERIOD_M1, li_0);
         if (iClose(Symbol(), PERIOD_M1, li_0) == iClose(Symbol(), PERIOD_M1, li_0 + 1)) {
            gd_84 += iVolume(Symbol(), PERIOD_M1, li_0) / 2.0;
            gd_92 += iVolume(Symbol(), PERIOD_M1, li_0) / 2.0;
         }
      }
      g_ibuf_108[l_shift_4] = gd_84;
      g_ibuf_112[l_shift_4] = gd_92;
      g_shift_140 = l_shift_4;
   }
   BST();
   Div();
   return (0);
}

void BST() {
   for (int l_index_0 = 0; l_index_0 < 500; l_index_0++) {
      g_ibuf_116[l_index_0] = 20;
      if (g_ibuf_108[l_index_0] / 2.0 > g_ibuf_112[l_index_0]) g_ibuf_120[l_index_0] = 20;
      if (g_ibuf_112[l_index_0] / 2.0 > g_ibuf_108[l_index_0]) g_ibuf_124[l_index_0] = 20;
   }
}

void Div() {
   for (int l_index_0 = 0; l_index_0 < 500; l_index_0++) {
      g_ibuf_128[l_index_0] = 5;
      if (Close[l_index_0] > Open[l_index_0 + 1] && Volume[l_index_0] < Volume[l_index_0 + 1] && Close[l_index_0 + 1] > Open[l_index_0 + 2] && Volume[l_index_0 + 1] < Volume[l_index_0 +
         2]) g_ibuf_132[l_index_0] = 5;
      if (Close[l_index_0] < Open[l_index_0 + 1] && Volume[l_index_0] < Volume[l_index_0 + 1] && Close[l_index_0 + 1] < Open[l_index_0 + 2] && Volume[l_index_0 + 1] < Volume[l_index_0 +
         2]) g_ibuf_136[l_index_0] = 5;
   }
}

void draw_objects() {
   ObjectCreate("VBox1s", OBJ_LABEL, WindowFind("VSA?TickDifferenceSignals&Divergence"), 0, 0);
   ObjectSetText("VBox1s", "VSA?TickDifferenceSignals", 8, "Trebuchet MS", Orange);
   ObjectSet("VBox1s", OBJPROP_CORNER, Corner);
   ObjectSet("VBox1s", OBJPROP_XDISTANCE, 15);
   ObjectSet("VBox1s", OBJPROP_YDISTANCE, 0);
   ObjectCreate("VaBox1s", OBJ_LABEL, WindowFind("VSA?TickDifferenceSignals&Divergence"), 0, 0);
   ObjectSetText("VaBox1s", "VSA?DiverganceSignals", 8, "Trebuchet MS", Orange);
   ObjectSet("VaBox1s", OBJPROP_CORNER, Corner);
   ObjectSet("VaBox1s", OBJPROP_XDISTANCE, 15);
   ObjectSet("VaBox1s", OBJPROP_YDISTANCE, 10);
}