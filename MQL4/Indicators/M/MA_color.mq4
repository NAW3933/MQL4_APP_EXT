//+------------------------------------------------------------------+
//|                                                MA_In_Color.mq4   |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//+------------------------------------------------------------------+
//mod2009fxtsd
#property  copyright "Copyright © 2006, FX Sniper and Robert Hill"
#property  link      "http://www.metaquotes.net/"

//---- indicator settings

#property  indicator_chart_window
#property  indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Green

extern int       MAPeriod=1;
extern int       MAMode =1;
extern int       MAPrice=0;

//---- buffers

double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];


//+------------------------

int init()
  {
   
   SetIndexBuffer(0,ExtMapBuffer2);
   SetIndexBuffer(1,ExtMapBuffer3);
   SetIndexBuffer(2,ExtMapBuffer4);
   SetIndexBuffer(3,ExtMapBuffer5);
   

   IndicatorShortName( "MA "+MAPeriod );
//---- 
   return(0);
  }

//-------------------------------
int start()
 {
  
   int limit;
   int counted_bars = IndicatorCounted();
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
   limit = Bars - counted_bars;


   for(int i=limit; i>=0; i--)
   {
      double ma0=iMA(NULL,0,MAPeriod,0,MAMode,MAPrice,i);
      double ma1=iMA(NULL,0,MAPeriod,0,MAMode,MAPrice,i+1);
         
//=========          

       ExtMapBuffer2[i] = EMPTY_VALUE;       ExtMapBuffer3[i] = EMPTY_VALUE; 
       ExtMapBuffer4[i] = EMPTY_VALUE;       ExtMapBuffer5[i] = EMPTY_VALUE; 

       
       if (ma0 > ma1 ) 
            {                          
               if (  ExtMapBuffer4[i+1]!=EMPTY_VALUE) 
                    
                  {  ExtMapBuffer5[i] = ma0;     ExtMapBuffer5[i+1]= ma1;
                        }
               else   
                  {  ExtMapBuffer2[i] = ma0;    ExtMapBuffer2[i+1]= ma1;
                        }
            }

        else 
            {        
               if ( ExtMapBuffer2[i+1]!=EMPTY_VALUE) 

                  { ExtMapBuffer4[i] = ma0;     ExtMapBuffer4[i+1]= ma1;
                        }
               else        
                  { ExtMapBuffer3[i] = ma0;     ExtMapBuffer3[i+1]= ma1;
                        }

            }
        
        
        
     }
    
      return(0);
 }
//+------------------------------------------------------------------+



