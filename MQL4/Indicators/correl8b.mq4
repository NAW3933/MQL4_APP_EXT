//+------------------------------------------------------------------+
//|                                                      Correl8.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 9
#property indicator_color1 clrRoyalBlue
#property indicator_color2 clrSilver
#property indicator_color3 clrDarkOrange
#property indicator_color4 clrDarkViolet
#property indicator_color5 clrFireBrick
#property indicator_color6 clrMagenta
#property indicator_color7 clrYellow
#property indicator_color8 clrLimeGreen
#property indicator_color9 clrGold

#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2
#property indicator_width6  2
#property indicator_width7  2
#property indicator_width8  3
#property indicator_width9  3

#property indicator_level1  -50
#property indicator_level2  -26
#property indicator_level3  -12
#property indicator_level4    0
#property indicator_level5   12
#property indicator_level6   26
#property indicator_level7   50
#property indicator_levelcolor clrLightSlateGray
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_RANGEMODE
  {
   HIGH_LOW,
   CLOSE_CLOSE,
   HIGH_LOW_CLOSE,
  };
// Indicator parameters
extern int   iPRIPeriod=14;
input ENUM_APPLIED_PRICE iPrice = PRICE_CLOSE;
input ENUM_RANGEMODE  RangeMode = HIGH_LOW;
input ENUM_TIMEFRAMES TimeFrame = 0;
// Show currencies on chart
extern bool  ShowAuto=true;
// Show all currencies
extern bool  ShowAll = false;
extern bool  ShowEUR = false;
extern bool  ShowGBP = false;
extern bool  ShowAUD = false;
extern bool  ShowNZD = false;
extern bool  ShowCHF = false;
extern bool  ShowCAD = false;
extern bool  ShowJPY = false;
extern bool  ShowUSD = false;
extern bool  ShowXAU = false;
//---index buffers for drawing
double Idx1[],Idx2[],Idx3[],Idx4[],Idx5[],Idx6[],Idx7[],Idx8[],Idx9[];
//---currency variables for calculation
double EUR,GBP,AUD,NZD,CHF,CAD,JPY,USD,XAU;
double EURUSD,GBPUSD,AUDUSD,NZDUSD,/*USDCHF,USDCAD,USDJPY,*/XAUUSD;
//---currency names and colors
string Currencies[indicator_buffers]=
  {
   "EUR","GBP","AUD","NZD",
   "CHF","CAD","JPY","USD","XAU"
  };
string ShortName;
int    BarsWindow;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   IndicatorDigits(0);
   IndicatorBuffers(indicator_buffers);
   BarsWindow=WindowBarsPerChart()+iPRIPeriod;
//---set timeframes
/*   if(TimeFrame==0)
     {
      switch(Period())
        {
         case PERIOD_M30: iPRIPeriod*=2;break;
         case PERIOD_M15: iPRIPeriod*=4;break;
         case PERIOD_M5:  iPRIPeriod*=12;break;
         case PERIOD_M1:  iPRIPeriod*=60;break;
        }
     }
   if(TimeFrame>0)
     {
      switch(TimeFrame)
        {
         case PERIOD_M30: iPRIPeriod*=2;break;
         case PERIOD_M15: iPRIPeriod*=4;break;
         case PERIOD_M5:  iPRIPeriod*=12;break;
         case PERIOD_M1:  iPRIPeriod*=60;break;
        }
     }*/
   string sTimeFrame;
   switch(TimeFrame)
     {
      case PERIOD_MN1: sTimeFrame = "MN1 ";break;
      case PERIOD_W1:  sTimeFrame = "W1 "; break;
      case PERIOD_D1:  sTimeFrame = "D1 "; break;
      case PERIOD_H4:  sTimeFrame = "H4 "; break;
      case PERIOD_H1:  sTimeFrame = "H1 "; break;
      case PERIOD_M30: sTimeFrame = "M30 ";break;
      case PERIOD_M15: sTimeFrame = "M15 ";break;
      case PERIOD_M5:  sTimeFrame = "M5 "; break;
      case PERIOD_M1:  sTimeFrame = "M1 "; break;
      default:         sTimeFrame = "";    break;
     }
   ShortName="iCorrel8 "+sTimeFrame+"("+IntegerToString(iPRIPeriod)+") ";
   IndicatorShortName(ShortName);
//---currencies to show
   if(ShowAuto)
     {
      string Quote= StringSubstr(Symbol(),3,3);  //Quote currency name
      string Base = StringSubstr(Symbol(),0,3);  //Base currency name
      if(Quote == "EUR" || Base == "EUR")  ShowEUR = true;
      if(Quote == "GBP" || Base == "GBP")  ShowGBP = true;
      if(Quote == "AUD" || Base == "AUD")  ShowAUD = true;
      if(Quote == "NZD" || Base == "NZD")  ShowNZD = true;
      if(Quote == "CHF" || Base == "CHF")  ShowCHF = true;
      if(Quote == "CAD" || Base == "CAD")  ShowCAD = true;
      if(Quote == "JPY" || Base == "JPY")  ShowJPY = true;
      if(Quote == "USD" || Base == "USD")  ShowUSD = true;
      if(Quote == "XAU" || Base == "XAU")  ShowXAU = true;
      //ShowAll=false;
     }

   if(ShowAll)
     {
      //ShowAuto = false;
      ShowEUR = true;
      ShowGBP = true;
      ShowAUD = true;
      ShowNZD = true;
      ShowCHF = true;
      ShowCAD = true;
      ShowJPY = true;
      ShowUSD = true;
      ShowXAU = true;
     }

   int window=WindowFind(ShortName);
   int xStart=4;       //label coordinates
   int xIncrement=25;
   int yStart=16;
//---set buffer properties
   if(ShowEUR)
     {
      SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,indicator_width1);
      SetIndexLabel(0,Currencies[0]);
      SetIndexDrawBegin(0,iPRIPeriod);
      CreateLabel(Currencies[0],window,xStart,yStart,indicator_color1);
      xStart+=xIncrement;
     }
   if(ShowGBP)
     {
      SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,indicator_width2);
      SetIndexLabel(1,Currencies[1]);
      SetIndexDrawBegin(1,iPRIPeriod);
      CreateLabel(Currencies[1],window,xStart,yStart,indicator_color2);
      xStart+=xIncrement;
     }
   if(ShowAUD)
     {
      SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,indicator_width3);
      SetIndexLabel(2,Currencies[2]);
      SetIndexDrawBegin(2,iPRIPeriod);
      CreateLabel(Currencies[2],window,xStart,yStart,indicator_color3);
      xStart+=xIncrement;
     }
   if(ShowNZD)
     {
      SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,indicator_width4);
      SetIndexDrawBegin(3,iPRIPeriod);
      SetIndexLabel(3,Currencies[3]);
      CreateLabel(Currencies[3],window,xStart,yStart,indicator_color4);
      xStart+=xIncrement;
     }
   if(ShowCHF)
     {
      SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,indicator_width5);
      SetIndexLabel(4,Currencies[4]);
      SetIndexDrawBegin(4,iPRIPeriod);
      CreateLabel(Currencies[4],window,xStart,yStart,indicator_color5);
      xStart+=xIncrement;
     }
   if(ShowCAD)
     {
      SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,indicator_width6);
      SetIndexLabel(5,Currencies[5]);
      SetIndexDrawBegin(5,iPRIPeriod);
      CreateLabel(Currencies[5],window,xStart,yStart,indicator_color6);
      xStart+=xIncrement;
     }
   if(ShowJPY)
     {
      SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,indicator_width7);
      SetIndexLabel(6,Currencies[6]);
      SetIndexDrawBegin(6,iPRIPeriod);
      CreateLabel(Currencies[6],window,xStart,yStart,indicator_color7);
      xStart+=xIncrement;
     }
   if(ShowUSD)
     {
      SetIndexStyle(7,DRAW_LINE,STYLE_SOLID,indicator_width8);
      SetIndexLabel(7,Currencies[7]);
      SetIndexDrawBegin(7,iPRIPeriod);
      CreateLabel(Currencies[7],window,xStart,yStart,indicator_color8);
      xStart+=xIncrement;
     }
   if(ShowXAU)
     {
      SetIndexStyle(8,DRAW_LINE,STYLE_SOLID,indicator_width9);
      SetIndexLabel(8,Currencies[8]);
      SetIndexDrawBegin(8,iPRIPeriod);
      CreateLabel(Currencies[8],window,xStart,yStart,indicator_color9);
      //xStart+=xIncrement;
     }
//---index buffers
   SetIndexBuffer(0,Idx1);
   SetIndexBuffer(1,Idx2);
   SetIndexBuffer(2,Idx3);
   SetIndexBuffer(3,Idx4);
   SetIndexBuffer(4,Idx5);
   SetIndexBuffer(5,Idx6);
   SetIndexBuffer(6,Idx7);
   SetIndexBuffer(7,Idx8);
   SetIndexBuffer(8,Idx9);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// delete labels
//int window=WindowFind(ShortName);
   for(int i=0;i<indicator_buffers;i++)
      ObjectDelete(Currencies[i]);
   return;
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
   BarsWindow=WindowBarsPerChart()+iPRIPeriod;
   int shift;
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)  limit=BarsWindow;
   if(prev_calculated>0)  limit++;
   if(prev_calculated>0 && NewBar()) limit++;
   for(int i=0; i<limit; i++)
     {
      shift=iBarShift(NULL,TimeFrame,time[i]);

      EUR = iPRI("EURUSD",TimeFrame,iPRIPeriod,iPrice,shift);
      GBP = iPRI("GBPUSD",TimeFrame,iPRIPeriod,iPrice,shift);
      AUD = iPRI("AUDUSD",TimeFrame,iPRIPeriod,iPrice,shift);
      NZD = iPRI("NZDUSD",TimeFrame,iPRIPeriod,iPrice,shift);
      CHF = iPRI("USDCHF",TimeFrame,iPRIPeriod,iPrice,shift);
      CAD = iPRI("USDCAD",TimeFrame,iPRIPeriod,iPrice,shift);
      JPY = iPRI("USDJPY",TimeFrame,iPRIPeriod,iPrice,shift);
      XAU = iPRI("XAUUSD",TimeFrame,iPRIPeriod,iPrice,shift);

      EURUSD = iClose("EURUSD",TimeFrame,shift);   //Get USD ratio      
      GBPUSD = iClose("GBPUSD",TimeFrame,shift);
      AUDUSD = iClose("AUDUSD",TimeFrame,shift);
      NZDUSD = iClose("NZDUSD",TimeFrame,shift);
      //USDCHF = iClose("USDCHF",TimeFrame,shift);
      //USDCAD = iClose("USDCAD",TimeFrame,shift);
      //USDJPY = iClose("USDJPY",TimeFrame,shift)/100;
      XAUUSD = iClose("XAUUSD",TimeFrame,shift)/1000;

      if(EURUSD)
         EUR*=1/EURUSD;
      if(GBPUSD)
         GBP*=1/GBPUSD;
      if(AUDUSD)
         AUD*=1/AUDUSD;
      if(NZDUSD)
         NZD*=1/NZDUSD;
      if(XAUUSD)
         XAU*=1/XAUUSD;

      CHF*=-1;
      CAD*=-1;
      JPY*=-1;
      
      USD=-(EUR+GBP+AUD+NZD+CHF+CAD+JPY+XAU)/(indicator_buffers-1);   //USD relative to other 
    /*EUR += -(GBP + AUD + NZD + CHF + CAD + JPY + XAU)/(indicator_buffers-2); //Currency relative to USD
      GBP += -(EUR + AUD + NZD + CHF + CAD + JPY + XAU)/(indicator_buffers-2);
      AUD += -(EUR + GBP + NZD + CHF + CAD + JPY + XAU)/(indicator_buffers-2);
      NZD += -(EUR + GBP + AUD + CHF + CAD + JPY + XAU)/(indicator_buffers-2);
      CHF += -(EUR + GBP + AUD + NZD + CAD + JPY + XAU)/(indicator_buffers-2);
      CAD += -(EUR + GBP + AUD + NZD + CHF + JPY + XAU)/(indicator_buffers-2);
      JPY += -(EUR + GBP + AUD + NZD + CHF + CAD + XAU)/(indicator_buffers-2);
    */
      if(ShowEUR)
         Idx1[i]=EUR;
      if(ShowGBP)
         Idx2[i]=GBP;
      if(ShowAUD)
         Idx3[i]=AUD;
      if(ShowNZD)
         Idx4[i]=NZD;
      if(ShowCHF)
         Idx5[i]=CHF;
      if(ShowCAD)
         Idx6[i]=CAD;
      if(ShowJPY)
         Idx7[i]=JPY;
      if(ShowUSD)
         Idx8[i]=USD;
      if(ShowXAU)
         Idx9[i]=XAU;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateLabel(string currency,
                 int window,
                 int x,
                 int y,
                 int clr)
  {
   int label=ObjectCreate(currency,OBJ_LABEL,window,0,0);
   ObjectSetText(currency,currency,8);
   ObjectSet(currency,OBJPROP_COLOR,clr);
   ObjectSet(currency,OBJPROP_XDISTANCE,x);
   ObjectSet(currency,OBJPROP_YDISTANCE,y);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewBar()
  {
   static datetime time_prev;
   if(iTime("EURUSD",TimeFrame,0) != time_prev &&
      iTime("GBPUSD",TimeFrame,0) != time_prev &&
      iTime("AUDUSD",TimeFrame,0) != time_prev &&
      iTime("NZDUSD",TimeFrame,0) != time_prev &&
      iTime("USDCHF",TimeFrame,0) != time_prev &&
      iTime("USDCAD",TimeFrame,0) != time_prev &&
      iTime("USDJPY",TimeFrame,0) != time_prev &&
      iTime("XAUUSD",TimeFrame,0) != time_prev)
     {
      time_prev = iTime("EURUSD",TimeFrame,0);
      time_prev = iTime("GBPUSD",TimeFrame,0);
      time_prev = iTime("AUDUSD",TimeFrame,0);
      time_prev = iTime("NZDUSD",TimeFrame,0);
      time_prev = iTime("USDCHF",TimeFrame,0);
      time_prev = iTime("USDCAD",TimeFrame,0);
      time_prev = iTime("USDJPY",TimeFrame,0);
      time_prev = iTime("XAUUSD",TimeFrame,0);
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Percent Range Index Function                                     |
//+------------------------------------------------------------------+
const int iPRI(const string symbol,
               const ENUM_TIMEFRAMES timeframe,
               const int period,
               const ENUM_APPLIED_PRICE price,
               const int idx)
  {
   int PRI;
   double Price;
   double Range;
   double MaxHigh;
   double MinLow;
   double HighHigh;
   double HighClose;
   double HighLow;
   double LowHigh;
   double LowClose;
   double LowLow;

   switch(RangeMode)
     {
      case HIGH_LOW:
        {
         MaxHigh=iHigh(symbol,timeframe,
                 iHighest(symbol,timeframe,MODE_HIGH,period,idx));
         MinLow=iLow(symbol,timeframe,
                iLowest(symbol,timeframe,MODE_LOW,period,idx));
         break;
        }
      case CLOSE_CLOSE:
        {
         MaxHigh=iClose(symbol,timeframe,
                 iHighest(symbol,timeframe,MODE_CLOSE,period,idx));
         MinLow=iClose(symbol,timeframe,
                iLowest(symbol,timeframe,MODE_CLOSE,period,idx));
         break;
        }
      case HIGH_LOW_CLOSE:
        {
         HighHigh=iHigh(symbol,timeframe,
                  iHighest(symbol,timeframe,MODE_HIGH,period,idx));
         HighClose=iClose(symbol,timeframe,
                   iHighest(symbol,timeframe,MODE_CLOSE,period,idx));
         HighLow=iLow(symbol,timeframe,
                 iHighest(symbol,timeframe,MODE_LOW,period,idx));
         LowHigh=iHigh(symbol,timeframe,
                 iLowest(symbol,timeframe,MODE_HIGH,period,idx));
         LowClose=iClose(symbol,timeframe,
                  iLowest(symbol,timeframe,MODE_CLOSE,period,idx));
         LowLow=iLow(symbol,timeframe,
                iLowest(symbol,timeframe,MODE_LOW,period,idx));
         MaxHigh=(HighHigh+HighClose+HighLow)/3;
         MinLow =(LowHigh+LowClose+LowLow)/3;
         break;
        }
     }

   switch(price)
     {
      case PRICE_CLOSE:    Price = iClose(symbol,timeframe,idx);    break;
      case PRICE_HIGH:     Price = iHigh(symbol,timeframe,idx);     break;
      case PRICE_LOW:      Price = iLow(symbol,timeframe,idx);      break;
      case PRICE_MEDIAN:   Price =(iHigh(symbol,timeframe,idx)+
                                   iLow(symbol,timeframe,idx))/2;   break;
      case PRICE_TYPICAL:  Price =(iHigh(symbol,timeframe,idx)+
                                   iLow(symbol,timeframe,idx)+
                                   iClose(symbol,timeframe,idx))/3; break;
      case PRICE_WEIGHTED: Price =(iHigh(symbol,timeframe,idx)+
                                   iLow(symbol,timeframe,idx)+
                                   iClose(symbol,timeframe,idx)+
                                   iClose(symbol,timeframe,idx))/4; break;
      default:             Price = iClose(symbol,timeframe,idx);
     }

   Range=MaxHigh-MinLow;

   if(NormalizeDouble(Range,3)!=0.0)
     {
      PRI=100*(Price-MinLow)/Range;
      PRI-=50;
     }
   else PRI=0;
//if(PRI >  50)   PRI =  50;
//if(PRI < -50)   PRI = -50;
   return(PRI);
  }
//+------------------------------------------------------------------+
