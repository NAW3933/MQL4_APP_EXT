//------------------------------------------------------------------
#property copyright "mladen"
#property link      "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1  clrGray
#property indicator_color2  clrRed
#property indicator_width1  2
#property indicator_style2  STYLE_DOT

//
//
//
//
//

extern ENUM_TIMEFRAMES TimeFrame = PERIOD_CURRENT;   // Time frame
extern int    SF              = 5;
extern int    kPeriod         = 13;
extern int    dPeriod         = 3;
extern int    slowing         = 3;
extern double WP              = 4.236;
extern bool   alertsOn        = false;
extern bool   alertsOnCurrent = true;
extern bool   alertsMessage   = true;
extern bool   alertsSound     = false;
extern bool   alertsNotify    = false;
extern bool   alertsEmail     = false;
extern string soundFile       = "alert2.wav";
extern bool   ShowLines       = false;
extern string linesID         = " QQE Stoch";
extern color  linesUpColor    = clrLime;
extern color  linesDnColor    = clrRed;
extern ENUM_LINE_STYLE linesStyle = STYLE_SOLID;
extern int    linesWidth      = 3;
extern bool   Interpolate     = true;             // Interpolate in multi time frame mode?


double Trend[],RsiMa[],slope[],count[];
string shortName;
string indicatorFileName;
#define _mtfCall(_buff,_ind) iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,SF,kPeriod,dPeriod,slowing,WP,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsNotify,alertsEmail,soundFile,ShowLines,linesID,linesUpColor,linesDnColor,linesStyle,linesWidth,_buff,_ind)

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int init()

{
   IndicatorBuffers(4);
   SetIndexBuffer(0,RsiMa);    SetIndexLabel(0, "QQE");
   SetIndexBuffer(1,Trend);    SetIndexLabel(1, "QQE trend");
   SetIndexBuffer(2,slope);
   SetIndexBuffer(3,count);
   
   indicatorFileName = WindowExpertName();
   TimeFrame         = fmax(TimeFrame,_Period);
   shortName = linesID+"  "+timeFrameToString(TimeFrame)+" ("+SF+","+kPeriod+","+dPeriod+","+slowing+")";
   IndicatorShortName(shortName);
return(0);
}

int deinit()
{
   string find = linesID+":";
   for (int i=ObjectsTotal()-1; i>= 0; i--)
   {
      string name = ObjectName(i); if (StringFind(name,find)==0) ObjectDelete(name);
   }
return(0); 
}

//
//
//
//
//

double emas[][3];
#define iEma 0
#define iEmm 1
#define iQqe 2

int start()
{
   int i,r,counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = fmin(Bars-counted_bars,Bars-1); count[0] = limit;
         if (TimeFrame != _Period)
         {
            limit = (int)fmax(limit,fmin(Bars-1,_mtfCall(3,0)*TimeFrame/_Period));
            for (i=limit;i>=0 && !_StopFlag; i--)
            {
                int y = iBarShift(NULL,TimeFrame,Time[i]);
                   RsiMa[i] = _mtfCall(0,y);
                   Trend[i] = _mtfCall(1,y);
                     
                   //
                   //
                   //
                   //
                   //
                     
                   if (!Interpolate || (i>0 && y==iBarShift(NULL,TimeFrame,Time[i-1]))) continue;
                     #define _interpolate(buff) buff[i+k] = buff[i]+(buff[i+n]-buff[i])*k/n
                     int n,k; datetime time = iTime(NULL,TimeFrame,y);
                     for(n = 1; (i+n)<Bars && Time[i+n] >= time; n++) continue;	
                     for(k = 1; k<n && (i+n)<Bars && (i+k)<Bars; k++)
                     {
                        _interpolate(RsiMa);
                        _interpolate(Trend);
                     }            
            }
   return(0);
   }

   //
   //
   //
   //
   //
   
   int window    = WindowFind(shortName);
   double alpha1 = 2.0/(SF+1.0);
   double alpha2 = 2.0/(kPeriod*2.0);
   if (ArrayRange(emas,0) != Bars) ArrayResize(emas,Bars); 
   for (i=limit, r=Bars-i-1; i>=0; i--,r++)
   {  
      RsiMa[i]   = RsiMa[i+1] + alpha1*(iStochastic(NULL, 0, kPeriod, dPeriod,slowing,0,0,0, i) - RsiMa[i+1]);
      emas[r][iEma] = emas[r-1][iEma] + alpha2*(MathAbs(RsiMa[i+1]-RsiMa[i]) - emas[r-1][iEma]);
      emas[r][iEmm] = emas[r-1][iEmm] + alpha2*(emas[r][iEma] - emas[r-1][iEmm]);

      //
      //
      //
      //
      //

         double rsi0 = RsiMa[i];
         double rsi1 = RsiMa[i+1];
         double dar  = emas[r  ][iEmm]*WP;
         double tr   = emas[r-1][iQqe];
         double dv   = tr;
   
            if (rsi0 < tr) { tr = rsi0 + dar; if ((rsi1 < dv) && (tr > dv)) tr = dv; }
            if (rsi0 > tr) { tr = rsi0 - dar; if ((rsi1 > dv) && (tr < dv)) tr = dv; }

         Trend[i]      = tr;
         emas[r][iQqe] = tr;
         slope[i]      = slope[i+1];
            if (RsiMa[i]>Trend[i]) slope[i] = 1;
            if (RsiMa[i]<Trend[i]) slope[i] =-1;
         
            //
            //
            //
            //
            //
     
            if (ShowLines && window > -1)
            {
             string name = linesID+":"+Time[i];
             ObjectDelete(name);
             if (slope[i]!= slope[i+1])
             {
                color theColor  = linesUpColor; if (slope[i]==-1) theColor = linesDnColor;
                   ObjectCreate(name,OBJ_VLINE,window,Time[i],0);
                      ObjectSet(name,OBJPROP_WIDTH,linesWidth);
                      ObjectSet(name,OBJPROP_STYLE,linesStyle);
                      ObjectSet(name,OBJPROP_COLOR,theColor);
              }
            }
      
      }
      
      //
      //
      //
      //
      //
      
      if (alertsOn)
      {
        if (alertsOnCurrent)
             int whichBar = 0;
        else     whichBar = 1;    
        if (slope[whichBar] != slope[whichBar+1])
        if (slope[whichBar] == 1)
              doAlert("Sloping up");
        else  doAlert("Sloping down");       
      }
return(0);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
      if (previousAlert != doWhat || previousTime != Time[0]) {
          previousAlert  = doWhat;
          previousTime   = Time[0];

          //
          //
          //
          //
          //
          
          message =  StringConcatenate(Symbol()," ",timeFrameToString(_Period)," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," QQE Stoch ",doWhat);
             if (alertsMessage) Alert(message);
             if (alertsNotify)  SendNotification(message);
             if (alertsEmail)   SendMail(StringConcatenate(Symbol()," QQE Stoch "),message);
             if (alertsSound)   PlaySound(soundFile);
      }
}   

//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}
