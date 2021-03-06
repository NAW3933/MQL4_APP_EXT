//+------------------------------------------------------------------+
//|                                TG-Money-Management-Indicator.mq4 |
//|                                         Copyright 2019. ThilinaG |
//|                                                @author ThilinaG  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, ThilinaG"
#property link      "TG-Money-Management-Indicator"
#property version   "2.00"
#property strict


#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1  clrNONE
#property indicator_color2  clrNONE
#property indicator_color3  clrNONE

enum EnumRiskMoney
{
   Account_Balance,      // AccountBalance
   Account_Equity,       // AccountEquity
   Account_FreeMargin    // AccountFreeMargin
};

enum EnumRiskMethod
{
   ATR,        // ATR stoploss
   Fixed       // Fixed stoploss
};

extern double    Risk_Fraction = 0.01;                         // Risk fraction ,ex: 0.01 = 1%
extern EnumRiskMoney Risk_Money = Account_Balance;             // Account's money to risk
extern EnumRiskMethod Risk_Method = ATR;                       // Method to calculate stoploss
extern int       ATR_Length = 14;                              // ATR length if ATR stoploss
extern double    ATR_SL_Multiplier = 1.5;                      // ATR multiplier if ATR stoploss 
extern int       Fixed_SL_Points = 1000;                       // Size in points if Fixed stoploss
int       Bar_History_Count = 500;                      
int       Display_Corner = 2;

double   buffer_atrPoints[];
double   buffer_stoplossPoints[];
double   buffer_lotsize[];

int init() {

   SetIndexBuffer(0,buffer_atrPoints); SetIndexLabel(0,"buffer_atrPoints"); SetIndexStyle(0,DRAW_NONE); SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexBuffer(1,buffer_stoplossPoints); SetIndexLabel(1,"buffer_stoplossPoints"); SetIndexStyle(1,DRAW_NONE); SetIndexEmptyValue(1,EMPTY_VALUE);
   SetIndexBuffer(2,buffer_lotsize); SetIndexLabel(2,"buffer_lotsize"); SetIndexStyle(2,DRAW_NONE); SetIndexEmptyValue(2,EMPTY_VALUE);

   IndicatorShortName(WindowExpertName());
   
   return(0);
}

int deinit() {
   
   ObjectDelete(ChartID(), "@MM-ATR");
   ObjectDelete(ChartID(), "@MM-LotText");
   ObjectDelete(ChartID(), "@MM-LotSize");
   return(0);
}

int start() {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit = MathMin(Bars-counted_bars+Bar_History_Count,Bars-1);

   double atr,lotsize;
   int atrPoints, slPoints;
   
   for(int i=limit; i>=0; i--) {
     atr = iATR(NULL,0,ATR_Length,i+1);
     atrPoints = (int)(atr * MathPow(10,MarketInfo(Symbol(),MODE_DIGITS)));
     
     if(Risk_Method == ATR) {
         slPoints = (int)MathCeil(ATR_SL_Multiplier*atrPoints);
         slPoints = slPoints > 0 ? slPoints : Fixed_SL_Points;
     } else {
         slPoints = Fixed_SL_Points;
     }
     
     lotsize = CalculateLotSize(Symbol(),Risk_Fraction, slPoints, 0, 10);

     buffer_atrPoints[i]=StrToDouble(DoubleToStr(atrPoints,0));
     buffer_stoplossPoints[i]=StrToDouble(DoubleToStr(slPoints,0));
     buffer_lotsize[i]=StrToDouble(DoubleToStr(lotsize,2));;
   }

   if(Risk_Method == ATR) {
      DisplayText("@MM-ATR",StringConcatenate("ATR (",ATR_Length,"): ",buffer_atrPoints[0]," points"),clrGold,30,35,Display_Corner);
   }

   DisplayText("@MM-LotText",StringConcatenate("Allow Lots per Trade (Risk ",DoubleToStr((Risk_Fraction*100),0),"% , SL ",buffer_stoplossPoints[0]," points) :"),clrGold,30,10,Display_Corner);
   DisplayText("@MM-LotSize",StringConcatenate(buffer_lotsize[0]),clrAqua,580,10,Display_Corner);

   return(0);
}

double Multiplicator(string currencyPairAppendix="")
{
	double _multiplicator = 1.0;
	
	if ( AccountCurrency() == "USD" )
		return ( _multiplicator );
   if ( AccountCurrency() == "EUR" ) 
		_multiplicator = 1.0 / MarketInfo ( "EURUSD" + currencyPairAppendix, MODE_BID );
   if ( AccountCurrency() == "GBP" ) 
		_multiplicator = 1.0 / MarketInfo ( "GBPUSD" + currencyPairAppendix, MODE_BID );
   if ( AccountCurrency() == "AUD" ) 
		_multiplicator = 1.0 / MarketInfo ( "AUDUSD" + currencyPairAppendix, MODE_BID );		
   if ( AccountCurrency() == "NZD" ) 
		_multiplicator = 1.0 / MarketInfo ( "NZDUSD" + currencyPairAppendix, MODE_BID );		
   if ( AccountCurrency() == "CHF" ) 
		_multiplicator = MarketInfo ( "USDCHF" + currencyPairAppendix, MODE_BID );
   if ( AccountCurrency() == "JPY" ) 
		_multiplicator = MarketInfo ( "USDJPY" + currencyPairAppendix, MODE_BID );
   if ( AccountCurrency() == "CAD" ) 
		_multiplicator = MarketInfo ( "USDCAD" + currencyPairAppendix, MODE_BID );		
   if ( _multiplicator == 0 )
   	_multiplicator = 1.0; // If account currency is neither of EUR, GBP, AUD, NZD, CHF, JPY or CAD we assumes that it is USD
	return ( _multiplicator );
}


double CalculateLotSize(string argSymbol, double argRiskDecimal, int argStoplossPoints, int argExtraPriceGapPoints, double argAllowedMaxLotSize)
{
   // Calculate LotSize based on Equity, Risk in decimal and StopLoss in points
   double _availableMoney, _maxLotByEquity, _maxLot, _minLot, _lotSize1, _lotSize2, _lotSize;
	int _lotdigit = 2;
	   
   // Calculate margin required for 1 lot
   double _marginForOneLot = MarketInfo(argSymbol, MODE_MARGINREQUIRED); 
   // Step in lot size changing
   double _lotStep = MarketInfo(argSymbol, MODE_LOTSTEP); 
	// Amount of money in base currency for 1 lot
	double _lotBase = MarketInfo ( Symbol(), MODE_LOTSIZE );
	
	if ( _lotStep ==  1) 
		_lotdigit = 0;
	if ( _lotStep == 0.1 )	
		_lotdigit = 1;
   if ( _lotStep == 0.01 ) 
		_lotdigit = 2;

	// Get available money
	if(Risk_Money == Account_Balance) {
	   _availableMoney = AccountBalance();
	}else if(Risk_Money == Account_Equity) {
	   _availableMoney = AccountEquity();
	} else {
	   _availableMoney = AccountFreeMargin();
	}
	
	// Maximum allowed Lot by the broker according to Equity. And we don't use 100% but 98%
	_maxLotByEquity = MathFloor(_availableMoney * 0.98 / _marginForOneLot / _lotStep) * _lotStep;
	_maxLot = MathMin(_maxLotByEquity, MathMin(argAllowedMaxLotSize, MarketInfo(argSymbol, MODE_MAXLOT)));
	// Minimum allowed Lot by the broker
	_minLot = MarketInfo(argSymbol, MODE_MINLOT);
	// Lot according to Risk. 
	_lotSize1 = MathFloor ( argRiskDecimal * _availableMoney / ( argStoplossPoints + argExtraPriceGapPoints ) / _lotStep ) * _lotStep;
   _lotSize2 = _lotSize1 * Multiplicator(""); 
   _lotSize = MathMax(MathMin(_lotSize2, _maxLot), _minLot);
	_lotSize = NormalizeDouble (_lotSize, _lotdigit);

	return ( _lotSize );
}

void DisplayText(string objname,string objtext,int clr,int x,int y,int corner) {
   if(ObjectFind(objname)==-1) {
      ObjectCreate(objname,OBJ_LABEL,0,0,0);
      ObjectSet(objname,OBJPROP_CORNER,corner);
      ObjectSet(objname,OBJPROP_XDISTANCE,x);
      ObjectSet(objname,OBJPROP_YDISTANCE,y);
   }
   ObjectSetText(objname,objtext,18,"Arial",clr);
}

