//+------------------------------------------------------------------+
//|                                               Object_to_File.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.ru/"

#property show_inputs
string SymbolsArray[6]={"","AUDJPY","AUDUSD","EURCAD","EURCHF","EURGBP"};



//+------------------------------------------------------------------+
//| string SymbolByNumber                                   |
//+------------------------------------------------------------------+
string GetSymbolString(int Number)
  {
//----
   string res="";
   res=SymbolsArray[Number];   
//----
   return(res);
  }



//+------------------------------------------------------------------+
//|   âûâîäèò â ôàéë êîòèðîâêè + çíà÷åíèÿ èíäèêàòîðà                 |
//+------------------------------------------------------------------+
void Line_output(string SymbolName)
   {
   
//----
   
   int handle=FileOpen("LineValue.csv",FILE_CSV|FILE_READ|FILE_WRITE, ';');
   
   if(handle>0) 
   {
   FileSeek(handle, 0, SEEK_END);
   FileWrite(handle,"Symbol;Time;High;Low");
   
   
   for (int i=10;i>0;i--)
      {
      FileWrite(handle,SymbolName,TimeToStr(ObjectGet("MyLineHigh"+i,OBJPROP_TIME1))
         ,ObjectGet("MyLineHigh"+i,OBJPROP_PRICE1), ObjectGet("MyLineLow"+i,OBJPROP_PRICE1)) ;
         
      }
   FileClose(handle);
   handle=0;
   }      
//----
   return;
   }
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
  int SymbolCounter; 
//----
   
   for (SymbolCounter=1;SymbolCounter<6;SymbolCounter++)
      {
                 
         Line_output(GetSymbolString(SymbolCounter));
      }  
//----
   return(0);
  }
//+------------------------------------------------------------------+