//+------------------------------------------------------------------+
//|                                           VSA© ROUND NUMBERS.mq4 |
//|                                    Copyright © 2008, FOREXflash. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, FOREXflash Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
//----
extern int     LinesAboveBelow= 150;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   int obj_total= ObjectsTotal();
     for(int i= obj_total; i>=0; i--) 
     {
      string name= ObjectName(i);
      if (StringSubstr(name,0,11)=="[SweetSpot]")
         ObjectDelete(name);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   static datetime timelastupdate= 0;
   static datetime lasttimeframe= 0;
   // no need to update these buggers too often   
   if (CurTime()-timelastupdate < 600 && Period()==lasttimeframe)
      return(0);
   int i, ssp1, style, ssp;
   double ds1;
   color linecolor;
//----
   ssp1= Bid/Point;
   ssp1= ssp1 - ssp1%1000;
     for(i= -LinesAboveBelow; i<LinesAboveBelow; i++) 
     {
      ssp= ssp1+(i*1000);
        if (ssp%1000==0) 
        {
        }
      ds1= ssp*Point;
      
      drawLine(DoubleToStr(ds1,Digits),Time[1],Time[0],ds1,ds1,1,0,Orange,1);
     }
   return(0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLine(string name,datetime tfrom, datetime tto, double pfrom, double pto, int width, int ray, color Col,int type)
  {
   if(ObjectFind(name)!=0)
     {
      ObjectCreate(name, OBJ_TREND, 0, tfrom, pfrom,tto,pto);
//----
      if(type==1)
         ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      else if(type==2)
            ObjectSet(name, OBJPROP_STYLE, STYLE_DASHDOT);
         else
            ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
//----
      ObjectSet(name, OBJPROP_COLOR, Col);
      ObjectSet(name,OBJPROP_WIDTH,width);
      ObjectSet(name,OBJPROP_RAY,ray);
     }
   else
     {
      ObjectDelete(name);
      ObjectCreate(name, OBJ_TREND, 0, tfrom, pfrom,tto,pto);

      if(type==1)
         ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
      else if(type==2)
            ObjectSet(name, OBJPROP_STYLE, STYLE_DASHDOT);
         else
            ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
//----
      ObjectSet(name, OBJPROP_COLOR, Col);
      ObjectSet(name,OBJPROP_WIDTH,width);
      ObjectSet(name,OBJPROP_RAY,ray);
     }
  }