//+------------------------------------------------------------------+
//|                                       PositionSizeCalculator.mq4 |
//| 				                 Copyright © 2012-2019, EarnForex.com |
//|                                     Based on panel by qubbit.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
//#property copyright "EarnForex.com"
#property copyright "Muckin around"
#property link      "https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/"
#property version   "2.21"
string    Version = "2.21";
#property strict
#property indicator_chart_window
#property indicator_plots 0

#property description "Calculates position size based on account balance/equity,"
#property description "currency, currency pair, given entry level, stop-loss level,"
#property description "and risk tolerance (set either in percentage points or in base currency)."
#property description "Displays reward/risk ratio based on take-profit."
#property description "Shows total portfolio risk based on open trades and pending orders."
#property description "Calculates margin required for new position, allows custom leverage.\r\n"
#property description "WARNING: There is no guarantee that the output of this indicator is correct. Use at your own risk."

#include "PositionSizeCalculator.mqh";

// Default values for settings:
double EntryLevel = 0;
double StopLossLevel = 0;
double TakeProfitLevel = 0;
double MoneyRisk = 0;
bool CountPendingOrders = false;
bool IgnoreOrdersWithoutStopLoss = false;
bool HideSecondRisk = false;
bool ShowLines = true;
int MagicNumber = 0;
bool DisableTradingWhenLinesAreHidden = false;
int MaxSlippage = 0;
int MaxSpread = 0;
int MaxEntrySLDistance = 0;
int MinEntrySLDistance = 0;
double MaxPositionSize = 0;
string Caption = "";

input bool ShowLineLabels = true; // ShowLineLabels: Show pip distance for TP/SL near lines?
input bool DrawTextAsBackground = false; // DrawTextAsBackground: Draw label objects as background?
input bool PanelOnTopOfChart = true; // PanelOnTopOfChart: Draw chart as background?
input bool HideAccSize = false; // HideAccSize: Hide account size?
input bool ShowPipValue = false; // ShowPipValue: Show pip value?
input color sl_label_font_color = clrLime; // SL Label  Color
input color tp_label_font_color = clrSandyBrown; // TP Label Font Color
input uint font_size = 13; // Labels Font Size
input string font_face = "Courier"; // Labels Font Face
input color entry_line_color = clrBlue; // Entry Line Color
input color stoploss_line_color = clrLime; // Stop-Loss Line Color
input color takeprofit_line_color = clrSandyBrown; // Take-Profit Line Color
input ENUM_LINE_STYLE entry_line_style = STYLE_SOLID; // Entry Line Style
input ENUM_LINE_STYLE stoploss_line_style = STYLE_SOLID; // Stop-Loss Line Style
input ENUM_LINE_STYLE takeprofit_line_style = STYLE_SOLID; // Take-Profit Line Style
input uint entry_line_width = 1; // Entry Line Width
input uint stoploss_line_width = 1; // Stop-Loss Line Width
input uint takeprofit_line_width = 1; // Take-Profit Line Width
input double Risk = 1; // Risk: Initial risk tolerance in percentage points
input ENTRY_TYPE EntryType = Instant; // EntryType: Instant or Pending.
input double Commission = 0; // Commission: Default one-way commission size.
input string Commentary = ""; // Commentary: Default order comment.
input int DefaultSL = 0; // DefaultSL: Deafault stop-loss value, in broker's pips.
input int DefaultTP = 0; // DefaultTP: Deafault take-profit value, in broker's pips.
input double TP_Multiplier = 1; // TP Multiplier for SL value, appears in Take-profit button.
input bool ShowSpread = false; // ShowSpread: If true, shows current spread in window caption.
input double AdditionalFunds = 0; // AdditionalFunds: Added to account balance for risk calculation.
input bool UseFixedSLDistance = false; // UseFixedSLDistance: SL distance in points instead of a level.
input bool UseFixedTPDistance = false; // UseFixedTPDistance: TP distance in points instead of a level.
input bool ShowATROptions = true; // ShowATROptions: If true, SL and TP can be set via ATR.

QCPositionSizeCalculator ExtDialog;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
	// Prevent attachment of second panel if it is not a timeframe/parameters change.
	if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Flag") > 0) GlobalVariableDel("PSC-" + IntegerToString(ChartID()) + "-Flag");
	else
	{
		int indicators_total = ChartIndicatorsTotal(0, 0);
		for (int i = 0; i < indicators_total; i++)
		{
         if (ChartIndicatorName(0, 0, i) == "Position Size Calculator" + IntegerToString(ChartID()))
			{
				Print("Position Size Calculator is already attached.");
				return(INIT_FAILED);
			}
		}
	}
	
   IndicatorSetString(INDICATOR_SHORTNAME, "Position Size Calculator" + IntegerToString(ChartID()));
   Caption = "Position Size Calculator (ver. " + Version + ")";

   if (!ExtDialog.LoadSettingsFromDisk())
   {
      sets.EntryType = EntryType; // If Instant, Entry level will be updated to current Ask/Bid price automatically; if Pending, Entry level will remain intact and StopLevel warning will be issued if needed.
      sets.EntryLevel = EntryLevel;
      sets.StopLossLevel = StopLossLevel;
      sets.TakeProfitLevel = TakeProfitLevel; // Optional
      sets.Risk = Risk; // Risk tolerance in percentage points
      sets.MoneyRisk = MoneyRisk; // Risk tolerance in account currency
      sets.CommissionPerLot = Commission; // Commission charged per lot (one side) in account currency.
      sets.UseMoneyInsteadOfPercentage = false;
      sets.RiskFromPositionSize = false;
      sets.AccountButton = Balance;
      sets.CountPendingOrders = CountPendingOrders; // If true, portfolio risk calculation will also involve pending orders.
      sets.IgnoreOrdersWithoutStopLoss = IgnoreOrdersWithoutStopLoss; // If true, portfolio risk calculation will skip orders without stop-loss.
      sets.HideAccSize = HideAccSize; // If true, account size line will not be shown.
      sets.HideSecondRisk = HideSecondRisk; // If true, second risk line will not be shown.
      sets.ShowLines = ShowLines;
      sets.SelectedTab = MainTab;
      sets.MagicNumber = MagicNumber;
      sets.ScriptCommentary = Commentary;
      sets.DisableTradingWhenLinesAreHidden = DisableTradingWhenLinesAreHidden;
      sets.MaxSlippage = MaxSlippage;
      sets.MaxSpread = MaxSpread;
      sets.MaxEntrySLDistance = MaxEntrySLDistance;
      sets.MinEntrySLDistance = MinEntrySLDistance;
      sets.MaxPositionSize = MaxPositionSize;
      sets.StopLoss = 0;
      sets.TakeProfit = 0;
      sets.TradeType = Buy;
      sets.SubtractPendingOrders = false;
      sets.SubtractPositions = false;
      sets.ATRPeriod = 14;
      sets.ATRMultiplierSL = 0;
      sets.ATRMultiplierTP = 0;
   }

   if (!ExtDialog.Create(0, Caption, 0, 20, 20)) return(-1);
   ExtDialog.IniFileLoad();
   ExtDialog.Run();

   Initialization();
   
   // Brings panel on top of other objects without actual maximization of the panel.
   ExtDialog.HideShowMaximize(false);

   EventSetTimer(1);
   
   return(INIT_SUCCEEDED);
}
  
void OnDeinit(const int reason)
{
   // If we tried to add a second indicator, do not delete objects.
   if (reason == REASON_INITFAILED) return;
	
	ObjectDelete("StopLossLabel");
	ObjectDelete("TakeProfitLabel");
   if (reason == REASON_REMOVE)
   {
      ExtDialog.DeleteSettingsFile();
      ObjectDelete("EntryLine");
      ObjectDelete("StopLossLine");
      ObjectDelete("TakeProfitLine");
      if (!FileDelete(ExtDialog.IniFileName() + ExtDialog.IniFileExt())) Print("Failed to delete PSC panel's .ini file: ", GetLastError());
   }  
   else
   {
      // It is deinitialization due to input parameters change - save current parameters values (that are also changed via panel) to global variables.
      if (reason == REASON_PARAMETERS) GlobalVariableSet("PSC-" + IntegerToString(ChartID()) + "-Parameters", 1);

   	ExtDialog.SaveSettingsOnDisk();
   	// Set temporary global variable, so that the indicator knows it is reinitializing because of timeframe/parameters change and should not prevent attachment.
   	if ((reason == REASON_CHARTCHANGE) || (reason == REASON_PARAMETERS) || (reason == REASON_RECOMPILE)) GlobalVariableSet("PSC-" + IntegerToString(ChartID()) + "-Flag", 1);
   }
   
   ExtDialog.Destroy(reason);

   EventKillTimer();
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
   ExtDialog.RefreshValues();
	return(rates_total);
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   // Remember the panel's location to have the same location for minimized and maximized states.
   if ((id == CHARTEVENT_CUSTOM + ON_DRAG_END) && (lparam == -1))
   {
      ExtDialog.remember_top = ExtDialog.Top();
      ExtDialog.remember_left = ExtDialog.Left();
   }

	// Call Panel's event handler only if it is not a CHARTEVENT_CHART_CHANGE - workaround for minimization bug on chart switch.
   if (id != CHARTEVENT_CHART_CHANGE) ExtDialog.OnEvent(id, lparam, dparam, sparam);

   // Recalculate on chart changes, clicks, and certain object dragging.
   if ((id == CHARTEVENT_CLICK) || (id == CHARTEVENT_CHART_CHANGE) ||
   ((id == CHARTEVENT_OBJECT_DRAG) && ((sparam == "EntryLine") || (sparam == "StopLossLine") || (sparam == "TakeProfitLine"))))
   {
      if (id != CHARTEVENT_CHART_CHANGE) ExtDialog.RefreshValues();
      if (ExtDialog.Top() < 0) ExtDialog.Move(ExtDialog.Left(), 0);
      int chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
      if (ExtDialog.Top() > chart_height) ExtDialog.Move(ExtDialog.Left(), chart_height - ExtDialog.Height());
      int chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
      if (ExtDialog.Left() > chart_width) ExtDialog.Move(chart_width - ExtDialog.Width(), ExtDialog.Top());
      ChartRedraw();
   }
}

//+------------------------------------------------------------------+
//| Trade event handler                                              |
//+------------------------------------------------------------------+
void OnTrade()
{
   ExtDialog.RefreshValues();
   ChartRedraw();   
}

//+------------------------------------------------------------------+
//| Timer event handler                                              |
//+------------------------------------------------------------------+
void OnTimer()
{
   ExtDialog.RefreshValues();
   ChartRedraw();   
}
//+------------------------------------------------------------------+