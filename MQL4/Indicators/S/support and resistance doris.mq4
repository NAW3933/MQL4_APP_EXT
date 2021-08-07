//+------------------------------------------------------------------+
//|                                 support and resistance doris.mq4 |
//|                                                           .....h |
//|                                                    hayseedfx.com |
//+------------------------------------------------------------------+
#property copyright ".....h"
#property link      "hayseedfx.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Lime


extern int support    =    242;
extern int resistance =    241;
//extern int limit      =     50;

double zig;
double zag;
double zigs[];
double zags[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  
int init()
  {

//---- 
  
   SetIndexStyle(0,DRAW_ARROW,EMPTY,1,Red);
   SetIndexStyle(1,DRAW_ARROW,EMPTY,1,Lime);
   
   SetIndexBuffer(0, zigs);
   SetIndexBuffer(1, zags);
   
   SetIndexArrow(0, support);
   SetIndexArrow(1, resistance);
   
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
   int counted_bars = IndicatorCounted();
   int i;

   i=Bars;               // limit
   while(i>=0)
     {
   
 zig = iCustom(NULL,0,"ZigZag",1,i);   
 if (zig > 0) 
   zigs[i]=High[i];
    else
      zigs[i] = zigs[i+1];
  
 zag = iCustom(NULL,0,"ZigZag",2,i); 
 if (zag > 0) 
   zags[i]=Low[i];
      else
      zags[i] = zags[i+1];

      i--;
     }   
   return(0);
  }
 
//+------------------------------------------------------------------+


