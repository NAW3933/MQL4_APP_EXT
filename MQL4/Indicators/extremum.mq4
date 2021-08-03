//+------------------------------------------------------------------+
//|                                                     Extremum.mq4 |
//|                                                             Egor |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Egor"
#property link      ""


#property indicator_separate_window
#property  indicator_buffers 8
#property  indicator_color1  Yellow//Silver
#property  indicator_color2  Lime//Green//Red//Green//Red
#property  indicator_color3  Lime//Red//Green//DodgerBlue//Yellow//Red//Green
#property  indicator_color4  Lime//Red//Lime//Red//DodgerBlue//Green
#property  indicator_color5  Red//DodgerBlue//Lime//Silver//Yellow
#property  indicator_color6  Yellow//Magenta//Red//Lime//Silver//Green//Lime//Silver//Yellow
#property  indicator_color7  Red//Silver//Magenta//Yellow//Silver//CornflowerBlue//Yellow//Silver//Green//Lime//Silver//Yellow
#property  indicator_color8  Magenta//MediumOrchid//Aquamarine//Green//White//Lime//CornflowerBlue//Lime//Red//CornflowerBlue//Yellow//Silver//Green//Lime//Silver//Yellow

//---- indicator parameters
extern int NBars=20;
//---- indicator buffers
double     MNKBuffer[];
double     MNKBuffer1[];
double     MNKBuffer2[];
double     MNKBuffer3[];
double     MNKBuffer4[]; 
double     MNKBuffer5[];
double     MNKBuffer6[];
double     MNKBuffer7[];
double     MNKBuffer8[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(8);


//---- drawing settings
   SetIndexStyle(0,DRAW_LINE,0,1);//HISTOGRAM,0,2);
   SetIndexStyle(1,DRAW_LINE,0,2);//HISTOGRAM,0,1);//LINE);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2);//LINE);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,5);//LINE);//HISTOGRAM,0,2);//LINE);
   SetIndexStyle(4,DRAW_LINE,0,2);//HISTOGRAM,0,2);//LINE);
   SetIndexStyle(5,DRAW_HISTOGRAM,0,2);//LINE,0,2);//HISTOGRAM,0,2);//LINE);
   SetIndexStyle(6,DRAW_HISTOGRAM,0,4);//LINE,0,2);//HISTOGRAM,0,2);//LINE);
   SetIndexStyle(7,DRAW_HISTOGRAM,0,2);//LINE);
  
   SetIndexDrawBegin(0,NBars);
   SetIndexDrawBegin(1,NBars);
   SetIndexDrawBegin(2,NBars);
   SetIndexDrawBegin(3,NBars);
   SetIndexDrawBegin(4,NBars);
   SetIndexDrawBegin(5,NBars);
   SetIndexDrawBegin(6,NBars);
   SetIndexDrawBegin(7,NBars);
   
   //SetIndexDrawBegin(2,NBarsLiniaSr);
   IndicatorDigits(Digits+4);
//---- indicator buffers mapping
   SetIndexBuffer(0,MNKBuffer);
   SetIndexBuffer(1,MNKBuffer1);
   SetIndexBuffer(2,MNKBuffer2);
   SetIndexBuffer(3,MNKBuffer3);
   SetIndexBuffer(4,MNKBuffer4);
   SetIndexBuffer(5,MNKBuffer5);
   SetIndexBuffer(6,MNKBuffer6);
   SetIndexBuffer(7,MNKBuffer7);
   
  //SetIndexBuffer(2,MNKBufferkSr);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Extremum("+NBars+")");
   
   SetIndexLabel(0,"MNK");
   SetIndexLabel(1,"MNK1");
   SetIndexLabel(2,"MNK2");
   SetIndexLabel(3,"MNK3");
   SetIndexLabel(4,"MNK4");
   SetIndexLabel(5,"MNK5");
   SetIndexLabel(6,"MNK6");
   SetIndexLabel(7,"MNK7");
   
 //---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+

 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int    counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
      
      
     
   for( int k=0; k<limit; k++)
       { 
  
   
    
    double n=0;
    for(int i=0+k;i<NBars+k; i++) 
      {    
      if(iHigh(NULL,0,k)>iHigh(NULL,0,i) && iHigh(NULL,0,k)-iHigh(NULL,0,i)>n)
        {
      n=iHigh(NULL,0,k)-iHigh(NULL,0,i);  
        }
      }  
    double m=0;
    for( i=0+k;i<NBars+k; i++) 
      {    
      if(iLow(NULL,0,k)<iLow(NULL,0,i) && iLow(NULL,0,k)-iLow(NULL,0,i)<m)
        {
      m= iLow(NULL,0,k)-iLow(NULL,0,i);  
        }
      }
 


    
    
       MNKBuffer[k]=n+m;
       MNKBuffer1[k]=m-n;
       MNKBuffer4[k]=n-m;
       
        if((n+m)==(m-n))
       {
       MNKBuffer2[k]=-(n+m)/2;
       }
      
        if((n+m)==(n-m))
       {
       MNKBuffer2[k]=-(n+m)/2;
       }
      
       
      if((n+m)<0)
       {
       MNKBuffer5[k]=n+m;
       }
       if((n+m)>0)
       {
       MNKBuffer7[k]=n+m;
       }
      
              
    }
    
   return(0);
  }

