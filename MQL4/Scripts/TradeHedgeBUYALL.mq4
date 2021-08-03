//+------------------------------------------------------------------+
//|                                                      mIBFXHedge  |
//|                               Copyright © 2008, Julius Figueroa  |
//|                                          trader101@Optonline.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Julius Figueroa"
#property link      "trader101@optonline.net"

#property show_inputs
#include <WinUser32.mqh>
#include <stdlib.mqh>

extern double  Lot = 0.01;
extern int     MagicNumber=71946723;
extern string  TradeComment="BTS BUY";


bool CheckIfTradeAlreadyExists(string symbol)
   {
      if (OrdersTotal()==0) return(false);
      for (int cc=0; cc<OrdersTotal();cc++)
      {
         OrderSelect(cc, SELECT_BY_POS);
         if (OrderSymbol()==symbol && OrderMagicNumber()==MagicNumber) return(true);
      }
      return(false);
   
   }// end bool CheckTrendExists()

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   
   int TradesSent=0;
   
   bool TradeExists = CheckIfTradeAlreadyExists("GBPUSD");
   if (!TradeExists) int ticket = OrderSend("GBPUSD",OP_BUY, Lot, MarketInfo("GBPUSD",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURGBP");
   if (!TradeExists) ticket = OrderSend("EURGBP",OP_BUY, Lot, MarketInfo("EURGBP",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("GBPCHF");
   if (!TradeExists) ticket = OrderSend("GBPCHF",OP_BUY, Lot, MarketInfo("GBPCHF",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("CHFJPY");
   if (!TradeExists) ticket = OrderSend("CHFJPY",OP_BUY, Lot, MarketInfo("CHFJPY",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("AUDJPY");
   if (!TradeExists) ticket = OrderSend("AUDJPY",OP_BUY, Lot, MarketInfo("AUDJPY",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURJPY");
   if (!TradeExists) ticket = OrderSend("EURJPY",OP_BUY, Lot, MarketInfo("EURJPY",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("USDCHF");
   if (!TradeExists) ticket = OrderSend("USDCHF",OP_BUY, Lot, MarketInfo("USDCHF",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   
   
   TradeExists = CheckIfTradeAlreadyExists("NZDJPY");
   if (!TradeExists) ticket = OrderSend("NZDJPY",OP_BUY, Lot, MarketInfo("NZDJPY",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("AUDUSD");
   if (!TradeExists) ticket = OrderSend("AUDUSD",OP_BUY, Lot, MarketInfo("AUDUSD",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("USDJPY");
   if (!TradeExists) ticket = OrderSend("USDJPY",OP_BUY, Lot, MarketInfo("USDJPY",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURUSD");
   if (!TradeExists) ticket = OrderSend("EURUSD",OP_BUY, Lot, MarketInfo("EURUSD",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURCHF");
   if (!TradeExists) ticket = OrderSend("EURCHF",OP_BUY, Lot, MarketInfo("EURCHF",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("GBPJPY");
   if (!TradeExists) ticket = OrderSend("GBPJPY",OP_BUY, Lot, MarketInfo("GBPJPY",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("NZDUSD");
   if (!TradeExists) ticket = OrderSend("NZDUSD",OP_BUY, Lot, MarketInfo("NZDUSD",MODE_ASK), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   
   MessageBox("This script opened " + TradesSent + " trades.","Information");
   
   return(0);
  }
//+------------------------------------------------------------------+