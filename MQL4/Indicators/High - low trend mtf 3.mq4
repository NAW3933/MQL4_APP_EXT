//+------------------------------------------------------------------
//|                                                     
//+------------------------------------------------------------------
#property copyright "mladen"
#property link      "mladenfx@gmail.com"
#property link      "www.forex-station.com"

#property indicator_chart_window
#property indicator_buffers 9
#property indicator_color1  clrDimGray
#property indicator_color2  clrDimGray
#property indicator_color3  clrDimGray
#property indicator_color4  clrDeepSkyBlue
#property indicator_color5  clrDeepSkyBlue
#property indicator_color6  clrPaleVioletRed
#property indicator_color7  clrPaleVioletRed
#property indicator_color8  clrDeepSkyBlue
#property indicator_color9  clrPaleVioletRed
#property indicator_style1  STYLE_DOT
#property indicator_style2  STYLE_DOT
#property indicator_style3  STYLE_DOT
#property indicator_width8  2
#property indicator_width9  2
#property strict

//
//
//
//
//

extern ENUM_TIMEFRAMES TimeFrame       = PERIOD_CURRENT;  // Time frame
extern int             HighLowPeriod   = 10;              // High low period
extern int             ZigZagLineWidth = 0;               // Lines width
extern bool            Interpolate     = true;            // Interpolate in multi time frame mode?

double peakUp[],peakDn[],legUpa[],legUpb[],legDna[],legDnb[],limHi[],limMi[],limLo[],leg[],zigzag[],trend[],count[];
string indicatorFileName;
#define _mtfCall(_buf,_ind) iCustom(NULL,TimeFrame,indicatorFileName,0,HighLowPeriod,_buf,_ind)

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
   IndicatorBuffers(13);
      SetIndexBuffer(0,limHi);
      SetIndexBuffer(1,limMi);
      SetIndexBuffer(2,limLo);
      SetIndexBuffer(3,legUpa); SetIndexStyle(3,EMPTY,EMPTY,ZigZagLineWidth);
      SetIndexBuffer(4,legUpb); SetIndexStyle(4,EMPTY,EMPTY,ZigZagLineWidth);
      SetIndexBuffer(5,legDna); SetIndexStyle(5,EMPTY,EMPTY,ZigZagLineWidth);
      SetIndexBuffer(6,legDnb); SetIndexStyle(6,EMPTY,EMPTY,ZigZagLineWidth);
      SetIndexBuffer(7,peakUp); SetIndexStyle(7,DRAW_ARROW); SetIndexArrow(7,159);
      SetIndexBuffer(8,peakDn); SetIndexStyle(8,DRAW_ARROW); SetIndexArrow(8,159);
      SetIndexBuffer(9,leg);
      SetIndexBuffer(10,trend);
      SetIndexBuffer(11,zigzag);
      SetIndexBuffer(12,count);
   
      //
      //
      //
      //
      //
      
         indicatorFileName = WindowExpertName();
         TimeFrame         = MathMax(TimeFrame,_Period);
   return(0);
}
int deinit()
{
   return(0);
}

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
   int counted_bars=IndicatorCounted();
      if (counted_bars<0) return(-1);
      if (counted_bars>0) counted_bars--;
          int limit = MathMin(Bars-counted_bars,Bars-1);
          int countz = 0;
            int k = limit; for (; k<Bars && countz<2; k++)
            {
               if (peakUp[k] != EMPTY_VALUE) countz ++;
               if (peakDn[k] != EMPTY_VALUE) countz ++;
            }
            count[0] = k;
            if (TimeFrame != _Period)
            {
               limit = (int)MathMax(limit,MathMin(Bars-1,_mtfCall(12,0)*TimeFrame/Period()));
               if (trend[limit]== 1) CleanPoint(limit,legUpa,legUpb);
               if (trend[limit]==-1) CleanPoint(limit,legDna,legDnb);
               for (int i=limit; i>=0; i--)
               {
                  int y = iBarShift(NULL,TimeFrame,Time[i]);
                  int x = (i<Bars-1) ? iBarShift(NULL,TimeFrame,Time[i+1]) : y;
                  if (Interpolate) x = (i>0) ? iBarShift(NULL,TimeFrame,Time[i-1]) : x;
                     limHi[i]  = _mtfCall( 0,y);
                     limMi[i]  = _mtfCall( 1,y);
                     limLo[i]  = _mtfCall( 2,y);
                     trend[i]  = _mtfCall(10,y);
                     zigzag[i] = _mtfCall(11,y);
                     peakUp[i] = EMPTY_VALUE;
                     peakDn[i] = EMPTY_VALUE;
                     if (x!=y)
                     {
                        peakUp[i] = _mtfCall(7,y);
                        peakDn[i] = _mtfCall(8,y);
                     }
         
                     //
                     //
                     //
                     //
                     //

                        if (!Interpolate || (i>0 && y==iBarShift(NULL,TimeFrame,Time[i-1]))) continue;
                           #define _interpolate(_buff) _buff[i+k] = _buff[i]+(_buff[i+n]-_buff[i])*k/n
                           int n; datetime time = iTime(NULL,TimeFrame,y);
                              for(n = 1; (i+n)<Bars && Time[i+n]>=time; n++) continue;	
                              for(k = 1; (k<n) && (i+n)<Bars && (i+k)<Bars; k++)
                              {
                                 _interpolate(limHi); 
                                 _interpolate(limLo); 
                                 _interpolate(limMi); 
                                 if (zigzag[i]!=EMPTY_VALUE) _interpolate(zigzag); 
                           }               
                  }
                  for (int i=limit; i>=0; i--)
                  {
                     legDna[i]  = EMPTY_VALUE; 
                     legDnb[i]  = EMPTY_VALUE; 
                     legUpa[i]  = EMPTY_VALUE; 
                     legUpb[i]  = EMPTY_VALUE; 
                     if (trend[i]== 1) PlotPoint(i,legUpa,legUpb,zigzag);
                     if (trend[i]==-1) PlotPoint(i,legDna,legDnb,zigzag);
                  }
                  return(0);
            }
            
   //
   //
   //
   //
   //
   
      if (trend[limit]== 1) CleanPoint(limit,legUpa,legUpb);
      if (trend[limit]==-1) CleanPoint(limit,legDna,legDnb);
      for (int i=limit,n=0; i>=0; i--)
      {
         peakUp[i] = EMPTY_VALUE;
         peakDn[i] = EMPTY_VALUE;
         zigzag[i] = EMPTY_VALUE;
         limHi[i]  = High[ArrayMaximum(High,HighLowPeriod,i)];
         limLo[i]  = Low[ArrayMinimum(Low,HighLowPeriod,i)];
         limMi[i]  = (limHi[i]+limLo[i])/2.0;
         leg[i]    = (i<Bars-1) ? leg[i+1] : 0;
      
         if ((i<Bars-1) && limHi[i]>limHi[i+1]) leg[i] = MathMax( 1,leg[i+1]+1);
         if ((i<Bars-1) && limLo[i]<limLo[i+1]) leg[i] = MathMin(-1,leg[i+1]-1);
         if (leg[i] > 0 && leg[i] != leg[i+1]) { if (leg[i]>1) cleanUppeak(i); peakUp[i] = High[i]; }
         if (leg[i] < 0 && leg[i] != leg[i+1]) { if (leg[i]<1) cleanDnpeak(i); peakDn[i] = Low[i];  }
         
         //
         //
         //
         //
         //
         
         trend[i] = (i<Bars-1) ? trend[i+1] : 0;
         if (peakUp[i] != EMPTY_VALUE || peakDn[i] != EMPTY_VALUE)
         {
            if (peakUp[i] != EMPTY_VALUE)
            {
                  for(n = 1; i+n < Bars-1 && peakUp[i+n]==EMPTY_VALUE; n++) continue; if (peakUp[i+n]<peakUp[i]) trend[i] = 1;
                  for(n = 1; i+n < Bars-1 && peakDn[i+n]==EMPTY_VALUE; n++) continue;
            }
            if (peakDn[i] != EMPTY_VALUE)
            {
                  for(n = 1; i+n < Bars-1 && peakDn[i+n]==EMPTY_VALUE; n++) continue; if (peakDn[i+n]>peakDn[i]) trend[i] = -1;
                  for(n = 1; i+n < Bars-1 && peakUp[i+n]==EMPTY_VALUE; n++) continue;
            }
            
            //
            //
            //
            //
            //
            
            if (trend[i] == 1)
                  if (peakUp[i] != EMPTY_VALUE) 
                        { zigzag[i] = peakUp[i]; zigzag[i+n] = peakDn[i+n]; }
                  else  { zigzag[i] = peakDn[i]; zigzag[i+n] = peakUp[i+n]; }
            else
                  if (peakUp[i] != EMPTY_VALUE) 
                        { zigzag[i] = peakUp[i]; zigzag[i+n] = peakDn[i+n]; }
                  else  { zigzag[i] = peakDn[i]; zigzag[i+n] = peakUp[i+n]; }
            
            //
            //
            //
            //
            //
            
            for(k=1; k<n; k++)
            {
               zigzag[i+k] = zigzag[i] + (zigzag[i+n]-zigzag[i])*k/n;
               trend[i+k]  = trend[i];
            }  	            
            for(k=n-1; k>=0; k--)
            {
               legDna[i+k]  = EMPTY_VALUE; 
               legDnb[i+k]  = EMPTY_VALUE; 
               legUpa[i+k]  = EMPTY_VALUE; 
               legUpb[i+k]  = EMPTY_VALUE; 
                  if (trend[i]== 1) PlotPoint(i+k,legUpa,legUpb,zigzag);
                  if (trend[i]==-1) PlotPoint(i+k,legDna,legDnb,zigzag);
            }                  
         }               
      }
      return(0);
}

//+------------------------------------------------------------------
//|                                                                  
//+------------------------------------------------------------------
//
//
//
//
//

void cleanUppeak(int i)
{
   for (int k=i+1; k<Bars && peakDn[k]==EMPTY_VALUE; k++) 
         if (peakUp[k] != EMPTY_VALUE) { peakUp[k]=EMPTY_VALUE; break; }
}
void cleanDnpeak(int i)
{
   for (int k=i+1; k<Bars && peakUp[k]==EMPTY_VALUE; k++) 
         if (peakDn[k] != EMPTY_VALUE) { peakDn[k]=EMPTY_VALUE; break; }
}
//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if (i>=Bars-3) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (i>=Bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i];  first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] =  from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                           second[i] = EMPTY_VALUE; }
}