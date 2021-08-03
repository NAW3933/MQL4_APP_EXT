//+------------------------------------------------------------------+
//|                                         Heiken Ashi Smoothed.mq4 |
//+------------------------------------------------------------------+
//|                                                      mod by Raff |
//+------------------------------------------------------------------+
//mod2008fxtsd mtf ki
#property copyright "Copyright © 2006, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 DodgerBlue
#property indicator_color3 Red
#property indicator_color4 DodgerBlue
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 3
#property indicator_width4 3

//---- parameters

extern int MaPeriod  = 6;
extern int MaMetod   = 2;

extern int MaPeriod2 = 2;
extern int MaMetod2  = 3;

extern bool DrawHisto = true;

extern int TimeFrame = 0;
extern string  note_TimeFrames = "M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-CurrentTF";
extern string  note_MA_Method =  "SMA0 EMA1 SMMA2 LWMA3";
string IndicatorFileName;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- indicators
   IndicatorBuffers(8);
   if (DrawHisto)
   {
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   }
   else 
   {
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexStyle(1,DRAW_SECTION);
   SetIndexStyle(2,DRAW_SECTION);
   SetIndexStyle(3,DRAW_SECTION);
   }
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexBuffer(3, ExtMapBuffer4);
//----
   SetIndexDrawBegin(0,5);
//---- indicator buffers mapping

   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexBuffer(7,ExtMapBuffer8);
//---- initialization done


           switch(TimeFrame)
     {
      case 1: string TimeFrameStr = "M1" ;  break;
      case 5     :   TimeFrameStr = "M5" ;  break;
      case 15    :   TimeFrameStr = "M15";  break;
      case 30    :   TimeFrameStr = "M30";  break;
      case 60    :   TimeFrameStr = "H1" ;  break;
      case 240   :   TimeFrameStr = "H4" ;  break;
      case 1440  :   TimeFrameStr = "D1" ;  break;
      case 10080 :   TimeFrameStr = "W1" ;  break;
      case 43200 :   TimeFrameStr = "MN1";  break;
      default :      TimeFrameStr = "TF0";
     }


   IndicatorShortName("HAMA ["+TimeFrameStr+"] ("
                              +MaPeriod+","+MaMetod+" | "+MaPeriod2+","+MaMetod2+")");

   IndicatorFileName = WindowExpertName();
   if (TimeFrame < Period()) TimeFrame = Period();

   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int  counted_bars=IndicatorCounted();
   int  i,limit;

   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
       
       limit=Bars-counted_bars;

   if (TimeFrame != Period())
     {
      datetime TimeArray[];
         limit = MathMax(limit,TimeFrame/Period());
         ArrayCopySeries(TimeArray ,MODE_TIME ,NULL,TimeFrame);
         
         for(i=0,int y=0; i<limit; i++)
         {
            if(Time[i]<TimeArray[y]) y++;
            
   ExtMapBuffer1[i] = iCustom(NULL,TimeFrame,IndicatorFileName,
                  MaPeriod,MaMetod,MaPeriod2,MaMetod2,DrawHisto,0,y);
   ExtMapBuffer2[i] = iCustom(NULL,TimeFrame,IndicatorFileName,
                  MaPeriod,MaMetod,MaPeriod2,MaMetod2,DrawHisto,1,y);
   ExtMapBuffer3[i] = iCustom(NULL,TimeFrame,IndicatorFileName,
                  MaPeriod,MaMetod,MaPeriod2,MaMetod2,DrawHisto,2,y);
   ExtMapBuffer4[i] = iCustom(NULL,TimeFrame,IndicatorFileName,
                  MaPeriod,MaMetod,MaPeriod2,MaMetod2,DrawHisto,3,y);

         }
       return(0);         
     }
   
   double maOpen, maClose, maLow, maHigh;
   double haOpen, haHigh, haLow, haClose;


      limit= MathMax(limit,MaPeriod);
      limit= MathMax(limit,MaPeriod2);
      
     for (i=limit;i>=0;i--)
          
     {
     
      maOpen=iMA(NULL,0,MaPeriod,0,MaMetod,MODE_OPEN,i);
      maClose=iMA(NULL,0,MaPeriod,0,MaMetod,MODE_CLOSE,i);
      maLow=iMA(NULL,0,MaPeriod,0,MaMetod,MODE_LOW,i);
      maHigh=iMA(NULL,0,MaPeriod,0,MaMetod,MODE_HIGH,i);

      haOpen=(ExtMapBuffer5[i+1]+ExtMapBuffer6[i+1])/2;
      haClose=(maOpen+maHigh+maLow+maClose)/4;
      haHigh=MathMax(maHigh, MathMax(haOpen, haClose));
      haLow=MathMin(maLow, MathMin(haOpen, haClose));

      if (haOpen<haClose) 
        {
         ExtMapBuffer7[i]=haLow;
         ExtMapBuffer8[i]=haHigh;
        } 
      else
        {
         ExtMapBuffer7[i]=haHigh;
         ExtMapBuffer8[i]=haLow;
        } 
      ExtMapBuffer5[i]=haOpen;
      ExtMapBuffer6[i]=haClose;

     }
     
     
     for(y=0,i=0; i<limit; i++)
     
     {

 ExtMapBuffer1[i]=iMAOnArray(ExtMapBuffer7,0,MaPeriod2,0,MaMetod2,i);
 ExtMapBuffer2[i]=iMAOnArray(ExtMapBuffer8,0,MaPeriod2,0,MaMetod2,i);
 ExtMapBuffer3[i]=iMAOnArray(ExtMapBuffer5,0,MaPeriod2,0,MaMetod2,i);
 ExtMapBuffer4[i]=iMAOnArray(ExtMapBuffer6,0,MaPeriod2,0,MaMetod2,i);

     }

//----
   return(0);
  }
//+------------------------------------------------------------------+