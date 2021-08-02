//+------------------------------------------------------------------+
//|                                       ex: Schaff Trend Cycle.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
//--  via eurisko at http://www.forexfactory.com/showpost.php?p=3875035&postcount=529
//--  post b529 20100715 _SchaffTrendCyclemtf.mq4
//--  renamed Schaffmtf.mq4             20100717           // scalpz
//--  renamed SchaffmtfAlert.mq4        20100717           // scalpz

#property copyright "mladen"
#property link      "mladenfx@gmail.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  Red
#property indicator_minimum  -5
#property indicator_maximum 105

#property indicator_level1 90
#property indicator_level2 10
#property indicator_levelstyle DRAW_LINE
#property indicator_levelcolor MediumBlue

extern string TimeFrame    = "current time frame";
extern int    STCPeriod    = 10;
extern int    FastMAPeriod = 23;
extern int    SlowMAPeriod = 50;
extern bool   Email_Alert = False;
extern bool   PopUp_Alert = False;
extern double AlertDownLevel = 10;
extern double AlertUpLevel = 90;


double stcBuffer[];
double macdBuffer[];
double fastKBuffer[];
double fastDBuffer[];
double fastKKBuffer[];

string IndicatorFileName;
string IndicatorName;
bool   calculating=false;
bool   returnBars =false;
bool   AlertDone  =false;                 // scalpz alert

int    timeFrame;

int    swEmail;


static datetime dt = 0;

//+------------------------------------------------------------------+
int init()
{
   SetIndexBuffer(0,stcBuffer);
   
   if(Email_Alert)swEmail=3;
   else swEmail=1;
   
   if (TimeFrame == "calculateSCHAF")
   {
      calculating = true;
         IndicatorBuffers(5);
            SetIndexBuffer(1,macdBuffer);
            SetIndexBuffer(2,fastKBuffer);
            SetIndexBuffer(3,fastDBuffer);
            SetIndexBuffer(4,fastKKBuffer);
      return(0);
   }
   if (TimeFrame == "getBarsCount")
   {
      returnBars=true;
      return(0);
   }   
      timeFrame = stringToTimeFrame(TimeFrame);   
      string TimeFrameStr;
         switch(timeFrame)
         {
            case PERIOD_M1:  TimeFrameStr="(M1)";      break;
            case PERIOD_M5:  TimeFrameStr="(M5)";      break;
            case PERIOD_M15: TimeFrameStr="(M15)";     break;
            case PERIOD_M30: TimeFrameStr="(M30)";     break;
            case PERIOD_H1:  TimeFrameStr="(H1)";      break;
            case PERIOD_H4:  TimeFrameStr="(H4)";      break;
            case PERIOD_D1:  TimeFrameStr="(Dayly)";   break;
            case PERIOD_W1:  TimeFrameStr="(Weekly)";  break;
            case PERIOD_MN1: TimeFrameStr="(Monthly)"; break;
            default :        TimeFrameStr="";
         }   

   IndicatorShortName("Schaff Trend Cycle "+TimeFrameStr+"("+STCPeriod+","+FastMAPeriod+","+SlowMAPeriod+")");
   IndicatorName = ("Schaff Trend Cycle "+TimeFrameStr+"("+STCPeriod+","+FastMAPeriod+","+SlowMAPeriod+")");
   IndicatorFileName = WindowExpertName();
   return(0);
}
//---------------------------------------------
int deinit()
{
   return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
{
   int counted_bars=IndicatorCounted();
   int limit,i,y;

   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
           limit = Bars-counted_bars;

   if (returnBars) { stcBuffer[0] = limit; return(0); }
   if (calculating)   
   {
      for(i = limit; i >= 0; i--)
      {
         macdBuffer[i] = iMA(NULL,0,FastMAPeriod,0,MODE_EMA,PRICE_CLOSE,i)-
                         iMA(NULL,0,SlowMAPeriod,0,MODE_EMA,PRICE_CLOSE,i);

         double lowMacd  = minValue(macdBuffer,i);
         double highMacd = maxValue(macdBuffer,i)-lowMacd;
            if (highMacd > 0)
                  fastKBuffer[i] = 100*((macdBuffer[i]-lowMacd)/highMacd);
            else  fastKBuffer[i] = fastKBuffer[i+1];
                  fastDBuffer[i] = fastDBuffer[i+1]+0.5*(fastKBuffer[i]-fastDBuffer[i+1]);
               
         double lowStoch  = minValue(fastDBuffer,i);
         double highStoch = maxValue(fastDBuffer,i)-lowStoch;
            if (highStoch > 0)
                  fastKKBuffer[i] = 100*((fastDBuffer[i]-lowStoch)/highStoch);
            else  fastKKBuffer[i] = fastKKBuffer[i+1];
                  stcBuffer[i]    = stcBuffer[i+1]+0.5*(fastKKBuffer[i]-stcBuffer[i+1]);
         
         
      }   
         if(stcBuffer[1]>AlertUpLevel && stcBuffer[0]<AlertUpLevel)
            {
               if(NewBar())ShowMessages("Schaff is going from: " + stcBuffer[1] + " to: " + stcBuffer[0]);
               //Print("Last  " + stcBuffer[1]);
               //Print("Now  " + stcBuffer[0]);
            }
         if(stcBuffer[1]<AlertDownLevel && stcBuffer[0]>AlertDownLevel)
            {
               if(NewBar())ShowMessages("Schaff is going from: " + stcBuffer[1] + " to: " + stcBuffer[0]);
               //Print("Last  " + stcBuffer[1]);
               //Print("Now  " + stcBuffer[0]);
            }
            
      return(0);
   }
   
   datetime TimeArray[]; ArrayCopySeries(TimeArray ,MODE_TIME ,NULL,timeFrame);
   
   if (timeFrame > Period()) limit = MathMax(limit,MathMin(Bars,iCustom(NULL,timeFrame,IndicatorFileName,"getBarsCount",0,0)*timeFrame/Period()));
   for(i=0, y=0; i<limit; i++)
   {
      if(Time[i]<TimeArray[y]) y++;
         stcBuffer[i] = iCustom(NULL,timeFrame,IndicatorFileName,"calculateSCHAF",STCPeriod,FastMAPeriod,SlowMAPeriod,0,y); 
   }
   
         if(stcBuffer[1]>AlertUpLevel && stcBuffer[0]<AlertUpLevel)
            {
               if(NewBar())ShowMessages("Schaff is going from: " + stcBuffer[1] + " to: " + stcBuffer[0]);
               //Print("Last  " + stcBuffer[1]);
               //Print("Now  " + stcBuffer[0]);
            }
         if(stcBuffer[1]<AlertDownLevel && stcBuffer[0]>AlertDownLevel)
            {
               if(NewBar())ShowMessages("Schaff is going from: " + stcBuffer[1] + " to: " + stcBuffer[0]);
               //Print("Last  " + stcBuffer[1]);
               //Print("Now  " + stcBuffer[0]);
            }
            
   return(0);      
}

//+------------------------------------------------------------------+
double minValue(double& array[],int shift)
{
   double minValue = array[shift];
            for (int i=1; i<STCPeriod; i++) minValue = MathMin(minValue,array[shift+i]);
   return(minValue);
}
double maxValue(double& array[],int shift)
{
   double maxValue = array[shift];
            for (int i=1; i<STCPeriod; i++) maxValue = MathMax(maxValue,array[shift+i]);
   return(maxValue);
}

//+------------------------------------------------------------------+
int stringToTimeFrame(string tfs)
{
   for(int l = StringLen(tfs)-1; l >= 0; l--)
   {
      int char = StringGetChar(tfs,l);
          if((char > 96 && char < 123) || (char > 223 && char < 256))
               tfs = StringSetChar(tfs, l, char - 32);
          else 
              if(char > -33 && char < 0)
                  tfs = StringSetChar(tfs, l, char + 224);
   }

   int tf=0;
         if (tfs=="M1" || tfs=="1")     tf=PERIOD_M1;
         if (tfs=="M5" || tfs=="5")     tf=PERIOD_M5;
         if (tfs=="M15"|| tfs=="15")    tf=PERIOD_M15;
         if (tfs=="M30"|| tfs=="30")    tf=PERIOD_M30;
         if (tfs=="H1" || tfs=="60")    tf=PERIOD_H1;
         if (tfs=="H4" || tfs=="240")   tf=PERIOD_H4;
         if (tfs=="D1" || tfs=="1440")  tf=PERIOD_D1;
         if (tfs=="W1" || tfs=="10080") tf=PERIOD_W1;
         if (tfs=="MN" || tfs=="43200") tf=PERIOD_MN1;
         if (tf<Period()) tf=Period();
   return(tf);
}
//------------------------------------                     // scalpz alert


void ShowMessages(string buyOrSell)
   {
      string varMesStr = "Schaff signal - " + buyOrSell + "\n";
      varMesStr = varMesStr + " Current Date is: " + Month( ) + "-" + Day( ) + "-" + Year( ) + "\n";
      varMesStr = varMesStr + " Current System Time is: " + Hour() + ":" + Minute() + "\n";
      varMesStr = varMesStr + " Current Chart Symbol is: " + Symbol() + "\n";
      varMesStr = varMesStr + " Current Time Frame is: " + timeFrame + "\n";
      varMesStr = varMesStr + " Current Open Bar Price is: " + Open[0] + "\n";
      if(PopUp_Alert == True) 
         {
            Alert(varMesStr);
         }
      if(swEmail == 3)
         {
            SendMail(buyOrSell,varMesStr);
         }
         
      return(0);
   }
   
bool NewBar()
{
   if (Time[0] != dt)
   {
      dt = Time[0];
      return(true);
   }
   return(false);
}

