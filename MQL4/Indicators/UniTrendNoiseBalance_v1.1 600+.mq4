//+------------------------------------------------------------------+
//|                               UniTrendNoiseBalance_v1.1 600+.mq4 |
//|                                Copyright © 2015, TrendLaboratory |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2015, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"
#property strict

#property indicator_separate_window
#property indicator_buffers   5
#property indicator_color1    clrLimeGreen
#property indicator_color2    clrGreen
#property indicator_color3    clrRed
#property indicator_color4    clrMaroon
#property indicator_color5    clrLightSteelBlue

#property indicator_width1    2
#property indicator_width2    1
#property indicator_width3    2
#property indicator_width4    1
#property indicator_width5    1


enum ENUM_PRICE
{
   close,               // Close
   open,                // Open
   high,                // High
   low,                 // Low
   median,              // Median
   typical,             // Typical
   weightedClose,       // Weighted Close
   heikenAshiClose,     // Heiken Ashi Close
   heikenAshiOpen,      // Heiken Ashi Open
   heikenAshiHigh,      // Heiken Ashi High   
   heikenAshiLow,       // Heiken Ashi Low
   heikenAshiMedian,    // Heiken Ashi Median
   heikenAshiTypical,   // Heiken Ashi Typical
   heikenAshiWeighted   // Heiken Ashi Weighted Close   
};

enum ENUM_MATHMODE
{
   RSI,                 // RSI
   Stoch,               // Stochastic
   DMI,                 // DMI
   MACD                 // MACD
};

enum ENUM_SCALEMODE
{
   scale1,              // 0...100
   scale2               // -100...100
};

//---- indicator parameters
extern ENUM_TIMEFRAMES  TimeFrame         =        0;    // TimeFrame
extern ENUM_MATHMODE    MathMode          =     MACD;    // Math Mode
extern ENUM_PRICE       Price             =    close;    // Applied to
extern int              Length            =       15;    // Period
extern int              PreSmooth         =        7;    // Pre-Smoothing Period
extern int              Smooth            =        1;    // Smoothing Period
extern int              TrendPeriod       =        4;    // Scalar Trend Period
extern int              NoisePeriod       =      250;    // Scalar Noise Period
extern int              Pole              =        1;    // Pole:1-EMA,2-DEMA,3-TEMA,4-QEMA...
extern int              Order             =        1;    // Smoothing Order(min. 1)
extern double           WeightFactor      =        2;    // Weight Factor (ex.Wilder=1,EMA=2)   
extern double           DampingFactor     =      0.5;    // Damping Factor
extern double           Level1            =       50;    // Weak Trend Level
extern double           Level2            =       65;    // Moderate Trend Level
extern double           Level3            =       80;    // Strong Trend Level 
extern bool             ShowInColor       =    false;    // Show in color
extern ENUM_SCALEMODE   ScaleMode         =   scale1;    // Scale Mode 

extern string           alerts            = "=== Alerts & Emails ===";
extern bool             AlertOn           =    false;    //
extern int              AlertShift        =        1;    //
extern int              SoundsNumber      =        5;    // Number of sounds after Signal
extern int              SoundsPause       =        5;    // Pause in sec between sounds 
extern string           UpSound           = "alert.wav";
extern string           DnSound           = "alert2.wav";
extern bool             EmailOn           =    false;    // 
extern int              EmailsNumber      =        1;    // Number of Emails after Signal


//---- indicator buffers

double upIncreasing[];
double upDecreasing[];
double dnIncreasing[];
double dnDecreasing[];
double tnbalance[];
double periods[];

double dt[];

//----
double   price[2], mMA[2], mHi[2], mLo[2], cpc[2], trend[2];
string   TF, IndicatorName, short_name;
int      timeframe;
datetime prevtime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   timeframe = TimeFrame;
   if(timeframe <= Period()) timeframe = Period(); 
   TF = tf(timeframe);
   
   IndicatorDigits(Digits);

//---- indicator buffers mapping
   IndicatorBuffers(7);
   SetIndexBuffer(0, upIncreasing); SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(1, upDecreasing); SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(2, dnIncreasing); SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(3, dnDecreasing); SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(4,    tnbalance); SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(5,      periods); 
   SetIndexBuffer(6,           dt);
  
 
//---- indicator name
    
   IndicatorName = WindowExpertName(); 
   short_name = IndicatorName + "[" + TF + "]("+ EnumToString(MathMode) + "," + EnumToString(Price) + "," + (string)Length + "," + (string)PreSmooth + "," + (string)Smooth + ")";
   IndicatorShortName(short_name);
     
   SetIndexLabel(0,"UpTrend Increasing");   
   SetIndexLabel(1,"UpTrend Decreasing");
   SetIndexLabel(2,"DnTrend Increasing ");
   SetIndexLabel(3,"DnTrend Decreasing");
   SetIndexLabel(4,"TrendNoiseBalance");
   SetIndexLabel(5,"Periods");
  
   
   int draw_begin = Bars - iBars(NULL,timeframe)*timeframe/Period() + Length + PreSmooth + Smooth + TrendPeriod + NoisePeriod;
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
   SetIndexDrawBegin(2,draw_begin);
   SetIndexDrawBegin(3,draw_begin);
   SetIndexDrawBegin(4,draw_begin);
   SetIndexDrawBegin(5,draw_begin);
   
   
   if(ScaleMode == scale1)
   {
   IndicatorSetDouble(INDICATOR_MINIMUM,  0);
   IndicatorSetDouble(INDICATOR_MAXIMUM,100);
   }
   else
   {
   IndicatorSetDouble(INDICATOR_MINIMUM,-100);
   IndicatorSetDouble(INDICATOR_MAXIMUM, 100);
   }
//----
   uniema_size = Pole*Order;   
   ArrayResize(uniema_tmp,uniema_size*9);
   ArrayResize(uniema_prevtime,9);

//---- initialization done
   
   return(INIT_SUCCEEDED);
}

int deinit() {Comment(""); return(0);}

//+------------------------------------------------------------------+
//| UniTrendNoiseBalance_v1.0 600+                                   |
//+------------------------------------------------------------------+
int start()
{
   int  limit = 0, shift, counted_bars = IndicatorCounted(); 
      
   if(counted_bars > 0) limit=Bars - counted_bars - 1;
   if(counted_bars < 0) return(0);
   if(counted_bars < 1)  
   { 
   limit = Bars - 1;   
      if(Level1 > 0)
      {
      SetLevelValue(2, Level1);
      IndicatorSetString(INDICATOR_LEVELTEXT,2,"Weak Trend");
         if(ScaleMode == scale2) 
         {
         SetLevelValue(3,-Level1);
         IndicatorSetString(INDICATOR_LEVELTEXT,3,"Weak Trend");
         }
      }
      else
      {
      SetLevelValue(2,0);
      SetLevelValue(3,0);
      IndicatorSetString(INDICATOR_LEVELTEXT,2," ");
      IndicatorSetString(INDICATOR_LEVELTEXT,3," ");
      }
      
      if(Level2 > 0)
      {
      SetLevelValue(4, Level2);
      IndicatorSetString(INDICATOR_LEVELTEXT,4,"Moderate Trend");
         if(ScaleMode == scale2) 
         {
         SetLevelValue(5,-Level2);
         IndicatorSetString(INDICATOR_LEVELTEXT,5,"Moderate Trend");
         }
      }
      else
      {
      SetLevelValue(4,0);
      SetLevelValue(5,0);
      IndicatorSetString(INDICATOR_LEVELTEXT,4," ");
      IndicatorSetString(INDICATOR_LEVELTEXT,5," ");
      }
      
      if(Level3 > 0)
      {
      SetLevelValue(6, Level3);
      IndicatorSetString(INDICATOR_LEVELTEXT,6,"Strong Trend");
         if(ScaleMode == scale2) 
         {
         SetLevelValue(7,-Level3);
         IndicatorSetString(INDICATOR_LEVELTEXT,7,"Strong Trend");
         }
      }
      else
      {
      SetLevelValue(6,0);
      SetLevelValue(7,0);
      IndicatorSetString(INDICATOR_LEVELTEXT,6," ");
      IndicatorSetString(INDICATOR_LEVELTEXT,7," ");
      }
   }   
   
   if(timeframe != Period())
	{
   limit = MathMax(limit,timeframe/Period());   
      
      for(shift = 0;shift < limit;shift++) 
      {	
      int y = iBarShift(NULL,timeframe,Time[shift]);
      
      
      upIncreasing[shift]  = iCustom(NULL,TimeFrame,IndicatorName,0,MathMode,Price,Length,PreSmooth,Smooth,TrendPeriod,NoisePeriod,Pole,Order,WeightFactor,DampingFactor,Level1,Level2,Level3,ShowInColor,ScaleMode,
                                     "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpSound,DnSound,EmailOn,EmailsNumber,0,y);      
      upDecreasing[shift]  = iCustom(NULL,TimeFrame,IndicatorName,0,MathMode,Price,Length,PreSmooth,Smooth,TrendPeriod,NoisePeriod,Pole,Order,WeightFactor,DampingFactor,Level1,Level2,Level3,ShowInColor,ScaleMode,
                                     "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpSound,DnSound,EmailOn,EmailsNumber,1,y);    
               
      dnIncreasing[shift]  = iCustom(NULL,TimeFrame,IndicatorName,0,MathMode,Price,Length,PreSmooth,Smooth,TrendPeriod,NoisePeriod,Pole,Order,WeightFactor,DampingFactor,Level1,Level2,Level3,ShowInColor,ScaleMode,
                                     "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpSound,DnSound,EmailOn,EmailsNumber,2,y);     
      dnDecreasing[shift]  = iCustom(NULL,TimeFrame,IndicatorName,0,MathMode,Price,Length,PreSmooth,Smooth,TrendPeriod,NoisePeriod,Pole,Order,WeightFactor,DampingFactor,Level1,Level2,Level3,ShowInColor,ScaleMode,
                                     "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpSound,DnSound,EmailOn,EmailsNumber,3,y);    
             
      tnbalance[shift]     = iCustom(NULL,TimeFrame,IndicatorName,0,MathMode,Price,Length,PreSmooth,Smooth,TrendPeriod,NoisePeriod,Pole,Order,WeightFactor,DampingFactor,Level1,Level2,Level3,ShowInColor,ScaleMode,
                                     "",AlertOn,AlertShift,SoundsNumber,SoundsPause,UpSound,DnSound,EmailOn,EmailsNumber,4,y);       
      }  
	
	return(0);
	}
	else _UniTNB(limit);

   return(0);
}


//-----
void _UniTNB(int limit)
{   
   int      len;
   bool     uptrend = false, dntrend = false, upweak = false, dnweak = false, upmoder = false, dnmoder = false, upstrong = false, dnstrong = false;
   double   slow, up, dn, bulls, bears, lbulls, lbears, numerator;
   string   message;
   
   for(int shift=limit;shift>=0;shift--) 
   {
      if(prevtime != Time[shift])
      {
      price[1]   = price[0]; 
      mMA[1]     = mMA[0]; 
      mHi[1]     = mHi[0];
      mLo[1]     = mLo[0]; 
      cpc[1]     = cpc[0]; 
      trend[1]   = trend[0];
      prevtime   = Time[shift];
      }
   
   if(Price <= 6) price[0] = iMA(NULL,0,1,0,0,(int)Price,shift);   
   else
   if(Price > 6 && Price <= 13) price[0] = HeikenAshi(0,(int)Price-7,shift);
         
   mMA[0] = UniXMA(0,price[0],PreSmooth,Pole,Order,WeightFactor,DampingFactor,0,shift);      
      
   if(shift > Bars - Length - 2) continue;
   
      switch(MathMode) 
      {
      case RSI:   bulls = 0.5*(MathAbs(mMA[0] - mMA[1]) + (mMA[0] - mMA[1]));
                  bears = 0.5*(MathAbs(mMA[0] - mMA[1]) - (mMA[0] - mMA[1]));
                  break;
                     
      case Stoch: up = High[shift];      
                  dn = Low [shift];
                     
                     for(int i=1;i<Length;i++)
                     {   
                     up = MathMax(up,High[shift+i]);
                     dn = MathMin(dn,Low [shift+i]);
                     }
         
                  bulls = mMA[0] - dn;
                  bears = up - mMA[0];
                  break;
                     
      case DMI:   mHi[0] = UniXMA(1,iMA(NULL,0,1,0,0,2,shift),PreSmooth,Pole,Order,WeightFactor,DampingFactor,0,shift); 
                  mLo[0] = UniXMA(2,iMA(NULL,0,1,0,0,3,shift),PreSmooth,Pole,Order,WeightFactor,DampingFactor,0,shift);           
               
                  bulls = MathMax(0,0.5*(MathAbs(mHi[0] - mHi[1]) + (mHi[0] - mHi[1])));
                  bears = MathMax(0,0.5*(MathAbs(mLo[1] - mLo[0]) + (mLo[1] - mLo[0])));
      
                    if(bulls >  bears) bears = 0;
                    else 
                    if(bulls <  bears) bulls = 0;
                    else
                    if(bulls == bears) {bulls = 0; bears = 0;}
                  break;
                     
      case MACD:  slow = UniXMA(3,price[0],Length,Pole,Order,WeightFactor,DampingFactor,0,shift);  
                  bulls = 0.5*(MathAbs(mMA[0] - slow) + (mMA[0] - slow));
                  bears = 0.5*(MathAbs(mMA[0] - slow) - (mMA[0] - slow));
                  break;
      }
         
   if(MathMode == Stoch || MathMode == MACD) len = 1; else len = Length; 
   
   lbulls = UniXMA(4,bulls,len,Pole,Order,WeightFactor,DampingFactor,0,shift);       
   lbears = UniXMA(5,bears,len,Pole,Order,WeightFactor,DampingFactor,0,shift);
   
   double Bulls = UniXMA(6,lbulls,Smooth,Pole,Order,WeightFactor,DampingFactor,0,shift);      
   double Bears = UniXMA(7,lbears,Smooth,Pole,Order,WeightFactor,DampingFactor,0,shift);  
     
      
      if(Bulls > Bears) periods[shift] = 1;
      else
      if(Bulls < Bears) periods[shift] =-1; 
      else periods[shift] = 0;
      
   double dc = price[0] - price[1];
         
      
      if(periods[shift] != periods[shift+1])
      {
      cpc[0]   = 0;
      trend[0] = UniXMA(8,cpc[0],TrendPeriod,1,1,1,1,1,shift);;
      }
      else
      {
      cpc[0]   = cpc[1] + dc;
      trend[0] = UniXMA(8,cpc[0],TrendPeriod,1,1,1,1,0,shift);  
      }      
      
   dt[shift]    = (cpc[0] - trend[0])*(cpc[0] - trend[0]);
   
   if(shift > Bars - Length - NoisePeriod - 2) continue;
   
   double avg   = SMAOnArray(dt,NoisePeriod,shift);
   double noise = MathSqrt(avg);   
   
      if(ScaleMode == scale1) numerator = MathAbs(trend[0]); 
      else 
      if(ScaleMode == scale2) 
      {
      if(periods[shift] > 0) numerator = MathAbs(trend[0]); else numerator = -MathAbs(trend[0]);
      }
   
   if(MathAbs(trend[0]) + noise > 0) tnbalance[shift] = 100*numerator/(MathAbs(trend[0]) + MathAbs(noise)); else tnbalance[shift] = 0;    
         
      if(ShowInColor)
      {   
      upIncreasing[shift] = EMPTY_VALUE; 
      upDecreasing[shift] = EMPTY_VALUE; 
      dnIncreasing[shift] = EMPTY_VALUE; 
      dnDecreasing[shift] = EMPTY_VALUE;       
         
         if(periods[shift] > 0)
            if(tnbalance[shift] > tnbalance[shift+1]) upIncreasing[shift] = tnbalance[shift]; else  upDecreasing[shift] = tnbalance[shift];
         else               
            if(tnbalance[shift] > tnbalance[shift+1]) dnDecreasing[shift] = tnbalance[shift]; else  dnIncreasing[shift] = tnbalance[shift];   
      }     
   }
   
   if(AlertOn)
   {
   int sign = 1; 
   if(ScaleMode == scale2) sign =-1;   
      
      if(Level1 > 0)
      {
      upweak   = periods[AlertShift] > 0 && tnbalance[AlertShift] > Level1 && tnbalance[AlertShift+1] <= Level1 && tnbalance[AlertShift] <= Level2;                  
         
         if(ScaleMode == scale1) 
         dnweak = periods[AlertShift] < 0 && tnbalance[AlertShift] > Level1 && tnbalance[AlertShift+1] <= Level1 && tnbalance[AlertShift] <= Level2; 
         else
         dnweak = periods[AlertShift] < 0 && tnbalance[AlertShift] <-Level1 && tnbalance[AlertShift+1] >=-Level1 && tnbalance[AlertShift] >=-Level2; 
      }
        
      if(Level2 > 0)
      {
      upmoder  = periods[AlertShift] > 0 && tnbalance[AlertShift] > Level2 && tnbalance[AlertShift+1] <= Level2 && tnbalance[AlertShift] <= Level3;                  
         
         if(ScaleMode == scale1) 
         dnmoder  = periods[AlertShift] < 0 && tnbalance[AlertShift] > Level2 && tnbalance[AlertShift+1] <= Level2 && tnbalance[AlertShift] <= Level3; 
         else
         dnmoder  = periods[AlertShift] < 0 && tnbalance[AlertShift] <-Level2 && tnbalance[AlertShift+1] >=-Level2 && tnbalance[AlertShift] >=-Level3; 
      }
      
      if(Level3 > 0)
      {
      upstrong = periods[AlertShift] > 0 && tnbalance[AlertShift] > Level3 && tnbalance[AlertShift+1] <= Level3;                  
         
         if(ScaleMode == scale1) 
         dnstrong = periods[AlertShift] < 0 && tnbalance[AlertShift] > Level3 && tnbalance[AlertShift+1] <= Level3;    
         else
         dnstrong = periods[AlertShift] < 0 && tnbalance[AlertShift] <-Level3 && tnbalance[AlertShift+1] >=-Level3;    
      }
      
      if(upweak || upmoder || upstrong)
      {
         if(upweak  ) message = "Weak Up";
         else
         if(upmoder ) message = "Moderate Up";
         else
         if(upstrong) message = "Strong Up";
      uptrend = true;
      }
      
      if(dnweak || dnmoder || dnstrong)
      {
         if(dnweak  ) message = "Weak Down";
         else
         if(dnmoder ) message = "Moderate Down";
         else
         if(dnstrong) message = "Strong Down";
      dntrend = true;
      }   
      
      if(uptrend || dntrend)
      {
         if(isNewBar(TimeFrame))
         {
         BoxAlert(uptrend," : " + message + "trend @ " +DoubleToStr(Close[AlertShift],Digits));   
         BoxAlert(dntrend," : " + message + "trend @ " +DoubleToStr(Close[AlertShift],Digits)); 
         }
      
      WarningSound(uptrend,SoundsNumber,SoundsPause,UpSound,Time[AlertShift]);
      WarningSound(dntrend,SoundsNumber,SoundsPause,DnSound,Time[AlertShift]);
         
         if(EmailOn)
         {
         EmailAlert(uptrend,"BUY" ," : " + message + "trend @ " +DoubleToStr(Close[AlertShift],Digits),EmailsNumber); 
         EmailAlert(dntrend,"SELL"," : " + message + "trend @ " +DoubleToStr(Close[AlertShift],Digits),EmailsNumber); 
         }
      }
   }
}


//-----
int      uniema_size;
double   uniema_tmp[][2];
datetime uniema_prevtime[];

double UniXMA(int index,double iprice,int len,int pole,int order,double wf,double df,int initp,int bar)
{
   int k, j, m = index*uniema_size; 
   double alpha = (wf*order)/(len + wf*order-1); 
         
   if(uniema_prevtime[index] != Time[bar])
   {
   for(k=0;k<order;k++) 
      for(j=0;j<pole;j++) uniema_tmp[m+pole*k+j][1] = uniema_tmp[m+pole*k+j][0];
   
   uniema_prevtime[index] = Time[bar];
   }
   
   if(bar >= Bars - 2 || (initp > 0)) 
   {
   for(k=0;k<order;k++) 
      for(j=0;j<pole;j++) uniema_tmp[m+pole*k+j][0] = iprice; 
   }
   else  
   {
      for(k=0;k<order;k++)
      {
         for(j=0;j<pole;j++)
         {   
         uniema_tmp[m+pole*k+j][0] = (1 - alpha)*uniema_tmp[m+pole*k+j][1] + alpha*iprice; 
         if(j > 0) iprice += df*(uniema_tmp[m+pole*k][0] - uniema_tmp[m+pole*k+j][0]); else iprice = uniema_tmp[m+pole*k+j][0];
         }
      }   
   }
   
   return(iprice); 
}

double SMAOnArray(double& array[],int per,int bar)
{
   double Sum = 0;
   for(int i=0;i<per;i++) Sum += array[bar+i];
   
   return(Sum/per);
}

// HeikenAshi Price
double   haClose[2][2], haOpen[2][2], haHigh[2][2], haLow[2][2];
datetime prevhatime[2];

double HeikenAshi(int index,int iprice,int bar)
{ 
   if(prevhatime[index] != Time[bar])
   {
   haClose[index][1] = haClose[index][0];
   haOpen [index][1] = haOpen [index][0];
   haHigh [index][1] = haHigh [index][0];
   haLow  [index][1] = haLow  [index][0];
   prevhatime[index] = Time[bar];
   }
   
   if(bar == Bars - 1) 
   {
   haClose[index][0] = Close[bar];
   haOpen [index][0] = Open [bar];
   haHigh [index][0] = High [bar];
   haLow  [index][0] = Low  [bar];
   }
   else
   {
   haClose[index][0] = (Open[bar] + High[bar] + Low[bar] + Close[bar])/4;
   haOpen [index][0] = (haOpen[index][1] + haClose[index][1])/2;
   haHigh [index][0] = MathMax(High[bar],MathMax(haOpen[index][0],haClose[index][0]));
   haLow  [index][0] = MathMin(Low [bar],MathMin(haOpen[index][0],haClose[index][0]));
   }
   
   switch(iprice)
   {
   case  0: return(haClose[index][0]); break;
   case  1: return(haOpen [index][0]); break;
   case  2: return(haHigh [index][0]); break;
   case  3: return(haLow  [index][0]); break;
   case  4: return((haHigh[index][0] + haLow[index][0])/2); break;
   case  5: return((haHigh[index][0] + haLow[index][0] +   haClose[index][0])/3); break;
   case  6: return((haHigh[index][0] + haLow[index][0] + 2*haClose[index][0])/4); break;
   default: return(haClose[index][0]); break;
   }
}     


string tf(int itimeframe)
{
   string result = "";
   
   switch(itimeframe)
   {
   case PERIOD_M1:   result = "M1" ;
   case PERIOD_M5:   result = "M5" ;
   case PERIOD_M15:  result = "M15";
   case PERIOD_M30:  result = "M30";
   case PERIOD_H1:   result = "H1" ;
   case PERIOD_H4:   result = "H4" ;
   case PERIOD_D1:   result = "D1" ;
   case PERIOD_W1:   result = "W1" ;
   case PERIOD_MN1:  result = "MN1";
   default:          result = "N/A";
   }
   
   if(result == "N/A")
   {
   if(itimeframe <  PERIOD_H1 ) result = "M"  + (string)itimeframe;
   if(itimeframe >= PERIOD_H1 ) result = "H"  + (string)(itimeframe/PERIOD_H1);
   if(itimeframe >= PERIOD_D1 ) result = "D"  + (string)(itimeframe/PERIOD_D1);
   if(itimeframe >= PERIOD_W1 ) result = "W"  + (string)(itimeframe/PERIOD_W1);
   if(itimeframe >= PERIOD_MN1) result = "MN" + (string)(itimeframe/PERIOD_MN1);
   }
   
   return(result); 
}                  

datetime prevnbtime;

bool isNewBar(int tf)
{
   bool result = false;
   
   if(tf >= 0)
   {
      if(iTime(NULL,tf,0) != prevnbtime)
      {
      result     = true;
      prevnbtime = iTime(NULL,tf,0);
      }   
   }
   else result = true;
   
   return(result);
}

string prevmess;
 
bool BoxAlert(bool cond,string text)   
{      
   string mess = IndicatorName + "("+Symbol()+","+TF + ")" + text;
   
   if (cond && mess != prevmess)
	{
	Alert(mess);
	prevmess = mess; 
	return(true);
	} 
  
   return(false);  
}

datetime pausetime;

bool Pause(int sec)
{
   if(TimeCurrent() >= pausetime + sec) {pausetime = TimeCurrent(); return(true);}
   
   return(false);
}

datetime warningtime;

void WarningSound(bool cond,int num,int sec,string sound,datetime curtime)
{
   static int i;
   
   if(cond)
   {
   if(curtime != warningtime) i = 0; 
   if(i < num && Pause(sec)) {PlaySound(sound); warningtime = curtime; i++;}       	
   }
}

string prevemail;

bool EmailAlert(bool cond,string text1,string text2,int num)   
{      
   string subj = "New " + text1 +" Signal from " + IndicatorName + "!!!";    
   string mess = IndicatorName + "("+Symbol()+","+TF + ")" + text2;
   
   if(cond && mess != prevemail)
	{
	if(subj != "" && mess != "") for(int i=0;i<num;i++) SendMail(subj, mess);  
	prevemail = mess; 
	return(true);
	} 
  
   return(false);  
}	       	       