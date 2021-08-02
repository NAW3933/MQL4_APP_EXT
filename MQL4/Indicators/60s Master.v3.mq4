//+------------------------------------------------------------------+
//|                                           60s Master.v3.mq4 |
//|          Copyright © 2016, VIAC.RU, OlegVS, GOODMAN, 2016 Shurka |
//|                                                 shforex@narod.ru |
//|                                                                  |
//|                                                                  |
//| Пишу программы на заказ                                          |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2016"
#property link      "http://shforex.narod.ru"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_width1 1
#property indicator_color2 Red
#property indicator_width2 1
#define  SH_BUY   1
#define  SH_SELL  -1

//---- Входные параметры
extern int     AllBars=0;//How many bars should be counted. 0 - all the bars.
extern int     Otstup=30;//Step back.
extern double  Per=9;//Period.
extern bool UseSoundBuy=true;
extern bool AlertSoundBuy=true;
extern bool UseSoundSell=true;
extern bool AlertSoundSell=true;
extern string SoundFileBuy ="tada.wav";
extern string SoundFileSell="email.wav";
extern bool SendMailPossible = false;
extern int SIGNAL_BAR= 1; 
 bool SoundBuy  = False;
 bool SoundSell = False;

         
int            SH,NB,i,UD,x=0,y=0,a=0,b=0;
double         R,SHMax,SHMin;
double         BufD[];
double         BufU[];
//+------------------------------------------------------------------+
//| Функция инициализации                                            |
//+------------------------------------------------------------------+
int init()
{
   //We will write the number of the bars for which we are counting to the NB
   if (Bars<AllBars+Per || AllBars==0) NB=Bars-Per; else NB=AllBars;
   IndicatorBuffers(2);
   IndicatorShortName("SHI_SilverTrendSig");
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexArrow(1,218);
   SetIndexBuffer(0,BufU);
   SetIndexBuffer(1,BufD);
   SetIndexDrawBegin(0,Bars-NB);//This indicator will be shown for NB bar only
   SetIndexDrawBegin(1,Bars-NB);
//   ArrayInitialize(BufD,0.0);//Give a lot of "zero" to the buffe. Otherwise it will be garbage during the changing of time frame.
//   ArrayInitialize(BufU,0.0);
   return(0);
}
//+------------------------------------------------------------------+
//| Функция деинициализации                                          |
//+------------------------------------------------------------------+
int deinit()
{
   return(0);
}
//+------------------------------------------------------------------+
//| Собсна индикатор                                                 |
//+------------------------------------------------------------------+
int start()
{
   int CB=IndicatorCounted();
   /* It is the optimization option. We have the function here which restore/return the number of counted bars in very special way. 
   During the first indicator's call we have 0: it is normal because it was not counted anything, 
   and then we receive the number of bars minus 1. For example, if the number of bars equal 100,
   we will have 99. I did it especially, you may see that NB is the number of bars whioch should be counted. 
   You know we may throw out this parameter. But for the people who understand we may keep it. So, during the first call
   of indicator this NB is the same one but during the 2dn etc calls - reducing the value up to the last bar, 
   That is 1 or 2 for example*/
   if(CB<0) return(-1); else if(NB>Bars-CB) NB=Bars-CB;
   for (SH=1;SH<=NB;SH++)//comb out the chart from 1 to NB
   {
      for (R=0,i=SH;i<SH+10;i++) {R+=(10+SH-i)*(High[i]-Low[i]);}      R/=55;
      
   

      SHMax = High[Highest(NULL,0,MODE_HIGH,Per,SH)];
      SHMin = Low[Lowest(NULL,0,MODE_LOW,Per,SH)];
      
     
      if (Close[SH]>SHMax-(SHMax-SHMin)*Otstup/100 && UD!=SH_BUY) { BufD[SH]=High[SH]+R*0.5;  
      /*if (Close[SH]>SHMax-(SHMax-SHMin)*Otstup/100 && UD!=SH_BUY)*/ UD=SH_BUY;
      /*if (Close[SH]>SHMax-(SHMax-SHMin)*Otstup/100 && UD!=SH_BUY)*/ y=0; x=x+1;
      
    
      
      }
      else 
          
     
      if (Close[SH]<SHMin+(SHMax-SHMin)*Otstup/100 && UD!=SH_SELL) { BufU[SH]=Low[SH]-R*0.5;  
      /*if (Close[SH]<SHMin+(SHMax-SHMin)*Otstup/100 && UD!=SH_SELL)*/UD=SH_SELL;
      /*if (Close[SH]<SHMin+(SHMax-SHMin)*Otstup/100 && UD!=SH_SELL)*/ x=0; y=y+1;
   
      }
   }
      
   //----------------------- ALERT ON UP / DOWN DOT
   
  
   //string AlertComment;
   string  message  =  StringConcatenate("60s Master.v3 (", Symbol(), ", ", Period(), ")  -  BUY!!!" ,"-" ,TimeToStr(TimeLocal(),TIME_SECONDS));
   string  message2 =  StringConcatenate("60s Master.v3 (", Symbol(), ", ", Period(), ")  -  SELL!!!","-"  ,TimeToStr(TimeLocal(),TIME_SECONDS));  
    
   if (BufU[SIGNAL_BAR] != EMPTY_VALUE && BufU[SIGNAL_BAR] != 0 && SoundBuy)
         {
         SoundBuy = False;
            if (UseSoundBuy) PlaySound (SoundFileBuy);
               if(AlertSoundBuy){         
               Alert(message);                             
               if (SendMailPossible) SendMail(Symbol(),message); 
            }              
         } 
      if (!SoundBuy && (BufU[SIGNAL_BAR] == EMPTY_VALUE || BufU[SIGNAL_BAR] == 0)) SoundBuy = True;  
            
  
     if (BufD[SIGNAL_BAR] != EMPTY_VALUE && BufD[SIGNAL_BAR] != 0 && SoundSell)
         {
         SoundSell = False;
            if (UseSoundSell) PlaySound (SoundFileSell); 
             if(AlertSoundSell){                    
             Alert(message2);             
             if (SendMailPossible) SendMail(Symbol(),message2); 
             }            
         } 
      if (!SoundSell && (BufD[SIGNAL_BAR] == EMPTY_VALUE || BufD[SIGNAL_BAR] == 0)) SoundSell = True;         
   
//+------------------------------------------------------------------+  
    
   


//----------------------- END FUNCTION
   return(0);
}