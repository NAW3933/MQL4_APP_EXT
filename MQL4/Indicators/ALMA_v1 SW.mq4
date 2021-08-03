//+------------------------------------------------------------------+
//|                                                   ALMA_v1 SW.mq4 |
//| ALMA by Arnaud Legoux / Dimitris Kouzis-Loukas / Anthony Cascino |
//|                                             www.arnaudlegoux.com |                     
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"
//---- indicator settings
#property indicator_separate_window 
#property indicator_buffers 2 
#property indicator_color1 LightBlue 
#property indicator_color2 Tomato 
#property indicator_width1 2
#property indicator_width2 2
#property indicator_maximum 2
#property indicator_minimum 0 
//---- indicator parameters
extern int     TimeFrame         =   0;  //TimeFrame in min 
extern int     Price             =   0;  //Price Mode (0...6)
extern int     WindowSize        =   9;  //Window Size  
extern double  Sigma             = 6.0;  //Sigma parameter 
extern double  Offset            =0.85;  //Offset of Gaussian distribution (0...1)
extern double  PctFilter         =   0;  //Dynamic filter in decimal
extern double  IndicatorValue    =   1;
extern int     ArrowCode         = 167;
extern int     AlertMode         =   0;  //Sound Alert switch (0-off,1-on) 
extern int     WarningMode       =   0;  //Sound Warning switch(0-off,1-on) 
//---- indicator buffers

double     Uptrend[];
double     Dntrend[];
double     trend[];
double     ALMA[];
double     Del[];

int        draw_begin;
bool       UpTrendAlert=false, DownTrendAlert=false;
double     wALMA[]; 
string     TF, IndicatorName;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if(TimeFrame <= Period()) TimeFrame = Period();
//---- indicator buffers mapping
   IndicatorBuffers(5);
   
   SetIndexBuffer(0,Uptrend);
   SetIndexBuffer(1,Dntrend);
   SetIndexBuffer(2,trend);  
   SetIndexBuffer(3,ALMA);
   SetIndexBuffer(4,Del);
//---- drawing settings
   
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(0,ArrowCode);
   SetIndexArrow(1,ArrowCode);
   
   
   draw_begin = MathMax(2,Bars - iBars(NULL,TimeFrame)*TimeFrame/Period() + WindowSize);
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
      
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
//---- name for DataWindow and indicator subwindow label
   switch(TimeFrame)
   {
   case 1     : TF = "M1" ; break;
   case 5     : TF = "M5" ; break;
   case 15    : TF = "M15"; break;
   case 30    : TF = "M30"; break;
   case 60    : TF = "H1" ; break;
   case 240   : TF = "H4" ; break;
   case 1440  : TF = "D1" ; break;
   case 10080 : TF = "W1" ; break;
   case 43200 : TF = "MN1"; break;
   } 
     
   
   IndicatorShortName("ALMA SW["+TF+"]("+WindowSize +")");
   SetIndexLabel(0,"ALMA Uptrend"+"["+TF+"]");
   SetIndexLabel(1,"ALMA Dntrend"+"["+TF+"]");
//---- 
   
   double m = MathFloor(Offset * (WindowSize - 1));
	double s = WindowSize/Sigma;
	
	ArrayResize(wALMA,WindowSize);
	double wsum = 0;		
	for (int i=0;i < WindowSize;i++) 
	{
	wALMA[i] = MathExp(-((i-m)*(i-m))/(2*s*s));
   wsum += wALMA[i];
   }
   
   for (i=0;i < WindowSize;i++) wALMA[i] = wALMA[i]/wsum; 
   
   IndicatorName = WindowExpertName();
   
   return(0);
  }
//+------------------------------------------------------------------+
//| ALMA_v1 SW                                                       |
//+------------------------------------------------------------------+
int start()
{
   int limit,shift,i;
   int counted_bars=IndicatorCounted();
//---- 
   if(counted_bars<1)
   {
      for(i=Bars-1;i>0;i--) 
      {
      Uptrend[i]=EMPTY_VALUE;
      Dntrend[i]=EMPTY_VALUE;
      }
   }
//---- 
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

//---- 
   if(TimeFrame != Period())
	{
   limit = MathMax(limit,TimeFrame/Period());   
      
      for(shift = 0;shift < limit;shift++) 
      {	
      int y = iBarShift(NULL,TimeFrame,Time[shift]);
      
      Uptrend[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,WindowSize,Sigma,Offset,PctFilter,IndicatorValue,ArrowCode,AlertMode,WarningMode,0,y);
      Dntrend[shift] = iCustom(NULL,TimeFrame,IndicatorName,0,Price,WindowSize,Sigma,Offset,PctFilter,IndicatorValue,ArrowCode,AlertMode,WarningMode,1,y);
      }  
	return(0);
	}
	else _ALMA(limit);

//---- done
   return(0);
}

void _ALMA(int limit)
{
   int shift,i;
   
   
   for(shift=limit; shift>=0; shift--)
   {
   if (shift > Bars - WindowSize) continue; 
   
	double sum  = 0;
	for(i=0;i < WindowSize;i++) sum += wALMA[i] * iMA(NULL,0,1,0,0,Price,shift + (WindowSize - 1 - i)); 
	
	ALMA[shift] = sum;

      if(PctFilter>0)
      {
      Del[shift] = MathAbs(ALMA[shift] - ALMA[shift+1]);
   
      double sumdel=0;
      for (int j=0;j<WindowSize;j++) sumdel = sumdel+Del[shift+j];
      double AvgDel = sumdel/WindowSize;
    
      double sumpow = 0;
      for (j=0;j<WindowSize;j++) sumpow+=MathPow(Del[j+shift]-AvgDel,2);
      double StdDev = MathSqrt(sumpow/WindowSize); 
     
      double Filter = PctFilter * StdDev;
     
      if( MathAbs(ALMA[shift]-ALMA[shift+1]) < Filter ) ALMA[shift]=ALMA[shift+1];
      }
      else
      Filter=0;
      
   trend[shift] = trend[shift+1];
   if (ALMA[shift] - ALMA[shift+1] > Filter) trend[shift] = 1;
   if (ALMA[shift+1] - ALMA[shift] > Filter) trend[shift] =-1;
    
      if (trend[shift]>0)
      {
      Uptrend[shift] = IndicatorValue; 
      Dntrend[shift] = EMPTY_VALUE;
      if (WarningMode>0 && trend[shift+1]<0 && i==0) PlaySound("alert2.wav");
      }
      else              
      if (trend[shift]<0)
      { 
      Dntrend[shift] = IndicatorValue; 
      Uptrend[shift] = EMPTY_VALUE;
      if (WarningMode>0 && trend[shift+1]>0 && i==0) PlaySound("alert2.wav");
      }               
   }      
//----------   
   if ( AlertMode>0 )
   {
   string Message;
   
      if ( trend[2]<0 && trend[1]>0 && Volume[0]>1 && !UpTrendAlert)
      {
	   Message = " "+Symbol()+" M"+Period()+": HMA Signal for BUY";
	   Alert (Message); 
	   UpTrendAlert=true; DownTrendAlert=false;
	   } 
	 	  
	   if ( trend[2]>0 && trend[1]<0 && Volume[0]>1 && !DownTrendAlert)
	   {
	   Message = " "+Symbol()+" M"+Period()+": HMA Signal for SELL";
	   if ( AlertMode>0 ) Alert (Message); 
	   DownTrendAlert=true; UpTrendAlert=false;
	   } 	         
   }

}