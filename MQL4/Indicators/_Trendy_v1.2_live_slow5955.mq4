//+------------------------------------------------------------------+
//|                                                       Trendy.mq4 |
//|                                                         forexmts |
//|                                                 forexmts@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Paul Langham"
#property link "http://www.exacttrading.com"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 3
#property indicator_plots   3

#define rCHN "\\Indicators\\ChandelierExit.ex4"
#define cCHN "::Indicators\\ChandelierExit.ex4"
#resource rCHN

//--- plot Up
#property indicator_label1  "Up"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  5
//--- plot Dn
#property indicator_label2  "Dn"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  5
//--- plot Nt
#property indicator_label3  "Nt"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  5

//--- inputs
int Chandelier1_Range = 7;                //Chandelier 1 range
int Chandelier1_Shift = 0;                //Chandelier 1 shift
int Chandelier1_ATRPeriod = 9;            //Chandelier 1 ATR period
double Chandelier1_ATRMultipl = 4.5;      //Chandelier 1 ATR mult
int Chandelier2_Range = 7;                //Chandelier 2 range
int Chandelier2_Shift = 0;                //Chandelier 2 shift
int Chandelier2_ATRPeriod = 9;            //Chandelier 2 ATR period
double Chandelier2_ATRMultipl = 6.0;      //Chandelier 2 ATR mult
int WPRPeriod = 5;                        //Williams %R period
int WPRLevelBuy = -95;                    //Williams %R retrace for BUY
int WPRLevelSell = -5;                    //Williams %R retrace for SELL
input bool bAlert = true;                       //Show alert
input bool bPush = false;                       //Send push
input bool bMail = false;                       //Send e-mail
input uint uiMaxBars = 500;                     //Max bars

//--- indicator buffers
double         dUpBuffer[];
double         dDnBuffer[];
double         dNtBuffer[];
double         dTrendBuffer[];

datetime dtLastAlert;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  //--- indicator buffers mapping1
  IndicatorBuffers(4);
  SetIndexBuffer(0,dUpBuffer);
  SetIndexBuffer(1,dDnBuffer);
  SetIndexBuffer(2,dNtBuffer);
  SetIndexBuffer(3,dTrendBuffer);
  //--- settings
  IndicatorShortName("Trendy_v1.2_live_slow5955");
  IndicatorDigits(0);
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
  if(rates_total < 10) return(0);   //not enough bars
  
  //--- account check
  static bool bOnce = false;
  if(AccountInfoInteger(ACCOUNT_TRADE_MODE) != ACCOUNT_TRADE_MODE_REAL)
    {
    if(!bOnce) { Alert("This version works only on real account!"); bOnce = true; }
    return(rates_total);
    }
  
  int iLimit = rates_total - prev_calculated;
  if(prev_calculated == 0)
    {
    ZeroMemory(dTrendBuffer);
    iLimit = rates_total - 2;
    }
  if(uiMaxBars > 0) iLimit = MathMin(iLimit, (int)uiMaxBars);
  
  //--- main loop
  HideTestIndicators(true);
  for(int i = iLimit; i >= 0; i--)
    {
    double dChand1Sup = fGetChandelier(1, 0, i);
    double dChand1Res = fGetChandelier(1, 1, i);
    double dChand2Sup = fGetChandelier(2, 0, i);
    double dChand2Res = fGetChandelier(2, 1, i);
    double dWPR = iWPR(NULL, 0, WPRPeriod, i);
    
    //--- trend
    dTrendBuffer[i] = MathAbs(dTrendBuffer[i+1]) < 3 ? dTrendBuffer[i+1] : 0;
    bool bTrendUp = dChand1Sup != EMPTY_VALUE && dChand2Sup != EMPTY_VALUE && close[i] > dChand1Sup && dChand1Sup > dChand2Sup;
    bool bTrendDn = dChand1Res != EMPTY_VALUE && dChand2Res != EMPTY_VALUE && close[i] < dChand1Res && dChand1Res < dChand2Res;
    
    if(bTrendUp && dTrendBuffer[i] == 0) dTrendBuffer[i] = 1;
    else
    if(bTrendDn && dTrendBuffer[i] == 0) dTrendBuffer[i] = -1;
    else
    if((dTrendBuffer[i] > 0 && !bTrendUp) || (dTrendBuffer[i] < 0 && !bTrendDn)) dTrendBuffer[i] = 0;
    
    //--- WPR check
    if(dTrendBuffer[i] == 1 && dWPR <= WPRLevelBuy) dTrendBuffer[i] = 2;
    else
    if(dTrendBuffer[i] == -1 && dWPR >= WPRLevelSell) dTrendBuffer[i] = -2;
    
    //--- two candles check
    if(dTrendBuffer[i] == 2 && dTrendBuffer[i+1] == 2 && close[i] > open[i] && close[i+1] > open[i+1]) dTrendBuffer[i] = 3;
    else
    if(dTrendBuffer[i] == -2 && dTrendBuffer[i+1] == -2 && close[i] < open[i] && close[i+1] < open[i+1]) dTrendBuffer[i] = -3;
    
    //--- histogram
    dUpBuffer[i] = dDnBuffer[i] = dNtBuffer[i] = 0;
    switch((int)dTrendBuffer[i])
      {
      case 2: case -2: dNtBuffer[i] = 1; break;
      case 3: dUpBuffer[i] = 1; break;
      case -3: dDnBuffer[i] = 1; break;
      }
    }
  
  //--- alert
  if(time[0] != dtLastAlert)
    {
    dtLastAlert = time[0];
    if(dUpBuffer[1] > 0 && dUpBuffer[2] == 0) fAlert("buy");
    else
    if(dDnBuffer[1] > 0 && dDnBuffer[2] == 0) fAlert("sell");
    }
   
  //--- return value of prev_calculated for next call
  return(rates_total);
  }
//+------------------------------------------------------------------+
double fGetChandelier(int iNum, int iBuf, int iPos)
  {
  switch(iNum)
    {
    case 1: return(iCustom(NULL, 0, cCHN, Chandelier1_Range, Chandelier1_Shift, Chandelier1_ATRPeriod, Chandelier1_ATRMultipl, iBuf, iPos));
    case 2: return(iCustom(NULL, 0, cCHN, Chandelier2_Range, Chandelier2_Shift, Chandelier2_ATRPeriod, Chandelier2_ATRMultipl, iBuf, iPos));
    }
  return(0);
  }
//+------------------------------------------------------------------+
//| Send Alert                                                       |
//+------------------------------------------------------------------+
void fAlert (string sDir)
  {
  string sText = StringFormat("%s_%s: Trendy is %s", _Symbol, StringSubstr(EnumToString(ChartPeriod()),7), sDir);
  if (bAlert) Alert(sText);
  if (bPush) SendNotification(sText);
  if (bMail) SendMail(WindowExpertName(), sText);
  }