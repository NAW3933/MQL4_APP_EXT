//+------------------------------------------------------------------+
//|                                                  smHull Mavg.mq4 |
//|                                 Copyright © 2009.04.07, SwingMan |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009.04.07, SwingMan"
#property link      ""

/*+------------------------------------------------------------------+ 
//Source:
//| HMA.mq4 
//| #property copyright "MT4 release WizardSerg <wizardserg@mail.ru>, 
//| #property link      "wizardserg@mail.ru" 
//|                         Revised by IgorAD,igorad2003@yahoo.co.uk |   
//|                                        http://www.forex-tsd.com/ |                                      
+------------------------------------------------------------------+*/

#property indicator_chart_window 
#property indicator_buffers 2 
#property indicator_color1 RoyalBlue
#property indicator_color2 DarkOrange
#property indicator_width1 4
#property indicator_width2 4


//---- extern parameters --------------------------------------------
extern int Hull_period=27;
extern double Hull_periodDivisor = 1.5;
extern int Hull_method=3; // MODE_LWMA 
extern int Hull_price =0;  // PRICE_CLOSE 
//+------------------------------------------------------------------+ 

//---- buffers 
double UpTrend[];
double DnTrend[];
double ExtHullBuffer[]; 


//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init() 
{ 
   IndicatorBuffers(3);  
   SetIndexBuffer(0, UpTrend); SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,indicator_width1); SetIndexLabel(0,"Hull UP trend");
   SetIndexBuffer(1, DnTrend); SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,indicator_width2); SetIndexLabel(1,"Hull DN trend");
   SetIndexBuffer(2, ExtHullBuffer); 
   ArraySetAsSeries(ExtHullBuffer, true);     
    
   IndicatorShortName("smHull Mavg("+Hull_period+")"); 
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);    
   return(0); 
} 

//+------------------------------------------------------------------+ 
//| Custor indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int deinit() 
{ 
   return(0); 
} 

//+------------------------------------------------------------------+ 
//| ?????????? ???????                                               | 
//+------------------------------------------------------------------+ 
double WMA(int x, int p) 
{ 
    return(iMA(NULL, 0, p, 0, Hull_method, Hull_price, x));    
} 

//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+ 
int start() 
{ 
   int counted_bars = IndicatorCounted(); 
    
   if(counted_bars < 0) return(-1); 
                  
   int x = 0;    
   int p = MathFloor(MathSqrt(Hull_period));
   int perVector = MathFloor(Hull_period/Hull_periodDivisor);   
               
   int e = Bars - counted_bars + Hull_period + 1; 
   if(e > Bars)  e = Bars;    
    
   double vect[], trend[];   
   ArraySetAsSeries(vect, true);  ArrayResize(vect, e);    
   ArraySetAsSeries(trend, true); ArrayResize(trend, e); 
    
   //---- first Hull vector
   for(x = 0; x < e; x++) 
      vect[x] = 2*WMA(x, perVector) - WMA(x, Hull_period);        

   for(x = 0; x < e-Hull_period; x++)     
      ExtHullBuffer[x] = iMAOnArray(vect, 0, p, 0, Hull_method, x);
    
   for(x = e-Hull_period; x >= 0; x--)
   {     
      trend[x] = trend[x+1];
      if (ExtHullBuffer[x]> ExtHullBuffer[x+1]) trend[x] =1;
      if (ExtHullBuffer[x]< ExtHullBuffer[x+1]) trend[x] =-1;
    
      if (trend[x]>0)
      { 
         UpTrend[x] = ExtHullBuffer[x]; 
         if (trend[x+1]<0) UpTrend[x+1]=ExtHullBuffer[x+1];
         DnTrend[x] = EMPTY_VALUE;
      }
      else              
      
      if (trend[x]<0)
      { 
         DnTrend[x] = ExtHullBuffer[x]; 
         if (trend[x+1]>0) DnTrend[x+1]=ExtHullBuffer[x+1];
         UpTrend[x] = EMPTY_VALUE;
      }              
   }    
   return(0); 
} 
//+------------------------------------------------------------------+ 