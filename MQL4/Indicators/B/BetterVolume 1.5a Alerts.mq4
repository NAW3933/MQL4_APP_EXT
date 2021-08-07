//+------------------------------------------------------------------+
//|                                     BetterVolume 1.5a Alerts.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
// Alert code for color changes added by Andriy Moraru (http://www.earnforex.com)
// + Alerts can be now turned off for particular colors (2012-08-23)
// fxdaytrader 11.2013: Alerts for ma/volume-cross added, Alertfunctions improved, sound/pushnotificationalerts added, etc.

//for more information about VSA (volume spread analysis) pls. visit http://www.forexfactory.com/showthread.php?t=157629
//I do not know who holds the copyright, so I just wrote "VSA TRADERS", fxdaytrader
#property copyright "VSA TRADERS"
#property link      "http://forexBaron.net"

// BetterVolume 1.5.mq4 
// modified to correct start loop 

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 LightSeaGreen 	// Climax High 	Red 
#property indicator_color2 White 	// Neutral 	DeepSkyBlue 
#property indicator_color3 FireBrick 	// Low 		Yellow 
#property indicator_color4 DodgerBlue 	// High Churn 	Lime 
#property indicator_color5 LightSalmon 	// Climax Low 	CadetBlue LightSeaGreen White 
#property indicator_color6 Magenta 	// Climax Churn 
#property indicator_color7 LightSeaGreen 	// Ma 		Maroon 

#property indicator_width1 4
#property indicator_width2 4
#property indicator_width3 4
#property indicator_width4 4
#property indicator_width5 4
#property indicator_width6 4

extern int     NumberOfBars = 0 ; // 1500 ; 500;
extern string  Note = "0 means Display all bars";
extern int     MAPeriod = 14 ;
extern int     LookBack = 20;
extern int     width1 = 4 ;
extern int     width2 = 4 ;

extern string ahi="******* ALERTs on COLORCHANGE?";
extern bool AlertOnColorChange = false;//fxdaytrader
extern string ahi1="-----: ignore some colorchanges?";
extern bool IgnoreLightSeaGreen = false;
extern bool IgnoreWhite = false;
extern bool IgnoreFireBrick = false;
extern bool IgnoreDodgerBlue = false;
extern bool IgnoreLightSalmon = false;
extern bool IgnoreMagenta = false;
extern string ahi2="******* ALERTs on MOVING AVERAGE CROSS?";
extern bool AlertOnMAcross = true;
extern string ahi3="-----: alert methods:";
extern int  AlertCandleShift=0;//0:current candle
extern bool PopupAlerts = true;
extern bool EmailAlerts = false;
extern bool PushNotificationAlerts = false;
extern bool SoundAlerts = false;
extern string SoundFile = "alert.wav";//fxdaytrader
string msg,crossdir;


double red[],blue[],yellow[],green[],white[],magenta[],v4[];

// Variables for alerts:
color CurrentColor[3] = {White, White, White};
//datetime LastAlertTime = D'1980.01.01';

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      SetIndexBuffer(0,red);
      SetIndexStyle(0,DRAW_HISTOGRAM,0,width2);
      SetIndexLabel(0,"Climax High ");
      
      SetIndexBuffer(1,blue);
      SetIndexStyle(1,DRAW_HISTOGRAM,0,width1);
      SetIndexLabel(1,"Neutral");
      
      SetIndexBuffer(2,yellow);
      SetIndexStyle(2,DRAW_HISTOGRAM,0,width1);
      SetIndexLabel(2,"Low ");
      
      SetIndexBuffer(3,green);
      SetIndexStyle(3,DRAW_HISTOGRAM,0,width1);
      SetIndexLabel(3,"HighChurn ");

      SetIndexBuffer(4,white);
      SetIndexStyle(4,DRAW_HISTOGRAM,0,width2);
      SetIndexLabel(4,"Climax Low ");

      SetIndexBuffer(5,magenta);
      SetIndexStyle(5,DRAW_HISTOGRAM,0,width1);
      SetIndexLabel(5,"ClimaxChurn ");

      SetIndexBuffer(6,v4);
      SetIndexStyle(6,DRAW_LINE,0,1);
      SetIndexLabel(6,"Average("+MAPeriod+")");

      IndicatorShortName("Better Volume 1.5" );

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
/*
   if ( NumberOfBars == 0 )  //				0 = all - appalling resource hog if using anything but 0 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
*/
   if ( NumberOfBars == 0 )
      limit = Bars-counted_bars;
   if ( NumberOfBars > 0 && NumberOfBars < Bars )  //
      limit = NumberOfBars - counted_bars;

   for(int i=0; i<limit; i++)   
      {
         red[i] = 0; blue[i] = Volume[i]; yellow[i] = 0; green[i] = 0; white[i] = 0; magenta[i] = 0;
         Value2=0;Value3=0;HiValue2=0;HiValue3=0;LoValue3=99999999;tempv2=0;tempv3=0;tempv=0;
         if (i <= 2) CurrentColor[i] = White;


         VolLowest = Volume[iLowest(NULL,0,MODE_VOLUME,20,i)];
         if (Volume[i] == VolLowest)
            {
               yellow[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               if (i <= 2) CurrentColor[i] = FireBrick;
            }

         Range = (High[i]-Low[i]);
         Value2 = Volume[i]*Range;

         if (  Range != 0 )
            Value3 = Volume[i]/Range;

         for ( int n=i;n<i+MAPeriod;n++ )
            {
               tempv= Volume[n] + tempv; 
            } 
          v4[i] = NormalizeDouble(tempv/MAPeriod,0);//moving average

          for ( n=i;n<i+LookBack;n++)
            {
               tempv2 = Volume[n]*((High[n]-Low[n])); 
               if ( tempv2 >= HiValue2 )
                  HiValue2 = tempv2;

               if ( Volume[n]*((High[n]-Low[n])) != 0 )
                  {           
                     tempv3 = Volume[n] / ((High[n]-Low[n]));
                     if ( tempv3 > HiValue3 ) 
                        HiValue3 = tempv3; 
                     if ( tempv3 < LoValue3 )
                        LoValue3 = tempv3;
                  } 
            }

          if ( Value2 == HiValue2  && Close[i] > (High[i] + Low[i]) / 2 )
            {
               red[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               yellow[i]=0;
               if (i <= 2) CurrentColor[i] = LightSeaGreen;
            }   

          if ( Value3 == HiValue3 )
            {
               green[i] = NormalizeDouble(Volume[i],0);                
               blue[i] =0;
               yellow[i]=0;
               red[i]=0;
               if (i <= 2) CurrentColor[i] = DodgerBlue;
            }
          if ( Value2 == HiValue2 && Value3 == HiValue3 )
            {
               magenta[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               red[i]=0;
               green[i]=0;
               yellow[i]=0;
               if (i <= 2) CurrentColor[i] = Magenta;
            } 
         if ( Value2 == HiValue2  && Close[i] <= (High[i] + Low[i]) / 2 )
            {
               white[i] = NormalizeDouble(Volume[i],0);
               magenta[i]=0;
               blue[i]=0;
               red[i]=0;
               green[i]=0;
               yellow[i]=0;
               if (i <= 2) CurrentColor[i] = LightSalmon;
            }
      }
//----
//Alerts on volume-ma-cross:
 static datetime LastCrossAlertTime=0;
 if (AlertOnMAcross && CheckForVolMaCross(AlertCandleShift) && LastCrossAlertTime!=iTime(NULL,0,0)) {
 string msg="BetterVolume 1.5a Alert on "+Symbol()+", period "+TFtoStr(Period())+": Moving Average/Volume cross "+crossdir;
 doAlerts(msg,SoundFile);
 LastCrossAlertTime=iTime(NULL,0,0);
 }
//----
//Alerts on color change:
   static datetime LastAlertTime=0;
   if (AlertOnColorChange && (CurrentColor[AlertCandleShift] != CurrentColor[AlertCandleShift+1]) && (LastAlertTime != iTime(NULL,0,0)))
   {
      if ((CurrentColor[AlertCandleShift] == LightSeaGreen) && (IgnoreLightSeaGreen)) return;
      if ((CurrentColor[AlertCandleShift] == White) && (IgnoreWhite)) return;
      if ((CurrentColor[AlertCandleShift] == FireBrick) && (IgnoreFireBrick)) return;
      if ((CurrentColor[AlertCandleShift] == DodgerBlue) && (IgnoreDodgerBlue)) return;
      if ((CurrentColor[AlertCandleShift] == LightSalmon) && (IgnoreLightSalmon)) return;
      if ((CurrentColor[AlertCandleShift] == Magenta) && (IgnoreMagenta)) return;
      //alerts:
      msg="BetterVolume 1.5a Alert on "+Symbol()+", period "+TFtoStr(Period())+": Color changed from "+ColorToString(CurrentColor[AlertCandleShift+1])+" to "+ColorToString(CurrentColor[AlertCandleShift]);
      doAlerts(msg,SoundFile);
      //SendMail("Better Volume Alert - " + ColorToString(CurrentColor[AlertCandleShift+1]) + " -> " + ColorToString(CurrentColor[AlertCandleShift]), Time[AlertCandleShift] + " BetterVolume - Color changed from " + ColorToString(CurrentColor[AlertCandleShift+1]) + " to " + ColorToString(CurrentColor[AlertCandleShift]) + ".");
      LastAlertTime = iTime(NULL,0,0);
   }//if ((CurrentColor[1] != CurrentColor[2]) && (LastAlertTime != Time[1])) 
// 
   return(0);
  }
  
string ColorToString(color Color)
{
   switch(Color)
   {
      case LightSeaGreen: return("LightSeaGreen");
      case White: return("White");
      case FireBrick: return("FireBrick");
      case DodgerBlue: return("DodgerBlue");
      case LightSalmon: return("LightSalmon");
      case Magenta: return("Magenta");
      default: return("Unknown");
   }
}
//+------------------------------------------------------------------+
//fxdaytrader:
bool CheckForVolMaCross(int shift) {
 double ma=v4[shift];
 double mab4=v4[shift+1];
 double vol=iVolume(NULL,0,shift);
 double volb4=iVolume(NULL,0,shift+1);
  /* redundant, makes only sense if we would like to ignore some colors ...
  double vol=0.0;
  if (red[shift]!=0) vol=red[shift];
  if (blue[shift]!=0) vol=blue[shift];
  if (yellow[shift]!=0) vol=yellow[shift];
  if (green[shift]!=0) vol=green[shift];
  if (white[shift]!=0) vol=white[shift];
  if (magenta[shift]!=0) vol=magenta[shift];
  */  
  crossdir="NONE";
  if (vol>ma && volb4<=mab4) { crossdir="UP"; return(true); }
  if (vol<ma && volb4>=mab4) { crossdir="DOWN"; return(true); }
  return(false);
}//bool CheckForVolMaCross(int shift) {

void doAlerts(string msg,string SoundFile) {
 string emailsubject="MT4 alert on acc. "+AccountNumber()+", "+WindowExpertName()+" - Alert on "+Symbol()+", period "+TFtoStr(Period());
  if (PopupAlerts) Alert(msg);
  if (EmailAlerts) SendMail(emailsubject,msg);
  if (PushNotificationAlerts) SendNotification(msg);
  if (SoundAlerts) PlaySound(SoundFile);
}//void doAlerts(string msg,string SoundFile) {

string TFtoStr(int period) {
 switch(period) {
  case 1     : return("M1");  break;
  case 5     : return("M5");  break;
  case 15    : return("M15"); break;
  case 30    : return("M30"); break;
  case 60    : return("H1");  break;
  case 240   : return("H4");  break;
  case 1440  : return("D1");  break;
  case 10080 : return("W1");  break;
  case 43200 : return("MN1"); break;
  default    : return(DoubleToStr(period,0));
 }
 return("UNKNOWN");
}//string TFtoStr(int period) {