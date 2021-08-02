//+------------------------------------------------------------------+
//|                                  VSA© WICK/SPREAD/DIVERGENCE.mq4 |
//|                                    Copyright © 2008, FOREXflash. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, FOREXflash Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 White
#property indicator_color2 Lime
#property indicator_color3 Red
#property indicator_color4 Black
#property indicator_color5 Gray
#property indicator_color6 Gray
#property indicator_color7 Red
#property indicator_color8 Lime



#property indicator_width1  2
#property indicator_width2  3
#property indicator_width3  3
#property indicator_width4  1
#property indicator_width5  1
#property indicator_width6  1
#property indicator_width7  1
#property indicator_width8  1


extern bool    ShowText=true;
extern int     Corner=1;
extern int     MA_Length= 100; 
extern color   Trending=C'35,35,35';
extern color   Ranging= Black ;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer1a[];
double ExtMapBuffer2a[];
double Volumes[];
double AvgVolumes[];
double white1[];
double green1[];
double red1[];


int PipFactor = 1;
string WindowName;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{

//---- indicators
SetIndexBuffer(0,ExtMapBuffer1);
SetIndexStyle(0,DRAW_HISTOGRAM);
SetIndexLabel(0,"Spread(High-Low)");

SetIndexStyle(1,DRAW_HISTOGRAM);
SetIndexBuffer(1,ExtMapBuffer1a);
SetIndexLabel(1,"UpperWick");

SetIndexStyle(2,DRAW_HISTOGRAM);
SetIndexBuffer(2,ExtMapBuffer2a);
SetIndexLabel(2,"LowerWick");
   //
   SetIndexBuffer(3,Volumes);
   SetIndexStyle(3,DRAW_NONE);
   // MA of Volume
   SetIndexBuffer(4,AvgVolumes);     
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexLabel(4,"AverageSpread");
   
      SetIndexBuffer(5,white1);
      SetIndexStyle(5,DRAW_ARROW,STYLE_SOLID);
      SetIndexArrow(5,117);
      SetIndexLabel(5,"DivergenceNone");
      SetIndexBuffer(6,green1);
      SetIndexStyle(6,DRAW_ARROW,STYLE_SOLID);
      SetIndexArrow(6,117);
      SetIndexLabel(6,"DivergenceTrending");
      SetIndexBuffer(7,red1);
      SetIndexStyle(7,DRAW_ARROW,STYLE_SOLID);
      SetIndexArrow(7,117);
      SetIndexLabel(7,"DivergenceBearish");
   


string short_name = "VSA© WICK/SPREAD/DIVERGENCE";     
IndicatorShortName(short_name);
WindowName = short_name;

ObjectDelete("Spread(High-Low)");
IndicatorDigits(1);
//----
return(1);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   for(int i = ObjectsTotal() - 1; i >= 0; i--) {
      string Label = ObjectName(i);
      if(StringSubstr(Label, 0, 8) != "RSXTrend")
         continue;
     ObjectDelete(Label);   
   }
//----
ObjectsDeleteAll(0,OBJ_LABEL);
//----
return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
{

   if (ShowText==True)
   {

   draw_objects();
   }

AVGVolume();
Div();

double tempv;
int counted_bars=IndicatorCounted();
//---- check for possible errors
if (counted_bars<0) return(-1);
//---- last counted bar will be recounted
if (counted_bars>0) counted_bars--;
int pos=Bars-counted_bars;

//---- main calculation loop
double Result;
double dResult1;
double dResult2;

while(pos>=0)
{
Result = iHigh(NULL, 0, pos) - iLow(NULL, 0, pos); 
ExtMapBuffer1[pos]= (Result/Point)/PipFactor ;


if (iOpen(NULL, 0, pos) > iClose(NULL, 0, pos)){
   dResult1 = iHigh(NULL, 0, pos) - iOpen(NULL, 0, pos);
   }
if (iOpen(NULL, 0, pos) <= iClose(NULL, 0, pos)){
   dResult1 = iHigh(NULL, 0, pos) - iClose(NULL, 0, pos);
   }
if (iOpen(NULL, 0, pos) > iClose(NULL, 0, pos)){
   dResult2 = iLow(NULL, 0, pos) - iClose(NULL, 0, pos);
   }
if (iOpen(NULL, 0, pos) <= iClose(NULL, 0, pos)){
   dResult2 = iLow(NULL, 0, pos) - iOpen(NULL, 0, pos);
   }
   ExtMapBuffer1a[pos]= (dResult1/Point)/PipFactor ;
   ExtMapBuffer2a[pos]= (dResult2/Point)/PipFactor ;

pos--;
}

//----
return(0);
}
//+------------------------------------------------------------------+
//| avgVolumes                                                       |
//+------------------------------------------------------------------+
int AVGVolume()
{  
   int Window=WindowFind("VSA© WICK/SPREAD/DIVERGENCE");
   int    i,nLimit,nCountedBars;
//---- bars count that does not changed after last indicator launch.
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted
   if(nCountedBars>0) nCountedBars--;
   nLimit=Bars-nCountedBars;
//----


   for(i=0; i<nLimit; i++) Volumes[i] =  ((iHigh(NULL, 0, i) - iLow(NULL, 0, i))/Point)/PipFactor;
   
   for(i=0; i<nLimit; i++)
   {
   AvgVolumes[i] = iMAOnArray(Volumes,0,MA_Length,0,MODE_EMA,i);
          
   } 
   
   
   
   string Label;
   int cnt=0;   
   for(i=nLimit-1;i>0;i--) 
   {
      if(Volumes[i]>AvgVolumes[i]) { // If its a cross point
         cnt++; // calculate the number of crosses.
         Label="RSXTrend" + cnt;
         if(ObjectFind(Label)==-1)
            ObjectCreate(Label,OBJ_RECTANGLE,Window,0,0);
         ObjectSet(Label,OBJPROP_COLOR,Ranging);
         ObjectSet(Label,OBJPROP_PRICE1,100000);
         ObjectSet(Label,OBJPROP_PRICE2,-100000);
         ObjectSet(Label,OBJPROP_TIME1,Time[i]);
         ObjectSet(Label,OBJPROP_TIME2,Time[i-1]);
    }
    else 
    {
         if(Volumes[i]<AvgVolumes[i]) { // If its a cross point
            cnt++; // calculate the number of crosses.
            Label="RSXTrend" + cnt;
            if(ObjectFind(Label)==-1)
               ObjectCreate(Label,OBJ_RECTANGLE,Window,0,0);
            ObjectSet(Label,OBJPROP_COLOR,Trending);
            ObjectSet(Label,OBJPROP_PRICE1,100000);
            ObjectSet(Label,OBJPROP_PRICE2,-100000);
            ObjectSet(Label,OBJPROP_TIME1,Time[i]);
            ObjectSet(Label,OBJPROP_TIME2,Time[i-1]);
     }
     else 
            
            ObjectSet(Label,OBJPROP_TIME2,Time[i-1]); // drag the current shadow
     }
   }       
//---- done
   return(0);
}
//+------------------------------------------------------------------+

void Div()
{
   int i;
//----
   for(i=0; i<500; i++)
     { 
                                                                                                           {white1[i] = ExtMapBuffer1[i];}
if (Close[i] > Open[i+1] && Volume[i]<Volume[i+1] )    {green1[i] = ExtMapBuffer1[i];}
if (Close[i] < Open[i+1] && Volume[i]<Volume[i+1] )    {red1[i]   = ExtMapBuffer1[i];}
}
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| VOID DRAW OBJECTS                                                |
//+------------------------------------------------------------------+

void draw_objects()
{
//+--------------
   ObjectCreate("Box", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("Box","V  S  A  ®",14, "Trebuchet MS", Orange);
   ObjectSet("Box", OBJPROP_CORNER, Corner);
   ObjectSet("Box", OBJPROP_XDISTANCE, 15);
   ObjectSet("Box", OBJPROP_YDISTANCE, 1);
   
   ObjectCreate("Box1", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("Box1","Spread/Wick/Candle",8, "Trebuchet MS", Gray);
   ObjectSet("Box1", OBJPROP_CORNER, Corner);
   ObjectSet("Box1", OBJPROP_XDISTANCE, 15);
   ObjectSet("Box1", OBJPROP_YDISTANCE, 18);
//+--------------  


   string SPREAD=DoubleToStr(ExtMapBuffer1[0],1);
   ObjectCreate("Spread(High-Low)", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("Spread(High-Low)","Spread(H-L):"+SPREAD,13, "Trebuchet MS", White);
   ObjectSet("Spread(High-Low)", OBJPROP_CORNER, Corner);
   ObjectSet("Spread(High-Low)", OBJPROP_XDISTANCE, 15);
   ObjectSet("Spread(High-Low)", OBJPROP_YDISTANCE, 34);
   
   ObjectCreate("BA_Spread(High-Low)", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("BA_Spread(High-Low)","SPREAD IS BELOW AVERAGE.",8, "Trebuchet MS", White);
   ObjectSet("BA_Spread(High-Low)", OBJPROP_CORNER, Corner);
   ObjectSet("BA_Spread(High-Low)", OBJPROP_XDISTANCE, 15);
   ObjectSet("BA_Spread(High-Low)", OBJPROP_YDISTANCE, 54);
   
if (ExtMapBuffer1[0]>AvgVolumes[0])

{ 
ObjectSetText("BA_Spread(High-Low)","SPREAD IS ABOVE AVERAGE!!!", 8,"Trebuchet MS",Red);                                                          
}
//+--------------   
   
   string UPWICK=DoubleToStr(ExtMapBuffer1a[0],1);
   ObjectCreate("UpWick", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("UpWick","WICK: "+UPWICK,9, "Trebuchet MS", Lime);
   ObjectSet("UpWick", OBJPROP_CORNER, Corner);
   ObjectSet("UpWick", OBJPROP_XDISTANCE, 85);
   ObjectSet("UpWick", OBJPROP_YDISTANCE, 70);
   
//+--------------      
   
   string DNWICK=DoubleToStr(ExtMapBuffer2a[0],1);
   ObjectCreate("DnWick", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("DnWick","WICK:"+DNWICK,9, "Trebuchet MS", Red);
   ObjectSet("DnWick", OBJPROP_CORNER, Corner);
   ObjectSet("DnWick", OBJPROP_XDISTANCE, 15);
   ObjectSet("DnWick", OBJPROP_YDISTANCE, 70);
   
   ObjectCreate("Div", OBJ_LABEL, WindowFind(WindowName), 0, 0);
   ObjectSetText("Div","Divergance:None",13, "Trebuchet MS", White);
   ObjectSet("Div", OBJPROP_CORNER, Corner);
   ObjectSet("Div", OBJPROP_XDISTANCE, 15);
   ObjectSet("Div", OBJPROP_YDISTANCE, 85);
   
   if (Close[1] > Open[2] && Volume[1]<Volume[2] )    
   {   ObjectSetText("Div","Divergance:Bearish" ,13, "Trebuchet MS", Red);}
   if (Close[1] < Open[2] && Volume[1]<Volume[2] )    
   {   ObjectSetText("Div","Divergance:Bullish",13, "Trebuchet MS", Lime);}
}

//+------------------------------------------------------------------+