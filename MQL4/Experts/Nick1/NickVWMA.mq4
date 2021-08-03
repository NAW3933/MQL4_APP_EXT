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

   string fileName="DataSource_"+dataSourceName+"_VWMA.csv";
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
class InstrumentProperties
  {

public:
                     InstrumentProperties(string symbol);
   string            GetPropertyCVS();
   string            Symbol;
   
   double            vwma;
   double            sma;
   double            vwmaYes;
   double            smaYes;
   
   double            vwma_4h;
   double            sma_4h;
   double            vwmaYes_4h;
   double            smaYes_4h;
   
   double            vwma_1h;
   double            sma_1h;
   double            vwmaYes_1h;
   double            smaYes_1h;  

   double            vwma_30m;
   double            sma_30m;
   double            vwmaYes_30m;
   double            smaYes_30m; 
  };

//+------------------------------------------------------------------+
InstrumentProperties::InstrumentProperties(string symbol)
  {
   this.Symbol          = symbol;
   this.vwma            = iCustom(this.Symbol,PERIOD_D1,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.sma             = iCustom(this.Symbol,PERIOD_D1,"Custom Moving Averages",4,0,0);
   this.vwmaYes         = iCustom(this.Symbol,PERIOD_D1,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.smaYes          = iCustom(this.Symbol,PERIOD_D1,"Custom Moving Averages",4,0,1);

   this.vwma_4h            = iCustom(this.Symbol,PERIOD_H4,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.sma_4h             = iCustom(this.Symbol,PERIOD_H4,"Custom Moving Averages",4,0,0);
   this.vwmaYes_4h        = iCustom(this.Symbol,PERIOD_H4,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.smaYes_4h          = iCustom(this.Symbol,PERIOD_H4,"Custom Moving Averages",4,0,1);

   this.vwma_1h            = iCustom(this.Symbol,PERIOD_H1,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.sma_1h             = iCustom(this.Symbol,PERIOD_H1,"Custom Moving Averages",4,0,0);
   this.vwmaYes_1h        = iCustom(this.Symbol,PERIOD_H1,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.smaYes_1h          = iCustom(this.Symbol,PERIOD_H1,"Custom Moving Averages",4,0,1);

   this.vwma_30m            = iCustom(this.Symbol,PERIOD_M30,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.sma_30m             = iCustom(this.Symbol,PERIOD_M30,"Custom Moving Averages",4,0,0);
   this.vwmaYes_30m        = iCustom(this.Symbol,PERIOD_M30,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.smaYes_30m          = iCustom(this.Symbol,PERIOD_M30,"Custom Moving Averages",4,0,1);

  }
//+------------------------------------------------------------------+

string GetHeader()
{
   string content="";
   content += "\"Symbol\",";

   content += "\"vwma\",";
   content += "\"sma\",";
   content += "\"vwmaYes\",";
   content += "\"smaYes\",";
   
   content += "\"vwma_4h\",";
   content += "\"sma_4h\",";
   content += "\"vwmaYes_4h\",";
   content += "\"smaYes_4h\",";

   content += "\"vwma_1h\",";
   content += "\"sma_1h\",";
   content += "\"vwmaYes_1h\",";
   content += "\"smaYes_1h\",";
   
   content += "\"vwma_30m\",";
   content += "\"sma_30m\",";
   content += "\"vwmaYes_30m\",";
   content += "\"smaYes_30m\"\n";
    
   return(content);
}
//+------------------------------------------------------------------+
string InstrumentProperties::GetPropertyCVS(void)
  {
   string content="";

   content += this.Symbol+",";
   
   content += DoubleToString(this.vwma,6)+",";
   content += DoubleToString(this.sma,6)+",";
   content += DoubleToString(this.vwmaYes,6)+",";
   content += DoubleToString(this.smaYes,6)+",";
   
   content += DoubleToString(this.vwma_4h,6)+",";
   content += DoubleToString(this.sma_4h,6)+",";
   content += DoubleToString(this.vwmaYes_4h,6)+",";
   content += DoubleToString(this.smaYes_4h,6)+","; 

   content += DoubleToString(this.vwma_1h,6)+",";
   content += DoubleToString(this.sma_1h,6)+",";
   content += DoubleToString(this.vwmaYes_1h,6)+",";
   content += DoubleToString(this.smaYes_1h,6)+","; 
 
   content += DoubleToString(this.vwma_30m,6)+",";
   content += DoubleToString(this.sma_30m,6)+",";
   content += DoubleToString(this.vwmaYes_30m,6)+",";
   content += DoubleToString(this.smaYes_30m,6)+","; 
    
   return (content);
  }
