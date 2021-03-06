//+++======================================================================+++
//+++                     Williams AD +MA TT [x3]                          +++
//+++======================================================================+++
#property copyright "" 
#property link      "" 

#property description "Williams Accumulation/Distribution [A/D] определяется изменением цены и объема." 
#property description "Объем выступает в роли весового коэффициента при изменении цены: рост A/D = накопление (покупка) и падение A/D = распределение (продажа) фьючерса." 
//#property version   "1.00"

#property indicator_separate_window
#property indicator_buffers 4

enum MAtype { NO, Lines, Cloud };

//+++======================================================================+++
//+++                 Custom indicator input parameters                    +++
//+++======================================================================+++

extern int            SignalMA1  =  15,
                      SignalMA2  =  45,
                      SignalMA3  =  135;
extern ENUM_MA_METHOD MA1Method  =  MODE_LWMA,
                      MA2Method  =  MODE_LWMA,
                      MA3Method  =  MODE_LWMA;
extern int             WADShift  =  0,
                       MA1Shift  =  0,     
                       MA2Shift  =  0,            
                       MA3Shift  =  0; 
                            
extern color            ADcolor  =  LightSteelBlue,   //Lavender,    Индекс - Цвет
                       MA1color  =  Lime,             //             Первая МАшка: Цвет
                       MA2color  =  Yellow,           //Orange,      Вторая МАшка: Цвет
                       MA3color  =  Red;              //Magenta;     Третья МАшка: Цвет
                     
extern MAtype          MA12Type  =  Lines;            //Первая, Вторая МАшка - Тип Отрисовки 
extern ENUM_LINE_STYLE  ADstyle  =  STYLE_SOLID,      //Индекс - Стиль
                       MA1style  =  STYLE_SOLID,      //Первая МАшка: Стиль
                       MA2style  =  STYLE_SOLID,      //Вторая МАшка: Стиль
                       MA3style  =  STYLE_SOLID;      //Третья МАшка: Стиль
                       
extern int               ADsize  =  2,                //Индекс - Толщина
                        MA1size  =  1,                //Первая МАшка: Толщина
                        MA2size  =  2,                //Вторая МАшка: Толщина
                        MA3size  =  3;                //Третья МАшка: Толщина
                        
extern bool       AlertsMessage  =  false,    
                    AlertsSound  =  false,
                    AlertsEmail  =  false,
                   AlertsMobile  =  false;
                  
//+++======================================================================+++
//+++                     Custom indicator buffers                         +++
//+++======================================================================+++
double Signal1[], Signal2[], Signal3[], Buffer[];
datetime TimeBar=0; 
//+++======================================================================+++
//+++              Custom indicator initialization function                +++
//+++======================================================================+++

int init()
  {
   IndicatorBuffers(4);   IndicatorDigits(Digits-1);

   SetIndexBuffer(0,Signal1);
   SetIndexBuffer(1,Signal2);
   SetIndexBuffer(2,Signal3);
   SetIndexBuffer(3,Buffer);
   
   int LNT = DRAW_NONE;   if (MA12Type==Lines) LNT = DRAW_LINE;    if (MA12Type==Cloud) LNT = DRAW_ZIGZAG;    
   SetIndexStyle(0,LNT,MA1style,MA1size,MA1color);
   SetIndexStyle(1,LNT,MA2style,MA2size,MA2color);
   SetIndexStyle(2,DRAW_LINE,MA3style,MA3size,MA3color);
   SetIndexStyle(3,DRAW_LINE,ADstyle,ADsize,ADcolor);
   
   SetIndexLabel(0,"Signal1  ["+IntegerToString(SignalMA1)+"]");
   SetIndexLabel(1,"Signal2  ["+IntegerToString(SignalMA2)+"]");
   SetIndexLabel(2,"Signal3  ["+IntegerToString(SignalMA3)+"]");
   SetIndexLabel(3,"WAD");
   
   SetIndexShift(0,MA1Shift);     
   SetIndexShift(1,MA2Shift);   
   SetIndexShift(2,MA3Shift);   
   SetIndexShift(3,WADShift);
        
   SetIndexDrawBegin(0,MA1Shift+SignalMA1);     
   SetIndexDrawBegin(1,MA2Shift+SignalMA2);
   SetIndexDrawBegin(2,MA3Shift+SignalMA3);
   SetIndexDrawBegin(3,WADShift);     
   
   IndicatorShortName("WAD -> MA ["+IntegerToString(SignalMA1)+","+IntegerToString(SignalMA2)+","+IntegerToString(SignalMA3)+"]");
//----
   return(0);
  }
//+++======================================================================+++
//+++              Custom indicator deinitialization function              +++
//+++======================================================================+++
int deinit()  { return(0); }
//+++======================================================================+++
//+++                 Custom indicator iteration function                  +++
//+++======================================================================+++

int start()
{
   double AD,TRH,TRL;
   
   int limit, i;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

//+++======================================================================+++
//+++                     Williams AD +MA TT [x3]                          +++
//+++======================================================================+++

   for (i=limit; i >= 0; i--)   //for(i=0; i<=limit; i++)    //
     {      
      TRH = MathMax(High[i], Close[i+1]);
      TRL = MathMin(Low[i], Close[i+1]);
      
      if (Close[i]>Close[i+1]+Point)       AD = Close[i]-TRL;
      else if (Close[i]<Close[i+1]-Point)  AD = Close[i]-TRH;
      else AD = 0;
         
      Buffer[i] = Buffer[i+1]+AD;
     }
//+++======================================================================+++

   for (i=limit; i>=0; i--) 
     {
      if (SignalMA1==0) Signal1[i]=EMPTY_VALUE; else Signal1[i]=iMAOnArray(Buffer,0,SignalMA1,0,MA1Method,i);
      if (SignalMA2==0) Signal2[i]=EMPTY_VALUE; else Signal2[i]=iMAOnArray(Buffer,0,SignalMA2,0,MA2Method,i);   
      if (SignalMA3==0) Signal3[i]=EMPTY_VALUE; else Signal3[i]=iMAOnArray(Buffer,0,SignalMA3,0,MA3Method,i);   
     }
//+++======================================================================+++

   if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound) 
    {
      string message;
      if (TimeBar!=Time[0] && (Buffer[1]>Signal3[1] && Buffer[2]<Signal3[2])) 
       {
         message =("Williams AD +MA TT [x3] - "+Symbol()+", TF ["+IntegerToString(Period())+"] - WAD >>> SignalMA3");
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(Symbol(),message);
         if (AlertsMobile)  SendNotification(message);
         if (AlertsSound)   PlaySound("alert2.wav"); 
         TimeBar=Time[0];
         return(0);
       } 
          
      else if (TimeBar!=Time[0] && (Buffer[1]<Signal3[1] && Buffer[2]>Signal3[2])) 
       { 
         message =("Williams AD +MA TT [x3] - "+Symbol()+", TF ["+IntegerToString(Period())+"] - WAD <<< SignalMA3");
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(Symbol(),message);
         if (AlertsMobile)  SendNotification(message);
         if (AlertsSound)   PlaySound("alert2.wav"); 
         TimeBar=Time[0];
         return(0);
       }
   
      if (TimeBar!=Time[0] && (Buffer[1]>Signal2[1] && Buffer[2]<Signal2[2])) 
       {
         message =("Williams AD +MA TT [x3] - "+Symbol()+", TF ["+IntegerToString(Period())+"] - WAD >>> SignalMA2");
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(Symbol(),message);
         if (AlertsMobile)  SendNotification(message);
         if (AlertsSound)   PlaySound("expert.wav"); 
         TimeBar=Time[0];
         return(0);
       } 
          
      else if (TimeBar!=Time[0] && (Buffer[1]<Signal2[1] && Buffer[2]>Signal2[2])) 
       { 
         message =("Williams AD +MA TT [x3] - "+Symbol()+", TF ["+IntegerToString(Period())+"] - WAD <<< SignalMA2");
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(Symbol(),message);
         if (AlertsMobile)  SendNotification(message);
         if (AlertsSound)   PlaySound("expert.wav"); 
         TimeBar=Time[0];
         return(0);
       }
   
      if (TimeBar!=Time[0] && (Buffer[1]>Signal1[1] && Buffer[2]<Signal1[2]))
       {
         message =("Williams AD +MA TT [x3] - "+Symbol()+", TF ["+IntegerToString(Period())+"] - WAD >>> SignalMA1");
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(Symbol(),message);
         if (AlertsMobile)  SendNotification(message);
         if (AlertsSound)   PlaySound("stops.wav"); 
         TimeBar=Time[0];
       } 
          
      else if (TimeBar!=Time[0] && (Buffer[1]<Signal1[1] && Buffer[2]>Signal1[2])) 
       { 
         message =("Williams AD +MA TT [x3] - "+Symbol()+", TF ["+IntegerToString(Period())+"] - WAD <<< SignalMA1");
         if (AlertsMessage) Alert(message);
         if (AlertsEmail)   SendMail(Symbol(),message);
         if (AlertsMobile)  SendNotification(message);
         if (AlertsSound)   PlaySound("stops.wav"); 
         TimeBar=Time[0];
       }
    }
//----
   return(0);
}
//+++======================================================================+++
//+++                     Williams AD +MA TT [x3]                          +++
//+++======================================================================+++
