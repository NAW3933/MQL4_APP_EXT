
//+------------------------------------------------------------------+
//|             Currency Strength                                    |
//|            https://5d3071208c5e2.site123.me/                     |
//+------------------------------------------------------------------+
#property copyright   "AHARON TZADIK"
#property link        "https://5d3071208c5e2.site123.me/"
#property version     "1.00"
#property strict


extern bool        tick=true;//every tick\open price
extern int         BarsToCount=10;
extern bool        Exit=false;//Enable Exit strategy
extern double      IncreaseFactor=0.001;   //IncreaseFactor
extern int         CandlesToRetrace=10;    //Num.Of Candles For Divergence
extern double      Lots=0.01;              //Lots size
extern double      TrailingStop=40;        //TrailingStop
extern double      Stop_Loss=100;           //Stop Loss
extern int         MagicNumber=1234;       //MagicNumber
input double       Take_Profit=50;          //TakeProfit
extern int         FastMA=6;             //FastMA
extern int         SlowMA=85;            //SlowMA
extern double      Mom_Sell=0.3;           //Momentum_Sell
extern double      Mom_Buy=0.3;            //Momentum_Buy
input bool         UseEquityStop = true;  //Use Equity Stop
input double       TotalEquityRisk = 1.0; //Total Equity Risk
input int          Max_Trades=100;
//---------------------------------------------------------------------------------
extern bool   USETRAILINGSTOP=true; //IF USE TRAILING STOP
extern int    WHENTOTRAIL=40;//WHEN TO TRAIL
extern int    TRAILAMOUNT=40;//TRAIL AMOUNT
extern int    Distance_From_Candle=3;//Distance From Candle
extern bool   USECANDELTRAIL=true;//USE CANDEL TRAIL
extern int     X=3;//NUMBER OF CANDLES
//---------------------------------------------------------------------------------
bool               USEMOVETOBREAKEVEN=true;//Enable "no loss"
double             WHENTOMOVETOBE=30;      //When to move break even
double             PIPSTOMOVESL=30;         //How much pips to move sl
//----
int buyticket;
int selticket;
int BUYSTOPCANDLE;
int SELSTOPCANDLE;
int           err;

int total=0;
double
Lot,Dmax,Dmin,// Amount of lots in a selected order
    Lts,                             // Amount of lots in an opened order
    Min_Lot,                         // Minimal amount of lots
    Step,                            // Step of lot size change
    Free,                            // Current free margin
    One_Lot,                         // Price of one lot
    Price,                           // Price of a selected order,
    pips,
    MA_1,MA_2,MACD_SIGNAL;
int Type,freeze_level,Spread;
//--- price levels for orders and positions
double priceopen,stoploss,takeprofit;
//--- ticket of the current order
int orderticket;

//--------------------------------------------------------------- 3 --
int
Period_MA_2,  Period_MA_3,       // Calculation periods of MA for other timefr.
              Period_MA_02, Period_MA_03,      // Calculation periods of supp. MAs
              K2,K3,T,L;
//---

double AccountEquityHighAmt,PrevEquity;
bool B=false,BUY1=false,sell1=false,BUY2=false,sell2=false,BUY3=false,sell3=false,BUY4=false,sell4=false,BUY5=false
                              ,sell5=false,BUY6=false,sell6=false,BUY7=false,sell7=false,BUY8=false,sell8=false,BUY9=false,sell9=false,BUY10=false,sell10=false
                              ,BUY11=false,sell11=false,BUY12=false,sell12=false,BUY13=false
                              ,sell13=false,BUY14=false,sell14=false,BUY15=false,sell15=false,BUY16=false,sell16=false
                              ,BUY17=false,sell17=false,BUY18=false,sell18=false,BUY19=false,BUY23=false,sell23=false
                              ,sell19=false,BUY20=false,sell20=false,BUY21=false,sell21=false,BUY22=false,sell22=false;
string EUR  ;
string GBP  ;
string AUD  ;
string NZD  ;
string USD  ;
string CAD  ;
string CHF  ;
string JPY ;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

//--------------------------------------------------------------- 5 --
   switch(Period())                 // Calculating coefficient for..
     {
      // .. different timeframes
      case     1:
         L=PERIOD_M5;
         T=PERIOD_M15;
         break;// Timeframe M1
      case     5:
         L=PERIOD_M1;
         T=PERIOD_M15;
         break;// Timeframe M5
      case    15:
         L=PERIOD_M5;
         T=PERIOD_M30;
         break;// Timeframe M15
      case    30:
         L=PERIOD_M15;
         T=PERIOD_H1;
         break;// Timeframe M30
      case    60:
         L=PERIOD_M30;
         T=PERIOD_H4;
         break;// Timeframe H1
      case   240:
         L=PERIOD_H1;
         T=PERIOD_D1;
         break;// Timeframe H4
      case  1440:
         L=PERIOD_H4;
         T=PERIOD_W1;
         break;// Timeframe D1
      case 10080:
         L=PERIOD_D1;
         T=PERIOD_MN1;
         break;// Timeframe W1
      case 43200:
         L=PERIOD_W1;
         T=PERIOD_D1;
         break;// Timeframe MN
     }

   double ticksize=MarketInfo(Symbol(),MODE_TICKSIZE);
   if(ticksize==0.00001 || ticksize==0.001)
      pips=ticksize*10;
   else
      pips=ticksize;
   return(INIT_SUCCEEDED);
//--- distance from the activation price, within which it is not allowed to modify orders and positions
   freeze_level=(int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL);
   if(freeze_level!=0)
     {
      PrintFormat("SYMBOL_TRADE_FREEZE_LEVEL=%d: order or position modification is not allowed,"+
                  " if there are %d points to the activation price",freeze_level,freeze_level);
     }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick(void)
  {
//Gathers the EUR Symbol close values from the past (Base Values)
   double  CloseEURGBP = iClose("EURGBP",PERIOD_CURRENT,1);
   double  CloseEURAUD = iClose("EURAUD",PERIOD_CURRENT,1);
   double  CloseEURNZD = iClose("EURNZD",PERIOD_CURRENT,1);
   double  CloseEURUSD = iClose("EURUSD",PERIOD_CURRENT,1);
   double  CloseEURCAD = iClose("EURCAD",PERIOD_CURRENT,1);
   double  CloseEURCHF = iClose("EURCHF",PERIOD_CURRENT,1);
   double  CloseEURJPY = iClose("EURJPY",PERIOD_CURRENT,1);

//Gathers the GBP Symbol close values from the past (Base Values)
   double  CloseGBPAUD = iClose("GBPAUD",PERIOD_CURRENT,1);
   double  CloseGBPNZD = iClose("GBPNZD",PERIOD_CURRENT,1);
   double  CloseGBPUSD = iClose("GBPUSD",PERIOD_CURRENT,1);
   double  CloseGBPCAD = iClose("GBPCAD",PERIOD_CURRENT,1);
   double  CloseGBPCHF = iClose("GBPCHF",PERIOD_CURRENT,1);
   double  CloseGBPJPY = iClose("GBPJPY",PERIOD_CURRENT,1);

//Gathers the AUD Symbol close values from the past (Base Values)
   double CloseAUDNZD = iClose("AUDNZD",PERIOD_CURRENT,1);
   double CloseAUDUSD = iClose("AUDUSD",PERIOD_CURRENT,1);
   double CloseAUDCAD = iClose("AUDCAD",PERIOD_CURRENT,1);
   double CloseAUDCHF = iClose("AUDCHF",PERIOD_CURRENT,1);
   double CloseAUDJPY = iClose("AUDJPY",PERIOD_CURRENT,1);

//Gathers the NZD Symbol close values from the past (Base Values)
   double CloseNZDUSD = iClose("NZDUSD",PERIOD_CURRENT,1);
   double CloseNZDCAD = iClose("NZDCAD",PERIOD_CURRENT,1);
   double CloseNZDCHF = iClose("NZDCHF",PERIOD_CURRENT,1);
   double CloseNZDJPY = iClose("NZDJPY",PERIOD_CURRENT,1);

//Gathers the USD Symbol close values from the past (Base Values)
   double CloseUSDCAD = iClose("USDCAD",PERIOD_CURRENT,1);
   double CloseUSDCHF = iClose("USDCHF",PERIOD_CURRENT,1);
   double CloseUSDJPY = iClose("USDJPY",PERIOD_CURRENT,1);

//Gathers the CAD Symbol close values from the past (Base Values)
   double CloseCADCHF = iClose("CADCHF",PERIOD_CURRENT,1);
   double CloseCADJPY = iClose("CADJPY",PERIOD_CURRENT,1);

//Gathers the CHF Symbol close values from the past (Base Values)
   double CloseCHFJPY = iClose("CHFJPY",PERIOD_CURRENT,1);


//Gathers the Open EUR Symbol  Values
   double  EURGBP = iOpen("EURGBP", PERIOD_CURRENT,1);
   double  EURAUD = iOpen("EURAUD", PERIOD_CURRENT,1);
   double  EURNZD = iOpen("EURNZD", PERIOD_CURRENT,1);
   double  EURUSD = iOpen("EURUSD", PERIOD_CURRENT,1);
   double  EURCAD = iOpen("EURCAD", PERIOD_CURRENT,1);
   double  EURCHF = iOpen("EURCHF", PERIOD_CURRENT,1);
   double  EURJPY = iOpen("EURJPY", PERIOD_CURRENT,1);

//Gathers the Open GBP Symbol  Values
   double  GBPAUD = iOpen("GBPAUD", PERIOD_CURRENT,1);
   double  GBPNZD = iOpen("GBPNZD", PERIOD_CURRENT,1);
   double  GBPUSD = iOpen("GBPUSD", PERIOD_CURRENT,1);
   double  GBPCAD = iOpen("GBPCAD", PERIOD_CURRENT,1);
   double  GBPCHF = iOpen("GBPCHF", PERIOD_CURRENT,1);
   double  GBPJPY = iOpen("GBPJPY", PERIOD_CURRENT,1);

//Gathers the Open AUD Symbol  Values
   double  AUDNZD = iOpen("AUDNZD", PERIOD_CURRENT,1);
   double  AUDUSD = iOpen("AUDUSD", PERIOD_CURRENT,1);
   double  AUDCAD = iOpen("AUDCAD", PERIOD_CURRENT,1);
   double  AUDCHF = iOpen("AUDCHF", PERIOD_CURRENT,1);
   double  AUDJPY = iOpen("AUDJPY", PERIOD_CURRENT,1);

//Gathers the Open NZD Symbol  Values
   double  NZDUSD = iOpen("NZDUSD", PERIOD_CURRENT,1);
   double  NZDCAD = iOpen("NZDCAD", PERIOD_CURRENT,1);
   double  NZDCHF = iOpen("NZDCHF", PERIOD_CURRENT,1);
   double  NZDJPY = iOpen("NZDJPY", PERIOD_CURRENT,1);

//Gathers the Open USD Symbol  Values
   double  USDCAD = iOpen("USDCAD", PERIOD_CURRENT,1);
   double  USDCHF = iOpen("USDCHF", PERIOD_CURRENT,1);
   double  USDJPY = iOpen("USDJPY", PERIOD_CURRENT,1);

//Gathers the Open CAD Symbol  Values
   double  CADCHF = iOpen("CADCHF", PERIOD_CURRENT,1);
   double  CADJPY = iOpen("CADJPY", PERIOD_CURRENT,1);

//Gathers the Open CHF Symbol  Values
   double  CHFJPY = iOpen("CHFJPY", PERIOD_CURRENT,1);


//Calcualtes the percent change  EUR values
   double perEURGBP = (EURGBP - CloseEURGBP + 0.0000000001)/(CloseEURGBP + 0.0000000001)*100;
   double perEURAUD = (EURAUD - CloseEURAUD + 0.0000000001)/(CloseEURAUD + 0.0000000001)*100;
   double perEURNZD = (EURNZD - CloseEURNZD + 0.0000000001)/(CloseEURNZD + 0.0000000001)*100;
   double perEURUSD = (EURUSD - CloseEURUSD + 0.0000000001)/(CloseEURUSD + 0.0000000001)*100;
   double perEURCAD = (EURCAD - CloseEURCAD + 0.0000000001)/(CloseEURCAD + 0.0000000001)*100;
   double perEURCHF = (EURCHF - CloseEURCHF + 0.0000000001)/(CloseEURCHF + 0.0000000001)*100;
   double perEURJPY = (EURJPY - CloseEURJPY + 0.0000000001)/(CloseEURJPY + 0.0000000001)*100;

//Calcualtes the percent change  GBP values
   double perGBPAUD = (GBPAUD - CloseGBPAUD + 0.0000000001)/(CloseGBPAUD + 0.0000000001)*100;
   double perGBPNZD = (GBPNZD - CloseGBPNZD + 0.0000000001)/(CloseGBPNZD + 0.0000000001)*100;
   double perGBPUSD = (GBPUSD - CloseGBPUSD + 0.0000000001)/(CloseGBPUSD + 0.0000000001)*100;
   double perGBPCAD = (GBPCAD - CloseGBPCAD + 0.0000000001)/(CloseGBPCAD + 0.0000000001)*100;
   double perGBPCHF = (GBPCHF - CloseGBPCHF + 0.0000000001)/(CloseGBPCHF + 0.0000000001)*100;
   double perGBPJPY = (GBPJPY - CloseGBPJPY + 0.0000000001)/(CloseGBPJPY + 0.0000000001)*100;

//Calcualtes the percent change AUD values
   double perAUDNZD = (AUDNZD - CloseAUDNZD + 0.0000000001)/(CloseAUDNZD + 0.0000000001)*100;
   double perAUDUSD = (AUDUSD - CloseAUDUSD + 0.0000000001)/(CloseAUDUSD + 0.0000000001)*100;
   double perAUDCAD = (AUDCAD - CloseAUDCAD + 0.0000000001)/(CloseAUDCAD + 0.0000000001)*100;
   double perAUDCHF = (AUDCHF - CloseAUDCHF + 0.0000000001)/(CloseAUDCHF + 0.0000000001)*100;
   double perAUDJPY = (AUDJPY - CloseAUDJPY + 0.0000000001)/(CloseAUDJPY + 0.0000000001)*100;

//Calcualtes the percent change  NZD values
   double perNZDUSD = (NZDUSD - CloseNZDUSD + 0.0000000001)/(CloseNZDUSD + 0.0000000001)*100;
   double perNZDCAD = (NZDCAD - CloseNZDCAD + 0.0000000001)/(CloseNZDCAD + 0.0000000001)*100;
   double perNZDCHF = (NZDCHF - CloseNZDCHF + 0.0000000001)/(CloseNZDCHF + 0.0000000001)*100;
   double perNZDJPY = (NZDJPY - CloseNZDJPY + 0.0000000001)/(CloseNZDJPY + 0.0000000001)*100;

//Calcualtes the percent change  USD values
   double perUSDCAD = (USDCAD - CloseUSDCAD + 0.0000000001)/(CloseUSDCAD + 0.0000000001)*100;
   double perUSDCHF = (USDCHF - CloseUSDCHF + 0.0000000001)/(CloseUSDCHF + 0.0000000001)*100;
   double perUSDJPY = (USDJPY - CloseUSDJPY + 0.0000000001)/(CloseUSDJPY + 0.0000000001)*100;

//Calcualtes the percent change  CAD values
   double perCADCHF = (CADCHF - CloseCADCHF + 0.0000000001)/(CloseCADCHF + 0.0000000001)*100;
   double perCADJPY = (CADJPY - CloseCADJPY + 0.0000000001)/(CloseCADJPY + 0.0000000001)*100;

//Calcualtes the percent change  CHF values
   double perCHFJPY = (CHFJPY - CloseCHFJPY + 0.0000000001)/(CloseCHFJPY + 0.0000000001)*100;


//Calculates true strength of the Pair
   double perEUR = (perEURGBP + perEURAUD + perEURNZD + perEURUSD + perEURCAD+ perEURCHF + perEURJPY);
   double perGBP = ((-perEURGBP) + perGBPAUD + perGBPNZD + perGBPUSD + perGBPCAD + perGBPCHF + perGBPJPY);
   double perAUD = (((-perEURAUD) + (-perGBPAUD)) + perAUDNZD + perAUDUSD + perAUDCAD + perAUDCHF + perAUDJPY);
   double perNZD = (((-perEURNZD) + (-perGBPNZD) + (-perAUDNZD)) + perNZDUSD + perNZDCAD + perNZDCHF + perNZDJPY);
   double perUSD = (((-perEURUSD) + (-perGBPUSD) + (-perAUDUSD) + (-perNZDUSD)) + perUSDCAD + perUSDCHF + perUSDJPY);
   double perCAD = (((-perEURCAD) + (-perGBPCAD) + (-perAUDCAD) + (-perNZDCAD) + (-perUSDCAD)) + perCADCHF + perCADJPY);
   double perCHF = (((-perEURCHF) + (-perGBPCHF) + (-perAUDCHF) + (-perNZDCHF) + (-perUSDCHF) + (-perCADCHF)) + perCHFJPY);
   double perJPY = ((-perEURJPY) + (-perGBPJPY) + (-perAUDJPY) + (-perNZDJPY) + (-perUSDJPY) + (-perCADJPY) + (-perCHFJPY));




//------------------------------PRINT VALUE---------------------------------------------------------
   //NAW Commented out -dont need it
   //Print("EUR ", perEUR);
   //Print("GBP ", perGBP);
   //Print("AUD ", perAUD);
  // Print("NZD ", perNZD);
   //Print("USD ", perUSD);
   //Print("CAD ", perCAD);
   //Print("CHF ", perCHF);
   //Print("JPY ", perJPY);
//------------------------------FIND STRONGEST----------------------------------------------------------------------------
   if(perEUR>perGBP && perEUR>perAUD && perEUR>perNZD && perEUR>perUSD && perEUR>perCAD && perEUR>perCHF && perEUR>perJPY)
     { EUR="one" ;}
   if(perEUR<perGBP && perEUR<perAUD && perEUR<perNZD && perEUR<perUSD && perEUR<perCAD && perEUR<perCHF && perEUR<perJPY)
     { EUR="eight" ;}

   if(perGBP>perEUR && perGBP>perAUD && perGBP>perNZD && perGBP>perUSD && perGBP>perCAD && perGBP>perCHF && perGBP>perJPY)
     { GBP="one"  ;}
   if(perGBP<perEUR && perGBP<perAUD && perGBP<perNZD && perGBP<perUSD && perGBP<perCAD && perGBP<perCHF && perGBP<perJPY)
     { GBP="eight" ;}

   if(perAUD>perEUR && perAUD>perGBP && perAUD>perNZD && perAUD>perUSD && perAUD>perCAD && perAUD>perCHF && perAUD>perJPY)
     { AUD="one"  ;}
   if(perAUD<perEUR && perAUD<perGBP && perAUD<perNZD && perAUD<perUSD && perAUD<perCAD && perAUD<perCHF && perAUD<perJPY)
     { AUD="eight" ;}

   if(perNZD>perEUR && perNZD>perGBP && perNZD>perAUD && perNZD>perUSD && perNZD>perCAD && perNZD>perCHF && perNZD>perJPY)
     { NZD="one"  ;}
   if(perNZD<perEUR && perNZD<perGBP && perNZD<perAUD && perNZD<perUSD && perNZD<perCAD && perNZD<perCHF && perNZD<perJPY)
     { NZD="eight" ;}

   if(perUSD>perEUR && perUSD>perGBP && perUSD>perAUD && perUSD>perNZD && perUSD>perCAD && perUSD>perCHF && perUSD>perJPY)
     { USD="one"  ;}
   if(perUSD<perEUR && perUSD<perGBP && perUSD<perAUD && perUSD<perNZD && perUSD<perCAD && perUSD<perCHF && perUSD<perJPY)
     { USD="eight" ;}

   if(perCAD>perEUR && perCAD>perGBP && perCAD>perAUD && perCAD>perNZD && perCAD>perUSD && perCAD>perCHF && perCAD>perJPY)
     { CAD="one"  ;}
   if(perCAD<perEUR && perCAD<perGBP && perCAD<perAUD && perCAD<perNZD && perCAD<perUSD && perCAD<perCHF && perCAD<perJPY)
     { CAD="eight" ;}

   if(perCHF>perEUR && perCHF>perGBP && perCHF>perAUD && perCHF>perNZD && perCHF>perUSD && perCHF>perCAD && perCHF>perJPY)
     { CHF="one"  ;}
   if(perCHF<perEUR && perCHF<perGBP && perCHF<perAUD && perCHF<perNZD && perCHF<perUSD && perCHF<perCAD && perCHF<perJPY)
     { CHF="eight" ;}

   if(perJPY>perEUR && perJPY>perGBP && perJPY>perAUD && perJPY>perNZD && perJPY>perUSD && perJPY>perCAD && perJPY>perCHF)
     { JPY="one"  ;}
   if(perJPY<perEUR && perJPY<perGBP && perJPY<perAUD && perJPY<perNZD && perJPY<perUSD && perJPY<perCAD && perJPY<perCHF)
     { JPY="eight" ;}

//---------------EUR-------------------------------
   if(EUR=="one"&&JPY=="eight")
      if(StringFind(_Symbol,"EURJPY")==-1)
        {
         BUY1=false;
        }
      else
        {BUY1=true;}

//----------------------------------
   if(EUR=="eight"&&JPY=="one")
      if(StringFind(_Symbol,"EURJPY")==-1)
        {
         sell1=false;
        }
      else
        {sell1=true;}
//-------------------------------------
   if(EUR=="one"&&GBP=="eight")
      if(StringFind(_Symbol,"EURGBP")==-1)
        {
         BUY2=false;
        }
      else
        {BUY2=true;}

   if(EUR=="eight"&&GBP=="one")
      if(StringFind(_Symbol,"EURGBP")==-1)
        {
         sell2=false;
        }
      else
        {sell2=true;}
//-------------------------------------
   if(EUR=="one"&&AUD=="eight")
      if(StringFind(_Symbol,"EURAUD")==-1)
        {
         BUY3=false;
        }
      else
        {BUY3=true;}

   if(EUR=="eight"&&AUD=="one")
      if(StringFind(_Symbol,"EURAUD")==-1)
        {
         sell3=false;
        }
      else
        {sell3=true;}
//-------------------------------------
   if(EUR=="one"&&NZD=="eight")
      if(StringFind(_Symbol,"EURNZD")==-1)
        {
         BUY4=false;
        }
      else
        {BUY4=true;}

   if(EUR=="eight"&&NZD=="one")
      if(StringFind(_Symbol,"EURNZD")==-1)
        {
         sell4=false;
        }
      else
        {sell4=true;}
//-------------------------------------
   if(EUR=="one"&&USD=="eight")
      if(StringFind(_Symbol,"EURUSD")==-1)
        {
         BUY5=false;
        }
      else
        {BUY5=true;}

   if(EUR=="eight"&&USD=="one")
      if(StringFind(_Symbol,"EURUSD")==-1)
        {
         sell5=false;
        }
      else
        {sell5=true;}
//-------------------------------------
   if(EUR=="one"&&CAD=="eight")
      if(StringFind(_Symbol,"EURCAD")==-1)
        {
         BUY6=false;
        }
      else
        {BUY6=true;}

   if(EUR=="eight"&&CAD=="one")
      if(StringFind(_Symbol,"EURCAD")==-1)
        {
         sell6=false;
        }
      else
        {sell6=true;}
//-------------------------------------
   if(EUR=="one"&&CHF=="eight")
      if(StringFind(_Symbol,"EURCHF")==-1)
        {
         BUY7=false;
        }
      else
        {BUY7=true;}

   if(EUR=="eight"&&CHF=="one")
      if(StringFind(_Symbol,"EURCHF")==-1)
        {
         sell7=false;
        }
      else
        {sell7=true;}
//-------------------------------------
   if(EUR=="one"&&JPY=="eight")
      if(StringFind(_Symbol,"EURJPY")==-1)
        {
         BUY8=false;
        }
      else
        {BUY8=true;}

   if(EUR=="eight"&&JPY=="one")
      if(StringFind(_Symbol,"EURJPY")==-1)
        {
         sell8=false;
        }
      else
        {sell8=true;}
//---------------GBP-------------------------------
   if(GBP=="one"&&AUD=="eight")
      if(StringFind(_Symbol,"GBPAUD")==-1)
        {
         BUY9=false;
        }
      else
        {BUY9=true;}

   if(GBP=="eight"&&AUD=="one")
      if(StringFind(_Symbol,"GBPAUD")==-1)
        {
         sell9=false;
        }
      else
        {sell9=true;}
//-------------------------------------
   if(GBP=="one"&&NZD=="eight")
      if(StringFind(_Symbol,"GBPNZD")==-1)
        {
         BUY9=false;
        }
      else
        {BUY9=true;}

   if(GBP=="eight"&&NZD=="one")
      if(StringFind(_Symbol,"GBPNZD")==-1)
        {
         sell9=false;
        }
      else
        {sell9=true;}
//-------------------------------------
   if(GBP=="one"&&USD=="eight")
      if(StringFind(_Symbol,"GBPUSD")==-1)
        {
         BUY10=false;
        }
      else
        {BUY10=true;}

   if(GBP=="eight"&&USD=="one")
      if(StringFind(_Symbol,"GBPUSD")==-1)
        {
         sell10=false;
        }
      else
        {sell10=true;}
//-------------------------------------
   if(GBP=="one"&&CAD=="eight")
      if(StringFind(_Symbol,"GBPCAD")==-1)
        {
         BUY11=false;
        }
      else
        {BUY11=true;}

   if(GBP=="eight"&&CAD=="one")
      if(StringFind(_Symbol,"GBPCAD")==-1)
        {
         sell11=false;
        }
      else
        {sell11=true;}
//-------------------------------------
   if(GBP=="one"&&CHF=="eight")
      if(StringFind(_Symbol,"GBPCHF")==-1)
        {
         BUY12=false;
        }
      else
        {BUY12=true;}

   if(GBP=="eight"&&CHF=="one")
      if(StringFind(_Symbol,"GBPCHF")==-1)
        {
         sell12=false;
        }
      else
        {sell12=true;}
//-------------------------------------
   if(GBP=="one"&&JPY=="eight")
      if(StringFind(_Symbol,"GBPJPY")==-1)
        {
         BUY13=false;
        }
      else
        {BUY13=true;}
   if(GBP=="eight"&&JPY=="one")
      if(StringFind(_Symbol,"GBPJPY")==-1)
        {
         sell13=false;
        }
      else
        {sell13=true;}
//---------------AUD-------------------------------
   if(AUD=="one"&&USD=="eight")
      if(StringFind(_Symbol,"GBPUSD")==-1)
        {
         BUY14=false;
        }
      else
        {BUY14=true;}

   if(AUD=="eight"&&USD=="one")
      if(StringFind(_Symbol,"GBPUSD")==-1)
        {
         sell14=false;
        }
      else
        {sell14=true;}
//-------------------------------------
   if(AUD=="one"&&NZD=="eight")
      if(StringFind(_Symbol,"AUDNZD")==-1)
        {
         BUY15=false;
        }
      else
        {BUY15=true;}

   if(AUD=="eight"&&NZD=="one")
      if(StringFind(_Symbol,"AUDNZD")==-1)
        {
         sell15=false;
        }
      else
        {sell15=true;}
//-------------------------------------
   if(AUD=="one"&&CAD=="eight")
      if(StringFind(_Symbol,"AUDCAD")==-1)
        {
         BUY16=false;
        }
      else
        {BUY16=true;}

   if(AUD=="eight"&&CAD=="one")
      if(StringFind(_Symbol,"AUDCAD")==-1)
        {
         sell16=false;
        }
      else
        {sell16=true;}
//-------------------------------------
   if(AUD=="one"&&CHF=="eight")
      if(StringFind(_Symbol,"AUDCHF")==-1)
        {
         BUY17=false;
        }
      else
        {BUY17=true;}

   if(AUD=="eight"&&CHF=="one")
      if(StringFind(_Symbol,"AUDCHF")==-1)
        {
         sell17=false;
        }
      else
        {sell17=true;}
//-------------------------------------
   if(AUD=="one"&&JPY=="eight")
      if(StringFind(_Symbol,"AUDJPY")==-1)
        {
         BUY18=false;
        }
      else
        {BUY18=true;}

   if(AUD=="eight"&&USD=="one")
      if(StringFind(_Symbol,"AUDJPY")==-1)
        {
         sell18=false;
        }
      else
        {sell18=true;}
//---------------USD-------------------------------
   if(USD=="one"&&CHF=="eight")
      if(StringFind(_Symbol,"USDCHF")==-1)
        {
         BUY19=false;
        }
      else
        {BUY19=true;}

   if(USD=="eight"&&CHF=="one")
      if(StringFind(_Symbol,"USDCHF")==-1)
        {
         sell19=false;
        }
      else
        {sell19=true;}
//-------------------------------------
   if(USD=="one"&&CAD=="eight")
      if(StringFind(_Symbol,"USDCAD")==-1)
        {
         BUY20=false;
        }
      else
        {BUY20=true;}

   if(USD=="eight"&&CAD=="one")
      if(StringFind(_Symbol,"USDCAD")==-1)
        {
         sell20=false;
        }
      else
        {sell20=true;}
//-------------------------------------
   if(USD=="one"&&JPY=="eight")
      if(StringFind(_Symbol,"USDJPY")==-1)
        {
         BUY21=false;
        }
      else
        {BUY21=true;}
   if(USD=="eight"&&JPY=="one")
      if(StringFind(_Symbol,"USDJPY")==-1)
        {
         sell21=false;
        }
      else
        {sell21=true;}

//************************************************************

//************************************************************

// double MacdCurrent,MacdPrevious;
// double SignalCurrent,SignalPrevious;
//double MaCurrent,MaPrevious;
   int   ticket=0;
   double AveragePrice=0;
   double Count=0;
   double CurrentPairProfit=CalculateProfit();
// Check for New Bar (Compatible with both MQL4 and MQL5)
   static datetime dtBarCurrent=WRONG_VALUE;
   datetime dtBarPrevious=dtBarCurrent;
   dtBarCurrent=(datetime) SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
   bool NewBarFlag=(dtBarCurrent!=dtBarPrevious);
   if(NewBarFlag)

      if(USEMOVETOBREAKEVEN)
        {MOVETOBREAKEVEN();}
  adjustTrail();

   if(UseEquityStop)
     {
      if(CurrentPairProfit<0.0 && MathAbs(CurrentPairProfit)>TotalEquityRisk/100.0*AccountEquityHigh())
        {
         CloseThisSymbolAll();
         Print("Closed All due to Stop Out");

        }
     }


   ticket=0;
// initial data checks
// it is important to make sure that the expert works with a normal
// chart and the user did not make any mistakes setting external
// variables (Lots, StopLoss, TakeProfit,
// TrailingStop) in our case, we check TakeProfit
// on a chart of less than 100 bars
//---
   if(Bars<100)
     {
      Print("bars less than 100");
      return;
     }
   if(Take_Profit<10)
     {
      Print("TakeProfit less than 10");
      return;
     }
//--- to simplify the coding and speed up access data are put into internal variables
   HideTestIndicators(true);
//+------------------------------------------------------------------+
   double   MA_1_t=iMA(NULL,L,FastMA,0,MODE_LWMA,PRICE_TYPICAL,0); // МА_1
   double   MA_2_t=iMA(NULL,L,SlowMA,0,MODE_LWMA,PRICE_TYPICAL,0); // МА_2
//----------------------------------------------------------------------------
   double   MomLevel=MathAbs(100-iMomentum(NULL,T,14,PRICE_CLOSE,1));
   double   MomLevel1=MathAbs(100 - iMomentum(NULL,T,14,PRICE_CLOSE,2));
   double   MomLevel2=MathAbs(100 - iMomentum(NULL,T,14,PRICE_CLOSE,3));
//----------------------------------------------------------------------------
   double upper=iHigh(Symbol(),T,iHighest(Symbol(),Period(),MODE_HIGH,BarsToCount,1));
   double lower=iLow(Symbol(),T,iLowest(Symbol(),Period(),MODE_LOW,BarsToCount,1));
   double middle=(upper+lower)/2;
//--------------------------------------------------------------------------------------------------
   HideTestIndicators(false);
//--------------------------------------------------------------------------------------------------
// if(getOpenOrders()==0)


//--- no opened orders identified
   if(AccountFreeMargin()<(1000*Lots))
     {
      Print("We have no money. Free Margin = ",AccountFreeMargin());
      return;
     }
   if(NewBarFlag  &&CountTrades()<Max_Trades)
     {
      //--- check for long position (BUY) possibility
      //+------------------------------------------------------------------+
      //| BUY                      BUY                 BUY                 |
      //+------------------------------------------------------------------+
    
         if(MA_1_t>MA_2_t)
            if(MomLevel<Mom_Buy || MomLevel1<Mom_Buy || MomLevel2<Mom_Buy)

               if(BUY1==true||BUY2==true||BUY3==true||BUY4==true||BUY5==true
                  ||BUY6==true||BUY7==true||BUY8==true||BUY9==true||BUY10==true||BUY11==true||BUY12==true
                  ||BUY13==true||BUY14==true||BUY15==true||BUY16==true||BUY17==true||BUY18==true||BUY19==true
                  ||BUY20==true||BUY21==true||BUY22==true)
                  //------------------------------------------------------------------------------------------------------------
                 {
                  if(NewBarFlag)
                     if((CheckVolumeValue(LotsOptimized(Lots)))==TRUE)
                        if((CheckMoneyForTrade(Symbol(),LotsOptimized(Lots),OP_BUY))==TRUE)
                           if((CheckStopLoss_Takeprofit(OP_BUY,NDTP(Bid-Stop_Loss*pips),NDTP(Bid+Take_Profit*pips)))==TRUE)
                              ticket=OrderSend(Symbol(),OP_BUY,LotsOptimized(Lots),ND(Ask),3,NDTP(Bid-Stop_Loss*pips),NDTP(Bid+Take_Profit*pips),"Long 1",MagicNumber,0,PaleGreen);
                  if(ticket>0)
                    {
                     if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
                        Print("BUY order opened : ",OrderOpenPrice());
                     Alert("we just got a buy signal on the ",_Period,"M",_Symbol);
                     SendNotification("we just got a buy signal on the1 "+(string)_Period+"M"+_Symbol);
                     SendMail("Order sent successfully","we just got a buy signal on the1 "+(string)_Period+"M"+_Symbol);
                    }
                  else
                     Print("Error opening BUY order : ",GetLastError());
                  return;
                 }
      //--- check for short position (SELL) possibility
      //+------------------------------------------------------------------+
      //| SELL             SELL                       SELL                 |
      //+------------------------------------------------------------------+
     
         if(MA_1_t<MA_2_t)
            if(MomLevel<Mom_Sell || MomLevel1<Mom_Sell || MomLevel2<Mom_Sell)
               //-------------------------------------------------------------------------------------------------------------------------
               if(sell1==true||sell2==true||sell3==true||sell4==true||sell5==true||sell6==true||sell7==true||sell8==true
                  ||sell9==true||sell10==true||sell11==true||sell12==true||sell13==true||sell14==true||sell15==true||sell16==true
                  ||sell17==true||sell18==true||sell19==true||sell20==true||sell21==true||sell22)
                  //-------------------------------------------------------------------------------------------------------------------------
                 {
                  // if(NewBarFlag)
                  if((CheckVolumeValue(LotsOptimized(Lots)))==TRUE)
                     if((CheckMoneyForTrade(Symbol(),LotsOptimized(Lots),OP_SELL))==TRUE)
                        if((CheckStopLoss_Takeprofit(OP_SELL,NDTP(Ask+Stop_Loss*pips),NDTP(Ask-Take_Profit*pips)))==TRUE)
                           ticket=OrderSend(Symbol(),OP_SELL,LotsOptimized(Lots),ND(Bid),3,NDTP(Ask+Stop_Loss*pips),NDTP(Ask-Take_Profit*pips),"Short 1",MagicNumber,0,Red);
                  if(ticket>0)
                    {
                     if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
                        Print("SELL order opened : ",OrderOpenPrice());
                     Alert("we just got a sell signal on the ",_Period,"M",_Symbol);
                     SendMail("Order sent successfully","we just got a sell signal on the "+(string)_Period+"M"+_Symbol);
                    }
                  else
                     Print("Error opening SELL order : ",GetLastError());
                 }
     }
//--- exit from the "no opened orders" block
   return;

  }


//+------------------------------------------------------------------+
//| Trailing stop loss                                               |
//+------------------------------------------------------------------+
// --------------- ----------------------------------------------------------- ------------------------
//+---------------------------------------------------------------------------+
//|                          CANDLE  Trailing stop loss
//+---------------------------------------------------------------------------+
void adjustTrail()// CANDLE TRAIL
  {
// Check for New Bar (Compatible with both MQL4 and MQL5)
   static datetime dtBarCurrent=WRONG_VALUE;
   datetime dtBarPrevious=dtBarCurrent;
   dtBarCurrent=(datetime) SeriesInfoInteger(_Symbol,_Period,SERIES_LASTBAR_DATE);
   bool NewBarFlag=(dtBarCurrent!=dtBarPrevious);
   BUYSTOPCANDLE=iLowest(Symbol(),0,1,X,0);//Lowest
   SELSTOPCANDLE=iHighest(Symbol(),0,2,X,0);//Highest
//Buy
//+------------------------------------------------------------------+
//| Buy                                                              |
//+------------------------------------------------------------------+
//----------------------------------------------------------------------------------
   for(int b=OrdersTotal()-1; b>=0; b--)
     {
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()!=MagicNumber)
            continue;
      if(OrderSymbol()==Symbol())//Symbol
         if(OrderType()==OP_BUY)//OrderType
            if(USECANDELTRAIL)
              {

               if(NewBarFlag)
                 {
                  RefreshRates();
                  stoploss=Low[BUYSTOPCANDLE]-Distance_From_Candle*pips;
                  takeprofit=OrderTakeProfit()+pips*TRAILAMOUNT;
                  double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)+MarketInfo(Symbol(),MODE_SPREAD);
                  if(stoploss<StopLevel*pips)
                     stoploss=StopLevel*pips;
                  string symbol=OrderSymbol();
                  double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
                  if(MathAbs(OrderStopLoss()-stoploss)>point)
                     if((pips*TRAILAMOUNT)>(int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL)*pips)

                        //--- modify order and exit
                        if(CheckStopLoss_Takeprofit(OP_BUY,stoploss,takeprofit))
                           if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),stoploss,takeprofit))

                              if(OrderStopLoss()<Low[BUYSTOPCANDLE]-Distance_From_Candle*pips)
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),Low[BUYSTOPCANDLE]-Distance_From_Candle*pips,takeprofit,0,CLR_NONE))
                                    Print("eror");

                 }
              }
            else
               if(Bid-OrderOpenPrice()>WHENTOTRAIL*pips)
                  if(OrderStopLoss()<Bid-pips*TRAILAMOUNT)
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(pips*TRAILAMOUNT),OrderTakeProfit(),0,CLR_NONE))//משנים את STOPLOS
                        Print("eror");
     }

//SELL
//+------------------------------------------------------------------+
//| SELL                                                              |
//+------------------------------------------------------------------+
//------------------------------------------------------------------------------
   for(int s=OrdersTotal()-1; s>=0; s--)
     {
      if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()!=MagicNumber)
            continue;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_SELL)
            if(USECANDELTRAIL)
              {

               if(NewBarFlag)
                 {

                  RefreshRates();
                  stoploss=High[SELSTOPCANDLE]+Distance_From_Candle*pips;
                  takeprofit=OrderTakeProfit()-pips*TRAILAMOUNT;
                  double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)+MarketInfo(Symbol(),MODE_SPREAD);
                  if(stoploss<StopLevel*pips)
                     stoploss=StopLevel*pips;
                  if(takeprofit<StopLevel*pips)
                     takeprofit=StopLevel*pips;
                  string symbol=OrderSymbol();
                  double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
                  if(MathAbs(OrderStopLoss()-stoploss)>point)
                     if((pips*TRAILAMOUNT)>(int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_FREEZE_LEVEL)*pips)

                        //--- modify order and exit
                        if(CheckStopLoss_Takeprofit(OP_SELL,stoploss,takeprofit))
                           if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),stoploss,takeprofit))

                              if(OrderStopLoss()>High[SELSTOPCANDLE]+Distance_From_Candle*pips)
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),High[SELSTOPCANDLE]+Distance_From_Candle*pips,takeprofit,0,CLR_NONE))
                                    Print("eror");
                 }
              }
            else
               if(OrderOpenPrice()-Ask>WHENTOTRAIL*pips)
                  if(OrderStopLoss()>Ask+pips*TRAILAMOUNT || OrderStopLoss()==0)
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(pips*TRAILAMOUNT),OrderTakeProfit(),0,CLR_NONE))
                        Print("eror");
     }

  }
//+------------------------------------------------------------------+
//+---------------------------------------------------------------------------+
//|                          MOVE TO BREAK EVEN                               |
//+---------------------------------------------------------------------------+
void MOVETOBREAKEVEN()

  {
   for(int b=OrdersTotal()-1; b>=0; b--)
     {
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()!=MagicNumber)
            continue;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_BUY)
            if(Bid-OrderOpenPrice()>WHENTOMOVETOBE*pips)
               if(OrderOpenPrice()>OrderStopLoss())
                  if(CheckStopLoss_Takeprofit(OP_SELL,OrderOpenPrice()+(PIPSTOMOVESL*pips),OrderTakeProfit()))
                     if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(PIPSTOMOVESL*pips),OrderTakeProfit()))
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(PIPSTOMOVESL*pips),OrderTakeProfit(),0,CLR_NONE))
                           Print("eror");
     }

   for(int s=OrdersTotal()-1; s>=0; s--)
     {
      if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
         if(OrderMagicNumber()!=MagicNumber)
            continue;
      if(OrderSymbol()==Symbol())
         if(OrderType()==OP_SELL)
            if(OrderOpenPrice()-Ask>WHENTOMOVETOBE*pips)
               if(OrderOpenPrice()<OrderStopLoss())
                  if(CheckStopLoss_Takeprofit(OP_SELL,OrderOpenPrice()-(PIPSTOMOVESL*pips),OrderTakeProfit()))
                     if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(PIPSTOMOVESL*pips),OrderTakeProfit()))
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(PIPSTOMOVESL*pips),OrderTakeProfit(),0,CLR_NONE))
                           Print("eror");
     }
  }
//--------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
double NDTP(double val)
  {
   RefreshRates();
   double SPREAD=MarketInfo(Symbol(),MODE_SPREAD);
   double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(val<StopLevel*pips+SPREAD*pips)
      val=StopLevel*pips+SPREAD*pips;
   return(NormalizeDouble(val, Digits));
// return(val);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double ND(double val)
  {
   return(NormalizeDouble(val, Digits));
  }
//+------------------------------------------------------------------+
//| Checking the new values of levels before order modification      |
//+------------------------------------------------------------------+
bool OrderModifyCheck(int ticket,double price,double sl,double tp)
  {
//--- select order by ticket
   if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
      //--- point size and name of the symbol, for which a pending order was placed
      string symbol=OrderSymbol();
      double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
      //--- check if there are changes in the Open price
      bool PriceOpenChanged=true;
      int type=OrderType();
      if(!(type==OP_BUY || type==OP_SELL))
        {
         PriceOpenChanged=(MathAbs(OrderOpenPrice()-price)>point);
        }
      //--- check if there are changes in the StopLoss level
      bool StopLossChanged=(MathAbs(OrderStopLoss()-sl)>point);
      //--- check if there are changes in the Takeprofit level
      bool TakeProfitChanged=(MathAbs(OrderTakeProfit()-tp)>point);
      //--- if there are any changes in levels
      if(PriceOpenChanged || StopLossChanged || TakeProfitChanged)
         return(true);  // order can be modified
      //--- there are no changes in the Open, StopLoss and Takeprofit levels
      else
         //--- notify about the error
         PrintFormat("Order #%d already has levels of Open=%.5f SL=%.5f TP=%.5f",
                     ticket,OrderOpenPrice(),OrderStopLoss(),OrderTakeProfit());
     }
//--- came to the end, no changes for the order
   return(false);       // no point in modifying
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool CheckStopLoss_Takeprofit(ENUM_ORDER_TYPE type,double SL,double TP)
  {
//--- get the SYMBOL_TRADE_STOPS_LEVEL level
   int stops_level=(int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
   if(stops_level!=0)
     {
      PrintFormat("SYMBOL_TRADE_STOPS_LEVEL=%d: StopLoss and TakeProfit must"+
                  " not be nearer than %d points from the closing price",stops_level,stops_level);
     }
//---
   bool SL_check=false,TP_check=false;
//--- check only two order types
   switch(type)
     {
      //--- Buy operation
      case  ORDER_TYPE_BUY:
        {
         //--- check the StopLoss
         SL_check=(Bid-SL>stops_level*_Point);
         if(!SL_check)
            PrintFormat("For order %s StopLoss=%.5f must be less than %.5f"+
                        " (Bid=%.5f - SYMBOL_TRADE_STOPS_LEVEL=%d points)",
                        EnumToString(type),SL,Bid-stops_level*_Point,Bid,stops_level);
         //--- check the TakeProfit
         TP_check=(TP-Bid>stops_level*_Point);
         if(!TP_check)
            PrintFormat("For order %s TakeProfit=%.5f must be greater than %.5f"+
                        " (Bid=%.5f + SYMBOL_TRADE_STOPS_LEVEL=%d points)",
                        EnumToString(type),TP,Bid+stops_level*_Point,Bid,stops_level);
         //--- return the result of checking
         return(SL_check&&TP_check);
        }
      //--- Sell operation
      case  ORDER_TYPE_SELL:
        {
         //--- check the StopLoss
         SL_check=(SL-Ask>stops_level*_Point);
         if(!SL_check)
            PrintFormat("For order %s StopLoss=%.5f must be greater than %.5f "+
                        " (Ask=%.5f + SYMBOL_TRADE_STOPS_LEVEL=%d points)",
                        EnumToString(type),SL,Ask+stops_level*_Point,Ask,stops_level);
         //--- check the TakeProfit
         TP_check=(Ask-TP>stops_level*_Point);
         if(!TP_check)
            PrintFormat("For order %s TakeProfit=%.5f must be less than %.5f "+
                        " (Ask=%.5f - SYMBOL_TRADE_STOPS_LEVEL=%d points)",
                        EnumToString(type),TP,Ask-stops_level*_Point,Ask,stops_level);
         //--- return the result of checking
         return(TP_check&&SL_check);
        }
      break;
     }
//--- a slightly different function is required for pending orders
   return false;
  }
//+------------------------------------------------------------------+
////////////////////////////////////////////////////////////////////////////////////
int getOpenOrders()
  {

   int Orders=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
        {
         continue;
        }
      if(OrderSymbol()!=Symbol() || OrderMagicNumber()!=MagicNumber)
        {
         continue;
        }
      Orders++;
     }
   return(Orders);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Calculate optimal lot size buy                                   |
//+------------------------------------------------------------------+
double LotsOptimized1Mxs(double llots)
  {
   double lots=llots;
//--- minimal allowed volume for trade operations
   double minlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lots<minlot)
     { lots=minlot; }
//--- maximal allowed volume of trade operations
   double maxlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(lots>maxlot)
     { lots=maxlot;  }
//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lots/volume_step);
   if(MathAbs(ratio*volume_step-lots)>0.0000001)
     {  lots=ratio*volume_step;}
   if(((AccountStopoutMode()==1) &&
       (AccountFreeMarginCheck(Symbol(),OP_BUY,lots)>AccountStopoutLevel()))
      || ((AccountStopoutMode()==0) &&
          ((AccountEquity()/(AccountEquity()-AccountFreeMarginCheck(Symbol(),OP_BUY,lots))*100)>AccountStopoutLevel())))
      return(lots);
   /* else  Print("StopOut level  Not enough money for ",OP_SELL," ",lot," ",Symbol());*/
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Calculate optimal lot size buy                                   |
//+------------------------------------------------------------------+
double LotsOptimizedMxs(double llots)
  {
   double lots=llots;
//--- minimal allowed volume for trade operations
   double minlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lots<minlot)
     {
      lots=minlot;
      Print("Volume is less than the minimal allowed ,we use",minlot);
     }
//--- maximal allowed volume of trade operations
   double maxlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(lots>maxlot)
     {
      lots=maxlot;
      Print("Volume is greater than the maximal allowed,we use",maxlot);
     }
//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lots/volume_step);
   if(MathAbs(ratio*volume_step-lots)>0.0000001)
     {
      lots=ratio*volume_step;

      Print("Volume is not a multiple of the minimal step ,we use the closest correct volume ",ratio*volume_step);
     }

   return(lots);

  }
//+------------------------------------------------------------------+
//| Check the correctness of the order volume                        |
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume/*,string &description*/)

  {
   double lot=volume;
   int    orders=OrdersHistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//--- select lot size
//--- maximal allowed volume of trade operations
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(lot>max_volume)

      Print("Volume is greater than the maximal allowed ,we use",max_volume);
//  return(false);

//--- minimal allowed volume for trade operations
   double minlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lot<minlot)

      Print("Volume is less than the minimal allowed ,we use",minlot);
//  return(false);

//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lot/volume_step);
   if(MathAbs(ratio*volume_step-lot)>0.0000001)
     {
      Print("Volume is not a multiple of the minimal step ,we use, the closest correct volume is %.2f",
            volume_step,ratio*volume_step);
      //   return(false);
     }
//  description="Correct volume value";
   return(true);
  }
//+------------------------------------------------------------------+
bool CheckMoneyForTrade(string symb,double lots,int type)
  {
   double free_margin=AccountFreeMarginCheck(symb,type,lots);
//-- if there is not enough money
   if(free_margin>0)
     {
      if((AccountStopoutMode()==1) &&
         (AccountFreeMarginCheck(symb,type,lots)<AccountStopoutLevel()))
        {
         Print("StopOut level  Not enough money ", type," ",lots," ",Symbol());
         return(false);
        }
      if(AccountEquity()-AccountFreeMarginCheck(Symbol(),type,lots)==0)
        {
         Print("StopOut level  Not enough money ", type," ",lots," ",Symbol());
         return(false);
        }
      if((AccountStopoutMode()==0) &&
         ((AccountEquity()/(AccountEquity()-AccountFreeMarginCheck(Symbol(),type,lots))*100)<AccountStopoutLevel()))
        {
         Print("StopOut level  Not enough money ", type," ",lots," ",Symbol());
         return(false);
        }
     }
   else
      if(free_margin<0)
        {
         string oper=(type==OP_BUY)? "Buy":"Sell";
         Print("Not enough money for ",oper," ",lots," ",symb," Error code=",GetLastError());
         return(false);
        }
//--- checking successful
   return(true);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTrades()
  {
   int count=0;
   for(int trade=OrdersTotal()-1; trade>=0; trade--)
     {
      if(!OrderSelect(trade,SELECT_BY_POS,MODE_TRADES))
         Print("Error");
      if(OrderSymbol()!=Symbol() || OrderMagicNumber()!=MagicNumber)
         continue;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         if(OrderType()==OP_SELL || OrderType()==OP_BUY)
            count++;
     }
   return (count);
  }
//+------------------------------------------------------------------+
double AccountEquityHigh()
  {
   if(CountTrades()==0)
      AccountEquityHighAmt=AccountEquity();
   if(AccountEquityHighAmt<PrevEquity)
      AccountEquityHighAmt=PrevEquity;
   else
      AccountEquityHighAmt=AccountEquity();
   PrevEquity=AccountEquity();
   return (AccountEquityHighAmt);
  }
//+------------------------------------------------------------------+
double CalculateProfit()
  {
   double Profit=0;
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         Print("Error");
      if(OrderSymbol()!=Symbol() || OrderMagicNumber()!=MagicNumber)
         continue;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         if(OrderType()==OP_BUY || OrderType()==OP_SELL)
            Profit+=OrderProfit();
     }
   return (Profit);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseThisSymbolAll()
  {
   double CurrentPairProfit=CalculateProfit();
   for(int trade=OrdersTotal()-1; trade>=0; trade--)
     {
      if(!OrderSelect(trade,SELECT_BY_POS,MODE_TRADES))
         Print("Error");
      if(OrderSymbol()==Symbol())
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType() == OP_BUY)
               if(!OrderClose(OrderTicket(), OrderLots(), Bid, 3, Blue))
                  Print("Error");
            if(OrderType() == OP_SELL)
               if(!OrderClose(OrderTicket(), OrderLots(), Ask, 3, Red))
                  Print("Error");
           }
         Sleep(1000);
         if(UseEquityStop)
           {
            if(CurrentPairProfit>0.0 && MathAbs(CurrentPairProfit)>TotalEquityRisk/100.0*AccountEquityHigh())
              {
               return;

              }
           }

        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Calculate optimal lot size buy                                   |
//+------------------------------------------------------------------+
double LotsOptimized(double llots)
  {
   double lot=llots;
   int    orders=OrdersHistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//--- calcuulate number of losses orders without a break
   if(IncreaseFactor>0)
     {
      for(int i=orders-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("Error in history!");
            break;
           }
         if(OrderSymbol()!=Symbol())
            continue;
         //---
         if(OrderProfit()>0)
            break;
         if(OrderProfit()<0)
            losses++;
        }
      if(losses>1)
         // lot=NormalizeDouble(lot+lot*losses/IncreaseFactor,1);
         lot=AccountFreeMargin()*IncreaseFactor/1000.0;
     }
//--- minimal allowed volume for trade operations
   double minlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(lot<minlot)
     {
      lot=minlot;
      Print("Volume is less than the minimal allowed ,we use",minlot);
     }
// lot=minlot;

//--- maximal allowed volume of trade operations
   double maxlot=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(lot>maxlot)
     {
      lot=maxlot;
      Print("Volume is greater than the maximal allowed,we use",maxlot);
     }
// lot=maxlot;

//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);
   int ratio=(int)MathRound(lot/volume_step);
   if(MathAbs(ratio*volume_step-lot)>0.0000001)
     {
      lot=ratio*volume_step;

      Print("Volume is not a multiple of the minimal step ,we use the closest correct volume ",ratio*volume_step);
     }
   return(lot);

  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+