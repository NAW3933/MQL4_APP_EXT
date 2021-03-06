//+++======================================================================+++
//+++                    MA 3x3 Colors MTF TT [x3x5]                       +++
//+++======================================================================+++
#property copyright   "" 
#property link        "" 
#property description "Индикатор Moving Average показывает среднее значение цены инструмента за некоторый период времени." 
#property description "Существует несколько типов скользящих средних: простое (его также называют арифметическим), экспоненциальное, сглаженное и взвешенное."
#property description "Moving Average можно рассчитывать для любого последовательного набора данных, включая цены открытия и закрытия, максимальную и минимальную цены, объем торгов или значения других индикаторов."
#property description "Три цвета, отрезками по ТФ. Расширены настройки...." 
//#property version  "5.55"
//------
#property indicator_chart_window
#property indicator_buffers 11
//------
#property indicator_color1  clrGreen   //LimeGreen   //Red
#property indicator_color2  clrYellow   //Red
#property indicator_color3  clrRed   //Lime
//------
#property indicator_color4  clrMagenta   //Lime
#property indicator_color5  clrDodgerBlue   //Red
#property indicator_color6  clrLightCyan   //Gold   //LimeGreen   //Red
//------
#property indicator_color7  clrBrown  //Magenta   //Lime
#property indicator_color8  clrMediumBlue  //DodgerBlue   //Red
#property indicator_color9  clrSteelBlue  //SlateGray  //LightCyan   //Gold   //LimeGreen   //Red
//------
#property indicator_color10  clrRed   //Lime
#property indicator_color11  clrWhite   //
//------
#property indicator_style1  STYLE_DOT
#property indicator_style2  STYLE_DOT
#property indicator_style3  STYLE_DOT
//------
#property indicator_style4  STYLE_DASH
#property indicator_style5  STYLE_DASH
#property indicator_style6  STYLE_DASH
//------
#property indicator_style7  STYLE_SOLID
#property indicator_style8  STYLE_SOLID
#property indicator_style9  STYLE_SOLID
//------
#property indicator_width10  1
#property indicator_width11  1
//+++======================================================================+++
enum maType1 { t1SIMPLE,  t1MedianaOC, t1MedianaLH, t1OCLH, t1HeikenAshi };
enum maType2 { t2SIMPLE,  t2MedianaOC, t2MedianaLH, t2OCLH, t2HeikenAshi };
enum maType3 { t3SIMPLE,  t3MedianaOC, t3MedianaLH, t3OCLH, t3HeikenAshi };
//+++======================================================================+++
//+++                 Custom indicator input parameters                    +++
//+++======================================================================+++

extern int                    History  =  3333;   //Сколько свечей в Истории (глубина Истории для расчёта/отрисовки Индекса)
extern string FIRST_Moving_Average = "-----------------------------------------------------------------";
extern ENUM_TIMEFRAMES       MA111MTF  =  PERIOD_CURRENT;  
extern maType1              MA111Type  =  t1SIMPLE;
extern int                MA111period  =  45,           
                           MA111shift  =  0;           
extern ENUM_MA_METHOD      MA111metod  =  MODE_LWMA;    
extern ENUM_APPLIED_PRICE  MA111price  =  PRICE_CLOSE;   
extern ENUM_TIMEFRAMES ChangeColor111  =  PERIOD_H1;  
extern int                GMTShift111  =  0,          
                            MA111size  =  0,   
                           MA111BLINK  =  2; //Динамическая подсветка линии // если =0 == МАшка "не моргает" :))
extern string SECOND_Moving_Average = "-----------------------------------------------------------------";
extern ENUM_TIMEFRAMES       MA222MTF  =  PERIOD_CURRENT;  
extern maType2              MA222Type  =  t2MedianaLH;
extern int                MA222period  =  135,           
                           MA222shift  =  0;           
extern ENUM_MA_METHOD      MA222metod  =  MODE_LWMA;    
extern ENUM_APPLIED_PRICE  MA222price  =  PRICE_CLOSE;   
extern ENUM_TIMEFRAMES ChangeColor222  =  PERIOD_H4;  
extern int                GMTShift222  =  0,         
                            MA222size  =  1,   
                           MA222BLINK  =  3; //Динамическая подсветка линии // если =0 == МАшка "не моргает" :))
extern string THIRD_Moving_Average = "-----------------------------------------------------------------";
extern ENUM_TIMEFRAMES       MA333MTF  =  PERIOD_CURRENT;  
extern maType3              MA333Type  =  t3HeikenAshi;
extern int                MA333period  =  270,           
                           MA333shift  =  0;           
extern ENUM_MA_METHOD      MA333metod  =  MODE_LWMA;    
extern ENUM_APPLIED_PRICE  MA333price  =  PRICE_CLOSE;   
extern ENUM_TIMEFRAMES ChangeColor333  =  PERIOD_D1;  
extern int                GMTShift333  =  0,          
                            MA333size  =  2,   
                           MA333BLINK  =  4; //Динамическая подсветка линии // если =0 == МАшка "не моргает" :))
extern string ARROWS = "-----------------------------------------------------------------";
extern int                  SIGNALBAR  =  0,
                             ArrowGap  =  3,   //Дистанция от High/Low свечи (Koef for ATR)  
                             ArrCodDN  =  234,   //181,  233,   //225
                             ArrCodUP  =  233;  //147,  116, 117, 234,   //226
extern string ALERTS =  "-----------------------------------------------------------------";
extern bool             AlertsMessage  =  true,   //false,    
                          AlertsSound  =  true,   //false,
                          AlertsEmail  =  false,
                         AlertsMobile  =  false;
extern string               SoundFile  =  "news.wav";   //"stops.wav"   //"alert2.wav"   //"expert.wav"
                                                       
//+++======================================================================+++
//+++                     Custom indicator buffers                         +++  
//+++======================================================================+++
double ExtMapBuffer1[], ExtMapBuffer2[], ExtMapBuffer3[]; 
double ExtMapBuffer4[], ExtMapBuffer5[], ExtMapBuffer6[]; 
double ExtMapBuffer7[], ExtMapBuffer8[], ExtMapBuffer9[]; 
double ArrDN[], ArrUP[];   double MA111[], MA222[], MA333[];
ENUM_TIMEFRAMES NextTF;    string CurrTF;  datetime TimeBar=0; 
//+++======================================================================+++
//+++              Custom indicator initialization function                +++
//+++======================================================================+++
int init()
{
  	IndicatorBuffers(14);   IndicatorDigits(Digits);   if (Digits==3 || Digits==5) IndicatorDigits(Digits-1);
//------ 11 распределенных буфера индикатора 
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   //---
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
   //---
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexBuffer(7,ExtMapBuffer8);
   SetIndexBuffer(8,ExtMapBuffer9);
   //---
   SetIndexBuffer(9, ArrDN);    SetIndexStyle(9, DRAW_ARROW);   SetIndexArrow(9, ArrCodDN);  
   SetIndexBuffer(10,ArrUP);   	SetIndexStyle(10,DRAW_ARROW);   SetIndexArrow(10,ArrCodUP);  
//------ 3 дополнительных буфера, используются для подсчета
   SetIndexBuffer(11,MA111);
   SetIndexBuffer(12,MA222);
   SetIndexBuffer(13,MA333);
//------ установка сдвига линий при отрисовке
   SetIndexShift(0,MA111shift);   
   SetIndexShift(1,MA111shift);   
   SetIndexShift(2,MA111shift);   
   //---
   SetIndexShift(3,MA222shift);   
   SetIndexShift(4,MA222shift);   
   SetIndexShift(5,MA222shift);   
   //---
   SetIndexShift(6,MA333shift);   
   SetIndexShift(7,MA333shift);   
   SetIndexShift(8,MA333shift);   
   //---
   SetIndexShift(9, MA111shift);   
   SetIndexShift(10,MA111shift);   
//------ пропуск отрисовки первых баров
   SetIndexDrawBegin(0,MA111shift+MA111period);   
   SetIndexDrawBegin(1,MA111shift+MA111period);   
   SetIndexDrawBegin(2,MA111shift+MA111period);   
   //---
   SetIndexDrawBegin(3,MA222shift+MA222period);   
   SetIndexDrawBegin(4,MA222shift+MA222period);   
   SetIndexDrawBegin(5,MA222shift+MA222period);   
   //---
   SetIndexDrawBegin(6,MA333shift+MA333period);   
   SetIndexDrawBegin(7,MA333shift+MA333period);   
   SetIndexDrawBegin(8,MA333shift+MA333period); 
   //---
   SetIndexDrawBegin(9, MA111shift+MA111period);   
   SetIndexDrawBegin(10,MA111shift+MA111period);   
//------ значение 0 отображаться не будет 
  	//SetIndexEmptyValue(0,0.0);
   //SetIndexEmptyValue(1,0.0);
   //SetIndexEmptyValue(2,0.0);
   //SetIndexEmptyValue(3,0.0); 
   //SetIndexEmptyValue(4,0.0);
   //SetIndexEmptyValue(5,0.0); 
   //SetIndexEmptyValue(6,0.0); 
   //SetIndexEmptyValue(7,0.0); 
   //SetIndexEmptyValue(8,0.0); 
//------ "короткое имя" для DataWindow и подокна индикатора 
   SetIndexLabel(9, "Arrow SELL");   
   SetIndexLabel(10,"Arrow BUY");
   //------
   switchTimeFrame();
   IndicatorShortName(CurrTF+": MA 3x3 TT ["+(string)MA111period+"+"+(string)MA222period+"+"+(string)MA333period+"]");
//+++======================================================================+++
//+++======================================================================+++
//-----
return(0);
}
//+++======================================================================+++
//+++                    MA 3x3 Colors MTF TT [x3x5]                       +++
//+++======================================================================+++
void switchTimeFrame()
{  // вперёд на "следующий ТФ"
   switch(_Period) 
    {
     case PERIOD_M1:   NextTF=PERIOD_M5;   CurrTF="M1";   break;
     case PERIOD_M5:   NextTF=PERIOD_M15;  CurrTF="M5";   break;
     case PERIOD_M15:  NextTF=PERIOD_M30;  CurrTF="M15";  break;
     case PERIOD_M30:  NextTF=PERIOD_H1;   CurrTF="M30";  break;
     case PERIOD_H1:   NextTF=PERIOD_H4;   CurrTF="H1";   break;
     case PERIOD_H4:   NextTF=PERIOD_D1;   CurrTF="H4";   break;
     case PERIOD_D1:   NextTF=PERIOD_W1;   CurrTF="D1";   break;
     case PERIOD_W1:   NextTF=PERIOD_MN1;  CurrTF="W1";   break;
     case PERIOD_MN1:  NextTF=PERIOD_MN1;  CurrTF="MN1";
    }
}
//+++======================================================================+++
//+++======================================================================+++
string stringMTF(int perMTF)
{  // "старший ТФ" для расчётов
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
   return("Ошибка периода");
}
//+++======================================================================+++
//+++              Custom indicator deinitialization function              +++
//+++======================================================================+++
int deinit()  { Comment("");  return(0); }
//+++======================================================================+++
//+++                 Custom indicator iteration function                  +++
//+++======================================================================+++
int start() 
{
   int  counted_bars = IndicatorCounted();       
   if (counted_bars < 0)    return(-1);
     if (History < 1)     History = Bars;       //Tankk-Вариант...
     if (counted_bars > 0)    counted_bars -= 0;
       int limit = MathMin(History-counted_bars,History-1); 
       if (limit <= 0) limit = 1;          
//+++======================================================================+++
   int i, y1, y2, y3, j, shift;  //для "цветных отрезков"  //y = для всех MTF
//+++======================================================================+++
//+++         Calculate Types of Moving Average, Arrows && Alerts          +++     
//+++======================================================================+++
//enum maType1 { t1SIMPLE,  t1MedianaOC, t1MedianaLH, t1OCLH, t1HeikenAshi };
   
   for (i=limit; i>=0; i--)   //for (i=0; i<limit; i++)  //"положительный цикл" был изначально....
    {
     if (MA111MTF < _Period && MA111MTF!=PERIOD_CURRENT) MA111MTF=NextTF;  //авто-переключение на "следующий старший ТФ"  //или = PERIOD_CURRENT; 
     y1 = iBarShift(NULL,MA111MTF,Time[i],false);   
     //---
     if (MA111Type==0)  MA111[i] =  iMA(NULL,MA111MTF,MA111period,0,MA111metod,MA111price,y1);       
     if (MA111Type==1)  MA111[i] = (iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_OPEN,y1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_CLOSE,y1)) /2;
     if (MA111Type==2)  MA111[i] = (iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_LOW,y1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_HIGH,y1)) /2;
     //---
     if (MA111Type==3)  MA111[i] = (iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_OPEN,y1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_CLOSE,y1)
                                    + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_LOW,y1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_HIGH,y1)) /4;
     //---
     if (MA111Type==4)  MA111[i] = (((iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_OPEN,y1+1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_CLOSE,y1+1)) /2)
                                      + ((iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_OPEN,y1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_CLOSE,y1)
                                          + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_LOW,y1) + iMA(NULL,MA111MTF,MA111period,0,MA111metod,PRICE_HIGH,y1)) /4)) /2;
     //+++======================================================================+++
     
     if (MA222MTF < _Period && MA222MTF!=PERIOD_CURRENT) MA222MTF=NextTF;  //авто-переключение на "следующий старший ТФ"  //или = PERIOD_CURRENT; 
     y2=iBarShift(NULL,MA222MTF,Time[i],false);   
     //---
     if (MA222Type==0)  MA222[i] =  iMA(NULL,MA222MTF,MA222period,0,MA222metod,MA222price,y2);       
     if (MA222Type==1)  MA222[i] = (iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_OPEN,y2) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_CLOSE,y2)) /2;
     if (MA222Type==2)  MA222[i] = (iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_LOW,y2) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_HIGH,y2)) /2;
     //---
     if (MA222Type==3)  MA222[i] = (iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_OPEN,y2) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_CLOSE,y2)
                                    + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_LOW,y2) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_HIGH,y2)) /4;
     //---
     if (MA222Type==4)  MA222[i] = (((iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_OPEN,y2+1) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_CLOSE,y2+1)) /2)
                                      + ((iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_OPEN,y2) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_CLOSE,y2)
                                          + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_LOW,y2) + iMA(NULL,MA222MTF,MA222period,0,MA222metod,PRICE_HIGH,y2)) /4)) /2;
     //+++======================================================================+++
     
     if (MA333MTF < _Period && MA333MTF!=PERIOD_CURRENT) MA333MTF=NextTF;  //авто-переключение на "следующий старший ТФ"  //или = PERIOD_CURRENT; 
     y3=iBarShift(NULL,MA333MTF,Time[i],false);   
     //---
     if (MA333Type==0)  MA333[i] =  iMA(NULL,MA333MTF,MA333period,0,MA333metod,MA333price,y3);       
     if (MA333Type==1)  MA333[i] = (iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_OPEN,y3) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_CLOSE,y3)) /2;
     if (MA333Type==2)  MA333[i] = (iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_LOW,y3) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_HIGH,y3)) /2;
     //---
     if (MA333Type==3)  MA333[i] = (iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_OPEN,y3) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_CLOSE,y3)
                                    + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_LOW,y3) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_HIGH,y3)) /4;
     //---
     if (MA333Type==4)  MA333[i] = (((iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_OPEN,y3+1) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_CLOSE,y3+1)) /2)
                                      + ((iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_OPEN,y3) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_CLOSE,y3)
                                          + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_LOW,y3) + iMA(NULL,MA333MTF,MA333period,0,MA333metod,PRICE_HIGH,y3)) /4)) /2;
     //+++======================================================================+++
    
     int SGB=SIGNALBAR;
     double GapAR=ArrowGap*Point;   if (Digits==3 || Digits==5) GapAR=ArrowGap*Point*10;
     ArrDN[i]=EMPTY_VALUE;   ArrUP[i]=EMPTY_VALUE;
     //---
     if ((MA111[i+SGB] < MA222[i+SGB] && MA111[i+1+SGB] > MA222[i+1+SGB]) || (MA111[i+SGB] < MA333[i+SGB] && MA111[i+1+SGB] > MA333[i+1+SGB]))  ArrDN[i] = High[i] +GapAR;  //MA111[i] +GapAR;   //iHigh(NULL,MA111MTF,y) +GapAR;
     if ((MA111[i+SGB] > MA222[i+SGB] && MA111[i+1+SGB] < MA222[i+1+SGB]) || (MA111[i+SGB] > MA333[i+SGB] && MA111[i+1+SGB] < MA333[i+1+SGB]))  ArrUP[i] = Low[i] -GapAR;  //MA111[i] -GapAR;   //iLow(NULL,MA111MTF,y)  -GapAR;
//+++======================================================================+++
    }  //*конец цикла* for (i=limit; i>=0; i--)
//+++======================================================================+++
//+++======================================================================+++

   if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound) 
    {
     string messageDN =("MA 3x3 TT: "+_Symbol+", "+ stringMTF(_Period)+"  <<  Arrow DN  <<  SELL");   //SSL Channel TT  //HA CLH 4C SHLD TT  
     string messageUP =("MA 3x3 TT: "+_Symbol+", "+ stringMTF(_Period)+"  >>  Arrow UP  >>  BUY");    //SSL Channel TT  //HA CLH 4C SHLD TT         
     //---
     if (TimeBar!=Time[0] && ArrDN[0]!=EMPTY_VALUE) 
      {
       if (AlertsMessage) Alert(messageDN);
       if (AlertsEmail)   SendMail(_Symbol,messageDN);
       if (AlertsMobile)  SendNotification(messageDN);
       if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
       TimeBar=Time[0];   //return(0);
      } 
     //---
     else 
     if (TimeBar!=Time[0] && ArrUP[0]!=EMPTY_VALUE) 
      { 
       if (AlertsMessage) Alert(messageUP);
       if (AlertsEmail)   SendMail(_Symbol,messageUP);
       if (AlertsMobile)  SendNotification(messageUP);
       if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
       TimeBar=Time[0];   //return(0);
      }
    }
//+++======================================================================+++
//+++                  Calculate Segments of First MA                      +++
//+++======================================================================+++
   //if (ChangeColor111 < _Period) ChangeColor111=PERIOD_CURRENT;  //вроде НЕ работает :((  		
   //if (ChangeColor111 < _Period) return(0);   //прерывание расчёта индикатора		
   int Count1 = ChangeColor111/_Period;  //количество баров текущего графика внутри каждого бара старшего ТФ
   if (ChangeColor111 < _Period)  Count1 = _Period/_Period;  //"защита от дурака" (чтоб терминал НЕ зависал)  //Count1 = NextTF/_Period;  //или так - авто-переключение на "следующий старший ТФ"
   //---
   int Current1 = 1;  //количество баров периода графика в текущем (нулевом) периоде старшего ТФ
   int BarShift1 = iBarShift(NULL,_Period,iTime(NULL,ChangeColor111,0))-GMTShift111*60/_Period;
   if (BarShift1<Count1)  Current1=BarShift1;
   //+++======================================================================+++
   for (i=0; i<Current1; i++) {                       
     for (j=0, shift=i; j<=Current1; j++, shift++) {  
       ExtMapBuffer1[shift] = MA111[shift];
         if (j>0 && j<Current1) {
           ExtMapBuffer2[shift]=EMPTY_VALUE;
           ExtMapBuffer3[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current1+Count1; i<Bars-1-Count1*2; i+=Count1) {   
     for (j=0, shift=i; j<=Count1; j++, shift++) {            
       ExtMapBuffer1[shift] = MA111[shift];
         if (j>0 && j<Count1) {
           ExtMapBuffer2[shift]=EMPTY_VALUE;
           ExtMapBuffer3[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current1; i<Bars-1-Count1; i+=Count1*3) {
     for (j=0, shift=i; j<=Count1; j++, shift++) {
       ExtMapBuffer2[shift] = MA111[shift];
         if (j>0 && j<Count1) {
           ExtMapBuffer1[shift]=EMPTY_VALUE;
           ExtMapBuffer3[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current1+Count1; i<Bars-1; i+=Count1*3) {
     for (j=0, shift=i; j<=Count1; j++, shift++) {
       ExtMapBuffer3[shift] = MA111[shift];
         if (j>0 && j<Count1) {
           ExtMapBuffer1[shift]=EMPTY_VALUE;
           ExtMapBuffer2[shift]=EMPTY_VALUE; } } }
//+++======================================================================+++
//+++                 Calculate Segments of Second MA                      +++
//+++======================================================================+++
   //if (ChangeColor222 < _Period) ChangeColor222=PERIOD_CURRENT;  //вроде НЕ работает :((  		
   //if (ChangeColor222 < _Period) return(0);   //прерывание расчёта индикатора		
   int Count2 = ChangeColor222/_Period;  //количество баров текущего графика внутри каждого бара старшего ТФ
   if (ChangeColor222 < _Period)  Count2 = _Period/_Period;  //"защита от дурака" (чтоб терминал НЕ зависал)  //Count2 = NextTF/_Period;  //или так - авто-переключение на "следующий старший ТФ"
   //---
   int Current2 = 1;  //количество баров периода графика в текущем (нулевом) периоде старшего ТФ
   int BarShift2 = iBarShift(NULL,_Period,iTime(NULL,ChangeColor222,0))-GMTShift222*60/_Period;
   if (BarShift2<Count2)  Current2=BarShift2;
   //+++======================================================================+++
   for (i=0; i<Current2; i++) {                        
     for (j=0, shift=i; j<=Current2; j++, shift++) {  
       ExtMapBuffer4[shift] = MA222[shift];
         if (j>0 && j<Current2) {
           ExtMapBuffer5[shift]=EMPTY_VALUE;
           ExtMapBuffer6[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current2+Count2; i<Bars-1-Count2*2; i+=Count2) {   
     for (j=0, shift=i; j<=Count2; j++, shift++) {           
       ExtMapBuffer4[shift] = MA222[shift];
         if (j>0 && j<Count2) {
           ExtMapBuffer5[shift]=EMPTY_VALUE;
           ExtMapBuffer6[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current2; i<Bars-1-Count2; i+=Count2*3) {
     for (j=0, shift=i; j<=Count2; j++, shift++) {
       ExtMapBuffer5[shift] = MA222[shift];
         if (j>0 && j<Count2) {
           ExtMapBuffer4[shift]=EMPTY_VALUE;
           ExtMapBuffer6[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current2+Count2; i<Bars-1; i+=Count2*3) {
     for (j=0, shift=i; j<=Count2; j++, shift++) {
       ExtMapBuffer6[shift] = MA222[shift];
         if (j>0 && j<Count2) {
           ExtMapBuffer4[shift]=EMPTY_VALUE;
           ExtMapBuffer5[shift]=EMPTY_VALUE; } } }
//+++======================================================================+++
//+++                  Calculate Segments of Third MA                      +++
//+++======================================================================+++
   //if (ChangeColor333 < _Period) ChangeColor333=PERIOD_CURRENT;  //вроде НЕ работает :((  		
   //if (ChangeColor333 < _Period) return(0);   //прерывание расчёта индикатора		
   int Count3 = ChangeColor333/_Period;  //количество баров текущего графика внутри каждого бара старшего ТФ
   if (ChangeColor333 < _Period)  Count3 = _Period/_Period;  //"защита от дурака" (чтоб терминал НЕ зависал)  //Count3 = NextTF/_Period;  //или так - авто-переключение на "следующий старший ТФ"
   //---
   int Current3 = 1;  //количество баров периода графика в текущем (нулевом) периоде старшего ТФ
   int BarShift3 = iBarShift(NULL,_Period,iTime(NULL,ChangeColor333,0))-GMTShift333*60/_Period;
   if (BarShift3<Count3)  Current3=BarShift3;
   //+++======================================================================+++
   for (i=0; i<Current3; i++) {                        
     for (j=0, shift=i; j<=Current3; j++, shift++) { 
       ExtMapBuffer7[shift] = MA333[shift];
         if (j>0 && j<Current3) {
           ExtMapBuffer8[shift]=EMPTY_VALUE;
           ExtMapBuffer9[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current3+Count3; i<Bars-1-Count3*2; i+=Count3) {   
     for (j=0, shift=i; j<=Count3; j++, shift++) {            
       ExtMapBuffer7[shift] = MA333[shift];
         if (j>0 && j<Count3) {
           ExtMapBuffer8[shift]=EMPTY_VALUE;
           ExtMapBuffer9[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current3; i<Bars-1-Count3; i+=Count3*3) {
     for (j=0, shift=i; j<=Count3; j++, shift++) {
       ExtMapBuffer8[shift] = MA333[shift];
         if (j>0 && j<Count3) {
           ExtMapBuffer7[shift]=EMPTY_VALUE;
           ExtMapBuffer9[shift]=EMPTY_VALUE; } } }
   //+++======================================================================+++
   for (i=Current3+Count3; i<Bars-1; i+=Count3*3) {
     for (j=0, shift=i; j<=Count3; j++, shift++) {
       ExtMapBuffer9[shift] = MA333[shift];
         if (j>0 && j<Count3) {
           ExtMapBuffer7[shift]=EMPTY_VALUE;
           ExtMapBuffer8[shift]=EMPTY_VALUE; } } }
//+++======================================================================+++
//+++                    Manage Size && Blink of MA                        +++
//+++======================================================================+++
   
   static int width1=MA111size;
   //---
   if (MA111BLINK<=0) width1=MA111size;  else {if (width1>MA111BLINK) width1=EMPTY;  else width1++;}
   //---
   SetIndexStyle(0,DRAW_LINE,EMPTY,width1);
   SetIndexStyle(1,DRAW_LINE,EMPTY,width1);
   SetIndexStyle(2,DRAW_LINE,EMPTY,width1);
   //+++======================================================================+++
   static int width2=MA222size;
   //---
   if (MA222BLINK<=0) width2=MA222size;  else {if (width2>MA222BLINK) width2=EMPTY;  else width2++;}
   //---
   SetIndexStyle(3,DRAW_LINE,EMPTY,width2);
   SetIndexStyle(4,DRAW_LINE,EMPTY,width2);
   SetIndexStyle(5,DRAW_LINE,EMPTY,width2);
   //+++======================================================================+++
   static int width3=MA333size;
   //---
   if (MA333BLINK<=0) width3=MA333size;  else {if (width3>MA333BLINK) width3=EMPTY;  else width3++;}
   //---
   SetIndexStyle(6,DRAW_LINE,EMPTY,width3);
   SetIndexStyle(7,DRAW_LINE,EMPTY,width3);
   SetIndexStyle(8,DRAW_LINE,EMPTY,width3);
//+++======================================================================+++
//---- "короткое имя" для DataWindow и подокна индикатора 
   SetIndexLabel(0,"["+stringMTF(ChangeColor111)+"+"+(string)GMTShift111+"h]" + " MA1 ["+stringMTF(MA111MTF)+"="+(string)MA111period+"]");    
   SetIndexLabel(1,"["+stringMTF(ChangeColor111)+"+"+(string)GMTShift111+"h]" + " MA1 ["+stringMTF(MA111MTF)+"="+(string)MA111period+"]");   
   SetIndexLabel(2,"["+stringMTF(ChangeColor111)+"+"+(string)GMTShift111+"h]" + " MA1 ["+stringMTF(MA111MTF)+"="+(string)MA111period+"]");
   //---
   SetIndexLabel(3,"["+stringMTF(ChangeColor222)+"+"+(string)GMTShift222+"h]" + " MA2 ["+stringMTF(MA222MTF)+"="+(string)MA222period+"]");    
   SetIndexLabel(4,"["+stringMTF(ChangeColor222)+"+"+(string)GMTShift222+"h]" + " MA2 ["+stringMTF(MA222MTF)+"="+(string)MA222period+"]");   
   SetIndexLabel(5,"["+stringMTF(ChangeColor222)+"+"+(string)GMTShift222+"h]" + " MA2 ["+stringMTF(MA222MTF)+"="+(string)MA222period+"]");
   //---
   SetIndexLabel(6,"["+stringMTF(ChangeColor333)+"+"+(string)GMTShift333+"h]" + " MA3 ["+stringMTF(MA333MTF)+"="+(string)MA333period+"]");    
   SetIndexLabel(7,"["+stringMTF(ChangeColor333)+"+"+(string)GMTShift333+"h]" + " MA3 ["+stringMTF(MA333MTF)+"="+(string)MA333period+"]");   
   SetIndexLabel(8,"["+stringMTF(ChangeColor333)+"+"+(string)GMTShift333+"h]" + " MA3 ["+stringMTF(MA333MTF)+"="+(string)MA333period+"]");
//+++======================================================================+++
//+++======================================================================+++
//-----
return(0);
}
//+++======================================================================+++
//+++                    MA 3x3 Colors MTF TT [x3x5]                       +++
//+++======================================================================+++