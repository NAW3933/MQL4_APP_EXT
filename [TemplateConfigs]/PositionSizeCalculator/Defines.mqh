//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//| 				                 Copyright © 2012-2019, EarnForex.com |
//|                                     Based on panel by qubbit.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include <Controls\Button.mqh>
#include <Controls\Dialog.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Label.mqh>

#define CONTROLS_EDIT_COLOR_ENABLE  C'255,255,255' 
#define CONTROLS_EDIT_COLOR_DISABLE C'221,221,211'

#define CONTROLS_BUTTON_COLOR_ENABLE  C'200,200,200' 
#define CONTROLS_BUTTON_COLOR_DISABLE C'224,224,224'

enum ENTRY_TYPE
{
   Instant,
   Pending
};

enum ACCOUNT_BUTTON
{
   Balance,
   Equity,
   Balance_minus_Risk
};

enum TABS
{
	MainTab,
	RiskTab,
	MarginTab,
	SwapsTab,
	ScriptTab
};

enum TRADE_TYPE
{
   Buy,
   Sell
};


struct Settings
{
   ENTRY_TYPE EntryType;
   double EntryLevel;
   double StopLossLevel;
   double TakeProfitLevel;
   double Risk;
   double MoneyRisk;
   double CommissionPerLot;
   bool UseMoneyInsteadOfPercentage;
	bool RiskFromPositionSize;
	double PositionSize; // Used only when RiskFromPositionSize == true.
   ACCOUNT_BUTTON AccountButton;
   bool DeleteLines;
   bool CountPendingOrders;
   bool IgnoreOrdersWithoutStopLoss;
   bool HideAccSize;
   bool HideSecondRisk;
   bool ShowLines;
	TABS SelectedTab;
	int CustomLeverage;
	int MagicNumber;
	string ScriptCommentary;
	bool DisableTradingWhenLinesAreHidden;
	int MaxSlippage;
	int MaxSpread;
	int MaxEntrySLDistance;
	int MinEntrySLDistance;
	double MaxPositionSize;
	// For SL/TP distance modes:
	int StopLoss;
	int TakeProfit;
	// Only for SL distance mode:
	TRADE_TYPE TradeType;
	// For script only:
	bool SubtractPositions;
	bool SubtractPendingOrders;
	// For ATR:
	int ATRPeriod;
	double ATRMultiplierSL;
	double ATRMultiplierTP;
} sets;