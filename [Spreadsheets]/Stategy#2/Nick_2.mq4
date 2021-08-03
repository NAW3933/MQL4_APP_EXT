//+------------------------------------------------------------------+
//|                                                   NickExport.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

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

   string fileName="DataSource_"+dataSourceName+"_Nick1.csv";
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
   
   double 	   v ;
   double 	   a ;
   double      k1;
   double      k2;
   
  };

//+------------------------------------------------------------------+
InstrumentProperties::InstrumentProperties(string symbol)
  {
  
   this.Symbol          = symbol;
   //CUrrent timeframe
   this.v           = iCustom(this.Symbol,0,"vwmacg-4c-aa-mtf-tt",0,0,12,6,3,6,2.618,1,0,1,0,0,0,0,0);
   this.a           =iCustom(this.Symbol,0,"ATR_Channels",18,49,3,1.6,3.2,4.8,0,0);
   this.k1          = iCustom(this.Symbol,0,"Klinger Oscillator",34,55,6,0,0);
   this.k2          = iCustom(this.Symbol,0,"Klinger Oscillator",34,55,6,1,0);
  }
  
//+------------------------------------------------------------------+

string GetHeader()
{
   string content="";
   content += "\"Symbol\",";
   content += "\"v\",";
   content += "\"a\",";
   content += "\"k1\",";
   content += "\"k2\"\n"; 
   return(content);
}
//+------------------------------------------------------------------+
string InstrumentProperties::GetPropertyCVS(void)
  {
   string content="";

   content += this.Symbol+",";
   
   content += DoubleToString(this.a,6)+",";
   content += DoubleToString(this.v,6)+",";
   content += DoubleToString(this.k1,6)+",";
   content += DoubleToString(this.k2,6)+",";

   return (content);
   
  }
