//+------------------------------------------------------------------+
//|                                                   OpenCharts.mq4 |
//|                                                         renexxxx |
//| This script was developed by renexxxx from the                   |
//|    http://www.stevehopwoodforex.com/ forum.                      |
//|                                                                  |
//| version 0.1   initial release (RZ)                               |
//|------------------------------------------------------------------+
#property copyright "renexxxx"
#property link      "http://www.stevehopwoodforex.com/"
#property version   "1.10"
#property strict
#property show_inputs

input string           IncludeSymbols       = "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY,EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD,NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY";
input bool             SortAlphabetically   = true;
input string           TemplateName         = "default.tpl";
input ENUM_TIMEFRAMES  TimeFrame            = PERIOD_H4;

string pair[];

//+------------------------------------------------------------------+
//| createSymbolNamesArray()                                         |
//+------------------------------------------------------------------+
void createSymbolNamesArray( string &symbolNames[] ) {

   static const ushort comma = StringGetChar(",",0);

   string allSymbols[];
   getAllSymbols( allSymbols );
   
   string mySymbols[];
   StringSplit(IncludeSymbols, comma, mySymbols);
   
   ArrayFree(symbolNames);
   ArrayResize(symbolNames, 0);
   
 
   for(int iSymbol=0; iSymbol < ArraySize(mySymbols); iSymbol++) {
      
      string symbolName = StringTrimLeft(StringTrimRight(mySymbols[iSymbol])); // trim whitespace of left and right
      
      if (findInStringArray(allSymbols, symbolName) >= 0) {
      
         // Make sure it is selected
         SymbolSelect(symbolName, true);

         int currentSize = ArraySize(symbolNames);
         ArrayResize(symbolNames, currentSize+1);
         symbolNames[currentSize] = symbolName;
      }
   }
   
}

void getAllSymbols( string &symbolNames[] ) {

   ArrayFree(symbolNames);
   ArrayResize(symbolNames, 0);
   
   for(int iSymbol=0; iSymbol < SymbolsTotal(false); iSymbol++) {
   
      int currentSize = ArraySize(symbolNames);
      ArrayResize(symbolNames, currentSize+1);
      symbolNames[currentSize] = SymbolName(iSymbol, false);
   }
}

int findInStringArray(string &array[], string elem) {

   int result = -1;
   
   for(int index=0; index < ArraySize(array); index++) {
   
      if ( array[index] == elem ) {
         result = index;
         break;
      }
   }
   return(result);
}

//+------------------------------------------------------------------+
//| return true if chart (symbol,timeframe) is already open          |
//+------------------------------------------------------------------+
bool isChartOpen( string symbol, int timeFrame ) {

   bool isOpen = false;
   long chartID = ChartFirst();
   
   while( chartID >= 0 ) {
      if ( ( chartID != ChartID() ) && ( ChartSymbol( chartID ) == symbol ) && ( ChartPeriod( chartID ) == timeFrame ) ) {
         isOpen = true;
         break;
      }
      chartID = ChartNext( chartID );
   }
   return(isOpen);
}

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart() {

   for(int i=SymbolsTotal(true)-1; i>=0; i--)
     {
      ChartOpen(SymbolName(i,true),PERIOD_H1);
      long ch=ChartFirst()+1;
      if(ch!=ChartID())
         ChartClose(ch);
      ChartClose(ChartID());
     }
    /*
   long chartID;
   int  timeFrame = (int)TimeFrame;
   if (timeFrame == 0) timeFrame = _Period;

   // Load the selected symbols into pair[]
   createSymbolNamesArray( pair );
   
   // Sort pair[] is so desired
   if ( SortAlphabetically ) ArraySort( pair );
   
   for (int iPair=0; iPair < ArraySize(pair); iPair++) {
      if ( ! isChartOpen( pair[iPair], timeFrame ) ) {
         
         chartID = ChartOpen( pair[iPair],timeFrame );
         if ( chartID > 0 ) {
            string templateName = TemplateName;
            string extension = StringSubstr(templateName, StringLen(templateName)-4);
            StringToLower(extension);
            // Check if the templateName ends with .tpl, and add it if not.
            if ( extension != ".tpl" ) templateName = templateName+".tpl";
            ChartApplyTemplate(chartID, templateName);
         } // if
      } // if
   } // for
   
   */
}