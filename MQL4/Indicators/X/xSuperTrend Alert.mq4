/*------------------------------------------------------------------------------------
   Name: xSuperTrend Alert.mq4
   Copyright ©2011, Xaphod, http://wwww.xaphod.com
   
   Supertrend formula Copyright © Unknown. Someone on the Internets:
      UpperLevel=(High[i]+Low[i])/2+Multiplier*Atr(Period);
      LowerLevel=(High[i]+Low[i])/2-Multiplier*Atr(Period);
   
   Description: Alerts when supertrend changes state
                Alert either on the open bar or on closed bars only
                Requires that xSuperTrend.mq4 is installed to work.
	          
   Change log: 
       2011-12-30. Xaphod, v1.00 
          - First Release 
-------------------------------------------------------------------------------------*/
// Indicator properties
#property copyright "Copyright © 2011, Xaphod"
#property link      "http://wwww.xaphod.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 FireBrick
#property indicator_color3 Green
#property indicator_width1 1
#property indicator_width2 2
#property indicator_width3 2
#property indicator_style1 STYLE_DOT
#property indicator_maximum 1
#property indicator_minimum 0

// Win32 API
#import "Kernel32.dll"
  int CreateFileA(string lpFileName,int dwDesiredAccess, int dwShareMode, int lpSecurityAttributes, int dwCreationDisposition,int dwFlagsAndAttributes, int hTemplateFile);
  int CloseHandle(int hObject);
#import
#define OPEN_EXISTING 3
#define FILE_SHARE_READ 1
#define FILE_READ_DATA 1
#define FILE_ATTRIBUTE_NORMAL 128
#define INVALID_HANDLE_VALUE 0xFFFFFFFF

// Constant definitions
#define INDICATOR_NAME "xSuperTrend Alerts"
#define INDICATOR_VERSION "v1.00, www.xaphod.com"
#define SUPERTREND   "xSuperTrend"

// Indicator parameters
extern string Version.Info=INDICATOR_VERSION;
extern string SuperTrend.Info="——————————————————————————————";
extern int    SuperTrend.Period=10;      // SuperTrend ATR Period
extern double SuperTrend.Multiplier=1.7; // SuperTrend Multiplier
extern int    SuperTrend.TimeFrame=0;    // SuperTrend Timeframe
extern string Alert.Settings="——————————————————————————————";
extern bool   Alert.ClosedBar=False;     // Alert on closed bars only
extern bool   Alert.Popup=True;          // Enable popup alert
extern bool   Alert.Email=False;         // Enable email alert
extern string Alert.Subject="";          // Email alert subject. NULL=>Subject

// Global module varables
double gadSuperTrend[];

//-----------------------------------------------------------------------------
// function: init()
// Description: Custom indicator initialization function.
//-----------------------------------------------------------------------------
int init() {
  if (!IndicatorExists(SUPERTREND+".ex4"))
    Alert(Symbol()+", "+TF2Str(Period())+", "+INDICATOR_NAME+": Error! ..\\experts\\indicators\\"+SUPERTREND+".ex4 cannot be found.");
  IndicatorShortName(INDICATOR_NAME+" "+TF2Str(SuperTrend.TimeFrame) +"["+SuperTrend.Period+";"+DoubleToStr(SuperTrend.Multiplier,1)+"]");
  return(0);
}


//-----------------------------------------------------------------------------
// function: deinit()
// Description: Custom indicator deinitialization function.
//-----------------------------------------------------------------------------
int deinit() {
   return (0);
}


///-----------------------------------------------------------------------------
// function: start()
// Description: Custom indicator iteration function.
//-----------------------------------------------------------------------------
int start() {
  int iNewBars, iCountedBars, i;
  double dStDn0,dStDn1,dStUp0,dStUp1;
  static bool bInit=True;
  
  // Alert if trend changed
  if (Alert.ClosedBar)
    if (Alert.Popup || Alert.Email) {
      // get data
      dStDn0=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,1,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[1]));
      dStDn1=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,1,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[2]));
      dStUp0=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,2,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[1]));
      dStUp1=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,2,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[2]));
      // Alert
      if (dStUp0!=EMPTY_VALUE && dStUp1==EMPTY_VALUE)
        TriggerAlert(Symbol()+", "+ TF2Str(Period()) + ": SuperTrend UP!", Time[1],bInit);
      else if (dStDn0!=EMPTY_VALUE && dStDn1==EMPTY_VALUE)
        TriggerAlert(Symbol()+", "+ TF2Str(Period()) + ": SuperTrend DOWN!", Time[1],bInit); 
    }
  
  if (!Alert.ClosedBar)
    if (Alert.Popup || Alert.Email) {
      // get data
      dStDn0=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,1,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[0]));
      dStDn1=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,1,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[1]));
      dStUp0=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,2,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[0]));
      dStUp1=iCustom(NULL,SuperTrend.TimeFrame,SUPERTREND,"","",SuperTrend.Period,SuperTrend.Multiplier,2,iBarShift(Symbol(), SuperTrend.TimeFrame, Time[1]));
      // Alert
      if (dStUp0!=EMPTY_VALUE && dStUp1==EMPTY_VALUE)
        TriggerAlert(Symbol()+", "+ TF2Str(Period()) + ": SuperTrend UP!", Time[0],bInit);
      else if (dStDn0!=EMPTY_VALUE && dStDn1==EMPTY_VALUE)
        TriggerAlert(Symbol()+", "+ TF2Str(Period()) + ": SuperTrend DOWN!", Time[0],bInit); 
    }

  // Clear init flag
  if (bInit)
    bInit=False;
  return(0);
}
//+------------------------------------------------------------------+


//-----------------------------------------------------------------------------
// function: TriggerAlert()
// Description: Trigger the popup and email alerts
//-----------------------------------------------------------------------------
int TriggerAlert(string sAlertMsg,datetime tBarTime, bool bInit=False) {
  int ihFile;
  static datetime tAlertTime=0;
  
  //PrintD("Alert="+sAlertMsg);
  // If on init cycle set alert time and exit
  if (bInit) {
    tAlertTime=tBarTime;
    return(0);
  }
  
  // Perform alerts
  if (tAlertTime<tBarTime) {
    tAlertTime=tBarTime;
    
    //Popup Alert 
    if (Alert.Popup)
      Alert(sAlertMsg, " ", INDICATOR_NAME);
    //Email Alert
    if (Alert.Email) {
      if (Alert.Subject=="") 
        SendMail( sAlertMsg, "\r\n"+INDICATOR_NAME+"\r\n" + TimeToStr(Time[0],TIME_DATE|TIME_SECONDS )+"\r\n"+sAlertMsg);
      else 
        SendMail( Alert.Subject, "\r\n"+INDICATOR_NAME+"\r\n" + TimeToStr(Time[0],TIME_DATE|TIME_SECONDS )+"\r\n"+sAlertMsg);
    }
    return(1);
  }
  return(0);
}


//-----------------------------------------------------------------------------
// function: TF2Str()
// Description: Convert time-frame to a string
//-----------------------------------------------------------------------------
string TF2Str(int iPeriod) {
  switch(iPeriod) {
    case PERIOD_M1: return("M1");
    case PERIOD_M5: return("M5");
    case PERIOD_M15: return("M15");
    case PERIOD_M30: return("M30");
    case PERIOD_H1: return("H1");
    case PERIOD_H4: return("H4");
    case PERIOD_D1: return("D1");
    case PERIOD_W1: return("W1");
    case PERIOD_MN1: return("MN1");
    default: return("M"+iPeriod);
  }
}


//-----------------------------------------------------------------------------
// function: IndicatorExists()
// Description: Check if an indicator exists
//-----------------------------------------------------------------------------
bool IndicatorExists(string sIndicatorName) {
  int hFile;
  string sFile;
    
  // Exit if dlls are disabled
  if (!IsDllsAllowed())
    return(True);
  
  // Try to open indicator 
  sFile=TerminalPath()+"\\experts\\indicators\\"+sIndicatorName;
  hFile=CreateFileA(sFile,FILE_READ_DATA,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);  
  if (hFile==INVALID_HANDLE_VALUE) {
    return(False);    
  }
  else {
    CloseHandle(hFile);
    return(True);
  }
  return(False);
}