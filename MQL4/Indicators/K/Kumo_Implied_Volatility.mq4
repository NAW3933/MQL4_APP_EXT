//+------------------------------------------------------------------+
//|                                      Kumo Implied Volatility.mq4 |
//|                                                   Copyright 2019 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019 ao"
#property link      "https://www.prorealcode.com/prorealtime-indicators"
#property version   "1.00"
#property description "https://www.prorealcode.com/prorealtime-indicators/kumo-implied-volatility/"
#property strict

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   3
//--- plot KIV
#property indicator_label1  "KIV"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrLightSlateGray
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot KIVOB
#property indicator_label2  "KIVOB"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot KIVOS
#property indicator_label3  "KIVOS"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrSpringGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- input parameters
input int      inpTenkansen=9;
input int      inpKijunsen=26;
input int      inpFutureSpanB=52;
input int      inpAverage=200;
input int      inpOB=100;
input int      inpOS=20;
//--- indicator buffers
double         KIVBuffer[];
double         KIVOBBuffer[];
double         KIVOSBuffer[];
double         KumoDepth[];

int k1, k2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,KIVBuffer);
   IndicatorSetInteger(INDICATOR_LEVELS, 2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, inpOS);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, inpOB);
   SetIndexBuffer(1,KIVOBBuffer);
   SetIndexBuffer(2,KIVOSBuffer);
   SetIndexBuffer(3, KumoDepth);
   SetIndexLabel(3, NULL);

   k1 = inpTenkansen;
   if (inpKijunsen < k1)
      k1 = inpKijunsen;
   if (inpFutureSpanB < k1)
      k1 = inpFutureSpanB;
   k2 = inpTenkansen;
   if (k2 < inpKijunsen)
      k2 = inpKijunsen;
   if (k2 < inpFutureSpanB)
      k2 = inpFutureSpanB;

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
   int i, begin;
   double Tenkansen = 0.0, Kijunsen = 0.0, FutureSpanA, FutureSpanB,
          AverageIndicator, StandardDeviation, UpperBand, LowerBand;

   begin = rates_total - prev_calculated;

   if (prev_calculated == 0) {
      if (rates_total < inpAverage * 2) {
         Alert("Insufficient number of candles (" + IntegerToString(rates_total) + ")");
         return 0;
      }
      begin = rates_total - 1 - k1;
   }

   for (i = begin; i >= 0; i--) {
      if (rates_total - i > inpTenkansen)
         Tenkansen = (High[iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, inpTenkansen, i)]
                    + Low[iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, inpTenkansen, i)]) / 2.0;
      else
         Tenkansen = 0.0;

      if (rates_total - i > inpKijunsen)
         Kijunsen = (High[iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, inpKijunsen, i)]
                   + Low[iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, inpKijunsen, i)]) / 2.0;
      else
         Kijunsen = 0.0;

      if (rates_total - i > inpFutureSpanB) {
         FutureSpanA = (Tenkansen + Kijunsen) / 2.0;
         FutureSpanB = (High[iHighest(_Symbol, PERIOD_CURRENT, MODE_HIGH, inpFutureSpanB, i)]
                      + Low[iLowest(_Symbol, PERIOD_CURRENT, MODE_LOW, inpFutureSpanB, i)]) / 2.0;
         KumoDepth[i] = MathAbs(FutureSpanA - FutureSpanB);
      }
      else
         KumoDepth[i] = 0.0;

      if (rates_total - i > k2 && rates_total - i > inpAverage) {
         AverageIndicator = iMAOnArray(KumoDepth, 0, inpAverage, 0, MODE_SMA, i);
//         StandardDeviation = iStdDevOnArray(KumoDepth, 0, inpAverage, 0, MODE_SMA, i);
         double dTemp = 0.0;
         for(int j = 0; j < inpAverage; j++)
            dTemp += (KumoDepth[i + j] - AverageIndicator) * (KumoDepth[i + j] - AverageIndicator);
         StandardDeviation = MathSqrt(dTemp / inpAverage);
         UpperBand = AverageIndicator + (2 * StandardDeviation);
         LowerBand = AverageIndicator - (2 * StandardDeviation);
         KIVBuffer[i] = ((KumoDepth[i] - LowerBand) / (UpperBand - LowerBand)) * 100;
         KIVOBBuffer[i] = EMPTY_VALUE;
         KIVOSBuffer[i] = EMPTY_VALUE;
         if (KIVBuffer[i] > inpOB) {
            KIVOBBuffer[i] = KIVBuffer[i];
//            KIVOBBuffer[i + 1] = KIVBuffer[i + 1];
         }
         else if (KIVBuffer[i] < inpOS) {
            KIVOSBuffer[i] = KIVBuffer[i];
//            KIVOSBuffer[i + 1] = KIVBuffer[i + 1];
         }
      }
      else {
         KIVBuffer[i] = EMPTY_VALUE;
         KIVOBBuffer[i] = EMPTY_VALUE;
         KIVOSBuffer[i] = EMPTY_VALUE;
      }
   }

   return(rates_total);
}
