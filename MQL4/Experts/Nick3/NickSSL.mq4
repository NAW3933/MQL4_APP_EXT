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

   string fileName="DataSource_"+dataSourceName+"_SSL.csv";
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
   
   double 	   ssl_MN1_v1            	;
   double 	   ssl_MN1_v2             	;
   double 	   ssl_MN1_v1_Y            	;
   double 	   ssl_MN1_v2_Y             	;
		
   double 	   ssl_W1_v1            	;
   double 	   ssl_W1_v2             	;
   double 	   ssl_W1_v1_Y            	;
   double 	   ssl_W1_v2_Y             	;
		
   double 	   ssl_1d_v1            	;
   double 	   ssl_1d_v2             	;
   double 	   ssl_1d_v1_Y            	;
   double 	   ssl_1d_v2_Y             	;
		
   double 	   ssl_H4_v1            	;
   double 	   ssl_H4_v2             	;
   double 	   ssl_H4_v1_Y            	;
   double 	   ssl_H4_v2_Y             	;
		
   double 	   ssl_H1_v1            	;
   double 	   ssl_H1_v2             	;
   double 	   ssl_H1_v1_Y            	;
   double 	   ssl_H1_v2_Y             	;
		
   double 	   ssl_M30_v1            	;
   double 	   ssl_M30_v2             	;
   double 	   ssl_M30_v1_Y            	;
   double 	   ssl_M30_v2_Y             	;

   
  };

//+------------------------------------------------------------------+
InstrumentProperties::InstrumentProperties(string symbol)
  {
  
  
   this.Symbol          = symbol;
 
   this.ssl_MN1_v1            = NULL; //iCustom(this.Symbol,PERIOD_MN1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,0);
   this.ssl_MN1_v2             = NULL; //iCustom(this.Symbol,PERIOD_MN1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,0);
   this.ssl_MN1_v1_Y            = NULL; //iCustom(this.Symbol,PERIOD_MN1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,1);
   this.ssl_MN1_v2_Y             = NULL; //iCustom(this.Symbol,PERIOD_MN1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,1);
   
   this.ssl_W1_v1            = NULL; //iCustom(this.Symbol,PERIOD_W1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,0);
   this.ssl_W1_v2             = NULL; //iCustom(this.Symbol,PERIOD_W1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,0);
   this.ssl_W1_v1_Y            = NULL; //iCustom(this.Symbol,PERIOD_W1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,1);
   this.ssl_W1_v2_Y             = NULL; //iCustom(this.Symbol,PERIOD_W1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,1);
   
   this.ssl_1d_v1            = NULL; //iCustom(this.Symbol,PERIOD_D1,"Me\\ssl-channel-chart-alert-indicator",8,false,false,false,false,0,0);
   this.ssl_1d_v2             = NULL; //iCustom(this.Symbol,PERIOD_D1,"Me\\ssl-channel-chart-alert-indicator",8,false,false,false,false,1,0);
   this.ssl_1d_v1_Y            = NULL; //iCustom(this.Symbol,PERIOD_D1,"Me\\ssl-channel-chart-alert-indicator",8,false,false,false,false,0,1);
   this.ssl_1d_v2_Y             = NULL; //iCustom(this.Symbol,PERIOD_D1,"Me\\ssl-channel-chart-alert-indicator",8,false,false,false,false,1,1);

   this.ssl_H4_v1            = iCustom(this.Symbol,PERIOD_H4,"nick1\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,0);
   this.ssl_H4_v2             = iCustom(this.Symbol,PERIOD_H4,"Nick1\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,0);
   this.ssl_H4_v1_Y            = iCustom(this.Symbol,PERIOD_H4,"Nick1\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,1);
   this.ssl_H4_v2_Y             = iCustom(this.Symbol,PERIOD_H4,"Nick1\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,1);

   this.ssl_H1_v1            = NULL; //iCustom(this.Symbol,PERIOD_H1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,0);
   this.ssl_H1_v2             = NULL; //iCustom(this.Symbol,PERIOD_H1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,0);
   this.ssl_H1_v1_Y            = NULL; //iCustom(this.Symbol,PERIOD_H1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,1);
   this.ssl_H1_v2_Y             = NULL; //iCustom(this.Symbol,PERIOD_H1,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,1);

   this.ssl_M30_v1            = NULL; //iCustom(this.Symbol,PERIOD_M30,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,0);
   this.ssl_M30_v2             = NULL; //iCustom(this.Symbol,PERIOD_M30,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,0);
   this.ssl_M30_v1_Y            = NULL; //iCustom(this.Symbol,PERIOD_M30,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,0,1);
   this.ssl_M30_v2_Y             = NULL; //iCustom(this.Symbol,PERIOD_M30,"Me\\ssl-channel-chart-alert-indicator",12,false,false,false,false,1,1);

  }
//+------------------------------------------------------------------+

string GetHeader()
{
   string content="";
   content += "\"Symbol\",";
   content += "\"ssl_MN1_v1\",";
    content += "\"ssl_MN1_v2\",";
    content += "\"ssl_MN1_v1_Y\",";
    content += "\"ssl_MN1_v2_Y\",";
   
   content += "\"ssl_W1_v1\",";
   content += "\"ssl_W1_v2\",";
   content += "\"ssl_W1_v1_Y\",";
   content += "\"ssl_W1_v2_Y\",";
   
   content += "\"ssl_1d_v1\",";
   content += "\"ssl_1d_v2\",";
   content += "\"ssl_1d_v1_Y\",";
   content += "\"ssl_1d_v2_Y\",";

   content += "\"ssl_H4_v1\",";
   content += "\"ssl_H4_v2\",";
   content += "\"ssl_H4_v1_Y\",";
   content += "\"ssl_H4_v2_Y\",";

   content += "\"ssl_H1_v1\",";
   content += "\"ssl_H1_v2\",";
   content += "\"ssl_H1_v1_Y\",";
   content += "\"ssl_H1_v2_Y\",";

   content += "\"ssl_M30_v1\",";
   content += "\"ssl_M30_v2\",";
   content += "\"ssl_M30_v1_Y\",";
   content += "\"ssl_M30_v2_Y\"\n";
    
   return(content);
}
//+------------------------------------------------------------------+
string InstrumentProperties::GetPropertyCVS(void)
  {
   string content="";

   content += this.Symbol+",";
   
   content += DoubleToString(this.ssl_MN1_v1,6)+",";
   content += DoubleToString(this.ssl_MN1_v2,6)+",";
   content += DoubleToString(this.ssl_MN1_v1_Y,6)+",";
   content += DoubleToString(this.ssl_MN1_v2_Y,6)+",";

   content += DoubleToString(this.ssl_W1_v1,6)+",";
   content += DoubleToString(this.ssl_W1_v2,6)+",";
   content += DoubleToString(this.ssl_W1_v1_Y,6)+",";
   content += DoubleToString(this.ssl_W1_v2_Y,6)+",";

   content += DoubleToString(this.ssl_1d_v1,6)+",";
   content += DoubleToString(this.ssl_1d_v2,6)+",";
   content += DoubleToString(this.ssl_1d_v1_Y,6)+",";
   content += DoubleToString(this.ssl_1d_v2_Y,6)+",";

   content += DoubleToString(this.ssl_H4_v1,6)+",";
   content += DoubleToString(this.ssl_H4_v2,6)+",";
   content += DoubleToString(this.ssl_H4_v1_Y,6)+",";
   content += DoubleToString(this.ssl_H4_v2_Y,6)+",";

   content += DoubleToString(this.ssl_H1_v1,6)+",";
   content += DoubleToString(this.ssl_H1_v2,6)+",";
   content += DoubleToString(this.ssl_H1_v1_Y,6)+",";
   content += DoubleToString(this.ssl_H1_v2_Y,6)+",";

   content += DoubleToString(this.ssl_M30_v1,6)+",";
   content += DoubleToString(this.ssl_M30_v2,6)+",";
   content += DoubleToString(this.ssl_M30_v1_Y,6)+",";
   content += DoubleToString(this.ssl_M30_v2_Y,6)+",";

   return (content);
   
  }
