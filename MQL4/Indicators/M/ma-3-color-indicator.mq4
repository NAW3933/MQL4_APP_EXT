//+++======================================================================+++
//+++                           MA 3 Color TT                              +++
//+++======================================================================+++
#property copyright   "" 
#property link        "" 
#property description "Индикатор Moving Average показывает среднее значение цены инструмента за некоторый период времени." 
#property description "Существует несколько типов скользящих средних: простое (его также называют арифметическим), экспоненциальное, сглаженное и взвешенное."
#property description "Moving Average можно рассчитывать для любого последовательного набора данных, включая цены открытия и закрытия, максимальную и минимальную цены, объем торгов или значения других индикаторов."
//#property description "Три цвета, отрезками по 10 баров. Расширены настройки, добавлена Медиана." 
#property version  "1.3"
#property indicator_chart_window
#property indicator_buffers 3
//+++======================================================================+++
//+++                 Custom indicator input parameters                    +++
//+++======================================================================+++

extern int                  History  =  3333;                  //Сколько свечей в Истории (глубина Истории для расчёта/отрисовки Индекса)
extern ENUM_TIMEFRAMES  ChangeColor  =  PERIOD_H4;  // Добавить 2 параметра = "менять Цвет на следующий" каждый выбранный ТФ
extern int                 GMTShift  =  0;          // грёбанный GMT!!! но и без него - ни как :(( :((

extern bool             ShowMediana  =  false;
extern int                 MAperiod  =  60,           
                            MAshift  =  0;           
extern ENUM_MA_METHOD       MAmetod  =  MODE_LWMA;    
extern ENUM_APPLIED_PRICE  MAprice1  =  PRICE_OPEN,   
                           MAprice2  =  PRICE_CLOSE;
                          
extern color                 Color1  =  clrCrimson,  //clrRed,     //Lavender,         
                             Color2  =  clrGold,  //clrYellow,  //Magenta,           
                             Color3  =  clrLimeGreen;    //DodgerBlue;            
extern ENUM_LINE_STYLE      MAstyle  =  STYLE_DASH;  //SOLID;    
extern int                   MAsize  =  1,   
                     SizeIndication  =  8; //Динамическая подсветка линии // если =0 == МАшка "не моргает" :))

//+++======================================================================+++
//+++                     Custom indicator buffers                         +++  
//+++======================================================================+++
double ExtMapBuffer1[], ExtMapBuffer2[], ExtMapBuffer3[], MAbuffer[];
//+++======================================================================+++
//+++              Custom indicator initialization function                +++
//+++======================================================================+++
int init()
{
   MAperiod = fmax(MAperiod,1);                         
   //------
  	IndicatorBuffers(4);    	IndicatorDigits(Digits);  if (Digits==3 || Digits==5) IndicatorDigits(Digits-1);
   //------ 3 распределенных буфера индикатора 
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,MAbuffer);
   //------ установка сдвига линий при отрисовке
   SetIndexShift(0,MAshift);   
   SetIndexShift(1,MAshift);   
   SetIndexShift(2,MAshift);   
   //------ пропуск отрисовки первых баров
   SetIndexDrawBegin(0,MAshift+MAperiod);   
   SetIndexDrawBegin(1,MAshift+MAperiod);   
   SetIndexDrawBegin(2,MAshift+MAperiod);   
   //------ "короткое имя" для DataWindow и подокна индикатора 
   SetIndexLabel(0,"MA 3 Color ["+(string)MAperiod+"]");    
   SetIndexLabel(1,"MA 3 Color ["+(string)MAperiod+"]");   
   SetIndexLabel(2,"MA 3 Color ["+(string)MAperiod+"]");
   //----
   IndicatorShortName("MA 3 Color TT ["+(string)MAperiod+"±"+(string)MAshift+"]");
//+++======================================================================+++
//-----
return(0);
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
//+++======================================================================+++
   
   int i, j, shift;
   static int width=0;
   int Count = ChangeColor/_Period;
   int CountCurrent = 1;
   int BarShift = iBarShift(NULL,_Period,iTime(NULL,ChangeColor,0))-GMTShift*60/_Period;
   if (BarShift<Count) CountCurrent=BarShift;
//+++======================================================================+++
//+++                           MA 3 Color TT                              +++     
//+++======================================================================+++
   
   for (i=0; i<limit; i++) {
       if (!ShowMediana)  MAbuffer[i] =  iMA(NULL,0,MAperiod,0,MAmetod,MAprice1,i);       
       else               MAbuffer[i] = (iMA(NULL,0,MAperiod,0,MAmetod,MAprice1,i) + iMA(NULL,0,MAperiod,0,MAmetod,MAprice2,i)) /2;
   }
                                                                       
   for (i=0; i<CountCurrent; i++) {                        
      for (j=0, shift=i; j<=CountCurrent; j++, shift++) {  
         ExtMapBuffer1[shift] = MAbuffer[shift];
         if (j>0 && j<CountCurrent) {
            ExtMapBuffer2[shift]=EMPTY_VALUE;
            ExtMapBuffer3[shift]=EMPTY_VALUE;
         }
      }
   }

   for (i=CountCurrent+Count; i<Bars-1-Count*2; i+=Count) {   
      for (j=0, shift=i; j<=Count; j++, shift++) {            
         ExtMapBuffer1[shift] = MAbuffer[shift];
         if (j>0 && j<Count) {
            ExtMapBuffer2[shift]=EMPTY_VALUE;
            ExtMapBuffer3[shift]=EMPTY_VALUE;
         }
      }
   }
   
   for (i=CountCurrent; i<Bars-1-Count; i+=Count*3) {
      for (j=0, shift=i; j<=Count; j++, shift++) {
         ExtMapBuffer2[shift] = MAbuffer[shift];
         if (j>0 && j<Count) {
            ExtMapBuffer1[shift]=EMPTY_VALUE;
            ExtMapBuffer3[shift]=EMPTY_VALUE;
         }
      }
   }
   
   for (i=CountCurrent+Count; i<Bars-1; i+=Count*3) {
      for (j=0, shift=i; j<=Count; j++, shift++) {
         ExtMapBuffer3[shift] = MAbuffer[shift];
         if (j>0 && j<Count) {
            ExtMapBuffer1[shift]=EMPTY_VALUE;
            ExtMapBuffer2[shift]=EMPTY_VALUE;
         }
      }
   }
//+++======================================================================+++
   
   if (width>SizeIndication) width=MAsize;
   else width++;
   
   SetIndexStyle(0,DRAW_LINE,MAstyle,width,Color3);
   SetIndexStyle(1,DRAW_LINE,MAstyle,width,Color2);
   SetIndexStyle(2,DRAW_LINE,MAstyle,width,Color1);
//+++======================================================================+++
//-----
return(0);
}
//+++======================================================================+++
//+++                           MA 3 Color TT                              +++
//+++======================================================================+++