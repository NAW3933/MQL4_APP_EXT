//+------------------------------------------------------------------+
//|                                   McGinley-Dynamic-Indicator_with2ATR_bands.mq4 |
//+------------------------------------------------------------------+
// Coded by smjones
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_width1 2


extern string     Note1 = "NumberOfBars = 0 means all bars";
extern int        NumberOfBars = 500;
extern int        Periods = 12;
extern int        Smoothing = 125;

extern bool       ShowATRBands  = true;
extern double     ATRupDistance  = 1;
extern double     ATRdownDistance  = 1;
extern color      BandsColor  = clrAqua;
extern int        ATR_Period  = 14; 
extern string     Note2 = " 0 means no bands - hidden - up 3";
extern int        NoOfBands = 3; 
extern int        mult = 1;

double            buffer1[];
double atrUp[], atrDn[],atrDn2[],atrUp2[],atrDn3[],atrUp3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
    if ( Digits == 3 || Digits == 5 )
         mult = 10;
//---- indicators
    SetIndexBuffer(0,buffer1);
    SetIndexStyle(0,DRAW_LINE);
    SetIndexBuffer(1, atrUp);    ArraySetAsSeries(atrUp, true);
    SetIndexBuffer(2, atrDn);    ArraySetAsSeries(atrDn, true);
    SetIndexBuffer(3, atrUp2);    ArraySetAsSeries(atrUp, true);
    SetIndexBuffer(4, atrDn2);    ArraySetAsSeries(atrDn, true);
    SetIndexBuffer(5, atrUp3);    ArraySetAsSeries(atrUp, true);
    SetIndexBuffer(6, atrDn3);    ArraySetAsSeries(atrDn, true); 
      
    SetIndexStyle(1,DRAW_LINE, STYLE_SOLID, 1, BandsColor);
    SetIndexStyle(2,DRAW_LINE, STYLE_SOLID, 1, BandsColor);
    SetIndexStyle(3,DRAW_LINE, STYLE_SOLID, 1, BandsColor);
    SetIndexStyle(4,DRAW_LINE, STYLE_SOLID, 1, BandsColor);
    SetIndexStyle(5,DRAW_LINE, STYLE_SOLID, 1, BandsColor);
    SetIndexStyle(6,DRAW_LINE, STYLE_SOLID, 1, BandsColor);
      
    //if (ShowATRBands) SetIndexLabel(1,"Upper ATR Band");   else SetIndexLabel(5,NULL);
    //if (ShowATRBands) SetIndexLabel(2,"Lower ATR Band");   else SetIndexLabel(6,NULL);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars;

   for(int i=0; i<limit; i++)   
      {
         
         //  Ref(Mov(C,12,E),-1)+((C-(Ref(Mov(C,12,E),-1))) / (C/(Ref(Mov(C,12,E),-1))*125))
            
         buffer1[i] = 
         //  Ref(Mov(C,12,E),-1)
         iMA(NULL,0,Periods,0,MODE_EMA,PRICE_CLOSE,i+1) 
         // +
         +
         // ( (C - (Ref(Mov(C,12,E),-1)) )
         ( (Close[i] - (iMA(NULL,0,Periods,0,MODE_EMA,PRICE_CLOSE,i+1)))
         // /
         /
         // (C/(Ref(Mov(C,12,E),-1))*125))
         (Close[i] / (iMA(NULL,0,Periods,0,MODE_EMA,PRICE_CLOSE,i+1)) * Smoothing) );
          
         if (ShowATRBands) {
                           double atr = iATR(_Symbol,PERIOD_CURRENT,ATR_Period,i);
                           atrUp[i] = buffer1[i] + atr * ATRupDistance;
                           atrDn[i] = buffer1[i] - atr * ATRdownDistance;
                           atrUp2[i] = buffer1[i] + atr * (ATRupDistance*2);
                           atrDn2[i] = buffer1[i] - atr * (ATRdownDistance*2);
                           atrUp3[i] = buffer1[i] + atr * (ATRupDistance*3);
                           atrDn3[i] = buffer1[i] - atr * (ATRdownDistance*3);
                           }
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+