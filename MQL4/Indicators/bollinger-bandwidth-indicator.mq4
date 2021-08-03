//+-------------------------------------------------------------------+
//|                                                    Bandswidth.mq4 |
//|                                         by Linuxser for Forex TSD |
//|                                                                   |
//| John Bollinger original formula is:                               |
//| (Upper BB - Lower BB)/middle BB                                   |
//+-------------------------------------------------------------------+
#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Yellow


//---- input parameters
extern int BBPeriod=20;
extern int StdDeviation=2;
//---- buffers
double BLGBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,BLGBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="Bandswidth("+BBPeriod+","+StdDeviation+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,BBPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Momentum                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=BBPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=BBPeriod;i++) BLGBuffer[Bars-i]=0.0;
//----
   i=Bars-BBPeriod-1;
   if(counted_bars>=BBPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      BLGBuffer[i]= (iBands(NULL,0,BBPeriod,StdDeviation,0,PRICE_CLOSE,MODE_UPPER,i) - iBands(NULL,0,BBPeriod,StdDeviation,0,PRICE_CLOSE,MODE_LOWER,i))
      /iMA(NULL,0,BBPeriod,0,MODE_SMA,PRICE_CLOSE,i);
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+