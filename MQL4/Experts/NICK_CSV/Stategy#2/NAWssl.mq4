//+------------------------------------------------------------------+
//|                                                   NickExport.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


extern bool   bAtr1 = false;
extern bool   bAtr5 = true;
extern bool   bAtr15 = false;
extern bool   bAtr30 = false;
extern bool   bAtr60 = false;
extern bool   bAtr1hr = false;
extern bool   bAtr4hr = false;
extern bool   bAtr1D = false;
extern bool   bAtr1w=false;

extern int period = 10;

class InstrumentProperties;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(5);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }


//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {

   string dataSourceName=TerminalInfoString(TERMINAL_NAME);
   string path=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files";
   //string path="C:\\Users\\Wales\\OneDrive\\Desktop\\Stuff";
   
   string dataDirectory=path;
   string description="Data Source exported from "+
                      TerminalInfoString(TERMINAL_NAME)+", "+
                      TerminalInfoString(TERMINAL_COMPANY);

   string symbolsList[];
   int symbols=GetSymbolsList(symbolsList);
   InstrumentProperties *properties[];
   ArrayResize(properties,symbols);
   for(int i=0;i<symbols;i++)
      properties[i]=new InstrumentProperties(symbolsList[i]);

   string dataSourceContent=ComposeDataSourceContent(dataSourceName,
                                                     dataDirectory,
                                                     description,properties);

   string fileName="DataSource_"+dataSourceName+"_NAWssl.csv";
   SaveStringToFile(fileName,dataSourceContent);

   string note="Exported "+fileName+"\n"+IntegerToString(symbols)+" symbols";
   Print(note);
   Comment(note);

   for(int i=0;i<symbols;i++)
      delete(properties[i]);
  }   
  
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int GetSymbolsList(string &symbolsList[])
  {
   int symbolsTotal=SymbolsTotal(true);
   ArrayResize(symbolsList,symbolsTotal);
   int symbolIndex=0;
   for(int i=0; i<symbolsTotal; i++)
     {
      string symbol=SymbolName(i,true);
      if(StringLen(symbol)>3)
         symbolsList[symbolIndex++]=symbol;
     }
   ArrayResize(symbolsList,symbolIndex);
   return (symbolIndex);
  }
//+------------------------------------------------------------------+
void SaveStringToFile(string filename,string text)
  {
   int handle= FileOpen(filename,FILE_TXT|FILE_WRITE|FILE_ANSI);
   if(handle == INVALID_HANDLE)
      return;

   FileWriteString(handle,text);
   FileClose(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ComposeDataSourceContent(string dataSourceName,
                                string dataDirectory,
                                string description,
                                InstrumentProperties *&properties[])
  {
   string content="";
   int propCount=ArraySize(properties);
   
   content=GetHeader();
   
   for(int i=0;i<propCount;i++)
      content+=properties[i].GetPropertyCVS()+(i<propCount-1?",\n":"\n");
   //content += "    }\n";
   //content += "}";
   return (content);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//v = vwmacg-4c-aa-mtf-tt
//a = ATR_Channels
//k = Klinger Oscilator 1 faster

class InstrumentProperties
  {

public:
                     InstrumentProperties(string symbol);
   string            GetPropertyCVS();
   string            Symbol;
   
   double      atr1;
   double 	   atr5;
   double 	   atr15;
   double 	   atr30;
   double 	   atr60;
   double 	   atr4hr;
   double      atr1d;
   double      atr1W;
   
  };

//+------------------------------------------------------------------+
InstrumentProperties::InstrumentProperties(string symbol)
  {
  
   this.Symbol          = symbol;
   //CUrrent timeframe
   
   if(bAtr1) this.atr1        =iCustom(this.Symbol,PERIOD_M1,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr5) this.atr5        =iCustom(this.Symbol,PERIOD_M5,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr15)this.atr15       =iCustom(this.Symbol,PERIOD_M15,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr30)this.atr30       =iCustom(this.Symbol,PERIOD_M30,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr1hr)this.atr60       =iCustom(this.Symbol,PERIOD_H1,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr4hr)this.atr4hr      =iCustom(this.Symbol,PERIOD_H4,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr1D)this.atr1d       =iCustom(this.Symbol,PERIOD_D1,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);
   if(bAtr1w) this.atr1W     =iCustom(this.Symbol,PERIOD_W1,"ssl-channel-chart-alert-indicator",period,false,false,false,false,0,0);

  }
  
//+------------------------------------------------------------------+

string GetHeader()
{
   string content="";
   content += "\"Symbol\"";
   content += "\"ssl1\",";   
   content += "\"ssl5\",";   
   content += "\"ssl5\",";   
   content += "\"ssl30\",";   
   content += "\"ssl60\",";   
   content += "\"ssllhr\","; 
   content += "\"ssl1w\"\n";  

   return(content);
}
//+------------------------------------------------------------------+
string InstrumentProperties::GetPropertyCVS(void)
  {
   string content="";

   content += this.Symbol+",";
   
   content += DoubleToString(this.atr1)+",";
   content += DoubleToString(this.atr5)+",";
   content += DoubleToString(this.atr15)+",";
   content += DoubleToString(this.atr30)+",";
   content += DoubleToString(this.atr60)+",";
   content += DoubleToString(this.atr4hr)+",";
   content += DoubleToString(this.atr1d)+","; 
   content += DoubleToString(this.atr1W)+",";  
   return (content);
   
  }
