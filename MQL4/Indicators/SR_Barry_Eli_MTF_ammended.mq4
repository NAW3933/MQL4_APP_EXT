//+------------------------------------------------------------------+
//|                                                      #MTF SR.mq4 |
//|                                      Copyright © 2006, Eli hayun |
//|                                          http://www.elihayun.com |
//+------------------------------------------------------------------+
//updated2008fxtsd    ki
//Ammended 2009 Limstylz
#property copyright "Copyright © 2006, Eli hayun"
#property link      "http://www.elihayun.com"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 DarkGreen
#property indicator_color2 DarkOrange
#property indicator_color3 DarkBlue
#property indicator_color4 Maroon
#property indicator_color5 Blue
#property indicator_color6 Red
#property indicator_color7 PowderBlue
#property indicator_color8 LightPink

//#property indicator_width1 3
//#property indicator_width2 3
//#property indicator_width3 2
//#property indicator_width4 2
//#property indicator_width5 1
//#property indicator_width6 1
//#property indicator_width7 1
//#property indicator_width8 1



//---- buffers
double buf_up1D[];
double buf_down1D[];

double buf_up4H[];
double buf_down4H[];

double buf_up1H[];
double buf_down1H[];

double buf_up30M[];
double buf_down30M[];

extern int Period_1 = 5;
extern int Period_2 = 15;
extern int Period_3 = 30;
extern int Period_4 = 60;


extern bool display_Period_1 = true;
extern bool display_Period_2 = true;
extern bool display_Period_3 = true;
extern bool display_Period_4 = true;

extern string note_timeFrames = "M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-currentTF";

//extern bool Play_Sound = true;
//int UniqueNum = 22841;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   
   int draw = DRAW_ARROW; if (!display_Period_4) draw = DRAW_NONE;
   SetIndexStyle(0,draw);
   SetIndexArrow(0,167);
   SetIndexStyle(1,draw);
   SetIndexArrow(1,167);
   
   SetIndexBuffer(0,buf_up1D);
   SetIndexBuffer(1,buf_down1D);
   SetIndexLabel(0, "S "+tf2txt(Period_4)); SetIndexLabel(1,"R "+tf2txt(Period_4));
   
   draw = DRAW_ARROW; if (!display_Period_3) draw = DRAW_NONE;
   SetIndexStyle(2,draw);
   SetIndexArrow(2,167);
   SetIndexStyle(3,draw);
   SetIndexArrow(3,167);

   SetIndexBuffer(2,buf_up4H);
   SetIndexBuffer(3,buf_down4H);
   SetIndexLabel(2,"S "+ tf2txt(Period_3)); SetIndexLabel(3,"R "+ tf2txt(Period_3));


   draw = DRAW_ARROW; if (!display_Period_2) draw = DRAW_NONE;
   SetIndexStyle(4,draw);
   SetIndexArrow(4,167);
   SetIndexStyle(5,draw);
   SetIndexArrow(5,167);

   SetIndexBuffer(4,buf_up1H);
   SetIndexBuffer(5,buf_down1H);
   SetIndexLabel(4, "S "+tf2txt(Period_2)); SetIndexLabel(5,"R "+ tf2txt(Period_2));

   draw = DRAW_ARROW; if (!display_Period_1) draw = DRAW_NONE;
   SetIndexStyle(6,draw);
   SetIndexArrow(6,167);
   SetIndexStyle(7,draw);
   SetIndexArrow(7,167);

   SetIndexBuffer(6,buf_up30M);
   SetIndexBuffer(7,buf_down30M);
   SetIndexLabel (6,"S "+ tf2txt(Period_1)); SetIndexLabel(7,"R "+ tf2txt(Period_1));

Period_1= MathMax (Period_1,Period());
Period_2= MathMax (Period_2,Period());
Period_3= MathMax (Period_3,Period());
Period_4= MathMax (Period_4,Period());

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   RefreshRates();
   int    counted_bars=IndicatorCounted();
   int i=0, y1d=0, y4h=0, y1h=0, y30m=0;
   
   int limit=Bars-counted_bars;
   limit = MathMax (limit,Period_4/Period());
   limit = MathMax (limit,Period_3/Period());
   limit = MathMax (limit,Period_2/Period());
   limit = MathMax (limit,Period_1/Period());

   double pd_1=0, pd_2=0, pd_3=0, pd_4=0;
   double pu_1=0, pu_2=0, pu_3=0, pu_4=0;
   
   datetime TimeArray_1D[] ,TimeArray_4H[], TimeArray_1H[], TimeArray_30M[];
//----
   ArrayCopySeries(TimeArray_1D,MODE_TIME,Symbol(),Period_4); 
   ArrayCopySeries(TimeArray_4H,MODE_TIME,Symbol(),Period_3); 
   ArrayCopySeries(TimeArray_1H,MODE_TIME,Symbol(),Period_2); 
   ArrayCopySeries(TimeArray_30M,MODE_TIME,Symbol(),Period_1);
      
   for(i=0, y1d=0,  y4h=0,  y1h=0,  y30m=0; i<limit;i++)
   {
      if (Time[i]<TimeArray_1D[y1d]) y1d++;
      if (Time[i]<TimeArray_4H[y4h]) y4h++;
      if (Time[i]<TimeArray_1H[y1h]) y1h++;
      if (Time[i]<TimeArray_30M[y30m]) y30m++;
      
      double fh = iFractals( NULL, Period_4, MODE_HIGH, y1d);
            
      buf_up1D[i] = fh; 
      buf_down1D[i] = iFractals( NULL, Period_4, MODE_LOW, y1d);
      
      buf_up4H[i] = iFractals( NULL, Period_3, MODE_HIGH, y4h); 
      buf_down4H[i] = iFractals( NULL, Period_3, MODE_LOW, y4h);

      
      buf_up1H[i] = iFractals( NULL, Period_2, MODE_HIGH, y1h);
      buf_down1H[i] = iFractals( NULL, Period_2, MODE_LOW, y1h);
      
      
      buf_up30M[i] = iFractals( NULL, Period_1, MODE_HIGH, y30m);
      buf_down30M[i] = iFractals( NULL, Period_1, MODE_LOW, y30m);

   }
   
   for (i=limit; i>=0; i--)
   {
      if (   buf_up1D[i] == 0 )   buf_up1D[i] = pu_1; else  pu_1 = buf_up1D[i];
      if (   buf_down1D[i] == 0 ) buf_down1D[i] = pd_1; else  pd_1 = buf_down1D[i];

      if (   buf_up4H[i] == 0 )   buf_up4H[i] = pu_2; else  pu_2 = buf_up4H[i];
      if (   buf_down4H[i] == 0 ) buf_down4H[i] = pd_2; else  pd_2 = buf_down4H[i];

      if (   buf_up1H[i] == 0 )   buf_up1H[i] = pu_3; else  pu_3 = buf_up1H[i];
      if (   buf_down1H[i] == 0 ) buf_down1H[i] = pd_3; else  pd_3 = buf_down1H[i];

      if (   buf_up30M[i] == 0 )   buf_up30M[i] = pu_4; else  pu_4 = buf_up30M[i];
      if (   buf_down30M[i] == 0 ) buf_down30M[i] = pd_4; else  pd_4 = buf_down30M[i];
   }

//----
   return(0);
  }
//+------------------------------------------------------------------+


string tf2txt(int tf)
{
   if (tf == 0)            return("CurrentTF");
   if (tf == PERIOD_M1)    return("M1");
   if (tf == PERIOD_M5)    return("M5");
   if (tf == PERIOD_M15)    return("M15");
   if (tf == PERIOD_M30)    return("M30");
   if (tf == PERIOD_H1)    return("H1");
   if (tf == PERIOD_H4)    return("H4");
   if (tf == PERIOD_D1)    return("D1");
   if (tf == PERIOD_W1)    return("W1");
   if (tf == PERIOD_MN1)    return("MN1");
   
   return("??");
}

