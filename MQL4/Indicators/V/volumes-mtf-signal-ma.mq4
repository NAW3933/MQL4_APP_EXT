//**************************************************************************//
//***                    Volume MTF +SigMA TT [x7]                         ***
//**************************************************************************//
#property copyright "" 
#property link      "" 
#property description "Индикатор объёмов ++ Сигнальная средняя скользящая."
//#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 2

#property indicator_color1 RoyalBlue   //DodgerBlue
#property indicator_color2 LightCyan   //LightSteelBlue
#property indicator_width1  2
#property indicator_width2  2

enum volt { AD, BWMFI, FORCE, MFI, OBV, WPR, VOLUMES };
//**************************************************************************//
//***                 Custom indicator input parameters                    ***
//**************************************************************************//

extern int                 History  =  0;   //Сколько свечей в Истории
extern ENUM_TIMEFRAMES   TimeFrame  =  PERIOD_CURRENT;
extern volt            Calculation  =  VOLUMES;
extern int               VolPeriod  =  15;   
extern ENUM_MA_METHOD      VolMode  =  MODE_LWMA;
extern ENUM_APPLIED_PRICE VolPrice  =  PRICE_CLOSE;

extern bool             VolumeLine  =  false;
extern int                   SigMA  =  15;   
extern ENUM_MA_METHOD    SigMAMode  =  MODE_LWMA;
extern bool              ShowSigMA  =  true;

//**************************************************************************//
//***                     Custom indicator buffers                         ***
//**************************************************************************//
double VolumeBuffer[], SigMABuffer[];
//**************************************************************************//
//***              Custom indicator initialization function                ***
//**************************************************************************//
int init()
{
   IndicatorBuffers(2);      IndicatorDigits(2);
//---- indicator line
   SetIndexBuffer(0,VolumeBuffer);
   SetIndexBuffer(1,SigMABuffer);
   
   int VLT = DRAW_HISTOGRAM;   if (VolumeLine) VLT = DRAW_LINE;      
   SetIndexStyle(0,VLT);
   SetIndexStyle(1,DRAW_LINE);
   
   SetIndexLabel (0,EnumToString(Calculation)+" ["+IntegerToString(VolPeriod)+"]");
   if (ShowSigMA) SetIndexLabel (1,"SigMA ["+IntegerToString(SigMA)+"]");   else SetIndexLabel(1,NULL);
   
//---- name for DataWindow and indicator subwindow label
   if (ShowSigMA) IndicatorShortName("["+EnumToString(TimeFrame)+"] - "+EnumToString(Calculation)+" MTF TT ["+IntegerToString(VolPeriod)+"] --> SigMA ["+IntegerToString(SigMA)+"]");
   else IndicatorShortName("["+EnumToString(TimeFrame)+"] - "+EnumToString(Calculation)+" MTF TT ["+IntegerToString(VolPeriod)+"]");
   
//---
return(0);
}
//**************************************************************************//
//***              Custom indicator deinitialization function              ***
//**************************************************************************//
int deinit() { return (0); }
//**************************************************************************//
//***                 Custom indicator iteration function                  ***
//**************************************************************************//

int start()
  {
   int i, y, counted_bars=IndicatorCounted();
      if(counted_bars<0)    return(-1);
      
         if(History < 1)     History = Bars;
         if(counted_bars > 0)    counted_bars -= 0;
          
            int limit = MathMin(History-counted_bars,History-1);  
            if(limit<=0) limit=1;          

//**************************************************************************//
   datetime TimeArray[];      
   int timeFrame=stringToTimeFrame(TimeFrame);   //вычисление в режиме MTF
   ArrayCopySeries(TimeArray,MODE_TIME,NULL,timeFrame);   
//**************************************************************************//
   
   for(i=0, y=0; i<limit; i++)      //enum volt { AD, BWMFI, FORCE, MFI, OBV, WPR, VOLUMES };
     { 
      if (Time[i]<TimeArray[y]) y++;      
      
      if (Calculation==AD)       { VolumeBuffer[i] = iAD(NULL,timeFrame,y); }  
      if (Calculation==BWMFI)    { VolumeBuffer[i] = iBWMFI(NULL,timeFrame,y); }
      if (Calculation==FORCE)    { VolumeBuffer[i] = iForce(NULL,timeFrame,VolPeriod,VolMode,VolPrice,y); }
      if (Calculation==MFI)      { VolumeBuffer[i] = iMFI(NULL,timeFrame,VolPeriod,y); }  
      if (Calculation==OBV)      { VolumeBuffer[i] = iOBV(NULL,timeFrame,VolPrice,y); }  
      if (Calculation==WPR)      { VolumeBuffer[i] = iWPR(NULL,timeFrame,VolPeriod,y); }
      if (Calculation==VOLUMES)  { VolumeBuffer[i] = iVolume(NULL,timeFrame,y); }
     }  

   for(i=limit; i>=0; i--)       { if (ShowSigMA) SigMABuffer[i] = iMAOnArray(VolumeBuffer,0,SigMA,0,SigMAMode,i);   else SigMABuffer[i]=EMPTY_VALUE; }     
   
//---
   return(0);
  }
//**************************************************************************//
//***                    Volume MTF +SigMA TT [x7]                         ***
//**************************************************************************//
int stringToTimeFrame(string tfs)   //вычисление в режиме MTF
{
   int tf=0;   
   if (tfs=="M1" || tfs=="1")     tf=PERIOD_M1;
   if (tfs=="M5" || tfs=="5")     tf=PERIOD_M5;
   if (tfs=="M15"|| tfs=="15")    tf=PERIOD_M15;
   if (tfs=="M30"|| tfs=="30")    tf=PERIOD_M30;
   if (tfs=="H1" || tfs=="60")    tf=PERIOD_H1;
   if (tfs=="H4" || tfs=="240")   tf=PERIOD_H4;
   if (tfs=="D1" || tfs=="1440")  tf=PERIOD_D1;
   if (tfs=="W1" || tfs=="10080") tf=PERIOD_W1;
   if (tfs=="MN" || tfs=="43200") tf=PERIOD_MN1;
   if (tf<Period()) tf=Period();
//----
return(tf);
}
//**************************************************************************//
//***                    Volume MTF +SigMA TT [x7]                         ***
//**************************************************************************//