
#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Yellow
#property indicator_color4 Yellow
#property indicator_color5 White
#property indicator_color6 White


extern int     NumberOfBars = 0;
extern string  Note = "0 means Display all bars";
extern int     MAPeriod = 100;


double red[],blue[],yellow[],green[],white[],magenta[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      SetIndexBuffer(0,red);
      SetIndexStyle(0,DRAW_HISTOGRAM,0,1);
      SetIndexLabel(0,"Climax ");
      
      SetIndexBuffer(1,blue);
      SetIndexStyle(1,DRAW_HISTOGRAM,0,1);
      SetIndexLabel(1,"");
      
      SetIndexBuffer(2,yellow);
      SetIndexStyle(2,DRAW_HISTOGRAM,0,1);
      SetIndexLabel(2,"Low ");
      
      SetIndexBuffer(3,green);
      SetIndexStyle(3,DRAW_HISTOGRAM,0,1);
      SetIndexLabel(3,"");
      
      SetIndexBuffer(4,white);
      SetIndexStyle(4,DRAW_HISTOGRAM,0,1);
      SetIndexLabel(4,"LowChurn ");
      
      SetIndexBuffer(5,magenta);
      SetIndexStyle(5,DRAW_HISTOGRAM,0,1);
      SetIndexLabel(5,"");
           
      IndicatorShortName("Better Volume On Chart" );
      

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
  
   double VolLowest,Range,Value2,Value3,HiValue2,HiValue3,LoValue3,tempv2,tempv3,tempv;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
   
      
   for(int i=0; i<limit; i++)   
      {
         red[i] = 0; blue[i] = 0; yellow[i] = 0; green[i] = 0; white[i] = 0; magenta[i] = 0;
         Value2=0;Value3=0;HiValue2=0;HiValue3=0;LoValue3=99999999;tempv2=0;tempv3=0;tempv=0;
         
         VolLowest = Volume[iLowest(NULL,0,MODE_VOLUME,20,i)];
         if (Volume[i] == VolLowest)
            {
               yellow[i] = High[i];
               green[i]=Low[i];
            }
               
         Range = (High[i]-Low[i])/Point;
         Value2 = Volume[i]*Range;
         
         if (  Range != 0 )
            Value3 = Volume[i]/Range;
            
         for ( int n=i;n<i+20;n++)
            {
               tempv2 = Volume[n]*((High[n]-Low[n])/Point); 
               if ( tempv2 > HiValue2 )
                  HiValue2 = tempv2;
                  
               
               if ( Volume[n]*((High[n]-Low[n])/Point) != 0 )
                  {
                     tempv3 = Volume[n] / ((High[n]-Low[n])/Point);
                     if ( tempv3 > HiValue3 ) 
                        HiValue3 = tempv3;
                     if ( tempv3 <  LoValue3 )
                        LoValue3 = tempv3;
                  }         
            }
             
          if ( Value2 == HiValue2 )
            {
               red[i] = High[i];
               blue[i]=Low[i];
               //yellow[i]=0;
            }   
            
          if ( Value3 == HiValue3 )
            {
               //green[i] = High[i];                
               //blue[i] =Low[i];
               //yellow[i]=0;
               //red[i]=0;
            }
          if ( Value2 == HiValue2 && Value3 == HiValue3 )
            {
               //magenta[i] = High[i];
               //blue[i]=Low[i];
               //red[i]=0;
               //green[i]=0;
               //yellow[i]=0;
            } 
          if ( Value3 == LoValue3 )
            {
               white[i] = High[i];
               magenta[i]=Low[i];
               //blue[i]=0;
               //red[i]=0;
               //green[i]=0;
               //yellow[i]=0;
            }     
            
         
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
         