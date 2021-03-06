//+++======================================================================+++
//+++                TriangularMA centered.mq4   ///   mladen              +++
//+++======================================================================+++
#property copyright   "" 
#property link        "" 
#property description "" 
#property description "*****************************************************************************************************"
#property description "Алгоритм расчёта от mladen'а не тронут. Выбор основных настроек в главном окне."
#property description "Индикатор злостно перерисовывается!!!"
//#property version "5.0"
//#property strict
#property indicator_separate_window
#property indicator_buffers 3
//------
//#property indicator_color1  clrDarkSlateBlue  
//#property indicator_color2  clrDarkSlateBlue 
#property indicator_color1  clrDarkSlateBlue  //clrDimGray  //  //Gray
#property indicator_color2  clrMediumSeaGreen  //clrLime
#property indicator_color3  clrOrangeRed  //clrRed
//------
#property indicator_width1  0
#property indicator_width2  2  //3  
#property indicator_width3  2  //3
//------
#property indicator_style1  STYLE_DOT
#property indicator_style2  STYLE_DASH
#property indicator_style3  STYLE_DASH
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%                   Custom indicator ENUM settings                     %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    /// 0-9++
enum TFauto { OFF, /*switch OFF*/ TF1, /*+ 1 TimeFrame*/ TF2, /*+ 2 TimeFrame*/  TF3 /*+ 3 TimeFrame*/  };
enum LNtype { LINE, HISTO, TAPE };
enum showAR { HideArrows, aINSIDE, aCENTER, aOUTSIDE };  //enum showAR { aDoNotCALC, HideArrows, aOnCHART, aOnINDIK };  
//+++======================================================================+++
//+++                 Custom indicator input parameters                    +++
//+++======================================================================+++

extern int                History  =  1800;
extern ENUM_TIMEFRAMES  TimeFrame  =  PERIOD_CURRENT;
extern TFauto       TimeFrameAuto  =  TF1;  //OFF;  //
////extern string           TimeFrame  =  "current time frame";
extern int         FastHalfLength  =  3;  //24;   //50;
extern int         SlowHalfLength  =  12;  //96;   //100;
extern ENUM_APPLIED_PRICE   Price  =  PRICE_CLOSE;
extern LNtype             Display  =  HISTO;  //TAPE;
////extern color              TrendUP  =  clrMediumSeaGreen,
////                          TrendDN  =  clrOrangeRed,
////                         ZeroLine  =  clrDimGray;
////extern int              TrendSize  =  2,
////                          ZRLSize  =  0;
////extern ENUM_LINE_STYLE TrendStyle  =  STYLE_SOLID,            
////                         ZRLStyle  =  STYLE_SOLID;
extern double      HotLevel  =  0.075;
//extern bool      ShowLevels  =  true;
extern color          LevelColor  =  C'80,60,210';  //C'0,75,0';
/*extern*/ ENUM_LINE_STYLE LevelStyle =  STYLE_DOT;
/*extern*/ int             LevelSize  =  0;

extern showAR     ShowArrows  =  aOUTSIDE;  
extern int        ARROWBAR  =  0; 
extern string  ArrowsIdentifier  =  "";  ///"TMA Index True x15 TT——>";
extern color         ArrUP  =  clrWhite, //clrLime,   //LightCyan,   //Lavender,    //FireBrick,       //Red,
                     ArrDN  =  clrRed;    //Magenta;   //DarkGreen;       //Lime
extern int          ArrGap  =  3;            //Дистанция от High/Low свечи (4-значные пипсы)     
extern int           CodUP  =  233,   //225
                     CodDN  =  234,   //226
                   ArrSize  =  1; 
////extern bool           Interpolate  =  false; 

extern bool AlertsHotLevel  =  true;
extern bool AlertsTMAColor  =  true;
extern int              SIGNALBAR  =  1;   //На каком баре сигналить....
extern bool         AlertsMessage  =  true,   //false,    
                      AlertsSound  =  true,   //false,
                      AlertsEmail  =  false,
                     AlertsMobile  =  false;
extern string           SoundFile  =  "expert.wav";  //"news.wav";  //   //"stops.wav"   //"alert2.wav"   //

//+++======================================================================+++
//+++                     Custom indicator buffers                         +++
//+++======================================================================+++
double ZERO[], /*LEVUP[], LEVDN[],*/ Uptrend[], Dntrend[], trend[];   double temp0, temp1;
double MAINBUFF[], FAST[], SLOW[], pricesArray[]; //,  FAST[], SLOW[], trend[];
//------
string IndikName;  datetime TimeBar=0;  int MTF;  string PREF, sufix;
////bool   calculateValue, returnBars;
////int    timeFrame;
//+++======================================================================+++
//+++              Custom indicator initialization function                +++
//+++======================================================================+++
int init()
{
   FastHalfLength=MathMax(FastHalfLength,1);
   SlowHalfLength=MathMax(SlowHalfLength,1);
   if (FastHalfLength==SlowHalfLength) SlowHalfLength+=1;
//------
   
   if (TimeFrame>_Period) MTF = TimeFrame;  /// <<== это одно и тоже ==>> ///if (MTF1<_Period)  MTF1 = PERIOD_CURRENT;
   else 
    {
     switch(TimeFrameAuto) 
      {
       case 1: MTF=NextHigherTF(_Period);  break;
       case 2: MTF=NextHigherTF(NextHigherTF(_Period));  break;
       case 3: MTF=NextHigherTF(NextHigherTF(NextHigherTF(_Period)));  break;
       default:  MTF=_Period;  break;
      }
    }
//+++======================================================================+++
//+++======================================================================+++

   IndicatorBuffers(6);  
    
   SetIndexBuffer(0,ZERO);
      ////SetIndexBuffer(1,LEVUP);
      ////SetIndexBuffer(2,LEVDN);
      int ZRLT = DRAW_NONE;   if (LevelColor!=clrNONE /*ShowLevels==true*/ && Display!=2) ZRLT = DRAW_LINE;    
      SetIndexStyle(0,ZRLT);  ////,ZRLStyle,ZRLSize,ZeroLine);
      ////SetIndexStyle(1,ZRLT);
      ////SetIndexStyle(2,ZRLT);
//------ настройка параметров отрисовки уровней
   //SetLevelValue(1,0);
   SetLevelValue(0,HotLevel);   SetLevelValue(1,-HotLevel);
   //SetLevelValue(4,LevelHard);   SetLevelValue(5,-LevelHard);
   SetLevelStyle(LevelStyle,LevelSize,LevelColor); 

   SetIndexBuffer(1,Uptrend);   SetIndexDrawBegin(1,SlowHalfLength);
   SetIndexBuffer(2,Dntrend);   SetIndexDrawBegin(2,SlowHalfLength);
   
      int LNT = DRAW_LINE;   if (Display==HISTO || Display==TAPE) LNT = DRAW_HISTOGRAM;    
      SetIndexStyle(1,LNT);  ////,TrendStyle,TrendSize,TrendUP);
      SetIndexStyle(2,LNT);  ////,TrendStyle,TrendSize,TrendDN);
      
//------ отображение в DataWindow    
      SetIndexLabel(0,"TMA ZERO ["+(string)FastHalfLength+"-"+(string)SlowHalfLength+"]"); 
      SetIndexLabel(1,timeFrameToString(MTF)+": TMA MACD UP");
      SetIndexLabel(2,timeFrameToString(MTF)+": TMA MACD DN");
         
//------ значение 0 отображаться не будет 
  	//SetIndexEmptyValue(1,0.0);
   //SetIndexEmptyValue(2,0.0);

   SetIndexBuffer(3,MAINBUFF);   
   //SetIndexBuffer(4,FAST);   
   //SetIndexBuffer(5,SLOW);   
   //ArraySetAsSeries(MAINBUFF,true); 
         
   SetIndexBuffer(4,pricesArray);
   //SetIndexBuffer(4,FAST);
   //SetIndexBuffer(5,SLOW);
   SetIndexBuffer(5,trend);
   
   IndikName = WindowExpertName();
   ////calculateValue    = (TimeFrame=="CalculateValue"); if (calculateValue) return(0);
   ////returnBars        = (TimeFrame=="returnBars");     if (returnBars)     return(0);
   ////timeFrame         = stringToTimeFrame(TimeFrame);
   
   IndicatorShortName(timeFrameToString(MTF)+": TMA MACD v6 HAL TT ["+(string)FastHalfLength+"-"+(string)SlowHalfLength+"]"); 
//-------   
   if (ArrowsIdentifier!="") PREF = ArrowsIdentifier;
   else PREF = timeFrameToString(MTF)+": TMA MACD ["+(string)FastHalfLength+"-"+(string)SlowHalfLength+"]_";  //// "уникальное Имя" для Стрелок, чтоб НЕ забивали друг друга....
  
//---//---//---//---
return(0);
}
//+++======================================================================+++
//+++              Custom indicator deinitialization function              +++
//+++======================================================================+++
///void OnDeinit(const int reason)  { ObjectsDeleteAll(0,PREF,-1,-1); }     
int deinit() { ALL_OBJ_DELETE();  Comment("");  return (0); }  
//**************************************************************************//
void ALL_OBJ_DELETE()
{
   string name;
   for (int s=ObjectsTotal()-1; s>=0; s--) {
        name=ObjectName(s);
        if (StringSubstr(name,0,StringLen(PREF))==PREF) ObjectDelete(name); }
}
//+++======================================================================+++
//+++                 Custom indicator iteration function                  +++
//+++======================================================================+++
int start()
{
   int i, y, limit;
   int CountedBars=IndicatorCounted();
   if (CountedBars<0) return(-1);
   if (CountedBars>0) CountedBars--;
   limit=History;
   if (History<=SlowHalfLength) {
       limit=MathMin(Bars-CountedBars,Bars-1);      
       limit=MathMax(limit,FastHalfLength);
       limit=MathMax(limit,SlowHalfLength); }
   ////if (returnBars) { ZERO[0] = limit+1; return(0); }
//+++======================================================================+++
//+++======================================================================+++

  //if (MTF==_Period) //// || calculateValue)
  // {
    ////ArrayResize(trend,Bars); 
    ////ArraySetAsSeries(trend,true); 
//+++======================================================================+++

    for (i=limit+SlowHalfLength; i>=0; i--) pricesArray[i] = iMA(NULL,MTF,1,0,MODE_SMA,Price,i); 
   
    for (i=limit; i>=0; i--)
     { 
      y = iBarShift(NULL,MTF,Time[i],false);
      ////FAST[i] = calculateTma(pricesArray,FastHalfLength,y);
      ////SLOW[i] = calculateTma(pricesArray,SlowHalfLength,y);
      MAINBUFF[i] = calculateTma(pricesArray,FastHalfLength,y) - calculateTma(pricesArray,SlowHalfLength,y);   ////FAST[i] - SLOW[i];    ///
      ZERO[i] = 0;   //LEVUP[i] = HotLevel;   LEVDN[i] = -HotLevel;
//+++======================================================================+++
      trend[i]=0;   Uptrend[i]=EMPTY_VALUE;  Dntrend[i]=EMPTY_VALUE;
      //---
      temp0 = (Display!=2) ? EMPTY_VALUE : 0;  
      temp1 = (Display!=2) ? MAINBUFF[i] : 100;  
      //---
      ////if (MAINBUFF[i] > MAINBUFF[i+1])  { Uptrend[i] = temp1;  Dntrend[i]=temp0; }  //else Uptrend[i]=EMPTY_VALUE;
      ////if (MAINBUFF[i] < MAINBUFF[i+1])  { Dntrend[i] = temp1;  Uptrend[i]=temp0; }  //else Dntrend[i]=EMPTY_VALUE;
//+++======================================================================+++
       trend[i] = trend[i+1];  //Uptrend[i]=0;  Dntrend[i]=0;  ////Uptrend[i+1]=0;  Dntrend[i+1]=0;
       
       if (MAINBUFF[i] > MAINBUFF[i+1])  trend[i] = 1;
       if (MAINBUFF[i] < MAINBUFF[i+1])  trend[i] =-1;
     
       if (trend[i]>0)
        {  
         Uptrend[i] = temp1; 
         if (trend[i+1] < 0)  Uptrend[i+1] = MAINBUFF[i+1];
         Dntrend[i] = temp0;
        }
        
       else if (trend[i] < 0)
        { 
         Dntrend[i] = temp1; 
         if (trend[i+1]>0)  Dntrend[i+1] = MAINBUFF[i+1];
         Uptrend[i] = temp0;
        }   
//+++======================================================================+++
//+++======================================================================+++
      
      if (MAINBUFF[i+ARROWBAR] > -HotLevel && MAINBUFF[i+1+ARROWBAR] <= -HotLevel) {
          if (AlertsHotLevel) trend[i]=444;
          if (ShowArrows!=0 && ArrUP!=clrNONE) DrawARROW(false,"BUY",i); }
      
      if (MAINBUFF[i+ARROWBAR] < HotLevel && MAINBUFF[i+1+ARROWBAR] >= HotLevel) { 
          if (AlertsHotLevel) trend[i]=-444;
          if (ShowArrows!=0 && ArrUP!=clrNONE) DrawARROW(true,"SELL",i); }
//+++======================================================================+++
//+++======================================================================+++
      
      if (AlertsTMAColor) {
        if (MAINBUFF[i] > MAINBUFF[i+1] && MAINBUFF[i+1] <= MAINBUFF[i+2])  trend[i]=888;
        if (MAINBUFF[i] < MAINBUFF[i+1] && MAINBUFF[i+1] >= MAINBUFF[i+2])  trend[i]=-888; }
//+++======================================================================+++
     }  //*конец* цикла
//+++======================================================================+++
//+++======================================================================+++

   if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound) 
    {
     if (trend[SIGNALBAR]==444)  sufix = "TMA cross -"+DoubleToStr(HotLevel,1) + " UP  >>  BUY";
     if (trend[SIGNALBAR]==-444)  sufix = "TMA cross +"+DoubleToStr(HotLevel,1) + " DOWN  <<  SELL";
   //------
     if (trend[SIGNALBAR]==888)  sufix = "TMA  changed  Color  >>  BUY"; 
     if (trend[SIGNALBAR]==-888)  sufix = "TMA  changed  Color  <<  SELL";
   //------  ///WindowExpertName()+
     string messageUP = "TMA MACD v6 HAL >> "+_Symbol+", "+timeFrameToString(_Period)+"  >>  " +sufix;  //TMA UP  >>  BUY");   //BearsBulls Alerts MTF TT
     string messageDN = "TMA MACD v6 HAL << "+_Symbol+", "+timeFrameToString(_Period)+"  <<  " +sufix;  //TMA DN  <<  SELL");   //BearsBulls Alerts MTF TT
   //------
     if (TimeBar!=Time[0] && (trend[SIGNALBAR]==444 || trend[SIGNALBAR]==888)) { ////(Uptrend[SIGNALBAR]!=EMPTY_VALUE || Uptrend[SIGNALBAR]!=0) &&
                             ////(Uptrend[SIGNALBAR+1]==EMPTY_VALUE || Uptrend[SIGNALBAR+1]==0)) {
         if (AlertsMessage) Alert(messageUP);
         if (AlertsEmail)   SendMail(_Symbol,messageUP);
         if (AlertsMobile)  SendNotification(messageUP);
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
         TimeBar=Time[0]; }  //return(0);
   //------
     else 
     if (TimeBar!=Time[0] && (trend[SIGNALBAR]==-444 || trend[SIGNALBAR]==-888)) { ////(Dntrend[SIGNALBAR]!=EMPTY_VALUE || Dntrend[SIGNALBAR]!=0) &&
                             ////(Dntrend[SIGNALBAR+1]==EMPTY_VALUE || Dntrend[SIGNALBAR+1]==0)) {
         if (AlertsMessage) Alert(messageDN);
         if (AlertsEmail)   SendMail(_Symbol,messageDN);
         if (AlertsMobile)  SendNotification(messageDN);
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"
         TimeBar=Time[0]; }  //return(0);
    }  ///*конец* АЛЕРТОВ для всех.....         
//+++======================================================================+++
//+++======================================================================+++
//---//---
    return(0);
   }
//+++======================================================================+++
//+++                TriangularMA centered.mq4   ///   mladen              +++
//+++======================================================================+++
        
   ////limit = MathMax(limit,TimeFrame/_Period);
   ////limit = MathMax(limit,MathMin(Bars,iCustom(NULL,timeFrame,IndikName,"returnBars",0,0)*timeFrame/_Period));
////   limit = MathMax(limit,MathMin(Bars,iCustom(NULL,MTF,IndikName,History,0,TimeFrameAuto,0,0)*MTF/_Period));
////   ////if (trend[limit]== 1) CleanPoint(limit,Uptrend);
////   ////if (trend[limit]==-1) CleanPoint(limit,Dntrend);
////   
////   for (i=limit; i>=0; i--) 
////    {
////     int y = iBarShift(NULL,MTF,Time[i],false);
////      
////       ZERO[i]  = iCustom(NULL,MTF,IndikName,History,0,TimeFrameAuto,FastHalfLength,SlowHalfLength,Price,Display,/*TrendUP,TrendDN,ZeroLine,TrendSize,ZRLSize,TrendStyle,ZRLStyle,*/ShowLevels,Interpolate,SIGNALBAR,AlertsMessage,AlertsSound,AlertsEmail,AlertsMobile,SoundFile,0,y);
////     Uptrend[i]  = iCustom(NULL,MTF,IndikName,History,0,TimeFrameAuto,FastHalfLength,SlowHalfLength,Price,Display,/*TrendUP,TrendDN,ZeroLine,TrendSize,ZRLSize,TrendStyle,ZRLStyle,*/ShowLevels,Interpolate,SIGNALBAR,AlertsMessage,AlertsSound,AlertsEmail,AlertsMobile,SoundFile,1,y);
////      Dntrend[i]  = iCustom(NULL,MTF,IndikName,History,0,TimeFrameAuto,FastHalfLength,SlowHalfLength,Price,Display,/*TrendUP,TrendDN,ZeroLine,TrendSize,ZRLSize,TrendStyle,ZRLStyle,*/ShowLevels,Interpolate,SIGNALBAR,AlertsMessage,AlertsSound,AlertsEmail,AlertsMobile,SoundFile,2,y);
////        MAINBUFF[i] = iCustom(NULL,MTF,IndikName,History,0,TimeFrameAuto,FastHalfLength,SlowHalfLength,Price,Display,/*TrendUP,TrendDN,ZeroLine,TrendSize,ZRLSize,TrendStyle,ZRLStyle,*/ShowLevels,Interpolate,SIGNALBAR,AlertsMessage,AlertsSound,AlertsEmail,AlertsMobile,SoundFile,3,y);
////      //pricesArray[i] = iCustom(NULL,TimeFrame,IndikName,History,TimeFrame,FastHalfLength,SlowHalfLength,Price,Display,TrendUP,TrendDN,ZeroLine,TrendSize,ZRLSize,TrendStyle,ZRLStyle,ShowLevels,Interpolate,4,y);
////         ////trend[i]    = iCustom(NULL,timeFrame,IndikName,History,"CalculateValue",FastHalfLength,SlowHalfLength,Price,Display,TrendUP,TrendDN,ZeroLine,TrendSize,ZRLSize,TrendStyle,ZRLStyle,ShowLevels,Interpolate,7,y);
////     //+++======================================================================+++
////         
////     if (!Interpolate || y==iBarShift(NULL,MTF,Time[i-1])) continue;
////       datetime time = iTime(NULL,MTF,y);
////         for (n = 1; i+n < Bars && Time[i+n] >= time; n++) continue;	
////           for(k = 1; k < n; k++)
////             MAINBUFF[i+k] = MAINBUFF[i] + (MAINBUFF[i+n]-MAINBUFF[i])*k/n;     
////    }
////  
////   ////for (i=limit; i>=0; i--)
////   //// {
////   ////  if (trend[i]== 1) PlotPoint(i,Uptrend,MAINBUFF);
////   ////  if (trend[i]==-1) PlotPoint(i,Dntrend,MAINBUFF);
////   //// }
//////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//////---//---//---//---
////return(0);   //глобальный....
////}
//+++======================================================================+++
//+++                TriangularMA centered.mq4   ///   mladen              +++
//+++======================================================================+++
double calculateTma(double& prices[], int halfLength, int i)
{
   int j, k;

   double sum  = (halfLength+1)*prices[i];
   double sumw = (halfLength+1);

   for(j=1, k=halfLength; j<=halfLength; j++, k--)
    {
      sum  += k*prices[i+j];
      sumw += k;

      if (j<=i)
       {
        sum  += k*prices[i-j];
        sumw += k;
       }
    }
//+++
return(sum/sumw);
}
//**************************************************************************//
//***                      ZZ NRP X4 SW AA LB TT [MK]                      ***
//**************************************************************************//
void DrawARROW(bool DOWN, string Name, /*int SPEED,*/ int z)  //, int ARRSIZE, int ARRCOD)  //double gap, int ARRCOD, color ARRCOLOR)
{
   //int DGTS = Digits;  if (Digits==3 || Digits==5) DGTS-=1;
   string objName = PREF+Name+"*"+(string)z;  //+"_"+TimeToStr(Time[z],TIME_MINUTES);  ///+"_"+DoubleToStr(Close[z],DGTS);
   //double Gap = 2.0*iATR(NULL,0,20,z)/4.0;
   double GAP=ArrGap*_Point;   if (Digits==3 || Digits==5) GAP*=10;
//------
   ObjectDelete(objName);
   ObjectCreate(objName,OBJ_ARROW, 0, Time[z], 0);
   //ObjectSetText(objName, TEXT, Size, "Verdana", Color);
   //ObjectSet(objName,OBJPROP_ARROWCODE, ARRCOD);
   ObjectSet(objName,OBJPROP_WIDTH, ArrSize);  //ARRSIZE);  //
   //ObjectSet(objName,OBJPROP_COLOR, ARRCOLOR);  
   ObjectSet(objName,OBJPROP_SELECTABLE, false);
   ObjectSet(objName,OBJPROP_BACK, false);
   ObjectSet(objName,OBJPROP_HIDDEN, true);  
   //ObjectSet(objName,OBJPROP_ANCHOR, ANCHOR_CENTER);  //ANCHOR_LEFT);
   //------   enum showAR { HideArrows, aINSIDE, aCENTER, aOUTSIDE };
   double HIGH=High[z]+GAP;  if (ShowArrows==2) HIGH=(High[z]+Low[z])/2;  if (ShowArrows==1) HIGH=Low[z] -GAP;
   double LOW =Low[z] -GAP;  if (ShowArrows==2) LOW =(High[z]+Low[z])/2;  if (ShowArrows==1) LOW =High[z]+GAP;
//------
   if (DOWN) {
              ObjectSetText(objName, "TMA  cross  -"+DoubleToStr(HotLevel,1)+"  DOWN  <<  SELL", 10, "Verdana", clrRed);
              ObjectSet(objName,OBJPROP_COLOR, ArrDN);  
              ObjectSet(objName,OBJPROP_ARROWCODE, CodDN);  //CodSELL);
              ObjectSet(objName,OBJPROP_PRICE1, HIGH); 
              ObjectSet(objName,OBJPROP_ANCHOR, ANCHOR_BOTTOM); }
//------
   if (!DOWN) {
               ObjectSetText(objName, "TMA  cross  +"+DoubleToStr(HotLevel,1)+"  UP  >>  BUY", 10, "Verdana", clrWhite);
               ObjectSet(objName,OBJPROP_COLOR, ArrUP);  
               ObjectSet(objName,OBJPROP_ARROWCODE, CodUP);  //CodBUY);
               ObjectSet(objName,OBJPROP_PRICE1, LOW); 
               ObjectSet(objName,OBJPROP_ANCHOR, ANCHOR_TOP); } 
}   
//+++======================================================================+++
//+++======================================================================+++
string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};
//+++======================================================================+++
int stringToTimeFrame(string tfs) 
{
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],_Period));
                                                      return(_Period);
}
//+++======================================================================+++
string timeFrameToString(int tf) 
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}
//+++======================================================================+++
string stringUpperCase(string str) 
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--) 
    {
      int charA = StringGetChar(s, length);
         if((charA > 96 && charA < 123) || (charA > 223 && charA < 256))
                     s = StringSetChar(s, length, charA - 32);
         else if(charA > -33 && charA < 0)
                     s = StringSetChar(s, length, charA + 224);
    }
//---
return(s);
}
//+++======================================================================+++
//+++                TriangularMA centered.mq4   ///   mladen              +++
//+++======================================================================+++
void CleanPoint(int i, double& first[])
{
   //if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
   //     second[i+1] = EMPTY_VALUE;
   //else
      if ((first[i] != 0) && (first[i+1] != 0) && (first[i+2] == 0))
          first[i+1] = 0;
}
//+++======================================================================+++
void PlotPoint(int i, double& first[], double& from[])
{
   if (first[i+1] == 0)
    {
     if (first[i+2] == 0) 
      {
       first[i]   = from[i];
       first[i+1] = from[i+1];
       //second[i]  = EMPTY_VALUE;
      }
     else 
      {
       //second[i]   =  from[i];
       //second[i+1] =  from[i+1];
       first[i]    = 0;
      }
    }
   
   else
    {
     first[i]  = from[i];
     //second[i] = EMPTY_VALUE;
    }
}
//+++======================================================================+++
//+++======================================================================+++
//+++                TriangularMA centered.mq4   ///   mladen              +++
//+++======================================================================+++
//-----------------------------------------------------------------------------
// function: NextHigherTF()
// Description: Select the next higher time-frame. 
//              Note: M15 and M30 both select H1 as next higher TF. 
//-----------------------------------------------------------------------------
int NextHigherTF(int iPeriod)
{
  if (iPeriod==0) iPeriod=_Period;
  //---
  switch(iPeriod) 
   {
    case PERIOD_M1: return(PERIOD_M5);
    case PERIOD_M5: return(PERIOD_M15);
    case PERIOD_M15: return(PERIOD_M30);
    case PERIOD_M30: return(PERIOD_H1);
    case PERIOD_H1: return(PERIOD_H4);
    case PERIOD_H4: return(PERIOD_D1);
    case PERIOD_D1: return(PERIOD_W1);
    case PERIOD_W1: return(PERIOD_MN1);
    case PERIOD_MN1: return(PERIOD_MN1);
    default: return(_Period);
   }
return(_Period);
}
//+++======================================================================+++
//+++                TriangularMA centered.mq4   ///   mladen              +++
//+++======================================================================+++