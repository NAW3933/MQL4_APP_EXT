//+------------------------------------------------------------------+
//|                                                     Ex_Trend.mq4 |
//|                                                         forexmts |
//|                                                 forexmts@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Paul Langham"
#property link "http://www.mql5.com/en/users/goshort"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
#property indicator_type1 DRAW_ARROW
#property indicator_type2 DRAW_ARROW
#property indicator_width1 2
#property indicator_width2 2

input uint uiRSIPeriod = 14;                      //RSI period
input uint uiRSIBuy = 70;                         //RSI threshold LONG
input uint uiRSISell = 30;                        //RSI threshold SHORT
input uint uiMACDFast = 12;                       //MACD fast
input uint uiMACDSlow = 26;                       //MACD slow
input string Section1 = "~~~~~~~ALERTS~~~~~~~";   //~~~~~~~ALERTS~~~~~~~
input bool bAlert = false;      //ShowAlert
input bool bPush = false;       //Send push
input bool bMail = false;       //Send e-mail

double adUpBuf[], adDnBuf[];
datetime dtLastAlert;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
  SetIndexBuffer(0, adUpBuf);
  SetIndexArrow(0, 233);
  SetIndexBuffer(1, adDnBuf);
  SetIndexArrow(1, 234);
//---
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
                const int &spread[])
  {
  int iLimit = rates_total - prev_calculated;
  if (prev_calculated == 0)
    {
    ArrayInitialize(adUpBuf, EMPTY_VALUE);
    ArrayInitialize(adDnBuf, EMPTY_VALUE);
    iLimit = rates_total - 2;
    }
  for (int i = iLimit; i >= 0; i--)
    {
    double dRSI = iRSI(_Symbol, _Period, uiRSIPeriod, PRICE_CLOSE, i);
    double dRSI1 = iRSI(_Symbol, _Period, uiRSIPeriod, PRICE_CLOSE, i+1);
    double dMACD = iMACD(_Symbol, _Period, uiMACDFast, uiMACDSlow, 1, PRICE_CLOSE, MODE_MAIN, i);
    double dMACD1 = iMACD(_Symbol, _Period, uiMACDFast, uiMACDSlow, 1, PRICE_CLOSE, MODE_MAIN, i+1);
    
    if (dRSI > uiRSIBuy && dMACD > 0 && (dMACD1 <= 0 || dRSI1 <= uiRSIBuy))
      adUpBuf[i] = low[i]-iATR(_Symbol,_Period,10,i)/2;
    else
      adUpBuf[i] = EMPTY_VALUE;
    
    if (dRSI < uiRSISell && dMACD < 0 && (dMACD1 >= 0 || dRSI1 >= uiRSISell))
      adDnBuf[i] = high[i]+iATR(_Symbol,_Period,10,i)/2;
    else
      adDnBuf[i] = EMPTY_VALUE;
    }
  //alert
  if (time[1] != dtLastAlert)
    {
    dtLastAlert = time[1];
    if (adUpBuf[1] != EMPTY_VALUE) fAlert("buy");
    if (adDnBuf[1] != EMPTY_VALUE) fAlert("sell");
    }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fAlert (string sDir)
  {
  string sText = StringFormat("%s_%s: %s signal", _Symbol, StringSubstr(EnumToString(ChartPeriod()),7), sDir);
  if (bAlert) Alert(sText);
  if (bPush) SendNotification(sText);
  if (bMail) SendMail(WindowExpertName(), sText);
  }
//+------------------------------------------------------------------+
double ND(double dValue) { return(NormalizeDouble(dValue, _Digits)); }
