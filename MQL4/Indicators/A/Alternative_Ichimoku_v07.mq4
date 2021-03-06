//+----------------------------------------------------------+
//|                           Alternative_Ichimoku_v07.mq4   |
//|                            Copyright © april 2007 v.07   |
//|                Lukashuk Victor Gennadievich aka lukas1   |
//+----------------------------------------------------------+
#property copyright "Copyright © 2007, lukas1"
#property link ""
//----
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 LightPink
#property indicator_color2 LightSteelBlue
#property indicator_color3 LightPink
#property indicator_color4 LightSteelBlue
#property indicator_width1 2
#property indicator_width2 2
#property indicator_color5 Blue
#property indicator_color6 Magenta
//---- input parameters
// calculating period
extern int SSP = 75; 
//  tolerance of second line
extern int SSK = 75; 
// do not show middle line
extern bool Show_Middle = false; 
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double Wal1[];
double Wal2[];
double ExtMapBuffer4[], ExtMapBuffer5[];
int i, j;
double SsMax, SsMin, SsMax05, SsMin05, Rsmin, Rsmax, 
       Tsmin, Tsmax;
double Day_max, Day_min;
int val1, val2, AvgRange, day_bars, day_Range, 
    delta_from_max, delta_from_min, spred;
string comm, sutki;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(8);
//----
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexDrawBegin(0, SSP*2);
// priority line
   SetIndexLabel(0, "îïåðåæàþùàÿ ëèíèÿ"); 
//----
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexDrawBegin(1, SSP*2);
// overdue line
   SetIndexLabel(1, "çàïàçäûâþùàÿ ëèíèÿ"); 
//----
   SetIndexStyle(2, DRAW_HISTOGRAM);
   SetIndexBuffer(2, Wal1);
   SetIndexDrawBegin(2,SSP*2);
//----
   SetIndexStyle(3, DRAW_HISTOGRAM);
   SetIndexBuffer(3, Wal2);
   SetIndexDrawBegin(3,SSP*2);
//----
   SetIndexStyle(4, DRAW_LINE);
   SetIndexBuffer(4, ExtMapBuffer4);
   SetIndexDrawBegin(4,SSP*2);
// stop-order line
   SetIndexLabel(4,"ëèíèÿ ñòîï-îðäåðà"); 
//----      
   SetIndexStyle(5, DRAW_LINE);
   SetIndexBuffer(5, ExtMapBuffer5);
   SetIndexDrawBegin(5,SSP*2);
// middle line 
   SetIndexLabel(5,"ñðåäíÿÿ ëèíèÿ");      
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() 
  {
   Comment("");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   comm= ""; 
   int counted_bars = IndicatorCounted();
   if(Bars <= SSP + 1)
       return(0);
   i = Bars - counted_bars;
   if(counted_bars==0) i-=(SSP+1);
   while(i >= 0)
     {
       // RefreshRates();
       // maximum of previous SSP bars period
       SsMax = High[iHighest(NULL, 0, MODE_HIGH, SSP, i)];      
       // minimum of previous SSP bars period
       SsMin = Low[iLowest(NULL, 0, MODE_LOW, SSP, i)];         
       // maximum of SSP bars period for SSK bars from begin
       SsMax05 = High[iHighest(NULL, 0, MODE_HIGH, SSP, i + SSK)];
       // maximum of SSP bars period for SSK bars from begin
       SsMin05 = Low[iLowest(NULL, 0, MODE_LOW, SSP, i + SSK)];   
       ExtMapBuffer1[i] = (SsMax + SsMin) / 2;
       ExtMapBuffer2[i] = (SsMax05 + SsMin05) / 2;
       val1 = ExtMapBuffer1[1] / Point;
       val2 = ExtMapBuffer2[1] / Point;
       //for volatility
       Rsmax = High[iHighest(NULL, 0, MODE_HIGH, SSP*2, i)];
       //for volatility
       Rsmin = Low[iLowest(NULL, 0, MODE_LOW, SSP*2, i)];
       //LOGISTIC OF THE COOKING CLUB??????
       Wal1[i] = ExtMapBuffer1[i]; 
       // the library of the bright cloud????
       Wal2[i] = ExtMapBuffer2[i]; 
       // stop line  
       Tsmax = High[iHighest(NULL, 0,MODE_HIGH, SSP*1.62, i)];   
       // stop line
       Tsmin = Low[iLowest(NULL, 0, MODE_LOW, SSP*1.62, i)];       
       ExtMapBuffer4[i] = (Tsmax + Tsmin) / 2;
       //----
       if(Show_Middle)
         {
           ExtMapBuffer5[i] = ((SsMax + SsMin) / 2 + 
                              (SsMax05 + SsMin05) / 2  ) / 2;
         }
       i--;
     }
   day_bars = MathCeil(1440 / Period());
   //if (Period()==1440) day_bars=5;
   sutki = "days";
   if(Period() == 1440)  
     {
       sutki = "week";
       day_bars = 5;
     }  // äåíü
   if(Period() == 10080) 
     {
       sutki = "month"; 
       day_bars = 4;
     }  // íåäåëÿ
   if(Period() == 43200) 
     {
       sutki = "year";  
       day_bars = 12;
     }  // ìåñÿö
   j = SSP*2 + 1;
   while(j >= 0)
     { 
        // define a day range
        // line maks dn 
       Day_max = High[iHighest(NULL, 0,MODE_HIGH, day_bars, j + 1)];   
       // line min. äíÿ
       Day_min = Low[iLowest(NULL, 0, MODE_LOW, day_bars, j + 1)];           
       j--;
     }      
   AvgRange = (Rsmax / Point) - (Rsmin / Point);
   day_Range = (Day_max / Point) - (Day_min / Point); 
   delta_from_max = (Day_max-Bid) / Point;
   delta_from_min = (Bid - Day_min) / Point;
//----
   comm = " parameters  SSP , SSK  =   " + SSP + " ,  " + SSK + " ;\n" +
          " volatility (for " + SSP*2 + " bars) :      " + 
          AvgRange + "  ï.\n" + "\n" +
          " range for " + sutki + "  (for  " + day_bars + 
          "  bars) :   " + day_Range + "  ï.\n" +
          " Decommissioning from the maximum for " + sutki + ":  " + 
          delta_from_max + "  ï.\n" +
          " Decommissioning from the minimum for" + sutki + ":  " + 
          delta_from_min + "  ï.\n";            
   Comment(comm);
//----
   return(0);
  }
//+------------------------------------------------------------------+

