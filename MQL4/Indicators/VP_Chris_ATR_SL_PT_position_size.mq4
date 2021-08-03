//----------------------------------------------------------------------------
//
// ATR, SL, PT and position size calculator - version 1.0
// Jaime Machado/Cris Alvarado 2016
// 
//----------------------------------------------------------------------------
//
// Calculates ATR (volatility) in pips and suggests SL and PT values in pips.
// SL and PT values are based on the volatility and user defined ATR 
// multipliers: higher volatility = larger SL and PT.
//
// The indicator will also suggest a position size based on the calculated 
// SL, the risk per trade defined and the available capital. 
// The Risk to Reward Rario is also printed.
//
// The ATR is calculated always on the same Time Frame which can be defined.
// The ATR value used is the greatest of 2 calculations with 2 different 
// periods. This allows for a fast reaction to increased volatility but not
// go below a long term baseline level. If desired, the same period can be 
// entered in both ATR and it would be equivalent to having a single ATR
// calculation.
//
//----------------------------------------------------------------------------


#property copyright 	"Copyright 2016, cristopher Alvarado"
#property link      	"https://www.facebook.com/Trading.Up.Down"
#property description 	"Shows the ATR (volatility) in pips and proposes PT, SL and position size based on the pair volatility. The ATR used is the greater of two calculations with 2 different periods. A position size is suggested based on the SL, Risk per Trade and available capital."

#property indicator_chart_window


enum ENUM_MONEY {
	Balance 	= 0,     	// Use Account Balance 
	Equity 		= 1,     	// Use Account Equity
};




input string			ATR_Settings			= "--------------------------------------------------";
input int				ATR1_period				= 14;			// Period of th first ATR
input int				ATR2_period				= 14;			// Period of the second ATR
input ENUM_TIMEFRAMES	ATR_TimeFrame			= PERIOD_D1;	// TimeFrame of the ATRs
input double			PT_ATR_multiplier		= 1;			// ATR multiplier to calculate PT
input double			SL_ATR_multiplier		= 1.5;			// ATR multiplier to calculate SL
input string			Money_Manag_Settings	= "--------------------------------------------------";
input double			Risk_per_Trade			= 2.0;			// Risk per trade in percentage
input ENUM_MONEY 		Money_Reference			= Balance;		// Balance or Equity as money reference
input string			Aesthetic_Settings		= "--------------------------------------------------";
input color				FieldColor				= White;		// Color of the fields
input color				ValueColor				= Red;		// Color of the values
input string			FontName				= "Verdana";	// Font name
input int				FontSize				= 14;			// Font size
input string			Position_Settings		= "--------------------------------------------------";
input int				Corner					= 0;			// Screen corner for placement
input int				X_Position				= 400;			// Screen X position
input int				Y_Position				= 0;			// Screen Y position




double 	digits;
double 	tick_size;
double 	pip_size;
double	tick_value;
double	pip_value;
double	RRR;
string 	id_string = "ATR_SL_PT_2";



//----------------------------------------------------------------------------
//  Custom indicator initialization function
//----------------------------------------------------------------------------
int init() {

	digits = MarketInfo(Symbol(), MODE_DIGITS);
	tick_size = MarketInfo(Symbol(), MODE_TICKSIZE); 
	tick_value = MarketInfo(Symbol(), MODE_TICKVALUE); 
	
	// calculate the Risk to Reward Ratio
	RRR = PT_ATR_multiplier / SL_ATR_multiplier;

	// calculate the pip size and pip value in 4 digits format
	if (digits == 3 || digits == 5) {
		pip_size = tick_size * 10;
		pip_value = tick_value * 10;
	} else {
		pip_size = tick_size;
		pip_value = tick_value;
	}
	
	return(0);
}
  
  
  
  
//----------------------------------------------------------------------------
//  Custom indicator deinitialization function
//----------------------------------------------------------------------------
int deinit() {

	// delets all objects created by this indicator
	delete_objects(id_string);

	return(0);
}
  
  
  
  
  
//----------------------------------------------------------------------------
// Custom indicator iteration function
//----------------------------------------------------------------------------
int start() {
	static bool FirstTick = true;
	double money;
	
	double ATR_pips = MathMax(iATR(NULL, ATR_TimeFrame, ATR1_period, 0), iATR(NULL, ATR_TimeFrame, ATR2_period, 0)) / pip_size; 
	double PT_pips = ATR_pips * PT_ATR_multiplier;
	double SL_pips = ATR_pips * SL_ATR_multiplier;
	
	// obtains the capital available
	if (Money_Reference == Balance)
		money = AccountInfoDouble(ACCOUNT_BALANCE);
	else if (Money_Reference == Equity)
		money = AccountInfoDouble(ACCOUNT_EQUITY);
	
	// calculates the lot size based on risk per trade, capital, SL and pip value
	double lots = (Risk_per_Trade * money /100.0) / (SL_pips * pip_value);
	
	
 	// if on first tick, draw field text
	if (FirstTick) {
		deinit();
		FirstTick = false;
		
		Display("ATR_SL_PT_2_PT", X_Position + 0, Y_Position);
		ObjectSetText("ATR_SL_PT_2_PT", "PT " , FontSize, FontName, FieldColor);
		Display("ATR_SL_PT_2_PTv", X_Position + 30, Y_Position);
		
		Display("ATR_SL_PT_2_SL", X_Position + 90, Y_Position);
		ObjectSetText("ATR_SL_PT_2_SL", "SL " , FontSize, FontName, FieldColor);
		Display("ATR_SL_PT_2_SLv", X_Position + 120, Y_Position);
		
		Display("ATR_SL_PT_2_ATR", X_Position + 180, Y_Position);
		ObjectSetText("ATR_SL_PT_2_ATR", "ATR " , FontSize, FontName, FieldColor);
		Display("ATR_SL_PT_2_ATRv", X_Position + 220, Y_Position);
		
		Display("ATR_SL_PT_2_RRR", X_Position + 280, Y_Position);
		ObjectSetText("ATR_SL_PT_2_RRR", "RRR " , FontSize, FontName, FieldColor);
		Display("ATR_SL_PT_2_RRRv", X_Position + 320, Y_Position);

		Display("ATR_SL_PT_2_Risk", X_Position + 390, Y_Position);
		ObjectSetText("ATR_SL_PT_2_Risk", "Risk " , FontSize, FontName, FieldColor);
		Display("ATR_SL_PT_2_Riskv", X_Position + 430, Y_Position);
		
		Display("ATR_SL_PT_2_Lots", X_Position + 480, Y_Position);
		ObjectSetText("ATR_SL_PT_2_Lots", "Lots " , FontSize, FontName, FieldColor);
		Display("ATR_SL_PT_2_Lotsv", X_Position + 520, Y_Position);
   }
   
	// update values
	ObjectSetText("ATR_SL_PT_2_ATRv", DoubleToStr(ATR_pips,1), FontSize, FontName, ValueColor);
	ObjectSetText("ATR_SL_PT_2_PTv", DoubleToStr(PT_pips,1), FontSize, FontName, ValueColor);
	ObjectSetText("ATR_SL_PT_2_SLv", DoubleToStr(SL_pips,1), FontSize, FontName, ValueColor);
	ObjectSetText("ATR_SL_PT_2_RRRv", "1/" + DoubleToStr(RRR,2), FontSize, FontName, ValueColor);
	ObjectSetText("ATR_SL_PT_2_Riskv", DoubleToStr(Risk_per_Trade,1), FontSize, FontName, ValueColor);
	ObjectSetText("ATR_SL_PT_2_Lotsv", DoubleToStr(lots,2), FontSize, FontName, ValueColor);

   return(0);
 }
 
 
 
 
 
 
//----------------------------------------------------------------------------
// Create object
//----------------------------------------------------------------------------
void Display(string name, int x, int y) {
	
	ObjectCreate(name, OBJ_LABEL, 0, 0, 0);
	ObjectSet(name, OBJPROP_CORNER, Corner);
	ObjectSet(name, OBJPROP_XDISTANCE, x);
	ObjectSet(name, OBJPROP_YDISTANCE, y);
	ObjectSet(name, OBJPROP_BACK, FALSE);
}




//----------------------------------------------------------------------------
// Delete Objects whose id string starts with the specified string
//----------------------------------------------------------------------------
void delete_objects(string id) {
	int k = 0;
	while (k < ObjectsTotal()) {
		string objname = ObjectName(k);
		if (StringSubstr(objname, 0, StringLen(id)) == id)
			ObjectDelete(objname);
		else
			k++;
	}    
}