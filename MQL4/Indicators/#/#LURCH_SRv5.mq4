#property copyright "Copyright © 2007-2008, Bruce Hellstrom (brucehvn)"
#property link      "http: //www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 DarkBlue
#property indicator_width1 1
#property indicator_color2 Blue
#property indicator_width2 2
#property indicator_color3 Red
#property indicator_width3 2

#define INDICATOR_VERSION "v2.0"
#define VTS_OBJECT_PREFIX "vtsbh2483-"
//---- input parameters
extern bool UseATRMode = true;
extern int NonATRStopPips = 40;
extern int ATRPeriod = 9;
extern double ATRMultiplier = 3.0;
extern int ATRSmoothing = 0;
extern int ArrowDistance = 0;
extern bool AlertSound = true;
extern bool AlertMail = true;
extern bool ShowComment = true;
//---- buffers
double TrStopLevel[];
double UpBuffer[];
double DownBuffer[];
//---- variables
double ATRBuffer[];
double SmoothBuffer[];
string ShortName;
datetime LastArrowTime = 0;
bool LastArrowSignal = 0;
datetime LastAlertBar = 0;
datetime CurrentBarTime = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() 
{
    int DrawBegin = 0;
    if ( UseATRMode ) DrawBegin = ATRPeriod;
    
    // Set the smoothing to 1 if it is zero or less
    if ( ATRSmoothing <= 0 ) ATRSmoothing = 1;
    
    IndicatorBuffers( 3 );
    SetIndexStyle( 0, DRAW_LINE);
    SetIndexBuffer( 0, TrStopLevel );
    SetIndexDrawBegin( 0, DrawBegin );
    
    SetIndexStyle(1,DRAW_ARROW);
    SetIndexArrow(1,233);
    SetIndexBuffer(1,UpBuffer);
    SetIndexEmptyValue(1,0.0);

    SetIndexStyle(2,DRAW_ARROW);
    SetIndexArrow(2,234);
    SetIndexBuffer(2,DownBuffer);
    SetIndexEmptyValue(2,0.0);

    ShortName = "MT4-LevelStop-Reverse-" + INDICATOR_VERSION + "(";   
    if ( UseATRMode ) 
        ShortName = StringConcatenate( ShortName, "ATRMode ", ATRPeriod, ", ", ATRMultiplier, ", ", ATRSmoothing, " )" );
    else 
        ShortName = StringConcatenate( ShortName, "Manual Mode Stop = ", NonATRStopPips, " )" );
    
    IndicatorShortName( ShortName );
    SetIndexLabel( 0, ShortName );    
    return( 0 );
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                         |
//+------------------------------------------------------------------+
int deinit() 
{
    Comment("");
    return( 0 );
}

//+------------------------------------------------------------------+
//| Function run on every tick                                       |
//+------------------------------------------------------------------+
int start() 
{
    int ictr;
    int counted_bars = IndicatorCounted();
    if ( counted_bars < 0 ) return( -1 );
    if ( counted_bars > 0 ) counted_bars--;    
    int limit = Bars - counted_bars;
    ictr = limit - 1;    
    if ( UseATRMode && Bars < ATRPeriod ) return( 0 );
 
    int buff_size = ArraySize( TrStopLevel );
    if ( ArraySize( ATRBuffer ) != buff_size ) 
    {
        ArraySetAsSeries( ATRBuffer, false );
        ArrayResize( ATRBuffer, buff_size );
        ArraySetAsSeries( ATRBuffer, true );
    }
    
    int xctr;
    
    if ( UseATRMode ) 
    {
     for ( xctr = 0; xctr < limit; xctr++ ) ATRBuffer[xctr] = iATR( NULL, 0, ATRPeriod, xctr );
    }
    
    
    for ( xctr = ictr; xctr >= 0; xctr-- ) 
     {
      double DeltaStop = NonATRStopPips * Point;
      if ( UseATRMode ) DeltaStop = NormalizeDouble( iATR( NULL, 0, ATRPeriod, xctr ) * ATRMultiplier, Digits );

      double NewStopLevel;
      double PrevStop = TrStopLevel[xctr + 1];
      bool DrawUpArrow = false;
      bool DrawDnArrow = false;
        
     if ( Close[xctr] == PrevStop ) NewStopLevel = PrevStop;
     else if ( Close[xctr + 1] <= PrevStop && Close[xctr] < PrevStop ) NewStopLevel = MathMin( PrevStop, ( Close[xctr] + DeltaStop ) );
     else if ( Close[xctr + 1] >= PrevStop && Close[xctr] > PrevStop ) NewStopLevel = MathMax( PrevStop, ( Close[xctr] - DeltaStop ) );
     else if ( Close[xctr] > PrevStop ) 
      {
       NewStopLevel = Close[xctr] - DeltaStop;
       DrawUpArrow = true;
      }
     else if ( Close[xctr] < PrevStop ) 
      {
       NewStopLevel = Close[xctr] + DeltaStop;
       DrawDnArrow = true;
      }       
       TrStopLevel[xctr] = NewStopLevel;
	    //UpBuffer[xctr] = EMPTY_VALUE;  
	    //DownBuffer[xctr] = EMPTY_VALUE;  

     if ( xctr > 0 && Time[xctr] > LastArrowTime) 
      {
       if ( DrawUpArrow ) 
        { 
         LastArrowTime = Time[xctr];
         LastArrowSignal = true;
         UpBuffer[xctr] = TrStopLevel[xctr] - ( ArrowDistance * Point ) - 1*Point;
        }
       else if ( DrawDnArrow ) 
        {
         LastArrowTime = Time[xctr];
         LastArrowSignal = false;
         DownBuffer[xctr] = TrStopLevel[xctr] + ( 2 * Point ) + ( ArrowDistance * Point ) + 1*Point;
        }
      }
        
     if ( xctr == 1 && LastArrowTime == Time[xctr]) DoAlerts();        
     if ( xctr == 0 && Time[xctr] != CurrentBarTime)  CurrentBarTime = Time[xctr];
   }            
 return( 0 );
}
//+------------------------------------------------------------------+
//| Handles alerting via sound/email                                 |
//+------------------------------------------------------------------+
void DoAlerts() 
 {
  if(LastArrowTime > LastAlertBar) 
   {
      int per = Period();
      string perstr = "";
      switch(per)
       {
        case PERIOD_M1:perstr = "M1";break;
        case PERIOD_M5:perstr = "M5";break;
        case PERIOD_M15:perstr = "M15";break;
        case PERIOD_M30:perstr = "M30";break;
        case PERIOD_H1:perstr = "H1";break;
        case PERIOD_H4:perstr = "H4";break;
        case PERIOD_D1:perstr = "D1";break;
        case PERIOD_W1:perstr = "W1";break;
        case PERIOD_MN1:perstr = "MN1";break;
        default:perstr = "" + per + " Min";break;
       }
      datetime curtime = TimeCurrent();
      string strSignal = "LONG";
      if (!LastArrowSignal) strSignal = "SHORT";
      string str_subject = "MT4-SLReverse Alert " + TimeToStr( curtime, TIME_DATE | TIME_SECONDS );

    if(AlertSound)Alert("The StopLevelReverse has given a " + strSignal + " signal for pair " +Symbol() + " " + perstr + "." );  
    if(AlertMail)SendMail( str_subject,"The StopLevelReverse has given a " + strSignal + " signal for pair " +Symbol() + " " + perstr + "." );
    LastAlertBar = LastArrowTime;
  }
}
    

//+------------------------------------------------------------------+