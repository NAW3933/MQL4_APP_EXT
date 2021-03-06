//+------------------------------------------------------------------+ 
//| HMA.mq4 
//| Copyright © 2006 WizardSerg <wizardserg@mail.ru>, ?? ??????? ForexMagazine #104 
//| wizardserg@mail.ru 
//| Revised by IgorAD,igorad2003@yahoo.co.uk | 
//| Personalized by iGoR AKA FXiGoR for the Trend Slope Trading method (T_S_T)
//| Link: 
//| contact: thefuturemaster@hotmail.com 
//+------------------------------------------------------------------+
#property copyright "" 
#property link "" 

// "Modify 2008, Victor Nicolev"
// link "vinin.ucoz.ru"
// Убрал все явные ошибки, теперь индиктор можно использовать в советнике
// При использовании в осветнике обращаться к нулевому буфферу
// Убрана перерисовка

#property indicator_chart_window 
#property indicator_buffers 3
#property indicator_color1 DarkOrchid
#property indicator_color2 DeepSkyBlue
#property indicator_color3 Orange
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2

//---- input parameters 
extern int period=14; 
extern int method=3; // MODE_SMA 
extern int price=0; // PRICE_CLOSE 
extern int sdvig=0;

extern bool   AlertsMessage   = false; 
extern bool   AlertsSound     = false;
extern bool   AlertsEmail     = false;
extern bool   AlertsMobile    = false;
extern string AlertsSoundFile = "alert.wav"; 
extern int    SignalBar       = 0;

datetime TimeBar; 
//---- buffers 


double Uptrend[];
double Dntrend[];
double ExtMapBuffer[];

double vect[]; 

//+------------------------------------------------------------------+ 
//| Custom indicator initialization function | 
//+------------------------------------------------------------------+ 
int init() { 
   IndicatorBuffers(4); 
   SetIndexBuffer(0, ExtMapBuffer); 
   SetIndexBuffer(1, Uptrend); 
   SetIndexBuffer(2, Dntrend); 
   SetIndexBuffer(3, vect); 
   
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);

   SetIndexDrawBegin(0,1*period);
   SetIndexDrawBegin(1,2*period);
   SetIndexDrawBegin(2,3*period);

   IndicatorShortName("Signal Line("+period+")");
   SetIndexLabel(1,"UP");
   SetIndexLabel(2,"DN");
   return(0); 
} 

//+------------------------------------------------------------------+ 
//| Custor indicator deinitialization function | 
//+------------------------------------------------------------------+ 
int deinit() { return(0); } 

//+------------------------------------------------------------------+ 
//| ?????????? ??????? | 
//+------------------------------------------------------------------+ 
double WMA(int x, int p) { return(iMA(NULL, 0, p, 0, method, price, x+sdvig)); } 

//+------------------------------------------------------------------+ 
//| Custom indicator iteration function | 
//+------------------------------------------------------------------+ 
int start() { 
   int counted_bars = IndicatorCounted();

   if (counted_bars < 0) return(-1); 
   if (counted_bars > 0) counted_bars--;
   
   int p = MathSqrt(period); 

   int i, limit0,limit1,limit2;
   
   limit2=Bars - counted_bars;
   limit1=limit2;
   limit0=limit1;

   if (counted_bars==0){
      limit1-=(period);
      limit2-=(2*period);
   }

   for(i = limit0; i >= 0; i--)    vect[i]          = 2*WMA(i, period/2) - WMA(i, period);
   for(i = limit1; i >= 0; i--)    ExtMapBuffer[i]  = iMAOnArray(vect, 0, p, 0, method, i); 
   for(i = limit2; i >= 0; i--)
    { 
      Uptrend[i] = EMPTY_VALUE; if (ExtMapBuffer[i]> ExtMapBuffer[i+1]) Uptrend[i] = ExtMapBuffer[i]; 
      Dntrend[i] = EMPTY_VALUE; if (ExtMapBuffer[i]< ExtMapBuffer[i+1]) Dntrend[i] = ExtMapBuffer[i]; 
    }

  if(AlertsMessage || AlertsSound || AlertsEmail || AlertsMobile)
   { 
     string message1 = (WindowExpertName()+" - "+Symbol()+"  "+PeriodString()+" - Signal Up");
     string message2 = (WindowExpertName()+" - "+Symbol()+"  "+PeriodString()+" - Signal Dn");
       
     if(TimeBar!=Time[0] && Uptrend[SignalBar+1]==EMPTY_VALUE && Uptrend[SignalBar]!=EMPTY_VALUE)
      { 
        if (AlertsMessage) Alert(message1);
        if (AlertsSound)   PlaySound(AlertsSoundFile);
        if (AlertsEmail)   SendMail(Symbol()+" - "+WindowExpertName()+" - ",message1);
        if (AlertsMobile)  SendNotification(message1);
        TimeBar=Time[0];
      }
   
     if(TimeBar!=Time[0] && Dntrend[SignalBar+1]==EMPTY_VALUE && Dntrend[SignalBar]!=EMPTY_VALUE)
      { 
        if (AlertsMessage) Alert(message2);
        if (AlertsSound)   PlaySound(AlertsSoundFile);
        if (AlertsEmail)   SendMail(Symbol()+" - "+WindowExpertName()+" - ",message2);
        if (AlertsMobile)  SendNotification(message2);
        TimeBar=Time[0];
     }
   }
   return(0); 
} 
//+------------------------------------------------------------------+
//| Period String                                                    |
//+------------------------------------------------------------------+
string PeriodString()
  {
    switch (_Period) 
     {
        case PERIOD_M1:  return("M1");
        case PERIOD_M5:  return("M5");
        case PERIOD_M15: return("M15");
        case PERIOD_M30: return("M30");
        case PERIOD_H1:  return("H1");
        case PERIOD_H4:  return("H4");
        case PERIOD_D1:  return("D1");
        case PERIOD_W1:  return("W1");
        case PERIOD_MN1: return("MN1");
        default: return("M"+(string)_Period);
     }  
    return("M"+(string)_Period); 
  }   
//-------------------------------------------------------------------+ 