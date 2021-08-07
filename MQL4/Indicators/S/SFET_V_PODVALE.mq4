///+------------------------------------------------------------------+ 
// PUX_3_Semafor              (2)
// Ways of the ancients      (rus)
//______________________o7o___(_)___o7o__
//___¦_____¦_____¦gold¦_____¦_____¦_____¦
//¦_5484_¦_____¦_____¦_____¦_____¦_____¦__
//___¦_____¦_____¦_____¦_kazan__¦_____¦
//¦____¦ihldiaf¦_____¦_____¦_____¦____¦__
//___¦_____¦_____¦_____¦Lou¦Master_¦____¦
//¦PUX_FX___¦_____¦_garri_¦_____¦_____¦__        APRIL, 2013
/*
      Переводим индикацию в подвал //***
*/
//+------------------------------------------------------------------+
//#property indicator_chart_window
#property indicator_separate_window

//+------------------------------------------------------------------+ 
#property indicator_buffers 12      // А чего стесняться?***
/*
#property indicator_color1 Lime 
#property indicator_color2 Red 
#property indicator_color3 Gold
#property indicator_color4 Gold
#property indicator_color5 Lime
#property indicator_color6 Red
 
#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 3
#property indicator_width6 3
*/ 
#property indicator_minimum 0.5
#property indicator_maximum 3.5 
//---- input parameters 
enum GraphType
{
    Квадратики,
    Кружочки
};

extern double     Period1     =0; 
extern double     Period2     =12; 
extern double     Period3     =34; 
extern GraphType  Тип_Графика;
extern int        SymbSize    = 1; 
extern string     Dev_Step_1  ="1";
extern string     Dev_Step_2  ="1";
extern string     Dev_Step_3  ="1";
//extern int        SymbCode    = 110;
       
extern int        BarsCount = 1000;
 int Symbol_1_Kod=159;
 int Symbol_2_Kod=159;
 int Symbol_3_Kod=178;

//+----    mod of  TRO MODIFICATION ------------------------+ 
extern string _____           ="";
extern bool   Box_Alerts      = false ;
extern bool   Email_Alerts    = false ;

extern bool   Alert_Lv1    = false ;
extern bool   Alert_Lv2    = false ;
extern bool   Alert_Lv3    = false ;

//---- buffers 
double FP_BuferUp[];
double FP_BuferDn[]; 
double NP_BuferUp[];
double NP_BuferDn[]; 
double HP_BuferUp[];
double HP_BuferDn[]; 

double BufSlowUp[];
double BufSlowDn[];
double BufMidUp[];
double BufMidDn[];
double BufFastUp[];
double BufFastDn[];

int F_Period;
int N_Period;
int H_Period;
int Dev1;
int Stp1;
int Dev2;
int Stp2;
int Dev3;
int Stp3;
//+------------------------------------------------------------------+  
string symbol, tChartPeriod,  tShortName ;  
int    digits, period  ; 
bool Trigger1,  Trigger2,  Trigger3 ;
int OldBars = -1 ;
color tColor = Yellow ;

string MyName = "SFP_";
//================================================================
//    NewBuffersInit
//================================================================
void NewBuffersInit()
{
   int symCode = -1;
   int i;
   if(Тип_Графика == 0 ) symCode = 110;
   if(Тип_Графика == 1 ) symCode = 159;
   
   if(symCode != -1)
   {
      for( i=6; i<=11; i++)
      {
         SetIndexArrow(i,symCode); 
         SetIndexEmptyValue(i,EMPTY_VALUE); 
      }
      SetIndexStyle(6,DRAW_ARROW, EMPTY, SymbSize, Green);
      SetIndexBuffer(6,BufSlowUp); 
            
      SetIndexStyle(7,DRAW_ARROW, EMPTY, SymbSize, Red);
      SetIndexBuffer(7,BufSlowDn); 
            
      SetIndexStyle(8,DRAW_ARROW, EMPTY, SymbSize, Green);
      SetIndexBuffer(8,BufMidUp); 
            
      SetIndexStyle(9,DRAW_ARROW, EMPTY, SymbSize, Red);
      SetIndexBuffer(9,BufMidDn); 
            
      SetIndexStyle(10,DRAW_ARROW, EMPTY, SymbSize, Green);
      SetIndexBuffer(10,BufFastUp); 
            
      SetIndexStyle(11,DRAW_ARROW, EMPTY, SymbSize, Red);
      SetIndexBuffer(11,BufFastDn); 
    }
    
   
   
   
   
   
   
}

//+------------------------------------------------------------------+ 
int init() 
  { 
//+------------------------------------------------------------------+   
   period       = Period() ;     
   tChartPeriod =  TimeFrameToString(period) ;
   symbol       =  Symbol() ;
   digits       =  Digits ;   

   tShortName = "tbb"+ symbol + tChartPeriod  ;
//+------------------------------------------------------------------+   
   if (Period1>0) F_Period=MathCeil(Period1*Period()); else F_Period=0; 
   if (Period2>0) N_Period=MathCeil(Period2*Period()); else N_Period=0; 
   if (Period3>0) H_Period=MathCeil(Period3*Period()); else H_Period=0;    
//---- 
   if (Period1>0)
   {
   //SetIndexStyle(0,DRAW_ARROW); 
   SetIndexStyle(0,DRAW_NONE); 
   SetIndexArrow(0,Symbol_1_Kod); 
   SetIndexBuffer(0,FP_BuferUp); 
   SetIndexEmptyValue(0,0.0); 
   
   //SetIndexStyle(1,DRAW_ARROW); 
   SetIndexStyle(1,DRAW_NONE); 
   SetIndexArrow(1,Symbol_1_Kod); 
   SetIndexBuffer(1,FP_BuferDn); 
   SetIndexEmptyValue(1,0.0); 
   }   
//---- 
   if (Period2>0)
   {
   //SetIndexStyle(2,DRAW_ARROW); 
   SetIndexStyle(2,DRAW_NONE); 
   SetIndexArrow(2,Symbol_2_Kod); 
   SetIndexBuffer(2,NP_BuferUp); 
   SetIndexEmptyValue(2,0.0); 
   
   //SetIndexStyle(3,DRAW_ARROW); 
   SetIndexStyle(3,DRAW_NONE); 
   SetIndexArrow(3,Symbol_2_Kod); 
   SetIndexBuffer(3,NP_BuferDn); 
   SetIndexEmptyValue(3,0.0); 
   }
//---- 
   if (Period3>0)
   {
   //SetIndexStyle(4,DRAW_ARROW); 
   SetIndexStyle(4,DRAW_NONE); 
   SetIndexArrow(4,Symbol_3_Kod); 
   SetIndexBuffer(4,HP_BuferUp); 
   SetIndexEmptyValue(4,0.0); 

   //SetIndexStyle(5,DRAW_ARROW);
   SetIndexStyle(5,DRAW_NONE);  
   SetIndexArrow(5,Symbol_3_Kod); 
   SetIndexBuffer(5,HP_BuferDn); 
   SetIndexEmptyValue(5,0.0); 
   }
   
   //*** Новые буферы
   
   NewBuffersInit();
   

   
   
//----
   int CDev=0;
   int CSt=0;
   int Mass[]; 
   int C=0;  
   if (IntFromStr(Dev_Step_1,C, Mass)==1) 
      {
        Stp1=Mass[1];
        Dev1=Mass[0];
      }
   
   if (IntFromStr(Dev_Step_2,C, Mass)==1)
      {
        Stp2=Mass[1];
        Dev2=Mass[0];
      }      
   
   
   if (IntFromStr(Dev_Step_3,C, Mass)==1)
      {
        Stp3=Mass[1];
        Dev3=Mass[0];
      }      
   return(0); 
  } 
//+------------------------------------------------------------------+ 
int deinit() 
  { 
//---- 
    
//---- 
   return(0); 
  } 
//+------------------------------------------------------------------+ 
int start() 
  { 
//+------------------------------------------------------------------+    
   if( Bars != OldBars ) { Trigger1 = True ; Trigger2 = True ; Trigger3 = True ;}
     
   if (Period1>0) CountZZ(FP_BuferUp,FP_BuferDn,Period1,Dev1,Stp1, 3, BufFastUp, BufFastDn);
   if (Period2>0) CountZZ(NP_BuferUp,NP_BuferDn,Period2,Dev2,Stp2, 2, BufMidUp, BufMidDn);
   if (Period3>0) CountZZ(HP_BuferUp,HP_BuferDn,Period3,Dev3,Stp3, 1, BufSlowUp, BufSlowDn);
//+------------------------------------------------------------------+  
   string alert_level;   string alert_message;
   
   alert_message = symbol+"  "+ tChartPeriod+ " at "+ DoubleToStr(Close[0] ,digits);

      if ( Trigger1 &&  Alert_Lv1 ) 
      {
        if( FP_BuferUp[0] != 0 ) { Trigger1 = False ; alert_level =" ZZS: Level 1 Low;  "; if(Box_Alerts) Alert(alert_level,alert_message); if(Email_Alerts) SendMail(alert_level,alert_message);}
        if( FP_BuferDn[0] != 0 ) { Trigger1 = False ; alert_level =" ZZS: Level 1 High; "; if(Box_Alerts) Alert(alert_level,alert_message); if(Email_Alerts) SendMail(alert_level,alert_message);}
      }
      
      if ( Trigger2 &&  Alert_Lv2 ) 
      {
        if( NP_BuferUp[0] != 0 ) { Trigger2 = False ; alert_level =" ZZS: Level 2 Low;  "; if(Box_Alerts) Alert(alert_level,alert_message); if(Email_Alerts) SendMail(alert_level,alert_message);}
        if( NP_BuferDn[0] != 0 ) { Trigger2 = False ; alert_level =" ZZS: Level 2 High; "; if(Box_Alerts) Alert(alert_level,alert_message); if(Email_Alerts) SendMail(alert_level,alert_message);}
      }
      
      if ( Trigger3 &&  Alert_Lv3 ) 
      {     
        if( HP_BuferUp[0] != 0 ) { Trigger3 = False ; alert_level =" ZZS: Level 3 Low;  "; if(Box_Alerts) Alert(alert_level,alert_message); if(Email_Alerts) SendMail(alert_level,alert_message);}
        if( HP_BuferDn[0] != 0 ) { Trigger3 = False ; alert_level =" ZZS: Level 3 High; "; if(Box_Alerts) Alert(alert_level,alert_message); if(Email_Alerts) SendMail(alert_level,alert_message);}
      }

   OldBars = Bars ;   
   DrawLabels();
   
   return(0);
}
//================================================================
//    DrawLabels
//================================================================
void DrawLabels()
{
    string labName; 
    int win;
    long current_chart_id=ChartID();
    datetime t1;
      
      if(Period3 != 0)
      {
         labName = MyName + "SFB";
         win = ObjectFind(labName);
         t1 = Time[0] + Period()*60*6;
         
         if(win == -1)
         {
            ObjectCreate(current_chart_id, labName, OBJ_TEXT, ChartWindowFind(), t1, 1.2);
            Print("GetLastError() = ", GetLastError());
            ObjectSetText(labName, "СФБ", 8, NULL, Blue);
            ChartRedraw(current_chart_id);

         }
         else
         {
              ObjectSet(labName, OBJPROP_TIME1, t1);
              ObjectSet(labName, OBJPROP_PRICE1, 1.2);

         }
      }
      else
      {
         labName = MyName + "SFB";
         ObjectDelete(current_chart_id, labName);
      }
      
      
      if(Period2 != 0)
      {
         labName = MyName + "SFM";
         win = ObjectFind(labName);
         t1 = Time[0] + Period()*60*6;
         
         if(win == -1)
         {
            ObjectCreate(current_chart_id, labName, OBJ_TEXT, ChartWindowFind(), t1, 2.4);
            Print("GetLastError() = ", GetLastError());
            ObjectSetText(labName, "СФM", 8, NULL, Blue);
            ChartRedraw(current_chart_id);

         }
         else
         {
              ObjectSet(labName, OBJPROP_TIME1, t1);
              ObjectSet(labName, OBJPROP_PRICE1, 2.4);

         }
      }
      else
      {
         labName = MyName + "SFM";
         ObjectDelete(current_chart_id, labName);
      }
      
      
      if(Period1 != 0)
      {
         labName = MyName + "SFMM";
         win = ObjectFind(labName);
         t1 = Time[0] + Period()*60*6;
         
         if(win == -1)
         {
            ObjectCreate(current_chart_id, labName, OBJ_TEXT, ChartWindowFind(), t1, 3.6);
            Print("GetLastError() = ", GetLastError());
            ObjectSetText(labName, "СФMМ", 8, NULL, Blue);
            ChartRedraw(current_chart_id);

         }
         else
         {
              ObjectSet(labName, OBJPROP_TIME1, t1);
              ObjectSet(labName, OBJPROP_PRICE1, 3.6);

         }
      }
      else
      {
         labName = MyName + "SFMM";
         ObjectDelete(current_chart_id, labName);
      }
      
      
         
}

string TimeFrameToString(int tf)
{
   string tfs;
   switch(tf) {
      case PERIOD_M1:  tfs="M1"  ; break;
      case PERIOD_M5:  tfs="M5"  ; break;
      case PERIOD_M15: tfs="M15" ; break;
      case PERIOD_M30: tfs="M30" ; break;
      case PERIOD_H1:  tfs="H1"  ; break;
      case PERIOD_H4:  tfs="H4"  ; break;
      case PERIOD_D1:  tfs="D1"  ; break;
      case PERIOD_W1:  tfs="W1"  ; break;
      case PERIOD_MN1: tfs="MN";
   }
   return(tfs);
}
//+------------------------------------------------------------------+ 
void CountZZ( double& ExtMapBuffer[], double& ExtMapBuffer2[], int ExtDepth, int ExtDeviation, int ExtBackstep, int number, double& BufUp[], double& BufDn[] )
  {
   int    shift, back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;
   double bufValue; //***
   int i, direct;
   int limit;
   
   if(BarsCount == 0)
      limit = Bars-ExtDepth;
   else
      limit = BarsCount;
   
   
   bufValue = number;
   
   for(shift = limit; shift>=0; shift--)
     {
      val=Low[Lowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
        { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer[shift+back];
               if((res!=0)&&(res>val)) ExtMapBuffer[shift+back]=0.0; 
              }
           }
        } 
        
          ExtMapBuffer[shift]=val;
      //--- high
      val=High[Highest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
        {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=ExtMapBuffer2[shift+back];
               if((res!=0)&&(res<val)) ExtMapBuffer2[shift+back]=0.0; 
              } 
           }
        }
      ExtMapBuffer2[shift]=val;
     }
   // final cutting 
   lasthigh=-1; lasthighpos=-1;
   lastlow=-1;  lastlowpos=-1;

   for(shift=Bars-ExtDepth; shift>=0; shift--)
     {
      curlow=ExtMapBuffer[shift];
      curhigh=ExtMapBuffer2[shift];
      if((curlow==0)&&(curhigh==0)) continue;
      //---
      if(curhigh!=0)
        {
         if(lasthigh>0) 
           {
            if(lasthigh<curhigh) ExtMapBuffer2[lasthighpos]=0;
            else ExtMapBuffer2[shift]=0;
           }
         //---
         if(lasthigh<curhigh || lasthigh<0)
           {
            lasthigh=curhigh;
            lasthighpos=shift;
           }
         lastlow=-1;
        }
      //----
      if(curlow!=0)
        {
         if(lastlow>0)
           {
            if(lastlow>curlow) ExtMapBuffer[lastlowpos]=0;
            else ExtMapBuffer[shift]=0;
           }
         //---
         if((curlow<lastlow)||(lastlow<0))
           {
            lastlow=curlow;
            lastlowpos=shift;
           } 
         lasthigh=-1;
        }
     }
  
   for(shift=Bars-1; shift>=0; shift--)
     {
      if(shift>=Bars-ExtDepth) ExtMapBuffer[shift]=0.0;
      else
        {
         res=ExtMapBuffer2[shift];
         if(res!=0.0) ExtMapBuffer2[shift]=res;
        }
     }
     
     //
     for(i = limit; i>=0; i--)
     {
       if(ExtMapBuffer[i] !=0) 
       direct = 1;
      
       if(ExtMapBuffer2[i] !=0) 
       direct = -1;
       
       if(direct == 1)
       {
          BufUp[i] = bufValue;
          BufDn[i] = EMPTY_VALUE;
       }
       
       if(direct == -1)
       {
          BufUp[i] = EMPTY_VALUE;
          BufDn[i] = bufValue;
       }
       
       
     }
     
     
     
 }
//+------------------------------------------------------------------+   
int Str2Massive(string VStr, int& M_Count, int& VMass[])
  {
    int val=StrToInteger( VStr);
    if (val>0)
       {
         M_Count++;
         int mc=ArrayResize(VMass,M_Count);
         if (mc==0)return(-1);
          VMass[M_Count-1]=val;
         return(1);
       }
    else return(0);    
  } 
//+------------------------------------------------------------------+   
int IntFromStr(string ValStr,int& M_Count, int& VMass[])
  {
    
    if (StringLen(ValStr)==0) return(-1);
    string SS=ValStr;
    int NP=0; 
    string CS;
    M_Count=0;
    ArrayResize(VMass,M_Count);
    while (StringLen(SS)>0)
      {
            NP=StringFind(SS,",");
            if (NP>0)
               {
                 CS=StringSubstr(SS,0,NP);
                 SS=StringSubstr(SS,NP+1,StringLen(SS));  
               }
               else
               {
                 if (StringLen(SS)>0)
                    {
                      CS=SS;
                      SS="";
                    }
               }
            if (Str2Massive(CS,M_Count,VMass)==0) 
               {
                 return(-2);
               }
      }
    return(1);    
  }
//+------------------------------------------------------------------+ 