//+------------------------------------------------------------------+
//|                                           CandleWicksDisplay.mq4 |
//|                                  Copyright © 2011, Andriy Moraru |
//| 20.05.15 mode to candle range poruchik                           |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Andriy Moraru"
#property link      "http://www.earnforex.com"

/*
   Alerts you when the candle's wick (shadow) reaches a certain length.
   Your e-mail settings are set in Tools -> Options -> Email.
   Also displays the candle wicks' length above and below the candles.
*/

// The indicator uses only objects for display, but the line below is required for it to work.
#property indicator_chart_window

extern int DisplayWickLimit = 5; // In standard pips
extern color DisplayHighWickColor = Red;
extern color DisplayLowWickColor = Blue;
extern int DisplayWickDistance = 8; // Distance from High to Pip Count
extern int UpperWickLimit = 10; // In broker pips
extern int LowerWickLimit = 10; // In broker pips
extern bool WaitForClose = true; // Wait for a candle to close before checking wicks' length
extern bool EmailAlert = false;
extern bool SoundAlert = false;
extern bool VisualAlert = false;

// Time of the bar of the last alert
datetime AlertDone;

double Poin;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
	Poin = Point;
	//Checking for unconvetional Point digits number
   if ((Point == 0.00001) || (Point == 0.001)) Poin *= 10;
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   for (int i = 0; i < Bars; i++)
   {
      ObjectDelete("Red-" + TimeToStr(Time[i], TIME_DATE|TIME_MINUTES));
      ObjectDelete("Blue-" + TimeToStr(Time[i], TIME_DATE|TIME_MINUTES));
   }
   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   string name, length;
   bool DoAlert = false;
   int index = 0;
   
   if (WaitForClose) index = 1;
   
   int counted_bars = IndicatorCounted();
   if (counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   if (limit > 1200) limit = 1200;
     
   for (int i = 0; i <= limit; i++)
   {
      if (Open[i] <= Close[i])
      {
         if (High[i] - Low[i] >= DisplayWickLimit * Poin) // Upper wick length display
         {
            name = "Red-" + TimeToStr(Time[i], TIME_DATE|TIME_MINUTES);
            length = DoubleToStr(MathRound((High[i] - Low[i]) / Poin), 0);
            if (ObjectFind(name) != -1) ObjectDelete(name);
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], High[i] + DisplayWickDistance * Poin);
            ObjectSetText(name, length, 10, "Verdana", DisplayHighWickColor);
         }
         if (High[i] - Low[i] >= DisplayWickLimit * Poin) // Lower wick length display
         {
            name = "Blue-" + TimeToStr(Time[i], TIME_DATE|TIME_MINUTES);
            length = DoubleToStr(MathRound((High[i] - Low[i]) / Poin), 0);
            if (ObjectFind(name) != -1) ObjectDelete(name);
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], Low[i]);
            ObjectSetText(name, length, 10, "Verdana", DisplayLowWickColor);
         }
      }
      else 
      {
         if (High[i] - Low[i] >= DisplayWickLimit * Poin) // Upper wick length display
         {
            name = "Red-" + TimeToStr(Time[i], TIME_DATE|TIME_MINUTES);
            length = DoubleToStr(MathRound((High[i] - Low[i]) / Poin), 0);
            if (ObjectFind(name) != -1) ObjectDelete(name);
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], High[i] + DisplayWickDistance * Poin);
            ObjectSetText(name, length, 10, "Verdana", DisplayHighWickColor);
         }
         if (High[i] - Low[i] >= DisplayWickLimit * Poin) // Lower wick length display
         {
            name = "Blue-" + TimeToStr(Time[i], TIME_DATE|TIME_MINUTES);
            length = DoubleToStr(MathRound((High[i] - Low[i]) / Poin), 0);
            if (ObjectFind(name) != -1) ObjectDelete(name);
            ObjectCreate(name, OBJ_TEXT, 0, Time[i], Low[i]);
            ObjectSetText(name, length, 10, "Verdana", DisplayLowWickColor);
         }
      }
   }
   
   if (AlertDone == Time[index]) return(0); // Already sent an alert for this candle
   
   if (Close[index] >= Open[index]) // Bullish candle
   {
      if ((High[index] - Close[index] >= UpperWickLimit * Point) || (Open[index] - Low[index] >= LowerWickLimit * Point)) DoAlert = true;
   }
   else // Bearish candle
   {
      if ((High[index] - Open[index] >= UpperWickLimit * Point) || (Close[index] - Low[index] >= LowerWickLimit * Point)) DoAlert = true;
   }
   
   if (DoAlert)
   {
      datetime tc = TimeCurrent();
      string time = TimeYear(tc) + "-" + TimeMonth(tc) + "-" + TimeDay(tc) + " " + TimeHour(tc) + ":" + TimeMinute(tc);
      if (VisualAlert) Alert(time + " - wick limit reached!");
      if (SoundAlert) PlaySound("alert.wav");
      if (EmailAlert) SendMail("CandleWick Alert", time + " - wick limit reached!");
      AlertDone = Time[index];
   }
      
   return(0);
}
//+------------------------------------------------------------------+