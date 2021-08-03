/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website:  ht TP : / / wWw. me T aQ Uo tE S.N E t
   E-mail : S u P P O R t@ M EtA Q uo t E s.Net
*/
#property copyright "BPS Auto Harmonic Patterns      Copyright © 2011     Barry Stander              fx1@4africa.net"
#property link      "http://www.4Africa.net/4meta/"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Green
#property indicator_color4 Yellow
#property indicator_color5 Yellow
#property indicator_color6 Black
#property indicator_color7 Orange
#property indicator_color8 DarkViolet

#import "shell32.dll"
   int ShellExecuteA(int a0, int a1, string a2, string a3, string a4, int a5);
#import "user32.dll"
   int GetDC(int a0);
   int ReleaseDC(int a0, int a1);
#import "gdi32.dll"
   int GetPixel(int a0, int a1, int a2);
#import "Tools4Meta.dll"
   double DataPass(int a0, int a1, int a2, double a3, double a4, double a5);
#import

string Gs_76 = "BPS Auto Harmonic Patterns Version 1.7 17/07/2011     Copyright © 2012     Barry Stander        fx1@4africa.net  ,   Pretoria   ,   South Africa ";
int Gi_unused_84 = 300;
extern bool Predict_Pattern = TRUE;
extern bool Show_Fibo_Levels = FALSE;
extern bool Show_Old_Pattern = TRUE;
extern bool Show_Old_Pattern_Fibo = FALSE;
bool Gi_108 = TRUE;
bool Gi_112 = FALSE;
extern bool Fill_Pattern = TRUE;
extern int Histo = 30;
int Gi_124 = 1;
double Gd_128 = 161.0;
double Gd_136 = 127.0;
int G_width_144 = 2;
int G_fontsize_148 = 15;
int G_fontsize_152 = 10;
int Gi_156 = 0;
bool Gi_160 = FALSE;
int Gi_unused_164 = 0;
bool Gi_168 = FALSE;
extern bool show_points = FALSE;
int Gi_unused_176 = 0;
int Gi_unused_180;
int Gi_184;
int Gi_188 = 2;
int G_count_192;
double G_ibuf_196[];
double G_ibuf_200[];
double G_ibuf_204[];
double G_ibuf_208[];
double G_ibuf_212[];
double G_ibuf_216[];
int Gi_220;
double G_ibuf_228[];
int Gia_232[101];
double Gda_236[101];
double Gda_unused_240[];
int Gia_244[2];
double Gda_248[2];
int Gia_252[2];
double Gda_256[2];
int Gia_unused_260[10];
double Gda_unused_264[10];
int Gia_unused_268[10];
double Gda_unused_272[10];
int G_count_276;
int G_count_280;
int Gi_unused_284;
int Gi_unused_288;
int Gi_292 = 0;
int Gi_296 = 0;
int Gi_unused_300 = 0;
int Gi_unused_304 = 0;
string Gs_308;

// C6E190B284633C48E39E55049DA3CCE8
int f0_2(int Ai_0) {
   if (IsDllsAllowed() == FALSE) {
      Alert("DLL call is not allowed. Please switch on    Allow DDL import");
      Print("DLL call is not allowed. Please switch on    Allow DDL import");
      Comment("DLL call is not allowed. Please switch on    Allow DDL import");
   }
   MathSrand(TimeLocal());
   double Ld_4 = MathMod(MathRand(), Ai_0);
   if (Ld_4 > -1.0 && Ld_4 < 1.0) ShellExecuteA(0, 0, "http://www.4africa.net", 0, 0, 3);
   if (Ld_4 > Ai_0 - 1 && Ld_4 < Ai_0 + 1) ShellExecuteA(0, 0, "http://www.4africa.net/index3.htm", 0, 0, 3);
   return (0);
}

// 1A179E6A3AD18F923BCB0AC5EE09221D
int f0_1() {
   ObjectDelete("HarPat0mp");
   ObjectDelete("HarPat1mp");
   ObjectDelete("HarPat2mp");
   ObjectDelete("HarPat3mp");
   ObjectDelete("HarPat4mp");
   ObjectDelete("HarPat5mp");
   ObjectDelete("HarPat6mp");
   ObjectDelete("HarPat7mp");
   ObjectDelete("HarPat8mp");
   ObjectDelete("HarPat9mp");
   ObjectDelete("HarPat10mp");
   ObjectDelete("HarPat11mp");
   ObjectDelete("HarPat12mp");
   ObjectDelete("HarPat13mp");
   ObjectDelete("HarPat14mp");
   ObjectDelete("HarPat15mp");
   ObjectDelete("HarPat16mp");
   ObjectDelete("HarPat17mp");
   ObjectDelete("HarPat18mp");
   ObjectDelete("HarPat19mp");
   ObjectDelete("HarPat20mp");
   ObjectDelete("HarPat21mp");
   ObjectDelete("HarPat22mp");
   ObjectDelete("HarPat0wp");
   ObjectDelete("HarPat1wp");
   ObjectDelete("HarPat2wp");
   ObjectDelete("HarPat3wp");
   ObjectDelete("HarPat4wp");
   ObjectDelete("HarPat5wp");
   ObjectDelete("HarPat6wp");
   ObjectDelete("HarPat7wp");
   ObjectDelete("HarPat8wp");
   ObjectDelete("HarPat9wp");
   ObjectDelete("HarPat10wp");
   ObjectDelete("HarPat11wp");
   ObjectDelete("HarPat12wp");
   ObjectDelete("HarPat13wp");
   ObjectDelete("HarPat14wp");
   ObjectDelete("HarPat15wp");
   ObjectDelete("HarPat16wp");
   ObjectDelete("HarPat17wp");
   ObjectDelete("HarPat18wp");
   ObjectDelete("HarPat19wp");
   ObjectDelete("HarPat20wp");
   ObjectDelete("HarPat21wp");
   ObjectDelete("HarPat22wp");
   return (0);
}

// 0FA758BAF5F3212D9E63DDAD25F4DE20
int f0_0() {
   for (int count_0 = 0; count_0 <= Gi_124; count_0++) {
      ObjectDelete("HarPat0m" + count_0);
      ObjectDelete("HarPat1m" + count_0);
      ObjectDelete("HarPat2m" + count_0);
      ObjectDelete("HarPat3m" + count_0);
      ObjectDelete("HarPat4m" + count_0);
      ObjectDelete("HarPat5m" + count_0);
      ObjectDelete("HarPat6m" + count_0);
      ObjectDelete("HarPat7m" + count_0);
      ObjectDelete("HarPat8m" + count_0);
      ObjectDelete("HarPat9m" + count_0);
      ObjectDelete("HarPat10m" + count_0);
      ObjectDelete("HarPat11m" + count_0);
      ObjectDelete("HarPat12m" + count_0);
      ObjectDelete("HarPat13m" + count_0);
      ObjectDelete("HarPat14m" + count_0);
      ObjectDelete("HarPat15m" + count_0);
      ObjectDelete("HarPat16m" + count_0);
      ObjectDelete("HarPat17m" + count_0);
      ObjectDelete("HarPat18m" + count_0);
      ObjectDelete("HarPat19m" + count_0);
      ObjectDelete("HarPat21m" + count_0);
      ObjectDelete("HarPat22m" + count_0);
      ObjectDelete("HarPat0w" + count_0);
      ObjectDelete("HarPat1w" + count_0);
      ObjectDelete("HarPat2w" + count_0);
      ObjectDelete("HarPat3w" + count_0);
      ObjectDelete("HarPat4w" + count_0);
      ObjectDelete("HarPat5w" + count_0);
      ObjectDelete("HarPat6w" + count_0);
      ObjectDelete("HarPat7w" + count_0);
      ObjectDelete("HarPat8w" + count_0);
      ObjectDelete("HarPat9w" + count_0);
      ObjectDelete("HarPat10w" + count_0);
      ObjectDelete("HarPat11w" + count_0);
      ObjectDelete("HarPat12w" + count_0);
      ObjectDelete("HarPat13w" + count_0);
      ObjectDelete("HarPat14w" + count_0);
      ObjectDelete("HarPat15w" + count_0);
      ObjectDelete("HarPat16w" + count_0);
      ObjectDelete("HarPat17w" + count_0);
      ObjectDelete("HarPat18w" + count_0);
      ObjectDelete("HarPat19w" + count_0);
      ObjectDelete("HarPat21w" + count_0);
      ObjectDelete("HarPat22w" + count_0);
   }
   ObjectDelete("HarPat20m");
   ObjectDelete("HarPat20w");
   return (0);
}

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   if (IsDllsAllowed() == FALSE) {
      Alert("DLL call is not allowed. Please switch on    Allow DDL import");
      Print("DLL call is not allowed. Please switch on    Allow DDL import");
      Comment("DLL call is not allowed. Please switch on    Allow DDL import");
   }
   Comment(Gs_76);
   f0_2(44);
   Gi_unused_180 = 0;
   IndicatorBuffers(8);
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_NONE);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexStyle(3, DRAW_NONE);
   SetIndexStyle(4, DRAW_NONE);
   SetIndexStyle(5, DRAW_NONE);
   SetIndexStyle(6, DRAW_NONE);
   SetIndexStyle(7, DRAW_NONE);
   if (show_points == TRUE) SetIndexStyle(0, DRAW_ARROW, EMPTY, 5, Red);
   SetIndexBuffer(0, G_ibuf_228);
   SetIndexBuffer(2, G_ibuf_196);
   SetIndexBuffer(3, G_ibuf_200);
   SetIndexBuffer(4, G_ibuf_204);
   SetIndexBuffer(5, G_ibuf_208);
   SetIndexBuffer(6, G_ibuf_212);
   SetIndexBuffer(7, G_ibuf_216);
   SetIndexLabel(0, "current");
   SetIndexLabel(1, "");
   SetIndexLabel(2, "bmode");
   SetIndexLabel(3, "b_D");
   SetIndexLabel(4, "b_C");
   SetIndexLabel(5, "smode");
   SetIndexLabel(6, "s_D");
   SetIndexLabel(7, "s_C");
   f0_1();
   f0_0();
   return (0);
}

// 52D46093050F38C27267BCE42543EF60
int deinit() {
   if (IsDllsAllowed() == FALSE) {
      Alert("DLL call is not allowed. Please switch on    Allow DDL import");
      Print("DLL call is not allowed. Please switch on    Allow DDL import");
      Comment("DLL call is not allowed. Please switch on    Allow DDL import");
   }
   f0_1();
   f0_0();
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_8;
   double Ld_16;
   double Ld_24;
   double Ld_32;
   double Ld_68;
   double Ld_112;
   double Ld_120;
   double Ld_128;
   double Ld_136;
   double Ld_144;
   double Ld_152;
   double Ld_160;
   double Ld_168;
   double Ld_176;
   double Ld_184;
   double Ld_192;
   double Ld_200;
   double Ld_208;
   double Ld_216;
   double Ld_224;
   double Ld_232;
   double Ld_240;
   double Ld_248;
   double Ld_256;
   double Ld_264;
   double Ld_272;
   double Ld_280;
   double Ld_296;
   double Ld_304;
   double Ld_312;
   double Ld_320;
   double Ld_332;
   double Ld_340;
   double Ld_348;
   double Ld_356;
   G_count_192 = 0;
   for (int count_0 = 0; count_0 < Histo; count_0++) {
      for (int count_4 = 0; count_4 < Histo; count_4++) {
         Ld_8 = ObjectGet("HarPat1m" + count_0, OBJPROP_PRICE1);
         Ld_16 = ObjectGet("HarPat1m" + ((count_0 + count_4)), OBJPROP_PRICE1);
         Ld_24 = ObjectGet("HarPat1w" + count_0, OBJPROP_PRICE1);
         Ld_32 = ObjectGet("HarPat1w" + ((count_0 + count_4)), OBJPROP_PRICE1);
         if ((Ld_8 == Ld_16 && Ld_8 > 0.0 && Ld_16 > 0.0) || (Ld_24 == Ld_32 && Ld_24 > 0.0 && Ld_32 > 0.0)) G_count_192++;
      }
   }
   if (G_count_192 > 0) {
      f0_1();
      f0_0();
   }
   int Li_40 = 0;
   int Li_44 = 0;
   int Li_48 = 2;
   double Ld_52 = 0;
   double Ld_60 = 0;
   int Li_unused_88 = 0;
   G_ibuf_196[0] = 0;
   G_ibuf_200[0] = 0;
   G_ibuf_204[0] = 0;
   G_ibuf_208[0] = 0;
   G_ibuf_212[0] = 0;
   G_ibuf_216[0] = 0;
   Gs_308 = "";
   if (Histo > 500) Histo = 500;
   Gi_184 = 3 * Histo;
   int ind_counted_84 = IndicatorCounted();
   int Li_76 = Gi_184 - Gi_188;
   if (Li_76 > Gi_188) Li_76 = Li_76 - Gi_188 - 1;
   if (ind_counted_84 == 0) {
      f0_1();
      f0_0();
   }
   while (Li_76 > Gi_188 - 1) {
      G_ibuf_228[Li_76] = 0;
      Ld_68 = Low[Li_76];
      for (int Li_80 = 1; Li_80 <= Gi_188; Li_80++)
         if (Low[Li_76 + Li_80] < Low[Li_76] || Low[Li_76 - Li_80] < Low[Li_76]) Ld_68 = 0;
      if (Ld_68 > 0.0) {
         if (Ld_60 != 0.0) {
            switch (Li_48) {
            case 1:
               if (Ld_68 >= Ld_60) break;
               G_ibuf_228[Li_40] = Ld_52;
               Gda_236[0] = G_ibuf_228[Li_40];
               Gia_232[0] = Li_40;
               Li_48 = 2;
               break;
            case 2:
               if (Ld_68 <= Ld_60) break;
               G_ibuf_228[Li_44] = Ld_60;
               Gda_236[0] = G_ibuf_228[Li_44];
               Gia_232[0] = Li_44;
               Li_48 = 1;
               if (Li_40 < Li_44) break;
               Ld_52 = 0;
               Li_40 = 0;
            }
         }
         Ld_60 = Ld_68;
         Li_44 = Li_76;
      }
      Ld_68 = High[Li_76];
      for (Li_80 = 1; Li_80 <= Gi_188; Li_80++)
         if (High[Li_76 + Li_80] > High[Li_76] || High[Li_76 - Li_80] > High[Li_76]) Ld_68 = 0;
      if (Ld_68 > 0.0) {
         if (Ld_52 != 0.0) {
            switch (Li_48) {
            case 1:
               if (Ld_68 >= Ld_52) break;
               G_ibuf_228[Li_40] = Ld_52;
               Gda_236[0] = G_ibuf_228[Li_40];
               Gia_232[0] = Li_40;
               Li_48 = 2;
               if (Li_44 < Li_40) break;
               Ld_60 = 0;
               Li_44 = 0;
               break;
            case 2:
               if (Ld_68 <= Ld_52) break;
               G_ibuf_228[Li_44] = Ld_60;
               Gda_236[0] = G_ibuf_228[Li_44];
               Gia_232[0] = Li_44;
               Li_48 = 1;
            }
         }
         Ld_52 = Ld_68;
         Li_40 = Li_76;
      }
      if (Gda_236[0] > 0.0 && Gda_236[0] != Gda_236[1]) {
         for (int Li_100 = Histo; Li_100 >= 0; Li_100--) {
            Gda_236[Li_100] = Gda_236[Li_100 - 1];
            Gia_232[Li_100] = Gia_232[Li_100 - 1];
         }
      }
      Li_76--;
   }
   if (Li_48 == 1) {
      G_ibuf_228[Li_40] = Ld_52;
      Gda_236[0] = G_ibuf_228[Li_40];
      Gia_232[0] = Li_40;
   } else {
      G_ibuf_228[Li_44] = Ld_60;
      Gda_236[0] = G_ibuf_228[Li_44];
      Gia_232[0] = Li_44;
   }
   if (Gda_236[0] > 0.0 && Gda_236[0] != Gda_236[1]) {
      for (int Li_104 = Histo; Li_104 >= 0; Li_104--) {
         Gda_236[Li_104] = Gda_236[Li_104 - 1];
         Gia_232[Li_104] = Gia_232[Li_104 - 1];
      }
   }
   G_count_276 = 0;
   G_count_280 = 0;
   Gi_unused_284 = 0;
   Gi_unused_288 = 0;
   for (int count_108 = 0; count_108 < Histo; count_108++) {
      if (Show_Old_Pattern == TRUE) {
         if (Gda_236[count_108 - 2] < Gda_236[count_108 - 1] && Gda_236[count_108 - 3] > Gda_236[count_108 - 2] && Gda_236[count_108 - 3] <= Gda_236[count_108 - 1] && Gda_236[count_108 - 4] < Gda_236[count_108 - 2] &&
            Gda_236[count_108 - 4] > 0.0 && Gia_232[count_108 - 1] > Gia_232[count_108 - 2] && Gia_232[count_108 - 2] > Gia_232[count_108 - 3] && Gia_232[count_108 - 3] > Gia_232[count_108 - 4] &&
            Gda_236[count_108 - 1] > Gda_236[count_108 - 0] && Gda_236[count_108 - 2] > Gda_236[count_108 - 0] && Gda_236[count_108 - 3] > Gda_236[count_108 - 0] && Gda_236[count_108 - 0] > 0.0 &&
            Gia_232[count_108 - 0] > Gia_232[count_108 - 1]) {
            G_count_276++;
            if (G_count_276 > Gi_124 - 1) G_count_276 = 0;
            Gi_220 = count_108 - 1;
            Gi_unused_300 = 2;
            G_ibuf_196[Gia_232[count_108 - 4]] = 2;
            G_ibuf_200[Gia_232[count_108 - 4]] = Gda_236[count_108 - 4];
            G_ibuf_204[Gia_232[count_108 - 4]] = Gda_236[count_108 - 3];
            if (Fill_Pattern == TRUE) {
               ObjectCreate("HarPat21m" + G_count_276, OBJ_TRIANGLE, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1],
                  Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
               ObjectCreate("HarPat22m" + G_count_276, OBJ_TRIANGLE, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3],
                  Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            }
            ObjectCreate("HarPat0m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            ObjectCreate("HarPat14m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0]);
            ObjectSetText("HarPat14m" + G_count_276, "      x   ", G_fontsize_148);
            ObjectCreate("HarPat15m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
            ObjectCreate("HarPat16m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat17m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 2] - (Gia_232[count_108 - 2] - (Gia_232[count_108 - 0])) / 2], Gda_236[count_108 - 2] - (Gda_236[count_108 - 2] - (Gda_236[count_108 - 0])) / 2.0);
            ObjectCreate("HarPat18m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 0] - (Gia_232[count_108 - 0] - (Gia_232[count_108 - 4])) / 2], Gda_236[count_108 - 0] - (Gda_236[count_108 - 0] - (Gda_236[count_108 - 4])) / 2.0);
            Ld_112 = MathAbs(Gda_236[count_108 - 1] - (Gda_236[count_108 - 2])) / Point / (MathAbs(Gda_236[count_108 - 1] - (Gda_236[count_108 - 0])) / Point);
            Ld_120 = MathAbs(Gda_236[count_108 - 4] - (Gda_236[count_108 - 1])) / Point / (MathAbs(Gda_236[count_108 - 1] - (Gda_236[count_108 - 0])) / Point);
            ObjectSetText("HarPat17m" + G_count_276, DoubleToStr(Ld_112, 3), G_fontsize_152);
            ObjectSetText("HarPat18m" + G_count_276, DoubleToStr(Ld_120, 3), G_fontsize_152);
            if (Gi_112 == TRUE) ObjectCreate("HarPat19m" + G_count_276, OBJ_FIBO, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            Gs_308 = " Buy at point D :  " + ((Gda_236[count_108 - 4]));
            if (ObjectFind("HarPat1m" + G_count_276) != 0) ObjectCreate("HarPat1m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
            ObjectCreate("HarPat2m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3]);
            ObjectCreate("HarPat3m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat4m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3]);
            ObjectCreate("HarPat5m" + G_count_276, OBJ_TREND, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat6m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 1] - (Gia_232[count_108 - 1] - (Gia_232[count_108 - 3])) / 2], Gda_236[count_108 - 1] - (Gda_236[count_108 - 1] - (Gda_236[count_108 - 3])) / 2.0);
            ObjectCreate("HarPat7m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 2] - (Gia_232[count_108 - 2] - (Gia_232[count_108 - 4])) / 2], Gda_236[count_108 - 2] - (Gda_236[count_108 - 2] - (Gda_236[count_108 - 4])) / 2.0);
            Ld_128 = MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 3])) / Point / (MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 1])) / Point + 0.0000001);
            Ld_136 = MathAbs(Gda_236[count_108 - 4] - (Gda_236[count_108 - 1])) / Point / (MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 1])) / Point + 0.0000001);
            ObjectSetText("HarPat6m" + G_count_276, DoubleToStr(Ld_128, 3), G_fontsize_152);
            ObjectSetText("HarPat7m" + G_count_276, DoubleToStr(Ld_136, 3), G_fontsize_152);
            if (Gi_112 == TRUE) {
               ObjectCreate("HarPat8m" + G_count_276, OBJ_FIBO, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
               ObjectCreate("HarPat9m" + G_count_276, OBJ_FIBO, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            }
            if (Show_Old_Pattern_Fibo == TRUE) ObjectCreate("HarPat20m", OBJ_FIBO, 0, Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat10m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectSetText("HarPat10m" + G_count_276, "       d   ", G_fontsize_148);
            ObjectCreate("HarPat11m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3]);
            ObjectSetText("HarPat11m" + G_count_276, "       c ", G_fontsize_148);
            ObjectCreate("HarPat12m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
            ObjectSetText("HarPat12m" + G_count_276, "       b   ", G_fontsize_148);
            ObjectCreate("HarPat13m" + G_count_276, OBJ_TEXT, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            ObjectSetText("HarPat13m" + G_count_276, "      a  ", G_fontsize_148);
         }
         if (Gda_236[count_108 - 2] > Gda_236[count_108 - 1] && Gda_236[count_108 - 3] < Gda_236[count_108 - 2] && Gda_236[count_108 - 3] >= Gda_236[count_108 - 1] && Gda_236[count_108 - 4] > Gda_236[count_108 - 2] &&
            Gda_236[count_108 - 4] > 0.0 && Gia_232[count_108 - 1] > Gia_232[count_108 - 2] && Gia_232[count_108 - 2] > Gia_232[count_108 - 3] && Gia_232[count_108 - 3] > Gia_232[count_108 - 4] &&
            Gda_236[count_108 - 1] < Gda_236[count_108 - 0] && Gda_236[count_108 - 2] < Gda_236[count_108 - 0] && Gda_236[count_108 - 3] < Gda_236[count_108 - 0] && Gda_236[count_108 - 0] > 0.0 &&
            Gia_232[count_108 - 0] > Gia_232[count_108 - 1]) {
            G_count_280++;
            if (G_count_280 > Gi_124 - 1) G_count_280 = 0;
            Gi_unused_304 = 2;
            G_ibuf_208[Gia_232[count_108 - 4]] = 2;
            G_ibuf_212[Gia_232[count_108 - 4]] = Gda_236[count_108 - 4];
            G_ibuf_216[Gia_232[count_108 - 4]] = Gda_236[count_108 - 3];
            if (Fill_Pattern == TRUE) {
               ObjectCreate("HarPat21w" + G_count_280, OBJ_TRIANGLE, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1],
                  Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
               ObjectCreate("HarPat22w" + G_count_280, OBJ_TRIANGLE, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3],
                  Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            }
            ObjectCreate("HarPat0w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            ObjectCreate("HarPat14w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0]);
            ObjectSetText("HarPat14w" + G_count_280, "X     ", G_fontsize_148);
            ObjectCreate("HarPat15w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
            ObjectCreate("HarPat16w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat17w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 2] - (Gia_232[count_108 - 2] - (Gia_232[count_108 - 0])) / 2], Gda_236[count_108 - 2] - (Gda_236[count_108 - 2] - (Gda_236[count_108 - 0])) / 2.0);
            ObjectCreate("HarPat18w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 0] - (Gia_232[count_108 - 0] - (Gia_232[count_108 - 4])) / 2], Gda_236[count_108 - 0] - (Gda_236[count_108 - 0] - (Gda_236[count_108 - 4])) / 2.0);
            Ld_144 = MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 1])) / Point / (MathAbs(Gda_236[count_108 - 0] - (Gda_236[count_108 - 1])) / Point);
            Ld_152 = MathAbs(Gda_236[count_108 - 4] - (Gda_236[count_108 - 1])) / Point / (MathAbs(Gda_236[count_108 - 0] - (Gda_236[count_108 - 1])) / Point);
            ObjectSetText("HarPat17w" + G_count_280, DoubleToStr(Ld_144, 3), G_fontsize_152);
            ObjectSetText("HarPat18w" + G_count_280, DoubleToStr(Ld_152, 3), G_fontsize_152);
            if (Gi_112 == TRUE) ObjectCreate("HarPat19w" + G_count_280, OBJ_FIBO, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 0]], Gda_236[count_108 - 0]);
            Gs_308 = " Sell at point D :  " + ((Gda_236[count_108 - 4]));
            ObjectCreate("HarPat1w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
            ObjectCreate("HarPat2w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3]);
            ObjectCreate("HarPat3w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat4w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3]);
            ObjectCreate("HarPat5w" + G_count_280, OBJ_TREND, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectCreate("HarPat6w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 1] - (Gia_232[count_108 - 1] - (Gia_232[count_108 - 3])) / 2], Gda_236[count_108 - 1] - (Gda_236[count_108 - 1] - (Gda_236[count_108 - 3])) / 2.0);
            ObjectCreate("HarPat7w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 2] - (Gia_232[count_108 - 2] - (Gia_232[count_108 - 4])) / 2], Gda_236[count_108 - 2] - (Gda_236[count_108 - 2] - (Gda_236[count_108 - 4])) / 2.0);
            Ld_160 = MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 3])) / Point / (MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 1])) / Point + 0.0000001);
            Ld_168 = MathAbs(Gda_236[count_108 - 4] - (Gda_236[count_108 - 1])) / Point / (MathAbs(Gda_236[count_108 - 2] - (Gda_236[count_108 - 1])) / Point + 0.0000001);
            ObjectSetText("HarPat6w" + G_count_280, DoubleToStr(Ld_160, 3), G_fontsize_152);
            ObjectSetText("HarPat7w" + G_count_280, DoubleToStr(Ld_168, 3), G_fontsize_152);
            if (Gi_112 == TRUE) {
               ObjectCreate("HarPat8w" + G_count_280, OBJ_FIBO, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
               ObjectCreate("HarPat9w" + G_count_280, OBJ_FIBO, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2], Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            }
            ObjectCreate("HarPat10w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 1]], Gda_236[count_108 - 1]);
            ObjectSetText("HarPat10w" + G_count_280, "A     ", G_fontsize_148);
            ObjectCreate("HarPat11w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 2]], Gda_236[count_108 - 2]);
            ObjectSetText("HarPat11w" + G_count_280, "B     ", G_fontsize_148);
            ObjectCreate("HarPat12w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3]);
            ObjectSetText("HarPat12w" + G_count_280, "C     ", G_fontsize_148);
            ObjectCreate("HarPat13w" + G_count_280, OBJ_TEXT, 0, Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
            ObjectSetText("HarPat13w" + G_count_280, "D     ", G_fontsize_148);
            if (Show_Old_Pattern_Fibo == TRUE) ObjectCreate("HarPat20w", OBJ_FIBO, 0, Time[Gia_232[count_108 - 3]], Gda_236[count_108 - 3], Time[Gia_232[count_108 - 4]], Gda_236[count_108 - 4]);
         }
         ObjectSet("HarPat0m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat1m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat2m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat3m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat4m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat5m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat15m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat16m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat0m" + G_count_276, OBJPROP_COLOR, Red);
         ObjectSet("HarPat1m" + G_count_276, OBJPROP_COLOR, Red);
         ObjectSet("HarPat2m" + G_count_276, OBJPROP_COLOR, Red);
         ObjectSet("HarPat3m" + G_count_276, OBJPROP_COLOR, Red);
         ObjectSet("HarPat4m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat5m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat6m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat7m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat8m" + G_count_276, OBJPROP_COLOR, Green);
         ObjectSet("HarPat9m" + G_count_276, OBJPROP_COLOR, Green);
         ObjectSet("HarPat10m" + G_count_276, OBJPROP_COLOR, DarkViolet);
         ObjectSet("HarPat11m" + G_count_276, OBJPROP_COLOR, DarkViolet);
         ObjectSet("HarPat12m" + G_count_276, OBJPROP_COLOR, DarkViolet);
         ObjectSet("HarPat13m" + G_count_276, OBJPROP_COLOR, DarkViolet);
         ObjectSet("HarPat14m" + G_count_276, OBJPROP_COLOR, DarkViolet);
         ObjectSet("HarPat15m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat16m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat17m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat18m" + G_count_276, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat19m" + G_count_276, OBJPROP_COLOR, Green);
         ObjectSet("HarPat20m", OBJPROP_COLOR, Blue);
         ObjectSet("HarPat21m" + G_count_276, OBJPROP_COLOR, Yellow);
         ObjectSet("HarPat22m" + G_count_276, OBJPROP_COLOR, Yellow);
         ObjectSet("HarPat0m" + G_count_276, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat1m" + G_count_276, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat2m" + G_count_276, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat3m" + G_count_276, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat4m" + G_count_276, OBJPROP_WIDTH, 0);
         ObjectSet("HarPat5m" + G_count_276, OBJPROP_WIDTH, 0);
         ObjectSet("HarPat4m" + G_count_276, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat5m" + G_count_276, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat8m" + G_count_276, OBJPROP_STYLE, STYLE_DASHDOTDOT);
         ObjectSet("HarPat9m" + G_count_276, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat15m" + G_count_276, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat16m" + G_count_276, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat19m" + G_count_276, OBJPROP_STYLE, STYLE_DASH);
         ObjectSet("HarPat20m", OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat8m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat9m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat19m" + G_count_276, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat20m", OBJPROP_RAY, FALSE);
         ObjectSet("HarPat0w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat1w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat2w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat3w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat4w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat5w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat15w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat16w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat0w" + G_count_280, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat1w" + G_count_280, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat2w" + G_count_280, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat3w" + G_count_280, OBJPROP_COLOR, Blue);
         ObjectSet("HarPat4w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat5w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat6w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat7w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat8w" + G_count_280, OBJPROP_COLOR, Green);
         ObjectSet("HarPat9w" + G_count_280, OBJPROP_COLOR, Green);
         ObjectSet("HarPat10w" + G_count_280, OBJPROP_COLOR, Black);
         ObjectSet("HarPat11w" + G_count_280, OBJPROP_COLOR, Black);
         ObjectSet("HarPat12w" + G_count_280, OBJPROP_COLOR, Black);
         ObjectSet("HarPat13w" + G_count_280, OBJPROP_COLOR, Black);
         ObjectSet("HarPat14w" + G_count_280, OBJPROP_COLOR, Black);
         ObjectSet("HarPat15w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat16w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat17w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat18w" + G_count_280, OBJPROP_COLOR, Red);
         ObjectSet("HarPat19w" + G_count_280, OBJPROP_COLOR, Green);
         ObjectSet("HarPat20w", OBJPROP_COLOR, Red);
         ObjectSet("HarPat21w" + G_count_280, OBJPROP_COLOR, Yellow);
         ObjectSet("HarPat22w" + G_count_280, OBJPROP_COLOR, Yellow);
         ObjectSet("HarPat0w" + G_count_280, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat1w" + G_count_280, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat2w" + G_count_280, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat3w" + G_count_280, OBJPROP_WIDTH, G_width_144);
         ObjectSet("HarPat4w" + G_count_280, OBJPROP_WIDTH, 0);
         ObjectSet("HarPat5w" + G_count_280, OBJPROP_WIDTH, 0);
         ObjectSet("HarPat4w" + G_count_280, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat5w" + G_count_280, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat8w" + G_count_280, OBJPROP_STYLE, STYLE_DASHDOTDOT);
         ObjectSet("HarPat9w" + G_count_280, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat15w" + G_count_280, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat16w" + G_count_280, OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat19w" + G_count_280, OBJPROP_STYLE, STYLE_DASH);
         ObjectSet("HarPat20w", OBJPROP_STYLE, STYLE_DOT);
         ObjectSet("HarPat8w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat9w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat19w" + G_count_280, OBJPROP_RAY, FALSE);
         ObjectSet("HarPat20w", OBJPROP_RAY, FALSE);
      }
   }
   if (Predict_Pattern == TRUE) {
      Ld_176 = MathAbs(Gda_236[3] - Gda_236[2]);
      Ld_184 = Gda_236[2] - Ld_176 / 100.0 * (Gd_128 - 100.0);
      Ld_192 = Gda_236[2] - Ld_176 / 100.0 * (Gd_136 - 100.0);
      if (Gda_236[2] < Gda_236[3] && Gda_236[1] > Gda_236[2] && Gda_236[1] <= Gda_236[3] && Gia_232[3] > Gia_232[2] && Gia_232[2] > Gia_232[1] && Gda_236[3] > Gda_236[4] &&
         Gda_236[2] > Gda_236[4] && Gda_236[1] > Gda_236[4] && Gia_232[4] > Gia_232[3]) {
         Gia_252[0] = 0;
         G_ibuf_196[Gia_232[0]] = 33;
         G_ibuf_200[Gia_252[0]] = Gda_256[0];
         G_ibuf_204[Gia_232[0]] = Gda_236[1];
         if (MathAbs(Gda_236[2] - Gda_236[1]) / Point / (MathAbs(Gda_236[2] - Gda_236[3]) / Point + 0.0000001) <= 0.707) Gda_256[0] = Ld_184;
         else Gda_256[0] = Ld_192;
         Gi_292 = 2;
         G_ibuf_196[Gia_232[0]] = 44;
         G_ibuf_200[Gia_252[0]] = Gda_256[0];
         G_ibuf_204[Gia_232[0]] = Gda_236[1];
         if (Fill_Pattern == TRUE) {
            ObjectCreate("HarPat21mp", OBJ_TRIANGLE, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[3]], Gda_236[3], Time[Gia_232[2]], Gda_236[2]);
            ObjectCreate("HarPat22mp", OBJ_TRIANGLE, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_232[1]], Gda_236[1], Time[Gia_244[0]], Gda_256[0]);
         }
         ObjectCreate("HarPat0mp", OBJ_TREND, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[3]], Gda_236[3]);
         ObjectCreate("HarPat14mp", OBJ_TEXT, 0, Time[Gia_232[4]], Gda_236[4]);
         ObjectSetText("HarPat14mp", "x    ", G_fontsize_148);
         ObjectCreate("HarPat15mp", OBJ_TREND, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[2]], Gda_236[2]);
         ObjectCreate("HarPat16mp", OBJ_TREND, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_252[0]], Gda_256[0]);
         ObjectCreate("HarPat17mp", OBJ_TEXT, 0, Time[Gia_232[2] - (Gia_232[2] - Gia_232[4]) / 2], Gda_236[2] - (Gda_236[2] - Gda_236[4]) / 2.0);
         ObjectCreate("HarPat18mp", OBJ_TEXT, 0, Time[Gia_232[4] - (Gia_232[4] - Gia_252[0]) / 2], Gda_236[4] - (Gda_236[4] - Gda_256[0]) / 2.0);
         Ld_200 = MathAbs(Gda_236[3] - Gda_236[2]) / Point / (MathAbs(Gda_236[3] - Gda_236[4]) / Point);
         Ld_208 = MathAbs(Gda_256[0] - Gda_236[3]) / Point / (MathAbs(Gda_236[3] - Gda_236[4]) / Point);
         ObjectSetText("HarPat17mp", DoubleToStr(Ld_200, 3), G_fontsize_152);
         ObjectSetText("HarPat18mp", DoubleToStr(Ld_208, 3), G_fontsize_152);
         if (Gi_112 == TRUE) {
            ObjectCreate("HarPat19mp", OBJ_FIBO, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[3]], Gda_236[3]);
            ObjectDelete("HarPat20m");
            ObjectDelete("HarPat20w");
         }
         Gs_308 = " Buy at point D :  " + Gda_256[0];
         ObjectCreate("HarPat1mp", OBJ_TREND, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_232[2]], Gda_236[2]);
         ObjectCreate("HarPat2mp", OBJ_TREND, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_232[1]], Gda_236[1]);
         ObjectCreate("HarPat3mp", OBJ_TREND, 0, Time[Gia_232[1]], Gda_236[1], Time[Gia_252[0]], Gda_256[0]);
         ObjectCreate("HarPat4mp", OBJ_TREND, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_232[1]], Gda_236[1]);
         ObjectCreate("HarPat5mp", OBJ_TREND, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_252[0]], Gda_256[0]);
         ObjectCreate("HarPat6mp", OBJ_TEXT, 0, Time[Gia_232[3] - (Gia_232[3] - Gia_232[1]) / 2], Gda_236[3] - (Gda_236[3] - Gda_236[1]) / 2.0);
         ObjectCreate("HarPat7mp", OBJ_TEXT, 0, Time[Gia_232[2] - (Gia_232[2] - Gia_252[0]) / 2], Gda_236[2] - (Gda_236[2] - Gda_256[0]) / 2.0);
         Ld_216 = MathAbs(Gda_236[2] - Gda_236[1]) / Point / (MathAbs(Gda_236[2] - Gda_236[3]) / Point + 0.0000001);
         Ld_224 = MathAbs(Gda_256[0] - Gda_236[3]) / Point / (MathAbs(Gda_236[2] - Gda_236[3]) / Point + 0.0000001);
         ObjectSetText("HarPat6mp", DoubleToStr(Ld_216, 3), G_fontsize_152);
         ObjectSetText("HarPat7mp", DoubleToStr(Ld_224, 3), G_fontsize_152);
         if (Gi_112 == TRUE) {
            ObjectCreate("HarPat8mp", OBJ_FIBO, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_252[0]], Gda_256[0]);
            ObjectCreate("HarPat9mp", OBJ_FIBO, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_232[3]], Gda_236[3]);
         }
         if (Show_Fibo_Levels == TRUE) {
            ObjectCreate("HarPat20mp", OBJ_FIBO, 0, Time[Gia_232[1]], Gda_236[1], Time[Gia_252[0]], Gda_256[0]);
            ObjectDelete("HarPat20m");
            ObjectDelete("HarPat20w");
         }
         ObjectCreate("HarPat10mp", OBJ_TEXT, 0, Time[Gia_232[3]], Gda_236[3]);
         ObjectSetText("HarPat10mp", "a     ", G_fontsize_148);
         ObjectCreate("HarPat11mp", OBJ_TEXT, 0, Time[Gia_232[2]], Gda_236[2]);
         ObjectSetText("HarPat11mp", "b   ", G_fontsize_148);
         ObjectCreate("HarPat12mp", OBJ_TEXT, 0, Time[Gia_232[1]], Gda_236[1]);
         ObjectSetText("HarPat12mp", "c    ", G_fontsize_148);
         ObjectCreate("HarPat13mp", OBJ_TEXT, 0, Time[Gia_252[0]], Gda_256[0]);
         ObjectSetText("HarPat13mp", "d   ", G_fontsize_148);
         if (High[iHighest(NULL, 0, MODE_HIGH, Gia_232[1], 0)] > Gda_236[1] && Gi_108 == TRUE) {
            ObjectDelete("HarPat0mp");
            ObjectDelete("HarPat1mp");
            ObjectDelete("HarPat2mp");
            ObjectDelete("HarPat3mp");
            ObjectDelete("HarPat4mp");
            ObjectDelete("HarPat5mp");
            ObjectDelete("HarPat6mp");
            ObjectDelete("HarPat7mp");
            ObjectDelete("HarPat8mp");
            ObjectDelete("HarPat9mp");
            ObjectDelete("HarPat10mp");
            ObjectDelete("HarPat11mp");
            ObjectDelete("HarPat12mp");
            ObjectDelete("HarPat13mp");
            ObjectDelete("HarPat14mp");
            ObjectDelete("HarPat15mp");
            ObjectDelete("HarPat16mp");
            ObjectDelete("HarPat17mp");
            ObjectDelete("HarPat18mp");
            ObjectDelete("HarPat19mp");
            ObjectDelete("HarPat20mp");
            ObjectDelete("HarPat21mp");
            ObjectDelete("HarPat22mp");
            Gi_292 = 0;
            G_ibuf_196[Gia_232[0]] = 0;
         }
         if ((Gda_256[0] > Bid && Gda_256[0] > Ask) || (Gda_236[1] < Bid && Gda_236[1] < Ask)) G_ibuf_196[Gia_232[0]] = -1;
      }
      Ld_232 = MathAbs(Gda_236[2] - Gda_236[3]);
      Ld_240 = Gda_236[2] + Ld_232 / 100.0 * (Gd_128 - 100.0);
      Ld_248 = Gda_236[2] + Ld_232 / 100.0 * (Gd_136 - 100.0);
      if (Gda_236[2] > Gda_236[3] && Gda_236[1] < Gda_236[2] && Gda_236[1] >= Gda_236[3] && Gia_232[3] > Gia_232[2] && Gia_232[2] > Gia_232[1] && Gda_236[3] < Gda_236[4] &&
         Gda_236[2] < Gda_236[4] && Gda_236[1] < Gda_236[4] && Gia_232[4] > Gia_232[3]) {
         Gia_244[0] = 0;
         G_ibuf_208[Gia_232[0]] = 33;
         G_ibuf_212[Gia_244[0]] = Gda_248[0];
         G_ibuf_216[Gia_232[0]] = Gda_236[1];
         if (MathAbs(Gda_236[2] - Gda_236[1]) / Point / (MathAbs(Gda_236[2] - Gda_236[3]) / Point + 0.0000001) <= 0.707) Gda_248[0] = Ld_240;
         else Gda_248[0] = Ld_248;
         Gi_296 = 2;
         G_ibuf_208[Gia_232[0]] = 44;
         G_ibuf_212[Gia_244[0]] = Gda_248[0];
         G_ibuf_216[Gia_232[0]] = Gda_236[1];
         if (Fill_Pattern == TRUE) {
            ObjectCreate("HarPat21wp", OBJ_TRIANGLE, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[3]], Gda_236[3], Time[Gia_232[2]], Gda_236[2]);
            ObjectCreate("HarPat22wp", OBJ_TRIANGLE, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_232[1]], Gda_236[1], Time[Gia_244[0]], Gda_248[0]);
         }
         ObjectCreate("HarPat0wp", OBJ_TREND, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[3]], Gda_236[3]);
         ObjectCreate("HarPat14wp", OBJ_TEXT, 0, Time[Gia_232[4]], Gda_236[4]);
         ObjectSetText("HarPat14wp", "X     ", G_fontsize_148);
         ObjectCreate("HarPat15wp", OBJ_TREND, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_232[2]], Gda_236[2]);
         ObjectCreate("HarPat16wp", OBJ_TREND, 0, Time[Gia_232[4]], Gda_236[4], Time[Gia_244[0]], Gda_248[0]);
         ObjectCreate("HarPat17wp", OBJ_TEXT, 0, Time[Gia_232[2] - (Gia_232[2] - Gia_232[4]) / 2], Gda_236[2] - (Gda_236[2] - Gda_236[4]) / 2.0);
         ObjectCreate("HarPat18wp", OBJ_TEXT, 0, Time[Gia_232[4] - (Gia_232[4] - Gia_244[0]) / 2], Gda_236[4] - (Gda_236[4] - Gda_248[0]) / 2.0);
         Ld_256 = MathAbs(Gda_236[2] - Gda_236[3]) / Point / (MathAbs(Gda_236[4] - Gda_236[3]) / Point);
         Ld_264 = MathAbs(Gda_248[0] - Gda_236[3]) / Point / (MathAbs(Gda_236[4] - Gda_236[3]) / Point);
         ObjectSetText("HarPat17wp", DoubleToStr(Ld_256, 3), G_fontsize_152);
         ObjectSetText("HarPat18wp", DoubleToStr(Ld_264, 3), G_fontsize_152);
         if (Gi_112 == TRUE) {
            ObjectCreate("HarPat19wp", OBJ_FIBO, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_232[4]], Gda_236[4]);
            ObjectDelete("HarPat20m");
            ObjectDelete("HarPat20w");
         }
         Gs_308 = " Sell at point D :  " + Gda_248[0];
         ObjectCreate("HarPat1wp", OBJ_TREND, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_232[2]], Gda_236[2]);
         ObjectCreate("HarPat2wp", OBJ_TREND, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_232[1]], Gda_236[1]);
         ObjectCreate("HarPat3wp", OBJ_TREND, 0, Time[Gia_232[1]], Gda_236[1], Time[Gia_244[0]], Gda_248[0]);
         ObjectCreate("HarPat4wp", OBJ_TREND, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_232[1]], Gda_236[1]);
         ObjectCreate("HarPat5wp", OBJ_TREND, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_244[0]], Gda_248[0]);
         ObjectCreate("HarPat6wp", OBJ_TEXT, 0, Time[Gia_232[3] - (Gia_232[3] - Gia_232[1]) / 2], Gda_236[3] - (Gda_236[3] - Gda_236[1]) / 2.0);
         ObjectCreate("HarPat7wp", OBJ_TEXT, 0, Time[Gia_232[2] - (Gia_232[2] - Gia_244[0]) / 2], Gda_236[2] - (Gda_236[2] - Gda_248[0]) / 2.0);
         Ld_272 = MathAbs(Gda_236[2] - Gda_236[1]) / Point / (MathAbs(Gda_236[2] - Gda_236[3]) / Point + 0.0000001);
         Ld_280 = MathAbs(Gda_248[0] - Gda_236[3]) / Point / (MathAbs(Gda_236[2] - Gda_236[3]) / Point + 0.0000001);
         ObjectSetText("HarPat6wp", DoubleToStr(Ld_272, 3), G_fontsize_152);
         ObjectSetText("HarPat7wp", DoubleToStr(Ld_280, 3), G_fontsize_152);
         if (Gi_112 == TRUE) {
            ObjectCreate("HarPat8wp", OBJ_FIBO, 0, Time[Gia_232[3]], Gda_236[3], Time[Gia_244[0]], Gda_248[0]);
            ObjectCreate("HarPat9wp", OBJ_FIBO, 0, Time[Gia_232[2]], Gda_236[2], Time[Gia_232[3]], Gda_236[3]);
         }
         if (Show_Fibo_Levels == TRUE) ObjectCreate("HarPat20wp", OBJ_FIBO, 0, Time[Gia_232[1]], Gda_236[1], Time[Gia_244[0]], Gda_248[0]);
         ObjectCreate("HarPat10wp", OBJ_TEXT, 0, Time[Gia_232[3]], Gda_236[3]);
         ObjectSetText("HarPat10wp", "A   ", G_fontsize_148);
         ObjectCreate("HarPat11wp", OBJ_TEXT, 0, Time[Gia_232[2]], Gda_236[2]);
         ObjectSetText("HarPat11wp", "B     ", G_fontsize_148);
         ObjectCreate("HarPat12wp", OBJ_TEXT, 0, Time[Gia_232[1]], Gda_236[1]);
         ObjectSetText("HarPat12wp", "C   ", G_fontsize_148);
         ObjectCreate("HarPat13wp", OBJ_TEXT, 0, Time[Gia_244[0]], Gda_248[0]);
         ObjectSetText("HarPat13wp", "D     ", G_fontsize_148);
         if (Low[iLowest(NULL, 0, MODE_LOW, Gia_232[1], 0)] < Gda_236[1] && Gi_108 == TRUE) {
            ObjectDelete("HarPat0wp");
            ObjectDelete("HarPat1wp");
            ObjectDelete("HarPat2wp");
            ObjectDelete("HarPat3wp");
            ObjectDelete("HarPat4wp");
            ObjectDelete("HarPat5wp");
            ObjectDelete("HarPat6wp");
            ObjectDelete("HarPat7wp");
            ObjectDelete("HarPat8wp");
            ObjectDelete("HarPat9wp");
            ObjectDelete("HarPat10wp");
            ObjectDelete("HarPat11wp");
            ObjectDelete("HarPat12wp");
            ObjectDelete("HarPat13wp");
            ObjectDelete("HarPat14wp");
            ObjectDelete("HarPat15wp");
            ObjectDelete("HarPat16wp");
            ObjectDelete("HarPat17wp");
            ObjectDelete("HarPat18wp");
            ObjectDelete("HarPat19wp");
            ObjectDelete("HarPat20wp");
            ObjectDelete("HarPat21wp");
            ObjectDelete("HarPat22wp");
            Gi_296 = 0;
            G_ibuf_208[Gia_232[0]] = 0;
         }
         if ((Gda_248[0] < Bid && Gda_248[0] < Ask) || (Gda_236[1] > Bid && Gda_236[1] > Ask)) G_ibuf_208[Gia_232[0]] = -1;
      }
      ObjectSet("HarPat0mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat1mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat2mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat3mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat4mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat5mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat15mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat16mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat0mp", OBJPROP_COLOR, Orange);
      ObjectSet("HarPat1mp", OBJPROP_COLOR, Orange);
      ObjectSet("HarPat2mp", OBJPROP_COLOR, Orange);
      ObjectSet("HarPat3mp", OBJPROP_COLOR, Orange);
      ObjectSet("HarPat4mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat5mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat6mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat7mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat8mp", OBJPROP_COLOR, Green);
      ObjectSet("HarPat9mp", OBJPROP_COLOR, Green);
      ObjectSet("HarPat10mp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat11mp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat12mp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat13mp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat14mp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat15mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat16mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat17mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat18mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat19mp", OBJPROP_COLOR, Green);
      ObjectSet("HarPat20mp", OBJPROP_COLOR, Blue);
      ObjectSet("HarPat21mp", OBJPROP_COLOR, Yellow);
      ObjectSet("HarPat22mp", OBJPROP_COLOR, Yellow);
      ObjectSet("HarPat0mp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat1mp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat2mp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat3mp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat4mp", OBJPROP_WIDTH, 0);
      ObjectSet("HarPat5mp", OBJPROP_WIDTH, 0);
      ObjectSet("HarPat4mp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat5mp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat8mp", OBJPROP_STYLE, STYLE_DASHDOTDOT);
      ObjectSet("HarPat9mp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat15mp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat16mp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat19mp", OBJPROP_STYLE, STYLE_DASH);
      ObjectSet("HarPat20mp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat8mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat9mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat19mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat20mp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat0wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat1wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat2wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat3wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat4wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat5wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat15wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat16wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat0wp", OBJPROP_COLOR, DarkViolet);
      ObjectSet("HarPat1wp", OBJPROP_COLOR, DarkViolet);
      ObjectSet("HarPat2wp", OBJPROP_COLOR, DarkViolet);
      ObjectSet("HarPat3wp", OBJPROP_COLOR, DarkViolet);
      ObjectSet("HarPat4wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat5wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat6wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat7wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat8wp", OBJPROP_COLOR, Green);
      ObjectSet("HarPat9wp", OBJPROP_COLOR, Green);
      ObjectSet("HarPat10wp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat11wp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat12wp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat13wp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat14wp", OBJPROP_COLOR, Black);
      ObjectSet("HarPat15wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat16wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat17wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat18wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat19wp", OBJPROP_COLOR, Green);
      ObjectSet("HarPat20wp", OBJPROP_COLOR, Red);
      ObjectSet("HarPat21wp", OBJPROP_COLOR, Yellow);
      ObjectSet("HarPat22wp", OBJPROP_COLOR, Yellow);
      ObjectSet("HarPat0wp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat1wp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat2wp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat3wp", OBJPROP_WIDTH, G_width_144);
      ObjectSet("HarPat4wp", OBJPROP_WIDTH, 0);
      ObjectSet("HarPat5wp", OBJPROP_WIDTH, 0);
      ObjectSet("HarPat4wp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat5wp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat8wp", OBJPROP_STYLE, STYLE_DASHDOTDOT);
      ObjectSet("HarPat9wp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat15wp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat16wp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat19wp", OBJPROP_STYLE, STYLE_DASH);
      ObjectSet("HarPat20wp", OBJPROP_STYLE, STYLE_DOT);
      ObjectSet("HarPat8wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat9wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat19wp", OBJPROP_RAY, FALSE);
      ObjectSet("HarPat20wp", OBJPROP_RAY, FALSE);
   }
   if (Gi_292 > 1 || Gi_296 > 1 && Gi_156 == 1 && MathMod(Minute(), Period()) == 0.0 && Seconds() <= 5 && Gi_168 == FALSE) {
      Alert("Harmonic Pattern on: ", Symbol(), "   graph : ", Period() + "    " + TimeToStr(TimeCurrent()) + "  " + Gs_308);
      Gi_168 = TRUE;
      if (Gi_160 == TRUE) {
         SendMail("Harmonic Pattern", "Harmonic Pattern  on  " + Symbol() + "  " + Period() + "    " + TimeToStr(TimeCurrent()) 
         + "\n\n   " + Gs_308);
      }
   } else
      if (Seconds() < 10) Gi_168 = FALSE;
   Gi_292 = 0;
   Gi_296 = 0;
   Gi_unused_300 = 0;
   Gi_unused_304 = 0;
   WindowRedraw();
   for (int count_288 = 0; count_288 < 23; count_288++) {
      for (int Li_292 = 1; Li_292 < Gi_124; Li_292++) {
         Ld_296 = ObjectGet("HarPat" + count_288 + "m" + Li_292, OBJPROP_PRICE1);
         Ld_304 = ObjectGet("HarPat" + count_288 + "m" + Li_292, OBJPROP_PRICE2);
         Ld_312 = ObjectGet("HarPat" + count_288 + "w" + Li_292, OBJPROP_PRICE1);
         Ld_320 = ObjectGet("HarPat" + count_288 + "w" + Li_292, OBJPROP_PRICE2);
         for (int Li_328 = 1; Li_328 < Gi_124; Li_328++) {
            Ld_332 = ObjectGet("HarPat" + count_288 + "m" + ((Li_292 + Li_328)), OBJPROP_PRICE1);
            Ld_340 = ObjectGet("HarPat" + count_288 + "m" + ((Li_292 + Li_328)), OBJPROP_PRICE2);
            Ld_348 = ObjectGet("HarPat" + count_288 + "w" + ((Li_292 + Li_328)), OBJPROP_PRICE1);
            Ld_356 = ObjectGet("HarPat" + count_288 + "w" + ((Li_292 + Li_328)), OBJPROP_PRICE2);
            if (Ld_296 == Ld_332 && Ld_304 == Ld_340) ObjectDelete("HarPat" + count_288 + "m" + Li_292);
            if (Ld_312 == Ld_348 && Ld_320 == Ld_356) ObjectDelete("HarPat" + count_288 + "w" + Li_292);
         }
      }
   }
   return (0);
}
