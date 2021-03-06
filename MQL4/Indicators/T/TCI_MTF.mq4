// More information about this indicator can be found at:
// http://fxcodebase.com/code/viewtopic.php?f=38&t=65657

//+------------------------------------------------------------------+
//|                               Copyright © 2018, Gehtsoft USA LLC | 
//|                                            http://fxcodebase.com |
//+------------------------------------------------------------------+
//|                                      Developed by : Mario Jemic  |                    
//|                                          mario.jemic@gmail.com   |
//+------------------------------------------------------------------+
//|                                 Support our efforts by donating  | 
//|                                    Paypal: https://goo.gl/9Rj74e |
//|                    BitCoin : 15VCJTLaz12Amr7adHSBtL9v8XomURo9RF  |  
//|                BitCoin Cash: 1BEtS465S3Su438Kc58h2sqvVvHK9Mijtg  | 
//|           Ethereum : 0x8C110cD61538fb6d7A2B47858F0c0AaBd663068D  |  
//|                   LiteCoin : LLU8PSY2vsq7B9kRELLZQcKf5nJQrdeqwD  |  
//+------------------------------------------------------------------+

#property copyright "Copyright © 2018, Gehtsoft USA LLC"
#property link      "http://fxcodebase.com"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1  clrLime
#property indicator_width1  2
#property indicator_color2  clrYellow
#property indicator_width2  2
#property indicator_color3  clrRed
#property indicator_width3  2
#property indicator_levelcolor clrWhite
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT

enum e_cycles{ Min_5=1, Min_15=2, Min_30=3, Min_60=4, Min_240=5, Daily=6, Weekly=7, Monthly=8 };
enum e_method{ SMA=MODE_SMA, EMA=MODE_EMA, SMMA=MODE_SMMA, LWMA=MODE_LWMA };
enum e_price{ CLOSE=PRICE_CLOSE, OPEN=PRICE_OPEN, LOW=PRICE_LOW, HIGH=PRICE_HIGH, MEDIAN=PRICE_MEDIAN, TYPICAL=PRICE_TYPICAL, WEIGHTED=PRICE_WEIGHTED };

input  e_method Fast_MA_Method  = EMA;
input  e_price  Fast_MA_Price   = CLOSE;
extern int      Fast_MA_Periods = 5;
input  e_method Slow_MA_Method  = EMA;
input  e_price  Slow_MA_Price   = CLOSE;
extern int      Slow_MA_Periods = 10;
input  e_cycles TimeFrame_1     = Min_60;
input  e_cycles TimeFrame_2     = Min_240;
input  e_cycles TimeFrame_3     = Daily;

double TCI1[];
double TCI2[];
double TCI3[];

//+****************************************************************+

int init(){
   
   IndicatorShortName("TCI_MTF");
   
   IndicatorBuffers(3);
      
   if (Check(TimeFrame_1)||Check(TimeFrame_2)||Check(TimeFrame_3)) Alert("The Bigger TF Source selected for this Time Frame cannot be calculated");
   
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,TCI1);
   SetIndexLabel(0,"TCI "+Get_TimeFrame(TimeFrame_1, true)+" mins");
   
   SetIndexStyle(1,DRAW_SECTION);
   SetIndexBuffer(1,TCI2);
   SetIndexLabel(1,"TCI "+Get_TimeFrame(TimeFrame_2, true)+" mins");
   
   SetIndexStyle(2,DRAW_SECTION);
   SetIndexBuffer(2,TCI3);
   SetIndexLabel(2,"TCI "+Get_TimeFrame(TimeFrame_3, true)+" mins");
   
   SetLevelValue(0,0);
   
   return(0);
   
  }
  
//+****************************************************************+

  
int start(){
   
   int i;
   int counted_bars=IndicatorCounted();
   int limit = Bars-counted_bars-1;
   
   double pipSize = MarketInfo(Symbol(),MODE_POINT);
   if (MarketInfo("EURUSD",MODE_DIGITS)==5) pipSize=pipSize*10; // I take the EURUSD as an example to check if it is 5 digits instead of 4, if so, I multiply it by 10
   
   double slow_ma, fast_ma;
   
   if (Check(TimeFrame_1)==false && Check(TimeFrame_2)==false && Check(TimeFrame_3)==false){
      
      int period, multiplier;
      
      for(i=limit; i>=0; i--) ResetBuffers(i);
      
      // TF 1
      period     = Get_TimeFrame(TimeFrame_1);
      multiplier = Get_TimeFrame(TimeFrame_1, true)/Period();
      for(i=floor(limit/multiplier) ; i>=0; i--){
         
         fast_ma = iMA(NULL,period,Fast_MA_Periods,0,ENUM_MA_METHOD(Fast_MA_Method),ENUM_APPLIED_PRICE(Fast_MA_Price),i);
         slow_ma = iMA(NULL,period,Slow_MA_Periods,0,ENUM_MA_METHOD(Slow_MA_Method),ENUM_APPLIED_PRICE(Slow_MA_Price),i);   
         TCI1[i*multiplier] = (fast_ma / slow_ma-1) *100;
      
      }
      
      // TF 2
      period     = Get_TimeFrame(TimeFrame_2);
      multiplier = Get_TimeFrame(TimeFrame_2, true)/Period();
      for(i=floor(limit/multiplier) ; i>=0; i--){
         fast_ma = iMA(NULL,period,Fast_MA_Periods,0,ENUM_MA_METHOD(Fast_MA_Method),ENUM_APPLIED_PRICE(Fast_MA_Price),i);
         slow_ma = iMA(NULL,period,Slow_MA_Periods,0,ENUM_MA_METHOD(Slow_MA_Method),ENUM_APPLIED_PRICE(Slow_MA_Price),i);   
         TCI2[i*multiplier] = (fast_ma / slow_ma-1) *100;
      }
      
      // TF 3
      period     = Get_TimeFrame(TimeFrame_3);
      multiplier = Get_TimeFrame(TimeFrame_3, true)/Period();
      for(i=floor(limit/multiplier) ; i>=0; i--){
         fast_ma = iMA(NULL,period,Fast_MA_Periods,0,ENUM_MA_METHOD(Fast_MA_Method),ENUM_APPLIED_PRICE(Fast_MA_Price),i);
         slow_ma = iMA(NULL,period,Slow_MA_Periods,0,ENUM_MA_METHOD(Slow_MA_Method),ENUM_APPLIED_PRICE(Slow_MA_Price),i);   
         TCI3[i*multiplier] = (fast_ma / slow_ma-1) *100;
      }
   
   } // if check
   
   return(0);
   
  }
  
bool Check (int BTF){
   
   bool wrong_tf = false;
   
   if (Period()==5     && BTF<1) wrong_tf = true;
   if (Period()==15    && BTF<2) wrong_tf = true;
   if (Period()==30    && BTF<3) wrong_tf = true;
   if (Period()==60    && BTF<4) wrong_tf = true;
   if (Period()==240   && BTF<5) wrong_tf = true;
   if (Period()==1440  && BTF<6) wrong_tf = true;
   if (Period()==10080 && BTF<7) wrong_tf = true;
   if (Period()==43200)          wrong_tf = true;
   
   return(wrong_tf);
   
}

int Get_TimeFrame(int BTF, bool mins = false){
   int Periodo, Minutes;
   if (BTF==1){ Periodo = PERIOD_M5;  Minutes = 5;     }
   if (BTF==2){ Periodo = PERIOD_M15; Minutes = 15;    }
   if (BTF==3){ Periodo = PERIOD_M30; Minutes = 30;    }
   if (BTF==4){ Periodo = PERIOD_H1;  Minutes = 60;    }
   if (BTF==5){ Periodo = PERIOD_H4;  Minutes = 240;   }
   if (BTF==6){ Periodo = PERIOD_D1;  Minutes = 1440;  }
   if (BTF==7){ Periodo = PERIOD_W1;  Minutes = 10080; }
   if (BTF==8){ Periodo = PERIOD_MN1; Minutes = 43200; }
   if (mins) return(Minutes); else return(Periodo);
}

void ResetBuffers(int shift){
   
   TCI1[shift] = EMPTY_VALUE;
   TCI2[shift] = EMPTY_VALUE;
   TCI3[shift] = EMPTY_VALUE;
   return;
   
}
