
#property copyright "Copyright © 2004, Shurka & Kevin"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 CLR_NONE

extern bool    Indicator_On               = true;
extern string  Select_the_chart_timeframe   = "0=default/currently open chart";
extern string  of_the_channel_you_want_on   = "1=M1, 5=M5, 15=M15, 30=M30";
extern string  the_currently_open_chart     = "60=H1, 240=H4, 1440=D, 10080=W"; 
extern int     Timeframe                    = 0;
extern int     AllBars                      = 240;
extern int     BarsForFract                 = 0;
extern int     ChannelLinesThickness_12345  = 1;
extern color   Color_M1_Channel             = Turquoise;
extern color   Color_M5_Channel             = SteelBlue;
extern color   Color_M15_Channel            = Green;
extern color   Color_M30_Channel            = Silver;
extern color   Color_H1_Channel             = Magenta;
extern color   Color_H4_Channel             = DarkSlateBlue;
extern color   Color_D_Channel              = DarkOrange;
extern color   Color_W_Channel              = Red;


double g_ibuf_88[];
int CurrentBar = 0;
double Step = 0.0;
int B1 = -1;
int B2 = -1;
int UpDown = 0;
double P1 = 0.0;
double P2 = 0.0;
double g_price_132 = 0.0;
int gi_140 = 0;
int AB = 300;
int BFF = 0;
int ishift = 0;
double iprice = 0.0;
int g_datetime_164;
int g_datetime_168;
color LineColor;

long InstanceNo = 0; 
string sIntanceNo="";
string sInstanceName="";

int init() {

   //if(Timeframe==Period())
   //{
   //   ChannelLinesThickness_12345=2;
   //}
   //--- Initialize the generator of random numbers
   //MathSrand(GetTickCount());
   //InstanceNo = MathRand();
   //sInstanceName = DoubleToString(InstanceNo,StringFind(".",sInstanceName,0));

   sInstanceName = "shi_" + Timeframe + "_MTF1";
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 164);
   SetIndexBuffer(0, g_ibuf_88);
   SetIndexEmptyValue(0, 0.0);
  
   if (Timeframe == 0) Timeframe = Period();
   return (0);
}

int deinit() {

   DelObj();
   return (0);
}

void DelObj() {  
   //int Random = MathRand(); 
   int obj_total= ObjectsTotal(); 
   for (int i= obj_total; i>=0; i--)
      {
      string name= ObjectName(i);   
      if (StringSubstr(name,0,StringLen(sInstanceName))==sInstanceName)  ObjectDelete(name);
      }    
}

int start() {
   if (Indicator_On == false) {DelObj(); return(0);}
  
   int li_unused_0 = IndicatorCounted();
   if (AllBars == 0 || iBars(Symbol(), Timeframe) < AllBars) AB = iBars(Symbol(), Timeframe);
   else AB = AllBars;
   if (BarsForFract > 0) BFF = BarsForFract;
   
   else {
      switch (Timeframe) {
      
      case PERIOD_M1:
         BFF = 12;
         LineColor = Color_M1_Channel;
         break;
      case PERIOD_M5:
         BFF = 48;
         LineColor = Color_M5_Channel;
         break;
      case PERIOD_M15:
         BFF = 24;
         LineColor = Color_M15_Channel;
         break;
      case PERIOD_M30:
         BFF = 24;
         LineColor = Color_M30_Channel;
         break;
      case PERIOD_H1:
         BFF = 12;
         LineColor = Color_H1_Channel;
         break;
      case PERIOD_H4:
         BFF = 15;
         LineColor = Color_H4_Channel;
         break;
      case PERIOD_D1:
         BFF = 10;
         LineColor = Color_D_Channel;
         break;
      case PERIOD_W1:
         BFF = 6;
         LineColor = Color_W_Channel;
         break;
      default:
         DelObj();
         return (-1);
      }
   }
      
   CurrentBar = 2;
   B1 = -1;
   B2 = -1;
   UpDown = 0;
   
   while ((B1 == -1 || B2 == -1) && CurrentBar < AB) {
   
      //if (UpDown < 1 && (CurrentBar == iLowest(Symbol(), Timeframe, MODE_LOW, BFF << 1 + 1, CurrentBar - BFF))) {
      if (UpDown < 1 && (CurrentBar == iLowest(Symbol(), Timeframe, MODE_LOW, BFF*2 + 1, CurrentBar - BFF))) {
         if (UpDown == 0) {
            UpDown = -1;
            B1 = CurrentBar;
            P1 = iLow(Symbol(), Timeframe, B1);
         } else {
            B2 = CurrentBar;
            P2 = iLow(Symbol(), Timeframe, B2);
         }
      }
      //if (UpDown > -1 && CurrentBar == iHighest(Symbol(), Timeframe, MODE_HIGH, BFF << 1 + 1, CurrentBar - BFF)) {
      if (UpDown > -1 && CurrentBar == iHighest(Symbol(), Timeframe, MODE_HIGH, BFF*2 + 1, CurrentBar - BFF)) {
         if (UpDown == 0) {
            UpDown = 1;
            B1 = CurrentBar;
            P1 = iHigh(Symbol(), Timeframe, B1);
         } else {
            B2 = CurrentBar;
            P2 = iHigh(Symbol(), Timeframe, B2);
         }
      }
      CurrentBar++;
   }
   if (B1 == -1 || B2 == -1) {
      DelObj();
      return (-1);
   }
   Step = (P2 - P1) / (B2 - B1);
   P1 -= B1 * Step;
   B1 = 0;
   ishift = 0;
   iprice = 0;
   if (UpDown == 1) {
      g_price_132 = iLow(Symbol(), Timeframe, 2) - 2.0 * Step;
      for (gi_140 = 3; gi_140 <= B2; gi_140++)
         if (iLow(Symbol(), Timeframe, gi_140) < g_price_132 + Step * gi_140) g_price_132 = iLow(Symbol(), Timeframe, gi_140) - Step * gi_140;
      if (iLow(Symbol(), Timeframe, 0) < g_price_132) {
         ishift = 0;
         iprice = g_price_132;
      }
      if (iLow(Symbol(), Timeframe, 1) < g_price_132 + Step) {
         ishift = 1;
         iprice = g_price_132 + Step;
      }
      if (iHigh(Symbol(), Timeframe, 0) > P1) {
         ishift = 0;
         iprice = P1;
      }
      if (iHigh(Symbol(), Timeframe, 1) > P1 + Step) {
         ishift = 1;
         iprice = P1 + Step;
      }
   } else {
      g_price_132 = iHigh(Symbol(), Timeframe, 2) - 2.0 * Step;
      for (gi_140 = 3; gi_140 <= B2; gi_140++)
         if (iHigh(Symbol(), Timeframe, gi_140) > g_price_132 + Step * gi_140) g_price_132 = iHigh(Symbol(), Timeframe, gi_140) - gi_140 * Step;
      if (iLow(Symbol(), Timeframe, 0) < P1) {
         ishift = 0;
         iprice = P1;
      }
      if (iLow(Symbol(), Timeframe, 1) < P1 + Step) {
         ishift = 1;
         iprice = P1 + Step;
      }
      if (iHigh(Symbol(), Timeframe, 0) > g_price_132) {
         ishift = 0;
         iprice = g_price_132;
      }
      if (iHigh(Symbol(), Timeframe, 1) > g_price_132 + Step) {
         ishift = 1;
         iprice = g_price_132 + Step;
      }
   }
   P2 = P1 + AB * Step;
   g_datetime_164 = iTime(Symbol(), Timeframe, B1);
   g_datetime_168 = iTime(Symbol(), Timeframe, AB);
   if (iprice != 0.0) g_ibuf_88[ishift] = iprice;
   DelObj();
   string l_text_8 = " Channel size = " + DoubleToStr(MathAbs(g_price_132 - P1) / Point, 0) + " Slope = " + DoubleToStr((-Step) / Point, 2);
   if (g_price_132 < P1) {
      ObjectCreate(sInstanceName+"1TL1-" + Timeframe, OBJ_TREND, 0, g_datetime_168, g_price_132 + Step * AB, g_datetime_164, g_price_132);
      ObjectSet(sInstanceName+"1TL1-" + Timeframe, OBJPROP_COLOR, LineColor);
      ObjectSet(sInstanceName+"1TL1-" + Timeframe, OBJPROP_WIDTH, ChannelLinesThickness_12345);
      ObjectSet(sInstanceName+"1TL1-" + Timeframe, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetText(sInstanceName+"1TL1-" + Timeframe, l_text_8);
      ObjectCreate(sInstanceName+"1TL2-" + Timeframe, OBJ_TREND, 0, g_datetime_168, P2, g_datetime_164, P1);
      ObjectSet(sInstanceName+"1TL2-" + Timeframe, OBJPROP_COLOR, LineColor);
      ObjectSet(sInstanceName+"1TL2-" + Timeframe, OBJPROP_WIDTH, ChannelLinesThickness_12345);
      ObjectSet(sInstanceName+"1TL2-" + Timeframe, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetText(sInstanceName+"1TL2-" + Timeframe, l_text_8);
      ObjectCreate(sInstanceName+"1MIDL-" + Timeframe, OBJ_TREND, 0, g_datetime_168, (P2 + g_price_132 + Step * AB) / 2.0, g_datetime_164, (P1 + g_price_132) / 2.0);
      ObjectSet(sInstanceName+"1MIDL-" + Timeframe, OBJPROP_COLOR, LineColor);
      ObjectSet(sInstanceName+"1MIDL-" + Timeframe, OBJPROP_WIDTH, 1);
      ObjectSet(sInstanceName+"1MIDL-" + Timeframe, OBJPROP_STYLE, STYLE_DOT);
      ObjectSetText(sInstanceName+"1MIDL-" + Timeframe, l_text_8);
   }
   if (g_price_132 > P1) {
      ObjectCreate(sInstanceName+"1TL2-" + Timeframe, OBJ_TREND, 0, g_datetime_168, g_price_132 + Step * AB, g_datetime_164, g_price_132);
      ObjectSet(sInstanceName+"1TL2-" + Timeframe, OBJPROP_COLOR, LineColor);
      ObjectSet(sInstanceName+"1TL2-" + Timeframe, OBJPROP_WIDTH, ChannelLinesThickness_12345);
      ObjectSet(sInstanceName+"1TL2-" + Timeframe, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetText(sInstanceName+"1TL2-" + Timeframe, l_text_8);
      ObjectCreate(sInstanceName+"1TL1-" + Timeframe, OBJ_TREND, 0, g_datetime_168, P2, g_datetime_164, P1);
      ObjectSet(sInstanceName+"1TL1-" + Timeframe, OBJPROP_COLOR, LineColor);
      ObjectSet(sInstanceName+"1TL1-" + Timeframe, OBJPROP_WIDTH, ChannelLinesThickness_12345);
      ObjectSet(sInstanceName+"1TL1-" + Timeframe, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetText(sInstanceName+"TL1-" + Timeframe, l_text_8);
      ObjectCreate(sInstanceName+"1MIDL-" + Timeframe, OBJ_TREND, 0, g_datetime_168, (P2 + g_price_132 + Step * AB) / 2.0, g_datetime_164, (P1 + g_price_132) / 2.0);
      ObjectSet(sInstanceName+"1MIDL-" + Timeframe, OBJPROP_COLOR, LineColor);
      ObjectSet(sInstanceName+"1MIDL-" + Timeframe, OBJPROP_WIDTH, 1);
      ObjectSet(sInstanceName+"1MIDL-" + Timeframe, OBJPROP_STYLE, STYLE_DOT);
      ObjectSetText(sInstanceName+"1MIDL-" + Timeframe, l_text_8);
   }
   return (0);
}