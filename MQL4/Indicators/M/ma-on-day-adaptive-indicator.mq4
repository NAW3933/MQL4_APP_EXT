//+------------------------------------------------------------------+
//|                                                      MAOnDay.mq4 |
//|                                                        Scriptong |
//|                                                scriptong@mail.ru |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//------
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1  clrLimeGreen  //OrangeRed
#property indicator_width1  2
#property indicator_style1  STYLE_DOT
//---- input parameters
extern ENUM_TIMEFRAMES    LargeTF = PERIOD_D1;  //1440;
extern int               PeriodMA = 1;
extern ENUM_MA_METHOD    MethodMA = MODE_SMA;
extern ENUM_APPLIED_PRICE PriceMA = PRICE_CLOSE;
extern ENUM_MA_METHOD   MethodSig = MODE_SMA;
//------
bool Activate;
datetime NowDay, LastDay;
double Buffer[];
int Count;
//---- buffers
double MA[];
//+-------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                            |
//+-------------------------------------------------------------------------------------+
int init()
  {
   Activate = False;
// - 1 - == Проверка правильности выбранного пользователем таймфрейма ===================
   if (_Period >= LargeTF)
     {                 //DayAdaptiveMA
      Comment("Индикатор MA on Day Adaptive работает на таймфреймах, меньших, чем D1.");
      return(0);
     }
// - 1 - == Окончание блока =============================================================
   
// - 2 - == Инициализация индикаторного буфера ==========================================
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MA);
   SetIndexEmptyValue(0,0);
// - 2 - == Окончание блока =============================================================
   
// - 3 - == Инициализация буфера для подсчета среднего ==================================
   ArrayResize(Buffer, MathCeil(LargeTF/_Period)+1);
   ArrayInitialize(Buffer, 0);
// - 3 - == Окончание блока =============================================================
   PeriodMA = fmax(PeriodMA,1);     
   //------
   Activate = True;
//----
   return(0);
  }
//+-------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                          |
//+-------------------------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("");
//----
   return(0);
  }
  
//+-------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                 |
//+-------------------------------------------------------------------------------------+
int start()
  {
// - 1 - == Правильно ли инициализирован индикатор? =====================================
   if (!Activate) return(0);
// - 1 - == Окончание блока =============================================================
  
   int limit, CountedBars=IndicatorCounted();
   limit=Bars-CountedBars;
   if (CountedBars==0) limit--;
// - 2 - == Расчет номера бара текущего ТФ, соответствующего началу дня =================
   if (CountedBars>0) CountedBars--;
   limit = iBarShift(_Symbol, 0, iTime(_Symbol, LargeTF, 
                     iBarShift(_Symbol, LargeTF, Time[limit])));
// - 2 - == Окончание блока =============================================================

   LastDay = 1;
   for (int i=limit; i>=0; i--)
     {
// - 3 - == Если начался новый день, формируем все данные заново ========================
      NowDay = iTime(_Symbol, LargeTF, iBarShift(_Symbol, LargeTF, Time[i]));
      if (LastDay != NowDay)
        {
         ArrayInitialize(Buffer, 0);
         Count = 0;
         LastDay = NowDay;
        }
// - 3 - == Окончание блока =============================================================
      
// - 4 - == Определение цены, по которой производится расчет МА =========================
      
      Buffer[Count] = iMA(NULL,0,PeriodMA,0,MethodMA,PriceMA,i); 
    
    //////------
    ////  switch (PriceMA)
    ////    {  
    ////     case 0: /*Close*/    Buffer[Count] = Close[i]; break;
    ////     case 1: /*Open*/     Buffer[Count] = Open[i]; break;
    ////     case 2: /*High*/     Buffer[Count] = High[i]; break;
    ////     case 3: /*Low*/      Buffer[Count] = Low[i]; break;
    ////     case 4: /*Median*/   Buffer[Count] = (High[i]+Low[i])/2; break;
    ////     case 5: /*Typical*/  Buffer[Count] = (High[i]+Low[i]+Close[i])/3; break;
    ////     case 6: /*Weighted*/ Buffer[Count] = (High[i]+Low[i]+2*Close[i])/4; break;  
    ////    }
// - 4 - == Окончание блока =============================================================
      
// - 5 - == Расчет средней скользящей по данным сегодняшнего дня ========================
      MA[i] = iMAOnArray(Buffer, Count+1, Count+1, 0, MethodSig, 0);
      Count++;      
// - 5 - == Окончание блока =============================================================
     } 

   return(0);
  }