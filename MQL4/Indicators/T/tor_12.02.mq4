//+------------------------------------------------------------------+
//|                                             Trending or Ranging? |
//|                                                     ToR_1.02.mq4 |
//|                                       Copyright © 2007 Tom Balfe |
//|                                                                  |
//| This indicator shows you whether a pair is trending or ranging.  | 
//| For trending markets use moving averages and for ranging         |
//| market use oscillators.                                          |
//|                                                                  |
//| It shows ADX values for multiple timeframes to help you          |
//| decide which trading technique to use.                           |
//| Sometimes you'll see short-term trends against the H4            |
//| and D1 trend.                                                    |
//|                                                                  |
//| It's up to you whether you trade in a ranging market. It seems   |
//| to me that trading with the long-term trend is best.             |
//| Having said that, the reason why I made this indicator is to     |
//| to let the trader decide at a glance what to do, or even to      |
//| do nothing. Staying out of a market is a position too.           |
//|                                                                  |
//| If you want to chat about FOREX my friends and I made an IRC     |
//| channel on Undernet called #forex.                               |
//|                                                                  |
//| Best of luck in all your trades!                                 |
//|                                                                  |
//| Version: 1.02                                                    |
//|                                                                  |
//| Changelog:                                                       |
//|     1.02 - added arrows, ranging icon, no zero space state       |
//|            for icons/arrows, spacing got messed up, now          | 
//|            fixed                                                 |
//|     1.01 - unreleased, reduced number of colors, functional      |
//|     1.0  - unreleased, too many colors for ADX values            |
//|                                                                  |
//|                   http://www.forex-tsd.com/members/nittany1.html |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Tom Balfe"
#property link      "http://www.forex-tsd.com/members/nittany1.html"
#property link      "redcarsarasota@yahoo.com"
#property indicator_separate_window

int spread;
//---- user selectable stuff
extern int  SpreadThreshold=6;
extern bool Show_D1_ADX=true;
double alertBar;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //---- indicator short name
   IndicatorShortName("ToR 1.02 ("+Symbol()+")");

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   //---- need to delete objects should user remove indicator
   ObjectsDeleteAll(0,OBJ_LABEL);
     ObjectDelete("ToR102-1");ObjectDelete("ToR102-2");ObjectDelete("ToR102-3");
     ObjectDelete("ToR102-4");ObjectDelete("ToR102-5");ObjectDelete("ToR102-6");
     ObjectDelete("ToR102-7");ObjectDelete("ToR102-8");ObjectDelete("ToR102-9");
     ObjectDelete("ToR102-10");ObjectDelete("ToR102-11");ObjectDelete("ToR102-12");
     ObjectDelete("ToR102-2a");ObjectDelete("ToR102-4a");ObjectDelete("ToR102-6a");
     ObjectDelete("ToR102-8a");ObjectDelete("ToR102-10a");ObjectDelete("ToR102-12a");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //---- let's define some stuff 
   // M5 data
   double adx_m5 = iADX(NULL,5,14,PRICE_CLOSE,0,0);
   double di_p_m5 = iADX(NULL,5,14,PRICE_CLOSE,1,0);
   double di_m_m5 = iADX(NULL,5,14,PRICE_CLOSE,2,0);
   // M15 data
   double adx_m15 = iADX(NULL,15,14,PRICE_CLOSE,0,0); 
   double di_p_m15 = iADX(NULL,15,14,PRICE_CLOSE,1,0);
   double di_m_m15 = iADX(NULL,15,14,PRICE_CLOSE,2,0);
   // M30 data
   double adx_m30 = iADX(NULL,30,14,PRICE_CLOSE,0,0); 
   double di_p_m30 = iADX(NULL,30,14,PRICE_CLOSE,1,0);
   double di_m_m30 = iADX(NULL,30,14,PRICE_CLOSE,2,0);
   // H1 data
   double adx_h1 = iADX(NULL,60,14,PRICE_CLOSE,0,0);
   double di_p_h1 = iADX(NULL,60,14,PRICE_CLOSE,1,0);
   double di_m_h1 = iADX(NULL,60,14,PRICE_CLOSE,2,0);
   // H4 data
   double adx_h4 = iADX(NULL,240,14,PRICE_CLOSE,0,0);
   double di_p_h4 = iADX(NULL,240,14,PRICE_CLOSE,1,0);
   double di_m_h4 = iADX(NULL,240,14,PRICE_CLOSE,2,0);
   // D1 data
   double adx_d1 = iADX(NULL,1440,14,PRICE_CLOSE,0,0);
   double di_p_d1 = iADX(NULL,1440,14,PRICE_CLOSE,1,0);
   double di_m_d1 = iADX(NULL,1440,14,PRICE_CLOSE,2,0);
   
   //---- define colors and arrows 
   color adx_color_m5,adx_color_m15,adx_color_m30,adx_color_h1,adx_color_h4,adx_color_d1;
   
   string  adx_arrow_m5,adx_arrow_m15,adx_arrow_m30,adx_arrow_h1,adx_arrow_h4,adx_arrow_d1;
      
   //---- assign color
   // M5 colors
   if ((adx_m5 < 23) && (adx_m5 != 0)) { adx_color_m5 = LightSkyBlue; }
   if ((adx_m5 >=23) && (di_p_m5 > di_m_m5)) { adx_color_m5 = Lime; }
   if ((adx_m5 >=23) && (di_p_m5 < di_m_m5)) { adx_color_m5 = Red; }
      
   // M15 colors
   if ((adx_m15 < 23) && (adx_m15 != 0)) { adx_color_m15 = LightSkyBlue; }
   if ((adx_m15 >=23) && (di_p_m15 > di_m_m15)) { adx_color_m15 = Lime; }
   if ((adx_m15 >=23) && (di_p_m15 < di_m_m15)) { adx_color_m15 = Red; }
   
   // M30 colors
   if ((adx_m30 < 23) && (adx_m30 != 0)) { adx_color_m30 = LightSkyBlue; }
   if ((adx_m30 >=23) && (di_p_m30 > di_m_m30)) { adx_color_m30 = Lime; }
   if ((adx_m30 >=23) && (di_p_m30 < di_m_m30)) { adx_color_m30 = Red; }
   
   // H1 colors
   if ((adx_h1 < 23) && (adx_h1 != 0)) { adx_color_h1 = LightSkyBlue; }
   if ((adx_h1 >=23) && (di_p_h1 > di_m_h1)) { adx_color_h1 = Lime; }
   if ((adx_h1 >=23) && (di_p_h1 < di_m_h1)) { adx_color_h1 = Red; }
   
   // H4 colors
   if ((adx_h4 < 23) && (adx_h4 != 0)) { adx_color_h4 = LightSkyBlue; }
   if ((adx_h4 >=23) && (di_p_h4 > di_m_h4)) { adx_color_h4 = Lime; }
   if ((adx_h4 >=23) && (di_p_h4 < di_m_h4)) { adx_color_h4 = Red; }
   
   // D1 colors 
   if ((adx_d1 < 23) && (adx_d1 != 0)) { adx_color_d1 = LightSkyBlue; }
   if ((adx_d1 >=23) && (di_p_d1 > di_m_d1)) { adx_color_d1 = Lime; }
   if ((adx_d1 >=23) && (di_p_d1 < di_m_d1)) { adx_color_d1 = Red; }
   
   //---- feed all the ADX values into strings      
   string adx_value_m5 = adx_m5;
   string adx_value_m15 = adx_m15;
   string adx_value_m30 = adx_m30;
   string adx_value_h1 = adx_h1;
   string adx_value_h4 = adx_h4;
   string adx_value_d1 = adx_d1;
   
   //---- assign arrows strong up: { adx_arrow_ = "é"; } strong down: { adx_arrow_ = "ê"; }
   //                   up: { adx_arrow_ = "ì"; } down: { adx_arrow_ = "î"; }
   //                   range: { adx_arrow_ = "h"; }
   //                   use wingdings for these, the h is squiggly line
   
   // M5 arrows
   if (adx_m5 < 23 && adx_m5 != 0) { adx_arrow_m5 = "h"; }
   if ((adx_m5 >= 23 && adx_m5 < 28) && (di_p_m5 > di_m_m5)) { adx_arrow_m5 = "ì"; }
   if ((adx_m5 >= 23 && adx_m5 < 28) && (di_p_m5 < di_m_m5)) { adx_arrow_m5 = "î"; }
   if ((adx_m5 >=28) && (di_p_m5 > di_m_m5)) { adx_arrow_m5 = "é"; }
   if ((adx_m5 >=28) && (di_p_m5 < di_m_m5)) { adx_arrow_m5 = "ê"; }
   
   // M15 arrows
   if (adx_m15 < 23 && adx_m15 != 0) { adx_arrow_m15 = "h"; }
   if ((adx_m15 >= 23 && adx_m15 < 28) && (di_p_m15 > di_m_m15)) { adx_arrow_m15 = "ì"; }
   if ((adx_m15 >= 23 && adx_m15 < 28) && (di_p_m15 < di_m_m15)) { adx_arrow_m15 = "î"; }
   if ((adx_m15 >=28) && (di_p_m15 > di_m_m15)) { adx_arrow_m15 = "é"; }
   if ((adx_m15 >=28) && (di_p_m15 < di_m_m15)) { adx_arrow_m15 = "ê"; }
   
   // M30 arrows
   if (adx_m30 < 23 && adx_m30 != 0) { adx_arrow_m30 = "h"; }
   if ((adx_m30 >= 23 && adx_m30 < 28) && (di_p_m30 > di_m_m30)) { adx_arrow_m30 = "ì"; }
   if ((adx_m30 >= 23 && adx_m30 < 28) && (di_p_m30 < di_m_m30)) { adx_arrow_m30 = "î"; }
   if ((adx_m30 >=28) && (di_p_m30 > di_m_m30)) { adx_arrow_m30 = "é"; }
   if ((adx_m30 >=28) && (di_p_m30 < di_m_m30)) { adx_arrow_m30 = "ê"; }
   
   // H1 arrows
   if (adx_h1 < 23 && adx_h1 != 0) { adx_arrow_h1 = "h"; }
   if ((adx_h1 >= 23 && adx_h1 < 28) && (di_p_h1 > di_m_h1)) { adx_arrow_h1 = "ì"; }
   if ((adx_h1 >= 23 && adx_h1 < 28) && (di_p_h1 < di_m_h1)) { adx_arrow_h1 = "î"; }
   if ((adx_h1 >=28) && (di_p_h1 > di_m_h1)) { adx_arrow_h1 = "é"; }
   if ((adx_h1 >=28) && (di_p_h1 < di_m_h1)) { adx_arrow_h1 = "ê"; }
   
   // H4 arrows
   if (adx_h4 < 23 && adx_h4 != 0) { adx_arrow_h4 = "h"; }
   if ((adx_h4 >= 23 && adx_h4 < 28) && (di_p_h4 > di_m_h4)) { adx_arrow_h4 = "ì"; }
   if ((adx_h4 >= 23 && adx_h4 < 28) && (di_p_h4 < di_m_h4)) { adx_arrow_h4 = "î"; }
   if ((adx_h4 >=28) && (di_p_h4 > di_m_h4)) { adx_arrow_h4 = "é"; }
   if ((adx_h4 >=28) && (di_p_h4 < di_m_h4)) { adx_arrow_h4 = "ê"; }
   
   // D1 arrows
   if (adx_d1 < 23 && adx_d1 != 0) { adx_arrow_d1 = "h"; }
   if ((adx_d1 >= 23 && adx_d1 < 28) && (di_p_d1 > di_m_d1)) { adx_arrow_d1 = "ì"; }
   if ((adx_d1 >= 23 && adx_d1 < 28) && (di_p_d1 < di_m_d1)) { adx_arrow_d1 = "î"; }
   if ((adx_d1 >=28) && (di_p_d1 > di_m_d1)) { adx_arrow_d1 = "é"; }
   if ((adx_d1 >=28) && (di_p_d1 < di_m_d1)) { adx_arrow_d1 = "ê"; }
   
   //----====>>>> ADX STUFF
   //----====>>>> creates text "5 Min: "  
   ObjectCreate("ToR102-1",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-1","5 Min:", 9, "Lucida Sans Regular", LightSteelBlue);
     ObjectSet("ToR102-1", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-1", OBJPROP_XDISTANCE, 95);
     ObjectSet("ToR102-1", OBJPROP_YDISTANCE, 2);
   //---- create 5 min value
   ObjectCreate("ToR102-2",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-2", " ADX "+StringSubstr(adx_value_m5,0,5)+" ",9, "Lucida Sands Regular",adx_color_m5);
     ObjectSet("ToR102-2", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-2", OBJPROP_XDISTANCE, 135);
     ObjectSet("ToR102-2", OBJPROP_YDISTANCE, 2);
   //---- create 5 min arrow, squiggle if ranging
   ObjectCreate("ToR102-2a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-2a",adx_arrow_m5,9, "Wingdings",adx_color_m5);
     ObjectSet("ToR102-2a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-2a", OBJPROP_XDISTANCE, 198);
     ObjectSet("ToR102-2a", OBJPROP_YDISTANCE, 2); 

   //----====>>>> create text "15 Min: "
   ObjectCreate("ToR102-3",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-3","15 Min:", 9, "Lucida Sans Regular", LightSteelBlue);
     ObjectSet("ToR102-3", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-3", OBJPROP_XDISTANCE, 228);
     ObjectSet("ToR102-3", OBJPROP_YDISTANCE, 2);
   //---- create 15 min value
   ObjectCreate("ToR102-4",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-4", " ADX "+StringSubstr(adx_value_m15,0,5)+" ",9, "Lucida Sands Regular",adx_color_m15);
     ObjectSet("ToR102-4", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-4", OBJPROP_XDISTANCE, 273);
     ObjectSet("ToR102-4", OBJPROP_YDISTANCE, 2);
   //---- create 15 min arrow, squiggle if ranging
   ObjectCreate("ToR102-4a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-4a",adx_arrow_m15,9, "Wingdings",adx_color_m15);
     ObjectSet("ToR102-4a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-4a", OBJPROP_XDISTANCE, 336);
     ObjectSet("ToR102-4a", OBJPROP_YDISTANCE, 2); 

   //----====>>>> create text "30 Min: "
   ObjectCreate("ToR102-5",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-5","M30:", 9, "Lucida Sans Regular", LightSteelBlue);
     ObjectSet("ToR102-5", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-5", OBJPROP_XDISTANCE, 366);
     ObjectSet("ToR102-5", OBJPROP_YDISTANCE, 2);
   //---- create 30 min value
   ObjectCreate("ToR102-6",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-6", " ADX "+StringSubstr(adx_value_m30,0,5)+" ",9, "Lucida Sands Regular",adx_color_m30);
     ObjectSet("ToR102-6", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-6", OBJPROP_XDISTANCE, 400);
     ObjectSet("ToR102-6", OBJPROP_YDISTANCE, 2);
   //---- create 30 min arrow, squiggle if ranging
      ObjectCreate("ToR102-6a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-6a",adx_arrow_m30,9, "Wingdings",adx_color_m30);
     ObjectSet("ToR102-6a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-6a", OBJPROP_XDISTANCE, 463);
     ObjectSet("ToR102-6a", OBJPROP_YDISTANCE, 2); 

   //----====>>>> create text "1 Hr: "
   ObjectCreate("ToR102-7",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-7","1 Hr:", 9, "Lucida Sans Regular", LightSteelBlue);
     ObjectSet("ToR102-7", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-7", OBJPROP_XDISTANCE, 490);
     ObjectSet("ToR102-7", OBJPROP_YDISTANCE, 2);
   //---- create 1 hour value
   ObjectCreate("ToR102-8",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-8", " ADX "+StringSubstr(adx_value_h1,0,5)+" ",9, "Lucida Sands Regular",adx_color_h1);
     ObjectSet("ToR102-8", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-8", OBJPROP_XDISTANCE, 520);
     ObjectSet("ToR102-8", OBJPROP_YDISTANCE, 2);
   //---- create 1 hour arrow, squiggle if ranging
   ObjectCreate("ToR102-8a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-8a",adx_arrow_h1,9, "Wingdings",adx_color_h1);
     ObjectSet("ToR102-8a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-8a", OBJPROP_XDISTANCE, 582);
     ObjectSet("ToR102-8a", OBJPROP_YDISTANCE, 2); 

   //----====>>>> create text "4 Hr: "
   ObjectCreate("ToR102-9",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-9","4 Hr:", 9, "Lucida Sans Regular", LightSteelBlue);
     ObjectSet("ToR102-9", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-9", OBJPROP_XDISTANCE, 612);
     ObjectSet("ToR102-9", OBJPROP_YDISTANCE, 2);
   //---- create 4 hour value
   ObjectCreate("ToR102-10",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-10", " ADX "+StringSubstr(adx_value_h4,0,5)+" ",9, "Lucida Sands Regular",adx_color_h4);
     ObjectSet("ToR102-10", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-10", OBJPROP_XDISTANCE, 642);
     ObjectSet("ToR102-10", OBJPROP_YDISTANCE, 2);
   //---- create 1 hour arrow, squiggle if ranging
   ObjectCreate("ToR102-10a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-10a",adx_arrow_h4,9, "Wingdings",adx_color_h4);
     ObjectSet("ToR102-10a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-10a", OBJPROP_XDISTANCE, 703);
     ObjectSet("ToR102-10a", OBJPROP_YDISTANCE, 2); 
      
   if (Show_D1_ADX==true)
   {
   //----====>>>> create text "1 Day: "
   ObjectCreate("ToR102-11",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-11","1 Day:", 9, "Lucida Sans Regular", LightSteelBlue);
     ObjectSet("ToR102-11", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-11", OBJPROP_XDISTANCE, 733);
     ObjectSet("ToR102-11", OBJPROP_YDISTANCE, 2);
   //---- create 15 min value
   ObjectCreate("ToR102-12",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-12", " ADX "+StringSubstr(adx_value_d1,0,5)+" ",9, "Lucida Sands Regular",adx_color_d1);
     ObjectSet("ToR102-12", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-12", OBJPROP_XDISTANCE, 773);
     ObjectSet("ToR102-12", OBJPROP_YDISTANCE, 2);
   ObjectCreate("ToR102-12a",OBJ_LABEL, WindowFind("ToR 1.02 ("+Symbol()+")"), 0, 0);
     ObjectSetText("ToR102-12a",adx_arrow_d1,9, "Wingdings",adx_color_d1);
     ObjectSet("ToR102-12a", OBJPROP_CORNER, 0);
     ObjectSet("ToR102-12a", OBJPROP_XDISTANCE, 833);
     ObjectSet("ToR102-12a", OBJPROP_YDISTANCE, 2);
   }


//----
   return(0);
  }
//+------------------------------------------------------------------+