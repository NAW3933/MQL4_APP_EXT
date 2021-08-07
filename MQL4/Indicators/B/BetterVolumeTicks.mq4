//+------------------------------------------------------------------+
//|   BetterVolumeTicks.mq4
//+------------------------------------------------------------------+
#property indicator_separate_window
#include <stdlib.mqh>
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 DarkGray
#property indicator_color3 Yellow
#property indicator_color4 Lime
#property indicator_color5 White
#property indicator_color6 Magenta
#property indicator_color7 Maroon

extern int     VolPeriod = 100;
extern int     LookBack = 20;

double CountUp,CountDn;
double HiVol,LoVol,HiUpTick,HiDnTick,MaxVol,ev=EMPTY_VALUE,Range,MyPoint;

double ClimaxHi[];
double Neutral[];
double LoVolume[];
double Churn[];
double ClimaxLo[];
double ClimaxChurn[];
double AvgVol[];

double UpTicks[];
double DnTicks[];
double VolRange[];
double VolSort[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   ArraySetAsSeries(UpTicks,true);
   ArraySetAsSeries(DnTicks,true);
   ArraySetAsSeries(VolRange,true);
   ArraySetAsSeries(VolSort,true);

   IndicatorBuffers(7);
      
   SetIndexBuffer(0,ClimaxHi);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);

   SetIndexBuffer(1,Neutral);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);

   SetIndexBuffer(2,LoVolume);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2);

   SetIndexBuffer(3,Churn);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,2);

   SetIndexBuffer(4,ClimaxLo);
   SetIndexStyle(4,DRAW_HISTOGRAM,0,2);

   SetIndexBuffer(5,ClimaxChurn);
   SetIndexStyle(5,DRAW_HISTOGRAM,0,2);

   SetIndexBuffer(6,AvgVol);
   SetIndexStyle(6,DRAW_LINE,0,2);

   IndicatorShortName("Better Volume Ticks" );
      
	if (Digits == 5 || (Digits == 3 && StringFind(Symbol(), "JPY") != -1))
	{
      MyPoint = Point*10;
	}
	else
	if (Digits == 6 || (Digits == 4 && StringFind(Symbol(), "JPY") != -1))
	{
      MyPoint = Point*100;
	}
	else
	{MyPoint = Point;}

   return(0);
}

int deinit()
{
  
   return(0);

}

int start()
{
   int i;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1); //---- check for possible errors
   if(counted_bars>0) counted_bars--; //---- last counted bar will be recounted
   
   for (i=Bars-counted_bars;i>=0;i--)
   {
      ResizeArrays();
      
      VolSort[i] = Volume[i];
      AvgVol[i] = NormalizeDouble(iMAOnArray(VolSort,0,VolPeriod,0,MODE_SMA,i),0);
   }   

   for (i=Bars-counted_bars;i>=0;i--)
   {
      Range = High[i]-Low[i];

      CountUp = (Volume[i]+(Close[i]-Open[i])/MyPoint)/2;
      CountDn = Volume[i]-UpTicks[i];

      UpTicks[i] = CountUp*Range;
      DnTicks[i] = CountDn*Range;
      if (!CompareDoubles(Range,0))
      {VolRange[i] = Volume[i]/Range;}

      LoVol = Volume[iLowest(NULL,0,MODE_VOLUME,LookBack,i)];
      HiVol = Volume[iHighest(NULL,0,MODE_VOLUME,LookBack,i)];

      HiUpTick = UpTicks[FindMaxUp(i)];
      HiDnTick = DnTicks[FindMaxDn(i)];
      MaxVol = VolRange[FindMaxVol(i)];
      
      Neutral[i] = NormalizeDouble(Volume[i],0);
      ClimaxHi[i] = ev;      
      ClimaxLo[i] = ev;      
      Churn[i] = ev;      
      LoVolume[i] = ev;      
      ClimaxChurn[i] = ev;      
      
      if (CompareDoubles(Volume[i],LoVol))
      {
         LoVolume[i] = NormalizeDouble(Volume[i],0);
         Neutral[i] = ev;
      }

      if (CompareDoubles(VolRange[i],MaxVol))
      {
         Churn[i] = NormalizeDouble(Volume[i],0);                
         Neutral[i] = ev;
         LoVolume[i] = ev;
      }

      if (CompareDoubles(UpTicks[i],HiUpTick) && Close[i] >= (High[i]+Low[i])/2)
      {

         ClimaxHi[i] = NormalizeDouble(Volume[i],0);
         Neutral[i] = ev;
         LoVolume[i] = ev;
         Churn[i] = ev;
      }   
         
      if (CompareDoubles(DnTicks[i],HiDnTick) && Close[i] <= (High[i]+Low[i])/2)
      {
         ClimaxLo[i] = NormalizeDouble(Volume[i],0);
         Neutral[i] = ev;
         LoVolume[i] = ev;
         Churn[i] = ev;
      }   
         
      if (CompareDoubles(VolRange[i],MaxVol) && (ClimaxHi[i] < ev || ClimaxLo[i] < ev))
      {
         ClimaxChurn[i] = NormalizeDouble(Volume[i],0);
         ClimaxHi[i] = ev;
         ClimaxLo[i] = ev;
         Churn[i] = ev;
         Neutral[i] = ev;
      }
   }

   return(0);
}

int FindMaxUp(int i)      
{
   int x,y;
   double max=0;
   for(x=LookBack-1;x>=0;x--)
   {
      if(UpTicks[i+x] > max)
      {
         y = i+x;
         max = UpTicks[y];
      }
   }
   return(y);
}

int FindMaxDn(int i)      
{
   int x,y;
   double max=0;
   for(x=LookBack-1;x>=0;x--)
   {
      if(DnTicks[i+x] > max)
      {
         y = i+x;
         max = DnTicks[y];
      }
   }
   return(y);
}

int FindMaxVol(int i)      
{
   int x,y;
   double max=0;
   for(x=LookBack-1;x>=0;x--)
   {
      if(VolRange[i+x] > max)
      {
         y = i+x;
         max = VolRange[y];
      }
   }
   return(y);
}

void ResizeArrays()
{
   ArrayResize(UpTicks,Bars);
   ArrayResize(DnTicks,Bars);
   ArrayResize(VolRange,Bars);
   ArrayResize(VolSort,Bars);
}
//+------------------------------------------------------------------+
         