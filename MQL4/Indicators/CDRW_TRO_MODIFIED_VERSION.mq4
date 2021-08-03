//| CDRW_TRO_MODIFIED_VERSION                                  |
//| MODIFIED BY AVERY T. HORTON, JR. AKA THERUMPLEDONE@GMAIL.COM     |
//| I am NOT the ORIGINAL author 
//  and I am not claiming authorship of this indicator. 
//  All I did was modify it. I hope you find my modifications useful.|
//|                                                                  |
//+------------------------------------------------------------------+

// http://www.forexfactory.com/showpost.php?p=2772048&postcount=50
#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Magenta
#property indicator_color2 Aqua
#property indicator_color3 Red
#property indicator_color4 Yellow

extern int     NumberOfBars = 300;
extern double  Offset = 5;


double R[],D[],S[],W[];


string symbol, tChartPeriod,  tShortName ;  
int    digits, period, digits2  ; 
double point ;

double O,H,L,C,O1,H1,L1,C1,O2,H2,L2,C2;
 
//+------------------------------------------------------------------+
int init()
  {
  
   period       =  Period() ;    
   symbol       =  Symbol() ;
   digits       =  Digits ;   
   point        =  Point ;
     
//---- indicators
     Offset = Offset*Point;
     
      SetIndexBuffer(0,R);
      SetIndexStyle(0,DRAW_ARROW,0,2);
      SetIndexArrow(0, 119);
      SetIndexLabel(0,"Reversal");
      
      SetIndexBuffer(1,D);
      SetIndexStyle(1,DRAW_ARROW,0,0);
      SetIndexArrow(1, 233);
      SetIndexLabel(1,"Demand");
      
      SetIndexBuffer(2,S);
      SetIndexStyle(2,DRAW_ARROW,0,0);
      SetIndexArrow(2,234);
      SetIndexLabel(2,"Supply");
      
      SetIndexBuffer(3,W);
      SetIndexStyle(3,DRAW_ARROW,0,1);
      SetIndexArrow(3, 251);
      SetIndexLabel(3,"Warning");

//----
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
   
   double spd1,spd2,v1,v2;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=NumberOfBars; //Bars-counted_bars;

   for(int i=limit; i>=0; i--)   
      {
         O1 = iOpen(symbol,period,i+1);
         H1 = iHigh(symbol,period,i+1);
         L1 = iLow(symbol,period,i+1);
         C1 = iClose(symbol,period,i+1);

         H2 = iHigh(symbol,period,i+2);
         L2 = iLow(symbol,period,i+2);
      
         spd1 = H1 - L1;
         spd2 = H2 - L2;
         
         R[i]=0; D[i]=0; S[i]=0; W[i]=0;
         
         v1=iVolume(symbol,period,i+1);
         v2=iVolume(symbol,period,i+2);
   
         if ( spd1 > spd2 )
            {
               if ( v1 < v2 )
                  {
                     if ( H1-C1 < C1-L1 )
                        {
                           R[i+1] = H1 + Offset;
                           S[i+1] = 0;
                        }   
                     if ( H1-C1 > C1-L1 )
                        {
                           R[i+1] = L1 - Offset;
                           D[i+1] = 0;
                        }
                  }           
               if ( v1 > v2 )
                  {
                     if ( H1-C1 < C1-L1 )
                        {
                           D[i+1] = L1 - Offset;
                           R[i+1] = 0;
                        }            
                     if ( H1-C1 > C1-L1 )
                        {
                           S[i+1] = H1 + Offset;
                           R[i+1] = 0;
                        }   
                  }      
            }
                        
         if ( spd1 < spd2 )
            
               if ( v1 > v2 )
                  W[i+1] = H1 + Offset;            
      }
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+