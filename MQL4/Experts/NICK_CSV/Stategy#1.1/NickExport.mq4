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
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
 

//+-------------------------------------------------
/*
void Export()
  {
   if(FileIsExist(my_File_Name))
     {
      FileDelete(my_File_Name);
     }

   my_archive=FileOpen(my_File_Name,FILE_WRITE|FILE_SHARE_WRITE|FILE_CSV);
//Check if Archive is opened
   if(my_archive==INVALID_HANDLE)
     {
      Print("Can't open archive");
      Print("Error code : ",GetLastError());
     }
   else
     {
      Print("Archive opened");
     }
//Loop on Marketwatch
   int n_markets=SymbolsTotal(false);
   for(int i=0;i<n_markets;i++)
     {
      PrintFormat("%s",SymbolName(i,true));
      FileWrite(my_archive,StringFormat("%s",SymbolName(i,true)));
     }
   FileClose(my_archive);
   
  }
  */
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   //Export Symbols Only
   //Export();
   
   string dataSourceName=TerminalInfoString(TERMINAL_NAME);
   string path=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files";
   //string path="C:\\Users\\Wales\\OneDrive\\Desktop\\Stuff";
   StringReplace(path,"\\","\\\\");
   string dataDirectory=path;
   string description="Data Source exported from "+
                      TerminalInfoString(TERMINAL_NAME)+", "+
                      TerminalInfoString(TERMINAL_COMPANY);

   string symbolsList[];
   //RemoveUnTradableInstruments();
   int symbols=GetSymbolsList(symbolsList);
   InstrumentProperties *properties[];
   ArrayResize(properties,symbols);
   for(int i=0;i<symbols;i++)
      properties[i]=new InstrumentProperties(symbolsList[i]);

   string dataSourceContent=ComposeDataSourceContent(dataSourceName,
                                                     dataDirectory,
                                                     description,properties);

   string fileName="DataSource_"+dataSourceName+".csv";
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
   //content += "{\n";
   //content += "    \"DataSourceName\" : \"" + dataSourceName + "\",\n";
   //content += "    \"DataDirectory\"  : \"" + dataDirectory  + "\",\n";
   //content += "    \"Description\"    : \"" + description    + "\",\n";
   //content += "    \"InstrumentProperties\": {\n";
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
   double            GetRate(string currency1,string currency2);
public:
                     InstrumentProperties(string symbol);
   string            GetPropertyCVS();
   string            Symbol;
   int               InstrType;
   string            Comment;
   string            PriceIn;
   string            BaseFileName;
   int               LotSize;
   double            Bid;
   double            Ask;
   int               Slippage;
   double            Spread;
   double            SwapLong;
   double            SwapShort;
   double            Commission;
   double            RateToUSD;
   double            RateToEUR;
   double            RateToGBP;
   double            RateToJPY;
   int               SwapType;
   int               CommissionType;
   int               CommissionScope;
   int               CommissionTime;
   int               Digits;
   double            Point;
   double            Pip;
   bool              IsFiveDigits;
   double            StopLevel;
   double            TickValue;
   double            MinLot;
   double            MaxLot;
   double            LotStep;
   double            MarginRequired;
   double            RSI_14_1D;
   double            RSI_14_30M;
   double            RSI_14_4hr;
   double            PreiousDayClose;
   double            PreiousMinClose;
   double            Preious5MinClose;
   double            Preious15MinClose;
   double            Preious2MinClose;
   double            Preious3MinClose;
   double            Preious4MinClose;
   double            ATR14_D;
   double            vwma;

  };

//+------------------------------------------------------------------+
InstrumentProperties::InstrumentProperties(string symbol)
  {
   this.Symbol          = symbol;
   string symbolUpper   = symbol;
   StringToUpper(symbolUpper);
   this.InstrType       = ((StringLen(symbol)==6 && symbolUpper==symbol)?0:1);
   this.Comment         = SymbolInfoString(symbol, SYMBOL_DESCRIPTION);
   this.PriceIn         = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
   this.BaseFileName    = symbol;
   this.LotSize         = (int) MarketInfo(symbol, MODE_LOTSIZE);
   this.Slippage        = 0;
   this.Point           = MarketInfo(symbol, MODE_POINT);
   this.Bid           = MarketInfo(symbol, MODE_BID);
   this.Ask           = MarketInfo(symbol, MODE_ASK);
   this.Spread          = (this.Ask-this.Bid)/this.Point;
   this.SwapLong        = NULL;//MarketInfo(symbol, MODE_SWAPLONG);
   this.SwapShort       = NULL;//MarketInfo(symbol, MODE_SWAPSHORT);
   this.Commission      = 0;
   this.RateToUSD       = NULL;//GetRate(this.PriceIn, "USD");
   this.RateToEUR       = NULL;//GetRate(this.PriceIn, "EUR");
   this.RateToGBP       = NULL;//GetRate(this.PriceIn, "GBP");
   this.RateToJPY       = NULL;//GetRate(this.PriceIn, "JPY");
   this.SwapType        = 0;
   this.CommissionType  = 0;
   this.CommissionScope = 0;
   this.CommissionTime  = 1;
   this.Digits          = (int)MarketInfo(symbol, MODE_DIGITS);
   this.IsFiveDigits    = NULL;//(this.Digits==3 || this.Digits==5);
   this.Pip             = NULL;//IsFiveDigits ? 10*this.Point : this.Point;
   this.StopLevel       = NULL;//MarketInfo(symbol, MODE_STOPLEVEL);
   this.TickValue       = NULL;//MarketInfo(symbol, MODE_TICKVALUE);
   this.MinLot          = NULL;//MarketInfo(symbol, MODE_MINLOT);
   this.MaxLot          = NULL;//MarketInfo(symbol, MODE_MAXLOT);
   this.LotStep         = NULL;//MarketInfo(symbol, MODE_LOTSTEP);
   this.MarginRequired  = NULL;//MarketInfo(symbol, MODE_MARGINREQUIRED);
   if(this.MarginRequired<0.0001)
      this.MarginRequired=NULL;//this.Bid*this.LotSize/100;
   this.RSI_14_1D       = iRSI(this.Symbol,PERIOD_D1, 14,PRICE_CLOSE,0);
   this.RSI_14_30M      = iRSI(this.Symbol,PERIOD_M30, 14,PRICE_CLOSE,0);
   this.RSI_14_4hr      = iRSI(this.Symbol,PERIOD_H1, 14,PRICE_CLOSE,0);
   this.PreiousDayClose = iClose(this.Symbol,PERIOD_D1,1);
   this.PreiousMinClose = iClose(this.Symbol,PERIOD_M1,1);
   this.Preious2MinClose = iClose(this.Symbol, PERIOD_M1,2);
   this.Preious3MinClose = iClose(this.Symbol, PERIOD_M1,3);
   this.Preious4MinClose = iClose(this.Symbol, PERIOD_M1,4);
   this.Preious5MinClose = iClose(this.Symbol,PERIOD_M5,1);
   this.Preious15MinClose = iClose(this.Symbol,PERIOD_M15,1);
   this.ATR14_D            = iATR(this.Symbol,PERIOD_D1,14,0);
   this.vwma        = NULL;//iCustom(this.Symbol,PERIOD_D1,"Me\\vwmacg-4c-aa-mtf-tt",7,false,10,6,1,0, 2.618, 1,2,false,1,false,false,false,false,"alert.wav",1,0);

  }
//+------------------------------------------------------------------+
double InstrumentProperties::GetRate(string currProfit,string currAccount)
  {
   if(currProfit==currAccount)
      return (1);

   double rate=MarketInfo(currAccount+currProfit,MODE_BID);

   if(rate<0.0001||rate>100000.0)
     {
      if(currProfit=="JPY")
         rate=0.01;
      else if(currAccount=="JPY")
         rate=100;
      else
         rate=1.0;
     }

   return (rate);
  }
string GetHeader()
{
   string content="";
   content += "\"Symbol\",";
   content += "\"InstrType\",";
   content += "\"Comment\",";
   content += "\"PriceIn\",";
   content += "\"BaseFileName\",";
   content += "\"LotSize\",";
   content += "\"Ask\",";
   content += "\"Bid\",";
   content += "\"Slippage\",";
   content += "\"Spread\",";
   content += "\"SwapLong\",";
   content += "\"SwapShort\",";
   content += "\"Commission\",";
   content += "\"RateToUSD\",";
   content += "\"RateToEUR\",";
   content += "\"RateToGBP\",";
   content += "\"RateToJPY\",";
   content += "\"SwapType\",";
   content += "\"CommissionType\",";
   content += "\"CommissionScope\",";
   content += "\"CommissionTime\",";
   content += "\"Digits\",";
   content += "\"Point\",";
   content += "\"Pip\",";
   content += "\"IsFiveDigits\",";
   content += "\"StopLevel\",";
   content += "\"TickValue\",";
   content += "\"MinLot\",";
   content += "\"MaxLot\",";
   content += "\"LotStep\",";
   content += "\"MarginRequired\",";
   content += "\"RSI_14_1D\",";
   content += "\"RSI_14_30m\",";
   content += "\"PrvsDyCls\",";
   content += "\"minClose\",";
   content += "\"5minClose\",";
   content +="\"15minClose\",";
   content += "\"RSI_14_4Hr\",";
   content += "\"ATR14_D\",";
   content += "\"Preious2MinClose\",";
   content += "\"Preious3MinClose\",";
   content += "\"Preious4MinClose\",";
   content += "\"vwma\"\n";
   return(content);
}
//+------------------------------------------------------------------+
string InstrumentProperties::GetPropertyCVS(void)
  {
   string content="";
   /*
   content += "        \""+this.Symbol+"\" : {\n";
   content += "            \"Symbol\"          : \""+this.Symbol+"\",\n";
   content += "            \"InstrType\"       : "+IntegerToString(this.InstrType)+",\n";
   content += "            \"Comment\"         : \""+this.Comment+"\",\n";
   content += "            \"PriceIn\"         : \""+this.PriceIn+"\",\n";
   content += "            \"BaseFileName\"    : \""+this.BaseFileName+"\",\n";
   content += "            \"LotSize\"         : "+IntegerToString(this.LotSize)+",\n";
   content += "            \"Slippage\"        : "+IntegerToString(this.Slippage)+",\n";
   content += "            \"Spread\"          : "+DoubleToString(this.Spread,2)+",\n";
   content += "            \"SwapLong\"        : "+DoubleToString(this.SwapLong,2)+",\n";
   content += "            \"SwapShort\"       : "+DoubleToString(this.SwapShort,2)+",\n";
   content += "            \"Commission\"      : "+DoubleToString(this.Commission,2)+",\n";
   content += "            \"RateToUSD\"       : "+DoubleToString(this.RateToUSD,this.Digits)+",\n";
   content += "            \"RateToEUR\"       : "+DoubleToString(this.RateToEUR,this.Digits)+",\n";
   content += "            \"RateToGBP\"       : "+DoubleToString(this.RateToGBP,this.Digits)+",\n";
   content += "            \"RateToJPY\"       : "+DoubleToString(this.RateToJPY,this.Digits)+",\n";
   content += "            \"SwapType\"        : "+IntegerToString(this.SwapType)+",\n";
   content += "            \"CommissionType\"  : "+IntegerToString(this.CommissionType)+",\n";
   content += "            \"CommissionScope\" : "+IntegerToString(this.CommissionScope)+",\n";
   content += "            \"CommissionTime\"  : "+IntegerToString(this.CommissionTime)+",\n";
   content += "            \"Digits\"          : "+IntegerToString(this.Digits)+",\n";
   content += "            \"Point\"           : "+DoubleToString(this.Point,this.Digits)+",\n";
   content += "            \"Pip\"             : "+DoubleToString(this.Pip,this.Digits)+",\n";
   content += "            \"IsFiveDigits\"    : "+(this.IsFiveDigits?"true":"false")+",\n";
   content += "            \"StopLevel\"       : "+DoubleToString(this.StopLevel,2)+",\n";
   content += "            \"TickValue\"       : "+DoubleToString(this.TickValue,2)+",\n";
   content += "            \"MinLot\"          : "+DoubleToString(this.MinLot,2)+",\n";
   content += "            \"MaxLot\"          : "+DoubleToString(this.MaxLot,2)+",\n";
   content += "            \"LotStep\"         : "+DoubleToString(this.LotStep,2)+",\n";
   content += "            \"MarginRequired\"  : "+DoubleToString(this.MarginRequired,2)+"\n";
   content += "        }";
   */
   
   content += this.Symbol+",";
   content += IntegerToString(this.InstrType)+",";
   content += "\""+this.Comment+"\",";
   content += this.PriceIn+",";
   content += this.BaseFileName+",";
   content += IntegerToString(this.LotSize)+",";
   content += DoubleToString(this.Ask)+",";
   content += DoubleToString(this.Bid)+",";  
   content += IntegerToString(this.Slippage)+",";
   content += DoubleToString(this.Spread,2)+",";
   content += DoubleToString(this.SwapLong,6)+",";
   content += DoubleToString(this.SwapShort,6)+",";
   content += DoubleToString(this.Commission,6)+",";
   content += DoubleToString(this.RateToUSD,this.Digits)+",";
   content += DoubleToString(this.RateToEUR,this.Digits)+",";
   content += DoubleToString(this.RateToGBP,this.Digits)+",";
   content += DoubleToString(this.RateToJPY,this.Digits)+",";
   content += IntegerToString(this.SwapType)+",";
   content += IntegerToString(this.CommissionType)+",";
   content += IntegerToString(this.CommissionScope)+",";
   content += IntegerToString(this.CommissionTime)+",";
   content += IntegerToString(this.Digits)+",";
   content += DoubleToString(this.Point,this.Digits)+",";
   content += DoubleToString(this.Pip,this.Digits)+",";
   content += (this.IsFiveDigits?"true":"false")+",";
   content += DoubleToString(this.StopLevel,6)+",";
   content += DoubleToString(this.TickValue,6)+",";
   content += DoubleToString(this.MinLot,6)+",";
   content += DoubleToString(this.MaxLot,6)+",";
   content += DoubleToString(this.LotStep,6)+",";
   content += DoubleToString(this.MarginRequired,2)+ ",";
   content += DoubleToString(this.RSI_14_1D,6)+",";
   content += DoubleToString(this.RSI_14_30M,6)+",";
   content += DoubleToString(this.PreiousDayClose,6)+",";
   content += DoubleToString(this.PreiousMinClose,6)+",";
   content += DoubleToString(this.Preious5MinClose,6)+",";
   content += DoubleToString(this.Preious15MinClose,6)+",";
   content += DoubleToString(this.RSI_14_4hr,6)+",";
   content += DoubleToString(this.ATR14_D,6)+",";
   content += DoubleToString(this.Preious2MinClose,6)+",";
   content += DoubleToString(this.Preious3MinClose,6)+",";
   content += DoubleToString(this.Preious4MinClose,6)+",";
   content += DoubleToString(this.vwma,6)+",";
   return (content);
  }
  
void RemoveUnTradableInstruments()
  {
   for(int i=0; i<=TotalInstruments(); i++)
     {
      ENUM_SYMBOL_TRADE_MODE
      mode=(ENUM_SYMBOL_TRADE_MODE)
           SymbolInfoInteger(SymbolName(i,false),SYMBOL_TRADE_MODE);
      if((mode != SYMBOL_TRADE_MODE_FULL))
        {
         SymbolSelect(SymbolName(i,false),false);
         Print("Removed ",SymbolName(i,false)," ",
         EnumToString(mode));
        }
      //if(StringFind(SymbolInfoString(SymbolName(i,false), SYMBOL_DESCRIPTION),"CryptoCurrencies"))
      //  {
      //   SymbolSelect(SymbolName(i,false),false);
      //  }
     }

  }
  
 int TotalInstruments()
  {
   return SymbolsTotal(false)-1;
  } 