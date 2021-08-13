//+------------------------------------------------------------------+
//|                                             AUTO_STOP_REVERS.mq4 |
//|                                                           "pip"  |
//+------------------------------------------------------------------+

#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_buffers 2

extern int Range=14;
extern int ATR=14;
double ExtGlistoBuffer[];
double ExtGlistoBuffer2[];

//----------------------------------------------------------------+

int init()
{
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID);
   SetIndexBuffer(0, ExtGlistoBuffer);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID);
   SetIndexBuffer(1, ExtGlistoBuffer2);
   SetIndexArrow(1,159);
   SetIndexArrow(0,159);
   return(0);
}

void start()
{
  ExtGlistoBuffer[0] = EMPTY_VALUE;
  ExtGlistoBuffer2[0] = EMPTY_VALUE;

  int counted = IndicatorCounted();
  if (counted < 0) return (-1);
  
  if (counted > 0) counted--;
  int limit = Bars-counted;
  
  for (int i=limit; i >= 0; i--)
  {
double ma  =iSAR(NULL,0,0.02,0.2,i);
double ma1 =iSAR(NULL,0,0.02,0.2,i);

double dma;
       
     dma=iADX(NULL, 0, 14,PRICE_MEDIAN,MODE_MAIN, i);
     
    if (
    iADX(NULL, 0, 14,PRICE_CLOSE,MODE_MAIN, i)>iADX(NULL, 0, 14,PRICE_CLOSE,MODE_MAIN, i+1)
    &&
    dma>25
    &&
    dma<40
    )// 
      ExtGlistoBuffer[i] =iSAR(NULL,0,0.02,0.2,i) ;

    if (
    iADX(NULL, 0, 14,PRICE_CLOSE,MODE_MAIN, i)<iADX(NULL, 0, 14,PRICE_CLOSE,MODE_MAIN, i+1)
    ||
    dma<25
    ||
    dma>40
    )
      ExtGlistoBuffer2[i] =iSAR(NULL,0,0.1,0.5,i);
  }
}