#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers    4
#property indicator_color1     Red
#property indicator_color2     Blue
#property indicator_color3     Gray
#property indicator_color4     Gray
#property indicator_levelcolor MediumOrchid


extern int Processed        = 2000;
extern int Control_Period   = 14;

extern int Signal_Period    = 5;
extern int Signal_Method    = MODE_SMA;

extern int BB_Up_Period     = 12;
extern int BB_Up_Deviation  = 2;

extern int BB_Dn_Period     = 12;
extern int BB_Dn_Deviation  = 2;

extern double levelOb       = 6;
extern double levelOs       = -6;

extern bool   alertsOn        = true;
extern bool   alertsOnCurrent = false;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = true;
extern bool   alertsEmail     = false;
extern string soundfile       = "alert2.wav";



double values[];
double signal[];
double band_up[];
double band_dn[];
double trend[];

int init() 
{
  IndicatorBuffers(5);
  SetIndexBuffer(0, values);
  SetIndexBuffer(1, signal);
  SetIndexBuffer(2, band_up);
  SetIndexBuffer(3, band_dn);  
  SetIndexBuffer(4, trend);  
  SetLevelValue(0,levelOb);
  SetLevelValue(1,levelOs);
  return (0);
}

int deinit() {
  return (0);
}

int start() {
  datetime bar_time;
  int idx, counter, offset, bar_shft, bar_cont;
  double price_high, price_close, price_low, trigger_high, trigger_low;
  double sum_up, sum_dn, complex_up, complex_dn;

  int counted = IndicatorCounted();
  if (counted < 0) return (-1);
  if (counted > 0) counted--;
  int limit = Bars - counted;
  if (limit > Processed) limit = Processed;

  for (idx = limit; idx >= 0; idx--) {
    counter = 0;
    complex_up = 0; complex_dn = 0;
    trigger_high = -999999; trigger_low  = 999999;

    while (counter < Control_Period) {
      sum_up = 0; sum_dn = 0;
         
      offset = idx + counter;
      bar_time = iTime(Symbol(), 0, offset);
      bar_shft = iBarShift(Symbol(), 0, bar_time, FALSE);
      bar_cont = bar_shft - Period(); if (bar_cont < 0) bar_cont = 0;
         
      for (int jdx = bar_shft; jdx >= bar_cont; jdx--) {   
        price_high  = iHigh(Symbol(), 0, jdx); 
        price_close = iClose(Symbol(), 0, jdx); 
        price_low   = iLow(Symbol(), 0, jdx);
        if (price_high > trigger_high) {trigger_high = price_high; sum_up += price_close;}
        if (price_low  < trigger_low ) {trigger_low  = price_low;  sum_dn += price_close;}
      }
     
      counter++;
      complex_up += sum_up; complex_dn += sum_dn;        
    }
    if (complex_dn != 0.0 && complex_up != 0.0) 
      values[idx] = complex_dn / complex_up - complex_up / complex_dn;
  }
  
  for (idx = limit; idx >= 0; idx--) { 
    signal[idx]  = iMAOnArray(values, 0, Signal_Period, 0, Signal_Method, idx); 
    band_up[idx] = iBandsOnArray(values, 0, BB_Up_Period, BB_Up_Deviation, 0, MODE_UPPER, idx); 
    band_dn[idx] = iBandsOnArray(values, 0, BB_Dn_Period, BB_Dn_Deviation, 0, MODE_LOWER, idx); 
    trend[idx] = trend[idx+1];
    if (values[idx]>levelOb) trend[idx] =-1;
    if (values[idx]<levelOs) trend[idx] = 1;
  }   
  
  if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1;
      if (trend[whichBar] != trend[whichBar+1])
      if (trend[whichBar] == 1)
            doAlert("Oversold");
      else  doAlert("Overbought");       
   }
  
  return (0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          //
          //
          //
          //
          //

          message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Vertex ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," Vertex "),message);
             if (alertsSound)   PlaySound(soundfile);
      }
}