//+------------------------------------------------------------------+
//|                           PVO (Percentage Volume Oscillator).mq4 |
//|                                   Copyright © 2009, Serega Lykov |
//|                                       http://mtexperts.narod.ru/ |
//+------------------------------------------------------------------+

#property copyright ""
#property link      ""

//---- property of indicator ----------------------------------------+
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1 Gray
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Magenta
#property indicator_color5 Blue
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_level1 0
#property indicator_levelcolor Snow

//---- external parameters ------------------------------------------+
extern int    FastMA_Period          = 12;
extern int    FastMA_Method          = 1;
extern int    SlowMA_Period          = 26;
extern int    SlowMA_Method          = 1;
extern int    SignalMA_Period        = 9;
extern int    SignalMA_Method        = 1;

//---- buffers ------------------------------------------------------+
static double PVOBuffer[];
static double SignalBuffer[];
static double HistBuffer[];
static double HistUpBuffer[];
static double HistDownBuffer[];
static double VolumeBuffer[];

//---- global variables ---------------------------------------------+
static int    draw_begin;

//-------------------------------------------------------------------+
//---- initialization of indicator ----------------------------------+
//-------------------------------------------------------------------+
int init()
  {
   //---- the 1 additional buffer -----------------------------------+
   IndicatorBuffers(6);
   //---- set a "short" name of the indicator -----------------------+
   IndicatorShortName(StringConcatenate("PVO(",DoubleToStr(FastMA_Period,0),",",DoubleToStr(SlowMA_Period,0),",",DoubleToStr(SignalMA_Period,0),")"));
   //---- set a accuracy of values of the indicator -----------------+
   IndicatorDigits(4);
   //---- set a style for line --------------------------------------+
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID);
   //---- set a arrays for line -------------------------------------+
   SetIndexBuffer(0,HistBuffer);
   SetIndexBuffer(1,HistUpBuffer);
   SetIndexBuffer(2,HistDownBuffer);
   SetIndexBuffer(3,SignalBuffer);
   SetIndexBuffer(4,PVOBuffer);
   SetIndexBuffer(5,VolumeBuffer);
   //---- set a first bar for drawing the line ----------------------+
   if(SignalMA_Period <= 1) SignalMA_Period = 0;
   draw_begin = MathMax(FastMA_Period,SlowMA_Period) + SignalMA_Period;
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
   SetIndexDrawBegin(2,draw_begin);
   SetIndexDrawBegin(3,draw_begin);
   SetIndexDrawBegin(4,draw_begin);
   //---- set a names for lines -------------------------------------+
   SetIndexLabel(0,"Hist");
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,"Signal");
   SetIndexLabel(4,"PVO");
   SetIndexLabel(5,NULL);
   //---- finish of initialization ----------------------------------+
   return(0);
  }

//-------------------------------------------------------------------+
//---- deinitialization of indicator --------------------------------+
//-------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }

//-------------------------------------------------------------------+
//---- PVO (Percentage Volume Oscillator) ---------------------------+
//-------------------------------------------------------------------+
int start()
  {
   //---- if on the chart there are not enough bars the indicator is not calculate
   if(Bars <= draw_begin) return(0);
   //---- amount not changed bars after last call of the indicator --+
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(-1);
   //---- last counted bar will be counted --------------------------+
   if(counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   //---- calculate values of indicator -----------------------------+
   for(int i=0; i<limit; i++) VolumeBuffer[i] = Volume[i];
   for(i=0; i<limit; i++)
     {
      double fast_ma = iMAOnArray(VolumeBuffer,0,FastMA_Period,0,FastMA_Method,i);
      double slow_ma = iMAOnArray(VolumeBuffer,0,SlowMA_Period,0,SlowMA_Method,i);
      PVOBuffer[i] = (fast_ma - slow_ma) / fast_ma * 100;
     }
   if(SignalMA_Period > 0)
     {
      for(i=0; i<limit; i++)
        {
         SignalBuffer[i] = iMAOnArray(PVOBuffer,0,SignalMA_Period,0,SignalMA_Method,i);
         HistBuffer[i] = PVOBuffer[i] - SignalBuffer[i];
        }
      DrawHist2Color(HistBuffer,HistUpBuffer,HistDownBuffer,limit);
     }
   else
     {
      for(i=0; i<limit; i++)
        {
         SignalBuffer[i]   = EMPTY_VALUE;
         HistBuffer[i]     = EMPTY_VALUE;
         HistUpBuffer[i]   = EMPTY_VALUE;
         HistDownBuffer[i] = EMPTY_VALUE;
        }
     }
   //---- finish of iteration ---------------------------------------+
   return(0);
  }

//-------------------------------------------------------------------+
//---- DrawHist2Color -----------------------------------------------+
//-------------------------------------------------------------------+
void DrawHist2Color(double &array[], double &array_up[], double &array_down[], int limit)
  {
   for(int i=0; i<limit; i++)
     {
      if(array[i] > array[i+1])
        {
         array_up[i]   = array[i];
         array_down[i] = EMPTY_VALUE;
        }
      else
        {
         if(array[i] < array[i+1])
             {
              array_down[i] = array[i];
              array_up[i]   = EMPTY_VALUE;
             }
         else
           {
            if(array_down[i+1] != EMPTY_VALUE)
              {
               array_up[i]   = array[i];
               array_down[i] = EMPTY_VALUE;
              }
            else
              {
               array_down[i] = array[i];
               array_up[i]   = EMPTY_VALUE;
              }
           }
        }
     }
  }
  
//-------------------------------------------------------------------+