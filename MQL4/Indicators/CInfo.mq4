//**********************************************************
//*   CInfo.mq4                                            *
//*                                                        *
//*   Displays the time left until the next candle close   *
//*   and the spread in absolute and relative Terms        *
//*                                                        *
//*   Written by: Totoro @ forexfactory.com                *
//**********************************************************

#property indicator_chart_window

extern bool   ShowSpread     = true;
extern bool   ShowRelative   = true;
extern string SpreadAbsolute = "pt";
extern string SpreadRelative = "per mille";
extern string Separator      = "|";

int deinit()
{
   Comment("");
   return(0);
}

int start()
{
	int ttc, d, h, m, s, rest;
	string spread, sp, rel;
   
   ttc = Time[0] + Period()*60 - TimeCurrent();
   
   rest=ttc%86400;
   d=(ttc-rest)/86400;
   ttc=rest;
   rest=ttc%3600;
   h=(ttc-rest)/3600;
   ttc=rest;
   rest=ttc%60;
   m=(ttc-rest)/60;
   s=rest;
   
   if(ShowSpread)
   {
      if(MarketInfo("EURUSD", MODE_DIGITS)==5) { sp = DoubleToStr(0.1*MarketInfo(Symbol(), MODE_SPREAD), 0); }
      else { sp = DoubleToStr(MarketInfo(Symbol(), MODE_SPREAD), 0); }
      rel = DoubleToStr(1000*(MarketInfo(Symbol(), MODE_ASK)-MarketInfo(Symbol(), MODE_BID))/MarketInfo(Symbol(), MODE_BID), 2);
      if(ShowRelative) { spread = StringConcatenate(" " + Separator + " Spread: ", sp + SpreadAbsolute + " (" + rel + " " + SpreadRelative + ")" ); }
      else             { spread = StringConcatenate(" " + Separator + " Spread: ", sp + SpreadAbsolute); }
   }

   if(d>0)      Comment( "Close in " + d + "d " + h + "h " + m + "m " + s + "s" + spread );
   else if(h>0) Comment( "Close in " + h + "h " + m + "m " + s + "s" + spread );
   else if(m>0) Comment( "Close in " + m + "m " + s + "s" + spread );
   else         Comment( "Close in " + s + "s" + spread );

   return(0);
}