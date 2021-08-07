//+------------------------------------------------------------------+
//|                                             RD_TradePanel_v7.mq4 |
//|                                                    Rod Greenwood |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Rod Greenwood"
#property link      "  "
#property version   "2.00"
#property strict

#include <Controls/Dialog_Bug_Fix.mqh>
#include <Controls/SpinEdit.mqh>
#include <Controls/SpinEditDouble.mqh>
#include <Controls/Edit.mqh>
#include <Controls/Button.mqh>

extern double MaxSpinValue = 2.00;
extern double MinSpinValue = 0.01;
extern double DefaultSpinValue = 0.05;


CAppDialog cpInterface;
CSpinEdit cpSpinTP,cpSpinSL;
CSpinEditDouble cpSpinLS;
CEdit cpEditTP,cpEditLS,cpEditSL;
CButton cpButton_0,cpButton_1;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static int a_x=int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)-10);
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   cpInterface.Create(0,_Symbol+" "+string(Period())+" Min",0,a_x-215,20,0,95);
//---
   cpSpinLS.Create(0,"cpSpinLS",0,75,5,133,25);
   cpSpinLS.MaxValue(MaxSpinValue);
   cpSpinLS.MinValue(MinSpinValue);
   cpSpinLS.Value(DefaultSpinValue);
   ObjectSetInteger(0,"cpSpinLSEdit",OBJPROP_READONLY,false);
   cpInterface.Add(cpSpinLS);

//+------------------------------------------------------------------+
//|                  LEFT Button                                     |
//+------------------------------------------------------------------+
   cpButton_0.Create(0,"cpButton_0",0,10,10,65,20);
   cpButton_0.Text("LEFT");
   cpButton_0.Color(clrWhite);
   cpButton_0.ColorBackground(clrGreen);
   cpButton_0.ColorBorder(clrBlack);
   cpButton_0.FontSize(6);
   cpButton_0.Font("Arial Bold");
   cpInterface.Add(cpButton_0);
//+------------------------------------------------------------------+
//|                  RIGHT Button                                    |
//+------------------------------------------------------------------+
   cpButton_1.Create(0,"cpButton_1",0,145,10,200,20);
   cpButton_1.Text("RIGHT");
   cpButton_1.Color(clrWhite);
   cpButton_1.ColorBackground(clrRed);
   cpButton_1.ColorBorder(clrBlack);
   cpButton_1.FontSize(6);
   cpButton_1.Font("Arial Bold");
   cpInterface.Add(cpButton_1);

   cpInterface.Run();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   cpInterface.Destroy(reason);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   cpInterface.OnEvent(id,lparam,dparam,sparam);
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      int a_y=int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)-10);

      int a1 =(a_x-a_y);
      int a2 =(a_y-a_x);
      int w =fabs(a_x-a_y);

      if(a_x > a_y)
        {
         cpInterface.Shift(-w,0);
        }
      if(a_x < a_y)
        {
         cpInterface.Shift(w,0);
        }
      Print("ax raw "+string(a_x));
      Print("ay raw "+string(a_y));
      Print("w "+string(w));
      //Print(fabs(a_y-a_x));
      Print("a2 fabs "+string(fabs(a2)));
      Print("a1 fabs "+string(fabs(a1)));
      Print("a2 "+string(a2));
      Print("a1 "+string(a1));
     }
   if(id==CHARTEVENT_OBJECT_CLICK&&sparam=="cpButton_0")
      LeftButton();

   if(id==CHARTEVENT_OBJECT_CLICK&&sparam=="cpButton_1")
      RightButton();
  }
//+------------------------------------------------------------------+
void LeftButton()
  {
   cpInterface.Shift(-10,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RightButton()
  {
   cpInterface.Shift(10,0);
  }
//+------------------------------------------------------------------+
