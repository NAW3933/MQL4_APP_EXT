#property copyright "DNK"
#property link      "slysov@yandex.ru"
#include <WinUser32.mqh>


#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Lime
#property indicator_color2 DodgerBlue
#property indicator_color3 Red
#property indicator_color4 Brown
#property indicator_color5 Lime

//-------------------------------------------------------------------
extern int basket = 14;

extern string Currency = "##T101##";

extern bool UseWeighting = false;

extern int MaxBars = 1000;

extern int TF = 0;

extern string Symbols="";

extern int Yoffset = 0;

bool Visual=false;

string Pair_suffix;

string shortname;


//---- buffers
double ExtMapBuffer1[];

double ExtMapBuffer1_High[];
double ExtMapBuffer1_Low[];
double ExtMapBuffer1_Open[];
double ExtMapBuffer1_Volume[];

//---

int length;

string Pair[14];
double A_Pair[14]; 
double A_Pair_H[14]; 
double A_Pair_L[14]; 
double A_Pair_O[14]; 
double A_Pair_V[14]; 


int StartBar;

static int ExtHandle=-1;
static int tf = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{

   Pair_suffix=StringSubstr(Symbol(),6,StringLen(Symbol())-6);
   
   shortname = "T101 Price v6 (" + basket + ")";

   IndicatorShortName(shortname);
   
   if (Visual) SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   else SetIndexStyle(0,DRAW_NONE,STYLE_DOT);
   SetIndexLabel (0, "BuyAll");
   SetIndexBuffer(0,ExtMapBuffer1);

   if (Visual) SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   else SetIndexStyle(1,DRAW_NONE,STYLE_DOT);
   SetIndexLabel (1, "BuyAll_H");
   SetIndexBuffer(1,ExtMapBuffer1_High);

   if (Visual) SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
   else SetIndexStyle(2,DRAW_NONE,STYLE_DOT);
   SetIndexLabel (2, "BuyAll_L");
   SetIndexBuffer(2,ExtMapBuffer1_Low);

   SetIndexStyle(3,DRAW_NONE,STYLE_DOT);
   SetIndexBuffer(3,ExtMapBuffer1_Open);

   SetIndexStyle(4,DRAW_NONE,STYLE_DOT);
   SetIndexBuffer(4,ExtMapBuffer1_Volume);

//---
   int pos=0;
   if (basket==0 && StringLen (Symbols) > 0) {
    while (true) {
     Pair[basket]=StringSubstr(Symbols,pos,6);
     pos+=7;
     basket++;
     if (pos >= StringLen (Symbols)) break;
    }
   } else {
 
   //basket ---------------------------------------------------------
  
   switch (basket)
               {
                 case 1:
                  Pair[0]  = "GBPJPY"+Pair_suffix;
                  Pair[1]  = "";
                  Pair[2]  = "";
                  Pair[3]  = "";
                  Pair[4]  = "";
                  Pair[5]  = "";
                  Pair[6]  = "";

                  Pair[7]  = "";
                  Pair[8]  = "";
                  Pair[9]  = "";
                  Pair[10] = "";
                  Pair[11] = "";
                  Pair[12] = "";
                  Pair[13] = "";
                  break;
                 case 2:
                  Pair[0]  = "GBPUSD"+Pair_suffix;
                  Pair[1]  = "EURUSD"+Pair_suffix;
                  Pair[2]  = "";
                  Pair[3]  = "";
                  Pair[4]  = "";
                  Pair[5]  = "";
                  Pair[6]  = "";

                  Pair[7]  = "";
                  Pair[8]  = "";
                  Pair[9]  = "";
                  Pair[10] = "";
                  Pair[11] = "";
                  Pair[12] = "";
                  Pair[13] = "";
                  break;
                 case 4:
                  Pair[0]  = "GBPUSD"+Pair_suffix;
                  Pair[1]  = "EURJPY"+Pair_suffix;
                  Pair[2]  = "EURUSD"+Pair_suffix;
                  Pair[3]  = "GBPJPY"+Pair_suffix;
                  Pair[4]  = "";
                  Pair[5]  = "";
                  Pair[6]  = "";

                  Pair[7]  = "";
                  Pair[8]  = "";
                  Pair[9]  = "";
                  Pair[10] = "";
                  Pair[11] = "";
                  Pair[12] = "";
                  Pair[13] = "";
                  break;
                 case 6:
                  Pair[0]  = "GBPUSD"+Pair_suffix;
                  Pair[1]  = "EURJPY"+Pair_suffix;
                  Pair[2]  = "AUDUSD"+Pair_suffix;
                  Pair[3]  = "EURUSD"+Pair_suffix;
                  Pair[4]  = "GBPJPY"+Pair_suffix;
                  Pair[5]  = "NZDUSD"+Pair_suffix;
                  Pair[6]  = "";

                  Pair[7]  = "";
                  Pair[8]  = "";
                  Pair[9]  = "";
                  Pair[10] = "";
                  Pair[11] = "";
                  Pair[12] = "";
                  Pair[13] = "";
                  break;
                 case 8:
                  Pair[0]  = "GBPUSD"+Pair_suffix;
                  Pair[1]  = "EURJPY"+Pair_suffix;
                  Pair[2]  = "AUDUSD"+Pair_suffix;
                  Pair[3]  = "NZDJPY"+Pair_suffix;
                  Pair[4]  = "EURUSD"+Pair_suffix;
                  Pair[5]  = "GBPJPY"+Pair_suffix;
                  Pair[6]  = "NZDUSD"+Pair_suffix;

                  Pair[7] = "AUDJPY"+Pair_suffix;
                  Pair[8]  = "";
                  Pair[9]  = "";
                  Pair[10]  = "";
                  Pair[11] = "";
                  Pair[12] = "";
                  Pair[13] = "";
                  break;
                 case 10:
                  Pair[0]  = "GBPUSD"+Pair_suffix;
                  Pair[1]  = "EURGBP"+Pair_suffix;
                  Pair[2]  = "GBPJPY"+Pair_suffix;
                  Pair[3]  = "CADJPY"+Pair_suffix;
                  Pair[4]  = "NZDUSD"+Pair_suffix;
                  Pair[5]  = "EURUSD"+Pair_suffix;
                  Pair[6]  = "USDJPY"+Pair_suffix;
                  
                  Pair[7]  = "AUDUSD"+Pair_suffix;
                  Pair[8] = "NZDJPY"+Pair_suffix;
                  Pair[9] = "GBPCHF"+Pair_suffix;
                  Pair[10]  = "";
                  Pair[11]  = "";
                  Pair[12] = "";
                  Pair[13] = "";
                  break;
                 case 12:
                  Pair[0]  = "GBPUSD"+Pair_suffix;
                  Pair[1]  = "EURGBP"+Pair_suffix;
                  Pair[2]  = "GBPJPY"+Pair_suffix;
                  Pair[3]  = "CADJPY"+Pair_suffix;
                  Pair[4]  = "NZDUSD"+Pair_suffix;
                  Pair[5]  = "AUDJPY"+Pair_suffix;

                  Pair[6]  = "EURUSD"+Pair_suffix;
                  Pair[7]  = "USDJPY"+Pair_suffix;
                  Pair[8]  = "AUDUSD"+Pair_suffix;
                  Pair[9] = "NZDJPY"+Pair_suffix;
                  Pair[10] = "GBPCHF"+Pair_suffix;
                  Pair[11] = "CHFJPY"+Pair_suffix;
                  Pair[12]  = "";
                  Pair[13] = "";
                  break;
                 case 14:
                  Pair[0] = "GBPUSD"+Pair_suffix; 
                  Pair[1] = "EURGBP"+Pair_suffix; 
                  Pair[2] = "GBPJPY"+Pair_suffix; 
                  Pair[3] = "USDCHF"+Pair_suffix; 
                  Pair[4] = "NZDUSD"+Pair_suffix;
                  Pair[5] = "AUDJPY"+Pair_suffix; 
                  Pair[6] = "EURJPY"+Pair_suffix; 
                  Pair[7] = "EURUSD"+Pair_suffix; 
                  Pair[8] = "USDJPY"+Pair_suffix; 
                  Pair[9] = "AUDUSD"+Pair_suffix;
                  Pair[10] = "NZDJPY"+Pair_suffix; 
                  Pair[11] = "GBPCHF"+Pair_suffix; 
                  Pair[12] = "CHFJPY"+Pair_suffix; 
                  Pair[13] = "EURCHF"+Pair_suffix;
                  break;
                 default: break;
               }
   }
   
   length = basket;

   if (TF==0) tf = Period();
   else tf = TF;
   
//Create initial file
   int    version=400;
   string c_copyright;


   string c_symbol=Currency;
   int    i_period=tf;
   int    i_digits=MarketInfo (Symbol(),MODE_DIGITS);


   int    i_unused[13];


//DNK - indentify
   i_unused[0]=3; i_unused[1]=3; i_unused[2]=3;

//----  
   ExtHandle=FileOpenHistory(c_symbol+i_period+".hst", FILE_BIN|FILE_WRITE);
   if(ExtHandle < 0) return(-1);
//---- write history file header
   c_copyright="(C)opyright 2010, DNK";
   FileWriteInteger(ExtHandle, version, LONG_VALUE);
   FileWriteString(ExtHandle, c_copyright, 64);
   FileWriteString(ExtHandle, c_symbol, 12);
   FileWriteInteger(ExtHandle, i_period, LONG_VALUE);
   FileWriteInteger(ExtHandle, i_digits, LONG_VALUE);
   FileWriteInteger(ExtHandle, 0, LONG_VALUE);       //timesign
   FileWriteInteger(ExtHandle, 0, LONG_VALUE);       //last_sync
   FileWriteArray(ExtHandle, i_unused, 0, 13);
   FileFlush(ExtHandle);


//Init message ObjectCreate

if (ObjectFind (Currency+shortname+tf)==-1) {
 ObjectCreate (Currency+shortname+tf,OBJ_LABEL,0,0,0);
 ObjectSet (Currency+shortname+tf,OBJPROP_CORNER,3);
 ObjectSet (Currency+shortname+tf,OBJPROP_XDISTANCE, 20);
 ObjectSet (Currency+shortname+tf,OBJPROP_YDISTANCE, Yoffset+20);
}

   return(0);
  }
//---- 
int deinit() {
   FileFlush(ExtHandle);
   FileClose(ExtHandle);
   ObjectDelete (Currency+shortname+tf);
   return(0);
}

//####################################################################
//+------------------------------------------------------------------+
//| Main program
//+------------------------------------------------------------------+
static datetime lastbar = 0;
static int last_fpos = 0;
static int hwnd;
static datetime last_time=0;

int start()
{


   if (ExtHandle==-1) Print ("Error");
   
   int counted_bars=IndicatorCounted();
   //---- check for possible errors
   if(counted_bars<0) return(-1);
   
   StartBar = MaxBars;
   
   if (counted_bars>0) StartBar=Bars-counted_bars;

   //---- main loop
   for(int i=StartBar; i>=0; i--)
   {
      if (lastbar < iTime(Symbol(),tf,i)) {
       last_fpos=FileTell(ExtHandle);
       lastbar=iTime(Symbol(),tf,i);
      } else {
       FileSeek(ExtHandle,last_fpos,SEEK_SET);  
      }

      datetime timebar=iTime(Symbol(),tf,i);

      if (UseWeighting) {
         double weight_calc=0;
         for(int j = 0; j < length; j++) {
          weight_calc = weight_calc + GetTickValue (Pair[j],i);
         }
      }

      double sum_A_Pair=0.0;
      double sum_A_Pair_H=0.0;
      double sum_A_Pair_L=0.0;
      double sum_A_Pair_O=0.0;
      double sum_A_Pair_V=0.0;

      
      for (j=0;j<length;j++)
      {
         int shift=iBarShift(Pair[j],tf,timebar);
         if (iTime(Pair[j],tf,i)>iTime(Pair[j],tf,shift)) {
            shift++;         
         } 

         A_Pair[j] = (iClose(Pair[j],tf,shift))/MarketInfo(Pair[j],MODE_POINT);
         A_Pair_H[j] = (iHigh(Pair[j],tf,shift))/MarketInfo(Pair[j],MODE_POINT);
         A_Pair_L[j] = (iLow(Pair[j],tf,shift))/MarketInfo(Pair[j],MODE_POINT);
         A_Pair_O[j] = (iOpen(Pair[j],tf,shift))/MarketInfo(Pair[j],MODE_POINT);
         A_Pair_V[j] = iVolume(Pair[j],tf,shift);

         if (UseWeighting) {
          double weight=GetTickValue (Pair[j],shift)/weight_calc;
          
          A_Pair[j] = A_Pair[j]*weight;
          A_Pair_H[j] = A_Pair_H[j]*weight;
          A_Pair_L[j] = A_Pair_L[j]*weight;
          A_Pair_O[j] = A_Pair_O[j]*weight;
          A_Pair_V[j] = A_Pair_V[j]*weight;
         }

         sum_A_Pair=sum_A_Pair+A_Pair[j];
         sum_A_Pair_H=sum_A_Pair_H+A_Pair_H[j];
         sum_A_Pair_L=sum_A_Pair_L+A_Pair_L[j];
         sum_A_Pair_O=sum_A_Pair_O+A_Pair_O[j];
         sum_A_Pair_V=sum_A_Pair_V+A_Pair_V[j];

 
      }   

         if (!UseWeighting) {
            sum_A_Pair=sum_A_Pair/length;
            sum_A_Pair_H=sum_A_Pair_H/length;
            sum_A_Pair_L=sum_A_Pair_L/length;
            sum_A_Pair_O=sum_A_Pair_O/length;
            sum_A_Pair_V=sum_A_Pair_V/length;
         }

      ExtMapBuffer1[i] = sum_A_Pair;
      ExtMapBuffer1_Low[i] = sum_A_Pair_L;
      ExtMapBuffer1_High[i] = sum_A_Pair_H;
      ExtMapBuffer1_Open[i] = sum_A_Pair_O;
      ExtMapBuffer1_Volume[i] = sum_A_Pair_V;

      
      FileWriteInteger(ExtHandle, lastbar, LONG_VALUE);
      FileWriteDouble(ExtHandle, ExtMapBuffer1_Open[i], DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, ExtMapBuffer1_Low[i], DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, ExtMapBuffer1_High[i], DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, ExtMapBuffer1[i], DOUBLE_VALUE);
      FileWriteDouble(ExtHandle, ExtMapBuffer1_Volume[i], DOUBLE_VALUE);
      FileFlush(ExtHandle);
      
   }
   
   int cur_time=LocalTime();
   
         if(hwnd==0)
           {
            hwnd=WindowHandle(Currency,tf);
            if(hwnd!=0) Print("Chart window detected");
           }
         //---- refresh window not frequently than 1 time in 2 seconds
         if(hwnd!=0 && cur_time-last_time>=2)
           {
            PostMessageA(hwnd,WM_COMMAND,33324,0);
            last_time=cur_time;

           }
if (ObjectFind (Currency+shortname+tf)==-1) {
 ObjectCreate (Currency+shortname+tf,OBJ_LABEL,0,0,0);
 ObjectSet (Currency+shortname+tf,OBJPROP_CORNER,3);
 ObjectSet (Currency+shortname+tf,OBJPROP_XDISTANCE, 20);
 ObjectSet (Currency+shortname+tf,OBJPROP_YDISTANCE, Yoffset+20);
}
   ObjectSetText (Currency+shortname+tf,Currency+","+tf+"-RUNNING",8,"",Green);

   return(0);
}
//+------------------------------------------------------------------+

bool RealSymbol( string Str )
{
  return(MarketInfo(Str, MODE_BID) != 0);
}
 
double GetTickValue( string Symb , int offset) {
  string Str, ProfitCurrency, SymbolPrefix;
  double Res, PriceExchage;
 
  string BaseCurrency = AccountCurrency();
 
  ProfitCurrency = StringSubstr(Symb, 3, 3);
  SymbolPrefix = StringSubstr(Symb, 6);
 
  if (ProfitCurrency == BaseCurrency)
    Res = MarketInfo(Symb, MODE_LOTSIZE) * MarketInfo(Symb, MODE_TICKSIZE);
  else
  {
    Str = BaseCurrency + ProfitCurrency + SymbolPrefix;
 
 
    if (RealSymbol(Str))
    {
      double spread = MarketInfo (Str, MODE_SPREAD);
      PriceExchage = iClose(Str,tf,offset)+spread*MarketInfo(Str,MODE_POINT);
      Res = MarketInfo(Symb, MODE_LOTSIZE) * MarketInfo(Symb, MODE_TICKSIZE) / PriceExchage;    
    }     else    {
      Str = ProfitCurrency + BaseCurrency + SymbolPrefix;
      spread = MarketInfo (Str, MODE_SPREAD);
      PriceExchage = iClose(Str,tf,offset)-spread*MarketInfo(Str,MODE_POINT);
      Res = MarketInfo(Symb, MODE_LOTSIZE) * MarketInfo(Symb, MODE_TICKSIZE) * PriceExchage;
    }
  }
 
  return(Res);
}