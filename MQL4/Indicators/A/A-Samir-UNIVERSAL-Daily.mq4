//+------------------------------------------------------------------+
//|                                    Ahmad samir Virtual Trade.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright ""
#property link      "" 

#property indicator_chart_window 
//#property indicator_buffers     1
//#property indicator_width1     2
//#property indicator_color1      Lime

extern double Lot = 0.1;
extern bool Show_Jump_Alert = false;
extern string ProfitPerLotAre = "Profit Every +1pips on Lot";

extern string SetForSell = "== S E L L  Pairs ==";// Below the Pairs to Sell
extern string Pair.1st = "NZDJPY";
extern string Pair.2nd = "USDJPY";
extern string Pair.3rd = "GBPCHF";
extern string Pair.4th = "CHFJPY";
extern string Pair.5th = "AUDUSD";
extern string Pair.6th = "EURCHF";
extern string Pair.7th = "EURUSD";

extern string SetForBuy = "== B U Y  Pairs ==";// Lower Pairs to Buy
extern string Pair.8th = "EURGBP";
extern string Pair.9th = "GBPUSD";
extern string Pair.10th = "USDCHF";
extern string Pair.11th = "NZDUSD";
extern string Pair.12th = "EURJPY";
extern string Pair.13th = "AUDJPY";
extern string Pair.14th = "GBPJPY";

extern string Comm1 = "Coordinates Placement on The Chart";
extern int Side = 1;
extern int MP_Y = 0; 
extern int MP_X = 300;

double profit_sum,buf[];

extern string Colors_Setting ="Colors";
extern color Title        = White;
extern color Head         = Wheat;
extern color SlotsSELL    = Red;
extern color SlotsBUY     = LimeGreen;
extern color Total        = LightGoldenrod;


color ColorSlots;

int init() {
    return (0);
}

int deinit() {
   Comment("");
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.1st, 1)); // Resets the Global Variable Pj - Slot BTS,erases all line
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.2nd, 2));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.3rd, 3));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.4th, 4));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.5th, 5));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.6th, 6));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.7th, 7));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.8th, 8));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.9th, 9));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.10th, 10));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.11th, 11));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.12th, 12));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.13th, 13));
   GlobalVariablesDeleteAll(StringConcatenate("Pj - Slot BTS", Pair.14th, 14));
   
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
       string label = ObjectName(i);
       ObjectDelete(label);   
     }  
   return (0);
}

int start() {
   int l_ind_counted_0 = IndicatorCounted();//number of bars, not counted after the last call 
   double sellprofit=0, buyprofit=0;
   for(int i=0; i<=OrdersTotal(); i++)  {
      if(OrderSelect(i,SELECT_BY_POS)==true) {                                   
           if(OrderType()==OP_BUY) buyprofit=buyprofit+OrderProfit();
           if(OrderType()==OP_SELL) sellprofit=sellprofit+OrderProfit();
      }
   }
   Write("Orders", Side, MP_X+90, MP_Y+315, "Open orders", 10, "Impact", Total); 
   Write("OrdersBuy", Side, MP_X+90, MP_Y+330, "BUY: "+DoubleToStr(buyprofit,2), 10, "Verdana", Total);
   Write("OrdersSell", Side, MP_X+90, MP_Y+340, "SELL: "+DoubleToStr(sellprofit,2), 10, "Verdana", Total);
   Write("OrdersTotal", Side, MP_X+90, MP_Y+360, "Result: "+DoubleToStr(buyprofit+sellprofit,2), 10, "Verdana", Total);  
          
   Write("Title", Side, MP_X+1, MP_Y+30, "Samir DAILY trades (Universal Pairs)", 8, "Verdana", Title); 
   /*if(sum()>70 && TradeType(CheckPairRank(1))=="Buy") {Write("LONG", Side, MP_X+10, MP_Y+40, "LONG", 18, "Verdana", Red); ObjectDelete("SHORT"); ObjectDelete("NONE");}
     else if(sum()<-70 && TradeType(CheckPairRank(1))=="Sell") {Write("SHORT", Side, MP_X+10, MP_Y+40, "SHORT", 18, "Verdana", Blue); ObjectDelete("LONG"); ObjectDelete("NONE");}
            else {Write("NONE", Side, MP_X+10, MP_Y+40, "NONE", 18, "Verdana", Title); ObjectDelete("SHORT"); ObjectDelete("LONG");}
   */
   Write("NONE", Side, MP_X+10, MP_Y+40, "NONE", 18, "Verdana", Total); 
   ObjectDelete("LONG WEAK"); ObjectDelete("SHORT STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("LONG STRONG");
   if(sumSELL()<0 && sumBUY()>0) {Write("LONG STRONG", Side, MP_X+10, MP_Y+40, "LONG STRONG", 18, "Verdana", Red); 
      ObjectDelete("LONG WEAK"); ObjectDelete("SHORT STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("NONE");}
   if(sumSELL()>0 && sumBUY()>0 && sumBUY()>sumSELL()) {Write("LONG WEAK", Side, MP_X+10, MP_Y+40, "LONG WEAK", 18, "Verdana", Red); 
      ObjectDelete("LONG STRONG"); ObjectDelete("SHORT STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("NONE");}      
   if(sumSELL()>0 && sumBUY()<0) {Write("SHORT STONG", Side, MP_X+10, MP_Y+40, "SHORT STONG", 18, "Verdana", Blue); 
      ObjectDelete("LONG WEAK"); ObjectDelete("LONG STRONG"); ObjectDelete("SHORT WEAK"); ObjectDelete("NONE");} 
   if(sumSELL()>0 && sumBUY()>0 && sumBUY()<sumSELL()) {Write("SHORT WEAK", Side, MP_X+10, MP_Y+40, "SHORT WEAK", 18, "Verdana", Blue); 
      ObjectDelete("LONG WEAK"); ObjectDelete("LONG STRONG"); ObjectDelete("SHORT STONG"); ObjectDelete("NONE");}        
   
   Write("Head", Side, MP_X+10, MP_Y+70, "No.     B/S            Pairs                      Profit", 10, "Arial Narrow", Total); 
   
   if(TradeType(CheckPairRank(1))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("1", Side, MP_X+180, MP_Y+90, "1:  ", 11, "Verdana", ColorSlots);
   Write("1T", Side, MP_X+155, MP_Y+90, TradeType(CheckPairRank(1)), 11, "Verdana", ColorSlots);
   Write("1O", Side, MP_X+85, MP_Y+90, CheckPairRank(1), 11, "Verdana", ColorSlots);
   Write("1P", Side, MP_X+1, MP_Y+90, DoubleToStr(CheckPairProfit(CheckPairRank(1)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(2))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("2", Side, MP_X+180, MP_Y+105, "2:  ", 11, "Verdana", ColorSlots);
   Write("2T", Side, MP_X+155, MP_Y+105, TradeType(CheckPairRank(2)), 11, "Verdana", ColorSlots);
   Write("2O", Side, MP_X+85, MP_Y+105, CheckPairRank(2), 11, "Verdana", ColorSlots);
   Write("2P", Side, MP_X+1, MP_Y+105, DoubleToStr(CheckPairProfit(CheckPairRank(2)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(3))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("3", Side, MP_X+180, MP_Y+120, "3:  ", 11, "Verdana", ColorSlots);
   Write("3T", Side, MP_X+155, MP_Y+120, TradeType(CheckPairRank(3)), 11, "Verdana", ColorSlots);
   Write("3O", Side, MP_X+85, MP_Y+120, CheckPairRank(3), 11, "Verdana", ColorSlots);
   Write("3P", Side, MP_X+1, MP_Y+120, DoubleToStr(CheckPairProfit(CheckPairRank(3)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(4))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("4", Side, MP_X+180, MP_Y+135, "4:  ", 11, "Verdana", ColorSlots);
   Write("4T", Side, MP_X+155, MP_Y+135, TradeType(CheckPairRank(4)), 11, "Verdana", ColorSlots);
   Write("4O", Side, MP_X+85, MP_Y+135, CheckPairRank(4), 11, "Verdana", ColorSlots);
   Write("4P", Side, MP_X+1, MP_Y+135, DoubleToStr(CheckPairProfit(CheckPairRank(4)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(5))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("5", Side, MP_X+180, MP_Y+150, "5:  ", 11, "Verdana", ColorSlots);
   Write("5T", Side, MP_X+155, MP_Y+150, TradeType(CheckPairRank(5)), 11, "Verdana", ColorSlots);
   Write("5O", Side, MP_X+85, MP_Y+150, CheckPairRank(5), 11, "Verdana", ColorSlots);
   Write("5P", Side, MP_X+1, MP_Y+150, DoubleToStr(CheckPairProfit(CheckPairRank(5)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(6))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("6", Side, MP_X+180, MP_Y+165, "6:  ", 11, "Verdana", ColorSlots);
   Write("6T", Side, MP_X+155, MP_Y+165, TradeType(CheckPairRank(6)), 11, "Verdana", ColorSlots);
   Write("6O", Side, MP_X+85, MP_Y+165, CheckPairRank(6), 11, "Verdana", ColorSlots);
   Write("6P", Side, MP_X+1, MP_Y+165, DoubleToStr(CheckPairProfit(CheckPairRank(6)),2), 11, "Verdana", ColorSlots);
      
   if(TradeType(CheckPairRank(7))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("7", Side, MP_X+180, MP_Y+180, "7:  ", 11, "Verdana", ColorSlots);
   Write("7T", Side, MP_X+155, MP_Y+180, TradeType(CheckPairRank(7)), 11, "Verdana", ColorSlots);
   Write("7O", Side, MP_X+85, MP_Y+180, CheckPairRank(7), 11, "Verdana", ColorSlots);
   Write("7P", Side, MP_X+1, MP_Y+180, DoubleToStr(CheckPairProfit(CheckPairRank(7)),2), 11, "Verdana", ColorSlots);
   
   Write("==", Side, MP_X+1, MP_Y+190, "==========================", 12, "Arial Narrow", Total);
   
   if(TradeType(CheckPairRank(8))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("8", Side, MP_X+180, MP_Y+205, "8:  ", 11, "Verdana", ColorSlots);
   Write("8T", Side, MP_X+155, MP_Y+205, TradeType(CheckPairRank(8)), 11, "Verdana", ColorSlots);
   Write("8O", Side, MP_X+85, MP_Y+205, CheckPairRank(8), 11, "Verdana", ColorSlots);
   Write("8P", Side, MP_X+1, MP_Y+205, DoubleToStr(CheckPairProfit(CheckPairRank(8)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(9))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("9", Side, MP_X+180, MP_Y+220, "9:  ", 11, "Verdana", ColorSlots);
   Write("9T", Side, MP_X+155, MP_Y+220, TradeType(CheckPairRank(9)), 11, "Verdana", ColorSlots);
   Write("9O", Side, MP_X+85, MP_Y+220, CheckPairRank(9), 11, "Verdana", ColorSlots);
   Write("9P", Side, MP_X+1, MP_Y+220, DoubleToStr(CheckPairProfit(CheckPairRank(9)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(10))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("10", Side, MP_X+180, MP_Y+235, "10:  ", 11, "Verdana", ColorSlots);
   Write("10T", Side, MP_X+155, MP_Y+235, TradeType(CheckPairRank(10)), 11, "Verdana", ColorSlots);
   Write("10O", Side, MP_X+85, MP_Y+235, CheckPairRank(10), 11, "Verdana", ColorSlots);
   Write("10P", Side, MP_X+1, MP_Y+235, DoubleToStr(CheckPairProfit(CheckPairRank(10)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(11))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("11", Side, MP_X+180, MP_Y+250, "11:  ", 11, "Verdana", ColorSlots);
   Write("11T", Side, MP_X+155, MP_Y+250, TradeType(CheckPairRank(11)), 11, "Verdana", ColorSlots);
   Write("11O", Side, MP_X+85, MP_Y+250, CheckPairRank(11), 11, "Verdana", ColorSlots);
   Write("11P", Side, MP_X+1, MP_Y+250, DoubleToStr(CheckPairProfit(CheckPairRank(11)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(12))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("12", Side, MP_X+180, MP_Y+265, "12:  ", 11, "Verdana", ColorSlots);
   Write("12T", Side, MP_X+155, MP_Y+265, TradeType(CheckPairRank(12)), 11, "Verdana", ColorSlots);
   Write("12O", Side, MP_X+85, MP_Y+265, CheckPairRank(12), 11, "Verdana", ColorSlots);
   Write("12P", Side, MP_X+1, MP_Y+265, DoubleToStr(CheckPairProfit(CheckPairRank(12)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(13))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("13", Side, MP_X+180, MP_Y+280, "13:  ", 11, "Verdana", ColorSlots);
   Write("13T", Side, MP_X+155, MP_Y+280, TradeType(CheckPairRank(13)), 11, "Verdana", ColorSlots);
   Write("13O", Side, MP_X+85, MP_Y+280, CheckPairRank(13), 11, "Verdana", ColorSlots);
   Write("13P", Side, MP_X+1, MP_Y+280, DoubleToStr(CheckPairProfit(CheckPairRank(13)),2), 11, "Verdana", ColorSlots);
   
   if(TradeType(CheckPairRank(14))=="Sell") ColorSlots=SlotsSELL;
      else ColorSlots=SlotsBUY;
   Write("14", Side, MP_X+180, MP_Y+295, "14:  ", 11, "Verdana", ColorSlots);
   Write("14T", Side, MP_X+155, MP_Y+295, TradeType(CheckPairRank(14)), 11, "Verdana", ColorSlots);
   Write("14O", Side, MP_X+85, MP_Y+295, CheckPairRank(14), 11, "Verdana", ColorSlots);
   Write("14P", Side, MP_X+1, MP_Y+295, DoubleToStr(CheckPairProfit(CheckPairRank(14)),2), 11, "Verdana", ColorSlots);
   
   Write("===", Side, MP_X+1, MP_Y+300, "_____________________", 12, "Verdana", Total);
   Write("Sum", Side, MP_X+1, MP_Y+320, DoubleToStr(sum(),2), 18, "Impact", Total);
      
   
   if (Show_Jump_Alert) {
      RankChangeAlert(Pair.1st, 1);
      RankChangeAlert(Pair.2nd, 2);
      RankChangeAlert(Pair.3rd, 3);
      RankChangeAlert(Pair.4th, 4);
      RankChangeAlert(Pair.5th, 5);
      RankChangeAlert(Pair.6th, 6);
      RankChangeAlert(Pair.7th, 7);
      RankChangeAlert(Pair.8th, 8);
      RankChangeAlert(Pair.9th, 9);
      RankChangeAlert(Pair.10th, 10);
      RankChangeAlert(Pair.11th, 11);
      RankChangeAlert(Pair.12th, 12);
      RankChangeAlert(Pair.13th, 13);
      RankChangeAlert(Pair.14th, 14);
   }
   
buf[0]=sum();
   return (0);
}

double OpenWeek(string a_symbol_0, int ai_8) {// considers the opening of the week, bais adds to spread
   double ld_ret_12;
   if (ai_8 < 8) ld_ret_12 = iOpen(a_symbol_0, PERIOD_D1, 0);
   else ld_ret_12 = iOpen(a_symbol_0, PERIOD_D1, 0);// + MarketInfo(a_symbol_0, MODE_SPREAD) * MarketInfo(a_symbol_0, MODE_POINT);
   return (ld_ret_12);
}

double ProfitPair(int ai_0) {
   string l_symbol_4;
   double ld_12;
   if (ai_0 == 1) l_symbol_4 = Pair.1st;
   if (ai_0 == 2) l_symbol_4 = Pair.2nd;
   if (ai_0 == 3) l_symbol_4 = Pair.3rd;
   if (ai_0 == 4) l_symbol_4 = Pair.4th;
   if (ai_0 == 5) l_symbol_4 = Pair.5th;
   if (ai_0 == 6) l_symbol_4 = Pair.6th;
   if (ai_0 == 7) l_symbol_4 = Pair.7th;
   if (ai_0 == 8) l_symbol_4 = Pair.8th;
   if (ai_0 == 9) l_symbol_4 = Pair.9th;
   if (ai_0 == 10) l_symbol_4 = Pair.10th;
   if (ai_0 == 11) l_symbol_4 = Pair.11th;
   if (ai_0 == 12) l_symbol_4 = Pair.12th;
   if (ai_0 == 13) l_symbol_4 = Pair.13th;
   if (ai_0 == 14) l_symbol_4 = Pair.14th;
   double ld_20 = MarketInfo(l_symbol_4, MODE_TICKVALUE) / MarketInfo(l_symbol_4, MODE_TICKSIZE) * MarketInfo(l_symbol_4, MODE_POINT);// calculates the value of the item pairs in the U.S
   RefreshRates();// updates the value of tick
   if (ai_0 < 8) ld_12 = (OpenWeek(l_symbol_4, ai_0) - MarketInfo(l_symbol_4, MODE_ASK)) / MarketInfo(l_symbol_4, MODE_POINT) * ld_20;// for the opening week of the village ASK ASK minus pair 
   else ld_12 = (MarketInfo(l_symbol_4, MODE_BID) - OpenWeek(l_symbol_4, ai_0)) / MarketInfo(l_symbol_4, MODE_POINT) * ld_20;// bai bid for a pair of minus bid beginning of the week
   return (NormalizeDouble(ld_12 * Lot, 2));// multiplies the difference between the opening weeks of dollar value of the lot
}

string CheckPairRank(int ai_0) {
   if (ai_0 == Rank(1)) return (Pair.1st);
   if (ai_0 == Rank(2)) return (Pair.2nd);
   if (ai_0 == Rank(3)) return (Pair.3rd);
   if (ai_0 == Rank(4)) return (Pair.4th);
   if (ai_0 == Rank(5)) return (Pair.5th);
   if (ai_0 == Rank(6)) return (Pair.6th);
   if (ai_0 == Rank(7)) return (Pair.7th);
   if (ai_0 == Rank(8)) return (Pair.8th);
   if (ai_0 == Rank(9)) return (Pair.9th);
   if (ai_0 == Rank(10)) return (Pair.10th);
   if (ai_0 == Rank(11)) return (Pair.11th);
   if (ai_0 == Rank(12)) return (Pair.12th);
   if (ai_0 == Rank(13)) return (Pair.13th);
   if (ai_0 == Rank(14)) return (Pair.14th);
   return ("");
}

double CheckPairProfit(string as_0) {
   if (as_0 == Pair.1st) return (ProfitPair(1));
   if (as_0 == Pair.2nd) return (ProfitPair(2));
   if (as_0 == Pair.3rd) return (ProfitPair(3));
   if (as_0 == Pair.4th) return (ProfitPair(4));
   if (as_0 == Pair.5th) return (ProfitPair(5));
   if (as_0 == Pair.6th) return (ProfitPair(6));
   if (as_0 == Pair.7th) return (ProfitPair(7));
   if (as_0 == Pair.8th) return (ProfitPair(8));
   if (as_0 == Pair.9th) return (ProfitPair(9));
   if (as_0 == Pair.10th) return (ProfitPair(10));
   if (as_0 == Pair.11th) return (ProfitPair(11));
   if (as_0 == Pair.12th) return (ProfitPair(12));
   if (as_0 == Pair.13th) return (ProfitPair(13));
   if (as_0 == Pair.14th) return (ProfitPair(14));
   return (0.0);
}
double sum()
{
double tmp=0;
for (int j=1; j<15; j++)
{
tmp=tmp+ ProfitPair(j);

}
profit_sum=tmp;
return(profit_sum);
}

int Rank(int ai_0) {
   double lda_4[15];
   for (int li_8 = 14; li_8 > 0; li_8--) lda_4[li_8] = ProfitPair(li_8);
   ArraySort(lda_4, WHOLE_ARRAY, 0, MODE_ASCEND);
   int li_12 = ArrayBsearch(lda_4, ProfitPair(ai_0), WHOLE_ARRAY, 1);
   return (15 - li_12);
}

string TradeType(string as_0) {
   if (as_0 == Pair.1st) return ("Sell");
   if (as_0 == Pair.2nd) return ("Sell");
   if (as_0 == Pair.3rd) return ("Sell");
   if (as_0 == Pair.4th) return ("Sell");
   if (as_0 == Pair.5th) return ("Sell");
   if (as_0 == Pair.6th) return ("Sell");
   if (as_0 == Pair.7th) return ("Sell");
   if (as_0 == Pair.8th) return ("Buy");
   if (as_0 == Pair.9th) return ("Buy");
   if (as_0 == Pair.10th) return ("Buy");
   if (as_0 == Pair.11th) return ("Buy");
   if (as_0 == Pair.12th) return ("Buy");
   if (as_0 == Pair.13th) return ("Buy");
   if (as_0 == Pair.14th) return ("Buy");
   return ("");
}

void RankChangeAlert(string as_0, int ai_8) {
   if (!GlobalVariableCheck(StringConcatenate("Pj - Slot BTS", as_0, ai_8))) GlobalVariableSet(StringConcatenate("Pj - Slot BTS", as_0, ai_8), Rank(ai_8));
   if (GlobalVariableGet(StringConcatenate("Pj - Slot BTS", as_0, ai_8)) <= 7.0) {
      if (Rank(ai_8) > 7) {
         Alert("Passed ", as_0, " with slots ", GlobalVariableGet(StringConcatenate("Pj - Slot BTS", as_0, ai_8)), " per slot ", Rank(ai_8), "");
         GlobalVariableSet(StringConcatenate("Pj - Slot BTS", as_0, ai_8), Rank(ai_8));
      }
   }
   if (GlobalVariableGet(StringConcatenate("Pj - Slot BTS", as_0, ai_8)) >= 8.0) {
      if (Rank(ai_8) < 8) {
         Alert("Passed ", as_0, " with slots ", GlobalVariableGet(StringConcatenate("Pj - Slot BTS", as_0, ai_8)), " per slot ", Rank(ai_8), "");
         GlobalVariableSet(StringConcatenate("Pj - Slot BTS", as_0, ai_8), Rank(ai_8));
      }
   }
   if (GlobalVariableGet(StringConcatenate("Pj - Slot BTS", as_0, ai_8)) != Rank(ai_8)) GlobalVariableSet(StringConcatenate("Pj - Slot BTS", as_0, ai_8), Rank(ai_8));
}

void Write(string LBL, double side, int pos_x, int pos_y, string text, int fontsize, string fontname, color Tcolor=CLR_NONE)
     {
       ObjectCreate(LBL, OBJ_LABEL, 0, 0, 0);
       ObjectSetText(LBL,text, fontsize, fontname, Tcolor);
       ObjectSet(LBL, OBJPROP_CORNER, side);
       ObjectSet(LBL, OBJPROP_XDISTANCE, pos_x);
       ObjectSet(LBL, OBJPROP_YDISTANCE, pos_y);
     }
     
double sumSELL()
{
double tmp=0;
for (int j=1; j<8; j++)
{
tmp=tmp+ ProfitPair(j);

}
profit_sum=tmp;
return(profit_sum);
}

double sumBUY()
{
double tmp=0;
for (int j=8; j<15; j++)
{
tmp=tmp+ ProfitPair(j);

}
profit_sum=tmp;
return(profit_sum);
}     