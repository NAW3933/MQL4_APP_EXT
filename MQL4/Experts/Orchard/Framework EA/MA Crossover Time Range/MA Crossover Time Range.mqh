/*

   MA Crossover Time Range.mqh

   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com

	Description: 
	Trades on MA cross if within the specified time range
	Uses: framework_2.03 minimum
	
*/

//
//	This is where we pull in the framework
//
#include <Orchard/Frameworks/Framework.mqh>

//
//	Input Section
//
//Fast Movin Average
input int InpFastPeriods                     =10; //Fast periods
input ENUM_MA_METHOD InpFastMethod           =MODE_SMA;  //Fast method
input ENUM_APPLIED_PRICE InpFastAppliedPrice =PRICE_CLOSE; //Fast price

//Slow moving average
input int InpSlowPeriods                     =20; //Slow periods
input ENUM_MA_METHOD InpSlowMethod           =MODE_SMA;  //Slow method
input ENUM_APPLIED_PRICE InpSlowAppliedPrice =PRICE_CLOSE; //Slow price

//Time range, for example just ask for start and finish hour and minute
//These will be inclusive,
//14.25-14:30 will trade when time is >=14.25 and <=14:30
//If start and end are the same then tre is no restriction
input int InpStartHour                      =0;  //Start Hour (0-23)
input int InpStartMinute                    =0;  //Start Minute (0-59)
input int InpEndHour                        =0;
input int InpEndMinute                      =0;
                 


//
//	Some standard inputs,
//		remember to change the default magic for each EA
//
input	double	InpVolume		=	0.01;			//	Default order size
input	string	InpComment		=	__FILE__;	//	Default trade comment
input	int		InpMagicNumber	=	20202022;	//	Magic Number

//
//	Declare the expert, use the child class name
//	If the base class does everything needed then it's OK to
//		just use CExpertBase
//	Declare the name CExpert as the actual class name.
//		This allows other files to just refer to CExpert
//
#define	CExpert	CExpertBase
CExpert		*Expert;

//
//	Indicators - use the child class name instead of CIndicatorBase
//	Remove if not needed
//
CIndicatorMA	*IndicatorFast;
CIndicatorMA   *IndicatorSlow;

//
//	Signals - use the child class name instead of CSignalBase
//	Remove if not needed
//
CSignalCrossover *SignalCrossOver;
CSignalTimeRange *SignalTimeRange;
//
//	TPSL - use child class names instead of CTPSLBase
//	Remove if not needed
//
//CTPSLBase	*TPObject;
//CTPSLBase	*SLObject;

//
//	Indicators for TPSL - use child class names instead of CIndicatorBase
//	Remove if not needed
//
//CIndicatorBase	*IndicatorTPSL1;
//CIndicatorBase	*IndicatorTPSL2;

int OnInit() {

	//
	//	Instantiate the expert
	//		Uses the declared class name
	//
	Expert	=	new CExpert();

	//
	//	Assign the default values to the expert
	//
	Expert.SetVolume(InpVolume);
	Expert.SetTradeComment(InpComment);
	Expert.SetMagic(InpMagicNumber);
	
	//
	//	Create the indicators - using your child class name
	//
	//Indicator1	=	new CIndicatorBase();
	IndicatorFast  = new CIndicatorMA(InpFastPeriods,0,InpFastMethod, InpFastAppliedPrice);
	IndicatorSlow  = new CIndicatorMA(InpSlowPeriods,0,InpSlowMethod, InpSlowAppliedPrice);

	//
	//	Set up the signals - using your child class names
	//
	SignalCrossOver = new CSignalCrossover();
	SignalCrossOver.AddIndicator(IndicatorFast,0);
	SignalCrossOver.AddIndicator(IndicatorSlow,0);
	
	//The time range signal
	SignalTimeRange = new CSignalTimeRange(InpStartHour, InpStartMinute, InpEndHour, InpEndMinute);
	
	//	Add the signals to the expert
	//
	Expert.AddEntrySignal(SignalCrossOver);	//	repeat for more signals
	Expert.AddEntrySignal(SignalTimeRange);
	Expert.AddExitSignal(SignalCrossOver);
	

	//
	//	If using fixed tp and sl set them here in points
	//
	//Expert.SetTakeProfitValue(0);
	//Expert.SetStopLossValue(0);
		
	//
	//	Set up the Take Profit and Stop Loss objects
	//	Remember to create child class names, not base
	//
	//TPObject			=	new CTPSLBase();	//	Create the object
	//IndicatorTPSL1	=	new CIndicatorBase();	//	Create an indicator for the tp object
	//TPObject.AddIndicator(IndicatorTPSL1, 0);	//	Add the indicator to tp
	//	Set any other properties needed

	//	And for the SL object
	//SLObject			=	new CTPSLBase();
	//IndicatorTPSL2	=	new CIndicatorBase();
	//SLObject.AddIndicator(IndicatorTPSL2, 0);

	//Expert.SetTakeProfitObj(TPObject);
	//Expert.SetStopLossObj(SLObject);

	//
	// Finish expert initialisation and check result
	//
	int	result	=	Expert.OnInit();
	
   return(result);

}

void OnDeinit(const int reason) {

   EventKillTimer();
	
	//	Delete all objects created
	delete	Expert;
	//delete	ExitSignal;
	//delete	EntrySignal;
	//delete	Indicator1;
	//delete	TPObject;
	//delete	SLObject;
	//delete	IndicatorTPSL1;
	//delete	IndicatorTPSL2;
	delete SignalCrossOver;
	delete SignalTimeRange;
	delete IndicatorFast;
	delete IndicatorSlow;

	return;
	
}

void OnTick() {

	Expert.OnTick();
	return;
	
}

void OnTimer() {

	Expert.OnTimer();
	return;

}

double OnTester() {

	return(Expert.OnTester());

}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {

	Expert.OnChartEvent(id, lparam, dparam, sparam);
	return;
	
}

