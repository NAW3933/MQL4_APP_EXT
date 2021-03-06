//**************************************************************************//
//***                       Ultimate SSL 4C MTF TT                         ***
//**************************************************************************//
#property copyright   "" 
#property link        "" 
#property description "Ultimate MA создана на основе Ultimate Oscillator [1985, Л.Вильямс]." 
#property description "В основе алгоритма 3 МА с разными периодами [временными циклами],"
#property description "и с дополнительными коэффициентами весомости каждой МА   [fast*4,  midd*2,  slow*1]."
#property description " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * "
#property description "Почта:  tualatine@mail.ru" 
#property version  "4.44"
//#property strict
#property indicator_chart_window
#property indicator_buffers 5
//------
#property indicator_color1  clrSlateBlue  //clrLime  //LightSteelBlue  //
#property indicator_color2  clrBrown  //FireBrick  //clrRed  //Magenta  //
#property indicator_color3  clrDeepSkyBlue  //clrLime  //LightSteelBlue  //
#property indicator_color4  clrDarkOrange  //clrRed  //Magenta  //
#property indicator_color5  clrLimeGreen  //clrCornflowerBlue  //LightCyan  //Dark  //Red
//------
//#property indicator_width1 3
//#property indicator_width2 3
#property indicator_width5  0
//------
#property indicator_style1  STYLE_DASH
#property indicator_style2  STYLE_DASH
#property indicator_style3  STYLE_DASH
#property indicator_style4  STYLE_DASH
#property indicator_style5  STYLE_DOT
//**************************************************************************//
//***                   Custom indicator ENUM settings                     ***
//**************************************************************************//
enum calcCHL { UltimateOFF, Standart, LowHigh, bySTD, byATR, likeSSL };
enum showCOR { LINEc2, ARROWc2, LINEc4, ARROWc4 };
//**************************************************************************//
//***                Custom indicator input parameters                     *** 
//**************************************************************************//

extern int               History  =  1888;  //2864;
extern ENUM_TIMEFRAMES TimeFrame  =  PERIOD_CURRENT;
extern bool          Interpolate  =  false;  //true;
extern int                  Fast  =  15; //5;      // Fast Period
extern int                  Midd  =  37;  //34;    // Middle Period
extern int                  Slow  =  67;  //55;    // Slow Period
extern int                 fastK  =  4;            // Fast Multiplier
extern int                 middK  =  2;            // Middle Multiplier
extern int                 slowK  =  1;            // Slow Multiplier
extern ENUM_MA_METHOD    UMAMode  =  MODE_LWMA;    // Method
extern int              UMAShift  =  0;

extern bool              ShowUMA  =  true;
extern calcCHL         CalcCoral  =  bySTD;  //likeSSL;
extern int             DeltaPips  =  0;
extern double         KoefSpread  =  45.0;  //5.0;
extern showCOR         ShowCoral  =  ARROWc4;  //LINE;  //
extern int              ArrCodUP  =  119,  //167,  //233,  //147,  116, 117, 234,   //226
                        ArrCodDN  =  119,  //167,  //234,   //181,  233,   //225
                         ArrSize  =  0;  //3;

extern string          SoundFile  =  "alert2.wav";  //"expert.wav";   //"stops.wav"   //"alert2.wav"   //"news.wav"
extern int             SIGNALBAR  =  0;
extern bool        AlertsMessage  =  true,   //false,    
                     AlertsSound  =  true,   //false,
                     AlertsEmail  =  false,
                    AlertsMobile  =  false;

//**************************************************************************//
//***                     Custom indicator buffers                         ***         
//**************************************************************************//
#define CallMTF(BUFF,idx)  iCustom(NULL,TimeFrame,IndikName,History,PERIOD_CURRENT,Interpolate,Fast,Midd,Slow,fastK,middK,slowK,UMAMode,UMAShift, ShowUMA,CalcCoral,DeltaPips,KoefSpread,ShowCoral,ArrCodUP,ArrCodDN,ArrSize, SoundFile,SIGNALBAR,AlertsMessage,AlertsSound,AlertsEmail,AlertsMobile, BUFF, idx)
//------
double prLO[], prHI[], T3UP[], T3DN[], T3ARRAY[];  
double LOWT3[], HIGHT3[], FLAG[], pOCLH[], pLOW[], pHIGH[]; 
string IndikName;  double DLT, SPR;   int MAX, mns, SGB; 
string messageUP, messageDN;  datetime TimeBar=0;
//**************************************************************************//
//***               Custom indicator initialization function               ***
//**************************************************************************//
int init()
{
   TimeFrame = fmax(TimeFrame,_Period); 
   Fast = fmax(Fast,1);   
   Midd = fmax(Midd,1);   
   Slow = fmax(Slow,1); 
   //------
   MAX = fmax(Fast,fmax(Midd,Slow));
   DLT = (Digits==2 || Digits==4) ? DeltaPips*_Point : DeltaPips*_Point*10;
   SGB = SIGNALBAR;
//------
//------
   IndicatorBuffers(11);   IndicatorDigits(Digits);  if (Digits==3 || Digits==5) IndicatorDigits(Digits-1);
//------ 3 распределенных буфера индикатора 
   SetIndexBuffer(0,prLO);
   SetIndexBuffer(1,prHI);
   SetIndexBuffer(2,T3UP);
   SetIndexBuffer(3,T3DN);
   SetIndexBuffer(4,T3ARRAY);
   SetIndexBuffer(5,LOWT3);
   SetIndexBuffer(6,HIGHT3);
   SetIndexBuffer(7,FLAG);
   SetIndexBuffer(8,pOCLH);
   SetIndexBuffer(9,pLOW);
   SetIndexBuffer(10,pHIGH);
//------ настройка параметров отрисовки 
   int ARR=DRAW_LINE;   if (ShowCoral==1 || ShowCoral==3) ARR=DRAW_ARROW; 
   SetIndexStyle(0,ARR,EMPTY,ArrSize);   SetIndexArrow(0,ArrCodUP);  
  	SetIndexStyle(1,ARR,EMPTY,ArrSize);   SetIndexArrow(1,ArrCodDN);   	
   SetIndexStyle(2,ARR,EMPTY,ArrSize);   SetIndexArrow(2,ArrCodUP);  
  	SetIndexStyle(3,ARR,EMPTY,ArrSize);   SetIndexArrow(3,ArrCodDN);   	
   int T3L=DRAW_NONE;   if (ShowUMA) T3L=DRAW_LINE;   
  	SetIndexStyle(4,T3L);     
//------

   for (int i=0; i<=11; i++) {
        SetIndexShift(i,UMAShift);  //--- установка сдвига линий при отрисовке
        SetIndexEmptyValue(i,0.0);  //--- значение 0 отображаться не будет 
        if (History > MAX)  SetIndexDrawBegin(i,Bars-History);  //--- пропуск отрисовки первых баров 
        if (History <= MAX) SetIndexDrawBegin(i,MAX); }   
    	
//------ отображение в DataWindow 
   SetIndexLabel(0,NULL);  //"TrendUP");
   SetIndexLabel(1,NULL);  //"TrendDN");
   SetIndexLabel(2,stringMTF(TimeFrame)+": UP  "+EnumToString(CalcCoral)+" ["+(string)DeltaPips+"::"+DoubleToStr(KoefSpread,2)+"]");   
   SetIndexLabel(3,stringMTF(TimeFrame)+": DN  "+EnumToString(CalcCoral)+" ["+(string)DeltaPips+"::"+DoubleToStr(KoefSpread,2)+"]");   
   SetIndexLabel(4,stringMTF(TimeFrame)+": UMA ["+(string)Fast+"+"+(string)Midd+"+"+(string)Slow+"]>["+(string)fastK+"+"+(string)middK+"+"+(string)slowK+"]");
   
//------ "короткое имя" для DataWindow и подокна индикатора + и/или "уникальное имя индикатора"
   IndikName = WindowExpertName();
   IndicatorShortName(stringMTF(TimeFrame)+": Ultimate SSL ["+(string)Fast+"+"+(string)Midd+"+"+(string)Slow+"]>["+(string)fastK+"+"+(string)middK+"+"+(string)slowK+"]");
//**************************************************************************//   
//**************************************************************************//   
//------
return(0);
}
//**************************************************************************//
//***              Custom indicator deinitialization function              ***
//**************************************************************************//
int deinit() { Comment("");  return(0); }
//**************************************************************************//
//***                 Custom indicator iteration function                  ***
//**************************************************************************//
int start()
{
   int  i, CountedBars=IndicatorCounted();   
   if (CountedBars<0) return(-1);    //Стандарт+Tankk=Вариант!!!
   if (CountedBars>0) CountedBars--;
   int limit=fmin(Bars-CountedBars,Bars-2);  //+MAX*10*TFK
   if (History>MAX) limit=fmin(History,Bars-2);  //Comment(limit);
//**************************************************************************//
//**************************************************************************//
   
   if (TimeFrame!=_Period)
    {
     limit = (int)fmax(limit,fmin(Bars-2,CallMTF(12,0)*TimeFrame/_Period));
   //------
     for (i=limit+MAX*3; i>=0; i--)
      {
       int y = iBarShift(NULL,TimeFrame,Time[i],false);
     //------
       prLO[i] = CallMTF(0,y);   prHI[i] = CallMTF(1,y);
       T3UP[i] = CallMTF(2,y);   T3DN[i] = CallMTF(3,y);
       T3ARRAY[i] = CallMTF(4,y);
       LOWT3[i]   = CallMTF(5,y);
       HIGHT3[i]  = CallMTF(6,y);    
       FLAG[i]    = CallMTF(7,y);    
     //------
       if (!Interpolate || y==iBarShift(NULL,TimeFrame,Time[i-1])) continue;
       datetime time = iTime(NULL,TimeFrame,y);
       for (int n=1; i+n<Bars && Time[i+n]>=time; n++) continue;	
       for (int k=1; k<n; k++)
        {
         if (T3UP[i+k]!=0 && FLAG[i]==888) T3UP[i+k] = T3UP[i] + (T3UP[i+n] - T3UP[i])*k/n;
         if (T3DN[i+k]!=0 && FLAG[i]==-888) T3DN[i+k] = T3DN[i] + (T3DN[i+n] - T3DN[i])*k/n;
         T3ARRAY[i+k] = T3ARRAY[i] + (T3ARRAY[i+n] - T3ARRAY[i])*k/n;
         //------
         prLO[i+k] = prLO[i] + (prLO[i+n] - prLO[i])*k/n;   if (T3UP[i+k]!=0) prLO[i+k]=T3UP[i+k];
         prHI[i+k] = prHI[i] + (prHI[i+n] - prHI[i])*k/n;   if (T3DN[i+k]!=0) prHI[i+k]=T3DN[i+k];
        }                       
//**************************************************************************//
      }  //*конец цикла* for (i=limit+T3Period*3; i>=0; i--)
//**************************************************************************//
     return(0);
    }  //*конец* if (TimeFrame!=_Period).....
//**************************************************************************//
//***                       Ultimate SSL 4C MTF TT                         ***
//**************************************************************************//
  
   for (i=limit+MAX*3; i>=0; i--)
    {
     pOCLH[i] = (2* ((Open[i]+Close[i])/2) + ((High[i]+Low[i])/2)) /3; 
     pLOW[i]  = (Open[i]+Close[i]+Low[i]*Slow) /(Slow+2);  //pLOW[i]  = ((Close[i]-Open[i])-Low[i]*Slow) /(-Slow+0); 
     pHIGH[i] = (Open[i]+Close[i]+High[i]*Slow) /(Slow+2);  //pHIGH[i] = (Open[i]-Close[i]+High[i]*Slow) /(Slow+0); 
    }
//**************************************************************************//
//**************************************************************************//

   for (i=limit; i>=0; i--)   
    {
     T3ARRAY[i] = initUMA(pOCLH,i);
     LOWT3[i]   = initUMA(pLOW,i);
     HIGHT3[i]  = initUMA(pHIGH,i);
   //------
     FLAG[i] = FLAG[i+1];    prLO[i]=0;  prHI[i]=0;   T3UP[i]=0;  T3DN[i]=0;
     if (T3ARRAY[i] > T3ARRAY[i+1]) FLAG[i] = 888;        
     if (T3ARRAY[i] < T3ARRAY[i+1]) FLAG[i] = -888;
   //------   //enum calcCHL { UltimateOFF, Standart, LowHigh, bySTD, byATR, likeSSL };
     SPR = MarketInfo(NULL,MODE_SPREAD) *KoefSpread *_Point;    //Comment(SPR);
     if (CalcCoral==bySTD) { mns = (KoefSpread>=1) ? 1 : -1;   SPR = iStdDev(NULL,0,KoefSpread*mns,0,MODE_LWMA,PRICE_WEIGHTED,i) *mns; }
     if (CalcCoral==byATR) { mns = (KoefSpread>=1) ? 1 : -1;   SPR = iATR(NULL,0,KoefSpread*mns,i) *mns; }
   //------  
     double slotLO = T3ARRAY[i];    double slotHI = T3ARRAY[i];
   //------
     if (CalcCoral==Standart || CalcCoral==bySTD || CalcCoral==byATR) {
         if (FLAG[i]==888) { T3UP[i]=T3ARRAY[i] -DLT -SPR;  if (FLAG[i+1]<0) T3UP[i+1]=T3ARRAY[i+1] -DLT -SPR;  T3DN[i]=0; }     
         if (FLAG[i]==-888) { T3DN[i]=T3ARRAY[i] +DLT +SPR;  if (FLAG[i+1]>0) T3DN[i+1]=T3ARRAY[i+1] +DLT +SPR;  T3UP[i]=0; } }
   //------
     if (CalcCoral==LowHigh) {
         slotLO = Low[i];   slotHI = High[i];
         //------
         if (FLAG[i]==888) { T3UP[i]=Low[i] -DLT -SPR;  if (FLAG[i+1]<0) T3UP[i+1]=Low[i+1] -DLT -SPR;  T3DN[i]=0; }     
         if (FLAG[i]==-888) { T3DN[i]=High[i] +DLT +SPR;  if (FLAG[i+1]>0) T3DN[i+1]=High[i+1] +DLT +SPR;  T3UP[i]=0; } }
   //------
     if (CalcCoral==likeSSL) {
         slotLO = LOWT3[i];   slotHI = HIGHT3[i];
         //------
         if (FLAG[i]==888) { T3UP[i]=LOWT3[i] -DLT -SPR;  if (FLAG[i+1]<0) T3UP[i+1]=LOWT3[i+1] -DLT -SPR;  T3DN[i]=0; }     
         if (FLAG[i]==-888) { T3DN[i]=HIGHT3[i] +DLT +SPR;  if (FLAG[i+1]>0) T3DN[i+1]=HIGHT3[i+1] +DLT +SPR;  T3UP[i]=0; } }
   //------
     if (ShowCoral==2 || ShowCoral==3) {
         prLO[i] = slotLO -DLT -SPR;   if (T3UP[i+1]!=0) prLO[i+1] = T3UP[i+1];
         prHI[i] = slotHI +DLT +SPR;   if (T3DN[i+1]!=0) prHI[i+1] = T3DN[i+1]; }
    }  //*конец цикла* for (i=limit+T3Period*3; i>=0; i--)
//**************************************************************************//
//***                       Ultimate SSL 4C MTF TT                         ***
//**************************************************************************//
   
   if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound)   
    {
     messageUP = WindowExpertName()+":  "+_Symbol+", "+stringMTF(_Period)+"  >>  Ultimate UP  >>  BUY";    //SSL Channel TT
     messageDN = WindowExpertName()+":  "+_Symbol+", "+stringMTF(_Period)+"  <<  Ultimate DN  <<  SELL";   //SSL Channel TT
   //------
     if (TimeBar!=Time[0] && (FLAG[SGB]==888 && FLAG[SGB+1]!=888)) {
         if (AlertsMessage) Alert(messageUP);
         if (AlertsEmail)   SendMail(_Symbol,messageUP);
         if (AlertsMobile)  SendNotification(messageUP);
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
         TimeBar=Time[0]; }  //return(0);
   //------
     else 
     if (TimeBar!=Time[0] && (FLAG[SGB]==-888 && FLAG[SGB+1]!=-888)) {
         if (AlertsMessage) Alert(messageDN);
         if (AlertsEmail)   SendMail(_Symbol,messageDN);
         if (AlertsMobile)  SendNotification(messageDN);
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
         TimeBar=Time[0]; }  //return(0);
    }  ///*конец* АЛЕРТОВ для всех.....    
//**************************************************************************//    
//**************************************************************************//
//------
return(0);   //*КОНЕЦ ВСЕХ РАСЧЁТОВ*
}
//**************************************************************************//
//***                       Ultimate SSL 4C MTF TT                         ***
//**************************************************************************//
//------ MA_Method=???, Ultimate MA....
double initUMA(double& price[], int i)
{
   double RawUMA, Divider;
//------
   RawUMA =   (fastK+ 3* iATR(NULL,0,Fast,i)) *iMAOnArray(price,0,Fast,0,UMAMode,i)
            + (middK+ 3* iATR(NULL,0,Midd,i)) *iMAOnArray(price,0,Midd,0,UMAMode,i)
            + (slowK+ 3* iATR(NULL,0,Slow,i)) *iMAOnArray(price,0,Slow,0,UMAMode,i);
//------
   Divider = (fastK+ 3* iATR(NULL,0,Fast,i)) + (middK+ 3* iATR(NULL,0,Midd,i)) + (slowK+ 3* iATR(NULL,0,Slow,i));
//------
return(RawUMA/Divider);
}
//**************************************************************************//
//***                       Ultimate SSL 4C MTF TT                         ***
//**************************************************************************//
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
//**************************************************************************//
//***                       Ultimate SSL 4C MTF TT                         ***
//**************************************************************************//