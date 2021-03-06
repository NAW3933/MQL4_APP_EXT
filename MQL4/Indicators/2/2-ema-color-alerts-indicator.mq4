//+------------------------------------------------------------------+
//|                                                 2_EMA_Color.mq4  |
//|                   Copyright © 2010, Sagacity International Corp. |
//|                                     http://www.paintbarforex.com |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Lime
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Brown
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2


extern int                 Fast  =  49;
extern int                 Slow  =  89;
extern ENUM_MA_METHOD      Mode  =  MODE_EMA;
extern ENUM_APPLIED_PRICE Price  =  PRICE_CLOSE;
extern int            SIGNALBAR  =  1;
extern bool       AlertsMessage  =  true,   //false,    
                    AlertsSound  =  true,   //false,
                    AlertsEmail  =  false,
                   AlertsMobile  =  false;
extern string         SoundFile  =  "alert2.wav";   //"stops.wav"   //"news.wav"   //"expert.wav"  //"Trumpet.wav";  //

double fastBUY[], slowBUY[];
double fastSEL[], slowSEL[];
string  messageUP, messageDN;  datetime TimeBar=0;

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, fastBUY);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, slowBUY);
   SetIndexEmptyValue(1, 0.0);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, fastSEL);
   SetIndexEmptyValue(2, 0.0);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(3, slowSEL);
   SetIndexEmptyValue(3, 0.0);
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double fast, slow;

   int CountedBars = IndicatorCounted();
   if (CountedBars < 0) return (-1);
   if (CountedBars > 0) CountedBars--;
   int limit = Bars - CountedBars;
   
   for (int i = 0; i < limit; i++) 
    {
     fast = iMA(NULL, 0, Fast, 0, Mode, Price, i);
     slow = iMA(NULL, 0, Slow, 0, Mode, Price, i);
     
     if (fast > slow) 
      {
       fastBUY[i] = fast;
       slowBUY[i] = slow;
       fastSEL[i] = 0;
       slowSEL[i] = 0; 
      } 
     
     if (fast <= slow) 
      {
       fastBUY[i] = 0;
       slowBUY[i] = 0;
       fastSEL[i] = fast;
       slowSEL[i] = slow;
      }
    }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   
   if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound) 
    {        ////
     messageUP = WindowExpertName()+ ":  " +_Symbol+", "+stringMTF(_Period)+"  >>  Fast cross  Slow  UP  >>  BUY";
     messageDN = WindowExpertName()+ ":  " +_Symbol+", "+stringMTF(_Period)+"  <<  Fast cross  Slow  DN  <<  SELL"; 
   //------
     if (TimeBar!=Time[0] &&  (fastBUY[SIGNALBAR]!=0 && fastBUY[SIGNALBAR+1]==0)) {   
         if (AlertsMessage) Alert(messageUP);  
         if (AlertsEmail)   SendMail(_Symbol,messageUP);  
         if (AlertsMobile)  SendNotification(messageUP);  
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"   //"alert2.wav"  //"expert.wav"  
         TimeBar=Time[0]; } //return(0);
   //------
     else 
     if (TimeBar!=Time[0] && (fastSEL[SIGNALBAR]!=0 && fastSEL[SIGNALBAR+1]==0)) {   
         if (AlertsMessage) Alert(messageDN);  
         if (AlertsEmail)   SendMail(_Symbol,messageDN);  
         if (AlertsMobile)  SendNotification(messageDN);  
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"   //"alert2.wav"  //"expert.wav"                
         TimeBar=Time[0]; } //return(0); 
    } //*конец* Алертов   
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   return (0);
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                  Stochastic Different AA TT™ [x4]                    %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
string stringMTF(int perMTF)
{  
   if (perMTF==0)      perMTF=_Period;
   if (perMTF==1)      return("M1");
   if (perMTF==5)      return("M5");
   if (perMTF==15)     return("M15");
   if (perMTF==30)     return("M30");
   if (perMTF==60)     return("H1");
   if (perMTF==240)    return("H4");
   if (perMTF==1440)   return("D1");
   if (perMTF==10080)  return("W1");
   if (perMTF==43200)  return("MN1");
   if (perMTF== 2 || 3  || 4  || 6  || 7  || 8  || 9 ||       /// нестандартные периоды для грфиков Renko
               10 || 11 || 12 || 13 || 14 || 16 || 17 || 18)  return("M"+(string)_Period);
//------
   return("Ошибка периода");
}
//**************************************************************************//
//                      Solar Wind Joy DS RP AA MTF TT                      //
//**************************************************************************//