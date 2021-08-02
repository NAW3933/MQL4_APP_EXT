//+------------------------------------------------------------------+
//|                                               BBands for RSI.mq4 |
//|                                              Copyright 2018, Tor |
//|                          https://www.mql5.com/ru/users/tormovies |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   ""
#property description "This indicator is based on standard indicator Relative Strength Index"
#property description "and draws a Bollinger Bands channel for him"
#property strict
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   5
#property indicator_minimum 0
#property indicator_maximum 100

input string t1="--- Input RSI parameters ---";
input int RSIPeriod = 14; // RSI Period
input int MaxLevel = 70;  // Max signal level
input int MinLevel = 30;  // Min signal level
input color rsicolor=clrDodgerBlue;// RSI color
input int rsiwidth=1;   // RSI width

input string t2="--- Input BBands parameters ---";
input int BBPeriod=80; // BB Period
input double BBDeviation = 2;// BB Deviation
input color BBcolor=clrGreen;// BB Color
input int BBWidth=1;// BB Width
input ENUM_LINE_STYLE BBStyle=STYLE_DOT;// BB line style

input string t3="--- Other parameters ---";
input int alertShift=1; // Candle which look for the signal (0 = current candle)
input bool showLine=false; // Show vertical lines
input bool showArrows=true; // Show arrows

double RSIx[],bbup[],bbdn[],buy[],sell[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorShortName("BB for RSI");
   SetIndexBuffer(0,RSIx);
   SetIndexBuffer(1,bbup);
   SetIndexBuffer(2,bbdn);
   SetIndexBuffer(3,buy);
   SetIndexBuffer(4,sell);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,rsiwidth,rsicolor);
   SetIndexStyle(1,DRAW_LINE,BBStyle,BBWidth,BBcolor);
   SetIndexStyle(2,DRAW_LINE,BBStyle,BBWidth,BBcolor);
   SetIndexStyle(3,DRAW_ARROW,STYLE_SOLID,1,clrBlue);
   SetIndexStyle(4,DRAW_ARROW,STYLE_SOLID,1,clrRed);
   SetIndexArrow(3,233);
   SetIndexArrow(4,234);
   SetIndexLabel(0,"RSI");
   SetIndexLabel(1,"BBands Up");
   SetIndexLabel(2,"BBands Down");
   SetLevelValue(1,MinLevel);
   SetLevelValue(2,MaxLevel);
   SetLevelValue(3,50);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
int deinit()
  {
   del("BBfrs_");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int limit; int xxx=0;
   static datetime altime=0;
//---
   if(rates_total<=1)
      return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0)
      limit=limit+2;

   for(int x=limit-2; x>=0; x--)
     {
      RSIx[x]=iRSI(Symbol(),0,RSIPeriod,PRICE_CLOSE,x);
     }
   for(int x2=limit-2; x2>=0; x2--)
     {
      bbup[x2]=iBandsOnArray(RSIx,0,BBPeriod,BBDeviation,0,MODE_UPPER,x2);
      bbdn[x2]=iBandsOnArray(RSIx,0,BBPeriod,BBDeviation,0,MODE_LOWER,x2);
     }
   for(int x3=limit-2; x3>=0; x3--)
     {
      if(RSIx[x3+alertShift]<bbup[x3+alertShift] && RSIx[x3+alertShift+1]>bbup[x3+alertShift+1])
        {
         if(showArrows){ sell[x3]=RSIx[x3]; }
         if(showLine){ Lines(x3,"Sell",clrRed); }
        }
      if(RSIx[x3+alertShift]>bbdn[x3+alertShift] && RSIx[x3+alertShift+1]<bbdn[x3+alertShift+1])
        {
         if(showArrows){ buy[x3]=RSIx[x3]; }
         if(showLine){ Lines(x3,"Buy",clrBlue); }
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void Lines(int shift,string txt,color clr=clrRed)
  {
   datetime time=iTime(Symbol(),0,shift);
   ObjectCreate(0,"BBfrs_"+txt+"_"+(string)time,OBJ_VLINE,0,time,0);
   ObjectSetInteger(0,"BBfrs_"+txt+"_"+(string)time,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,"BBfrs_"+txt+"_"+(string)time,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetString(0,"BBfrs_"+txt+"_"+(string)time,OBJPROP_TOOLTIP,txt);
   ObjectSetInteger(0,"BBfrs_"+txt+"_"+(string)time,OBJPROP_BACK,true);
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int del(string name)
  {
   for(int n=ObjectsTotal()-1; n>=0; n--)
     {
      string Obj_Name=ObjectName(n);
      if(StringFind(Obj_Name,name,0)!=-1)
        {
         ObjectDelete(Obj_Name);
        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
