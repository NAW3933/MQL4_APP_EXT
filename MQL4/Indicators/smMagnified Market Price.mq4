//+------------------------------------------------------------------+
//| Magnified Market Price.mq4        ver1.4             by Habeeb   |
//+------------------------------------------------------------------+
//| _TRO_MODIFIED_VERSION                                  |
//| MODIFIED BY AVERY T. HORTON, JR. AKA THERUMPLEDONE@GMAIL.COM     |
//| I am NOT the ORIGINAL author 
//  and I am not claiming authorship of this indicator. 
//  All I did was modify it. I hope you find my modifications useful.|
//|                                                                  |
//+------------------------------------------------------------------+
#property indicator_chart_window

  extern string note1 = "Change font colors automatically? True = Yes";
  //extern bool   Bid_Ask_Colors = True;
  extern bool   Open_Close_Colors = True;  
  extern bool   Show_AllDigits = false;  
  extern string note2 = "Default Font Color";
  extern color  FontColor = Blue;
  extern color  FontColorUp = Lime;  
  extern color  FontColorDn = Red; 
  extern string note3 = "Font Size";
  extern int    FontSize=30;
  extern string note4 = "Font Type";
  extern string FontType="Arial Bold" ; //"Comic Sans MS";
  extern string note5 = "Display the price in what corner?";
  extern string note6 = "Upper left=0; Upper right=1";
  extern string note7 = "Lower left=2; Lower right=3";
  extern int    WhatCorner=2;
  extern int    xAxis=1;
  extern int    yAxis=4;//50;

  string        symbol , tChartPeriod ;
  double        Old_Price, point;

int     digits, period, win, digits2, n, j, i, k;

//+------------------------------------------------------------------+

int init()
  {
   symbol       =  Symbol() ; 
   digits       =  Digits ;
   point        =  Point ;

   period       = Period() ;     
   tChartPeriod =  TimeFrameToString(period) ;   

   if (Show_AllDigits == false)
      if(digits == 5 || digits == 3) { 
         if (Period() > PERIOD_M1)
            digits  = digits - 1 ; 
         point = point * 10 ; 
      } 
 
  
   return(0);
  }

//+------------------------------------------------------------------+

int deinit()
  {
  ObjectDelete("Market_Price_Label"); 
 
  return(0);
  }

//+------------------------------------------------------------------+

int start()
{
   /*if (Bid_Ask_Colors == True)
   {
    if (Bid > Old_Price) FontColor = FontColorUp;
    if (Bid < Old_Price) FontColor = FontColorDn;
    Old_Price = Bid;
   }*/
   
   if (Open_Close_Colors == true)
   {
      if (Close[0] > Open[0]) FontColor = FontColorUp; else
      if (Close[0] < Open[0]) FontColor = FontColorDn;
   }
   
   //string Market_Price = tChartPeriod + " " +  symbol + " " + DoubleToStr(Bid, digits);
   string Market_Price = DoubleToStr(Bid, digits);
  
   ObjectCreate("Market_Price_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Market_Price_Label", Market_Price, FontSize, FontType, FontColor);
   ObjectSet("Market_Price_Label", OBJPROP_CORNER, WhatCorner);
   ObjectSet("Market_Price_Label", OBJPROP_XDISTANCE, xAxis);
   ObjectSet("Market_Price_Label", OBJPROP_YDISTANCE, yAxis);
}

//+------------------------------------------------------------------+  

string TimeFrameToString(int tf)
{
   string tfs;
   switch(tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN";
   }
   return(tfs);
}





//+------------------------------------------------------------------+    