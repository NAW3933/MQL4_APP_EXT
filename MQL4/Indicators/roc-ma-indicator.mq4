//+------------------------------------------------------------------+
//|                                                       ROC_MA.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                                  Hartono Setiono |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Lime
//---- input parameters
extern int       MATimeFrame=0;
extern int       MAPeriod=7;
extern int       MAMethod=MODE_SMA;
extern int       MAAppliedPrice=PRICE_CLOSE;
extern int       ROCPeriod=14;
extern int       ROCMethod=MODE_SMA;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,ExtMapBuffer2);
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
   int limit,ExtCountedBars=IndicatorCounted();
   if (ExtCountedBars<0) return(-1);
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   if(pos<MAPeriod) pos=MAPeriod;
   
   limit=pos;
   //if(ExtCountedBars<1) 
   for(int i=1;i<MAPeriod;i++,pos--) {ExtMapBuffer1[pos]=0; ExtMapBuffer2[pos]=0;}
   
   while(pos>=0)
     {
       double maVal=iMA(NULL,MATimeFrame,MAPeriod,0,MAMethod,MAAppliedPrice,pos);
       ExtMapBuffer1[pos]=(Close[pos] - maVal)/Point;
       pos--;
     }

   for(i=limit; i>0; i--)
   {
     ExtMapBuffer2[i]=iMAOnArray(ExtMapBuffer1,0,ROCPeriod,0,ROCMethod,i);
   }
   return(0);
  }
//+------------------------------------------------------------------+