//+------------------------------------------------------------------+
//|                                                  MTF_Volumes.mq4 |
//|------------------------------------------------------------------+

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 HotPink
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_level1 0.000000
//---- input parameters
/*************************************************************************
PERIOD_M1   1
PERIOD_M5   5
PERIOD_M15  15
PERIOD_M30  30 
PERIOD_H1   60
PERIOD_H4   240
PERIOD_D1   1440
PERIOD_W1   10080
PERIOD_MN1  43200
You must use the numeric value of the timeframe that you want to use
when you set the TimeFrame' value with the indicator inputs.
---------------------------------------*/
extern int    TimeFrame=0;
extern int    Length=20;      // Bollinger Bands Period
extern int    Deviation=2;    // Deviation
extern double MoneyRisk=0.5; // Offset Factor
extern int    Signal=1;       // Display signals mode: 1-Signals & Stops; 0-only Stops; 2-only Signals;
extern int    Line=1;         // Display line mode: 0-no,1-yes  
extern int    Nbars=1000;
extern int AppliedPrice=0;
extern bool SoundAlerts=false;
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];

int trend=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM,EMPTY,1);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,EMPTY,1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,EMPTY,1);
   SetIndexBuffer(2,ExtMapBuffer3);
//---- name for DataWindow and indicator subwindow label   
   switch(TimeFrame)
     {
      case 1 : string TimeFrameStr="Period_M1"; break;
      case 5 : TimeFrameStr="Period_M5"; break;
      case 15 : TimeFrameStr="Period_M15"; break;
      case 30 : TimeFrameStr="Period_M30"; break;
      case 60 : TimeFrameStr="Period_H1"; break;
      case 240 : TimeFrameStr="Period_H4"; break;
      case 1440 : TimeFrameStr="Period_D1"; break;
      case 10080 : TimeFrameStr="Period_W1"; break;
      case 43200 : TimeFrameStr="Period_MN1"; break;
      default : TimeFrameStr="Current Timeframe";
     }
   IndicatorShortName(" MTF_Volumes ( "+TimeFrameStr+" ) ");
   return(0);
  }
//----
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   datetime TimeArray[];
   int    i,limit,y=0,counted_bars=IndicatorCounted();
   // Plot defined time frame on to current time frame
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame);
   limit= Bars-1;
   
     for(i=limit;i>=0;i--){
      ExtMapBuffer1[i]=0;
      ExtMapBuffer2[i]=0;
      ExtMapBuffer3[i]=0;
      }
     
   for(i=0,y=0;i<limit;i++)
     {
      if (Time[i]<TimeArray[y]) y++;
/***********************************************************   
   Add your main indicator loop below.  You can reference an existing
      indicator with its iName  or iCustom.
   Rule 1:  Add extern inputs above for all neccesary values   
   Rule 2:  Use 'TimeFrame' for the indicator time frame
   Rule 3:  Use 'y' for your indicator's shift value
**********************************************************/
      if(iVolume(NULL,0,i)!=EMPTY_VALUE)
      ExtMapBuffer1[i]=iVolume(NULL,0,y);
      else ExtMapBuffer1[i]=-1;//iRSI(Symbol(),TimeFrame,period,AppliedPrice,y);
      
      
     }
     
     trend=0;
     for(i=limit;i>=0;i--){
     
     if(ExtMapBuffer1[i]>ExtMapBuffer1[i+1])trend=1;
     if(ExtMapBuffer1[i]<ExtMapBuffer1[i+1])trend=-1;
     if(trend==1)ExtMapBuffer2[i]=ExtMapBuffer1[i];
     if(trend==-1)ExtMapBuffer3[i]=ExtMapBuffer1[i];
      
      }
     
   if(GlobalVariableGet(Symbol()+"previndicator")<0 && ExtMapBuffer1[0]>=0)
      if(SoundAlerts){Alert("Buy Alert " + Symbol() + " [" + Period() + "] ");PlaySound("alert.wav");}
      
   if(GlobalVariableGet(Symbol()+"previndicator")>=0 && ExtMapBuffer1[0]<0)
      if(SoundAlerts){Alert("Sell Alert " + Symbol() + " [" + Period() + "] ");PlaySound("alert.wav");}
      
   GlobalVariableSet(Symbol()+"previndicator",ExtMapBuffer1[0]);
   return(0);
  }
//+------------------------------------------------------------------+