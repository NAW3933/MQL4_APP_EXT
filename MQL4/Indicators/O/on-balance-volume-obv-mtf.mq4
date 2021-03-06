//+++======================================================================+++
//+++                            OBV MTF TT                                +++
//+++======================================================================+++

#property copyright "" 
#property link      ""

#property description "Индикатор On Balance Volume [OBV] связывает объем и изменение цены, сопровождавшее данный объем. Интерпретация OBV основана на принципе, утверждающем, что изменения OBV опережают ценовые. Согласно этому принципу, повышение балансового объема свидетельствует о том, что в инструмент вкладывают средства профессионалы. Когда позднее начинает вкладывать широкая публика, и цена, и показания индикатора OBV начинают стремительно расти."
#property description "MTF искажён специально :))"

#property indicator_separate_window
#property indicator_buffers 1

#property indicator_color1 Gold
#property indicator_width1 2

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
---------------------------------------
PRICE_CLOSE    0 Close price. 
PRICE_OPEN     1 Open price. 
PRICE_HIGH     2 High price. 
PRICE_LOW      3 Low price. 
PRICE_MEDIAN   4 Median price, (high+low)/2. 
PRICE_TYPICAL  5 Typical price, (high+low+close)/3. 
PRICE_WEIGHTED 6 Weighted close price, (high+low+close+close)/4. 
You must use the numeric value of the Applied Price that you want to use
when you set the 'OBV_Price' value with the indicator inputs.
**************************************************************************/

extern ENUM_TIMEFRAMES    TimeFrame  =  PERIOD_CURRENT;
extern ENUM_APPLIED_PRICE OBV_Price  =  PRICE_CLOSE;

//extern string  note_Price = "0C 1O 2H 3L 4Md 5Tp 6WghC: Md(HL/2)4,Tp(HLC/3)5,Wgh(HLCC/4)6";
//extern string  TimeFrames = "M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-CurrentTF";

//+++======================================================================+++
//+++                            OBV MTF TT                                +++
//+++======================================================================+++
double OBVBuffer[];
//+++======================================================================+++
//+++             Custom indicator initialization function                 +++
//+++======================================================================+++
int init()
{
//---- indicator line
   SetIndexBuffer(0,OBVBuffer);
   SetIndexStyle (0,DRAW_LINE);
   
//---- name for DataWindow and indicator subwindow label
   switch(TimeFrame)
   {
      case 1  : string  TimeFrameStr="M1";   break;
      case 5  :         TimeFrameStr="M5";   break;
      case 15 :         TimeFrameStr="M15";  break;
      case 30 :         TimeFrameStr="M30";  break;
      case 60 :         TimeFrameStr="H1";   break;
      case 240  :       TimeFrameStr="H4";   break;
      case 1440 :       TimeFrameStr="D1";   break;
      case 10080 :      TimeFrameStr="W1";   break;
      case 43200 :      TimeFrameStr="MN";   break;
      default :         TimeFrameStr="TF0";
   }
   
   IndicatorShortName("OBV ["+TimeFrameStr+"] ");
   //TimeFrame=MathMax(TimeFrame,Period());    //разкомменировать строку -- и MTF будет работать нормально...
   
return(0);
}
//+++======================================================================+++
//+++                 Custom indicator iteration function                  +++
//+++======================================================================+++
int start()
{
   datetime TimeArray[];
   int    i,limit,y=0,counted_bars=IndicatorCounted();
 
// Plot defined time frame on to current time frame
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame); 
   
   limit=Bars-counted_bars;
   limit=MathMax(limit,TimeFrame/Period());
   
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
   OBVBuffer[i]=iOBV(NULL,TimeFrame, OBV_Price,y);
   }  
   
return(0);
}
//+++======================================================================+++
//+++                            OBV MTF TT                                +++
//+++======================================================================+++
