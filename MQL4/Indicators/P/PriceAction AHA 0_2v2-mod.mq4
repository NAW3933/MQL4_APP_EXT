//+------------------------------------------------------------------+
//|                                          PriceAction AHA 0.2.mq4 |
//|                                    Copyright ?2006, Hua Ai (aha) |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2006, Hua Ai (aha)"
#property link      ""

// Version 0.2 adds the cross timeframe alerts to v0.1.

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Yellow
#property indicator_color2 Yellow
#property indicator_color3 Magenta
#property indicator_color4 Magenta
#property indicator_color5 Yellow
#property indicator_color6 Yellow
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 1
#property indicator_width6 1
//---- input parameters
extern bool      Alerts=true;
extern bool      History=true;
extern bool      CheckPinBars=true;
extern int       Min_Nose_Ratio=50;
extern int       Max_Body_Ratio=50;

extern bool      CheckDoubleBarHighLows=false;
extern bool      CheckOutsideBars=false;
extern bool      CheckI4Bars=true;

extern bool      SearchM15=true;
extern bool      SearchM30=true;
extern bool      SearchH1=true;
extern bool      SearchH4=true;
extern bool      SearchD1=true;
extern bool      SearchW1=true;
extern bool      SearchMN1=true;
//---- buffers
double PPB[]; //Positive Pin Bar
double NPB[]; //Negative Pin Bar
double I4BTop[];
double I4BBottom[];
double BullB[];
double BearB[];

bool startup;
bool upalert,downalert;
int  SignalLabeled, DangerLabeled; // 0: initial state; 1: up; 2: down.
int  highlowoffset;

string timeframe;

// for cross timeframe alert
bool M15PBChecked, M15DBHLChecked, M15OBChecked;
bool M30PBChecked, M30DBHLChecked, M30OBChecked;
bool H1PBChecked, H1DBHLChecked, H1OBChecked;
bool H4PBChecked, H4DBHLChecked, H4OBChecked, H4I4BChecked;
bool D1PBChecked, D1DBHLChecked, D1OBChecked, D1I4BChecked;
bool W1PBChecked, W1DBHLChecked, W1OBChecked, W1I4BChecked;
bool MN1PBChecked, MN1DBHLChecked, MN1OBChecked, MN1I4BChecked;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,74);
   SetIndexBuffer(0,NPB);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,74);
   SetIndexBuffer(1,PPB);
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,249);
   SetIndexBuffer(2,I4BTop);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,249);
   SetIndexBuffer(3,I4BBottom);
   SetIndexEmptyValue(3,0.0);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,217);
   SetIndexBuffer(4,BullB);
   SetIndexEmptyValue(4,0.0);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,218);
   SetIndexBuffer(5,BearB);
   SetIndexEmptyValue(5,0.0);
//----
   startup=true;
   clearmarks(PPB, NPB, I4BTop, I4BBottom, BullB, BearB);
   
   switch (Period())
   {
      case PERIOD_MN1:
         timeframe="MN1";
         break;
      case PERIOD_W1:
         timeframe="W1";
         break;
      case PERIOD_D1:
         timeframe="D1";
         break;
      case PERIOD_H4:
         timeframe="H4";
         break;
      case PERIOD_H1:
         timeframe="H1";
         break;
      case PERIOD_M30:
         timeframe="M30";
         break;
      case PERIOD_M15:
         timeframe="M15";
         break;
      case PERIOD_M5:
         timeframe="M5";
         break;
      case PERIOD_M1:
         timeframe="M1";
         break;
      default:
         return(0);
   }   

   M15PBChecked=false; M15DBHLChecked=false; M15OBChecked=false;
   M30PBChecked=false; M30DBHLChecked=false; M30OBChecked=false;
   H1PBChecked=false; H1DBHLChecked=false; H1OBChecked=false;
   H4PBChecked=false; H4DBHLChecked=false; H4OBChecked=false; H4I4BChecked=false;
   D1PBChecked=false; D1DBHLChecked=false; D1OBChecked=false; D1I4BChecked=false;
   W1PBChecked=false; W1DBHLChecked=false; W1OBChecked=false; W1I4BChecked=false;
   MN1PBChecked=false; MN1DBHLChecked=false; MN1OBChecked=false; MN1I4BChecked=false;

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   startup=false;
   clearmarks(PPB, NPB, I4BTop, I4BBottom, BullB, BearB);
   
//----
   return(0);
  }

// Determine the check time based on the chart period
void CheckTime(bool& check, bool& verify, int& highlowoffset)
{
   switch (Period())
   {
      case PERIOD_M1:
      case PERIOD_M5:
      case PERIOD_M15:
         highlowoffset=0;
         break;
      case PERIOD_M30:
         if ((Minute()>28 && Seconds()>50) || startup) check=true; else check=false;
         if ((Minute()<5  && Seconds()<10) || startup) verify=true; else verify=false;
         highlowoffset=0;
         break;
      case PERIOD_H1:
         //Print("I am in H1!");
         if ((Minute()>58 && Seconds()>50) || startup) check=true; else check=false;
         if ((Minute()<10 && Seconds()<10) || startup) verify=true; else verify=false;
         //Print("check=", check);
         highlowoffset=1;
         break;
      case PERIOD_H4:
         if ((MathMod(Hour(),4)==3 && Minute()>58 && Seconds()>50) || startup) check=true; else check=false;
         if ((MathMod(Hour(),4)==0 && Minute()<10 && Seconds()<10) || startup) verify=true; else verify=false;
         highlowoffset=2;
         break;
      case PERIOD_D1:
         if ((Hour()==23 && Minute()>58 && Seconds()>50) || startup) check=true; else check=false;
         if ((Hour()==0  && Minute()<10 && Seconds()<10) || startup) verify=true; else verify=false;
         highlowoffset=3;
         break;
      case PERIOD_W1:
         if ((DayOfWeek()==5 && Hour()==19 && Minute()>58 && Seconds()>50) || startup) check=true; else check=false;
         if ((DayOfWeek()==0 && Hour()==20 && Minute()<10 && Seconds()<10) || startup) verify=true; else verify=false;
         highlowoffset=4;
         break;
      case PERIOD_MN1:
         if ((Day()>=28 && Hour()==23 && Minute()>58 && Seconds()>50) || startup) check=true; else check=false;
         if ((Day()==0  && Hour()==0  && Minute()<10 && Seconds()<10) || startup) verify=true; else verify=false;
         highlowoffset=5;
         break;
      default:
         //Print("I am in default!");
         check=false;
         verify=false;
         highlowoffset=0;
         break;
   }
   
   //Print("check=", check);
   return;
}

double CalRange(int bar_num, bool verify=false)
{
   int counter, n=0;
   double Range, AvgRange; 
   if (verify) n=1;
   AvgRange=0;
   for (counter=bar_num-n; counter<=bar_num+1;counter++)
   {
      AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
   }
   Range=AvgRange/2;
   return(Range);
}

void clearmarks(double& PPB[], double& NPB[], double& I4BTop[], 
                double& I4BBottom[], double& BullB[], double& BearB[])
{
   for (int i=0; i<= Bars-1; i++)
   {
      PPB[i]=0;
      NPB[i]=0;
      I4BTop[i]=0;
      I4BBottom[i]=0;
      BullB[i]=0;
      BearB[i]=0;
   }
   return;
}

void CheckNPB(int bar_num, double& NPB[], bool& downalert, bool verify=false)
{
   double bar_length, nose_length, body_length, eye_pos;

   if(CheckPinBars)
   {
      bar_length = High[bar_num]-Low[bar_num];
      if (bar_length==0) bar_length=0.0001;
      nose_length = High[bar_num]-MathMax(Open[bar_num], Close[bar_num]);
      body_length = MathAbs(Open[bar_num]-Close[bar_num]);

      if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
          body_length/bar_length < Max_Body_Ratio/100.0 &&
          (High[bar_num]-High[bar_num+1]>=bar_length/3.0 || 
           (High[bar_num]-High[bar_num+1]>=bar_length/4.0&&body_length/bar_length<0.2)) &&
          Low[bar_num]>Low[bar_num+1])
      {
         if(History) NPB[bar_num]=High[bar_num]+0.1*CalRange(bar_num, verify);
         
         if(Alerts && !downalert && !startup && !verify) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+timeframe+": Negative Pin Bar!! ");
            SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+timeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+timeframe+"!!");
            //upalert=true;
            downalert=true;
         }
         //Print("Got a negative pin!");
      }
   
      if(verify&&(!(nose_length/bar_length > Min_Nose_Ratio/100.0 &&
                    body_length/bar_length < Max_Body_Ratio/100.0 &&
                    (High[bar_num]-High[bar_num+1]>=bar_length/3.0 || 
                     (High[bar_num]-High[bar_num+1]>=bar_length/4.0&&body_length/bar_length<0.2)) &&
                    Low[bar_num]>Low[bar_num+1]) ||
                  High[bar_num]<High[bar_num-1])) 
         NPB[bar_num]=0;
      
      if(verify) 
      {
         //upalert=false;
         downalert=false;
      }
   }
   
   return;
}

void CheckPPB(int bar_num, double& PPB[], bool& upalert, bool verify=false)
{
   double bar_length, nose_length, body_length, eye_pos;

   if(CheckPinBars)
   {
      bar_length = High[bar_num]-Low[bar_num];
      if (bar_length==0) bar_length=0.00001;
      nose_length = MathMin(Open[bar_num], Close[bar_num])-Low[bar_num];
      body_length = MathAbs(Open[bar_num]-Close[bar_num]);
   
      if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
          body_length/bar_length < Max_Body_Ratio/100.0 &&
          (Low[bar_num+1]-Low[bar_num]>=bar_length/3.0 ||
           (Low[bar_num+1]-Low[bar_num]>=bar_length/4.0&&body_length/bar_length<0.2)) &&
          High[bar_num]<High[bar_num+1])
      {
         if(History) PPB[bar_num]=Low[bar_num]-0.1*CalRange(bar_num, verify);
              
         if(Alerts && !upalert && !startup && !verify) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+timeframe+": Positive Pin Bar!! ");
            SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+timeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+timeframe+"!!");
            upalert=true;
            //downalert=false;
         }
      }
      if(verify&&(!(nose_length/bar_length > Min_Nose_Ratio/100.0 &&
                    body_length/bar_length < Max_Body_Ratio/100.0 &&
                   (Low[bar_num+1]-Low[bar_num]>=bar_length/3.0 ||
                    (Low[bar_num+1]-Low[bar_num]>=bar_length/4.0&&body_length/bar_length<0.2)) &&
                    High[bar_num]<High[bar_num+1])||
                  Low[bar_num]>Low[bar_num-1]))
         PPB[bar_num]=0;

      if(verify) 
      {
         upalert=false;
         //downalert=false;
      }
   }
   
   return;
}

void CheckBullB(int bar_num, double& BullB[], bool& upalert, bool verify=false)
{
   if (CheckDoubleBarHighLows)
   {
      // check DBLHC
      if (MathAbs(Low[bar_num]-Low[bar_num+1])<=highlowoffset*Point&&Close[bar_num]>High[bar_num+1])
      {
         if(History) BullB[bar_num]=Low[bar_num]-0.1*CalRange(bar_num, verify);

         if(Alerts && !upalert && !startup && !verify) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+timeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+timeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+timeframe+"!!");
            upalert=true;
         }
      }

      if(verify&&!(MathAbs(Low[bar_num]-Low[bar_num+1])<=highlowoffset*Point&&Close[bar_num]>High[bar_num+1])) 
         BullB[bar_num]=0;
      
      if(verify) 
      {  
         upalert=false;
      }
   }   
   
   if (CheckOutsideBars)
   {
      // check BUOB
      if (Low[bar_num]<Low[bar_num+1]&&Close[bar_num]>High[bar_num+1])
      {
         if(History) BullB[bar_num]=Low[bar_num]-0.1*CalRange(bar_num, verify);

         if(Alerts && !upalert && !startup && !verify) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+timeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+timeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+timeframe+"!!");
            upalert=true;
         }
      }

      if(verify&&!(Low[bar_num]<Low[bar_num+1]&&Close[bar_num]>High[bar_num+1]))
         BullB[bar_num]=0;
      
      if(verify) 
      {  
         upalert=false;
      }
   }   
   
   return;
}

void CheckBearB(int bar_num, double& BearB[], bool& downalert, bool verify=false)
{
   if (CheckDoubleBarHighLows)
   {
      // check DBHLC
      if (MathAbs(High[bar_num]-High[bar_num+1])<=highlowoffset*Point&&Close[bar_num]<Low[bar_num+1])
      {
         if(History) BearB[bar_num]=High[bar_num]+0.1*CalRange(bar_num, verify);

         if(Alerts && !downalert && !startup && !verify) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+timeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+timeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+timeframe+"!!");
            downalert=true;
         }
      }

      if(verify&&!(MathAbs(High[bar_num]-High[bar_num+1])<=highlowoffset*Point&&Close[bar_num]<Low[bar_num+1])) 
         BearB[bar_num]=0;
      
      if(verify) 
      {  
         downalert=false;
      }
   }   
   
   if (CheckOutsideBars)
   {
      // check BEOB
      if (Close[bar_num]<Low[bar_num+1]&&High[bar_num]>High[bar_num+1])
      {
         if(History) BearB[bar_num]=High[bar_num]+0.1*CalRange(bar_num, verify);

         if(Alerts && !downalert && !startup && !verify) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+timeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+timeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+timeframe+"!!");
            downalert=true;
         }
      }

      if(verify&&!(Close[bar_num]<Low[bar_num+1]&&High[bar_num]>High[bar_num+1]))
         BearB[bar_num]=0;
      
      if(verify) 
      {  
         downalert=false;
      }
   }   
   
   return;
}

void CheckI4B(int bar_num, double& I4BTop[], double& I4BBottom[], bool verify=false)
{
   int dayintheweek=TimeDayOfWeek(iTime(NULL, 0, bar_num));
   int bar_0, bar_1, bar_2, bar_3;
   double bar_length_0, bar_length_1, bar_length_2, bar_length_3;
   
   if(CheckI4Bars) 
   {
      if (Period()==PERIOD_D1)
      {
         switch(dayintheweek)
         {
            case 4:
            case 5:
               bar_0 = bar_num;
               bar_1 = bar_num+1;
               bar_2 = bar_num+2;
               bar_3 = bar_num+3;
               break;
            case 3:
               bar_0 = bar_num;
               bar_1 = bar_num+1;
               bar_2 = bar_num+2;
               bar_3 = bar_num+4;
               break;
            case 2:
               bar_0 = bar_num;
               bar_1 = bar_num+1;
               bar_2 = bar_num+3;
               bar_3 = bar_num+4;
               break;
            case 1:
               bar_0 = bar_num;
               bar_1 = bar_num+2;
               bar_2 = bar_num+3;
               bar_3 = bar_num+4;
               break;
            default:
               bar_0 = bar_num;
               bar_1 = bar_num;
               bar_2 = bar_num;
               bar_3 = bar_num;
               break;
         }
      }
      else
      {
         bar_0 = bar_num;
         bar_1 = bar_num+1;
         bar_2 = bar_num+2;
         bar_3 = bar_num+3;
      }
      bar_length_0 = High[bar_0]-Low[bar_0];
      bar_length_1 = High[bar_1]-Low[bar_1];
      bar_length_2 = High[bar_2]-Low[bar_2];
      bar_length_3 = High[bar_3]-Low[bar_3];
      if( bar_length_0<bar_length_1 && bar_length_0<bar_length_2 && 
          bar_length_0<bar_length_3 && High[bar_0]<High[bar_1] &&
          Low[bar_0]>Low[bar_1] && (Period()==PERIOD_D1||Period()==PERIOD_H4))
      {
         I4BTop[bar_num]=High[bar_num]+0.1*CalRange(bar_num, verify);
         I4BBottom[bar_num]=Low[bar_num]-0.1*CalRange(bar_num, verify);
         //Print("Got a I4B bar!");
         //Print("dayintheweek=", dayintheweek);
      }
   }
   return;
}

void CheckM15(bool& M15PBChecked, bool& M15DBHLChecked, bool& M15OBChecked)
{
   if(Period()==PERIOD_M15) return;
   if(MathMod(Minute(),15)<2) {M15PBChecked=false; M15DBHLChecked=false; M15OBChecked=false; return;}
   if(MathMod(Minute(),15)>=2&&MathMod(Minute(),15)<13) return;
   
   int tf=PERIOD_M15;
   string checkingtimeframe="M15";
   double high0=iHigh(NULL,tf,0);
   double high1=iHigh(NULL,tf,1);
   double low0=iLow(NULL,tf,0);
   double low1=iLow(NULL,tf,1);
   double open0=iOpen(NULL,tf,0);
   double open1=iOpen(NULL,tf,1);
   double close0=iClose(NULL,tf,0);
   double close1=iClose(NULL,tf,1);
   
   double bar_length, body_length, nose_length;

   if(CheckPinBars&&!M15PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            M15PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            M15PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!M15DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M15DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M15DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!M15OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M15OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M15OBChecked=true;
      }
   }   
   
   return;
}

void CheckM30(bool& M30PBChecked, bool& M30DBHLChecked, bool& M30OBChecked)
{
   if(Period()==PERIOD_M30) return;
   if(MathMod(Minute(),30)<2) {M30PBChecked=false; M30DBHLChecked=false; M30OBChecked=false; return;}
   if(MathMod(Minute(),30)>=2&&MathMod(Minute(),30)<28) return;
   
   int tf=PERIOD_M30;
   string checkingtimeframe="M30";
   double high0=iHigh(NULL,tf,0);
   double high1=iHigh(NULL,tf,1);
   double low0=iLow(NULL,tf,0);
   double low1=iLow(NULL,tf,1);
   double open0=iOpen(NULL,tf,0);
   double open1=iOpen(NULL,tf,1);
   double close0=iClose(NULL,tf,0);
   double close1=iClose(NULL,tf,1);

   double bar_length, body_length, nose_length;

   if(CheckPinBars&&!M30PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            M30PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            M30PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!M30DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M30DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M30DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!M30OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M30OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         M30OBChecked=true;
      }
   }   
   
   return;
}

void CheckH1(bool& H1PBChecked, bool& H1DBHLChecked, bool& H1OBChecked)
{
   if(Period()==PERIOD_H1) return;
   if(Minute()<2) {H1PBChecked=false; H1DBHLChecked=false; H1OBChecked=false; return;}
   if(Minute()>=2&&Minute()<55) return;
   
   int tf=PERIOD_H1;
   string checkingtimeframe="H1";
   double high0=iHigh(NULL,tf,0);
   double high1=iHigh(NULL,tf,1);
   double low0=iLow(NULL,tf,0);
   double low1=iLow(NULL,tf,1);
   double open0=iOpen(NULL,tf,0);
   double open1=iOpen(NULL,tf,1);
   double close0=iClose(NULL,tf,0);
   double close1=iClose(NULL,tf,1);

   double bar_length, body_length, nose_length;

   if(CheckPinBars&&!H1PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            H1PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            H1PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!H1DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H1DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H1DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!H1OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H1OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H1OBChecked=true;
      }
   }   
   
   return;
}

void CheckH4(bool& H4PBChecked, bool& H4DBHLChecked, bool& H4OBChecked, bool& H4I4BChecked)
{
   if(Period()==PERIOD_H4) return;
   if(MathMod(Hour(),4)==0&&Minute()<2) {H4PBChecked=false; H4DBHLChecked=false; H4OBChecked=false; H4I4BChecked=false; return;}
   if(MathMod(Hour(),4)<3||(MathMod(Hour(),4)==3&&Minute()<50)) return;
   
   int tf=PERIOD_H4;
   string checkingtimeframe="H4";
   double high0=iHigh(NULL,tf,0);
   double high1=iHigh(NULL,tf,1);
   double low0=iLow(NULL,tf,0);
   double low1=iLow(NULL,tf,1);
   double open0=iOpen(NULL,tf,0);
   double open1=iOpen(NULL,tf,1);
   double close0=iClose(NULL,tf,0);
   double close1=iClose(NULL,tf,1);

   double bar_length, body_length, nose_length;

   if(CheckPinBars&&!H4PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            H4PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            H4PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!H4DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H4DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H4DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!H4OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H4OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H4OBChecked=true;
      }
   }

   if(CheckI4Bars&&!H4I4BChecked) 
   {
      double bar_length_0 = high0-low0;
      double bar_length_1 = high1-low1;
      double bar_length_2 = iHigh(NULL,tf,2)-iLow(NULL,tf,2);
      double bar_length_3 = iHigh(NULL,tf,3)-iLow(NULL,tf,3);
      if( bar_length_0<bar_length_1 && bar_length_0<bar_length_2 && 
          bar_length_0<bar_length_3 && high0<high1 && low0>low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": I4B!! ");
            SendMail("PriceAction AHA: I4B on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: I4B found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         H4I4BChecked=true;
      }
   }
   
   return;
}
   
void CheckD1(bool& D1PBChecked, bool& D1DBHLChecked, bool& D1OBChecked, bool& D1I4BChecked)
{
   if(Period()==PERIOD_D1) return;

   int tf=PERIOD_D1;
   string checkingtimeframe="D1";
   int dayintheweek=TimeDayOfWeek(iTime(NULL, tf, 0));
   if(dayintheweek==0||(Hour()==0&&Minute()<10)) {D1PBChecked=false; D1DBHLChecked=false; D1OBChecked=false; D1I4BChecked=false; return;}
   if(dayintheweek!=5&&(Hour()<23||(Hour()==23&&Minute()<50))||
      dayintheweek==5&&(Hour()<19||(Hour()==19&&Minute()<50))) return;

   int bar_0, bar_1, bar_2, bar_3;
   double bar_length_0, bar_length_1, bar_length_2, bar_length_3;
   switch(dayintheweek)
   {
      case 4:
      case 5:
         bar_0 = 0;
         bar_1 = 1;
         bar_2 = 2;
         bar_3 = 3;
         break;
      case 3:
         bar_0 = 0;
         bar_1 = 1;
         bar_2 = 2;
         bar_3 = 4;
         break;
      case 2:
         bar_0 = 0;
         bar_1 = 1;
         bar_2 = 3;
         bar_3 = 4;
         break;
      case 1:
         bar_0 = 0;
         bar_1 = 2;
         bar_2 = 3;
         bar_3 = 4;
         break;
      default:
         return;
   }

   double high0=iHigh(NULL,tf,bar_0);
   double high1=iHigh(NULL,tf,bar_1);
   double low0=iLow(NULL,tf,bar_0);
   double low1=iLow(NULL,tf,bar_1);
   double open0=iOpen(NULL,tf,bar_0);
   double open1=iOpen(NULL,tf,bar_1);
   double close0=iClose(NULL,tf,bar_0);
   double close1=iClose(NULL,tf,bar_1);

   double bar_length, body_length, nose_length;
   
   if(CheckPinBars&&!D1PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            D1PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            D1PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!D1DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         D1DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         D1DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!D1OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         D1OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         D1OBChecked=true;
      }
   }

   if(CheckI4Bars&&!D1I4BChecked) 
   {
      bar_length_0 = high0-low0;
      bar_length_1 = high1-low1;
      bar_length_2 = iHigh(NULL,tf,bar_2)-iLow(NULL,tf,bar_2);
      bar_length_3 = iHigh(NULL,tf,bar_3)-iLow(NULL,tf,bar_3);
      if( bar_length_0<bar_length_1 && bar_length_0<bar_length_2 && 
          bar_length_0<bar_length_3 && high0<high1 && low0>low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": I4B!! ");
            SendMail("PriceAction AHA: I4B on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: I4B found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         D1I4BChecked=true;
      }
   }
   
   return;
}

void CheckW1(bool& W1PBChecked, bool& W1DBHLChecked, bool& W1OBChecked, bool& W1I4BChecked)
{
   if(Period()==PERIOD_W1) return;

   int tf=PERIOD_W1;
   string checkingtimeframe="W1";
   int dayintheweek=TimeDayOfWeek(iTime(NULL, PERIOD_D1, 0));

   if(dayintheweek==0&&Hour()<=23&&Minute()<2) {W1PBChecked=false; W1DBHLChecked=false; W1OBChecked=false; W1I4BChecked=false; return;}
   if(!(dayintheweek==5&&Hour()==19&&Minute()<50)) return;
   
   double high0=iHigh(NULL,tf,0);
   double high1=iHigh(NULL,tf,1);
   double low0=iLow(NULL,tf,0);
   double low1=iLow(NULL,tf,1);
   double open0=iOpen(NULL,tf,0);
   double open1=iOpen(NULL,tf,1);
   double close0=iClose(NULL,tf,0);
   double close1=iClose(NULL,tf,1);

   double bar_length, body_length, nose_length;

   if(CheckPinBars&&!W1PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            W1PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            W1PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!W1DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         W1DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         W1DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!W1OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         W1OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         W1OBChecked=true;
      }
   }

   if(CheckI4Bars&&!W1I4BChecked) 
   {
      double bar_length_0 = high0-low0;
      double bar_length_1 = high1-low1;
      double bar_length_2 = iHigh(NULL,tf,2)-iLow(NULL,tf,2);
      double bar_length_3 = iHigh(NULL,tf,3)-iLow(NULL,tf,3);
      if( bar_length_0<bar_length_1 && bar_length_0<bar_length_2 && 
          bar_length_0<bar_length_3 && high0<high1 && low0>low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": I4B!! ");
            SendMail("PriceAction AHA: I4B on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: I4B found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         W1I4BChecked=true;
      }
   }
   
   return;
}

void CheckMN1(bool& MN1PBChecked, bool& MN1DBHLChecked, bool& MN1OBChecked, bool& MN1I4BChecked)
{
   if(Period()==PERIOD_MN1) return;

   int tf=PERIOD_MN1;
   string checkingtimeframe="MN1";
   int dayinthemonth=TimeDay(iTime(NULL, PERIOD_D1, 0));

   if((dayinthemonth==0||dayinthemonth>=28)&&Hour()==0&&Minute()<2) {MN1PBChecked=false; MN1DBHLChecked=false; MN1OBChecked=false; MN1I4BChecked=false; return;}
   if(!(dayinthemonth>=28&&Hour()==23&& Minute()>50)) return;
   
   double high0=iHigh(NULL,tf,0);
   double high1=iHigh(NULL,tf,1);
   double low0=iLow(NULL,tf,0);
   double low1=iLow(NULL,tf,1);
   double open0=iOpen(NULL,tf,0);
   double open1=iOpen(NULL,tf,1);
   double close0=iClose(NULL,tf,0);
   double close1=iClose(NULL,tf,1);

   double bar_length, body_length, nose_length;

   if(CheckPinBars&&!MN1PBChecked)
   {
      bar_length = high0-low0;
      if (bar_length==0) bar_length=0.0001;
      body_length = MathAbs(open0-close0);

      double nose1, nose2;
      nose1=high0-MathMax(open0, close0);
      nose2=MathMin(open0, close0)-low0;

      if (nose1>=nose2)
      {
         nose_length=nose1;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (high0-high1>=bar_length/3.0||(high0-high1>=bar_length/4.0&&body_length/bar_length<0.2))&&
             low0>low1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Negative Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Negative Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            MN1PBChecked=true;
         }
      }
      else if (nose1<=nose2)
      {
         nose_length=nose2;
         if( nose_length/bar_length > Min_Nose_Ratio/100.0 &&
             body_length/bar_length < Max_Body_Ratio/100.0 &&
             (low1-low0>=bar_length/3.0||(low1-low0>=bar_length/4.0&&body_length/bar_length<0.2))&&
             high0<high1
           )
         {
            if(Alerts) 
            { 
               Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": Positive Pin Bar!! ");
               SendMail("PriceAction AHA: Pin Bar on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: Positive Pin bar found on "+Symbol()+" "+checkingtimeframe+"!!");
            }
            //Print("Got a negative pin!");
            MN1PBChecked=true;
         }
      }
   }

   if (CheckDoubleBarHighLows&&!MN1DBHLChecked)
   {
      if (MathAbs(low0-low1)<=0&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBLHC!! ");
            SendMail("PriceAction AHA: DBLHC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBLHC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         MN1DBHLChecked=true;
      }
      else if (MathAbs(high0-high1)<=0&&close0<low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": DBHLC!! ");
            SendMail("PriceAction AHA: DBHLC on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: DBHLC found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         MN1DBHLChecked=true;
      }
   }   
   
   if (CheckOutsideBars&&!MN1OBChecked)
   {
      if (low0<low1&&close0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BUOB!! ");
            SendMail("PriceAction AHA: BUOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BUOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         MN1OBChecked=true;
      }
      else if (close0<low1&&high0>high1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": BEOB!! ");
            SendMail("PriceAction AHA: BEOB on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: BEOB found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         MN1OBChecked=true;
      }
   }

   if(CheckI4Bars&&!MN1I4BChecked) 
   {
      double bar_length_0 = high0-low0;
      double bar_length_1 = high1-low1;
      double bar_length_2 = iHigh(NULL,tf,2)-iLow(NULL,tf,2);
      double bar_length_3 = iHigh(NULL,tf,3)-iLow(NULL,tf,3);
      if( bar_length_0<bar_length_1 && bar_length_0<bar_length_2 && 
          bar_length_0<bar_length_3 && high0<high1 && low0>low1)
      {
         if(Alerts) 
         { 
            Alert ("PriceAction AHA on ", Symbol()," "+checkingtimeframe+": I4B!! ");
            SendMail("PriceAction AHA: I4B on "+Symbol()+" "+checkingtimeframe+"!!", "PriceAction AHA: I4B found on "+Symbol()+" "+checkingtimeframe+"!!");
         }
         MN1I4BChecked=true;
      }
   }
   
   return;
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
//----
   int i;
   bool timetocheck=false;
   bool timetoverify=false;
   
   //Print("dayintheweek=", DayOfWeek());
   CheckTime(timetocheck, timetoverify, highlowoffset);
   
   if (startup&&History)
   {
      //Print("I am in startup!");
      for(i=Bars-1; i>=1; i--) 
      {
         CheckPPB(i, PPB, upalert, true);
         CheckNPB(i, NPB, downalert, true);
         CheckI4B(i, I4BTop, I4BBottom, true);
         CheckBullB(i, BullB, upalert, true);
         CheckBearB(i, BearB, downalert, true);
      }
   }
   
   if (timetocheck)
   {
      CheckPPB(0, PPB, upalert);
      CheckNPB(0, NPB, downalert);
      CheckI4B(0, I4BTop, I4BBottom);
      CheckBullB(0, BullB, upalert);
      CheckBearB(0, BearB, downalert);
   }

   if (timetoverify)
   {
      CheckPPB(1, PPB, upalert, true);
      CheckNPB(1, NPB, downalert, true);
      CheckI4B(1, I4BTop, I4BBottom, true);
      CheckBullB(1, BullB, upalert, true);
      CheckBearB(1, BearB, downalert,true);
   }

   if(SearchM15) CheckM15(M15PBChecked, M15DBHLChecked, M30OBChecked);
   if(SearchM30) CheckM30(M30PBChecked, M30DBHLChecked, M30OBChecked);
   if(SearchH1) CheckH1(H1PBChecked, H1DBHLChecked, H1OBChecked);
   if(SearchH4) CheckH4(H4PBChecked, H4DBHLChecked, H4OBChecked, H4I4BChecked);
   if(SearchD1) CheckD1(D1PBChecked, D1DBHLChecked, D1OBChecked, D1I4BChecked);
   if(SearchW1) CheckW1(W1PBChecked, W1DBHLChecked, W1OBChecked, W1I4BChecked);
   if(SearchMN1) CheckMN1(MN1PBChecked, MN1DBHLChecked, MN1OBChecked, MN1I4BChecked);

   startup=false;

//----
   return(0);
}
//+------------------------------------------------------------------+