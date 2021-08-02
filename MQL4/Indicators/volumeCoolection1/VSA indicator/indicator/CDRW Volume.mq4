
#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 Yellow

extern int     NumberOfBars = 300;


double up[],dn[],flat[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      SetIndexBuffer(0,up);
      SetIndexStyle(0,DRAW_HISTOGRAM,0,3);
      SetIndexLabel(0,"Expanding Volume");
      
      SetIndexBuffer(1,dn);
      SetIndexStyle(1,DRAW_HISTOGRAM,0,3);
      SetIndexLabel(1,"Contracting Volume");
      
      SetIndexBuffer(2,flat);
      SetIndexStyle(2,DRAW_HISTOGRAM,0,3);
      SetIndexLabel(2,"Neutral Volume");

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
   
   double v0,v1,v2;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=NumberOfBars; //Bars-counted_bars;

   for(int i=0; i<limit; i++)   
      {
         up[i] = 0; dn[i] = 0;
       
         v0 = iVolume(NULL,0,i);
         v1 = iVolume(NULL,0,i+1);
         v2 = iVolume(NULL,0,i+2);
         
         flat[i] = v0;
         
         if ( v0<v1 && v0<v2 )
            {
               dn[i] = v0;
               flat[i] = 0;
            }   
         if ( v0>v1 && v0>v2 )
            {
               up[i] = v0;
               flat[i] = 0;
            }   
                  
       
      
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+