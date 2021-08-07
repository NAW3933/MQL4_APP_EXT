
#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Black

#property indicator_width1 3
#property indicator_width2 3


extern int     NumberOfBars = 500;
extern string  Note = "0 means Display all bars";
extern int     MAPeriod = 100;
extern int     LookBack = 20;


double red[],blue[],v4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      SetIndexBuffer(0,red);
      SetIndexStyle(0,DRAW_HISTOGRAM);
      SetIndexLabel(0,"Down");
      
      SetIndexBuffer(1,blue);
      SetIndexStyle(1,DRAW_HISTOGRAM);
      SetIndexLabel(1,"Up");
      
      SetIndexBuffer(2,v4);
      SetIndexStyle(2,DRAW_LINE,0,2);
      SetIndexLabel(2,"Average("+MAPeriod+")");
      
      IndicatorShortName("Better Volume 1.3 No Colors" );
      

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
  
  double tempv;
  
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
   
      
   for(int i=0; i<limit; i++)   
      {
         red[i] = 0; blue[i] = Volume[i]; tempv = 0;
         
         
         for ( int n=i;n<i+MAPeriod;n++ )
            {
               tempv= Volume[n] + tempv; 
            } 
          v4[i] = NormalizeDouble(tempv/MAPeriod,0);
         
         
            blue[i]=0;
            red[i]=0;
               
            if( NormalizeDouble(Volume[i],0) < NormalizeDouble(Volume[i+1],0) )
            {
               red[i] = NormalizeDouble(Volume[i],0);
               
            }
            else
            {
               blue[i] = NormalizeDouble(Volume[i],0);
            }
         
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
         