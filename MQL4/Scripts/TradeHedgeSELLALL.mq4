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
extern int     MagicNumber=719467;
extern string  TradeComment="BTS SELL";


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
   if (!TradeExists) int ticket = OrderSend("GBPUSD",OP_SELL, Lot, MarketInfo("GBPUSD",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURGBP");
   if (!TradeExists) ticket = OrderSend("EURGBP",OP_SELL, Lot, MarketInfo("EURGBP",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("GBPCHF");
   if (!TradeExists) ticket = OrderSend("GBPCHF",OP_SELL, Lot, MarketInfo("GBPCHF",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("CHFJPY");
   if (!TradeExists) ticket = OrderSend("CHFJPY",OP_SELL, Lot, MarketInfo("CHFJPY",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("AUDJPY");
   if (!TradeExists) ticket = OrderSend("AUDJPY",OP_SELL, Lot, MarketInfo("AUDJPY",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURJPY");
   if (!TradeExists) ticket = OrderSend("EURJPY",OP_SELL, Lot, MarketInfo("EURJPY",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("USDCHF");
   if (!TradeExists) ticket = OrderSend("USDCHF",OP_SELL, Lot, MarketInfo("USDCHF",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   
   
   TradeExists = CheckIfTradeAlreadyExists("NZDJPY");
   if (!TradeExists) ticket = OrderSend("NZDJPY",OP_SELL, Lot, MarketInfo("NZDJPY",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("AUDUSD");
   if (!TradeExists) ticket = OrderSend("AUDUSD",OP_SELL, Lot, MarketInfo("AUDUSD",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("USDJPY");
   if (!TradeExists) ticket = OrderSend("USDJPY",OP_SELL, Lot, MarketInfo("USDJPY",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURUSD");
   if (!TradeExists) ticket = OrderSend("EURUSD",OP_SELL, Lot, MarketInfo("EURUSD",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("EURCHF");
   if (!TradeExists) ticket = OrderSend("EURCHF",OP_SELL, Lot, MarketInfo("EURCHF",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("GBPJPY");
   if (!TradeExists) ticket = OrderSend("GBPJPY",OP_SELL, Lot, MarketInfo("GBPJPY",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   TradeExists = CheckIfTradeAlreadyExists("NZDUSD");
   if (!TradeExists) ticket = OrderSend("NZDUSD",OP_SELL, Lot, MarketInfo("NZDUSD",MODE_BID), 2, NULL, NULL, TradeComment, MagicNumber, 0, CLR_NONE);
   if (ticket > -1) TradesSent++;
   
   
   MessageBox("This script opened " + TradesSent + " trades.","Information");
   
   return(0);
  }
//+------------------------------------------------------------------+