//+------------------------------------------------------------------+
//|                                                          ROC.mq4 |
//|                                    Copyright ? 2006, Robert Hill |
//+------------------------------------------------------------------+

#property  copyright "Copyright ? 2006, Robert Hill"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Red
//---- indicator parameters
extern int RPeriod = 10;
extern bool UsePercent = false;
//---- indicator buffers
double RateOfChange[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0, DRAW_LINE);
   SetIndexDrawBegin(0, RPeriod);
   IndicatorDigits(Digits + 1);
//---- indicator buffers mapping
   if(!SetIndexBuffer(0, RateOfChange))
       Print("cannot set indicator buffers!");
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("ROC(" + RPeriod + ")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   double ROC, CurrentClose, PrevClose;
   int counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars - RPeriod;
//---- ROC calculation
   for(int i = 0; i < limit; i++)
     {
       CurrentClose = iClose(NULL, 0, i);
       PrevClose = iClose(NULL, 0, i + RPeriod);
       ROC = CurrentClose - PrevClose;
       //----
       if(UsePercent)
         {
           if(PrevClose != 0)
               RateOfChange[i] = 100 * ROC / PrevClose;
         }
       else
           RateOfChange[i] = ROC;
     }   
//---- done
   return(0);
  }
//+------------------------------------------------------------------+