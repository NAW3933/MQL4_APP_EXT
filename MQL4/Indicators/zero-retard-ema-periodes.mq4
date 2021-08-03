#property copyright ""
#property link ""

#property  indicator_separate_window

#property  indicator_buffers 2
#property  indicator_color1  Red
#property  indicator_color2  DodgerBlue


#property indicator_level1 0
#property indicator_levelcolor DimGray
#property indicator_levelstyle STYLE_SOLID
#property indicator_levelwidth 0


#define  LENGTH		1000

//---- 

extern int periodFast  = 10;
extern int periodSlow  = 25;
extern int maType      = 1; // 1=EMA
extern int maPice      = 0; // 0=close
extern int periodSignal=7;
extern int SignalMode  = 0;
double     ExtBuffer0[];
double     buffer2[1000], buffer3[1000];
double     SignalBuffer[];

//------------------------------------------------------------------+

int init()
{
   switch(maType)
   {
      case 0:
         string type = "SMA"; 
         break;
      case 1:
         type = "EMA";
         break;
      case 2:
         type = "SMMA";
         break;
      case 3:
         type = "LWMA";
         break;
   }

   IndicatorDigits(Digits);
   IndicatorShortName("Zéro Retard "+type+" Periodes = "+periodFast+" / "+periodSlow+" ");

   IndicatorBuffers(2);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtBuffer0);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,SignalBuffer);
   
   ArrayInitialize(buffer2,0.0);
   ArrayInitialize(buffer3,0.0);
   
   ArraySetAsSeries(buffer2,True);
   ArraySetAsSeries(buffer3,True);

   return(0);
}

//------------------------------------------------------------------+

int deinit()
{

   return(0);
}

//------------------------------------------------------------------+

int start()
{
   int counted_bars=IndicatorCounted();
   int limit, i;
   
   if(counted_bars<0) return(-1);

   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

   if (limit > LENGTH) limit = LENGTH;
  
   for(i=limit; i>=0; i--)  {
   
      //MM Courte 
      buffer2[i] = iMA(NULL, 0, periodFast, 0, maType, PRICE_CLOSE, i);
      double ma5 = iMAOnArray(buffer2,0, periodFast, 0, maType, i);
      double diff=buffer2[i]-ma5;
      double indic=buffer2[i]+diff;

      //MM longue 
      buffer3[i] = iMA(NULL, 0, periodSlow, 0, maType, PRICE_CLOSE, i);
      double ma5L = iMAOnArray(buffer3, 0, periodSlow, 0, maType, i);
      double diffL=buffer3[i]-ma5L;
      double indicL=buffer3[i]+diffL;

      ExtBuffer0[i]=indic-indicL;
   }
   for(i=limit; i>=0; i--)
   SignalBuffer[i]=iMAOnArray(ExtBuffer0,Bars,periodSignal,0,SignalMode,i);
   
return(0);
}
//------------------------------------------------------------------+