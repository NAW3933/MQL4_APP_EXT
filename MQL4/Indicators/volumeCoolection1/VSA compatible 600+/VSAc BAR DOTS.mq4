//+------------------------------------------------------------------+
//|                                                VSA© BAR DOTS.mq4 |
//|                                    Copyright © 2008, FOREXflash. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, FOREXflash Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 3

#property indicator_color1 White
#property indicator_color2 DeepSkyBlue
#property indicator_color3 Orange

#property indicator_width1 2
#property indicator_width2 1
#property indicator_width3 1

int     BarsLimit            = 500;

//---- buffers
double  R[],D[],S[];
string  WindowName;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators      
         
      SetIndexBuffer(0,R);
      SetIndexStyle(0,DRAW_ARROW);
      SetIndexArrow(0, 159);
      SetIndexLabel(0,"MIDDLE OF BAR");
      
      SetIndexBuffer(1,D);
      SetIndexStyle(1,DRAW_ARROW);
      SetIndexArrow(1, 161);
      SetIndexLabel(1,"UPPER PART OF BAR");
      
      SetIndexBuffer(2,S);
      SetIndexStyle(2,DRAW_ARROW);
      SetIndexArrow(2, 161);
      SetIndexLabel(2,"LOWER PART OF BAR");
      
      
string short_name = "VSA© BAR DOTS";     
IndicatorShortName(short_name);
WindowName = short_name;
IndicatorDigits(1);
//----
return(1);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----
return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
{    
   
   int    i,nLimit,nCountedBars;
//---- bars count that does not changed after last indicator launch.
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted
   if(nCountedBars>0) nCountedBars--;
   nLimit=Bars-nCountedBars;
   for(i=0; i<nLimit; i++)
   {  
//+-------------- 

double MIDDLEOFBAR =(High[i+1]+Low[i+1])/2;                    
double UPOFBAR =(High[i+1]+Low[i+1])/2+(High[i+1]-Low[i+1])/3.6;     
double DOWNOFBAR =(High[i+1]+Low[i+1])/2-(High[i+1]-Low[i+1])/3.6;   

if ( Close[i+1]<UPOFBAR && Close[i+1]>DOWNOFBAR)     {R[i+1]=MIDDLEOFBAR;   }
if ( Close[i+1]>UPOFBAR)                             {D[i+1]=UPOFBAR;       }
if ( Close[i+1]<DOWNOFBAR)                           {S[i+1]=DOWNOFBAR;     }
}

//----
return(0);
}
//+------------------------------------------------------------------+

