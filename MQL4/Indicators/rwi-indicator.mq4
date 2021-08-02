//+------------------------------------------------------------------+
//| RWI.mq4                                                          |
//| Индекс Случайной Прогулки (Random Walk Index)                    |
//| From MetaStock Indicator: Random Walk Index by E. Michael Poulos |
//| Ramdass                                                          |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
// (Random Walk Index)                                               |
//  Индикатор случайной прогулки используется, чтобы                 |
//  определить, развивает ли рыночный инструмент тренд или           |
//  совершает случайные движения в торговом диапазоне.               |
//  Данный индикатор пытается сделать это, определяя сначала         |
//  торговый диапазон рыночного инструмента. Следующий               |
//  шаг состоит в вычислении серии индексов RWI для                  |
//  максимума рассматриваемого периода. Наибольшее движение          |
//  индекса относительно Случайной прогулки используется             |
//  в качестве текущего индекса. Рынок развивает восходящий          |
//  тренд, если RWI максимумов больше 1, в то время                  |
//  как нисходящий тренд указывается, если RWI минимумов больше 1.   |
//                                                                   |
//+------------------------------------------------------------------+
#property  copyright "Ramdass"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_width1 2
#property indicator_width2 2
#property indicator_level1 1
//---- buffers
double RWI_High[];
double RWI_Low[];
//----
int RWI_Period = 8;  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator line
   IndicatorBuffers(2);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, RWI_High);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, RWI_Low);
//----
   IndicatorShortName("RWI");
   SetIndexLabel(0, "RWI_High");
   SetIndexLabel(1, "RWI_Low");  
//----
   SetIndexDrawBegin(0, RWI_Period + 1);
   SetIndexDrawBegin(1, RWI_Period + 1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| RWI                                                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,j;
   double max_1,max_2,max_High,max_Low,atr,sqrt;
//----
   if(Bars <= RWI_Period) 
       return(0);
   int limit = Bars - IndicatorCounted();
//----
   for(i = 0; i < limit; i++)
     {
       max_High=0.0; max_Low=0.0;
       for(j = 1; j <= RWI_Period; j++)
         {
           sqrt = MathSqrt(j + 1);
           atr = iATR(NULL, 0, j + 1, i + 1);
           if(atr != 0.0)
             {
               max_1 = (High[i] - Low[i+j]) / (atr * sqrt);   // RWI_High Index
               max_2 = (High[i+j] - Low[i]) / (atr * sqrt);   // RWI_Low Index
               if(max_1 > max_High) 
                   max_High = max_1;  // Maximum_RWI_High Index
               if(max_2 > max_Low) 
                   max_Low = max_2;   // Maximum_RWI_Low Index
             }
         }
       RWI_High[i] = max_High;
       RWI_Low[i] = max_Low;
     }  
//----
   return(0);
  }
//+------------------------------------------------------------------+