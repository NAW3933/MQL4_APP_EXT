//+------------------------------------------------------------------+
//|                                                    ATR Darma.mq4 |
//+------------------------------------------------------------------+

//---- indicator settings

#property indicator_separate_window

#property indicator_buffers 2

#property indicator_color1 Purple

#property indicator_color2 LightSeaGreen

#property indicator_level1 1

//---- indicator parameters

extern int ATR_Period      = 30;
extern int SignalLine_Period   =  20;
extern int SignalLineShift     =  0;
extern int SignalLineMa_Method =  0; // 0 SMA , 1 EMA , 2 SMMA , 3 LWMA
extern int ShowBars            = 500;

//---- indicator buffers

double ATR_Buffer[];
double MA_ATR_Buffer[];

int    draw_begin0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
 {

//---- indicator buffers mapping
  
//---- drawing settings
  
  draw_begin0 = ATR_Period;
  
  SetIndexEmptyValue(1,0.0000);
  SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
  SetIndexBuffer(1,ATR_Buffer);
  SetIndexLabel(1,"ATR");
  SetIndexDrawBegin(1,draw_begin0);
  
  SetIndexEmptyValue(0,0.0000);
  SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
  SetIndexBuffer(0,MA_ATR_Buffer);
  SetIndexLabel(0," ("+SignalLine_Period+") Period MA of ATR");
  SetIndexDrawBegin(0,draw_begin0);
  
  
//---- name for DataWindow and indicator subwindow label
  
  IndicatorShortName("ATR Darma");
  
  
//---- initialization done
  return(0);
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int start() {

   int limit,i,shift;
   int counted_bars=IndicatorCounted();

//---- check for possible errors
  if(counted_bars<1)
      for(i=1;i<=draw_begin0;i++) 
         MA_ATR_Buffer[Bars-i]=0; ATR_Buffer[Bars-i]=0;

//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
//limit=Bars-counted_bars;
   limit = ShowBars;
   if (ShowBars >= Bars) limit = Bars - 1;

//-----------------------------------------------------------------------------------------------------------------

//---- ATR_Buffer
  
   for(i=0; i<limit; i++)
      ATR_Buffer[i] = iATR(Symbol(),0,ATR_Period,i);

//---- MA_ATR_Buffer
  
   for(i=0; i<limit; i++)
      MA_ATR_Buffer[i]=iMAOnArray(ATR_Buffer,0,SignalLine_Period,SignalLineShift,SignalLineMa_Method,i);

//-----------------------------------------------------------------------------------------------------------------

//---- done
   return(0);
}

