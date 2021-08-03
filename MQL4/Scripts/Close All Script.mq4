//+------------------------------------------------------------------+
//|                                                     CloseAll.mq4 |
//|  Version 2.00  (7-July-2011)                                     |
//|                                                       CodersGuru |
//|                                            http://www.xpworx.com |
//+------------------------------------------------------------------+

#property copyright "CodersGuru"
#property link      "http://www.xpworx.com"
#property show_inputs

extern int option = 0;
//+------------------------------------------------------------------+
// Set this prameter to the type of clsoing you want:
// 0- Close all (instant and pending orders) (Default)
// 1- Close all instant orders
// 2- Close all pending orders
// 3- Close by the magic number
// 4- Close by comment
// 5- Close orders in profit
// 6- Close orders in loss
// 7- Close not today orders
// 8- Close before day orders
//+------------------------------------------------------------------+

extern int magic_number = 0; // set it if you'll use closing option 3 - closing by magic number
extern string comment_text = ""; // set it if you'll use closing option 4 - closing by comment
extern int before_day = 0; // set it if you'll use closing option 8 - closing by before day


int start()
  {
   CloseAll();
   return(0);
  }
//+------------------------------------------------------------------+

int CloseAll()
{
   int total = OrdersTotal();
   int cnt = 0;
 
   switch (option)
   {
      case 0:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(Symbol()!=OrderSymbol()) RefreshRates();
            if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
            if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
            if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
         }
         break;
      }
      case 1:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(Symbol()!=OrderSymbol()) RefreshRates();
            if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
            if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
         }
         break;
      }
      case 2:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
         }
         break;
      }
      case 3:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if (OrderMagicNumber() == magic_number)
            {
               if(Symbol()!=OrderSymbol()) RefreshRates();
               if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
               if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
               if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
           }
         }         
         break;
      }
      case 4:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if (OrderComment() == comment_text)
            {
               if(Symbol()!=OrderSymbol()) RefreshRates();
               if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
               if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
               if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
           }
         }         
         break;
      }      
      case 5:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(OrderProfit() > 0)
            {
               if(Symbol()!=OrderSymbol()) RefreshRates();
               if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
               if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
               if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
           }
         }         
         break;
      }            
      case 6:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(OrderProfit() < 0)
            {
               if(Symbol()!=OrderSymbol()) RefreshRates();
               if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
               if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
               if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
           }
         }         
         break;
      }            
      case 7:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(TimeDay(OrderOpenTime())!=TimeDay(TimeCurrent()))
            {
               if(Symbol()!=OrderSymbol()) RefreshRates();
               if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
               if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
               if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
           }
         }         
         break;
      }   
      case 8:
      {
         for (cnt = total ; cnt >=0 ; cnt--)
         {
            OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
            if(TimeDay(OrderOpenTime())<before_day)
            {
               if(Symbol()!=OrderSymbol()) RefreshRates();
               if(OrderType()==OP_BUY) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),5,Violet);
               if(OrderType()==OP_SELL) OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),5,Violet);
               if(OrderType()>OP_SELL) OrderDelete(OrderTicket());
           }
         }         
         break;
      }                           
   }
}