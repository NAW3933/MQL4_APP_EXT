//+------------------------------------------------------------------+
//|                                                       adxvma.mq4 |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "www.forex-tsd.com"


#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1  DimGray  
#property indicator_color2  DeepSkyBlue 
#property indicator_color3  DeepSkyBlue 
#property indicator_color4  OrangeRed
#property indicator_color5  OrangeRed 
#property indicator_color6  DimGray
#property indicator_color7  DimGray
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2

//
//
//
//
//

extern string TimeFrame         = "Current time frame";
extern double AdxVmaPeriod      = 10;
extern int    AdxVmaPrice       = PRICE_MEDIAN;
extern double BandsDevPeriod    = 20;
extern double BandsSmoothPeriod = 20;
extern double BandsMultiplier   = 3;
extern bool   TrendMode         = True;
extern bool   Interpolate       = true;

//
//
//
//
//

double adxvma[];
double adxvmua[];
double adxvmub[];
double adxvmda[];
double adxvmdb[];
double bandUp[];
double bandDn[];
double trend[];

//
//
//
//
//

string indicatorFileName;
bool   calculateValue;
bool   returnBars;
int    timeFrame;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   IndicatorBuffers(8);
   SetIndexBuffer(0,adxvma);
   SetIndexBuffer(1,adxvmua);
   SetIndexBuffer(2,adxvmub);
   SetIndexBuffer(3,adxvmda);
   SetIndexBuffer(4,adxvmdb);
   SetIndexBuffer(5,bandUp);
   SetIndexBuffer(6,bandDn);
   SetIndexBuffer(7,trend);

      //
      //
      //
      //
      //

      AdxVmaPeriod      = MathMax(AdxVmaPeriod,1);
      indicatorFileName = WindowExpertName();
      calculateValue    = (TimeFrame=="CalculateValue"); if (calculateValue) return(0);
      returnBars        = (TimeFrame=="returnBars");     if (returnBars)     return(0);
      timeFrame         = stringToTimeFrame(TimeFrame);

   //
   //
   //
   //
   //
   
   IndicatorShortName(timeFrameToString(timeFrame)+" AdxVma ("+DoubleToStr(AdxVmaPeriod,2)+")");
   return(0);
}
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

double work[];

int start()
{
   int counted_bars = IndicatorCounted();
   int i,r,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=MathMin(Bars-counted_bars,Bars-1);
           if (returnBars) { adxvma[0] = limit+1; return(0); }

   //
   //
   //
   //
   //
   
   if (calculateValue || timeFrame == Period())
   {
      if (ArraySize(work)!=Bars) ArrayResize(work,Bars);
      if (!calculateValue && trend[limit]== 1) CleanPoint(limit,adxvmua,adxvmub);
      if (!calculateValue && trend[limit]==-1) CleanPoint(limit,adxvmda,adxvmdb);
      
      //
      //
      //
      //
      //
      
      for(i = limit, r=Bars-i-1; i >= 0; i--,r++)
      {
         work[r]   = iMA(NULL,0,1,0,MODE_SMA,AdxVmaPrice,i);
         adxvma[i] = iAdxvma(work[r],AdxVmaPeriod,i,1);
         double dev=0;
            for (int j=0; j<BandsDevPeriod && (r-j)>=0; j++) dev += (work[r-j]-adxvma[i])*(work[r-j]-adxvma[i]);
                                                          dev = MathSqrt(dev/BandsDevPeriod);
         double range      = iAdxvma(dev,BandsSmoothPeriod,i,0);
                bandUp[i]  = adxvma[i]+BandsMultiplier*range;
                bandDn[i]  = adxvma[i]-BandsMultiplier*range;
                adxvmua[i] = EMPTY_VALUE;
                adxvmub[i] = EMPTY_VALUE;
                adxvmda[i] = EMPTY_VALUE;
                adxvmdb[i] = EMPTY_VALUE;

            if (TrendMode)
                  trend[i] = trend[i+1];
            else  trend[i] = 0;
            if (adxvma[i]>adxvma[i+1]) trend[i] =  1;
            if (adxvma[i]<adxvma[i+1]) trend[i] = -1;
            if (!calculateValue && trend[i]== 1) PlotPoint(i,adxvmua,adxvmub,adxvma);
            if (!calculateValue && trend[i]==-1) PlotPoint(i,adxvmda,adxvmdb,adxvma);
      }
      return(0);
   }
   
   
   //
   //
   //
   //
   //
   
   limit = MathMax(limit,MathMin(Bars,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
   if (trend[limit]== 1) CleanPoint(limit,adxvmua,adxvmub);
   if (trend[limit]==-1) CleanPoint(limit,adxvmda,adxvmdb);
   for (i=limit;i>=0;i--)
   {
      int y = iBarShift(NULL,timeFrame,Time[i]);
         adxvma[i]  = iCustom(NULL,timeFrame,indicatorFileName,"CalculateValue",AdxVmaPeriod,AdxVmaPrice,BandsDevPeriod,BandsSmoothPeriod,BandsMultiplier,TrendMode,0,y);
         bandUp[i]  = iCustom(NULL,timeFrame,indicatorFileName,"CalculateValue",AdxVmaPeriod,AdxVmaPrice,BandsDevPeriod,BandsSmoothPeriod,BandsMultiplier,TrendMode,5,y);
         bandDn[i]  = iCustom(NULL,timeFrame,indicatorFileName,"CalculateValue",AdxVmaPeriod,AdxVmaPrice,BandsDevPeriod,BandsSmoothPeriod,BandsMultiplier,TrendMode,6,y);
         trend[i]   = iCustom(NULL,timeFrame,indicatorFileName,"CalculateValue",AdxVmaPeriod,AdxVmaPrice,BandsDevPeriod,BandsSmoothPeriod,BandsMultiplier,TrendMode,7,y);
         adxvmua[i] = EMPTY_VALUE;
         adxvmub[i] = EMPTY_VALUE;
         adxvmda[i] = EMPTY_VALUE;
         adxvmdb[i] = EMPTY_VALUE;

         //
         //
         //
         //
         //
      
            if (timeFrame <= Period() || y==iBarShift(NULL,timeFrame,Time[i-1])) continue;
            if (!Interpolate) continue;

         //
         //
         //
         //
         //

         datetime time = iTime(NULL,timeFrame,y);
            for(int n = 1; i+n < Bars && Time[i+n] >= time; n++) continue;	
            for(int k = 1; k < n; k++)
            {
               adxvma[i+k] = adxvma[i] + (adxvma[i+n]-adxvma[i])*k/n;
               bandUp[i+k] = bandUp[i] + (bandUp[i+n]-bandUp[i])*k/n;
               bandDn[i+k] = bandDn[i] + (bandDn[i+n]-bandDn[i])*k/n;
            }               
   }
   for (i=limit;i>=0;i--)
   {
      if (trend[i]== 1) PlotPoint(i,adxvmua,adxvmub,adxvma);
      if (trend[i]==-1) PlotPoint(i,adxvmda,adxvmdb,adxvma);
   }
   
   //
   //
   //
   //
   //
      
   return(0);
         
}



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

double  workVma[][14];
#define prc 0
#define pdm 1
#define mdm 2
#define pdi 3
#define mdi 4
#define out 5
#define vma 6

//
//
//
//
//

double iAdxvma(double price, double period, int i, int s)
{
   if (period <= 1) return(price);
   if (ArrayRange(workVma,0)!=Bars) ArrayResize(workVma,Bars);
      int r=Bars-i-1; s = s*7;
         workVma[r][s+prc] = price;

         //
         //
         //
         //
         //
            
         double diff = workVma[r][s+prc]-workVma[r-1][s+prc];
         double tpdm = 0;
         double tmdm = 0;
               if (diff>0)
                     tpdm =  diff;
               else  tmdm = -diff;          
         workVma[r][s+pdm] = ((period-1.0)*workVma[r-1][s+pdm]+tpdm)/period;
         workVma[r][s+mdm] = ((period-1.0)*workVma[r-1][s+mdm]+tmdm)/period;

         //
         //
         //
         //
         //

         double trueRange = workVma[r][s+pdm]+workVma[r][s+mdm];
         double tpdi      = 0;
         double tmdi      = 0;
               if (trueRange>0)
               {
                  tpdi = workVma[r][s+pdm]/trueRange;
                  tmdi = workVma[r][s+mdm]/trueRange;
               }            
         workVma[r][s+pdi] = ((period-1.0)*workVma[r-1][s+pdi]+tpdi)/period;
         workVma[r][s+mdi] = ((period-1.0)*workVma[r-1][s+mdi]+tmdi)/period;
   
         //
         //
         //
         //
         //
                  
         double tout  = 0; if ((workVma[r][s+pdi]+workVma[r][s+mdi])>0) tout = MathAbs(workVma[r][s+pdi]-workVma[r][s+mdi])/(workVma[r][s+pdi]+workVma[r][s+mdi]);
         workVma[r][s+out] = ((period-1.0)*workVma[r-1][s+out]+tout)/period;

         //
         //
         //
         //
         //
                 
         double thi = MathMax(workVma[r][s+out],workVma[r-1][s+out]);
         double tlo = MathMin(workVma[r][s+out],workVma[r-1][s+out]);
            for (int j = 2; j<period; j++)
            {
               thi = MathMax(workVma[r-j][s+out],thi);
               tlo = MathMin(workVma[r-j][s+out],tlo);
            }            
         double vi = 0; if ((thi-tlo)>0) vi = (workVma[r][s+out]-tlo)/(thi-tlo);

      //
      //
      //
      //
      //
         
      workVma[r][s+vma] = ((period-vi)*workVma[r-1][s+vma]+vi*workVma[r][s+prc])/period;
      return(workVma[r][s+vma]);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

//
//
//
//
//

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
      {
         if (first[i+2] == EMPTY_VALUE) {
                first[i]   = from[i];
                first[i+1] = from[i+1];
                second[i]  = EMPTY_VALUE;
            }
         else {
                second[i]   =  from[i];
                second[i+1] =  from[i+1];
                first[i]    = EMPTY_VALUE;
            }
      }
   else
      {
         first[i]  = from[i];
         second[i] = EMPTY_VALUE;
      }
}


//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

//
//
//
//
//

int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],Period()));
                                                      return(Period());
}
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int char = StringGetChar(s, length);
         if((char > 96 && char < 123) || (char > 223 && char < 256))
                     s = StringSetChar(s, length, char - 32);
         else if(char > -33 && char < 0)
                     s = StringSetChar(s, length, char + 224);
   }
   return(s);
}