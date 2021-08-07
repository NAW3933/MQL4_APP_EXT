#property copyright ""
#property link      ""
#property strict

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  clrDodgerBlue

#property indicator_level1 0.0

enum ENUM_CALCULATION_MODE
{
   CALCULATION_MODE_BALANCED,                                                                      // Balanced   
   CALCULATION_MODE_FAST,                                                                          // Fast
   CALCULATION_MODE_SLOW                                                                           // Slow
};


input  int                    i_length             = 13;                                           // Period of calculation
input  ENUM_CALCULATION_MODE  i_mode               = CALCULATION_MODE_FAST;                        // Mode of calculation
input  int                    i_indBarsCount       = 0;                                            // The number of bars to display

double            g_resSentiment[];
double            g_sentBull[];
double            g_sentBear[];
double            g_tempBull[];
double            g_tempBear[];

bool              g_activate;                                                                      // Sign of successful initialization of indicator
     

//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnInit()
{
   g_activate = false;                                                                             
   
   if (!IsTuningParametersCorrect())                                                               
      return INIT_FAILED;                                 
      
   if (!BuffersBind())                             
      return (INIT_FAILED);                                 
         
   g_activate = true;                                                                              
   return INIT_SUCCEEDED;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Checking the correctness of values of tuning parameters                                                                                                                                           |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsTuningParametersCorrect()
{
   string name = WindowExpertName();

   if (i_length < 1)
   {
      Alert(name, ": period of calculation must be more than zero. Indicator is off.");
      return false;
   }

   return (true);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Binding the arrays with the indicator buffers                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool BuffersBind()
{
   string name = WindowExpertName();
   IndicatorBuffers(5);

   if (!SetIndexBuffer(0, g_resSentiment)     ||
       !SetIndexBuffer(1, g_sentBull)         ||
       !SetIndexBuffer(2, g_sentBear)         ||
       !SetIndexBuffer(3, g_tempBull)         ||
       !SetIndexBuffer(4, g_tempBear))
   {
      Alert(name, ": error of binding the arrays with the indicator buffers. Error ¹", GetLastError());
      return false;
   }

   SetIndexStyle(0, DRAW_LINE);
      
   string mode = "";
   switch(i_mode)
   {
      case CALCULATION_MODE_BALANCED:  mode = "Balanced"; break;
      case CALCULATION_MODE_FAST:      mode = "Fast";     break;
      case CALCULATION_MODE_SLOW:      mode = "Slow";     break;
   }

   IndicatorShortName(StringConcatenate("Sentiment (", i_length, ", ", mode, ")"));   
   IndicatorDigits(_Digits + 2);
      
   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Determination of the index bar, from which we want to make recalculation                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int GetRecalcIndex(int& total, const int ratesTotal, const int prevCalculated)
{
   total = ratesTotal - i_length - 1;                                                                         
                                                   
   if (i_indBarsCount > 0 && i_indBarsCount < total)
      total = MathMin(i_indBarsCount, total);                      
                                                   
   if (prevCalculated < ratesTotal - 1)                     
   {       
      InitializeBuffers();
      return (total);
   }
   
   return (MathMin(ratesTotal - prevCalculated, total));                            
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| The indicator buffers initialization                                                                                                                                                              |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void InitializeBuffers()
{
   ArrayInitialize(g_resSentiment, EMPTY_VALUE);
   ArrayInitialize(g_sentBull, 0.0);
   ArrayInitialize(g_sentBear, 0.0);
   ArrayInitialize(g_tempBull, EMPTY_VALUE);
   ArrayInitialize(g_tempBear, EMPTY_VALUE);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Set the temporary values                                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void SetTheTemporary(int barIndex, double barBull, double barBear, double groupBull, double groupBear)
{
   if (barIndex == Bars - 1)
   {
      g_tempBull[barIndex] = barBull;
      g_tempBear[barIndex] = barBear;
      return;
   }

   switch(i_mode)
   {
      case CALCULATION_MODE_BALANCED:  g_tempBull[barIndex] = (barBull + groupBull) / 2;
                                       g_tempBear[barIndex] = (barBear + groupBear) / 2;
                                       break;
         
      case CALCULATION_MODE_FAST:      g_tempBull[barIndex] = barBull;
                                       g_tempBear[barIndex] = barBear;
                                       break;
      
      case CALCULATION_MODE_SLOW:      g_tempBull[barIndex] = groupBull;
                                       g_tempBear[barIndex] = groupBear;
                                       break;
   }
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Prepare the calculattion data                                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void PrepareData(int limit)
{
   for (int i = limit; i >= 0; i--)
   {
      int length      = (int)MathCeil(i_length / 4);
      double barhi    = iMA(NULL, 0, length, 0, MODE_LWMA, PRICE_HIGH,  i);
      double barlo    = iMA(NULL, 0, length, 0, MODE_LWMA, PRICE_LOW,   i);
      double barop    = iMA(NULL, 0, length, 0, MODE_LWMA, PRICE_OPEN,  i);
      double barcl    = iMA(NULL, 0, length, 0, MODE_LWMA, PRICE_CLOSE, i);
      double bar_range = barhi - barlo;
      
      double grouphi     = High[iHighest(NULL, 0, MODE_HIGH, i_length, i)];
      double grouplo     = Low [iLowest (NULL, 0, MODE_LOW,  i_length, i)];
      double groupop     = iOpen(NULL, 0, i + i_length - 1);
      double group_range = grouphi - grouplo;
      
      if (bar_range == 0.0)   
         bar_range = 1.0;

      if(group_range == 0) 
         group_range = 1.0;

      double barBull   = (((barcl - barlo) + (barhi - barop)) / 2) / bar_range;
      double barBear   = (((barhi - barcl) + (barop - barlo)) / 2) / bar_range;

      double groupBull = (((barcl - grouplo) + (grouphi - groupop)) / 2) / group_range;
      double groupBear = (((grouphi - barcl) + (groupop - grouplo)) / 2) / group_range;
      
      SetTheTemporary(i, barBull, barBear, groupBull, groupBear);
   }
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Show the indicator data                                                                                                                                                                           |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowIndicatorData(int limit)
{
   for (int i = limit; i >= 0; i--)
   {
      g_sentBull[i] = iMAOnArray(g_tempBull, Bars, i_length, 0, 0, i);
      g_sentBear[i] = iMAOnArray(g_tempBear, Bars, i_length, 0, 0, i);
      
      g_resSentiment[i] = g_sentBull[i] - g_sentBear[i];
   }
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
{
   if (!g_activate)                                                                                
      return rates_total;                                 
    
   int total;   
   int limit = GetRecalcIndex(total, rates_total, prev_calculated);                                

   PrepareData(limit);
   ShowIndicatorData(limit);                                                                       
   
   return rates_total;
}
