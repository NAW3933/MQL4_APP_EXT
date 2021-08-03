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
   double            price;
   double            vwmaYes;
   double            priceYes;
   
   double            vwma_4h;
   double            price_4h;
   double            vwmaYes_4h;
   double            priceYes_4h;
   
   double            vwma_1h;
   double            price_1h;
   double            vwmaYes_1h;
   double            priceYes_1h;  

   double            vwma_30m;
   double            price_30m;
   double            vwmaYes_30m;
   double            priceYes_30m; 
  };

//+------------------------------------------------------------------+
InstrumentProperties::InstrumentProperties(string symbol)
  {
   this.Symbol          = symbol;
   this.vwma            = iCustom(this.Symbol,PERIOD_D1,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.price             = iClose(this.Symbol,PERIOD_D1,0);
   //NULL;//iCustom(this.Symbol,PERIOD_D1,"Custom Moving Averages",4,0,0);
 
   this.vwmaYes         = iCustom(this.Symbol,PERIOD_D1,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.priceYes          = iClose(this.Symbol,PERIOD_D1,1);
   //NULL;// iCustom(this.Symbol,PERIOD_D1,"Custom Moving Averages",4,0,1);

   this.vwma_4h            = iCustom(this.Symbol,PERIOD_H4,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.price_4h             = iClose(this.Symbol, PERIOD_H4,0);
   //NULL;//iCustom(this.Symbol,PERIOD_H4,"Custom Moving Averages",4,0,0);
   
   this.vwmaYes_4h        = iCustom(this.Symbol,PERIOD_H4,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.priceYes_4h          = iClose(this.Symbol, PERIOD_H4,1);
   //NULL;//iCustom(this.Symbol,PERIOD_H4,"Custom Moving Averages",4,0,1);

   this.vwma_1h            = iCustom(this.Symbol,PERIOD_H1,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.price_1h             = iClose(this.Symbol, PERIOD_H1,0);
   //NULL;//iCustom(this.Symbol,PERIOD_H1,"Custom Moving Averages",4,0,0);
   
   this.vwmaYes_1h        = iCustom(this.Symbol,PERIOD_H1,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.priceYes_1h          = iClose(this.Symbol, PERIOD_H1,1);
   //NULL; //iCustom(this.Symbol,PERIOD_H1,"Custom Moving Averages",4,0,1);

   this.vwma_30m            = iCustom(this.Symbol,PERIOD_M30,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,0);
   this.price_30m             = iClose(this.Symbol, PERIOD_M30,0);
   //NULL; //iCustom(this.Symbol,PERIOD_M30,"Custom Moving Averages",4,0,0);
  
   this.vwmaYes_30m        = iCustom(this.Symbol,PERIOD_M30,"vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",0,1);
   this.priceYes_30m          = iClose(this.Symbol, PERIOD_M30,1);
   //NULL; //iCustom(this.Symbol,PERIOD_M30,"Custom Moving Averages",4,0,1);

  }
//+------------------------------------------------------------------+

string GetHeader()
{
   string content="";
   content += "\"Symbol\",";

   content += "\"vwma\",";
   content += "\"price\",";
   content += "\"vwmaYes\",";
   content += "\"priceYes\",";
   
   content += "\"vwma_4h\",";
   content += "\"price_4h\",";
   content += "\"vwmaYes_4h\",";
   content += "\"priceYes_4h\",";

   content += "\"vwma_1h\",";
   content += "\"price_1h\",";
   content += "\"vwmaYes_1h\",";
   content += "\"priceYes_1h\",";
   
   content += "\"vwma_30m\",";
   content += "\"price_30m\",";
   content += "\"vwmaYes_30m\",";
   content += "\"priceYes_30m\"\n";
    
   return(content);
}
//+------------------------------------------------------------------+
string InstrumentProperties::GetPropertyCVS(void)
  {
   string content="";

   content += this.Symbol+",";
   
   content += DoubleToString(this.vwma,6)+",";
   content += DoubleToString(this.price,6)+",";
   content += DoubleToString(this.vwmaYes,6)+",";
   content += DoubleToString(this.priceYes,6)+",";
   
   content += DoubleToString(this.vwma_4h,6)+",";
   content += DoubleToString(this.price_4h,6)+",";
   content += DoubleToString(this.vwmaYes_4h,6)+",";
   content += DoubleToString(this.priceYes_4h,6)+","; 

   content += DoubleToString(this.vwma_1h,6)+",";
   content += DoubleToString(this.price_1h,6)+",";
   content += DoubleToString(this.vwmaYes_1h,6)+",";
   content += DoubleToString(this.priceYes_1h,6)+","; 
 
   content += DoubleToString(this.vwma_30m,6)+",";
   content += DoubleToString(this.price_30m,6)+",";
   content += DoubleToString(this.vwmaYes_30m,6)+",";
   content += DoubleToString(this.priceYes_30m,6)+","; 
    
   return (content);
  }
