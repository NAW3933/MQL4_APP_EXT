//+------------------------------------------------------------------
//|
//+------------------------------------------------------------------
#property copyright "mladen"
#property link      "www.forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1  DimGray
#property indicator_color2  DimGray
#property indicator_color3  DeepSkyBlue
#property indicator_color4  DeepSkyBlue
#property indicator_color5  PaleVioletRed
#property indicator_color6  PaleVioletRed
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2
#property indicator_width6  2
#property indicator_style1  STYLE_DOT
#property indicator_style2  STYLE_DOT
#property indicator_minimum 0

//
//
//
//
//

extern int  Length   = 32;
extern int  Price    = PRICE_CLOSE;
extern bool Inverted = true;

double uid[];
double uida[];
double uidb[];
double uiu[];
double uiua[];
double uiub[];
double price[];
double trend[];

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

int init()
{
   IndicatorBuffers(8);
      SetIndexBuffer(0,uiu);
      SetIndexBuffer(1,uid);
      SetIndexBuffer(2,uiua);
      SetIndexBuffer(3,uiub);
      SetIndexBuffer(4,uida);
      SetIndexBuffer(5,uidb);
      SetIndexBuffer(6,price);
      SetIndexBuffer(7,trend);
   IndicatorShortName("Dual Ulcer Index ("+Length+")");
   return(0); 
}
int deinit() { return(0); }

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

int start()
{
   int i,limit,counted_bars=IndicatorCounted();

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);

   //
   //
   //
   //
   //
   
   if (trend[limit]==-1) CleanPoint(limit,uida,uidb);
   if (trend[limit]== 1) CleanPoint(limit,uiua,uiub);
   for(i=limit; i>=0; i--)
   {
      price[i] = iMA(NULL,0,1,0,MODE_SMA,Price,i); if ((Bars-i)<Length) continue;

         //
         //
         //
         //
         //
         
         if (!Inverted)
         {
            double max = price[i+Length-1]; double sumsqd = 0;
            double min = price[i+Length-1]; double sumsqu = 0;
   
            for (int k = Length-2; k>=0; k--)
               {
                  if (price[i+k] > max)
                       max = price[i+k];
                  else sumsqd += MathPow(100.0*((max-price[i+k])/max),2);
                  if (price[i+k] < min)
                       min = price[i+k];
                  else sumsqu += MathPow(100.0*((price[i+k]-min)/min),2);
               }
         }
         else
         {
            max = price[i]; sumsqd = 0;
            min = price[i]; sumsqu = 0;
   
            for (k = 1; k<Length; k++)
               {
                  if (price[i+k] > max)
                       max = price[i+k];
                  else sumsqu += MathPow(100.0*((max-price[i+k])/max),2);
                  if (price[i+k] < min)
                       min = price[i+k];
                  else sumsqd += MathPow(100.0*((price[i+k]-min)/min),2);
               }
         }               

         //
         //
         //
         //
         //
         
         uiu[i] = MathSqrt(sumsqu/Length);
         uid[i] = MathSqrt(sumsqd/Length);
         uida[i] = EMPTY_VALUE;
         uidb[i] = EMPTY_VALUE;
         uiua[i] = EMPTY_VALUE;
         uiub[i] = EMPTY_VALUE;
            trend[i] = trend[i+1];
            if (uid[i] > uiu[i]) trend[i] = -1;
            if (uid[i] < uiu[i]) trend[i] =  1;
            if (trend[i] == -1) PlotPoint(i,uida,uidb,uid);
            if (trend[i] ==  1) PlotPoint(i,uiua,uiub,uiu);
   }     
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i]   = EMPTY_VALUE;
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
         first[i]   = from[i];
         second[i]  = EMPTY_VALUE;
      }
}