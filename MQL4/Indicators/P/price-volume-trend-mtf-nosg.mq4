//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                     Price Volume Trend MTF TT [PVT]                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#property copyright   "" 
#property link        "" 
#property description "Тенденция Цены и Объема [PVT] — нарастающая сумма значений Объема торгов," 
#property description "рассчитываемая с учетом изменений Цены."
#property description " "  
#property description "Расчёт  PVT:  к предыдущему значению PVT прибавляется только часть Объема," 
#property description "размер которого, определяется величиной изменения Цены относительно Цены закрытия предыдущей свечи. "  
#property description " "  
#property description "Похожий индекс — On Balance Volume [OBV]. Оба индекса хорошо скореллированны."
#property description " "  ///^^^^   ^^^   ^^^   ^^^   ^^^^"   ////   ^^^   ^^^   ^^^   ^^^   ^^^^"
#property description "" 
#property version  "2.34"
//------
#property indicator_separate_window  //chart_window
#property indicator_buffers 1
//------
#property indicator_color1  clrLime
#property indicator_width1  3
#property indicator_style1  STYLE_DOT
//**************************************************************************//
//***                   Custom indicator ENUM settings                     ***
//**************************************************************************//
enum calcPVT { MQL_Original, MQL_TimeFrame, TSLAB_RU, TradingView, Japan_OCLH };
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                 Custom indicator input parameters                    %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 
extern int                History  =  3333;  //288=D1/M5 //576=D2/M5; //864=D3/M5; //1152=D4/M5;  //1440=D5/M5;
extern ENUM_TIMEFRAMES  TimeFrame  =  PERIOD_CURRENT;

extern calcPVT        Calculation  =  MQL_Original;
extern int               PRPeriod  =  1;
extern int               VLPeriod  =  1;
extern ENUM_MA_METHOD      Method  =  MODE_LWMA;
extern ENUM_APPLIED_PRICE   Price  =  PRICE_CLOSE;

extern int               SQPeriod  =  9;  //32;  
extern ENUM_MA_METHOD    SQMethod  =  MODE_LWMA;  
extern ENUM_APPLIED_PRICE SQPrice  =  PRICE_CLOSE;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                     Custom indicator buffers                         %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
double PVT[], PRICE[], VOLUM[], tmpPR[], tmpVL[];   int MAX;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%              Custom indicator initialization function                %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int init()
{
   TimeFrame = fmax(TimeFrame,_Period);   
   PRPeriod = fmax(PRPeriod,1);     
   VLPeriod = fmax(VLPeriod,1);     
   MAX = fmax(PRPeriod,VLPeriod);     
//------   
//------   
  	IndicatorBuffers(5);   IndicatorDigits(1);  //Digits);   if (Digits==3 || Digits==5) IndicatorDigits(Digits-1);
//------ 2 распределенных буфера индикатора 
   SetIndexBuffer(0,PVT);      SetIndexLabel(0,stringMTF(TimeFrame)+":  PVT  ["+(string)PRPeriod+"+"+(string)VLPeriod+">"+(string)SQPeriod+"]");
//------ 4 дополнительных буфера индикатора, используются для подсчета   
   SetIndexBuffer(1,PRICE);    
   SetIndexBuffer(2,VOLUM);    
   //---
   SetIndexBuffer(3,tmpPR);  
   SetIndexBuffer(4,tmpVL);  
   //---
   for (int i=0; i<=4; i++) {
        SetIndexStyle(i,DRAW_LINE);                           //--- настройка параметров отрисовки
        //SetIndexEmptyValue(i,0.0);                          //--- значение 0 отображаться не будет 
        //SetIndexShift(11,SlowShift);                        //--- установка сдвига линий при отрисовке  
        if (History>MAX)  SetIndexDrawBegin(i,Bars-History);  //--- пропуск отрисовки первых баров
        if (History<=MAX) SetIndexDrawBegin(i,MAX*1); }       //--- пропуск отрисовки первых баров   

//------ "короткое имя" для DataWindow и подокна индикатора + и/или "уникальное имя индикатора"
   IndicatorShortName(stringMTF(TimeFrame)+": PVT MTF TT ["+(string)PRPeriod+"+"+(string)VLPeriod+">"+(string)SQPeriod+"]");      
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//------
return(0);
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%              Custom indicator deinitialization function              &&&
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int deinit()  { Comment("");  return(0); }
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                 Custom indicator iteration function                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
int start()
{
   int CountedBars=IndicatorCounted();   
   if (CountedBars<0) return(-1);       //Стандарт+Tankk-Вариант!!!
   if (CountedBars>0) CountedBars--;
   int limit=fmin(Bars-CountedBars,Bars-1);  //+MAX*10*TFK
   if (History>MAX) limit=fmin(History,Bars-1);  //Comment(limit);
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                     Price Volume Trend MTF TT [PVT]                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   for (int i=limit+MAX; i>=0; i--)  
    { 
     int y = iBarShift(NULL,TimeFrame,Time[i],false);
     //---
     tmpPR[i] = (Calculation!=Japan_OCLH)  ?  iMA(NULL,TimeFrame,PRPeriod,0,Method,Price,y)  :  ( iMA(NULL,TimeFrame,PRPeriod,0,Method,0,y) + iMA(NULL,TimeFrame,PRPeriod,0,Method,1,y)
                                                                                                   + iMA(NULL,TimeFrame,PRPeriod,0,Method,2,y) + iMA(NULL,TimeFrame,PRPeriod,0,Method,3,y) ) /4;
     //---
     if (SQPeriod>1)
      {
       if (i==Bars-1) { PRICE[i]=tmpPR[i]; continue; }
       double v1 = MathPow(iStdDev(NULL,TimeFrame,SQPeriod,0,SQMethod,SQPrice,y),2);
       double v2 = MathPow(PRICE[i+1]-tmpPR[i],2);
       double k  = 0;
       if (v2 < v1 || v2==0) k=0;   else k = 1-v1/v2;
       PRICE[i] = PRICE[i+1] + k*(tmpPR[i]-PRICE[i+1]);
      }
     //---
     else PRICE[i] = tmpPR[i];
     //---
     //---
     tmpVL[i] = iVolume(NULL,TimeFrame,y);
     //---
     double volum=0;
     for (int v=i; v<=i+VLPeriod; v++) volum += tmpVL[v];
     VOLUM[i] = volum/VLPeriod;
    }   
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                     Price Volume Trend MTF TT [PVT]                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   for (i=limit; i>=0; i--)  ////enum calcPVT { MQL_Original, MQL_TimeFrame, TSLAB_RU, TradingView, Japan_OCLH };
    { 
     if (Calculation==MQL_Original)
     PVT[i] = (i==Bars-1 || i==History-1) ? VOLUM[i] : PVT[i+1] + VOLUM[i] * (PRICE[i] - PRICE[i+1]) / PRICE[i+1];   ////с сайта MQL Code Base....  ExtPVTBuffer[i] = ExtPVTBuffer[i+1] + Volume[i]*(dCurrentPrice - dPreviousPrice) / dPreviousPrice;  
     //---
     if (Calculation==MQL_TimeFrame)
     PVT[i] = (i==Bars-1 || i==History-1) ? VOLUM[i]/TimeFrame : (PVT[i+1] + VOLUM[i] * (PRICE[i] - PRICE[i+1]) / PRICE[i+1]) /TimeFrame;   ////с поправкой на "период графика".... 
     //---
     if (Calculation==TSLAB_RU)
     PVT[i] = (i==Bars-1 || i==History-1) ? 1 : (PRICE[i] - PRICE[i+1]) / PRICE[i+1] * VOLUM[i];    ///i == 1 ? 1 :(C-C[i-1])/(C[i-1]*V)  ///формула с сайта http://forum.tslab.ru/ubb/ubbthreads.php?ubb=showflat&Number=3852&page=8 ///
     //---
     if (Calculation==TradingView)
     PVT[i] = (i==Bars-1 || i==History-1) ? 1 : (((PRICE[i] - PRICE[i+1]) / PRICE[i+1]) * VOLUM[i]) + PVT[i+1];    ///PVT = [((CurrentClose - PreviousClose) / PreviousClose) x Volume] + PreviousPVT   ///с сайта https://www.tradingview.com/wiki/static/index.php?title=Price_Volume_Trend_(PVT)&oldid=3124
     //---
     if (Calculation==Japan_OCLH)
     PVT[i] = (i==Bars-1 || i==History-1) ? 1 : PVT[i+1] + (PRICE[i] - PRICE[i+1]) / PRICE[i+1] * VOLUM[i];  ///tvp=tvp[1]+(mpc-mpc[1])/mpc[1]*volume   //с "японского" сайта  http://xstrader.net/修正式價量指標vptvolume-price-trend/
    }  
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//------
return(0);
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                     Price Volume Trend MTF TT [PVT]                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
string stringMTF(int perMTF)
{  
   if (perMTF==0)      perMTF=_Period;
   if (perMTF==1)      return("M1");
   if (perMTF==5)      return("M5");
   if (perMTF==15)     return("M15");
   if (perMTF==30)     return("M30");
   if (perMTF==60)     return("H1");
   if (perMTF==240)    return("H4");
   if (perMTF==1440)   return("D1");
   if (perMTF==10080)  return("W1");
   if (perMTF==43200)  return("MN1");
   if (perMTF== 2 || 3  || 4  || 6  || 7  || 8  || 9 ||       /// нестандартные периоды для грфиков Renko
               10 || 11 || 12 || 13 || 14 || 16 || 17 || 18)  return("M"+(string)_Period);
//------
   return("Ошибка периода");
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                     Price Volume Trend MTF TT [PVT]                  %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%