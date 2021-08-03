//+------------------------------------------------------------------+
//|                                                     ATR Pips.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Joshua Jones"
#property link      "http://www.forexfactory.com"

#property indicator_chart_window
#property indicator_buffers 2

//---- input parameters

extern int periods = 14;
extern double multiplier = 1.5;
int pipMult = 10000;
double ATR[];
double SL[];

string prefix = "";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   
   //Setup PIPS
   if (StringFind(Symbol(),"JPY",0) != -1)
   {
      pipMult = 100;
   }
   /*
   if (multiplier != 1.0)
   {
      int percentage = multiplier*100;
      prefix = percentage + "% of ";
   }
   */
   //Indicator Name
   IndicatorShortName(prefix + "ATR / SL (" + periods + ")");  
   IndicatorDigits(0);
   //Buffer 0, TP 
   SetIndexBuffer(0,ATR);
   SetIndexLabel(0,"ATR");
   SetIndexStyle(0,DRAW_NONE);
   //Buffer 1, SL
   SetIndexBuffer(1,SL);
   SetIndexLabel(1,"StopLoss x" + multiplier);
   SetIndexStyle(1,DRAW_NONE);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int limit;  
   int counted_bars=IndicatorCounted(); 
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   
   limit=Bars-counted_bars;


      for (int i = 0; i < limit; i++){
         double stopLoss = MathCeil(pipMult * (iATR(NULL,0,periods,i)));
         ATR[i] = stopLoss;
         SL[i]=ATR[i]*multiplier;
      }
      
      
//      Comment("\n", prefix, "ATR (", periods, ")   TP:   ", TP[i], " pips", "   SL:  ", SL[i], " pips");
      
      return(0);
  }
//+------------------------------------------------------------------+


