//+------------------------------------------------------------------+
//|                                       PositionSizeCalculator.mqh |
//| 				                 Copyright © 2012-2019, EarnForex.com |
//|                                     Based on panel by qubbit.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include "Defines.mqh"

class QCPositionSizeCalculator : public CAppDialog
{
private:
   CButton           m_BtnTabMain, m_BtnTabRisk, m_BtnTabMargin, m_BtnTabSwaps, m_BtnTabScript, m_BtnOrderType, m_BtnAccount, m_BtnLines, m_BtnShowRisk, m_BtnShowMargin, m_BtnTakeProfit, m_BtnEntry;
   CCheckBox         m_ChkCountPendings, m_ChkIgnoreOrders, m_ChkDisableTradingWhenLinesAreHidden, m_ChkSubtractPositions, m_ChkSubtractPendingOrders;
   CEdit 		      m_EdtEntryLevel, m_EdtSL, m_EdtTP, m_EdtAccount, m_EdtCommissionSize, m_EdtRiskPIn, m_EdtRiskPRes, m_EdtRiskMIn, m_EdtRiskMRes, m_EdtReward1, m_EdtReward2, m_EdtRR1, m_EdtRR2, m_EdtPosSize, m_EdtPipValue, m_EdtATRPeriod, m_EdtATRMultiplierSL, m_EdtATRMultiplierTP, m_EdtCurRiskM, m_EdtCurRiskP, m_EdtPotRiskM, m_EdtPotRiskP, m_EdtCurProfitM, m_EdtCurProfitP, m_EdtPotProfitM, m_EdtPotProfitP, m_EdtCurL, m_EdtPotL, m_EdtPosMargin, m_EdtUsedMargin, m_EdtFreeMargin, m_EdtCustomLeverage, m_EdtMaxPositionSizeByMargin, m_EdtSwapsType, m_EdtSwapsTripleDay, m_EdtSwapsNominalLong, m_EdtSwapsNominalShort, m_EdtSwapsDailyLongLot, m_EdtSwapsDailyShortLot, m_EdtSwapsDailyLongPS, m_EdtSwapsDailyShortPS, m_EdtSwapsYearlyLongLot, m_EdtSwapsYearlyShortLot, m_EdtSwapsYearlyLongPS, m_EdtSwapsYearlyShortPS, m_EdtMagicNumber, m_EdtScriptCommentary, m_EdtMaxSlippage, m_EdtMaxSpread, m_EdtMaxEntrySLDistance, m_EdtMinEntrySLDistance, m_EdtMaxPositionSize;
   CLabel  		      m_LblEntryLevel, m_LblEntryWarning, m_LblSL, m_LblSLWarning, m_LblTPWarning, m_LblOrderType, m_LblCommissionSize, m_LblAdditionalFundsAsterisk, m_LblInput, m_LblResult, m_LblRisk, m_LblRiskM, m_LblReward, m_LblRR, m_LblPosSize, m_LblPipValue, m_LblATRPeriod, m_LblATRMultiplierSL, m_LblATRMultiplierTP, m_LblATRValue, m_LblCurrentRiskMoney, m_LblCurrentRiskPerc, m_LblCurrentProfitMoney, m_LblCurrentProfitPerc, m_LblPotentialRiskMoney, m_LblPotentialRiskPerc, m_LblPotentialProfitMoney, m_LblPotentialProfitPerc, m_LblCurrentLots, m_LblPotentialLots, m_LblCurrentPortfolio, m_LblPotentialPortfolio, m_LblPosMargin, m_LblUsedMargin, m_LblFreeMargin, m_LblCustomLeverage, m_LblAccLeverage, m_LblSymbolLeverage, m_LblMaxPositionSizeByMargin, m_LblSwapsType, m_LblSwapsTripleDay, m_LblSwapsLong, m_LblSwapsShort, m_LblSwapsNominal, m_LblSwapsDaily, m_LblSwapsYearly, m_LblSwapsPerLotDaily, m_LblSwapsPerPSDaily, m_LblSwapsPerLotYearly, m_LblSwapsPerPSYearly, m_LblMagicNumber, m_LblScriptCommentary, m_LblScriptExplanation, m_LblScriptPips, m_LblMaxSlippage, m_LblMaxSpread, m_LblMaxEntrySLDistance, m_LblMinEntrySLDistance, m_LblScriptLots, m_LblMaxPositionSize, m_LblURL;
   string            m_FileName;
   double				m_DPIScale;
   bool              NoPanelMaximization; // Crutch variable to prevent panel maximization when Maximize() is called at the indicator's initialization.
 
public:
                     QCPositionSizeCalculator(void);
                    ~QCPositionSizeCalculator(void) {};
        
   virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1);
   virtual bool      OnEvent(const int id, const long& lparam, const double& dparam, const string& sparam);   
	// Gets values from lines, recalculates position size, and updates values in the panel.
   virtual bool      RefreshValues();  
   virtual bool      SaveSettingsOnDisk();
   virtual bool      LoadSettingsFromDisk();
   virtual bool      DeleteSettingsFile();
   virtual bool		Run() {SeekAndDestroyDuplicatePanels(); return(CAppDialog::Run());}
   virtual void		HideShowMaximize(bool max);
   string            IniFileName(void) const;
   
   // Remember the panel's location to have the same location for minimized and maximized states.
           int       remember_top, remember_left;

private:     

   virtual void		ShowMain();
   virtual void		ShowRisk();
   virtual void		ShowMargin();
   virtual void		ShowSwaps();
   virtual void		ShowScript();
   virtual void		HideMain();
   virtual void		HideRisk();
   virtual void		HideMargin();
   virtual void		HideSwaps();
   virtual void		HideScript();

   virtual bool      CreateObjects();
   virtual bool      InitObjects();
   // Arranges panel objects on the panel.
   virtual void      MoveAndResize();
   virtual bool      DisplayValues();
   virtual void		SeekAndDestroyDuplicatePanels();

   virtual bool      ButtonCreate    (CButton&    Btn, int X1, int Y1, int X2, int Y2, string Name, string Text);
   virtual bool      CheckBoxCreate  (CCheckBox&  Chk, int X1, int Y1, int X2, int Y2, string Name, string Text);
   virtual bool      EditCreate      (CEdit&      Edt, int X1, int Y1, int X2, int Y2, string Name, string Text);
   virtual bool      LabelCreate     (CLabel&     Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text);
   virtual void      Maximize();
   virtual void      Minimize();

	// Event handlers
   void OnEndEditEdtEntryLevel();
   void OnEndEditEdtSL();
   void OnEndEditEdtTP();
   void OnClickBtnOrderType();
   void OnClickBtnLines();
   void OnClickBtnAccount();
   void OnEndEditEdtCommissionSize();
   void OnEndEditEdtRiskPIn();
   void OnEndEditEdtRiskMIn();
   void OnEndEditEdtPosSize();
   void OnEndEditATRPeriod();
   void OnEndEditATRMultiplierSL();
   void OnEndEditATRMultiplierTP();
   void OnChangeChkCountPendings();
   void OnChangeChkIgnoreOrders();
   void OnEndEditEdtCustomLeverage();
   void OnEndEditEdtMagicNumber();
   void OnEndEditEdtScriptCommentary();
   void OnChangeChkDisableTradingWhenLinesAreHidden();
   void OnEndEditEdtMaxSlippage();
   void OnEndEditEdtMaxSpread();
   void OnEndEditEdtMaxEntrySLDistance();
   void OnEndEditEdtMinEntrySLDistance();
   void OnEndEditEdtMaxPositionSize();
   void OnChangeChkSubtractPositions();
   void OnChangeChkSubtractPendingOrders();
   void OnClickBtnTabMain();
   void OnClickBtnTabRisk();
   void OnClickBtnTabMargin();
   void OnClickBtnTabSwaps();
   void OnClickBtnTabScript();
   void OnClickBtnTakeProfit();
   void OnClickBtnEntry();
};
 
// Event Map
EVENT_MAP_BEGIN(QCPositionSizeCalculator)
//Print(__FUNCTION__, " id = ", id, " (", EnumToString((ENUM_CHART_EVENT)id), ") lparam = ", lparam, " dparam = ", dparam, " sparam = ", sparam);
   ON_EVENT(ON_END_EDIT, m_EdtEntryLevel, OnEndEditEdtEntryLevel)
   ON_EVENT(ON_END_EDIT, m_EdtSL, OnEndEditEdtSL)
   ON_EVENT(ON_END_EDIT, m_EdtTP, OnEndEditEdtTP)
   ON_EVENT(ON_CLICK, m_BtnOrderType, OnClickBtnOrderType)
   ON_EVENT(ON_CLICK, m_BtnLines, OnClickBtnLines)
   ON_EVENT(ON_CLICK, m_BtnAccount, OnClickBtnAccount)
   ON_EVENT(ON_END_EDIT, m_EdtCommissionSize, OnEndEditEdtCommissionSize)
   ON_EVENT(ON_END_EDIT, m_EdtRiskPIn, OnEndEditEdtRiskPIn)
   ON_EVENT(ON_END_EDIT, m_EdtRiskMIn, OnEndEditEdtRiskMIn)
   ON_EVENT(ON_END_EDIT, m_EdtPosSize, OnEndEditEdtPosSize)
   ON_EVENT(ON_END_EDIT, m_EdtATRPeriod, OnEndEditATRPeriod)
   ON_EVENT(ON_END_EDIT, m_EdtATRMultiplierSL, OnEndEditATRMultiplierSL)
   ON_EVENT(ON_END_EDIT, m_EdtATRMultiplierTP, OnEndEditATRMultiplierTP)
   ON_EVENT(ON_CHANGE, m_ChkCountPendings, OnChangeChkCountPendings)
   ON_EVENT(ON_CHANGE, m_ChkIgnoreOrders, OnChangeChkIgnoreOrders)
   ON_EVENT(ON_END_EDIT, m_EdtCustomLeverage, OnEndEditEdtCustomLeverage)
   ON_EVENT(ON_END_EDIT, m_EdtMagicNumber, OnEndEditEdtMagicNumber)
   ON_EVENT(ON_END_EDIT, m_EdtScriptCommentary, OnEndEditEdtScriptCommentary)
   ON_EVENT(ON_CHANGE, m_ChkDisableTradingWhenLinesAreHidden, OnChangeChkDisableTradingWhenLinesAreHidden)
   ON_EVENT(ON_END_EDIT, m_EdtMaxSlippage, OnEndEditEdtMaxSlippage)
   ON_EVENT(ON_END_EDIT, m_EdtMaxSpread, OnEndEditEdtMaxSpread)
   ON_EVENT(ON_END_EDIT, m_EdtMaxEntrySLDistance, OnEndEditEdtMaxEntrySLDistance)
   ON_EVENT(ON_END_EDIT, m_EdtMinEntrySLDistance, OnEndEditEdtMinEntrySLDistance)
   ON_EVENT(ON_END_EDIT, m_EdtMaxPositionSize, OnEndEditEdtMaxPositionSize)
   ON_EVENT(ON_CHANGE, m_ChkSubtractPositions, OnChangeChkSubtractPositions)
   ON_EVENT(ON_CHANGE, m_ChkSubtractPendingOrders, OnChangeChkSubtractPendingOrders)
   ON_EVENT(ON_CLICK, m_BtnTabMain, OnClickBtnTabMain)
   ON_EVENT(ON_CLICK, m_BtnTabRisk, OnClickBtnTabRisk)
   ON_EVENT(ON_CLICK, m_BtnTabMargin, OnClickBtnTabMargin)
   ON_EVENT(ON_CLICK, m_BtnTabSwaps, OnClickBtnTabSwaps)
   ON_EVENT(ON_CLICK, m_BtnTabScript, OnClickBtnTabScript)
   ON_EVENT(ON_CLICK, m_BtnTakeProfit, OnClickBtnTakeProfit)
   ON_EVENT(ON_CLICK, m_BtnEntry, OnClickBtnEntry)
EVENT_MAP_END(CAppDialog)  

//+------------------
/// Class constructor 
//+------------------
QCPositionSizeCalculator::QCPositionSizeCalculator(void)
{
   m_FileName = "PSC_" + IntegerToString(ChartID()) + ".txt";
   NoPanelMaximization = false;
   remember_left = -1;
   remember_top = -1;
}
 
//+--------+
//| Button |
//+--------+
bool QCPositionSizeCalculator::ButtonCreate(CButton &Btn, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Btn.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Btn))                                                              return(false);
   if (!Btn.Text(Text))                                                        return(false);

   return(true);
}

//+----------+
//| Checkbox |
//+----------+
bool QCPositionSizeCalculator::CheckBoxCreate(CCheckBox &Chk, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Chk.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Chk))                                                              return(false);
   if (!Chk.Text(Text))                                                        return(false);

   return(true);
} 

//+------+
//| Edit |
//+------+
bool QCPositionSizeCalculator::EditCreate(CEdit &Edt, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Edt.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Edt))                                                              return(false);
   if (!Edt.Text(Text))                                                        return(false);

   return(true);
} 

//+-------+
//| Label |
//+-------+
bool QCPositionSizeCalculator::LabelCreate(CLabel &Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text)
{
   if (!Lbl.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return(false);
   if (!Add(Lbl))                                                              return(false);
   if (!Lbl.Text(Text))                                                        return(false);

   return(true);
}
 
//+-----------------------+
//| Create a panel object |
//+-----------------------+
bool QCPositionSizeCalculator::Create(const long chart, const string name, const int subwin, const int x1, const int y1)
{
	double screen_dpi = (double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
	m_DPIScale = screen_dpi / 96.0;

   int x2 = x1 + (int)MathRound(350 * m_DPIScale);
   int y2 = y1 + (int)MathRound(570 * m_DPIScale);
   if (!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))               return(false);
   if (!CreateObjects())                                                  		 return(false);

   return(true);
} 

bool QCPositionSizeCalculator::CreateObjects()
{
	int row_start = (int)MathRound(10 * m_DPIScale);
	int element_height = (int)MathRound(20 * m_DPIScale);
	int v_spacing = (int)MathRound(4 * m_DPIScale);
	
	int tab_button_start = (int)MathRound(15 * m_DPIScale);
	int tab_button_width = (int)MathRound(50 * m_DPIScale);
	int tab_button_spacing = (int)MathRound(15 * m_DPIScale);
	int normal_label_wdith = (int)MathRound(108 * m_DPIScale);
	int normal_edit_width = (int)MathRound(85 * m_DPIScale);
	int narrow_label_width = (int)MathRound(85 * m_DPIScale);
	int narrow_edit_width = (int)MathRound(75 * m_DPIScale);
	int risk_perc_edit_width = (int)MathRound(65 * m_DPIScale);
	int narrowest_label_width = (int)MathRound(50 * m_DPIScale);
	int commission_edit_width = (int)MathRound(50 * m_DPIScale);
	int max_psc_edit_width = (int)MathRound(90 * m_DPIScale);
	int narrowest_edit_width = (int)MathRound(75 * m_DPIScale);
	int leverage_edit_width = (int)MathRound(35 * m_DPIScale);
	int wide_edit_width = (int)MathRound(170 * m_DPIScale);
	int wide_label_width = (int)MathRound(193 * m_DPIScale);
	int swap_last_label_width = (int)MathRound(80 * m_DPIScale);
	int swap_type_edit_width = narrow_edit_width * 2 + (int)MathRound(5 * m_DPIScale);
	int atr_period_label_width = (int)MathRound(72 * m_DPIScale);
	int atr_period_edit_width = (int)MathRound(36 * m_DPIScale);
	
	int first_column_start = (int)MathRound(10 * m_DPIScale);
	int second_column_start = first_column_start + (int)MathRound(123 * m_DPIScale);
	int second_and_half_column_start = second_column_start + (int)MathRound(35 * m_DPIScale);
	int second_risk_column_start = first_column_start + (int)MathRound(114 * m_DPIScale);
	int second_margin_column_start = first_column_start + (int)MathRound(138 * m_DPIScale);
	int second_swaps_column_start = first_column_start + narrowest_label_width + (int)MathRound(5 * m_DPIScale);
	int second_script_column_start = second_margin_column_start + (int)MathRound(5 * m_DPIScale);
	int third_column_start = second_column_start + (int)MathRound(102 * m_DPIScale);
	int third_risk_column_start = second_risk_column_start + normal_edit_width + (int)MathRound(4 * m_DPIScale);
	int third_swaps_column_start = second_swaps_column_start + narrow_edit_width + (int)MathRound(5 * m_DPIScale);
	int fourth_risk_column_start = third_risk_column_start + risk_perc_edit_width + (int)MathRound(4 * m_DPIScale);
	int fourth_swaps_column_start = third_swaps_column_start + narrow_edit_width + (int)MathRound(5 * m_DPIScale);
	int max_psc_column_start = second_margin_column_start + normal_edit_width - (int)MathRound(5 * m_DPIScale);
	
	int panel_end = third_column_start + narrow_label_width;

	int y = (int)MathRound(8 * m_DPIScale);

// Tabs
	
   if (!ButtonCreate(m_BtnTabMain, tab_button_start, y, tab_button_start + tab_button_width, y + element_height, "m_BtnTabMain", "Main"))                    																								 return(false);
   if (!ButtonCreate(m_BtnTabRisk, tab_button_start + tab_button_width + tab_button_spacing, y, tab_button_start + tab_button_width * 2 + tab_button_spacing, y + element_height, "m_BtnTabRisk", "Risk"))                    																								 return(false);
   if (!ButtonCreate(m_BtnTabMargin, tab_button_start + tab_button_width * 2 + tab_button_spacing * 2, y, tab_button_start + tab_button_width * 3 + tab_button_spacing * 2, y + element_height, "m_BtnTabMargin", "Margin"))                   																							 return(false);
   if (!ButtonCreate(m_BtnTabSwaps, tab_button_start + tab_button_width * 3 + tab_button_spacing * 3, y, tab_button_start + tab_button_width * 4 + tab_button_spacing * 3, y + element_height, "m_BtnTabSwaps", "Swaps"))                   																							 return(false);
   if (!ButtonCreate(m_BtnTabScript, tab_button_start + tab_button_width * 4 + tab_button_spacing * 4, y, tab_button_start + tab_button_width * 5 + tab_button_spacing * 4, y + element_height, "m_BtnTabScript", "Script"))                   																							 return(false);

// Main
	
y = row_start + element_height + 3 * v_spacing;
   
   if ((UseFixedSLDistance) || (ShowATROptions))
   {
      // Button might be needed when ATR is used.
      if (!ButtonCreate(m_BtnEntry, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_BtnEntry", EnumToString(sets.TradeType) + " @"))                    return(false);
   }
   if (!UseFixedSLDistance)
      // Label might be needed when ATR is used
      if (!LabelCreate(m_LblEntryLevel, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblEntryLevel", "Entry:"))             						 	 return(false);
   if (!EditCreate(m_EdtEntryLevel, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtEntryLevel", ""))                    					 		 return(false);
   if (!LabelCreate(m_LblEntryWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblEntryWarning", ""))                         		 		 return(false);

y += element_height + v_spacing;
   
   string stoploss_label_text = "Stop-loss:";
   if (UseFixedSLDistance) stoploss_label_text = "SL, points:";
   if (!LabelCreate(m_LblSL, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblSL", stoploss_label_text))                                     		 	 return(false);
   if (!EditCreate(m_EdtSL, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtSL", ""))                                    					 		 return(false);
   if (!LabelCreate(m_LblSLWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblSLWarning", ""))                               		 		 return(false);

y += element_height + v_spacing;

   string takeprofit_label_text = "Take-profit:       ";
   if (UseFixedTPDistance) takeprofit_label_text = "TP, points:";
   if (!ButtonCreate(m_BtnTakeProfit, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_BtnTakeProfit", takeprofit_label_text))                    return(false);
   if (!EditCreate(m_EdtTP, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtTP", ""))                                    					 		 return(false);
   if (!LabelCreate(m_LblTPWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblTPWarning", ""))                               		 		 return(false);

   if (ShowATROptions)
   {
      y += element_height + v_spacing;
      
      if (!LabelCreate(m_LblATRPeriod, first_column_start, y, first_column_start + atr_period_label_width, y + element_height, "m_LblATRPeriod", "ATR period:"))                                     		 	 return(false);
      if (!EditCreate(m_EdtATRPeriod, first_column_start + atr_period_label_width, y, first_column_start + atr_period_label_width + atr_period_edit_width, y + element_height, "m_EdtATRPeriod", ""))                                    					 		 return(false);

      if (!LabelCreate(m_LblATRMultiplierSL, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblATRMultiplierSL", "SL multiplier:"))                                     		 	 return(false);
      
      if (!EditCreate(m_EdtATRMultiplierSL, third_column_start, y, third_column_start + normal_edit_width / 2, y + element_height, "m_EdtATRMultiplierSL", ""))                                    					 		 return(false);

      y += element_height + v_spacing;

      if (!LabelCreate(m_LblATRValue, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblATRValue", "ATR = "))                                     		 	 return(false);

      if (!LabelCreate(m_LblATRMultiplierTP, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblATRMultiplierTP", "TP multiplier:"))                                     		 	 return(false);
      
      if (!EditCreate(m_EdtATRMultiplierTP, third_column_start, y, third_column_start + normal_edit_width / 2, y + element_height, "m_EdtATRMultiplierTP", ""))                                    					 		 return(false);
   }

y += element_height + v_spacing;

   if (!LabelCreate(m_LblOrderType, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblOrderType", "Order type:"))                    		 		 return(false);
   if (!ButtonCreate(m_BtnOrderType, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnOrderType", "Instant"))							  		 		 return(false);

   if (!ButtonCreate(m_BtnLines, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_BtnLines", "Hide lines"))                      		 		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblCommissionSize, first_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblCommissionSize", "Commission (one-way) per lot:")) 		 return(false);
   if (!EditCreate(m_EdtCommissionSize, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtCommissionSize", ""))        						 		 return(false);

y += element_height + v_spacing;

   if (!HideAccSize)
   {
	   if (!ButtonCreate(m_BtnAccount, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_BtnAccount", "Account balance"))   							 		 return(false);
	   if (!EditCreate(m_EdtAccount, second_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtAccount", ""))                      						 		 return(false);
	   m_EdtAccount.ReadOnly(true);
	   m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
      
      if (!LabelCreate(m_LblAdditionalFundsAsterisk, third_column_start + normal_edit_width + v_spacing, y, third_column_start + normal_edit_width + v_spacing * 2, y + element_height, "m_LblAdditionalFundsAsterisk", "*")) 		 return(false);

		y += element_height + v_spacing;
	}
	
   if (!LabelCreate(m_LblInput, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblInput", "Input"))                                		 		 return(false);
   if (!LabelCreate(m_LblResult, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_LblResult", "Result"))                             		 		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblRisk, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblRisk", "Risk, %:"))                                   		 		 return(false);
   if (!EditCreate(m_EdtRiskPIn, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRiskPIn", ""))                      						 		 return(false);
   if (!EditCreate(m_EdtRiskPRes, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRiskPRes", ""))                    						 		 return(false);
   m_EdtRiskPRes.ReadOnly(true);
   m_EdtRiskPRes.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblRiskM, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblRiskM", "Risk, money:"))                          		 		 return(false);
   if (!EditCreate(m_EdtRiskMIn, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRiskMIn", ""))                      						 		 return(false);
   if (!EditCreate(m_EdtRiskMRes, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRiskMRes", ""))                    						 		 return(false);
   m_EdtRiskMRes.ReadOnly(true);
   m_EdtRiskMRes.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblReward, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblReward", "Reward, money:"))                             		 		 return(false);
   if (!EditCreate(m_EdtReward1, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtReward1", ""))                      						 		 return(false);
   m_EdtReward1.ReadOnly(true);
   m_EdtReward1.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtReward2, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtReward2", ""))                      						 		 return(false);
   m_EdtReward2.ReadOnly(true);
   m_EdtReward2.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblRR, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblRR", "Reward/risk:"))                                		 		 return(false);
   if (!EditCreate(m_EdtRR1, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRR1", ""))                                						 		 return(false);
   if (!EditCreate(m_EdtRR2, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRR2", ""))                                						 		 return(false);
   m_EdtRR1.ReadOnly(true);
   m_EdtRR1.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   m_EdtRR2.ReadOnly(true);
   m_EdtRR2.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblPosSize, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblPosSize", "Position size:"))                         		 return(false);
   if (!EditCreate(m_EdtPosSize, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtPosSize", ""))                      								 return(false);

   if (ShowPipValue)
   {
      y += element_height + v_spacing;

      if (!LabelCreate(m_LblPipValue, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblPipValue", "Pip value:"))                         		 return(false);
      if (!EditCreate(m_EdtPipValue, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtPipValue", ""))                      								 return(false);
      m_EdtPipValue.ReadOnly(true);
      m_EdtPipValue.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   }
   
y += element_height + v_spacing;

	// EarnForex URL
	//if (!LabelCreate(m_LblURL, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblURL", "www.earnforex.com"))             						 	 return(false);
	//m_LblURL.FontSize(8);
	//m_LblURL.Color(C'0,115,66'); // Green
	
	if (!LabelCreate(m_LblURL, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblURL", "NICK SAYS YIPEE!!!"))             						 	 return(false);
	m_LblURL.FontSize(8);
	m_LblURL.Color(C'0,115,66'); // Green

// Portfolio Risk   
   
// Reset
y = row_start + element_height + 3 * v_spacing;
   
   if (!CheckBoxCreate(m_ChkCountPendings, first_column_start, y, panel_end, y + element_height, "m_ChkCountPendings", "Count pending orders"))    		 return(false);

y += element_height + v_spacing;

   if (!CheckBoxCreate(m_ChkIgnoreOrders, first_column_start, y, panel_end, y + element_height, "m_ChkIgnoreOrders", "Ignore orders without stop-loss/take-profit")) return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblCurrentRiskMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblCurrentRiskMoney", "Risk $"))                                				 return(false);
   if (!LabelCreate(m_LblCurrentRiskPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentRiskPerc", "Risk %"))                                      				 return(false);
   if (!LabelCreate(m_LblCurrentLots, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentLots", "Lots"))                                      				 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblCurrentPortfolio, first_column_start, y, second_risk_column_start, y + element_height, "m_LblCurrentPortfolio", "Current portfolio:"))           				 return(false);
   if (!EditCreate(m_EdtCurRiskM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtCurRiskM", ""))                    								 return(false);
   m_EdtCurRiskM.ReadOnly(true);
   m_EdtCurRiskM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtCurRiskP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtCurRiskP", ""))                      							 return(false);
   m_EdtCurRiskP.ReadOnly(true);
   m_EdtCurRiskP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtCurL, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_EdtCurL", ""))                      							 return(false);
   m_EdtCurL.ReadOnly(true);
   m_EdtCurL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblCurrentProfitMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblCurrentProfitMoney", "Reward $"))                    								 return(false);
   if (!LabelCreate(m_LblCurrentProfitPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentProfitPerc", "Reward %"))                      							 return(false);

y += element_height + v_spacing;

   if (!EditCreate(m_EdtCurProfitM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtCurProfitM", ""))                    								 return(false);
   m_EdtCurProfitM.ReadOnly(true);
   m_EdtCurProfitM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtCurProfitP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtCurProfitP", ""))                      							 return(false);
   m_EdtCurProfitP.ReadOnly(true);
   m_EdtCurProfitP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblPotentialRiskMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblPotentialRiskMoney", "Risk $"))                                				 return(false);
   if (!LabelCreate(m_LblPotentialRiskPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialRiskPerc", "Risk %"))                                      				 return(false);
   if (!LabelCreate(m_LblPotentialLots, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialLots", "Lots"))                                      				 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblPotentialPortfolio, first_column_start, y, second_risk_column_start, y + element_height, "m_LblPotentialPortfolio", "Potential portfolio:"))           				 return(false);
   if (!EditCreate(m_EdtPotRiskM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtPotRiskM", ""))                    								 return(false);
   m_EdtPotRiskM.ReadOnly(true);
   m_EdtPotRiskM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtPotRiskP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtPotRiskP", ""))                      							 return(false);
   m_EdtPotRiskP.ReadOnly(true);
   m_EdtPotRiskP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtPotL, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_EdtPotL", ""))                      							 return(false);
   m_EdtPotL.ReadOnly(true);
   m_EdtPotL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblPotentialProfitMoney, second_risk_column_start, y, second_risk_column_start + narrow_edit_width, y + element_height, "m_LblPotentialProfitMoney", "Reward $"))                    								 return(false);
   if (!LabelCreate(m_LblPotentialProfitPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialProfitPerc", "Reward %"))                      							 return(false);

y += element_height + v_spacing;

   if (!EditCreate(m_EdtPotProfitM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtPotProfitM", ""))                    								 return(false);
   m_EdtPotProfitM.ReadOnly(true);
   m_EdtPotProfitM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   if (!EditCreate(m_EdtPotProfitP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtPotProfitP", ""))                      							 return(false);
   m_EdtPotProfitP.ReadOnly(true);
   m_EdtPotProfitP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Margin

// Reset
y = row_start + element_height + 3 * v_spacing;
   
   if (!LabelCreate(m_LblPosMargin, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblPosMargin", "Position margin:"))               				 return(false);
   if (!EditCreate(m_EdtPosMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtPosMargin", ""))                  								 return(false);
   m_EdtPosMargin.ReadOnly(true);
   m_EdtPosMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblUsedMargin, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblUsedMargin", "Future used margin:"))        				 return(false);
   if (!EditCreate(m_EdtUsedMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtUsedMargin","            "))                				 return(false);
   m_EdtUsedMargin.ReadOnly(true);
   m_EdtUsedMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblFreeMargin, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblFreeMargin", "Future free margin:"))         				 return(false);
   if (!EditCreate(m_EdtFreeMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtFreeMargin", ""))                								 return(false);
   m_EdtFreeMargin.ReadOnly(true);
   m_EdtFreeMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblCustomLeverage, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblCustomLeverage", "Custom leverage = 1:"))         				 return(false);
   if (!EditCreate(m_EdtCustomLeverage, second_margin_column_start - (int)MathRound(10 * m_DPIScale), y, second_margin_column_start + leverage_edit_width, y + element_height, "m_CustomLeverage", ""))                								 return(false);
   if (!LabelCreate(m_LblAccLeverage, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale), y, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale) + wide_edit_width, y + element_height, "m_LblAccLeverage", ""))         				 return(false);
   
y += element_height + v_spacing;

   if (!LabelCreate(m_LblSymbolLeverage, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale), y, second_margin_column_start + leverage_edit_width + (int)MathRound(5 * m_DPIScale) + wide_edit_width, y + element_height, "m_LblSymbolLeverage", "(Symbol = 1:?)"))         				 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMaxPositionSizeByMargin, first_column_start, y, first_column_start + wide_label_width, y + element_height, "m_LblMaxPositionSizeByMargin", "Maximum position size by margin:"))         				 return(false);
   if (!EditCreate(m_EdtMaxPositionSizeByMargin, max_psc_column_start, y, max_psc_column_start + max_psc_edit_width, y + element_height, "m_EdtMaxPositionSizeByMargin", ""))                								 return(false);
   m_EdtMaxPositionSizeByMargin.ReadOnly(true);
   m_EdtMaxPositionSizeByMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Swaps

// Reset
y = row_start + element_height + 3 * v_spacing;

   if (!LabelCreate(m_LblSwapsType, first_column_start, y, first_column_start + narrow_edit_width, y + element_height, "m_LblSwapsType", "Type:"))             						 	 return(false);
   if (!EditCreate(m_EdtSwapsType, first_column_start + narrow_edit_width, y, second_swaps_column_start + swap_type_edit_width, y + element_height, "m_EdtSwapsType", "Unknown"))                    					 		 return(false);
   m_EdtSwapsType.ReadOnly(true);
   m_EdtSwapsType.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;
   
   if (!LabelCreate(m_LblSwapsTripleDay, first_column_start, y, first_column_start + narrow_edit_width, y + element_height, "m_LblSwapsTripleDay", "Triple swap:"))             						 	 return(false);
   if (!EditCreate(m_EdtSwapsTripleDay, first_column_start + narrow_edit_width, y, second_swaps_column_start + swap_type_edit_width, y + element_height, "m_EdtSwapsTripleDay", "?"))                    					 		 return(false);
   m_EdtSwapsTripleDay.ReadOnly(true);
   m_EdtSwapsTripleDay.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;
   
   if (!LabelCreate(m_LblSwapsLong, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_LblSwapsLong", "Long"))             						 	 return(false);
   if (!LabelCreate(m_LblSwapsShort, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_LblSwapsShort", "Short"))             						 	 return(false);

y += element_height + v_spacing;
   
   if (!LabelCreate(m_LblSwapsNominal, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsNominal", "Nominal:"))             						 	 return(false);
   if (!EditCreate(m_EdtSwapsNominalLong, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsNominalLong", "?"))                    					 		 return(false);
   if (!EditCreate(m_EdtSwapsNominalShort, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsNominalShort", "?"))                    					 		 return(false);
   m_EdtSwapsNominalLong.ReadOnly(true);
   m_EdtSwapsNominalLong.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   m_EdtSwapsNominalShort.ReadOnly(true);
   m_EdtSwapsNominalShort.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;
   
   if (!LabelCreate(m_LblSwapsDaily, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsDaily", "Daily:"))             						 	 return(false);
   if (!EditCreate(m_EdtSwapsDailyLongLot, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsDailyLongLot", "?"))                    					 		 return(false);
   if (!EditCreate(m_EdtSwapsDailyShortLot, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsDailyShortLot", "?"))                    					 		 return(false);
   if (!LabelCreate(m_LblSwapsPerLotDaily, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerLotDaily", "USD per lot"))             						 	 return(false);
   m_EdtSwapsDailyLongLot.ReadOnly(true);
   m_EdtSwapsDailyLongLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   m_EdtSwapsDailyShortLot.ReadOnly(true);
   m_EdtSwapsDailyShortLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;
   
   if (!EditCreate(m_EdtSwapsDailyLongPS, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsDailyLongPS", "?"))                    					 		 return(false);
   if (!EditCreate(m_EdtSwapsDailyShortPS, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsDailyShortPS", "?"))                    					 		 return(false);
   if (!LabelCreate(m_LblSwapsPerPSDaily, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerPSDaily", "USD per PS ()"))             						 	 return(false);
   m_EdtSwapsDailyLongPS.ReadOnly(true);
   m_EdtSwapsDailyLongPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   m_EdtSwapsDailyShortPS.ReadOnly(true);
   m_EdtSwapsDailyShortPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblSwapsYearly, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsYearly", "Yearly:"))             						 	 return(false);
   if (!EditCreate(m_EdtSwapsYearlyLongLot, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsYearlyLongLot", "?"))                    					 		 return(false);
   if (!EditCreate(m_EdtSwapsYearlyShortLot, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsYearlyShortLot", "?"))                    					 		 return(false);
   if (!LabelCreate(m_LblSwapsPerLotYearly, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerLotYearly", "USD per lot"))             						 	 return(false);
   m_EdtSwapsYearlyLongLot.ReadOnly(true);
   m_EdtSwapsYearlyLongLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   m_EdtSwapsYearlyShortLot.ReadOnly(true);
   m_EdtSwapsYearlyShortLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

y += element_height + v_spacing;

   if (!EditCreate(m_EdtSwapsYearlyLongPS, second_swaps_column_start, y, second_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsYearlyLongPS", "?"))                    					 		 return(false);
   if (!EditCreate(m_EdtSwapsYearlyShortPS, third_swaps_column_start, y, third_swaps_column_start + narrow_edit_width, y + element_height, "m_EdtSwapsYearlyShortPS", "?"))                    					 		 return(false);
   if (!LabelCreate(m_LblSwapsPerPSYearly, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerPSYearly", "USD per PS ()"))             						 	 return(false);
   m_EdtSwapsYearlyLongPS.ReadOnly(true);
   m_EdtSwapsYearlyLongPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   m_EdtSwapsYearlyShortPS.ReadOnly(true);
   m_EdtSwapsYearlyShortPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Script

// Reset	
y = row_start + element_height + 3 * v_spacing;
   
   if (!LabelCreate(m_LblScriptExplanation, first_column_start, y, panel_end, y + element_height, "m_LblScriptExplanation", "Settings for PSC-Trader script."))             						 	 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMagicNumber, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblMagicNumber", "Magic number:"))             						 	 return(false);
   if (!EditCreate(m_EdtMagicNumber, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMagicNumber", ""))                    					 		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblScriptCommentary, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblScriptCommentary", "Order commentary:"))             						 	 return(false);
   if (!EditCreate(m_EdtScriptCommentary, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtScriptCommentary", ""))                    					 		 return(false);

y += element_height + v_spacing;

   if (!CheckBoxCreate(m_ChkDisableTradingWhenLinesAreHidden, first_column_start, y, panel_end, y + element_height, "m_ChkDisableTradingWhenLinesAreHidden", "Disable trading when lines are hidden"))    		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblScriptPips, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_LblScriptPips", "Pips"))             						 	 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMaxSlippage, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblMaxSlippage", "Max slippage:"))             						 	 return(false);
   if (!EditCreate(m_EdtMaxSlippage, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxSlippage", ""))                    					 		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMaxSpread, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblMaxSpread", "Max spread:"))             						 	 return(false);
   if (!EditCreate(m_EdtMaxSpread, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxSpread", ""))                    					 		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMaxEntrySLDistance, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblMaxEntrySLDistance", "Max Entry/SL distance:"))             						 	 return(false);
   if (!EditCreate(m_EdtMaxEntrySLDistance, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxEntrySLDistance", ""))                    					 		 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMinEntrySLDistance, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblMinEntrySLDistance", "Min Entry/SL distance:"))             						 	 return(false);
   if (!EditCreate(m_EdtMinEntrySLDistance, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMinEntrySLDistance", ""))                    					 		 return(false);

y += element_height + v_spacing;
   
   if (!LabelCreate(m_LblScriptLots, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_LblScriptLots", "Lots"))             						 	 return(false);

y += element_height + v_spacing;

   if (!LabelCreate(m_LblMaxPositionSize, first_column_start, y, first_column_start + normal_label_wdith, y + element_height, "m_LblMaxPositionSize", "Max position size:"))             						 	 return(false);
   if (!EditCreate(m_EdtMaxPositionSize, second_script_column_start, y, second_script_column_start + normal_edit_width, y + element_height, "m_EdtMaxPositionSize", ""))                    					 		 return(false);

y += element_height + v_spacing;

   if (!CheckBoxCreate(m_ChkSubtractPositions, first_column_start, y, panel_end, y + element_height, "m_ChkSubtractPositions", "Subtract open positions volume"))    		 return(false);

y += element_height + v_spacing;

   if (!CheckBoxCreate(m_ChkSubtractPendingOrders, first_column_start, y, panel_end, y + element_height, "m_ChkSubtractPendingOrders", "Subtract pending orders volume"))    		 return(false);

   InitObjects();

   return(true);
} 

bool QCPositionSizeCalculator::InitObjects()
{
   //+-------------------------------------+
   //| Align text from objects all objects |
   //+-------------------------------------+ 
   ENUM_ALIGN_MODE align = ALIGN_RIGHT;
   if (!m_EdtEntryLevel.TextAlign(align))                                   return(false);
   if (!m_EdtSL.TextAlign(align))                                           return(false);
   if (!m_EdtTP.TextAlign(align))                                           return(false);
   if (!m_EdtCommissionSize.TextAlign(align))                               return(false);
   if (!HideAccSize) if (!m_EdtAccount.TextAlign(align))                    return(false);
   if (!m_EdtRiskPIn.TextAlign(align))                                      return(false);
   if (!m_EdtRiskPRes.TextAlign(align))                                     return(false);
   if (!m_EdtRiskMIn.TextAlign(align))                                      return(false);
   if (!m_EdtRiskMRes.TextAlign(align))                                     return(false);
   if (!m_EdtReward1.TextAlign(align))                                      return(false);
   if (!m_EdtReward2.TextAlign(align))                                      return(false);
   if (!m_EdtRR1.TextAlign(align))                                          return(false);
   if (!m_EdtRR2.TextAlign(align))                                          return(false);
   if (!m_EdtPosSize.TextAlign(align))                                      return(false);
   if (ShowATROptions)
   {
      if (!m_EdtATRPeriod.TextAlign(align))                                 return(false);
      if (!m_EdtATRMultiplierSL.TextAlign(align))                           return(false);
      if (!m_EdtATRMultiplierTP.TextAlign(align))                           return(false);
   }
   if (ShowPipValue) if (!m_EdtPipValue.TextAlign(align))                   return(false);
   if (!m_EdtCurRiskM.TextAlign(align))                                     return(false);
   if (!m_EdtCurRiskP.TextAlign(align))                                     return(false);
   if (!m_EdtCurProfitM.TextAlign(align))                                   return(false);
   if (!m_EdtCurProfitP.TextAlign(align))                                   return(false);
   if (!m_EdtCurL.TextAlign(align))                                         return(false);
   if (!m_EdtPotRiskM.TextAlign(align))                                     return(false);
   if (!m_EdtPotRiskP.TextAlign(align))                                     return(false);
   if (!m_EdtPotProfitM.TextAlign(align))                                   return(false);
   if (!m_EdtPotProfitP.TextAlign(align))                                   return(false);
   if (!m_EdtPotL.TextAlign(align))                                         return(false);
   if (!m_EdtPosMargin.TextAlign(align))                                    return(false);
   if (!m_EdtUsedMargin.TextAlign(align))                                   return(false);
   if (!m_EdtFreeMargin.TextAlign(align))                                   return(false);
   if (!m_EdtMaxPositionSizeByMargin.TextAlign(align))                      return(false);
   if (!m_EdtSwapsNominalLong.TextAlign(align))                             return(false);
   if (!m_EdtSwapsNominalShort.TextAlign(align))                            return(false);
   if (!m_EdtSwapsDailyLongLot.TextAlign(align))                            return(false);
   if (!m_EdtSwapsDailyShortLot.TextAlign(align))                           return(false);
   if (!m_EdtSwapsDailyLongPS.TextAlign(align))                             return(false);
   if (!m_EdtSwapsDailyShortPS.TextAlign(align))                            return(false);
   if (!m_EdtSwapsYearlyLongLot.TextAlign(align))                           return(false);
   if (!m_EdtSwapsYearlyShortLot.TextAlign(align))                          return(false);
   if (!m_EdtSwapsYearlyLongPS.TextAlign(align))                            return(false);
   if (!m_EdtSwapsYearlyShortPS.TextAlign(align))                           return(false);
   if (!m_EdtMagicNumber.TextAlign(align))                           		 return(false);
   if (!m_EdtMaxSlippage.TextAlign(align))                           		 return(false);
   if (!m_EdtMaxSpread.TextAlign(align))                           			 return(false);
   if (!m_EdtMaxEntrySLDistance.TextAlign(align))                           return(false);
   if (!m_EdtMinEntrySLDistance.TextAlign(align))                           return(false);
   if (!m_EdtMaxPositionSize.TextAlign(align))                           	 return(false);

   //+-------------+
   //| Init values |
   //+-------------+
	HideRisk();
	HideMargin();
	HideMain();
	HideSwaps();
	HideScript();

	if (sets.SelectedTab == MainTab) ShowMain();
	else if (sets.SelectedTab == RiskTab) ShowRisk();
	else if (sets.SelectedTab == MarginTab) ShowMargin();
	else if (sets.SelectedTab == SwapsTab) ShowSwaps();
	else if (sets.SelectedTab == ScriptTab) ShowScript();

   if ((TP_Multiplier < 0.999) || (TP_Multiplier > 1.001))
   {
      if (!UseFixedTPDistance)
      {  
         if (!m_BtnTakeProfit.Text("Take-profit x " + DoubleToString(TP_Multiplier, CountDecimalPlaces(TP_Multiplier)) + ":")) return (false);
      }
      else if (!m_BtnTakeProfit.Text("TP x " + DoubleToString(TP_Multiplier, CountDecimalPlaces(TP_Multiplier)) + ":")) return (false);
   }

   if (sets.EntryType)
   {
      if (!m_BtnOrderType.Text("Pending"))                                  return(false);
   }
   else
   {
      if (!m_BtnOrderType.Text("Instant"))                                  return(false);
	   m_EdtEntryLevel.ReadOnly(true);
	   m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
   }     
   
   double acc_val;

   if (!HideAccSize)
   {
	   switch(sets.AccountButton)
	   {
	      default:
	      case Balance:
		      if (!m_BtnAccount.Text("Account balance"))								 return(false);
		      acc_val = AccountInfoDouble(ACCOUNT_BALANCE);
	      	break;
	      case Equity:
		      if (!m_BtnAccount.Text("Account equity"))                          return(false);
		      acc_val = AccountInfoDouble(ACCOUNT_EQUITY);
	      	break;
	      case Balance_minus_Risk:
		      if (!m_BtnAccount.Text("Balance - CPR"))                   			 return(false);
		      acc_val = AccountInfoDouble(ACCOUNT_BALANCE);
	      	break;
	   }
	   // Applying additional funds (e.g. bank balance or total net worth, etc.).
	   acc_val += AdditionalFunds;
	   if (!m_EdtAccount.Text(DoubleToString(acc_val, 2)))    						 return(false);
	   // Star to show that it is not "pure" account balance.
	   if ((AdditionalFunds >= 0.01) || (AdditionalFunds <= -0.01)) m_LblAdditionalFundsAsterisk.Show();
	   else m_LblAdditionalFundsAsterisk.Hide();
	}

   if (!m_EdtRiskPIn.Text(DoubleToString(sets.Risk, 2)))                    return(false);
   if (!m_EdtRiskMIn.Text(DoubleToString(sets.MoneyRisk, 2)))               return(false);

   if (ShowATROptions)
   {
      if (!m_EdtATRPeriod.Text(IntegerToString(sets.ATRPeriod)))               return(false);
      if (!m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2))) return(false);
      if (!m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2))) return(false);
   }
      
   if (!m_ChkCountPendings.Checked(sets.CountPendingOrders))                return(false);
   if (!m_ChkIgnoreOrders.Checked(sets.IgnoreOrdersWithoutStopLoss))        return(false);
   
   // Show/hide RiskReward
   if (sets.TakeProfitLevel == 0)   
   {
      if (!m_LblRR.Hide())                                                  return(false);
      if (!m_EdtRR1.Hide())                                                 return(false);
      if (!m_EdtRR2.Hide())                                                 return(false);
      if (!m_LblReward.Hide())                                              return(false);
      if (!m_EdtReward1.Hide())                                             return(false);
      if (!m_EdtReward2.Hide())                                             return(false);
   }

	CustomLeverage = sets.CustomLeverage;

	// Script
   if (!m_EdtMagicNumber.Text(IntegerToString(sets.MagicNumber)))                    			 return(false);
   if (!m_EdtScriptCommentary.Text(sets.ScriptCommentary))                    			 		 return(false);
   if (!m_ChkDisableTradingWhenLinesAreHidden.Checked(sets.DisableTradingWhenLinesAreHidden)) return(false);
   if (!m_EdtMaxSlippage.Text(IntegerToString(sets.MaxSlippage)))                    			 return(false);
   if (!m_EdtMaxSpread.Text(IntegerToString(sets.MaxSpread)))                    				 return(false);
   if (!m_EdtMaxEntrySLDistance.Text(IntegerToString(sets.MaxEntrySLDistance)))               return(false);
   if (!m_EdtMinEntrySLDistance.Text(IntegerToString(sets.MinEntrySLDistance)))               return(false);
   if (!m_ChkSubtractPositions.Checked(sets.SubtractPositions))                               return(false);
   if (!m_ChkSubtractPendingOrders.Checked(sets.SubtractPendingOrders))                       return(false);

   MoveAndResize();

   // Display values
   DisplayValues();
   
   if (sets.ShowLines == false)
   {
	   ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
	   ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
   }
   else
   {
	   ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	   ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
   }
   
	return(true);
}

// Moves elements on the panel depending on the choice of showing TP-related stuff, risk, and margin.
// Adjusts panel's height accordingly.
void QCPositionSizeCalculator::MoveAndResize()
{
   int col_height = (int)MathRound(24 * m_DPIScale);
   int new_height = col_height;
   int ref_point;

	switch(sets.SelectedTab)
	{
		case MainTab:
			ref_point = m_LblRiskM.Top();
		   if (sets.TakeProfitLevel == 0)
		   {
		      m_LblPosSize.Move(m_LblPosSize.Left(), ref_point + 1 * col_height);
		      m_EdtPosSize.Move(m_EdtPosSize.Left(), ref_point + 1 * col_height);
		      ref_point = ref_point + 1 * col_height;
		   }
		   else
		   {
		      m_LblReward.Move(m_LblReward.Left(), ref_point + 1 * col_height);
		      m_EdtReward1.Move(m_EdtReward1.Left(), ref_point + 1 * col_height);
		      m_EdtReward2.Move(m_EdtReward2.Left(), ref_point + 1 * col_height);
		      m_LblRR.Move(m_LblRR.Left(), ref_point + 2 * col_height);
		      m_EdtRR1.Move(m_EdtRR1.Left(), ref_point + 2 * col_height);
		      m_EdtRR2.Move(m_EdtRR2.Left(), ref_point + 2 * col_height);
		      m_LblPosSize.Move(m_LblPosSize.Left(), ref_point + 3 * col_height);
		      m_EdtPosSize.Move(m_EdtPosSize.Left(), ref_point + 3 * col_height);
		      ref_point = ref_point + 3 * col_height;
		   }  
			if (ShowPipValue)
   		{
		      m_LblPipValue.Move(m_LblPipValue.Left(), ref_point + 1 * col_height);
		      m_EdtPipValue.Move(m_EdtPipValue.Left(), ref_point + 1 * col_height);
   		   ref_point = ref_point + 1 * col_height;
   		}
			break;
		case RiskTab:
			ref_point = m_EdtPotProfitM.Top();
			break;
		case MarginTab:
			ref_point = m_LblMaxPositionSizeByMargin.Top();
			break;
		case SwapsTab:
	   	ref_point = m_LblSwapsPerPSYearly.Top();
	   	break;
		case ScriptTab:
	   	ref_point = m_ChkSubtractPendingOrders.Top();
	   	break;
	   default:
	   	ref_point = m_LblRiskM.Top();
	   	break;
	}
   m_LblURL.Move(m_LblURL.Left(), ref_point + col_height);
   new_height = m_LblURL.Top() + col_height - Top();
   
   if (!m_minimized)
   {
      // Resize window.
      Height(new_height);
      // Needed only in case of initialization when actual panel maximization is avoided.
      if (NoPanelMaximization) Width((int)MathRound(350 * m_DPIScale));
   }
   NoPanelMaximization = false;
}

bool QCPositionSizeCalculator::DisplayValues()
{
   string acc_currency = AccountCurrency();
   //=== Spread
   if (ShowSpread)      if (!Caption(Caption + " Spread: " + IntegerToString(SymbolInfoInteger(Symbol(), SYMBOL_SPREAD)))) return (false);
   
   //=== Levels
   /* Entry Level    */ if (!m_EdtEntryLevel.Text(DoubleToString(sets.EntryLevel, _Digits)))                        		  return(false);
   /* Entry Warning  */ if (!m_LblEntryWarning.Text(WarningEntry))                                                 		  return(false);
   
   /* Stop-Loss      */ if (!UseFixedSLDistance)
                        {
                           if (!m_EdtSL.Text(DoubleToString(sets.StopLossLevel, _Digits)))                              	  return(false);
                        }
                        else if (!m_EdtSL.Text(IntegerToString(sets.StopLoss)))                              	  return(false);
                        
   /* SL Warning     */ if (!m_LblSLWarning.Text(WarningSL))                                                       		  return(false);
   
   /* Take Profit    */ if (!UseFixedTPDistance)
                        {
                           if (!m_EdtTP.Text(DoubleToString(sets.TakeProfitLevel, _Digits)))                           		  return(false);
                        }
                        else if (!m_EdtTP.Text(IntegerToString(sets.TakeProfit)))                           		  return(false);
                        
   /* TP Warning     */ if (!m_LblTPWarning.Text(WarningTP))                                                       		  return(false);
   
   /* Account Value  */ if (!HideAccSize) if (!m_EdtAccount.Text(FormatDouble(DoubleToString(Size, 2))))                  return(false);
   
                        if (sets.ShowLines)
                        {
                           if (!m_BtnLines.Text("Hide lines"))                                                            return(false);  
                        }
                        else
                        {
                           if (!m_BtnLines.Text("Show lines"))                                                            return(false);
                        }
   //=== ATR SL and TP
   if (ShowATROptions)  
   {
                        double atr = iATR(_Symbol, _Period, sets.ATRPeriod, 0);
                        m_LblATRValue.Text("ATR = " + DoubleToString(atr, _Digits));
                        if (sets.ATRMultiplierSL > 0)
                        {
                           m_EdtSL.ReadOnly(true);
                           m_EdtSL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
                           if ((!UseFixedSLDistance) && (sets.SelectedTab == MainTab))
                           {
                              m_LblEntryLevel.Hide();
                              if (Height() > 26) m_BtnEntry.Show();
                              if (sets.StopLossLevel < sets.EntryLevel) sets.TradeType = Buy;
                              else sets.TradeType = Sell;
                              m_BtnEntry.Text(EnumToString(sets.TradeType) + " @");
                           }
                     	   ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_SELECTABLE, false);
                     	   ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_SELECTED, false);
                        }
                        else
                        {
                           m_EdtSL.ReadOnly(false);
                           m_EdtSL.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
                           if ((!UseFixedSLDistance) && (sets.SelectedTab == MainTab))
                           {
                              m_BtnEntry.Hide();
                              if (Height() > 26) m_LblEntryLevel.Show();
                              ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_SELECTABLE, true);
                           }
                        }
                        if (sets.ATRMultiplierTP > 0)
                        {
                           m_EdtTP.ReadOnly(true);
                           m_EdtTP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
                     	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, false);
                     	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTED, false);
                        }
                        else
                        {
                           m_EdtTP.ReadOnly(false);
                           m_EdtTP.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
                           ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, true);
                        }
   }                        
   //=== Commission, risk, position size
   /* Commission size*/ if (!m_EdtCommissionSize.Text(FormatDouble(DoubleToString(sets.CommissionPerLot, 2)))) 			  return(false);
   /* Risk currency  */ if (acc_currency != "") if (!m_LblRiskM.Text("Risk, " + acc_currency + ":"))            return(false);
   /* Risk In        */ if (!m_EdtRiskPIn.Text(FormatDouble(DoubleToString(DisplayRisk, 2))))                       		  return(false);
   /* Risk Money In  */ if (!m_EdtRiskMIn.Text(FormatDouble(DoubleToString(RiskMoney, 2))))                         		  return(false);  
   /* Risk Money Out */ if (!m_EdtRiskMRes.Text(FormatDouble(DoubleToString(OutputRiskMoney))))                  			  return(false);
   if ((OutputRiskMoney != 0) && (Size != 0))
   {
   /* Risk Out       */ if (!m_EdtRiskPRes.Text(FormatDouble(DoubleToString(Round(OutputRiskMoney / Size * 100, 2), 2)))) return(false);
   }
   /* Reward currency*/ if (acc_currency != "") if (!m_LblReward.Text("Reward, " + acc_currency + ":"))         return(false);
   /* Reward 1       */ if (!m_EdtReward1.Text(FormatDouble(InputReward)))                                                return(false);
   /* Reward 2       */ if (!m_EdtReward2.Text(FormatDouble(DoubleToString(OutputReward, 2))))                            return(false);
   /* Risk/Reward 1  */ if (!m_EdtRR1.Text(InputRR))                                                                      return(false);
   							if (InputRR == "Invalid TP") m_EdtRR1.Color(clrRed);
   							else m_EdtRR1.Color(m_EdtTP.Color());
   							if (StringToDouble(m_EdtTP.Text()) != 0) 
   							{
   							   if (InputRR == "") m_EdtRR1.Hide();
   							   else if (m_EdtRR2.IsVisible()) m_EdtRR1.Show();
   							}
   /* Risk/Reward 2  */ if (!m_EdtRR2.Text(OutputRR))                                                 						  return(false);
   							if (OutputRR == "Invalid TP") m_EdtRR2.Color(clrRed);
   							else m_EdtRR2.Color(m_EdtTP.Color());
   /* Position size  */ if (!m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits)))                		  return(false);
   /* Pip value      */ if (ShowPipValue)
                        {
                           if (acc_currency != "") if (!m_LblPipValue.Text("Pip value, " + acc_currency + ":")) return(false);
                           if (!m_EdtPipValue.Text(OutputPipValue))                		                                   return(false);
                        }
   //=== Portfolio Risk
   /* Money label    */ if (acc_currency != "")
   {
                                      if (!m_LblCurrentRiskMoney.Text("Risk " + acc_currency))                        	  return(false);
                                      if (!m_LblCurrentProfitMoney.Text("Reward " + acc_currency))                        return(false);
                                      if (!m_LblPotentialRiskMoney.Text("Risk " + acc_currency))                          return(false);
                                      if (!m_LblPotentialProfitMoney.Text("Reward " + acc_currency))                      return(false);
   }
   /* Current Portfolio Risk $     */ if (!m_EdtCurRiskM.Text(PLM))                                                       return(false);
   /* Current Portfolio Risk %     */ if (!m_EdtCurRiskP.Text(CPR))                                                       return(false);
   /* Current Portfolio Lots       */ if (!m_EdtCurL.Text(CPL))                                                           return(false);
   /* Current Portfolio Profit $   */ if (!m_EdtCurProfitM.Text(PRM))                                                     return(false);
   /* Current Portfolio Profit %   */ if (!m_EdtCurProfitP.Text(CPRew))                                                   return(false);
   /* Potential Portfolio Risk $   */ if (!m_EdtPotRiskM.Text(PPMR))                                                      return(false);
   /* Potential Portfolio Risk %   */ if (!m_EdtPotRiskP.Text(PPR))                                                       return(false);
   /* Potential Portfolio Profit $ */ if (!m_EdtPotProfitM.Text(PPMRew))                                                  return(false);
   /* Potential Portfolio Profit % */ if (!m_EdtPotProfitP.Text(PPRew))                                                   return(false);
   /* Potential Portfolio Lots     */ if (!m_EdtPotL.Text(PPL))                                                           return(false);
   
   //=== Margin
   /* Position Margin      	  */ if (!m_EdtPosMargin.Text(FormatDouble(DoubleToString(PositionMargin, 2))))        	  return(false);
   /* Future Used Margin   	  */ if (!m_EdtUsedMargin.Text(FormatDouble(DoubleToString(UsedMargin, 2))))           	  return(false);
   /* Future Free Margin   	  */ if (!m_EdtFreeMargin.Text(FormatDouble(DoubleToString(FutureMargin, 2))))           	  return(false);
   /* Custom Leverage   		  */ if (!m_EdtCustomLeverage.Text(IntegerToString(sets.CustomLeverage)))           	  	  return(false);
	string acc_lev = IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE));
   /* Account Leverage	 */ if (acc_lev != "") if (!m_LblAccLeverage.Text("(Default = 1:" + acc_lev + ")"))       	  			  return(false);
   /* Symbol Leverage	 */ if (SymbolLeverage) if (!m_LblSymbolLeverage.Text("(Symbol = 1:" + DoubleToString(SymbolLeverage, 0) + ")")) return(false);

   /* Max Position size  */ if (!m_EdtMaxPositionSizeByMargin.Text(FormatDouble(DoubleToString(OutputMaxPositionSize, LotStep_digits), LotStep_digits)))		  return(false);
   if (!StopOut) // Black
   {
      m_LblFreeMargin.Color(C'40,41,59');
      m_EdtFreeMargin.Color(C'40,41,59');

   }
   else // Red 
   {
      m_LblFreeMargin.Color(clrRed);
      m_EdtFreeMargin.Color(clrRed);
   }  

   //=== Swaps
   /* Swaps Type      	  		  */ if (!m_EdtSwapsType.Text(OutputSwapsType))        	  											 	  return(false);
   /* Swaps Triple Day 	  		  */ if (!m_EdtSwapsTripleDay.Text(SwapsTripleDay))        	  											  return(false);
   double swap_long = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_LONG);
   int swap_long_decimal_places = CountDecimalPlaces(swap_long);
   double swap_short = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_SHORT);
   int swap_short_decimal_places = CountDecimalPlaces(swap_short);
   /* Swaps Nominal Long     		*/ if (!m_EdtSwapsNominalLong.Text(DoubleToString(swap_long, swap_long_decimal_places)))    return(false);
   /* Swaps Nominal Short    		*/ if (!m_EdtSwapsNominalShort.Text(DoubleToString(swap_short, swap_short_decimal_places))) return(false);
   /* Swaps Daily Long Lot   		*/ if (!m_EdtSwapsDailyLongLot.Text(OutputSwapsDailyLongLot)) 										  return(false);
   /* Swaps Daily Short Lot  		*/ if (!m_EdtSwapsDailyShortLot.Text(OutputSwapsDailyShortLot)) 									  return(false);
   /* Swaps Label Daily per Lot 	*/ if (!m_LblSwapsPerLotDaily.Text(OutputSwapsCurrencyDailyLot))                         	  return(false);
   /* Swaps Daily Long PS 	  		*/ if (!m_EdtSwapsDailyLongPS.Text(OutputSwapsDailyLongPS)) 										  return(false);
   /* Swaps Daily Short PS	  		*/ if (!m_EdtSwapsDailyShortPS.Text(OutputSwapsDailyShortPS)) 										  return(false);
   /* Swaps Label Daily per PS 	*/ if (!m_LblSwapsPerPSDaily.Text(OutputSwapsCurrencyDailyPS))                         	  return(false);
   /* Swaps Yearly Long Lot  		*/ if (!m_EdtSwapsYearlyLongLot.Text(OutputSwapsYearlyLongLot)) 									  return(false);
   /* Swaps Yearly Short Lot 		*/ if (!m_EdtSwapsYearlyShortLot.Text(OutputSwapsYearlyShortLot)) 								  return(false);
   /* Swaps Label Yearly per Lot */ if (!m_LblSwapsPerLotYearly.Text(OutputSwapsCurrencyYearlyLot))                          return(false);
   /* Swaps Yearly Long PS   		*/ if (!m_EdtSwapsYearlyLongPS.Text(OutputSwapsYearlyLongPS)) 										  return(false);
   /* Swaps Yearly Short PS  		*/ if (!m_EdtSwapsYearlyShortPS.Text(OutputSwapsYearlyShortPS)) 									  return(false);
   /* Swaps Label Yearly per PS 	*/ if (!m_LblSwapsPerPSYearly.Text(OutputSwapsCurrencyYearlyPS))        	                 return(false);

   //=== Script
   /* Maximum Position Size      */ if (!m_EdtMaxPositionSize.Text(DoubleToString(sets.MaxPositionSize, LotStep_digits)))    return(false);

   return(true);
} 

void QCPositionSizeCalculator::Minimize()
{
   CAppDialog::Minimize();
   if (remember_left != -1) Move(remember_left, remember_top);
}

void QCPositionSizeCalculator::Maximize()
{
   if (!NoPanelMaximization) CAppDialog::Maximize();
   else if (m_minimized) CAppDialog::Minimize();

   if (sets.TakeProfitLevel == 0)
   {
      if (!m_LblRR.Hide())                                                     return;
      if (!m_EdtRR1.Hide())                                                    return;
      if (!m_EdtRR2.Hide())                                                    return;
      if (!m_LblReward.Hide())                                                 return;
      if (!m_EdtReward1.Hide())                                                return;
      if (!m_EdtReward2.Hide())                                                return;  
   }

	HideRisk();
	HideMargin();
	HideMain();
	HideSwaps();
	HideScript();

	if (!m_minimized)
	{
   	if (sets.SelectedTab == MainTab) ShowMain();
   	else if (sets.SelectedTab == RiskTab) ShowRisk();
   	else if (sets.SelectedTab == MarginTab) ShowMargin();
   	else if (sets.SelectedTab == SwapsTab) ShowSwaps();
   	else if (sets.SelectedTab == ScriptTab) ShowScript();
   }

   MoveAndResize(); 
   if (remember_left != -1) Move(remember_left, remember_top);
}

bool QCPositionSizeCalculator::RefreshValues()
{
   if ((ShowATROptions) && ((sets.ATRMultiplierSL > 0) || (sets.ATRMultiplierTP > 0)))
   {
      double atr = iATR(_Symbol, _Period, sets.ATRPeriod, 0);
      if (sets.ATRMultiplierSL > 0)
      {
         double sl = atr * sets.ATRMultiplierSL;
         if (sets.TradeType == Buy) sets.StopLossLevel = sets.EntryLevel - sl;
         else sets.StopLossLevel = sets.EntryLevel + sl;
         sets.StopLoss = (int)MathRound(MathAbs(sets.StopLossLevel - sets.EntryLevel) / _Point);
      }
      if (sets.ATRMultiplierTP > 0)
      {
         double tp = atr * sets.ATRMultiplierTP;
         // If no ATR SL multiplier is given, TradeType should be determined by Entry-SL difference.
         if (sets.StopLossLevel < sets.EntryLevel) sets.TakeProfitLevel = sets.EntryLevel + tp;
         else sets.TakeProfitLevel = sets.EntryLevel - tp;
         sets.TakeProfit = (int)MathRound(MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / _Point);
      }
   }
   
   if (sets.ShowLines)
   {
      if ((sets.ATRMultiplierSL == 0) || (!ShowATROptions)) sets.StopLossLevel = ObjectGetDouble(ChartID(), "StopLossLine", OBJPROP_PRICE);
      if ((sets.ATRMultiplierTP == 0) || (!ShowATROptions)) sets.TakeProfitLevel = ObjectGetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE);

      // Check and adjust for TickSize granularity.
      if (TickSize > 0)
      {  
         sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
         ObjectSetDouble(ChartID(), "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
         sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
         ObjectSetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
      }

      if (sets.EntryType == Instant)
      {
         if (!UseFixedSLDistance) 
         {
            if (sets.StopLossLevel < SymbolInfoDouble(Symbol(), SYMBOL_ASK)) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            else sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);
         }
         else
         {
            if (sets.TradeType == Buy) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            else sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);
         }
      }
      else // Pending
      {
         sets.EntryLevel = ObjectGetDouble(ChartID(), "EntryLine", OBJPROP_PRICE);
         // Check and adjust for TickSize granularity.
         if (TickSize > 0)
         {  
            sets.EntryLevel = NormalizeDouble(MathRound(sets.EntryLevel / TickSize) * TickSize, _Digits);
            ObjectSetDouble(ChartID(), "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
         }
      }
      
      // Set line based on the entered SL distance.
      if (UseFixedSLDistance)
      {
         if (sets.TradeType == Buy) sets.StopLossLevel = sets.EntryLevel - sets.StopLoss * _Point;
         else sets.StopLossLevel = sets.EntryLevel + sets.StopLoss * _Point;
         ObjectSetDouble(ChartID(), "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
      }
      
      // Set line based on the entered TP distance.
      if ((UseFixedTPDistance) && (sets.TakeProfit > 0))
      {
         if ((UseFixedSLDistance) || ((sets.ATRMultiplierSL > 0) && (ShowATROptions)))
         {
            // When using fixed SL distance, we can check trade type variable.
            if (sets.TradeType == Buy) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfit * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
         }
         else
         {
            // When NOT using fixed SL distance, there is no trade type variable to check - using relative position of levels instead.
            if (sets.EntryLevel > sets.StopLossLevel) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfit * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
         }
         ObjectSetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
      }
   }

	sets.CustomLeverage = (int)StringToInteger(m_EdtCustomLeverage.Text());
	
   RecalculatePositionSize();
   DisplayValues();

   if ((sets.SelectedTab == MainTab) && (!m_LblRR.IsVisible()) && (sets.TakeProfitLevel > 0) && (Height() > 26))
   {
   	// If TP is non-zero, show TP-related panel elements.
      m_LblRR.Show();
      if (InputRR != "") m_EdtRR1.Show();
      m_EdtRR2.Show();
      m_LblReward.Show();
      m_EdtReward1.Show();
      m_EdtReward2.Show();
      Hide(); Show(); Maximize();
   }

   return(true);
} 

void QCPositionSizeCalculator::HideMain()
{
	m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   if ((!UseFixedSLDistance) || ((ShowATROptions) && (sets.ATRMultiplierSL == 0))) m_LblEntryLevel.Hide();
   if ((UseFixedSLDistance) || ((ShowATROptions) && (sets.ATRMultiplierSL > 0))) m_BtnEntry.Hide();
   m_EdtEntryLevel.Hide();
   m_LblEntryWarning.Hide();
   m_LblSL.Hide();
   m_EdtSL.Hide();
   m_LblSLWarning.Hide();
   m_BtnTakeProfit.Hide();
   m_EdtTP.Hide();
   m_LblTPWarning.Hide();
   if (ShowATROptions)
   {
      m_LblATRPeriod.Hide();
      m_LblATRMultiplierSL.Hide();
      m_LblATRMultiplierTP.Hide();
      m_EdtATRPeriod.Hide();
      m_EdtATRMultiplierSL.Hide();
      m_EdtATRMultiplierTP.Hide();
      m_LblATRValue.Hide();
   }
   m_LblOrderType.Hide();
   m_BtnOrderType.Hide();
   m_BtnLines.Hide();
   m_LblCommissionSize.Hide();
   m_EdtCommissionSize.Hide();
   if (!HideAccSize)
   {
      m_BtnAccount.Hide();
      m_EdtAccount.Hide();
      m_LblAdditionalFundsAsterisk.Hide();
	}
   m_LblInput.Hide();
   m_LblResult.Hide();
   m_LblRisk.Hide();
   m_EdtRiskPIn.Hide();
   m_EdtRiskPRes.Hide();
   m_LblRiskM.Hide();
   m_EdtRiskMIn.Hide();
   m_EdtRiskMRes.Hide();
   m_LblReward.Hide();
   m_EdtReward1.Hide();
   m_EdtReward2.Hide();
   m_LblRR.Hide();
   m_EdtRR1.Hide();
   m_EdtRR2.Hide();
   m_LblPosSize.Hide();
   m_EdtPosSize.Hide();
   if (ShowPipValue)
   {
      m_LblPipValue.Hide();
      m_EdtPipValue.Hide();
   }
}

void QCPositionSizeCalculator::ShowMain()
{
	m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   if ((!UseFixedSLDistance) || ((ShowATROptions) && (sets.ATRMultiplierSL == 0))) m_LblEntryLevel.Show();
   if ((UseFixedSLDistance) || ((ShowATROptions) && (sets.ATRMultiplierSL > 0))) m_BtnEntry.Show();
   m_EdtEntryLevel.Show();
   m_LblEntryWarning.Show();
   m_LblSL.Show();
   m_EdtSL.Show();
   m_LblSLWarning.Show();
   m_BtnTakeProfit.Show();
   m_EdtTP.Show();
   m_LblTPWarning.Show();
   if (ShowATROptions)
   {
      m_LblATRPeriod.Show();
      m_LblATRMultiplierSL.Show();
      m_LblATRMultiplierTP.Show();
      m_EdtATRPeriod.Show();
      m_EdtATRMultiplierSL.Show();
      m_EdtATRMultiplierTP.Show();
      m_LblATRValue.Show();
   }
   m_LblOrderType.Show();
   m_BtnOrderType.Show();
   m_BtnLines.Show();
   m_LblCommissionSize.Show();
   m_EdtCommissionSize.Show();
   if (!HideAccSize)
   {
	   m_BtnAccount.Show();
	   m_EdtAccount.Show();
	   if ((AdditionalFunds >= 0.01) || (AdditionalFunds <= -0.01)) m_LblAdditionalFundsAsterisk.Show();
   }
   m_LblInput.Show();
   m_LblResult.Show();
   m_LblRisk.Show();
   m_EdtRiskPIn.Show();
   m_EdtRiskPRes.Show();
   m_LblRiskM.Show();
   m_EdtRiskMIn.Show();
   m_EdtRiskMRes.Show();
   if (sets.TakeProfitLevel != 0)
   {
	   m_LblReward.Show();
	   m_EdtReward1.Show();
	   m_EdtReward2.Show();
	   m_LblRR.Show();
	   if (InputRR != "") m_EdtRR1.Show();
	   m_EdtRR2.Show();
	}
   m_LblPosSize.Show();
   m_EdtPosSize.Show();
   if (ShowPipValue)
   {
	   m_LblPipValue.Show();
	   m_EdtPipValue.Show();
   }
}

void QCPositionSizeCalculator::HideRisk()
{
	m_BtnTabRisk.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_ChkCountPendings.Hide();
   m_ChkIgnoreOrders.Hide();
   m_LblCurrentPortfolio.Hide();
   m_LblPotentialPortfolio.Hide();
   m_LblCurrentRiskMoney.Hide();
   m_LblCurrentRiskPerc.Hide();
   m_LblCurrentProfitMoney.Hide();
   m_LblCurrentProfitPerc.Hide();
   m_LblPotentialRiskMoney.Hide();
   m_LblPotentialRiskPerc.Hide();
   m_LblPotentialProfitMoney.Hide();
   m_LblPotentialProfitPerc.Hide();
   m_LblCurrentLots.Hide();
   m_LblPotentialLots.Hide();
   m_EdtCurRiskM.Hide();
   m_EdtCurRiskP.Hide();
   m_EdtCurProfitM.Hide();
   m_EdtCurProfitP.Hide();
   m_EdtCurL.Hide();
   m_EdtPotRiskM.Hide();
   m_EdtPotRiskP.Hide();
   m_EdtPotProfitM.Hide();
   m_EdtPotProfitP.Hide();
   m_EdtPotL.Hide();
}  

void QCPositionSizeCalculator::ShowRisk()
{
	m_BtnTabRisk.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_ChkCountPendings.Show();
   m_ChkIgnoreOrders.Show();
   m_LblCurrentPortfolio.Show();
   m_LblPotentialPortfolio.Show();
   m_LblCurrentRiskMoney.Show();
   m_LblCurrentRiskPerc.Show();
   m_LblCurrentProfitMoney.Show();
   m_LblCurrentProfitPerc.Show();
   m_LblPotentialRiskMoney.Show();
   m_LblPotentialRiskPerc.Show();
   m_LblPotentialProfitMoney.Show();
   m_LblPotentialProfitPerc.Show();
   m_LblCurrentLots.Show();
   m_LblPotentialLots.Show();
   m_EdtCurRiskM.Show();
   m_EdtCurRiskP.Show();
   m_EdtCurProfitM.Show();
   m_EdtCurProfitP.Show();
   m_EdtCurL.Show();
   m_EdtPotRiskM.Show();
   m_EdtPotRiskP.Show();
   m_EdtPotProfitM.Show();
   m_EdtPotProfitP.Show();
   m_EdtPotL.Show();   
}

void QCPositionSizeCalculator::HideMargin()
{
	m_BtnTabMargin.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_LblPosMargin.Hide();
   m_EdtPosMargin.Hide();
   m_LblUsedMargin.Hide();
   m_EdtUsedMargin.Hide();
   m_LblFreeMargin.Hide();
   m_EdtFreeMargin.Hide();
   m_LblCustomLeverage.Hide();
   m_EdtCustomLeverage.Hide();
   m_LblAccLeverage.Hide();
   m_LblSymbolLeverage.Hide();
   m_LblMaxPositionSizeByMargin.Hide();
   m_EdtMaxPositionSizeByMargin.Hide();
}  

void QCPositionSizeCalculator::ShowMargin()
{
	m_BtnTabMargin.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_LblPosMargin.Show();
   m_EdtPosMargin.Show();
   m_LblUsedMargin.Show();
   m_EdtUsedMargin.Show();
   m_LblFreeMargin.Show();
   m_EdtFreeMargin.Show();
   m_LblCustomLeverage.Show();
   m_EdtCustomLeverage.Show();
   m_LblAccLeverage.Show();
   m_LblSymbolLeverage.Show();
   m_LblMaxPositionSizeByMargin.Show();
   m_EdtMaxPositionSizeByMargin.Show();
}

void QCPositionSizeCalculator::HideSwaps()
{
	m_BtnTabSwaps.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_LblSwapsType.Hide();
   m_EdtSwapsType.Hide();
   m_LblSwapsTripleDay.Hide();
   m_EdtSwapsTripleDay.Hide();
   m_LblSwapsLong.Hide();
   m_LblSwapsShort.Hide();
   m_LblSwapsNominal.Hide();
   m_EdtSwapsNominalLong.Hide();
   m_EdtSwapsNominalShort.Hide();
   m_LblSwapsDaily.Hide();
   m_EdtSwapsDailyLongLot.Hide();
   m_EdtSwapsDailyShortLot.Hide();
   m_LblSwapsPerLotDaily.Hide();
   m_EdtSwapsDailyLongPS.Hide();
   m_EdtSwapsDailyShortPS.Hide();
   m_LblSwapsPerPSDaily.Hide();
   m_LblSwapsYearly.Hide();
   m_EdtSwapsYearlyLongLot.Hide();
   m_EdtSwapsYearlyShortLot.Hide();
   m_LblSwapsPerLotYearly.Hide();
   m_EdtSwapsYearlyLongPS.Hide();
   m_EdtSwapsYearlyShortPS.Hide();
   m_LblSwapsPerPSYearly.Hide();
}  

void QCPositionSizeCalculator::ShowSwaps()
{
	m_BtnTabSwaps.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_LblSwapsType.Show();
   m_EdtSwapsType.Show();
   m_LblSwapsTripleDay.Show();
   m_EdtSwapsTripleDay.Show();
   m_LblSwapsLong.Show();
   m_LblSwapsShort.Show();
   m_LblSwapsNominal.Show();
   m_EdtSwapsNominalLong.Show();
   m_EdtSwapsNominalShort.Show();
   m_LblSwapsDaily.Show();
   m_EdtSwapsDailyLongLot.Show();
   m_EdtSwapsDailyShortLot.Show();
   m_LblSwapsPerLotDaily.Show();
   m_EdtSwapsDailyLongPS.Show();
   m_EdtSwapsDailyShortPS.Show();
   m_LblSwapsPerPSDaily.Show();
   m_LblSwapsYearly.Show();
   m_EdtSwapsYearlyLongLot.Show();
   m_EdtSwapsYearlyShortLot.Show();
   m_LblSwapsPerLotYearly.Show();
   m_EdtSwapsYearlyLongPS.Show();
   m_EdtSwapsYearlyShortPS.Show();
   m_LblSwapsPerPSYearly.Show();
}  

void QCPositionSizeCalculator::HideScript()
{
	m_BtnTabScript.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
   m_LblScriptExplanation.Hide();
   m_LblMagicNumber.Hide();
   m_EdtMagicNumber.Hide();
   m_LblScriptCommentary.Hide();
   m_EdtScriptCommentary.Hide();
   m_ChkDisableTradingWhenLinesAreHidden.Hide();
   m_LblScriptPips.Hide();
   m_LblMaxSlippage.Hide();
   m_EdtMaxSlippage.Hide();
   m_LblMaxSpread.Hide();
   m_EdtMaxSpread.Hide();
   m_LblMaxEntrySLDistance.Hide();
   m_EdtMaxEntrySLDistance.Hide();
   m_LblMinEntrySLDistance.Hide();
   m_EdtMinEntrySLDistance.Hide();
   m_LblScriptLots.Hide();
   m_LblMaxPositionSize.Hide();
   m_EdtMaxPositionSize.Hide();
   m_ChkSubtractPositions.Hide();
   m_ChkSubtractPendingOrders.Hide();
}

void QCPositionSizeCalculator::ShowScript()
{
	m_BtnTabScript.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
   m_LblScriptExplanation.Show();
   m_LblMagicNumber.Show();
   m_EdtMagicNumber.Show();
   m_LblScriptCommentary.Show();
   m_EdtScriptCommentary.Show();
   m_ChkDisableTradingWhenLinesAreHidden.Show();
   m_LblScriptPips.Show();
   m_LblMaxSlippage.Show();
   m_EdtMaxSlippage.Show();
   m_LblMaxSpread.Show();
   m_EdtMaxSpread.Show();
   m_LblMaxEntrySLDistance.Show();
   m_EdtMaxEntrySLDistance.Show();
   m_LblMinEntrySLDistance.Show();
   m_EdtMinEntrySLDistance.Show();
   m_LblScriptLots.Show();
   m_LblMaxPositionSize.Show();
   m_EdtMaxPositionSize.Show();
   m_ChkSubtractPositions.Show();
   m_ChkSubtractPendingOrders.Show();
}

void QCPositionSizeCalculator::SeekAndDestroyDuplicatePanels()
{
	int ot = ObjectsTotal(ChartID());
	for (int i = ot - 1; i >= 0; i--)
	{
		string object_name = ObjectName(ChartID(), i);
		if (ObjectGetInteger(ChartID(), object_name, OBJPROP_TYPE) != OBJ_EDIT) continue;
		// Found Caption object.
		if (StringSubstr(object_name, StringLen(object_name) - 7) == "Caption")
		{
			string prefix = StringSubstr(object_name, 0, StringLen(Name()));
			// Found Caption object with prefix different than current.
			if (prefix != Name())
			{
				ObjectsDeleteAll(ChartID(), prefix);
				// Reset object counter.
				ot = ObjectsTotal(ChartID());
				i = ot;
				Print("Deleted duplicate panel objects with prefix = ", prefix, ".");
				continue;
			}
		}
	}
}

//+--------------------------------------------+
//|                                            |         
//|                   EVENTS                   |
//|                                            |
//+--------------------------------------------+
void QCPositionSizeCalculator::OnClickBtnTabMain()
{
   if (sets.SelectedTab != MainTab)
   {
   	sets.SelectedTab = MainTab;
   	ShowMain();
   	HideRisk();
   	HideMargin();
   	HideSwaps();
   	HideScript();

   	MoveAndResize();
   	RefreshValues();
   }
}
 
void QCPositionSizeCalculator::OnClickBtnTabRisk()
{
   if (sets.SelectedTab != RiskTab)
   {
   	sets.SelectedTab = RiskTab;
   	HideMain();
   	ShowRisk();
   	HideMargin();
   	HideSwaps();
   	HideScript();

   	MoveAndResize();
   	RefreshValues();
   }
}
 
void QCPositionSizeCalculator::OnClickBtnTabMargin()
{
   if (sets.SelectedTab != MarginTab)
   {
   	sets.SelectedTab = MarginTab;
   	HideRisk();
   	HideMain();
   	ShowMargin();
   	HideSwaps();
   	HideScript();

   	MoveAndResize();
   	RefreshValues();
   }
}
 
void QCPositionSizeCalculator::OnClickBtnTabSwaps()
{
   if (sets.SelectedTab != SwapsTab)
   {
   	sets.SelectedTab = SwapsTab;
   	HideRisk();
   	HideMain();
   	HideMargin();
   	ShowSwaps();
   	HideScript();

   	MoveAndResize();
   	RefreshValues();
   }
}
 
void QCPositionSizeCalculator::OnClickBtnTabScript()
{
   if (sets.SelectedTab != ScriptTab)
   {
   	sets.SelectedTab = ScriptTab;
   	HideRisk();
   	HideMain();
   	HideMargin();
   	HideSwaps();
   	ShowScript();

   	MoveAndResize();
   }
}

void QCPositionSizeCalculator::OnClickBtnOrderType()
{
   sets.EntryType = (ENTRY_TYPE)!((bool)sets.EntryType);
   if (sets.EntryType == Instant)
   {
      ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_SELECTABLE, false);
      ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_SELECTED, false);
      if (!m_EdtEntryLevel.ReadOnly(true))                                    return;   
      if (!m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE))      return;
      m_BtnOrderType.Text("Instant");
   }  
   else // Pending
   { 
      ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_SELECTABLE, true);
      if (!m_EdtEntryLevel.ReadOnly(false))                                   return;
      if (!m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE))       return;
      m_BtnOrderType.Text("Pending");
   }  
   
   RefreshValues();
}

void QCPositionSizeCalculator::OnClickBtnAccount()
{
   switch(sets.AccountButton)
   {
   	case Balance:
   		// Switch to Equity.
   		sets.AccountButton = Equity;
   		m_BtnAccount.Text("Account equity");
   		break;
   	case Equity:
   		// Switch to Balance minus Risk.
   		sets.AccountButton = Balance_minus_Risk;
   		m_BtnAccount.Text("Balance - CPR");
   		break;
   	default:
   	case Balance_minus_Risk:
   		// Switch to Balance.
   		sets.AccountButton = Balance;
   		m_BtnAccount.Text("Account balance");
   		break;
   }
   RefreshValues();
}

void QCPositionSizeCalculator::OnClickBtnLines()
{
   sets.ShowLines = !sets.ShowLines;
   if (sets.ShowLines)
   {
      m_BtnLines.Text("Hide lines");   
   }
   else
   {
      m_BtnLines.Text("Show lines");   
   }  
   if (sets.ShowLines)
   {
		ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
		ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
		ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
		
		if (ShowLineLabels)
		{
			ObjectSetInteger(ChartID(), "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
			if (StringToDouble(m_EdtTP.Text()) != 0) ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
		}
		// Hides and shows the panel. Needed to put it to the foreground. Maximize() hides internal controls that were hidden before.
		HideShowMaximize();
   }
   else
	{
		ObjectSetInteger(ChartID(), "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
		ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
		ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

		ObjectSetInteger(ChartID(), "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
		ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
	} 
}

void QCPositionSizeCalculator::OnClickBtnTakeProfit()
{
	if (tStopLossLevel < tEntryLevel) sets.TakeProfitLevel = tEntryLevel + (tEntryLevel - tStopLossLevel) * TP_Multiplier;
	else if (tStopLossLevel > tEntryLevel) sets.TakeProfitLevel = (tEntryLevel - tStopLossLevel) * TP_Multiplier + tEntryLevel;
	else sets.TakeProfitLevel = tEntryLevel;
   
   if (tTakeProfitLevel != sets.TakeProfitLevel)
   {
   	tTakeProfitLevel = sets.TakeProfitLevel;
		if (sets.ATRMultiplierSL > 0)
		{
		   sets.ATRMultiplierTP = NormalizeDouble(sets.ATRMultiplierSL * TP_Multiplier, 2);
		   m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
		}
		if (!UseFixedTPDistance) m_EdtTP.Text(DoubleToString(tTakeProfitLevel, _Digits));
		else
		{
		   sets.TakeProfit = (int)MathRound(MathAbs(tTakeProfitLevel - tEntryLevel) / _Point);
		   m_EdtTP.Text(IntegerToString(sets.TakeProfit));
		}
    	if (ObjectFind(ChartID(), "TakeProfitLine") == -1) 
     	{
      	ObjectCreate(ChartID(), "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
		}
   	else
    	{
			ObjectSetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
    	}
   	if (UseFixedTPDistance)
   	{
   	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, false);
   	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTED, false);
   	}
   	else ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, true);
    
		if (StringToDouble(m_EdtTP.Text()) == 0) // Hide.
	   { 
	      m_LblRR.Hide();
	      m_EdtRR1.Hide();
	      m_EdtRR2.Hide();
	      m_LblReward.Hide();
	      m_EdtReward1.Hide();
	      m_EdtReward2.Hide();
			ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
			MoveAndResize(); 
	   }
	   else // Show.
	   {
	      m_LblRR.Show();
	      if (InputRR != "") m_EdtRR1.Show();
	      m_EdtRR2.Show();
	      m_LblReward.Show();
	      m_EdtReward1.Show();
	      m_EdtReward2.Show();
	      if (sets.ShowLines)
	      {
	      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	      	if (ShowLineLabels) ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	     	}

      	// Hides and shows the panel. Needed to put it to the foreground. Maximize() hides internal controls that were hidden before.
      	Hide(); Show(); Maximize();
		} 
		RefreshValues();
	   ChartRedraw();
	}
}

void QCPositionSizeCalculator::OnClickBtnEntry()
{
	// Switch trade type.
	if (sets.TradeType == Buy)
	{
	   sets.TradeType = Sell;

      double old_tp_distance = 0;
      if (sets.TakeProfitLevel > 0) old_tp_distance = sets.TakeProfitLevel - sets.EntryLevel;

      if (sets.EntryType == Instant) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);

      ObjectSetDouble(ChartID(), "StopLossLine", OBJPROP_PRICE, sets.EntryLevel + sets.StopLoss * _Point);

	   if (sets.TakeProfitLevel > 0)
	   {
	      if (UseFixedTPDistance) sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
	      else sets.TakeProfitLevel = sets.EntryLevel - old_tp_distance;
	      ObjectSetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
	   }
	}
	else
	{
	   sets.TradeType = Buy;

      double old_tp_distance = 0;
      if (sets.TakeProfitLevel > 0) old_tp_distance = sets.EntryLevel - sets.TakeProfitLevel;
      if (sets.EntryType == Instant) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

	   ObjectSetDouble(ChartID(), "StopLossLine", OBJPROP_PRICE, tEntryLevel - sets.StopLossLevel * _Point);

	   if (sets.TakeProfitLevel > 0)
	   {

	      if (UseFixedTPDistance) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfitLevel * _Point;
	      else sets.TakeProfitLevel = sets.EntryLevel + old_tp_distance;
	      ObjectSetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
	   }
	}
   m_BtnEntry.Text(EnumToString(sets.TradeType) + " @");
	
	RefreshValues();
   ChartRedraw();
}

void QCPositionSizeCalculator::OnEndEditEdtEntryLevel()
{
   sets.EntryLevel = StringToDouble(m_EdtEntryLevel.Text());
   if (tEntryLevel != sets.EntryLevel)
   {
   	// Check and adjust for TickSize granularity.
   	if (TickSize > 0) sets.EntryLevel = NormalizeDouble(MathRound(sets.EntryLevel / TickSize) * TickSize, _Digits);
   	tEntryLevel = sets.EntryLevel;
   	ObjectSetDouble(ChartID(), "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
   	RefreshValues();
   }
}

void QCPositionSizeCalculator::OnEndEditEdtSL()
{
   if (!UseFixedSLDistance)
   {
   	// Check and adjust for TickSize granularity.
   	if (TickSize > 0) sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
      sets.StopLossLevel = StringToDouble(m_EdtSL.Text());
   }
   else
   {
      if ((int)StringToInteger(m_EdtSL.Text()) <= 0)
      {
         Print("StopLoss should be positive.");
         m_EdtSL.Text(IntegerToString(sets.StopLoss));
      }
      else
      {
         sets.StopLoss = (int)StringToInteger(m_EdtSL.Text());
      	// Check and adjust for TickSize granularity.
      	if (TickSize > 0) sets.StopLoss = (int)MathRound(MathRound(sets.StopLoss * _Point / TickSize) * TickSize / _Point);
      }
      
      if (sets.TradeType == Buy)
         sets.StopLossLevel = NormalizeDouble(sets.EntryLevel + sets.StopLoss * _Point, _Digits);
      else
         sets.StopLossLevel = NormalizeDouble(sets.EntryLevel - sets.StopLoss * _Point, _Digits);
   }
   if (tStopLossLevel != sets.StopLossLevel)
   {
	   tStopLossLevel = sets.StopLossLevel;
	   ObjectSetDouble(ChartID(), "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
	   RefreshValues();
	}
}

void QCPositionSizeCalculator::OnEndEditEdtTP()
{
   if (!UseFixedTPDistance)
   {
   	// Check and adjust for TickSize granularity.
   	if (TickSize > 0) sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
      sets.TakeProfitLevel = StringToDouble(m_EdtTP.Text());
   }
   else 
   {
      sets.TakeProfit = (int)StringToInteger(m_EdtTP.Text());
   	// Check and adjust for TickSize granularity.
   	if (TickSize > 0) sets.TakeProfit = (int)MathRound(MathRound(sets.TakeProfit * _Point / TickSize) * TickSize / _Point);
      if (sets.TakeProfit > 0)
      {
         if (sets.TradeType == Buy)
            sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel - sets.TakeProfit * _Point, _Digits);
         else
            sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel + sets.TakeProfit * _Point, _Digits);
      }
      else sets.TakeProfitLevel = 0;
   }
   
   if (tTakeProfitLevel != sets.TakeProfitLevel)
   {
   	tTakeProfitLevel = sets.TakeProfitLevel;
    	if (ObjectFind(ChartID(), "TakeProfitLine") == -1) 
     	{
      	ObjectCreate(ChartID(), "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
		}
   	else
    	{
			ObjectSetDouble(ChartID(), "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
    	}
   	if (UseFixedTPDistance)
   	{
   	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, false);
   	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTED, false);
   	}
   	else ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, true);
    
		if (StringToDouble(m_EdtTP.Text()) == 0) // Hide.
	   { 
	      m_LblRR.Hide();
	      m_EdtRR1.Hide();
	      m_EdtRR2.Hide();
	      m_LblReward.Hide();
	      m_EdtReward1.Hide();
	      m_EdtReward2.Hide();
			ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
			MoveAndResize(); 
	   }
	   else // Show.
	   {
	      m_LblRR.Show();
	      if (InputRR != "") m_EdtRR1.Show();
	      m_EdtRR2.Show();
	      m_LblReward.Show();
	      m_EdtReward1.Show();
	      m_EdtReward2.Show();
	      if (sets.ShowLines)
	      {
	      	ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	      	if (ShowLineLabels) ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	      	// Hides and shows the panel. Needed to put it to the foreground. Maximize() hides internal controls that were hidden before.
	      	Hide(); Show(); Maximize();
	     	}
		}
		RefreshValues();
	}
}

void QCPositionSizeCalculator::OnEndEditEdtCommissionSize()
{
   if (sets.CommissionPerLot != StringToDouble(m_EdtCommissionSize.Text()))
   {
   	sets.CommissionPerLot = StringToDouble(m_EdtCommissionSize.Text());
   	CalculateRiskAndPositionSize();
   	DisplayValues();
	}
}

void QCPositionSizeCalculator::OnEndEditEdtRiskPIn()
{
   sets.UseMoneyInsteadOfPercentage = false;
   sets.RiskFromPositionSize = false;
   if (sets.Risk != StringToDouble(m_EdtRiskPIn.Text()))
   {
   	sets.Risk = StringToDouble(m_EdtRiskPIn.Text());
   	CalculateRiskAndPositionSize();
	   DisplayValues();
	}
}

void QCPositionSizeCalculator::OnEndEditEdtRiskMIn()
{
   string s_val = m_EdtRiskMIn.Text();
   StringReplace(s_val, ",", "");
   sets.UseMoneyInsteadOfPercentage = true;
   sets.RiskFromPositionSize = false;
   if (sets.MoneyRisk != StringToDouble(s_val))
   {
   	sets.MoneyRisk = StringToDouble(s_val);
   	CalculateRiskAndPositionSize();
   	DisplayValues();
   }
} 

void QCPositionSizeCalculator::OnEndEditEdtPosSize()
{
   sets.RiskFromPositionSize = true;
   
   double d_val = StringToDouble(m_EdtPosSize.Text());
   if (d_val >= 0)
   {
      if (OutputPositionSize != d_val)
      {
      	OutputPositionSize = d_val;
         sets.PositionSize = OutputPositionSize;
      	CalculateRiskAndPositionSize();
      	DisplayValues();
      }
   }
   else m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits));
}

void QCPositionSizeCalculator::OnEndEditATRPeriod()
{
   int i_val = (int)StringToInteger(m_EdtATRPeriod.Text());
   if (i_val > 0)
   {
   	if (sets.ATRPeriod != i_val)
   	{
      	sets.ATRPeriod = i_val;
      	RefreshValues();
      }
      m_EdtATRPeriod.Text(IntegerToString(i_val));
   }
   else m_EdtATRPeriod.Text(IntegerToString(sets.ATRPeriod));
} 

void QCPositionSizeCalculator::OnEndEditATRMultiplierSL()
{
   double d_val = StringToDouble(m_EdtATRMultiplierSL.Text());
   if (d_val >= 0)
   {
   	if (sets.ATRMultiplierSL != d_val)
   	{
      	sets.ATRMultiplierSL = d_val;
      	RefreshValues();
      }
      m_EdtATRMultiplierSL.Text(DoubleToString(d_val, 2));
   }
   else m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
} 

void QCPositionSizeCalculator::OnEndEditATRMultiplierTP()
{
   double d_val = StringToDouble(m_EdtATRMultiplierTP.Text());
   if (d_val >= 0)
   {
   	if (sets.ATRMultiplierTP != d_val)
   	{
      	sets.ATRMultiplierTP = d_val;
      	RefreshValues();
      }
      m_EdtATRMultiplierTP.Text(DoubleToString(d_val, 2));
   }
   else m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
} 

void QCPositionSizeCalculator::OnChangeChkCountPendings()
{
   if (sets.CountPendingOrders != m_ChkCountPendings.Checked())
   {
	   sets.CountPendingOrders = m_ChkCountPendings.Checked();
	   CalculatePortfolioRisk(); 
	   DisplayValues();
	}
}

void QCPositionSizeCalculator::OnChangeChkIgnoreOrders()
{
   if (sets.IgnoreOrdersWithoutStopLoss != m_ChkIgnoreOrders.Checked())
   {
   	sets.IgnoreOrdersWithoutStopLoss = m_ChkIgnoreOrders.Checked();
   	CalculatePortfolioRisk();
   	DisplayValues();
	}
}  
 
void QCPositionSizeCalculator::OnEndEditEdtCustomLeverage()
{
   sets.CustomLeverage = (int)StringToInteger(m_EdtCustomLeverage.Text());
   if (CustomLeverage != sets.CustomLeverage)
   {
   	CustomLeverage = sets.CustomLeverage;
   	RefreshValues();
   }
}

void QCPositionSizeCalculator::OnEndEditEdtMagicNumber()
{
   sets.MagicNumber = (int)StringToInteger(m_EdtMagicNumber.Text());
   if (sets.MagicNumber < 0)
   {
   	sets.MagicNumber = -sets.MagicNumber;
   	m_EdtMagicNumber.Text(IntegerToString(sets.MagicNumber));
   }
}

void QCPositionSizeCalculator::OnEndEditEdtScriptCommentary()
{
   sets.ScriptCommentary = m_EdtScriptCommentary.Text();
}

void QCPositionSizeCalculator::OnChangeChkDisableTradingWhenLinesAreHidden()
{
   sets.DisableTradingWhenLinesAreHidden = m_ChkDisableTradingWhenLinesAreHidden.Checked();
}

void QCPositionSizeCalculator::OnEndEditEdtMaxSlippage()
{
   sets.MaxSlippage = (int)StringToInteger(m_EdtMaxSlippage.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMaxSpread()
{
   sets.MaxSpread = (int)StringToInteger(m_EdtMaxSpread.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMaxEntrySLDistance()
{
   sets.MaxEntrySLDistance = (int)StringToInteger(m_EdtMaxEntrySLDistance.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMinEntrySLDistance()
{
   sets.MinEntrySLDistance = (int)StringToInteger(m_EdtMinEntrySLDistance.Text());
}

void QCPositionSizeCalculator::OnEndEditEdtMaxPositionSize()
{
   sets.MaxPositionSize = (double)StringToDouble(m_EdtMaxPositionSize.Text());
   m_EdtMaxPositionSize.Text(DoubleToString(sets.MaxPositionSize, LotStep_digits));
}

void QCPositionSizeCalculator::OnChangeChkSubtractPositions()
{
   sets.SubtractPositions = m_ChkSubtractPositions.Checked();
}

void QCPositionSizeCalculator::OnChangeChkSubtractPendingOrders()
{
   sets.SubtractPendingOrders = m_ChkSubtractPendingOrders.Checked();
}

//+-----------------------+
//| Working with settings |
//|+----------------------+
bool QCPositionSizeCalculator::SaveSettingsOnDisk()
{
	Print("Trying to save settings to file: " + m_FileName + ".");
   
	int fh;
	fh = FileOpen(m_FileName, FILE_CSV | FILE_WRITE);
	if (fh == INVALID_HANDLE)
	{
		Print("Failed to open file for writing: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
		return(false);
	}

	// Order does not matter.
	FileWrite(fh, "EntryType");
	FileWrite(fh, IntegerToString(sets.EntryType));
	FileWrite(fh, "EntryLevel");
	FileWrite(fh, DoubleToString(sets.EntryLevel, _Digits));
	FileWrite(fh, "StopLossLevel");
	FileWrite(fh, DoubleToString(sets.StopLossLevel, _Digits));
	FileWrite(fh, "TakeProfitLevel");
	FileWrite(fh, DoubleToString(sets.TakeProfitLevel, _Digits));
	FileWrite(fh, "Risk");
	FileWrite(fh, DoubleToString(sets.Risk, 2));
	FileWrite(fh, "MoneyRisk");
	FileWrite(fh, DoubleToString(sets.MoneyRisk, 2));
	FileWrite(fh, "CommissionPerLot");
	FileWrite(fh, DoubleToString(sets.CommissionPerLot, 2));
	FileWrite(fh, "UseMoneyInsteadOfPercentage");
	FileWrite(fh, IntegerToString(sets.UseMoneyInsteadOfPercentage));
	FileWrite(fh, "RiskFromPositionSize");
	FileWrite(fh, IntegerToString(sets.RiskFromPositionSize));
	if (sets.RiskFromPositionSize)
	{
   	FileWrite(fh, "PositionSize");
   	FileWrite(fh, DoubleToString(sets.PositionSize, LotStep_digits));
   }
	FileWrite(fh, "AccountButton");
	FileWrite(fh, IntegerToString(sets.AccountButton));
	FileWrite(fh, "CountPendingOrders");
	FileWrite(fh, IntegerToString(sets.CountPendingOrders));
	FileWrite(fh, "IgnoreOrdersWithoutStopLoss");
	FileWrite(fh, IntegerToString(sets.IgnoreOrdersWithoutStopLoss));
	FileWrite(fh, "ShowLines");
	FileWrite(fh, IntegerToString(sets.ShowLines));
	FileWrite(fh, "SelectedTab");
	FileWrite(fh, IntegerToString(sets.SelectedTab));
	FileWrite(fh, "CustomLeverage");
	FileWrite(fh, IntegerToString(sets.CustomLeverage));
	FileWrite(fh, "MagicNumber");
	FileWrite(fh, IntegerToString(sets.MagicNumber));
	FileWrite(fh, "ScriptCommentary");
	FileWrite(fh, sets.ScriptCommentary);
	FileWrite(fh, "DisableTradingWhenLinesAreHidden");
	FileWrite(fh, IntegerToString(sets.DisableTradingWhenLinesAreHidden));
	FileWrite(fh, "MaxSlippage");
	FileWrite(fh, IntegerToString(sets.MaxSlippage));
	FileWrite(fh, "MaxSpread");
	FileWrite(fh, IntegerToString(sets.MaxSpread));
	FileWrite(fh, "MaxEntrySLDistance");
	FileWrite(fh, IntegerToString(sets.MaxEntrySLDistance));
	FileWrite(fh, "MinEntrySLDistance");
	FileWrite(fh, IntegerToString(sets.MinEntrySLDistance));
	FileWrite(fh, "MaxPositionSize");
	FileWrite(fh, DoubleToString(sets.MaxPositionSize, LotStep_digits));
	FileWrite(fh, "StopLoss");
	FileWrite(fh, IntegerToString(sets.StopLoss));
	FileWrite(fh, "TakeProfit");
	FileWrite(fh, IntegerToString(sets.TakeProfit));
	FileWrite(fh, "TradeType");
	FileWrite(fh, IntegerToString(sets.TradeType));
	FileWrite(fh, "SubtractPositions");
	FileWrite(fh, IntegerToString(sets.SubtractPositions));
	FileWrite(fh, "SubtractPendingOrders");
	FileWrite(fh, IntegerToString(sets.SubtractPendingOrders));
	FileWrite(fh, "ATRPeriod");
	FileWrite(fh, IntegerToString(sets.ATRPeriod));
	FileWrite(fh, "ATRMultiplierSL");
	FileWrite(fh, DoubleToString(sets.ATRMultiplierSL, 2));
	FileWrite(fh, "ATRMultiplierTP");
	FileWrite(fh, DoubleToString(sets.ATRMultiplierTP, 2));
	
   // These are not part of settings but are panel-related input parameters.
   // When indicator is reloaded due to its input parameters change, these should be compared to the new values.
   // If the value is changed, it should be updated in the panel too.
   // Is indicator reloading due to the input parameters change?
   if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Parameters") > 0)
   {
   	FileWrite(fh, "Parameter_Risk");
   	FileWrite(fh, DoubleToString(Risk, 2));
   	FileWrite(fh, "Parameter_EntryType");
   	FileWrite(fh, IntegerToString(EntryType));
   	FileWrite(fh, "Parameter_Commission");
   	FileWrite(fh, DoubleToString(Commission, 2));
   	FileWrite(fh, "Parameter_Commentary");
   	FileWrite(fh, Commentary);
   }

	FileClose(fh);

	Print("Saved settings successfully.");
	return(true);
}

bool QCPositionSizeCalculator::LoadSettingsFromDisk()
{
   Print("Trying to load settings from file.");
   
   if (!FileIsExist(m_FileName))
   {
   	Print("No settings file to load.");
   	return(false);
   }
   
   int fh;
   fh = FileOpen(m_FileName, FILE_CSV | FILE_READ);
   
	if (fh == INVALID_HANDLE)
	{
		Print("Failed to open file for reading: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
		return(false);
	}

	while (!FileIsEnding(fh))
	{
	   string var_name = FileReadString(fh);
	   string var_content = FileReadString(fh);
	   if (var_name == "EntryType")
	   	sets.EntryType = (ENTRY_TYPE)StringToInteger(var_content);
	   else if (var_name == "EntryLevel")
	   	sets.EntryLevel = StringToDouble(var_content);
	   else if (var_name == "StopLossLevel")
	   	sets.StopLossLevel = StringToDouble(var_content);
	   else if (var_name == "TakeProfitLevel")
	   	sets.TakeProfitLevel = StringToDouble(var_content);
	   else if (var_name == "Risk")
	   	sets.Risk = StringToDouble(var_content);
	   else if (var_name == "MoneyRisk")
	   	sets.MoneyRisk = StringToDouble(var_content);
	   else if (var_name == "CommissionPerLot")
	   	sets.CommissionPerLot = StringToDouble(var_content);
	   else if (var_name == "UseMoneyInsteadOfPercentage")
	   	sets.UseMoneyInsteadOfPercentage = (bool)StringToInteger(var_content);
	   else if (var_name == "RiskFromPositionSize")
	   	sets.RiskFromPositionSize = (bool)StringToInteger(var_content);
	   else if ((var_name == "PositionSize") && (sets.RiskFromPositionSize))
	   {
	   	sets.PositionSize = StringToDouble(var_content);
	   	OutputPositionSize = sets.PositionSize;
	   }
	   else if (var_name == "AccountButton")
	   	sets.AccountButton = (ACCOUNT_BUTTON)StringToInteger(var_content);
	   else if (var_name == "CountPendingOrders")
	   	sets.CountPendingOrders = (bool)StringToInteger(var_content);
	   else if (var_name == "IgnoreOrdersWithoutStopLoss")
	   	sets.IgnoreOrdersWithoutStopLoss = (bool)StringToInteger(var_content);
	   else if (var_name == "ShowLines")
	   	sets.ShowLines = (bool)StringToInteger(var_content);
	   else if (var_name == "SelectedTab")
	   	sets.SelectedTab = (TABS)StringToInteger(var_content);
	   else if (var_name == "CustomLeverage")
	   	sets.CustomLeverage = (int)StringToInteger(var_content);
	   else if (var_name == "MagicNumber")
	   	sets.MagicNumber = (int)StringToInteger(var_content);
	   else if (var_name == "ScriptCommentary")
	   	sets.ScriptCommentary = var_content;
	   else if (var_name == "DisableTradingWhenLinesAreHidden")
	   	sets.DisableTradingWhenLinesAreHidden = (bool)StringToInteger(var_content);
	   else if (var_name == "MaxSlippage")
	   	sets.MaxSlippage = (int)StringToInteger(var_content);
	   else if (var_name == "MaxSpread")
	   	sets.MaxSpread = (int)StringToInteger(var_content);
	   else if (var_name == "MaxEntrySLDistance")
	   	sets.MaxEntrySLDistance = (int)StringToInteger(var_content);
	   else if (var_name == "MinEntrySLDistance")
	   	sets.MinEntrySLDistance = (int)StringToInteger(var_content);
	   else if (var_name == "MaxPositionSize")
	   	sets.MaxPositionSize = StringToDouble(var_content);
	   else if (var_name == "TradeType")
	   	sets.TradeType = (TRADE_TYPE)StringToInteger(var_content);
	   else if (var_name == "StopLoss")
	   	sets.StopLoss = (int)StringToInteger(var_content);
	   else if (var_name == "TakeProfit")
	   	sets.TakeProfit = (int)StringToInteger(var_content);
	   else if (var_name == "SubtractPositions")
	   	sets.SubtractPositions = (bool)StringToInteger(var_content);
	   else if (var_name == "SubtractPendingOrders")
	   	sets.SubtractPendingOrders = (bool)StringToInteger(var_content);
	   else if (var_name == "ATRPeriod")
	   	sets.ATRPeriod = (int)StringToInteger(var_content);
	   else if (var_name == "ATRMultiplierSL")
	   	sets.ATRMultiplierSL = StringToDouble(var_content);
	   else if (var_name == "ATRMultiplierTP")
	   	sets.ATRMultiplierTP = StringToDouble(var_content);

      // Is indicator reloading due to the input parameters change?
      if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Parameters") > 0)
      {
         // These are not part of settings but are panel-related input parameters.
         // When indicator is reloaded due to its input parameters change, these should be compared to the new values.
         // If the value is changed, it should be updated in the panel too.
   	   if (var_name == "Parameter_Risk")
   	   {
   	   	if (StringToDouble(var_content) != Risk) sets.Risk = Risk;
   	   }
   	   else if (var_name == "Parameter_EntryType")
   	   {
   	   	if ((ENTRY_TYPE)StringToInteger(var_content) != EntryType) sets.EntryType = EntryType;
   	   }
   	   else if (var_name == "Parameter_Commission")
   	   {
   	   	if (StringToDouble(var_content) != Commission) sets.CommissionPerLot = Commission;
   	   }
   	   else if (var_name == "Parameter_Commentary")
   	   {
   	   	if (var_content != Commentary) sets.ScriptCommentary = Commentary;   	   	
   	   }
      }
	}

   FileClose(fh);
   Print("Loaded settings successfully.");

   // Is indicator reloading due to the input parameters change? Delete the flag variable.
   if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Parameters") > 0) GlobalVariableDel("PSC-" + IntegerToString(ChartID()) + "-Parameters");

   return(true); 
} 

bool QCPositionSizeCalculator::DeleteSettingsFile()
{
   if (!FileIsExist(m_FileName))
   {
	   Print("No settings file to delete.");
   	return(false);
   }
   Print("Trying to delete settings file.");
   if (!FileDelete(m_FileName))
   {
   	Print("Failed to delete file: " + m_FileName + ". Error: " + IntegerToString(GetLastError()));
   	return(false);
   }
   Print("Deleted settings file successfully.");
   return(true);
} 
 
void QCPositionSizeCalculator::HideShowMaximize(bool max = true)
{
   // Remember the panel's location.
   remember_left = Left();
   remember_top = Top();

	Hide();
	Show();
	if (!max) NoPanelMaximization = true;
	else NoPanelMaximization = false;
	Maximize();
}
 
//+------------------------------------------------------------------+
//| Extends CAppDialog::IniFileName() to prevent problems with       |
//| trading instruments containing more than one dot in their name.  |
//+------------------------------------------------------------------+
string QCPositionSizeCalculator::IniFileName(void) const
{
   string name = CAppDialog::IniFileName();
   StringReplace(name, ".", "_dot_");
   return(name);
}

//+------------------------------------------------+
//|                                                |
//|              Calculation Functions             |
//|                                                |
//+------------------------------------------------+

//==================================================================================================================
// Used in more than one function.
double Size, OutputRiskMoney;
double OutputPositionSize, OutputMaxPositionSize;
double StopLoss;
double tEntryLevel, tStopLossLevel, tTakeProfitLevel;
// -1 because it is checked in the initialization function.
double TickSize = -1, MarginHedging, LotSize, MinLot, MaxLot, LotStep;
int AccStopoutMode, AccStopoutLevel, LotStep_digits;
int CustomLeverage = 0;
double SymbolLeverage = 1;
bool StopOut;

//----
string WarningEntry = "", WarningSL = "", WarningTP = "";
double DisplayRisk, RiskMoney, PositionMargin, UsedMargin, FutureMargin, PreHedgingPositionMargin, PortfolioLossMoney = 0;
string InputRR, OutputRR, PLM, CPR, PRM, CPRew, PPMR, PPR, PPMRew, PPRew, CPL, PPL; 
string InputReward;
double OutputReward;
string OutputPipValue = "", OutputSwapsType = "Unknown", SwapsTripleDay = "?",
OutputSwapsDailyLongLot = "?", OutputSwapsDailyShortLot = "?", OutputSwapsDailyLongPS = "?", OutputSwapsDailyShortPS = "?",
OutputSwapsYearlyLongLot = "?", OutputSwapsYearlyShortLot = "?", OutputSwapsYearlyLongPS = "?", OutputSwapsYearlyShortPS = "?",
OutputSwapsCurrencyDailyLot = "", OutputSwapsCurrencyDailyPS = "", OutputSwapsCurrencyYearlyLot = "", OutputSwapsCurrencyYearlyPS = "";
string ProfitCurrency, account_currency, ReferenceSymbol = NULL;
bool ReferenceSymbolMode;
int ProfitCalcMode;

//==================================================================================================================
//+----------------------+
//| Will be called once. |
//+----------------------+
void Initialization()
{
   if ((sets.EntryLevel == 0) && (sets.StopLossLevel == 0))
   {
      sets.EntryLevel = High[0];
      if (DefaultSL > 0) sets.StopLossLevel = sets.EntryLevel - DefaultSL * _Point;
      else sets.StopLossLevel = Low[0];
      if (DefaultTP > 0) sets.TakeProfitLevel = sets.EntryLevel + DefaultTP * _Point;
      if (sets.EntryLevel == sets.StopLossLevel) sets.StopLossLevel -= Point;
      if ((UseFixedSLDistance) && (sets.StopLoss == 0)) sets.StopLoss = (int)MathRound(MathAbs((sets.EntryLevel - sets.StopLossLevel) / _Point));
   }
   // Loaded template with TP line - delete the line.
   if ((sets.TakeProfit == 0) && (sets.TakeProfitLevel == 0) && (ObjectFind(0, "TakeProfitLine") == 0))
   {
      ObjectDelete(0, "TakeProfitLine");
      if (ObjectFind(0, "TakeProfitLabel") == 0) ObjectDelete(0, "TakeProfitLabel");
   }
   // Using TP distance in pips but just switched from the TP given as a level on an already attached indicator.
   if ((UseFixedTPDistance) && (sets.TakeProfit == 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.TakeProfitLevel - sets.EntryLevel) / _Point));
   if (sets.EntryLevel - sets.StopLossLevel == 0)
   {
      Alert("Entry and Stop-Loss levels should be different and non-zero.");
      return;
   }

   if (sets.EntryType == Instant)
   {
      RefreshRates();
      if ((Ask > 0) && (Bid > 0))
      {
         // SL got inside Ask/Bid range.
         if ((sets.StopLossLevel >= Bid) && (sets.StopLossLevel <= Ask)) sets.StopLossLevel = Bid - Point;
         // Long entry
         if (sets.StopLossLevel < Bid) sets.EntryLevel = Ask;
         // Short entry
         else if (sets.StopLossLevel > Ask) sets.EntryLevel = Bid;
         if (DefaultSL > 0) sets.StopLossLevel = sets.EntryLevel - DefaultSL * _Point;
         if (DefaultTP > 0) sets.TakeProfitLevel = sets.EntryLevel + DefaultTP * _Point;
         if ((UseFixedSLDistance) && (sets.StopLoss == 0)) sets.StopLoss = (int)MathRound(MathAbs((sets.EntryLevel - sets.StopLossLevel) / _Point));
      }
   }

   if (ObjectFind("EntryLine") == -1) ObjectCreate("EntryLine", OBJ_HLINE, 0, TimeCurrent(), sets.EntryLevel);
   else ObjectSetDouble(0, "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
   ObjectSet("EntryLine", OBJPROP_STYLE, entry_line_style);
   ObjectSet("EntryLine", OBJPROP_COLOR, entry_line_color);
   ObjectSet("EntryLine", OBJPROP_WIDTH, entry_line_width);
   if (sets.EntryType == Instant) ObjectSet("EntryLine", OBJPROP_SELECTABLE, false);
   else ObjectSet("EntryLine", OBJPROP_SELECTABLE, true);

   if (ObjectFind("StopLossLine") == -1) ObjectCreate("StopLossLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopLossLevel);
   else ObjectSetDouble(0, "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
   ObjectSet("StopLossLine", OBJPROP_STYLE, stoploss_line_style);
   ObjectSet("StopLossLine", OBJPROP_COLOR, stoploss_line_color);
   ObjectSet("StopLossLine", OBJPROP_WIDTH, stoploss_line_width);
	if (UseFixedSLDistance)
	{
	   ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_SELECTABLE, false);
	   ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_SELECTED, false);
	}
	else ObjectSetInteger(ChartID(), "StopLossLine", OBJPROP_SELECTABLE, true);
   StopLoss = MathAbs(sets.EntryLevel - sets.StopLossLevel);

   if (ShowLineLabels)
   {
   	ObjectCreate("StopLossLabel", OBJ_LABEL, 0, 0, 0);
	   if (sets.ShowLines) ObjectSetInteger(ChartID(), "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	   else ObjectSetInteger(ChartID(), "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
   	ObjectSet("StopLossLabel", OBJPROP_COLOR, clrNONE);
   	ObjectSet("StopLossLabel", OBJPROP_SELECTABLE, false);
   	ObjectSet("StopLossLabel", OBJPROP_HIDDEN, false);
	   ObjectSet("StopLossLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
		ObjectSet("StopLossLabel", OBJPROP_BACK, DrawTextAsBackground);
	}
	
	if (ObjectFind("TakeProfitLine") == -1) 
	{
	   ObjectCreate("TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
	   if (sets.TakeProfitLevel > 0) ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	   else ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
	}
   ObjectSet("TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
   ObjectSet("TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
   ObjectSet("TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
	if (UseFixedTPDistance)
	{
	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, false);
	   ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTED, false);
	}
	else ObjectSetInteger(ChartID(), "TakeProfitLine", OBJPROP_SELECTABLE, true);
   if ((ShowLineLabels) && (ObjectFind("TakeProfitLabel") == -1))
   {
   	ObjectCreate("TakeProfitLabel", OBJ_LABEL, 0, 0, 0);
	   if ((sets.TakeProfitLevel > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	   else ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
   	ObjectSet("TakeProfitLabel", OBJPROP_COLOR, clrNONE);
   	ObjectSet("TakeProfitLabel", OBJPROP_SELECTABLE, false);
   	ObjectSet("TakeProfitLabel", OBJPROP_HIDDEN, false);
	   ObjectSet("TakeProfitLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
	   ObjectSet("TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
	}
   
   if (!HideAccSize)
   {
	   switch(sets.AccountButton)
	   {
	      default:
	      case Balance:
	      	Size = AccountBalance();
	      	break;
	      case Equity:
	      	Size = AccountEquity();
	      	break;
	      case Balance_minus_Risk:
	      	if (PortfolioLossMoney != DBL_MAX) Size = AccountBalance() - PortfolioLossMoney;
	      	else Size = AccountBalance();
	      	break;
	   }
	}
	else Size = AccountBalance();
	Size += AdditionalFunds;
	  
   ChartSetInteger(0, CHART_FOREGROUND, !PanelOnTopOfChart);
   
   RecalculatePositionSize();
}

//+------------------------------------------------------------------+
//| Main recalculation function used on every tick and on entry/SL   |
//| line drag.                                                       |
//+------------------------------------------------------------------+
void RecalculatePositionSize()
{
   // Update Entry to Ask/Bid if needed.
   RefreshRates();
   WarningEntry = "";
   WarningSL    = "";
   WarningTP    = "";
   if (sets.EntryType == Instant)
   {
      if ((Ask > 0) && (Bid > 0))
      {
         if (sets.ShowLines)
            tStopLossLevel = Round(ObjectGet("StopLossLine", OBJPROP_PRICE1), _Digits); 
         else
            tStopLossLevel = sets.StopLossLevel;
            
         // Long entry
         if (tStopLossLevel < Bid) tEntryLevel = Ask;
         // Short entry
         else if (tStopLossLevel > Ask) tEntryLevel = Bid;
         // Undefined entry
         else
         {
            // Move tEntryLevel to the nearest line.
            if ((tEntryLevel - Bid) < (tEntryLevel - Ask)) tEntryLevel = Bid;
            else tEntryLevel = Ask;
         }
			ObjectSet("EntryLine", OBJPROP_PRICE1, tEntryLevel);
      }
   }
   
   if (sets.EntryLevel - sets.StopLossLevel == 0) return;

   // If could not find account currency, probably not connected.
   if ((AccountCurrency() == "") || (!TerminalInfoInteger(TERMINAL_CONNECTED))) return;
   
   if (TickSize == -1) // Run only once.
   {
      GetSymbolAndAccountData();
   }
   
	tEntryLevel       = Round(ObjectGet("EntryLine", OBJPROP_PRICE1), _Digits);
	tStopLossLevel    = Round(ObjectGet("StopLossLine", OBJPROP_PRICE1), _Digits);
	tTakeProfitLevel  = Round(ObjectGet("TakeProfitLine", OBJPROP_PRICE1), _Digits);

   if (ShowLineLabels)
   {
   	DrawPipsDifference("StopLossLabel", tStopLossLevel, tEntryLevel, sl_label_font_color);
	   if (sets.ShowLines) ObjectSetInteger(ChartID(), "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
   	else ObjectSetInteger(ChartID(), "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
   	if (tTakeProfitLevel > 0)
   	{
   		DrawPipsDifference("TakeProfitLabel", tTakeProfitLevel, tEntryLevel, tp_label_font_color);
		   if (sets.ShowLines) ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
	   	else ObjectSetInteger(ChartID(), "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
   	}
  	}
  	
  	double StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) * _Point;
   double AskBid = 0;
   if (sets.EntryType == Instant)
   {
      if ((tStopLossLevel < Ask) && (tStopLossLevel > Bid)) WarningSL = "(Wrong value!)";
      else if (tStopLossLevel < Ask) AskBid = Ask;
      else if (tStopLossLevel > Bid) AskBid = Bid;
   }
   else if (sets.EntryType == Pending)
   {
      if (tStopLossLevel < tEntryLevel)  AskBid = Ask;
      else if (tStopLossLevel > tEntryLevel) AskBid = Bid;
      if (AskBid)
      {
         if (MathAbs(AskBid - tEntryLevel) < StopLevel) WarningEntry = "(Too close!)";
      }
      else WarningSL = "(Wrong value!)";
   }
   
   if ((WarningSL == "") && (MathAbs(tStopLossLevel - tEntryLevel) < StopLevel)) WarningSL = "(Too close!)";
   
   if (tTakeProfitLevel > 0)
   {
      if (MathAbs(tTakeProfitLevel - tEntryLevel) < StopLevel) WarningTP = "(Too close!)";
      
   }
   StopLoss = MathAbs(tEntryLevel - tStopLossLevel);
   if (StopLoss == 0)
   {
      Print("Stop-loss should be different from Entry.");
      return;
   }

   switch(sets.AccountButton)
   {
      default:
      case Balance:
      	Size = AccountBalance();
      	break;
      case Equity:
      	Size = AccountEquity();
      	break;
      case Balance_minus_Risk:
      	if (PortfolioLossMoney != DBL_MAX) Size = AccountBalance() - PortfolioLossMoney;
      	else Size = AccountBalance();
      	break;
   }
   Size += AdditionalFunds;

   CalculateRiskAndPositionSize();
   
   CalculateSymbolLeverage();

  	GetSwapData();
}

//+------------------------------------------------------------------+
//| Gets basic info on Symbol and Account. It remains unchanged.     |
//+------------------------------------------------------------------+
void GetSymbolAndAccountData()
{
   TickSize = MarketInfo(Symbol(), MODE_TICKSIZE);
   MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   LotStep_digits = CountDecimalPlaces(LotStep);
   MarginHedging = MarketInfo(Symbol(), MODE_MARGINHEDGED);
   LotSize = MarketInfo(Symbol(), MODE_LOTSIZE);
   AccStopoutMode = AccountStopoutMode();
   AccStopoutLevel = AccountStopoutLevel();
   SwapsTripleDay = EnumToString((ENUM_DAY_OF_WEEK)SymbolInfoInteger(Symbol(), SYMBOL_SWAP_ROLLOVER3DAYS));
   string lowercase_part = StringSubstr(SwapsTripleDay, 1);
   StringToLower(lowercase_part);
   SwapsTripleDay = CharToString((uchar)SwapsTripleDay[0]) + lowercase_part;
   ProfitCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
   account_currency = AccountCurrency();
   ProfitCalcMode = (int)MarketInfo(Symbol(), MODE_PROFITCALCMODE);
}

//+-----------------------------------------------------------------------------------+
//| Calculates necessary adjustments for cases when ProfitCurrency != AccountCurrency.|
//+-----------------------------------------------------------------------------------+
double CalculateAdjustment(const ENUM_ORDER_TYPE dir)
{
   if (ReferenceSymbol == NULL)
   {
      ReferenceSymbol = GetSymbolByCurrencies(ProfitCurrency, account_currency);
      ReferenceSymbolMode = true;
      // Failed.
      if (ReferenceSymbol == NULL)
      {
         // Reversing currencies.
         ReferenceSymbol = GetSymbolByCurrencies(account_currency, ProfitCurrency);
         ReferenceSymbolMode = false;
      }
      if (ReferenceSymbol == NULL)
      {
         Print("Error. Cannot detect proper currency pair for adjustment calculation.");
         return(1);
      }
   }
   MqlTick tick;
   SymbolInfoTick(ReferenceSymbol, tick);
   return(GetCurrencyCorrectionCoefficient(dir, tick));
}

//+---------------------------------------------------------------------------+
//| Returns a currency pair with specified base currency and profit currency. |
//+---------------------------------------------------------------------------+
string GetSymbolByCurrencies(string base_currency, string profit_currency)
{
   // Cycle through all symbols.
   for (int s = 0; s < SymbolsTotal(false); s++)
   {
      // Get symbol name by number.
      string symbolname = SymbolName(s, false);

      // Get its base currency.
      string b_cur = SymbolInfoString(symbolname, SYMBOL_CURRENCY_BASE);

      // Get its profit currency.
      string p_cur = SymbolInfoString(symbolname, SYMBOL_CURRENCY_PROFIT);

      // If the currency pair matches both currencies, select it in Market Watch and return its name.
      if ((b_cur == base_currency) && (p_cur == profit_currency))
      {
         // Select if necessary.
         if (!(bool)SymbolInfoInteger(symbolname, SYMBOL_SELECT)) SymbolSelect(symbolname, true);
         
         return(symbolname);
      }
   }
   return(NULL);
}

//+------------------------------------------------------------------+
//| Get profit correction coefficient based on profit currency,      |
//| trade direction, and current prices.                             |
//+------------------------------------------------------------------+
double GetCurrencyCorrectionCoefficient(const ENUM_ORDER_TYPE dir, MqlTick &tick)
{
   if ((tick.ask == 0) || (tick.bid == 0)) return(-1); // Data is not yet ready.
   if (dir == OP_BUY)
   {
      // Reverse quote.
      if (ReferenceSymbolMode)
      {
         // Using Buy price for reverse quote.
         return(tick.ask);
      }
      // Direct quote.
      else
      {
         // Using Sell price for direct quote.
         return(1 / tick.bid);
      }
   }
   else if (dir == OP_SELL)
   {
      // Reverse quote.
      if (ReferenceSymbolMode)
      {
         // Using Sell price for reverse quote.
         return(tick.bid);
      }
      // Direct quote.
      else
      {
         // Using Buy price for direct quote.
         return(1 / tick.ask);
      }
   }
   return(-1);
}

//+------------------------------------------------------------------+
//| Calculates risk size and position size. Sets object values.      |
//+------------------------------------------------------------------+
void CalculateRiskAndPositionSize()
{
   double PositionSize = 0;
   DisplayRisk = sets.Risk;
   if (!sets.UseMoneyInsteadOfPercentage)
   {
      RiskMoney = RoundDown(Size * sets.Risk / 100, 2);
   }
   else
   {
      RiskMoney = sets.MoneyRisk;
      if (Size != 0) DisplayRisk = Round(sets.MoneyRisk / Size * 100, 2);
      else DisplayRisk = 0;
   }

   double UnitCost = MarketInfo(Symbol(), MODE_TICKVALUE);

   ENUM_ORDER_TYPE dir;
   if (tStopLossLevel < tEntryLevel) dir = OP_BUY;
   else if (tStopLossLevel > tEntryLevel) dir = OP_SELL;
   else return;

   // If profit currency is different from account currency and Symbol is not a Forex pair (CFD or futures).
   if ((ProfitCurrency != account_currency) && (ProfitCalcMode > 0))
   {
      double CCC = CalculateAdjustment(dir);
      // Adjust the unit cost.
      UnitCost *= CCC;
   }

   if ((StopLoss != 0) && (UnitCost != 0) && (TickSize != 0))
   {
      if (sets.RiskFromPositionSize)
      {
         RiskMoney = Round(OutputPositionSize * (StopLoss * UnitCost / TickSize + 2 * sets.CommissionPerLot), 2);
         sets.MoneyRisk = RiskMoney;
         if (Size != 0) DisplayRisk = Round(sets.MoneyRisk / Size * 100, 2);
         else DisplayRisk = 0;
         PositionSize = OutputPositionSize;
      }
      else
      {
         PositionSize = RoundDown(RiskMoney / (StopLoss * UnitCost / TickSize + 2 * sets.CommissionPerLot), 2);
         OutputPositionSize = PositionSize;
      }
   }      
   
   if (PositionSize < MinLot) OutputPositionSize = MinLot;
   else if (PositionSize > MaxLot) OutputPositionSize = MaxLot;
   double steps = 0;
   if (LotStep != 0) steps = OutputPositionSize / LotStep;
   if (MathFloor(steps) < steps) OutputPositionSize = MathFloor(steps) * LotStep;
   
   if (TickSize == 0) return;
   OutputRiskMoney = Round((StopLoss * UnitCost / TickSize + 2 * sets.CommissionPerLot) * OutputPositionSize, 2);
   
   if (ShowPipValue)
   {
      OutputPipValue = FormatDouble(DoubleToString(OutputPositionSize * UnitCost, 2));
   }
   
   if (tTakeProfitLevel > 0)
   {
      OutputReward = RoundDown((MathAbs((tTakeProfitLevel - tEntryLevel) * UnitCost / TickSize) - 2 * sets.CommissionPerLot) * OutputPositionSize, 2);
      // Have valid take-profit level that is above entry for SL below entry, or below entry for SL above entry.
      if ((((tTakeProfitLevel > tEntryLevel) && (tEntryLevel > tStopLossLevel)) || ((tTakeProfitLevel < tEntryLevel) && (tEntryLevel < tStopLossLevel))) && (OutputRiskMoney != 0))
      {
         InputRR = DoubleToString(RoundDown(MathAbs((tTakeProfitLevel - tEntryLevel) / StopLoss), 2), 2);
         OutputRR = DoubleToString(RoundDown(OutputReward / OutputRiskMoney, 2), 2);
      }
      else
      {
         InputRR = "Invalid TP";
         OutputRR = InputRR;
      }
      if (OutputRR == InputRR) InputRR = "";
   }
   
   InputReward = DoubleToString(RoundDown(RiskMoney * MathAbs(tTakeProfitLevel - tEntryLevel) / StopLoss, 2), 2);
   
   CalculatePortfolioRisk();
   CalculateMargin();
}

//+------------------------------------------------------------------+
//| Calculates risk size and position size. Sets object values.      |
//+------------------------------------------------------------------+
void CalculatePortfolioRisk()
{
   PortfolioLossMoney = 0;
   double PortfolioRewardMoney = 0;
   double volume = 0;
   int total = OrdersTotal();
   for (int i = 0; i < total; i++)
   {
      double PipsLoss = 0;
      double PipsReward = 0;
      // Select an order.
      if (!OrderSelect(i, SELECT_BY_POS)) continue;

      // Buy
      if ((OrderType() == ORDER_TYPE_BUY) || (((OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP)) && (sets.CountPendingOrders)))
      {
         if (OrderStopLoss() == 0)
         {
            // Losing all the current value.
            if (!sets.IgnoreOrdersWithoutStopLoss) PipsLoss = OrderOpenPrice();
         }
         else
         {
            PipsLoss = OrderOpenPrice() - OrderStopLoss();
         }
         if (OrderTakeProfit() == 0)
         {
            // Potential reward is infinite.
            if (!sets.IgnoreOrdersWithoutStopLoss) PipsReward = DBL_MAX;
         }
         else
         {
            PipsReward = OrderTakeProfit() - OrderOpenPrice();
         }
         volume += OrderLots();
      }
      // Sell
      else if ((OrderType() == ORDER_TYPE_SELL) || (((OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP)) && (sets.CountPendingOrders)))
      {
         if (OrderStopLoss() == 0)
         {
            // Potential loss is infinite.
            if (!sets.IgnoreOrdersWithoutStopLoss) PipsLoss = DBL_MAX;
         }
         else
         {
            PipsLoss = OrderStopLoss() - OrderOpenPrice();
         }
         if (OrderTakeProfit() == 0)
         {
            // Gaining all way down.
            if (!sets.IgnoreOrdersWithoutStopLoss) PipsReward = OrderOpenPrice();
         }
         else
         {
            PipsReward = OrderOpenPrice() - OrderTakeProfit();
         }
         volume += OrderLots();
      }
      
      if ((PipsLoss != DBL_MAX) && (PortfolioLossMoney != DBL_MAX))
      {
         double UnitCost = MarketInfo(OrderSymbol(), MODE_TICKVALUE);
         double TickSize_local = MarketInfo(OrderSymbol(), MODE_TICKSIZE);
         if (TickSize_local == 0)
         {
         	Print("Cannot retrieve tick size for ", OrderSymbol(), ". Looks like the instrument is no longer available. Calculation may not be accurate.");
         }
         else
         {
         	PortfolioLossMoney += OrderLots() * PipsLoss * UnitCost / TickSize_local;
        	}
      }
      else
      {
         // Infinite loss.
         PortfolioLossMoney = DBL_MAX;
      }
      
      if ((PipsReward != DBL_MAX) && (PortfolioRewardMoney != DBL_MAX))
      {
         double UnitCost = MarketInfo(OrderSymbol(), MODE_TICKVALUE);
         double TickSize_local = MarketInfo(OrderSymbol(), MODE_TICKSIZE);
         if (TickSize_local == 0)
         {
         	Print("Cannot retrieve tick size for ", OrderSymbol(), ". Looks like the instrument is no longer available. Calculation may not be accurate.");
         }
         else
         {
         	PortfolioRewardMoney += OrderLots() * PipsReward * UnitCost / TickSize_local;
        	}
      }
      else
      {
         // Infinite profit.
         PortfolioRewardMoney = DBL_MAX;
      }
   }
   
   // If account size did not load yet.
   if (Size == 0) return;

   if (PortfolioLossMoney == DBL_MAX) PLM = "      Infinity";
   else PLM = FormatDouble(DoubleToString(PortfolioLossMoney, 2));
   
   if (PortfolioLossMoney == DBL_MAX) CPR = "      Infinity";
   else CPR = FormatDouble(DoubleToString(PortfolioLossMoney / Size * 100, 2));

   if (PortfolioLossMoney == DBL_MAX) PPMR = "      Infinity";
   else PPMR = FormatDouble(DoubleToString(PortfolioLossMoney + OutputRiskMoney, 2));

   if (PortfolioLossMoney == DBL_MAX) PPR = "      Infinity";
   else PPR = FormatDouble(DoubleToString((PortfolioLossMoney + OutputRiskMoney) / Size * 100, 2));
   
   if (PortfolioRewardMoney == DBL_MAX) PRM = "      Infinity";
   else PRM = FormatDouble(DoubleToString(PortfolioRewardMoney, 2));
   
   if (PortfolioRewardMoney == DBL_MAX) CPRew = "      Infinity";
   else CPRew = FormatDouble(DoubleToString(PortfolioRewardMoney / Size * 100, 2));

   if (PortfolioRewardMoney == DBL_MAX) PPMRew = "      Infinity";
   else PPMRew = FormatDouble(DoubleToString(PortfolioRewardMoney + OutputReward, 2));

   if (PortfolioRewardMoney == DBL_MAX) PPRew = "      Infinity";
   else PPRew = FormatDouble(DoubleToString((PortfolioRewardMoney + OutputReward) / Size * 100, 2));

   CPL = FormatDouble(DoubleToString(volume, LotStep_digits), LotStep_digits);
   PPL = FormatDouble(DoubleToString(volume + OutputPositionSize, LotStep_digits), LotStep_digits);
}

//+------------------------------------------------------------------+
//| Calculates margin before and after position.                     |
//+------------------------------------------------------------------+
void CalculateMargin()
{
   int dir;
   if (tStopLossLevel < tEntryLevel) dir = OP_BUY;
   else if (tStopLossLevel > tEntryLevel) dir = OP_SELL;
   else return;

   double Margin1Lot = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
   double ContractSize = LotSize;
   
	// If custom leverage is given via panel's input.
	if (CustomLeverage > 0)
	{
		double symbol_cost_1_lot;
		if (sets.EntryType == Pending)
			symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * sets.EntryLevel / SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
		else symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
		Margin1Lot = symbol_cost_1_lot / CustomLeverage;
	}

   double HedgedRatio = MarginHedging / ContractSize;
   PositionMargin = OutputPositionSize * Margin1Lot;

	// Maximum position size allowed by current margin.
	double MaxPositionSizeByMargin = -1;
	// Maximum position margin tolerable before stop-out.
	double MaxPositionMargin = AccountFreeMargin();
   // Percentage mode.
   if (AccStopoutMode == 0)
   {
      // Slightly above account stop-out level.
      double ML = AccStopoutLevel + 0.01;
      if (ML > 0) MaxPositionMargin = 100 * AccountEquity() / ML - AccountMargin();
   }
   // Absolute value mode.
   else
   {
      // Slightly above account stop-out level.
      MaxPositionMargin = AccStopoutLevel + 0.01;
   }
   if (AccountFreeMargin() - MaxPositionMargin < 0) MaxPositionMargin = AccountFreeMargin();
   
   // Needed in another function to calculate symbol leverage.
   PreHedgingPositionMargin = PositionMargin;
   
   // Hedging on partial or no margin.
   if (NormalizeDouble(HedgedRatio, 2) < 1.00)
   {
      // Cycle through all open orders on this Symbol to find directional volume.
      double volume = 0;
      int type = -1;
      int total = OrdersTotal();
      for (int i = 0; i < total; i++)
      {
         if (!OrderSelect(i, SELECT_BY_POS)) continue;
   
         if (OrderSymbol() != Symbol()) continue;
         
         if (OrderType() == OP_BUY)
         {
            if (type == OP_BUY) volume += OrderLots();
            else if (type == OP_SELL)
            {
               volume -= OrderLots();
               if (volume < 0)
               {
                  type = OP_BUY;
                  volume = -volume;
               }
            }
            else if (type == -1)
            {
               volume = OrderLots();
               type = OP_BUY;
            }
         }
         else if (OrderType() == OP_SELL)
         {
            if (type == OP_SELL) volume += OrderLots();
            else if (type == OP_BUY)
            {
               volume -= OrderLots();
               if (volume < 0)
               {
                  type = OP_SELL;
                  volume = -volume;
               }
            }
            else if (type == -1)
            {
               volume = OrderLots();
               type = OP_SELL;
            }
         }
      }
      // There is position to hedge and new position is in opposite direction.
      if ((volume > 0) && (type != dir))
      {
         double calculated_volume;
         if (OutputPositionSize <= volume) calculated_volume = OutputPositionSize * (HedgedRatio - 1);
         else calculated_volume = volume * HedgedRatio + OutputPositionSize - 2 * volume;

         PositionMargin = calculated_volume * Margin1Lot;
         
         // Calculations for maximum position size:
         // 1. Find maximum position size for a given maximum position margin if the size is kept less than or equal to existing opposite volume.
         for (MaxPositionSizeByMargin = 0; MaxPositionSizeByMargin <= volume; MaxPositionSizeByMargin += LotStep)
         {
         	if ((HedgedRatio - 1) * MaxPositionSizeByMargin * Margin1Lot > MaxPositionMargin)
         	{
         		MaxPositionSizeByMargin -= LotStep;
         		break;
         	}
         }
         // 2. Find maximum position size for a given maximum position margin if the size is greater than existing opposite volume.
         double MPS_gv = 0;
         if (Margin1Lot != 0) MPS_gv = MaxPositionMargin / Margin1Lot - volume * (HedgedRatio - 2);
         if (MPS_gv > MaxPositionSizeByMargin) MaxPositionSizeByMargin = MPS_gv;
      }
   }
   
   // Was not found using partial hedge method.
   if ((MaxPositionSizeByMargin == -1) && (Margin1Lot != 0)) MaxPositionSizeByMargin = MaxPositionMargin / Margin1Lot;
	
	MaxPositionSizeByMargin = RoundDown(MaxPositionSizeByMargin, 2);
	   
   OutputMaxPositionSize = MaxPositionSizeByMargin;
   if (MaxPositionSizeByMargin < MinLot) OutputMaxPositionSize = MinLot;
   else if (MaxPositionSizeByMargin > MaxLot) OutputMaxPositionSize = MaxLot;
   double steps = 0;
   if (LotStep != 0) steps = OutputMaxPositionSize / LotStep;
   if (MathFloor(steps) < steps) OutputMaxPositionSize = MathFloor(steps) * LotStep;
   
   UsedMargin = AccountMargin() + PositionMargin;
  
	StopOut = false;
   FutureMargin = RoundDown(AccountFreeMargin() - PositionMargin, 2);
  
   // Percentage mode.
   if (AccStopoutMode == 0)
   {
      double ML = 0;
      
      if (UsedMargin != 0) ML = AccountEquity() / UsedMargin * 100;
      if ((ML > 0) && (ML <= AccStopoutLevel)) StopOut = true;
   }
   // Absolute value mode.
   else
   {
      if (FutureMargin <= AccStopoutLevel) StopOut = true;
   }
   
   if (FutureMargin < 0) StopOut = true;
}

//+------------------------------------------------------------------+
//| Gets info on overnight swaps.     											|
//+------------------------------------------------------------------+
void GetSwapData()
{
   int swap_type = (int)MarketInfo(Symbol(), MODE_SWAPTYPE);
   double swap_long = MarketInfo(Symbol(), MODE_SWAPLONG);
   double swap_short = MarketInfo(Symbol(), MODE_SWAPSHORT);
   double swap_long_1_lot = EMPTY_VALUE, swap_short_1_lot = EMPTY_VALUE;
   switch(swap_type)
   {
   	// Pips
   	case 0:
   	{
   		double tick_value = MarketInfo(Symbol(), MODE_TICKVALUE);
   		double tick_value_long = tick_value;
   		double tick_value_short = tick_value;
         // If profit currency is different from account currency and Symbol is not a Forex pair (CFD or futures).
         if ((ProfitCurrency != account_currency) && (ProfitCalcMode > 0))
         {
            double CCC = CalculateAdjustment(OP_BUY);
            // Adjust the unit cost.
            tick_value_long *= CCC;
            CCC = CalculateAdjustment(OP_SELL);
            tick_value_short *= CCC;
         }
   		OutputSwapsType = "Pips";
   		swap_long_1_lot = swap_long * tick_value_long;
   		swap_short_1_lot = swap_short * tick_value_short;
   	}
   		break;
   	// Base currency
   	case 1:
   	{
   		string base_currency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
   		OutputSwapsType = "Base currency (" + base_currency + ")";
   		// Simple case:
   		if (account_currency == base_currency)
   		{
   			swap_long_1_lot = swap_long;
   			swap_short_1_lot = swap_short;
   		}
   		// Need to find the current BAS/ACC or ACC/BAS rate.
   		else
   		{
   			string profit_currency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
   			// Simple case - use Symbol rates for conversion:
   			if (account_currency == profit_currency)
   			{
					if (sets.EntryType == Instant)
					{
						swap_long_1_lot = swap_long * Bid;
						swap_short_1_lot = swap_short * Bid;
					}
					// For pending orders, we may use the pending order's open price for calculation.
					else
					{
						swap_long_1_lot = swap_long * sets.EntryLevel;
						swap_short_1_lot = swap_short * sets.EntryLevel;
					}
   			}
   			// Go through Market Watch trying to find the currency pair with both base_currency and account_currency in it.
   			else
   			{
   				// Number of symbols in Market Watch (even if they are not visible there).
   				int symbols_total = SymbolsTotal(false);
   				for (int i = 0; i < symbols_total; i++)
   				{
   					string symbol = SymbolName(i, false);
		   			string base_currency_s = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
		   			string profit_currency_s = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
			   		// Found BAS/ACC currency pair.
			   		if ((base_currency_s == base_currency) && (profit_currency_s == account_currency))
			   		{
	   					SymbolSelect(symbol, true);
	   					double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
	   					// Symbol not yet synced.
	   					if (!bid) break;
			   			// Symbol is synchronized and can be used for swap calculation.
							swap_long_1_lot = swap_long * bid;
							swap_short_1_lot = swap_short * bid;
			   			break;
			   		}
			   		// Found ACC/BAS currency pair.
			   		else if ((base_currency_s == account_currency) && (profit_currency_s == base_currency))
			   		{
	   					SymbolSelect(symbol, true);
	   					double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
	   					// Symbol not yet synced.
	   					if (!ask) break;
			   			// Symbol is synchronized and can be used for swap calculation.
							swap_long_1_lot = swap_long * ask;
							swap_short_1_lot = swap_short * ask;
			   			break;
			   		}
   				}
   			}
   		}
   	}
	  		break;
   	// Interest - based on price during rollover.
   	case 2:
   	{
   		double symbol_cost_1_lot;
   		OutputSwapsType = "Interest";
   		// Calculate it by pending order's price.
   		if (sets.EntryType == Pending)
				symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * sets.EntryLevel / SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
   		// Calculate it by current price of contract - it is impossible to determine potential future price.
			else symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
			// Percentage per 360 days.
			swap_long_1_lot = swap_long * symbol_cost_1_lot / 100 / 360;
			swap_short_1_lot = swap_short * symbol_cost_1_lot / 100 / 360;
			// Stupid fix for strange cases when swap is given not in percentage points but in coefficient (?).
			if (MathAbs(swap_long) < 0.1)
			{
				swap_long_1_lot *= 1000;
				swap_short_1_lot *= 1000;
			}
		}
   		break;
   	// Account currency
   	case 3:
   	{
			OutputSwapsType = account_currency;
			swap_long_1_lot = swap_long;
			swap_short_1_lot = swap_short;
   	}
   		break;
		default:
			break;
   }
	if ((swap_long_1_lot != EMPTY_VALUE) && (swap_short_1_lot != EMPTY_VALUE))
	{
		OutputSwapsDailyLongLot = FormatDouble(DoubleToString(swap_long_1_lot, 2));
		OutputSwapsDailyShortLot = FormatDouble(DoubleToString(swap_short_1_lot, 2));
		OutputSwapsCurrencyDailyLot = account_currency + " per lot";
		OutputSwapsDailyLongPS = FormatDouble(DoubleToString(swap_long_1_lot * OutputPositionSize, 2));
		OutputSwapsDailyShortPS = FormatDouble(DoubleToString(swap_short_1_lot * OutputPositionSize, 2));
		OutputSwapsCurrencyDailyPS = account_currency + " per PS (" + DoubleToString(OutputPositionSize, 2) + ")";
		
		OutputSwapsYearlyLongLot = FormatDouble(DoubleToString(swap_long_1_lot * 360, 2));
		OutputSwapsYearlyShortLot = FormatDouble(DoubleToString(swap_short_1_lot * 360, 2));
		OutputSwapsCurrencyYearlyLot = account_currency + " per lot";
		OutputSwapsYearlyLongPS = FormatDouble(DoubleToString(swap_long_1_lot * 360 * OutputPositionSize, 2));
		OutputSwapsYearlyShortPS = FormatDouble(DoubleToString(swap_short_1_lot * 360 * OutputPositionSize, 2));
		OutputSwapsCurrencyYearlyPS = account_currency + " per PS (" + DoubleToString(OutputPositionSize, 2) + ")";
	}
}

//+------------------------------------------------------------------+
//| Round down a double value to a given decimal place.              |
//+------------------------------------------------------------------+
double RoundDown(const double value, const double digits)
{
   int norm = (int) MathPow(10, digits);
   return(MathFloor(value * norm) / norm);
}

//+------------------------------------------------------------------+
//| Round a double value to a given decimal place.                   |
//+------------------------------------------------------------------+
double Round(const double value, const double digits)
{
   int norm = (int) MathPow(10, digits);
   return(MathRound(value * norm) / norm);
}

//+---------------------------------------------------------------------------+
//| Formats double with thousands separator for so many digits after the dot. |
//+---------------------------------------------------------------------------+
string FormatDouble(const string number, const int digits = 2)
{
   // Find "." position.
   int pos = StringFind(number, ".");
   string integer = number;
   string decimal = "";
   if (pos > -1)
   {
      integer = StringSubstr(number, 0, pos);
      decimal = StringSubstr(number, pos, digits + 1);
   }
   string formatted = "";
   string comma = "";
   
   while (StringLen(integer) > 3)
   {
      int length = StringLen(integer);
      string group = StringSubstr(integer, length - 3);
      formatted = group + comma + formatted;
      comma = ",";
      integer = StringSubstr(integer, 0, length - 3);
   }
   if (integer == "-") comma = "";
   if (integer != "") formatted = integer + comma + formatted;
   
   return(formatted + decimal);
}

//+------------------------------------------------------------------+
//| Counts decimal places.                                           |
//+------------------------------------------------------------------+
int CountDecimalPlaces(double number)
{
   // 100 as maximum length of number.
   for (int i = 0; i < 100; i++)
   {
      if (MathAbs(MathRound(number) - number) / MathPow(10, i) <= FLT_EPSILON) return(i);
      number *= 10;
   }
   return(-1);
}

//+------------------------------------------------------------------+
//| Draws a pips distance for SL or TP.                              |
//+------------------------------------------------------------------+
void DrawPipsDifference(string label, double price1, double price2, color col)
{
   // Data not loaded yet.
   if (Bars <= 0) return;
   
   int x, y;
   long real_x;
   uint w, h;
	string pips = IntegerToString((int)MathRound((MathAbs(price1 - price2) / Point)));

	ObjectSetText(label, pips, font_size, font_face, col);
   real_x = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - 2;
   // Needed only for y, x is derived from the chart width.
   ChartTimePriceToXY(0, 0, Time[0], price1, x, y);
   // Get the width of the text based on font and its size. Negative because OS-dependent, *10 because set in 1/10 of pt.
   TextSetFont(font_face, font_size * -10);
   TextGetSize(pips, w, h);
   ObjectSet(label, OBJPROP_XDISTANCE, real_x - w);
   ObjectSet(label, OBJPROP_YDISTANCE, y);
}

//+------------------------------------------------------------------+
//| Calculates symbol leverage value based on required margin 			|
//| and current rates.                              						|
//+------------------------------------------------------------------+
void CalculateSymbolLeverage()
{
   double tickValue       = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double lotValue        = SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize * tickValue;
   if (PreHedgingPositionMargin == 0) return;
   SymbolLeverage         = lotValue / PreHedgingPositionMargin * OutputPositionSize;
}
//+------------------------------------------------------------------+