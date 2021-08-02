//+------------------------------------------------------------------+
//|                                  Original version: Spread V2.mq4 |
//|                                  Copyright © 2009, Andriy Moraru |
//|                         Modified version: Floating_Spread V1.mq4 |
//|                                  Copyright © 2015, Janez Hoèevar |
//+------------------------------------------------------------------+
#property copyright    "Andriy Moraru and Saronko"
#property link         "http://www.earnforex.com"
#property version      "1.00"
#property link         "http://www.forexfactory.com/saronko"
#property description  "The indicator changes color depending on the Spread Level" 
#property description  "Colors are adjustable" 

#property indicator_chart_window


extern int      font_size           = 10;
extern string   font_face           = "Arial Black";
extern color    SpreadColorHigh     = Red;
extern color    SpreadColorLow      = Lime;
extern int      SpreadHiLoMidLevel  = 12;
extern string   SpreadLabel         = "SP: ";
extern string   Corner_Note         = "0 top left, 1 top right, 2 bottom left, 3 bottom right";
extern int      corner              = 1; 
extern int      distance_x          = 5;
extern int      distance_y          = 5;
extern string   Normalize_Note      = "If true then the spread is normalized to traditional pips";
extern bool     normalize           = true; 
double Poin;
int n_digits = 0;
double divider = 1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   
   
   //Checking for unconvetional Point digits number
   if (Point == 0.00001) Poin = 0.0001; //5 digits
   else if (Point == 0.001) Poin = 0.01; //3 digits
   else Poin = Point; //Normal
   
   ObjectCreate("FLSpread", OBJ_LABEL, 0, 0, 0);
   ObjectSet("FLSpread", OBJPROP_CORNER, corner);
   ObjectSet("FLSpread", OBJPROP_XDISTANCE, distance_x);
   ObjectSet("FLSpread", OBJPROP_YDISTANCE, distance_y);
   double spread = MarketInfo(Symbol(), MODE_SPREAD);
   
   if ((Poin > Point) && (normalize))
   {
      divider = 10.0;
      n_digits = 1;
   }

   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   ObjectDelete("FLSpread");
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
  
  RefreshRates();
   
  color Col;
   
  double spread = (Ask - Bid) / Point;
   
  if ((Ask - Bid) / Point>=SpreadHiLoMidLevel) { Col=SpreadColorHigh; }//High calculation
  if ((Ask - Bid) / Point<=SpreadHiLoMidLevel) { Col=SpreadColorLow; }//Low calculation 

  ObjectSetText("FLSpread", SpreadLabel + DoubleToStr(NormalizeDouble(spread / divider,1), n_digits), font_size, font_face, Col);
 
  WindowRedraw();
    
   return(0);
}
//+------------------------------------------------------------------+