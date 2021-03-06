//+------------------------------------------------------------------+
//|                                             CT_Trendy_Expert.mq4 |   
//|                      Copyright © EXACT TRADING BVBA Paul LANGHAM |
//|                            https://www.mql5.com/en/users/goshort |
//+------------------------------------------------------------------+
#property copyright "Copyright © EXACT TRADING BVBA Paul LANGHAM" 
#property version   "1.00"
#property strict 
#property description "Created - 27.07.2020 05:24" 

enum yn
{ 
 n=0,//NO
 y=1 //YES
};

input string EAComment          = "CT Trendy Expert";// EA Comment  
input int    Positions          = 3;      // Positions 
input double Lot                = 1;      // Lot Size 
input double GlobalProfit       = 75;     // Global Profit pips
input double GlobalLoss         = 75;     // Global Loss pips 
input double TP1                = 15;     // Take Profit Price position 1
input double TP2                = 20;     // Take Profit Price position 2
input double TP3                = 25;     // Take Profit Price position 3
input string Time_Start         = "08:00";// Start Time
input string Time_Finish        = "12:00";// Finish Time
input yn     AddTrades          = 0;      // Add additional trades
input int    MN                 = 1;      // Magic Number   

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
double ClosingArray[100];int Pip=10;bool Buy=0, Sell=0;datetime Bar=0; 
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
void OnInit() 
{  
   double bid=MarketInfo(Symbol(),MODE_BID);
   double ls=MarketInfo(Symbol(),MODE_LOTSTEP);
   int dig=(int)MarketInfo(Symbol(),MODE_DIGITS);
    
   if(dig==4 || (bid<1000 && dig==2)) Pip=1; 
   
   EventSetMillisecondTimer(250);

   return;
}  
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{ 
   EventKillTimer(); 

   return;
}  
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Expert timer function                                            |
//+------------------------------------------------------------------+
void OnTimer() 
{  
   if(IsTesting()) return;
   
   if(IsDemo()){ Alert("This version works only on REAL accounts!!!"); return;}
//+------------------------------------------------------------------+
   // Check History...
   if(Bars < 10){ Print("Not enough bars for working the EA");return;}
//+------------------------------------------------------------------+
   double body=MathAbs(iClose(Symbol(),0,1)-iOpen(Symbol(),0,1)); 
   double high=MathMax(iHigh(Symbol(),0,1),iHigh(Symbol(),0,2));
   double low=MathMin(iLow(Symbol(),0,1),iLow(Symbol(),0,2));  
//-------------------------------------------------------------------+
   if(!IsTesting() || Bar!=iTime(Symbol(),0,0)){ Bar=iTime(Symbol(),0,0); Entry();} 
//-------------------------------------------------------------------+
 
   if(GlobalProfit > 0 && Profit() >= GlobalProfit)
     {
      CloseOrders(); Comment("\n","\n","Global Profit has reached! EA will stopped!"); return;
     } 
   if(GlobalLoss > 0 && Profit() < 0 && MathAbs(Profit()) >= GlobalLoss)
     {
      CloseOrders(); Comment("\n","\n","Global Loss has reached! EA will stopped!"); return;
     }
     
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//       
 
   if(GoodTime() && (IsTesting() || (IsExpertEnabled() && IsTradeAllowed())))
     {  
      if(Buy && ((AddTrades==0 && 1 > Orders()) || (AddTrades==1 && CurrBar())) && ClosedBar() && MarginCheck(0)) 
        {  
         double Sloss=0;   
              
         if(iOpen(Symbol(),0,0)-body*2 >= low) Sloss = low; else Sloss = iOpen(Symbol(),0,0)-body*2;
         
         if(Positions >= 1){ double Tprof=0; if(TP1 > 0){ Tprof = Ask + TP1 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_BUY, Lots(), Ask, Pip, Sloss, Tprof, EAComment, MN, 0, clrBlue);  
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
         
         if(Positions >= 2){ double Tprof2=0; if(TP2 > 0){ Tprof2 = Ask + TP2 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_BUY, Lots(), Ask, Pip, Sloss, Tprof2, EAComment, MN, 0, clrBlue);  
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}

         if(Positions >= 3){ double Tprof3=0; if(TP3 > 0){ Tprof3 = Ask + TP3 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_BUY, Lots(), Ask, Pip, Sloss, Tprof3, EAComment, MN, 0, clrBlue);  
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}  
        }       
      if(Sell && ((AddTrades==0 && 1 > Orders()) || (AddTrades==1 && CurrBar())) && ClosedBar() && MarginCheck(1)) 
        { 
         double Sloss=0;  
         
         if(iOpen(Symbol(),0,0)+body*2 <= high) Sloss = high; else Sloss = iOpen(Symbol(),0,0)+body*2;
         
         if(Positions >= 1){ double Tprof=0; if(TP1 > 0){ Tprof = Bid - TP1 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_SELL, Lots(), Bid, Pip, Sloss, Tprof, EAComment, MN, 0, clrRed); 
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
         
         if(Positions >= 2){ double Tprof2=0; if(TP2 > 0){ Tprof2 = Bid - TP2 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_SELL, Lots(), Bid, Pip, Sloss, Tprof2, EAComment, MN, 0, clrRed); 
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
         
         if(Positions >= 3){ double Tprof3=0; if(TP3 > 0){ Tprof3 = Bid - TP3 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_SELL, Lots(), Bid, Pip, Sloss, Tprof3, EAComment, MN, 0, clrRed); 
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
        }    
     }       
}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{   
   if(!IsTesting()) return;
   
   if(IsDemo()){ Alert("This version works only on REAL accounts!!!"); return;}
//+------------------------------------------------------------------+
   // Check History...
   if(Bars < 10){ Print("Not enough bars for working the EA"); return;}
//+------------------------------------------------------------------+  
   double body=MathAbs(iClose(Symbol(),0,1)-iOpen(Symbol(),0,1)); 
   double high=MathMax(iHigh(Symbol(),0,1),iHigh(Symbol(),0,2));
   double low=MathMin(iLow(Symbol(),0,1),iLow(Symbol(),0,2));  
   
//-------------------------------------------------------------------+
   if(!IsTesting() || Bar!=iTime(Symbol(),0,0)){ Bar=iTime(Symbol(),0,0); Entry();} 
//-------------------------------------------------------------------+
 
   if(GlobalProfit > 0 && Profit() >= GlobalProfit)
     {
      CloseOrders(); Comment("\n","\n","Global Profit has reached! EA will stopped!"); return;
     } 
   if(GlobalLoss > 0 && Profit() < 0 && MathAbs(Profit()) >= GlobalLoss)
     {
      CloseOrders(); Comment("\n","\n","Global Loss has reached! EA will stopped!"); return;
     } 
   
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//       
 
   if(GoodTime() && (IsTesting() || (IsExpertEnabled() && IsTradeAllowed())))
     {  
      if(Buy && ((AddTrades==0 && 1 > Orders()) || (AddTrades==1 && CurrBar())) && ClosedBar() && MarginCheck(0)) 
        {  
         double Sloss=0;   
              
         if(iOpen(Symbol(),0,0)-body*2 >= low) Sloss = low; else Sloss = iOpen(Symbol(),0,0)-body*2;
         
         if(Positions >= 1){ double Tprof=0; if(TP1 > 0){ Tprof = Ask + TP1 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_BUY, Lots(), Ask, Pip, Sloss, Tprof, EAComment, MN, 0, clrBlue);  
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
         
         if(Positions >= 2){ double Tprof2=0; if(TP2 > 0){ Tprof2 = Ask + TP2 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_BUY, Lots(), Ask, Pip, Sloss, Tprof2, EAComment, MN, 0, clrBlue);  
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}

         if(Positions >= 3){ double Tprof3=0; if(TP3 > 0){ Tprof3 = Ask + TP3 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_BUY, Lots(), Ask, Pip, Sloss, Tprof3, EAComment, MN, 0, clrBlue);  
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}  
        }       
      if(Sell && ((AddTrades==0 && 1 > Orders()) || (AddTrades==1 && CurrBar())) && ClosedBar() && MarginCheck(1)) 
        { 
         double Sloss=0;  
         
         if(iOpen(Symbol(),0,0)+body*2 <= high) Sloss = high; else Sloss = iOpen(Symbol(),0,0)+body*2;
         
         if(Positions >= 1){ double Tprof=0; if(TP1 > 0){ Tprof = Bid - TP1 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_SELL, Lots(), Bid, Pip, Sloss, Tprof, EAComment, MN, 0, clrRed); 
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
         
         if(Positions >= 2){ double Tprof2=0; if(TP2 > 0){ Tprof2 = Bid - TP2 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_SELL, Lots(), Bid, Pip, Sloss, Tprof2, EAComment, MN, 0, clrRed); 
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
         
         if(Positions >= 3){ double Tprof3=0; if(TP3 > 0){ Tprof3 = Bid - TP3 * point();} 
         
         int ticket=OrderSend(Symbol(), OP_SELL, Lots(), Bid, Pip, Sloss, Tprof3, EAComment, MN, 0, clrRed); 
         
         int err=GetLastError(); if(err!=ERR_NO_ERROR){ Print("Error on opening of order = ", ErrorDescription(err));}}
        }    
     }                           
   return;
}      
//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO//
//+------------------------------------------------------------------+
//|  Get the values from the indicators                              |    
//+------------------------------------------------------------------+
double SI(int bf,int sh){ return(iCustom(Symbol(),0,"Trendy_v1.2_live_slow5955",bf,sh));}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//  
//+------------------------------------------------------------------+
//| Get Entry Signals                                                |  
//+------------------------------------------------------------------+
void Entry() 
{   
   Buy  = (SI(0,1) > 0); 
   
   Sell = (SI(1,1) > 0);   
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Calculate Trade Volume(Lot)                                      |
//+------------------------------------------------------------------+
double Lots()
{ 
   double lots=Lot, LotStep=MarketInfo(Symbol(),MODE_LOTSTEP),  
   MaxLot=MarketInfo(Symbol(),MODE_MAXLOT), MinLot=MarketInfo(Symbol(),MODE_MINLOT);
 
   return( MathRound(MathMin(MathMax(lots,MinLot),MaxLot)/LotStep)*LotStep );
}    
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Trade Time Settings                                              |
//+------------------------------------------------------------------+   
bool GoodTime()
{
  int hs1 = StrToInteger(StringSubstr(Time_Start, 0, 2)), ms1 = StrToInteger(StringSubstr(Time_Start, 3, 2));
  int he1 = StrToInteger(StringSubstr(Time_Finish, 0, 2)), me1 = StrToInteger(StringSubstr(Time_Finish, 3, 2));
 
  if(hs1 <= he1)
    {
    if(((TimeHour(TimeCurrent()) == hs1 && TimeMinute(TimeCurrent()) >= ms1) && TimeHour(TimeCurrent()) < he1) 
    || (TimeMinute(TimeCurrent()) < me1 && TimeHour(TimeCurrent()) == he1 && TimeHour(TimeCurrent()) == hs1 && TimeMinute(TimeCurrent()) >= ms1)
    || ((TimeMinute(TimeCurrent()) <= me1 && TimeHour(TimeCurrent()) == he1) && TimeHour(TimeCurrent()) > hs1) 
    || (TimeHour(TimeCurrent()) < he1 && TimeHour(TimeCurrent()) > hs1))
    return(true);
    }
  if(hs1 > he1)
    {
    if((TimeHour(TimeCurrent()) == hs1 && TimeMinute(TimeCurrent()) >= ms1 && TimeHour(TimeCurrent()) < 24)
    || (TimeHour(TimeCurrent()) > hs1 && TimeHour(TimeCurrent()) < 24)
    || (TimeHour(TimeCurrent()) == he1 && TimeMinute(TimeCurrent()) <= me1 && TimeHour(TimeCurrent()) >= 0)
    || (TimeHour(TimeCurrent()) < he1 && TimeHour(TimeCurrent()) >= 0))
    return(true);
    }    
   return(false);   
}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------+
//|  Close Orders                                              |
//+------------------------------------------------------------+  
bool CloseOrders(int type=-1)
{ //-1= All,0=Buy,1=Sell,2=BuyLimit,3=SellLimit,4=BuyStop,5=SellStop,6=All Buys,7=All Sells,8=All Market,9=All Pending;
   bool oc=0; double ask=MarketInfo(Symbol(), MODE_ASK), bid=MarketInfo(Symbol(), MODE_BID); 
    
   for(int i=OrdersTotal()-1;i>=0;i--){
   bool os = OrderSelect(i,SELECT_BY_POS, MODE_TRADES);
   if(OrderSymbol()==Symbol() && (MN==0 || OrderMagicNumber()==MN))
     {   
      if(type==-1){
      if(OrderType()==0){ oc = OrderClose(OrderTicket(),OrderLots(),bid,1000,clrGold);}
      if(OrderType()==1){ oc = OrderClose(OrderTicket(),OrderLots(),ask,1000,clrGold);}      
      if(OrderType()>1){ oc = OrderDelete(OrderTicket());}}  
      if(OrderType()>1 && type==9){ oc = OrderDelete(OrderTicket());} 
      if(OrderType()<=1 && type==8){ oc = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),1000,clrGold);}
      if(OrderType()==type && type==0){ oc = OrderClose(OrderTicket(),OrderLots(),bid,1000,clrGold);}
      if(OrderType()==type && type==1){ oc = OrderClose(OrderTicket(),OrderLots(),ask,1000,clrGold);} 
      if(OrderType()==type && OrderType()> 1){ oc = OrderDelete(OrderTicket());} 
      if(OrderType()==0 && type==6){ oc = OrderClose(OrderTicket(),OrderLots(),bid,1000,clrGold);}  
      if((OrderType()==2 || OrderType()== 4) && type==6){ oc = OrderDelete(OrderTicket());}   
      if(OrderType()==1 && type==7){ oc = OrderClose(OrderTicket(),OrderLots(),ask,1000,clrGold);}  
      if((OrderType()==3 || OrderType()== 5) && type==7){ oc = OrderDelete(OrderTicket());}       
      
      for(int x=0;x<100;x++)
      {
       if(ClosingArray[x]==0)
       {
        ClosingArray[x]=OrderTicket();
        break; } } } }
   return(oc);
}   
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Get amount of open orders                                        |
//+------------------------------------------------------------------+
int Orders(int type=-1)
{
   int count=0;
   //-1= All,0=Buy,1=Sell,2=BuyLimit,3=SellLimit,4=BuyStop,5=SellStop,6=AllBuy,7=AllSell,8=AllMarket,9=AllPending;   
   for(int x=OrdersTotal()-1;x>=0;x--)
      {
      if(OrderSelect(x,SELECT_BY_POS,MODE_TRADES)){ 
      if(OrderSymbol()==Symbol() && (MN==0 || OrderMagicNumber()==MN)) 
        {
         if(type < 0){ count++;}
         if(OrderType() == type && type >= 0){ count++;}  
         if(OrderType() <= 1 && type == 8){ count++;}  
         if(OrderType() > 1 && type == 9){ count++;}  
         if((OrderType() == 0 || OrderType() == 2 || OrderType() == 4) && type == 6){ count++;}
         if((OrderType() == 1 || OrderType() == 3 || OrderType() == 5) && type == 7){ count++;}       
        }}}   
   return(count);
}     
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Check Pips Profit                                                |
//+------------------------------------------------------------------+     
double Profit(int type=-1)  
{
   double BuyPt=0, SellPt=0; 

   for(int i=OrdersTotal()-1;i>=0;i--)
      {
       bool os = OrderSelect(i,SELECT_BY_POS, MODE_TRADES);            
       if(OrderSymbol()==Symbol() && (MN==0 || OrderMagicNumber()==MN) && OrderOpenTime() >= StrToTime(Time_Start))
         {        
          if(OrderType()==OP_BUY) BuyPt += ((MarketInfo(OrderSymbol(),MODE_BID)-OrderOpenPrice())/point());  
          if(OrderType()==OP_SELL) SellPt += ((OrderOpenPrice()-MarketInfo(OrderSymbol(),MODE_ASK))/point());  
         }
      }     
   for(int i=OrdersHistoryTotal()-1;i>=0;i--)
      {
       bool os = OrderSelect(i,SELECT_BY_POS, MODE_HISTORY);    
               
       if(OrderSymbol()==Symbol() && (MN==0 || OrderMagicNumber()==MN) && OrderOpenTime() >= StrToTime(Time_Start))
         {        
          if(OrderType()==OP_BUY) BuyPt += ((OrderClosePrice()-OrderOpenPrice())/point());  
          if(OrderType()==OP_SELL) SellPt += ((OrderOpenPrice()-OrderClosePrice())/point());  
         }
      } 
      
   if(0==type){ return(BuyPt);}
   if(1==type){ return(SellPt);}
   if(-1==type){ return(BuyPt+SellPt);}
   
   return(0);
}  
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Check Free Margin                                                |
//+------------------------------------------------------------------+
bool MarginCheck(int type)// 0 - buy, 1 - sell;
{  
   if((AccountFreeMarginCheck(Symbol(), type, Lots()) <= 0.0 || 
      GetLastError() == ERR_NOT_ENOUGH_MONEY)){
      Print("NOT ENOUGH MONEY TO TRADE OPEN");return(false);}             
   return(true);
}     
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Check Symbol Points                                              |
//+------------------------------------------------------------------+     
double point(string symbol=NULL)  
{  
   string sym=symbol;
   if(symbol==NULL) sym=Symbol();
   double bid=MarketInfo(sym,MODE_BID);
   int digits=(int)MarketInfo(sym,MODE_DIGITS);
   
   if(digits<=1) return(1); //CFD & Indexes  
   if(digits==4 || digits==5) return(0.0001); 
   if((digits==2 || digits==3) && bid>1000) return(1);
   if((digits==2 || digits==3) && bid<1000) return(0.01);
   if(StringFind(sym,"XAU")>-1 || StringFind(sym,"xau")>-1 || StringFind(sym,"GOLD")>-1) return(0.1);//Gold  
   return(0);
}
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Disable trade in current bar(if one is already open)             |
//+------------------------------------------------------------------+
bool CurrBar()
{ 
   bool yes = 1;
//+------------------------------------------------------------------+
   for(int i = OrdersTotal()-1; i >= 0; i--)
      {
    	if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
    	{  
    	if(OrderSymbol()==Symbol() && (MN==0 || OrderMagicNumber()==MN)) 
      {     
       if(OrderOpenTime() >= iTime(Symbol(),0,0)) yes = 0;}}   
      }   
   return(yes);
}   
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Disable trade in current bar(if one is already opened and closed)|
//+------------------------------------------------------------------+
bool ClosedBar()
{ 
   bool yes = 1;
//+------------------------------------------------------------------+
   for(int i = OrdersHistoryTotal()-1; i>=0; i--)
      {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) 
      { 
      Print("Error in history!"); break; 
      }
      if(OrderSymbol() != Symbol() || OrderType()>OP_SELL) continue;
      if(OrderSymbol()==Symbol() && (MN==0 || OrderMagicNumber()==MN)) 
      {	    
      if(OrderOpenTime() >= iTime(Symbol(),0,0)) yes = 0;   
    	}}   
   return(yes);
}  
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
//+------------------------------------------------------------------+
//| Errors Description                                               |
//+------------------------------------------------------------------+
string ErrorDescription(int error_code)
  {
   string error_string;
//---
   switch(error_code)
     {
      //--- codes returned from trade server
      case 0:   error_string="no error";                                                   break;
      case 1:   error_string="no error, trade conditions not changed";                     break;
      case 2:   error_string="common error";                                               break;
      case 3:   error_string="invalid trade parameters";                                   break;
      case 4:   error_string="trade server is busy";                                       break;
      case 5:   error_string="old version of the client terminal";                         break;
      case 6:   error_string="no connection with trade server";                            break;
      case 7:   error_string="not enough rights";                                          break;
      case 8:   error_string="too frequent requests";                                      break;
      case 9:   error_string="malfunctional trade operation (never returned error)";       break;
      case 64:  error_string="account disabled";                                           break;
      case 65:  error_string="invalid account";                                            break;
      case 128: error_string="trade timeout";                                              break;
      case 129: error_string="invalid price";                                              break;
      case 130: error_string="invalid stops";                                              break;
      case 131: error_string="invalid trade volume";                                       break;
      case 132: error_string="market is closed";                                           break;
      case 133: error_string="trade is disabled";                                          break;
      case 134: error_string="not enough money";                                           break;
      case 135: error_string="price changed";                                              break;
      case 136: error_string="off quotes";                                                 break;
      case 137: error_string="broker is busy (never returned error)";                      break;
      case 138: error_string="requote";                                                    break;
      case 139: error_string="order is locked";                                            break;
      case 140: error_string="long positions only allowed";                                break;
      case 141: error_string="too many requests";                                          break;
      case 145: error_string="modification denied because order is too close to market";   break;
      case 146: error_string="trade context is busy";                                      break;
      case 147: error_string="expirations are denied by broker";                           break;
      case 148: error_string="amount of open and pending orders has reached the limit";    break;
      case 149: error_string="hedging is prohibited";                                      break;
      case 150: error_string="prohibited by FIFO rules";                                   break;
      //--- mql4 errors
      case 4000: error_string="no error (never generated code)";                           break;
      case 4001: error_string="wrong function pointer";                                    break;
      case 4002: error_string="array index is out of range";                               break;
      case 4003: error_string="no memory for function call stack";                         break;
      case 4004: error_string="recursive stack overflow";                                  break;
      case 4005: error_string="not enough stack for parameter";                            break;
      case 4006: error_string="no memory for parameter string";                            break;
      case 4007: error_string="no memory for temp string";                                 break;
      case 4008: error_string="non-initialized string";                                    break;
      case 4009: error_string="non-initialized string in array";                           break;
      case 4010: error_string="no memory for array\' string";                              break;
      case 4011: error_string="too long string";                                           break;
      case 4012: error_string="remainder from zero divide";                                break;
      case 4013: error_string="zero divide";                                               break;
      case 4014: error_string="unknown command";                                           break;
      case 4015: error_string="wrong jump (never generated error)";                        break;
      case 4016: error_string="non-initialized array";                                     break;
      case 4017: error_string="dll calls are not allowed";                                 break;
      case 4018: error_string="cannot load library";                                       break;
      case 4019: error_string="cannot call function";                                      break;
      case 4020: error_string="expert function calls are not allowed";                     break;
      case 4021: error_string="not enough memory for temp string returned from function";  break;
      case 4022: error_string="system is busy (never generated error)";                    break;
      case 4023: error_string="dll-function call critical error";                          break;
      case 4024: error_string="internal error";                                            break;
      case 4025: error_string="out of memory";                                             break;
      case 4026: error_string="invalid pointer";                                           break;
      case 4027: error_string="too many formatters in the format function";                break;
      case 4028: error_string="parameters count is more than formatters count";            break;
      case 4029: error_string="invalid array";                                             break;
      case 4030: error_string="no reply from chart";                                       break;
      case 4050: error_string="invalid function parameters count";                         break;
      case 4051: error_string="invalid function parameter value";                          break;
      case 4052: error_string="string function internal error";                            break;
      case 4053: error_string="some array error";                                          break;
      case 4054: error_string="incorrect series array usage";                              break;
      case 4055: error_string="custom indicator error";                                    break;
      case 4056: error_string="arrays are incompatible";                                   break;
      case 4057: error_string="global variables processing error";                         break;
      case 4058: error_string="global variable not found";                                 break;
      case 4059: error_string="function is not allowed in testing mode";                   break;
      case 4060: error_string="function is not confirmed";                                 break;
      case 4061: error_string="send mail error";                                           break;
      case 4062: error_string="string parameter expected";                                 break;
      case 4063: error_string="integer parameter expected";                                break;
      case 4064: error_string="double parameter expected";                                 break;
      case 4065: error_string="array as parameter expected";                               break;
      case 4066: error_string="requested history data is in update state";                 break;
      case 4067: error_string="internal trade error";                                      break;
      case 4068: error_string="resource not found";                                        break;
      case 4069: error_string="resource not supported";                                    break;
      case 4070: error_string="duplicate resource";                                        break;
      case 4071: error_string="cannot initialize custom indicator";                        break;
      case 4072: error_string="cannot load custom indicator";                              break;
      case 4073: error_string="no history data";                                           break;
      case 4074: error_string="not enough memory for history data";                        break;
      case 4075: error_string="not enough memory for indicator";                           break;
      case 4099: error_string="end of file";                                               break;
      case 4100: error_string="some file error";                                           break;
      case 4101: error_string="wrong file name";                                           break;
      case 4102: error_string="too many opened files";                                     break;
      case 4103: error_string="cannot open file";                                          break;
      case 4104: error_string="incompatible access to a file";                             break;
      case 4105: error_string="no order selected";                                         break;
      case 4106: error_string="unknown symbol";                                            break;
      case 4107: error_string="invalid price parameter for trade function";                break;
      case 4108: error_string="invalid ticket";                                            break;
      case 4109: error_string="trade is not allowed in the expert properties";             break;
      case 4110: error_string="longs are not allowed in the expert properties";            break;
      case 4111: error_string="shorts are not allowed in the expert properties";           break;
      case 4200: error_string="object already exists";                                     break;
      case 4201: error_string="unknown object property";                                   break;
      case 4202: error_string="object does not exist";                                     break;
      case 4203: error_string="unknown object type";                                       break;
      case 4204: error_string="no object name";                                            break;
      case 4205: error_string="object coordinates error";                                  break;
      case 4206: error_string="no specified subwindow";                                    break;
      case 4207: error_string="graphical object error";                                    break;
      case 4210: error_string="unknown chart property";                                    break;
      case 4211: error_string="chart not found";                                           break;
      case 4212: error_string="chart subwindow not found";                                 break;
      case 4213: error_string="chart indicator not found";                                 break;
      case 4220: error_string="symbol select error";                                       break;
      case 4250: error_string="notification error";                                        break;
      case 4251: error_string="notification parameter error";                              break;
      case 4252: error_string="notifications disabled";                                    break;
      case 4253: error_string="notification send too frequent";                            break;
      case 4260: error_string="ftp server is not specified";                               break;
      case 4261: error_string="ftp login is not specified";                                break;
      case 4262: error_string="ftp connect failed";                                        break;
      case 4263: error_string="ftp connect closed";                                        break;
      case 4264: error_string="ftp change path error";                                     break;
      case 4265: error_string="ftp file error";                                            break;
      case 4266: error_string="ftp error";                                                 break;
      case 5001: error_string="too many opened files";                                     break;
      case 5002: error_string="wrong file name";                                           break;
      case 5003: error_string="too long file name";                                        break;
      case 5004: error_string="cannot open file";                                          break;
      case 5005: error_string="text file buffer allocation error";                         break;
      case 5006: error_string="cannot delete file";                                        break;
      case 5007: error_string="invalid file handle (file closed or was not opened)";       break;
      case 5008: error_string="wrong file handle (handle index is out of handle table)";   break;
      case 5009: error_string="file must be opened with FILE_WRITE flag";                  break;
      case 5010: error_string="file must be opened with FILE_READ flag";                   break;
      case 5011: error_string="file must be opened with FILE_BIN flag";                    break;
      case 5012: error_string="file must be opened with FILE_TXT flag";                    break;
      case 5013: error_string="file must be opened with FILE_TXT or FILE_CSV flag";        break;
      case 5014: error_string="file must be opened with FILE_CSV flag";                    break;
      case 5015: error_string="file read error";                                           break;
      case 5016: error_string="file write error";                                          break;
      case 5017: error_string="string size must be specified for binary file";             break;
      case 5018: error_string="incompatible file (for string arrays-TXT, for others-BIN)"; break;
      case 5019: error_string="file is directory, not file";                               break;
      case 5020: error_string="file does not exist";                                       break;
      case 5021: error_string="file cannot be rewritten";                                  break;
      case 5022: error_string="wrong directory name";                                      break;
      case 5023: error_string="directory does not exist";                                  break;
      case 5024: error_string="specified file is not directory";                           break;
      case 5025: error_string="cannot delete directory";                                   break;
      case 5026: error_string="cannot clean directory";                                    break;
      case 5027: error_string="array resize error";                                        break;
      case 5028: error_string="string resize error";                                       break;
      case 5029: error_string="structure contains strings or dynamic arrays";              break;
      default:   error_string="unknown error";
     }
//---
   return(error_string);
  } 
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH\\
//                                                                           _________                                                                                    ||
//                                                                          /         \                                                                                   ||
//                                                                         |  THE END  |                                                                                  ||
//                                                                          \_________/                                                                                   ||
//                                                                                                                                                                        ||
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH//
 