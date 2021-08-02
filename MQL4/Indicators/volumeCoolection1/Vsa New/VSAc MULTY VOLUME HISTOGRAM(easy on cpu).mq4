//+------------------------------------------------------------------+
//|                                  VSA© MULTY VOLUME HISTOGRAM.mq4 |
//|                                    Copyright © 2008, FOREXflash. |
//|                                        http://www.metaquotes.net |
//|                better volume part of code is coded by thatwasme  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, FOREXflash Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 DeepSkyBlue
#property indicator_color3 Yellow
#property indicator_color4 Lime
#property indicator_color5 White
#property indicator_color6 Magenta
#property indicator_color7 Gray
#property indicator_color8 DarkOrange

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2
#property indicator_width7 2
#property indicator_width8 3


extern int     NumberOfBars     = 500;
extern int     MAPeriod         = 100;
extern int     LookBack         = 20;
extern bool    ShowText         =true;
extern int     Corner           =1;
extern bool    ShowOCLines      =true;
extern int     OCPeriod         =14;
extern bool    ShowBarTime      =true;
extern color   Trending=C'35,35,35';
extern color   Ranging= Black ;



string FontName="Trebuchet MS";
int FontSize=13;
color FontColor=White;
int XDistance=15;
int YDistance=35;

bool   Bid_Ask_Colors=True;
color  FontColor2=Black;
int    FontSize2=20;
string FontType="Arial Black";
int    WhatCorner=1;

int lenbase;
string s_base=":...:...:...:...:";

double P1;
double P2;
double red[],blue[],yellow[],green[],white[],magenta[],v4[];
double P3Buffer[];
double Old_Price;


bool  show.Bclk=true;
int   TimeFrame   =0 ;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
lenbase=StringLen(s_base);

//---- indicators
      SetIndexBuffer(0,red);
      SetIndexStyle(0,DRAW_HISTOGRAM);
      SetIndexLabel(0,"Climax High ");
      
      SetIndexBuffer(1,blue);
      SetIndexStyle(1,DRAW_HISTOGRAM);
      SetIndexLabel(1,"Neutral");
      
      SetIndexBuffer(2,yellow);
      SetIndexStyle(2,DRAW_HISTOGRAM);
      SetIndexLabel(2,"Low ");
      
      SetIndexBuffer(3,green);
      SetIndexStyle(3,DRAW_HISTOGRAM);
      SetIndexLabel(3,"HighChurn ");
      
      SetIndexBuffer(4,white);
      SetIndexStyle(4,DRAW_HISTOGRAM);
      SetIndexLabel(4,"Climax Low ");
      
      SetIndexBuffer(5,magenta);
      SetIndexStyle(5,DRAW_HISTOGRAM);
      SetIndexLabel(5,"ClimaxChurn ");
      
      SetIndexBuffer(6,v4);
      SetIndexStyle(6,DRAW_LINE,2,1);
      SetIndexLabel(6,"Average("+MAPeriod+")");
      
      SetIndexBuffer(7, P3Buffer);   
      SetIndexStyle(7, DRAW_HISTOGRAM, STYLE_SOLID);
      SetIndexLabel(7,"TickSeparateVolume");
      
      IndicatorShortName("VSA© MULTY VOLUME HISTOGRAM" );
      
   if (ShowText==True)
   {
   draw_objects();
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
     for(int i = ObjectsTotal() - 1; i >= 0; i--) {
      string Label = ObjectName(i);
      if(StringSubstr(Label, 0, 8) != "Trend2")
         continue;
     ObjectDelete(Label);   
   }
//----
if (ObjectFind("BarTimer1") != -1) ObjectDelete("BarTimer1");
ObjectDelete("Market_Price_Label1");
ObjectsDeleteAll(0,OBJ_LABEL); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bar Timer                                                        |
//+------------------------------------------------------------------+
int BarTimer()
  {
   int i=0,sec=0;
   double pc=0.0;
   string time="",s_end="",s_beg="";
   
   ObjectCreate("BarTimer1", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSet("BarTimer1", OBJPROP_CORNER, Corner);
   ObjectSet("BarTimer1", OBJPROP_XDISTANCE, XDistance);
   ObjectSet("BarTimer1", OBJPROP_YDISTANCE, YDistance);
   

   sec=TimeCurrent()-Time[0];
   i=(lenbase-1)*sec/(Period()*60);
   pc=100.0*sec/(Period()*60);
   if(i>lenbase-1) i=lenbase-1;
   if(i>0) s_beg=StringSubstr(s_base,0,i);
   if(i<lenbase-1) s_end=StringSubstr(s_base,i+1,lenbase-i-1);
   time=StringConcatenate(s_beg,"|",s_end,"  ",DoubleToStr(pc,0),"%");
   ObjectSetText("BarTimer1", time, FontSize, FontName, FontColor);

   return(0);
  }
//+------------------------------------------------------------------+
//|  MagnifiedPrice                                                  |
//+------------------------------------------------------------------+
int MPrice()
  {
   if (Bid_Ask_Colors==True)
     {
      if (Bid > Old_Price) FontColor2=LawnGreen;
      if (Bid < Old_Price) FontColor2=Red;
      Old_Price=Bid;
     }
     
   //---- Define the standard digits
   int digits;
   string sub=StringSubstr(Symbol(), 3, 3);
   if(sub == "JPY") digits = 2;
   else digits = 4;
    
   string Market_Price=DoubleToStr(Bid, digits);
//----   
   ObjectCreate("Market_Price_Label1", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSetText("Market_Price_Label1", Market_Price, FontSize2, FontType, FontColor2);
   ObjectSet("Market_Price_Label1", OBJPROP_CORNER, Corner);
   ObjectSet("Market_Price_Label1", OBJPROP_XDISTANCE, 15);
   ObjectSet("Market_Price_Label1", OBJPROP_YDISTANCE, 144);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   if (ShowText==True)
   {
   draw_objects();
   BarTimer();
   MPrice();
   }
   if (ShowOCLines==True)
   {
   OpenCloseLines();
   }
   if (ShowBarTime==True)
   {
   BarTime();
   }

   int Window=WindowFind("VSA© MULTY VOLUME HISTOGRAM");
   double VolLowest,Range,Value2,Value3,HiValue2,HiValue3,LoValue3,tempv2,tempv3,tempv;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
   
      
   for(int i=0; i<limit; i++)   
      {
         red[i] = 0; blue[i] = Volume[i]; yellow[i] = 0; green[i] = 0; white[i] = 0; magenta[i] = 0;
         Value2=0;Value3=0;HiValue2=0;HiValue3=0;LoValue3=99999999;tempv2=0;tempv3=0;tempv=0;
         
         
         VolLowest = Volume[iLowest(NULL,0,MODE_VOLUME,20,i)];
         if (Volume[i] == VolLowest)
            {
               yellow[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
            }
               
         Range = (High[i]-Low[i]);
         Value2 = Volume[i]*Range;
         
         if (  Range != 0 )
            Value3 = Volume[i]/Range;
            
         
         for ( int n=i;n<i+MAPeriod;n++ )
            {
               tempv= Volume[n] + tempv; 
            } 
          v4[i] = NormalizeDouble(tempv/MAPeriod,0);
         
          
          for ( n=i;n<i+LookBack;n++)
            {
               tempv2 = Volume[n]*((High[n]-Low[n])); 
               if ( tempv2 >= HiValue2 )
                  HiValue2 = tempv2;
                    
               if ( Volume[n]*((High[n]-Low[n])) != 0 )
                  {           
                     tempv3 = Volume[n] / ((High[n]-Low[n]));
                     if ( tempv3 > HiValue3 ) 
                        HiValue3 = tempv3; 
                     if ( tempv3 < LoValue3 )
                        LoValue3 = tempv3;
                  } 
            }
                                      
          if ( Value2 == HiValue2  && Close[i] > (High[i] + Low[i]) / 2 )
            {
               red[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               yellow[i]=0;
            }   
            
          if ( Value3 == HiValue3 )              
            {
               green[i] = NormalizeDouble(Volume[i],0);             
               blue[i] =0;
               yellow[i]=0;
               red[i]=0;
            }
          if ( Value2 == HiValue2 && Value3 == HiValue3 )               
            {
               magenta[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               red[i]=0;
               green[i]=0;
               yellow[i]=0;
            } 
         if ( Value2 == HiValue2  && Close[i] <= (High[i] + Low[i]) / 2 ) 
            {
               white[i] = NormalizeDouble(Volume[i],0);       
               magenta[i]=0;
               blue[i]=0;
               red[i]=0;
               green[i]=0;
               yellow[i]=0;      
            } 

         
      }
//----
string Label;
   int cnt=0;   
   for(i=limit-1;i>0;i--) 
   {
      if(Volume[i]>v4[i]) { // If its a cross point
         cnt++; // calculate the number of crosses.
         Label="Trend2" + cnt;
         if(ObjectFind(Label)==-1)
            ObjectCreate(Label,OBJ_RECTANGLE,Window,0,0);
         ObjectSet(Label,OBJPROP_COLOR,Ranging);
         ObjectSet(Label,OBJPROP_PRICE1,100000000);
         ObjectSet(Label,OBJPROP_PRICE2,-100000000);
         ObjectSet(Label,OBJPROP_TIME1,Time[i]);
         ObjectSet(Label,OBJPROP_TIME2,Time[i-1]);
    }
    else 
    {
         if(Volume[i]<v4[i]) { // If its a cross point
            cnt++; // calculate the number of crosses.
            Label="Trend2" + cnt;
            if(ObjectFind(Label)==-1)
               ObjectCreate(Label,OBJ_RECTANGLE,Window,0,0);
            ObjectSet(Label,OBJPROP_COLOR,Trending);
            ObjectSet(Label,OBJPROP_PRICE1,100000000);
            ObjectSet(Label,OBJPROP_PRICE2,-100000000);
            ObjectSet(Label,OBJPROP_TIME1,Time[i]);
            ObjectSet(Label,OBJPROP_TIME2,Time[i-1]);
     }
     else 
            
            ObjectSet(Label,OBJPROP_TIME2,Time[i-1]); // drag the current shadow
     }
   }          
//----
   return(0);
  }

//+-------------------------------------------------------------------------------------------+
//| VOID DRAW OBJECTS                                                                         |
//+-------------------------------------------------------------------------------------------+

void draw_objects()
{
//+-------------

   ObjectCreate("VBox", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSetText("VBox","V  S  A  ®",14, "Trebuchet MS", Orange);
   ObjectSet("VBox", OBJPROP_CORNER, Corner);
   ObjectSet("VBox", OBJPROP_XDISTANCE, 15);
   ObjectSet("VBox", OBJPROP_YDISTANCE, 1);
   
   ObjectCreate("VBox1", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSetText("VBox1","Better/Tick Separate Volume",8, "Trebuchet MS", Gray);
   ObjectSet("VBox1", OBJPROP_CORNER, Corner);
   ObjectSet("VBox1", OBJPROP_XDISTANCE, 15);
   ObjectSet("VBox1", OBJPROP_YDISTANCE, 18);
//+--------------  

//+--------------

 string v4MA=DoubleToStr(v4[0],1);
   ObjectCreate("v4MA", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSetText("v4MA","AVERAGE VOLUME:"+v4MA,13, "Trebuchet MS", Lime);
   ObjectSet("v4MA", OBJPROP_CORNER, Corner);
   ObjectSet("v4MA", OBJPROP_XDISTANCE, 15);
   ObjectSet("v4MA", OBJPROP_YDISTANCE, 92);
   
   ObjectCreate("BA_v4MA", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSetText("BA_v4MA","VOLUME IS BELOW AVERAGE.",8, "Trebuchet MS", White);
   ObjectSet("BA_v4MA", OBJPROP_CORNER, Corner);
   ObjectSet("BA_v4MA", OBJPROP_XDISTANCE, 15);
   ObjectSet("BA_v4MA", OBJPROP_YDISTANCE, 110);
   
if (v4[0]>v4[1] &&
    v4[0]>v4[2] &&
    v4[0]>v4[3] &&
    v4[0]>v4[4] &&
    v4[0]>v4[5] &&
    v4[0]>v4[6] &&
    v4[0]>v4[7] &&
    v4[0]>v4[8] &&
    v4[0]>v4[9] &&
    v4[0]>v4[10]&&
    v4[0]>v4[11]&&
    v4[0]>v4[12]&&
    v4[0]>v4[13]&&
    v4[0]>v4[14]&&
    v4[0]>v4[15]&&
    v4[0]>v4[16]&&
    v4[0]>v4[17]&&
    v4[0]>v4[18]&&
    v4[0]>v4[19]&&
    v4[0]>v4[20] )

{ 
ObjectSetText("BA_v4MA","VOLUME IS ABOVE AVERAGE!!!", 8,"Trebuchet MS",Red);                                                          
}
//+--------------   


   ObjectCreate("BetterVol", OBJ_LABEL, WindowFind("VSA© MULTY VOLUME HISTOGRAM"), 0, 0);
   ObjectSetText("BetterVol","PENDING BAR SIGNAL...",13, "Trebuchet MS", Gray);
   ObjectSet("BetterVol", OBJPROP_CORNER, Corner);
   ObjectSet("BetterVol", OBJPROP_XDISTANCE, 15);
   ObjectSet("BetterVol", OBJPROP_YDISTANCE, 127);
   

if (white[1]>1  )   { ObjectSetText("BetterVol","*Start/End of down trend_Pullback during up trend*",10,"Trebuchet MS", White);   }//Climax Low  /White                                 
if (red[1]>1    )   { ObjectSetText("BetterVol","*Start/End of up trend_Pullback during down trend*",10, "Trebuchet MS", Red);     }//Climax High /Red
if (green[1]>1  )   { ObjectSetText("BetterVol","*End of up/down trend_Profit taking mid-trend*",10, "Trebuchet MS", Lime);         }//HighChurn   /Lime       
if (magenta[1]>1)   { ObjectSetText("BetterVol","*Seen on tops and bottoms_Reversal or continuation*",10, "Trebuchet MS", Magenta);          }//ClimaxChurn /Magenta
if (yellow[1]>1 )   { ObjectSetText("BetterVol","*End of up/down trend_Pullback mid-trend*",10, "Trebuchet MS", Yellow);      }//Low         /Yellow
if (blue[1]>1   )   { ObjectSetText("BetterVol","*No signal_Neutral*",10, "Trebuchet MS", DeepSkyBlue);      }//Neutral     /SkyBlue
                         
      
//+--------------

}
 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OpenCloseLines()
  {
//----
   double hhmd =iClose(NULL,PERIOD_D1, Highest (NULL,PERIOD_D1, MODE_CLOSE, OCPeriod,1));
   double hhmh4=iClose(NULL,PERIOD_H4, Highest (NULL,PERIOD_H4, MODE_CLOSE, OCPeriod,1));
   double hhmh1=iClose(NULL,PERIOD_H1, Highest (NULL,PERIOD_H1, MODE_CLOSE, OCPeriod,1));
   double hhm30=iClose(NULL,PERIOD_M30, Highest (NULL,PERIOD_M30, MODE_CLOSE, OCPeriod,1));
   double hhm15=iClose(NULL,PERIOD_M15, Highest (NULL,PERIOD_M15, MODE_CLOSE, OCPeriod,1));
   double llmd =iClose(NULL,PERIOD_D1, Lowest (NULL,PERIOD_D1, MODE_CLOSE, OCPeriod,1));
   double llmh4=iClose(NULL,PERIOD_H4, Lowest (NULL,PERIOD_H4, MODE_CLOSE, OCPeriod,1));
   double llmh1=iClose(NULL,PERIOD_H1, Lowest (NULL,PERIOD_H1, MODE_CLOSE, OCPeriod,1));
   double llm30=iClose(NULL,PERIOD_M30, Lowest (NULL,PERIOD_M30, MODE_CLOSE, OCPeriod,1));
   double llm15=iClose(NULL,PERIOD_M15, Lowest (NULL,PERIOD_M15, MODE_CLOSE, OCPeriod,1));
   //
   drawLine("HH_D1",Time[36],Time[30],hhmd,hhmd,3,0,Lime,1);
   drawLine("HH_H4",Time[30],Time[24],hhmh4,hhmh4,3,0,Lime,1);
   drawLine("HH_H1",Time[18],Time[12],hhmh1,hhmh1,3,0,Lime,2);
   drawLine("HH_M30",Time[12],Time[6],hhm30,hhm30,3,0,Lime,2);
   drawLine("HH_M15",Time[6],Time[0],hhm15,hhm15,3,0,Lime,1);
   
   drawLine("LL_D1",Time[36],Time[30],llmd,llmd,3,0,Red,1);
   drawLine("LL_H4",Time[30],Time[24],llmh4,llmh4,3,0,Red,1);
   drawLine("LL_H1",Time[18],Time[12],llmh1,llmh1,3,0,Red,2);
   drawLine("LL_M30",Time[12],Time[6],llm30,llm30,3,0,Red,2);
   drawLine("LL_M15",Time[6],Time[0],llm15,llm15,3,0,Red,1);
   //
   drawTXTLabel("D1 Bar HC",hhmd,Time[33],White);
   drawTXTLabel("H4 Bar HC",hhmh4,Time[27],White);
   drawTXTLabel("H1 Bar HC",hhmh1,Time[15],White);
   drawTXTLabel("M30 Bar HC",hhm30,Time[9],White);
   drawTXTLabel("M15 Bar HC",hhm15,Time[3],White);
   
   drawTXTLabel("D1 Bar LC",llmd,Time[33],White);
   drawTXTLabel("H4 Bar LC",llmh4,Time[27],White);
   drawTXTLabel("H1 Bar LC",llmh1,Time[15],White);
   drawTXTLabel("M30 Bar LC",llm30,Time[9],White);
   drawTXTLabel("M15 Bar LC",llm15,Time[3],White);

//----
   return(0);
  }
//+------------------------------------------------------------------+
void drawTXTLabel(string name,double lvl,datetime time, color Color)
  {
   if(ObjectFind(name)!=0)
     {
      ObjectCreate(name, OBJ_TEXT, 0, time, lvl);
      ObjectSetText(name, name, 8, "Tahoma", EMPTY);
      ObjectSet(name, OBJPROP_COLOR, Color);
     }
   else
     {
      ObjectMove(name, 0, time, lvl);
     }
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
      ObjectSet(name,OBJPROP_WIDTH,2);
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
      ObjectSet(name,OBJPROP_WIDTH,2);
      ObjectSet(name,OBJPROP_RAY,ray);
     }
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void BarTime()
  {
   // int    counted_bars=IndicatorCounted();
//----
    double i,i1,i2,i3,i4,i5,i6,i7;
   int m,s,k,
   m0, m1,m2,m3,m4,m5,m6,m7,
   s0, s1,s2,s3,s4,s5,s6,s7,
   h,h1,h2,h3,h4,h5,h6,h7;
   if (TimeFrame ==0)TimeFrame=Period();
   m=iTime(NULL,TimeFrame,0)+TimeFrame*60 - TimeCurrent();
   //  m=Time[0]+Period()*60-CurTime();
   m1=iTime(NULL,1440,0)+1440*60-CurTime();
   m2=iTime(NULL,240,0)+240*60-CurTime();
   m3=iTime(NULL,60,0)+60*60-CurTime();
   m4=iTime(NULL,30,0)+30*60-CurTime();
   m5=iTime(NULL,15,0)+15*60-CurTime();
   m6=iTime(NULL,5,0)+5*60-CurTime();
   m7=iTime(NULL,1,0)+1*60-CurTime();
//----
   i=m/60.0;
   i1=m1/60.0;
   i2=m2/60.0;
   i3=m3/60.0;
   i4=m4/60.0;
   i5=m5/60.0;
   i6=m6/60.0;
   i7=m7/60.0;
//----
   s=m%60;
   s0=m%60;
   s1=m1%60;
   s2=m2%60;
   s3=m3%60;
   s4=m4%60;
   s5=m5%60;
   s6=m6%60;
   s7=m7%60;
//----
   m=(m-m%60)/60;
   m0=(m-m%60)/60;
   m1=(m1-m1%60)/60;
   m2=(m2-m2%60)/60;
   m3=(m3-m3%60)/60;
   m4=(m4-m4%60)/60;
   m5=(m5-m5%60)/60;
   m6=(m6-m6%60)/60;
   m7=(m7-m7%60)/60;
//----
   h=m/60;
   h1=m1/60;
   h2=m2/60;
   h3=m3/60;
   h4=m4/60;
   h5=m5/60;
   h6=m6/60;
   h7=m7/60;
//----
   string Bclk=   "                   <"+m+":"+s;
   string M1=  "[M1] "+m7+"m :"+s7;
   string M5=  "[M5] "+m6+"m :"+s6;
   string M15= "[M15] "+m5+"m :"+s5;
   string M30= "[M30] "+m4+"m :"+s4;
   string M60= "[M60] "+m3+"m :"+s3;
   string M240= "[H4] "+m2+"m :"+s2;
   string M1440= "[D1] "+m1+"m :"+s1;
//----


   ObjectDelete("time");
   if(ObjectFind("time")!=0)
     {
        if(show.Bclk )
        {
        ObjectCreate("time", OBJ_TEXT, 0, Time[0], Close[0]+ 0.0000);WindowRedraw();}
        if(show.Bclk )
        {
        ObjectSetText("time",StringSubstr((Bclk),0), 9, "Tahoma" ,White);WindowRedraw();}

     }
   else
     {
      ObjectMove("time", 0, Time[0], Close[0]+0.0005);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+     