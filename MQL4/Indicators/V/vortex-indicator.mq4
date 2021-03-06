//+------------------------------------------------------------------+
//|                                             vortex-indicator.mq4 |
//|        ©2011 Best-metatrader-indicators.com. All rights reserved |
//|                        http://www.best-metatrader-indicators.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011 Best-metatrader-indicators.com."
#property link      "http://www.best-metatrader-indicators.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 Tomato

//---- Input parameters
extern int VI_Length=14;

//---- Buffers
double PlusVI[];        //VI+ : + Vortex Indicator buffer
double MinusVI[];       //VI- : - Vortex Indicator buffer
double PlusVM[];        //VM+ : + Vortex Movement buffer
double MinusVM[];       //VM- : - Vorext Movement buffer
double SumPlusVM[];     //Sum of VI_Length PlusVM values
double SumMinusVM[];    //Sum of VI_Length MinusVM values
double SumTR[];         //True Range buffer
string Copyright="";  
string MPrefix="FI";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//----
    IndicatorBuffers(7);
    IndicatorDigits(Digits);
//---- Set visible buffer properties    
    SetIndexBuffer(0,PlusVI);
    SetIndexBuffer(1,MinusVI);
    SetIndexStyle(0,DRAW_LINE);    
    SetIndexStyle(1,DRAW_LINE);
    SetIndexLabel(0,"PlusVI(" + VI_Length + ")");
    SetIndexLabel(1,"MinusVI(" + VI_Length + ")");
    SetIndexDrawBegin(0,VI_Length);
    SetIndexDrawBegin(1,VI_Length);
//---- Set indices of caching buffers
    SetIndexBuffer(2,PlusVM);
    SetIndexBuffer(3,MinusVM);
    SetIndexBuffer(4,SumPlusVM);
    SetIndexBuffer(5,SumMinusVM);
    SetIndexBuffer(6,SumTR);
    IndicatorShortName("Vortex Indicator ("+VI_Length+") ");
//----
   DL("001", Copyright, 5, 20,Gold,"Arial",10,0); 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ClearObjects(); 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
    int Limit;
    int CountedBars = IndicatorCounted();
//---- Check for possible errors
    if(CountedBars < 0) return(-1);
//---- Last counted bar will be recounted
    if(CountedBars > 0) CountedBars--;
    Limit = Bars - CountedBars;
//---- Clear caching buffers
    for(int i = 0; i < Limit; i++)
    {
      SumPlusVM[i] = 0;
      SumMinusVM[i] = 0;
      SumTR[i]= 0;  
    }
//---- Store the values of PlusVM and MinusVM
    for(i = 0; i < Limit; i++)
    {
        //PlusVM = |Today's High - Yesterday's Low|
        PlusVM[i] = MathAbs(High[i] - Low[i + 1]);
        //MinusVM = |Today's Low - Yesterday's High|
        MinusVM[i] = MathAbs(Low[i] - High[i +1]);  
    }
//---- Sum VI_Length values of PlusVM, MinusVM and the True Range
    for(i = 0; i < Limit; i++)
    {
        for(int j = 0; j <= VI_Length - 1; j++)
        {
           SumPlusVM[i] += PlusVM[i + j];
           SumMinusVM[i] += MinusVM[i + j];
           SumTR[i] += iATR(NULL,0,1,i + j); //Sum VI_Length values of the True Range by using a 1-period ATR
        }
    }
//---- Draw the indicator
    for(i = 0; i < Limit; i++)
    {
        PlusVI[i] = SumPlusVM[i] / SumTR[i];
        MinusVI[i] = SumMinusVM[i] / SumTR[i];
    }
//----
    return(0);
}
//+------------------------------------------------------------------+
//| DL function                                                      |
//+------------------------------------------------------------------+
 void DL(string label, string text, int x, int y, color clr, string FontName = "Arial",int FontSize = 12, int typeCorner = 1)
 
{
   string labelIndicator = MPrefix + label;   
   if (ObjectFind(labelIndicator) == -1)
   {
      ObjectCreate(labelIndicator, OBJ_LABEL, 0, 0, 0);
  }
   
   ObjectSet(labelIndicator, OBJPROP_CORNER, typeCorner);
   ObjectSet(labelIndicator, OBJPROP_XDISTANCE, x);
   ObjectSet(labelIndicator, OBJPROP_YDISTANCE, y);
   ObjectSetText(labelIndicator, text, FontSize, FontName, clr);
  
}  

//+------------------------------------------------------------------+
//| ClearObjects function                                            |
//+------------------------------------------------------------------+
void ClearObjects() 
{ 
  for(int i=0;i<ObjectsTotal();i++) 
  if(StringFind(ObjectName(i),MPrefix)==0) { ObjectDelete(ObjectName(i)); i--; } 
}
//+------------------------------------------------------------------+