//+------------------------------------------------------------------+
//|                            Soho_Williams_VIX_fix_price_V1.20.mq4 |
//|                                                                  |
//+------------------------------------------------------------------+

/**********************************************************************
* This is a Synthetic VIX indicator as described in the December 2007 *
* issue of "Active Trader" magazine.  The indicator is also named the *
* "Williams VIX Fix" since Larry Williams is credited with the        *
* formula's discovery.                                                *
*                                                                     *
* This indicator was coded by Matthew Ebersviller.   
 and modified by sohocool the 07/01/2011   and 01/08/2015              *
**********************************************************************/




#property copyright "sohocool idea"
#property link       ""

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 3
#property indicator_color2 Red
#property indicator_width2 2

extern int VIX_Period = 22;
extern int FilterPeriod =5;
extern ENUM_APPLIED_PRICE PRICE =3;//3=low
extern int SignalPeriod=9;
extern ENUM_MA_METHOD SignalMaMode=0;

double VixBuffer[],up[];


int init() {
   string short_name;
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(0,VixBuffer);
   SetIndexBuffer(1,up);
   
   
   short_name="SOHO_VIX_V1.20("+VIX_Period+")";
   
   IndicatorShortName(short_name);
   
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"Signal");

   SetIndexDrawBegin(0,VIX_Period);
   
   return(0);
}

int deinit()
  {
   return(0);
  }

int start()
  {
   int i, counted_bars=IndicatorCounted();
   
   if(Bars<=VIX_Period) return(0);
   
   if(counted_bars<1) {
      for(i=1;i<=VIX_Period;i++) {
         VixBuffer[Bars-i]=0.0;
      }
   }

   int limit=Bars-counted_bars;
   if (counted_bars>0) limit++;
   for(i=0; i<limit; i++)       VixBuffer[i]=VIX(i);
       for(i=0; i<limit; i++)       up[i] =iMAOnArray(VixBuffer,0,SignalPeriod,0,SignalMaMode,i);
         
      
      
   return(0);
  }
//+------------------------------------------------------------------+

double VIX(int shift) {
  double highClose,price,vix;
  highClose = Close[iHighest(NULL,0,MODE_CLOSE,VIX_Period,shift)];
  price = iMA(NULL,0,FilterPeriod,0,3,PRICE,shift);
  vix = -100 *(highClose - price) / highClose ;
  return (vix);
}
  