//+------------------------------------------------------------------+
//|                                              Stochastic tape.mq4 |
//|                                                           mladen |
//|                                           4 colors by chrisstoff |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//------
#property indicator_separate_window
#property indicator_buffers   6
//------
#property indicator_color1  clrDarkGreen  //Thistle   //Gold   //Crimson   //OrangeRed    //,     //OrangeRed,    //,    
#property indicator_color2  clrPurple  //DarkViolet   //LightSteelBlue   //OrangeRed     //LightCyan   //RoyalBlue    //Blue
#property indicator_color3  clrLavender  //RoyalBlue  //SlateBlue  //LightSteelBlue
#property indicator_color4  clrOrange  //Gold
#property indicator_color5  clrAqua  //DeepSkyBlue   //Lime  //LightSteelBlue
#property indicator_color6  clrGold  //Yellow  //Violet   //Orchid   //Red  //LightSteelBlue
//------
#property indicator_width1  0
#property indicator_width2  0
#property indicator_width3  2
#property indicator_width4  0
#property indicator_width5  0
#property indicator_width6  0
//------
#property indicator_style3  STYLE_DOT
#property indicator_style4  STYLE_DOT
////#property indicator_minimum   0
////#property indicator_maximum 100
//#property indicator_level1   0
//#property indicator_level2   20
//#property indicator_levelcolor clrDarkGreen  //DimGray
//+------------------------------------------------------------------+
//|                   Custom indicator ENUM settings                 |
//+------------------------------------------------------------------+
enum showAR { HideArrows, aINSIDE, aCENTER, aOUTSIDE };  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

extern int               History  =  1440;
extern ENUM_TIMEFRAMES TimeFrame  =  PERIOD_CURRENT;
extern int                  Fast  =  6;  //9;  //12;
extern int                  Slow  =  18;  //27;  //26;
extern int                Signal  =  12;  //18;  //9;
extern ENUM_MA_METHOD     Method  =  MODE_SMMA;  //MODE_LWMA;  //MODE_EMA;
extern ENUM_MA_METHOD  SigMethod  =  MODE_LWMA;  //MODE_SMA;
extern ENUM_APPLIED_PRICE  Price  =  PRICE_CLOSE;

extern bool         ShowZero  =  true;
extern bool        ShowLines  =  true;
extern bool        ShowCross  =  true;
extern bool         ShowTape  =  true;
extern color     TapeColorUp  =  clrLightCyan;  //;  //clrLimeGreen;
extern color    TapeColorUp2  =  clrDarkTurquoise;  //CornflowerBlue;  //MediumSeaGreen;  //clrGreen;
extern color   TapeColorDown  =  clrRed;  //Crimson;
extern color  TapeColorDown2  =  clrDarkOrange;  //OrangeRed;
extern int     TapeBarsWidth  =  4;
extern string       UniqueID  =  "MACD Tape 4C TT";  ////"TMA Index True x15 TT——>";

extern int            SIGNALBAR  =  1;
extern bool       AlertsMessage  =  true,   //false,    
                    AlertsSound  =  true,   //false,
                    AlertsEmail  =  false,
                   AlertsMobile  =  false;
extern string         SoundFile  =  "news.wav";   //"stops.wav"   //"alert2.wav"   //"expert.wav"  //"Trumpet.wav";  //

extern showAR   ShowArrows  =  aOUTSIDE;  
extern int        ARROWBAR  =  0; 
extern color         ArrUP  =  clrAqua, //clrLime,   //LightCyan,   //Lavender,    //FireBrick,       //Red,
                     ArrDN  =  clrGold;    //Magenta;   //DarkGreen;       //Lime
extern int          ArrGap  =  3;            //Дистанция от High/Low свечи (4-значные пипсы)     
extern int           CodUP  =  233,   //225
                     CodDN  =  234,   //226
                   ArrSize  =  0; 

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MACD[], SIGMA[], DIFFER[], rising[];
double ZRUP[], ZRDN[], CRSUP[], CRSDN[];
string shortName;  int MAX, SGB, ARB, Window;
string  messageUP, messageDN, sufix;  datetime TimeBar=0;   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
{
   IndicatorBuffers(8);
   SetIndexBuffer(0,ZRUP);  
   SetIndexBuffer(1,ZRDN);  
   SetIndexBuffer(2,MACD);  
   SetIndexBuffer(3,SIGMA);  
   SetIndexBuffer(4,CRSUP);  
   SetIndexBuffer(5,CRSDN);  
   SetIndexBuffer(6,DIFFER);
   SetIndexBuffer(7,rising);
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   int ZRT = (ShowZero) ? DRAW_ARROW : DRAW_NONE;   
   SetIndexStyle(0,ZRT);   SetIndexArrow(0,171);
   SetIndexStyle(1,ZRT);   SetIndexArrow(1,171);
   int LNT=DRAW_NONE;   if (ShowLines) LNT=DRAW_LINE; 
   SetIndexStyle(2,LNT);
   SetIndexStyle(3,LNT);
   int CRT = (ShowCross) ? DRAW_ARROW : DRAW_NONE;   
   SetIndexStyle(4,CRT);   SetIndexArrow(4,108);
   SetIndexStyle(5,CRT);   SetIndexArrow(5,108);
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   Fast=fmax(Fast,0);  Slow=fmax(Slow,0);   
   MAX=fmax(Fast,fmax(Slow,Signal));
   SGB=SIGNALBAR;   ARB=ARROWBAR;
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   SetIndexLabel(0,"MACD  >>  0");
   SetIndexLabel(1,"MACD  <<  0");
   SetIndexLabel(2,stringMTF(TimeFrame)+":  "+"MACD  ["+(string)Fast+"-"+(string)Slow+"]");   
   SetIndexLabel(3,stringMTF(TimeFrame)+":  "+"SigMA ["+(string)Signal+"]");   
   SetIndexLabel(4,"MACD  >>  SigMA");
   SetIndexLabel(5,"MACD  <<  SigMA");
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   if (UniqueID=="") UniqueID = stringMTF(TimeFrame)+": MACD Tape ["+(string)Fast+"-"+(string)Slow+"->"+(string)Signal+"]";
   //------
   shortName = stringMTF(TimeFrame)+": MACD Tape 4C TT ["+(string)Fast+"-"+(string)Slow+"->"+(string)Signal+"]";
   IndicatorShortName(shortName);
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit() { ObjectsDeleteAll(0,UniqueID,-1,-1);  
               DeleteTape();  return(0); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
{
   int CountedBars=IndicatorCounted();   
   if (CountedBars<0) return(-1);       //Стандарт-Вариант!!!
   if (CountedBars>0) CountedBars--;
   int limit=fmin(Bars-CountedBars,Bars-2);  //+MAX*10*TFK
   if (History>MAX) limit=fmin(History,Bars-2);  //Comment(limit);
   CheckWindow();
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   for (int i=limit+MAX*25; i>=0; i--)
    {
     int y = iBarShift(NULL,TimeFrame,Time[i]);
     MACD[i] = iMA(NULL,TimeFrame,Fast,0,Method,Price,y) - iMA(NULL,TimeFrame,Slow,0,Method,Price,y);
    }     
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   for (i=limit; i>=0; i--)
    {
     SIGMA[i] = (Signal>0) ? iMAOnArray(MACD,Bars,Signal,0,SigMethod,i) : EMPTY_VALUE;
     DIFFER[i] = MACD[i]-SIGMA[i];    
         rising[i] = rising[i+1];
         if (DIFFER[i]>DIFFER[i+1]) rising[i] = 1;
         if (DIFFER[i]<DIFFER[i+1]) rising[i] = -1;
   //------
     ZRUP[i]=EMPTY_VALUE;   ZRDN[i]=EMPTY_VALUE;
     CRSUP[i]=EMPTY_VALUE;   CRSDN[i]=EMPTY_VALUE;
   //------
     if (MACD[i] > 0) ZRUP[i]=0;   
     if (MACD[i] < 0) ZRDN[i]=0;   
   //------
     if (MACD[i] > SIGMA[i] && MACD[i+1] <= SIGMA[i+1]) CRSUP[i]=MACD[i];  
     if (MACD[i] < SIGMA[i] && MACD[i+1] >= SIGMA[i+1]) CRSDN[i]=MACD[i]; 
    } 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   for (i=0; i<indicator_buffers; i++) { 
        SetIndexDrawBegin(i,Bars-History); 
        if (limit<=MAX) SetIndexDrawBegin(i,MAX*2); }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   limit = fmin(limit,2880);    if (limit<=MAX) limit=2880;
   DeleteTape();  if (ShowTape) for (i=0; i<limit; i++) DrawTape(MACD[i],SIGMA[i],rising[i],i);
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   if (ShowArrows!=0)
    {
     for (i=limit; i>=0; i--)
      {
       ObjectDelete(UniqueID+"_CRSUP"+"*"+(string)i);
       ObjectDelete(UniqueID+"_CRSDN"+"*"+(string)i);
     //------
       if (CRSUP[i+ARB]!=EMPTY_VALUE) DrawARROW(false,"_CRSUP",i,ArrSize);
       if (CRSDN[i+ARB]!=EMPTY_VALUE) DrawARROW(true,"_CRSDN",i,ArrSize);
     //------
       ObjectDelete(UniqueID+"_ZRUP"+"*"+(string)i);
       ObjectDelete(UniqueID+"_ZRDN"+"*"+(string)i);
     //------
       if (MACD[i+ARB] > 0 && MACD[i+1+ARB] <= 0) DrawARROW(false,"_ZRUP",i,ArrSize+1);
       if (MACD[i+ARB] < 0 && MACD[i+1+ARB] >= 0) DrawARROW(true,"_ZRDN",i,ArrSize+1);
      }
    } ///*конец* if (ShowArrows!=0)
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
   if (AlertsMessage || AlertsEmail || AlertsMobile || AlertsSound) 
    {
     if ((MACD[SGB]>0 && MACD[SGB+1]<=0) || (MACD[SGB]<0 && MACD[SGB+1]>=0))  sufix="Zero";  
     if (CRSUP[SGB]!=EMPTY_VALUE || CRSDN[SGB]!=EMPTY_VALUE)                  sufix="SigMA";
   //------   ///WindowExpertName()+
     messageUP ="MACD Tape TT:  "+_Symbol+", "+stringMTF(_Period)+"  >>  MACD cross "+sufix+"  >>  BUY";    //SSL Channel TT  //HA CLH 4C SHLD TT  //MA 3x3 TT       
     messageDN ="MACD Tape TT:  "+_Symbol+", "+stringMTF(_Period)+"  <<  MACD cross "+sufix+"  <<  SELL";   //SSL Channel TT  //HA CLH 4C SHLD TT  //MA 3x3 TT
     //---
     if (TimeBar!=Time[0] && ((MACD[SGB]>0 && MACD[SGB+1]<=0) || CRSUP[SGB]!=EMPTY_VALUE)) {   
         if (AlertsMessage) Alert(messageUP);  
         if (AlertsEmail)   SendMail(_Symbol,messageUP);  
         if (AlertsMobile)  SendNotification(messageUP);  
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"   //"alert2.wav"  //"expert.wav"  
         TimeBar=Time[0]; } //return(0);
   //------
     else 
     if (TimeBar!=Time[0] && ((MACD[SGB]<0 && MACD[SGB+1]>=0) || CRSDN[SGB]!=EMPTY_VALUE)) {   
         if (AlertsMessage) Alert(messageDN);  
         if (AlertsEmail)   SendMail(_Symbol,messageDN);  
         if (AlertsMobile)  SendNotification(messageDN);  
         if (AlertsSound)   PlaySound(SoundFile);   //"stops.wav"   //"news.wav"   //"alert2.wav"  //"expert.wav"                
         TimeBar=Time[0]; } //return(0); 
    } //*конец* Алертов
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
return(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#define SignalName "+" //"MACDTape"
    int maxLines = 0;
//+------------------------------------------------------------------+
void DrawTape(double __1, double __2, double trising, int shift)
{
   if (__1==__2) return;
   //
   maxLines++;
      datetime time = Time[shift];
      string   name = StringConcatenate(UniqueID,SignalName,"-",maxLines);
 
      ObjectCreate(name,OBJ_TREND,Window,time,__1,time,__2);
         if (__1>__2)
         {  
           if (trising==1)
           {  
               ObjectSet(name,OBJPROP_COLOR ,TapeColorUp);
           } else {
               ObjectSet(name,OBJPROP_COLOR ,TapeColorUp2); 
           }
         }         
         else {
           if (trising==-1) 
           {
               ObjectSet(name,OBJPROP_COLOR ,TapeColorDown);
           } else {
               ObjectSet(name,OBJPROP_COLOR ,TapeColorDown2);
           }  
         }    
         ObjectSet(name,OBJPROP_SELECTABLE, false);
         ObjectSet(name,OBJPROP_RAY, false);
         ObjectSet(name,OBJPROP_BACK, true);
         ObjectSet(name,OBJPROP_WIDTH, TapeBarsWidth);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteTape()
{
   string name = StringConcatenate(UniqueID,SignalName);
      while(maxLines>0) { ObjectDelete(StringConcatenate(name,"-",maxLines)); maxLines--; }
                          ObjectDelete(name);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckWindow() { Window = WindowFind(shortName); }
//**************************************************************************//
//***                    ZZ NRP X4 HST SW AA LB TT [MK]                    ***
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
//***                    TMA Centered MACD v6 HAL MTF TT                   ***
//**************************************************************************//
void DrawARROW(bool DOWN, string Name, int z, int ARRSIZE)
{
   //int DGTS = Digits;  if (Digits==3 || Digits==5) DGTS-=1;
   string objName = UniqueID+Name+"*"+(string)z;  //+"_"+TimeToStr(Time[z],TIME_MINUTES);  ///+"_"+DoubleToStr(Close[z],DGTS);
   //double Gap = 2.0*iATR(NULL,0,20,z)/4.0;
   double GAP=ArrGap*_Point;   if (Digits==3 || Digits==5) GAP*=10;
//------
   ObjectDelete(objName);
   ObjectCreate(objName,OBJ_ARROW, 0, Time[z], 0);
   //ObjectSetText(objName, TEXT, Size, "Verdana", Color);
   //ObjectSet(objName,OBJPROP_ARROWCODE, ARRCOD);
   ObjectSet(objName,OBJPROP_WIDTH, ARRSIZE);  //ArrSize);  //
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
              ObjectSetText(objName, "Arrow  DOWN  <<  SELL", 10, "Verdana", clrRed);
              ObjectSet(objName,OBJPROP_COLOR, ArrDN);  
              ObjectSet(objName,OBJPROP_ARROWCODE, CodDN);  //CodSELL);
              ObjectSet(objName,OBJPROP_PRICE1, HIGH); 
              ObjectSet(objName,OBJPROP_ANCHOR, ANCHOR_BOTTOM); }
//------
   if (!DOWN) {
               ObjectSetText(objName, "Arrow  UP  >>  BUY", 10, "Verdana", clrWhite);
               ObjectSet(objName,OBJPROP_COLOR, ArrUP);  
               ObjectSet(objName,OBJPROP_ARROWCODE, CodUP);  //CodBUY);
               ObjectSet(objName,OBJPROP_PRICE1, LOW); 
               ObjectSet(objName,OBJPROP_ANCHOR, ANCHOR_TOP); } 
}   
//**************************************************************************//
//***                    TMA Centered MACD v6 HAL MTF TT                   ***
//**************************************************************************//