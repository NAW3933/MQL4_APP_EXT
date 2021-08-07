
#property copyright ""
#property link      ""

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Aqua
#property indicator_color2 Red
#property indicator_color3 Lime

extern int     MAPeriod = 100;
extern int     LookBack = 20;
extern bool    AlertOn = true;
extern double  Offset = 5;

int NumberOfBars;
datetime       alertonce = 0;
double R[],D[],S[],W[];
bool redVol;
bool whiteVol;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
      Offset = Offset*Point;

      SetIndexBuffer(0,D);
      SetIndexStyle(0,DRAW_ARROW,0,0);
      SetIndexArrow(0, 233);
      SetIndexLabel(0,"Demand");
      
      SetIndexBuffer(1,S);
      SetIndexStyle(1,DRAW_ARROW,0,0);
      SetIndexArrow(1,234);
      SetIndexLabel(1,"Supply");
      
      SetIndexBuffer(2,W);
      SetIndexStyle(2,DRAW_ARROW,0,1);
      SetIndexArrow(2, 251);
      SetIndexLabel(2,"debug");
      
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
   //BetVol vars
   double VolLowest,Range,Value2,Value3,HiValue2,HiValue3,LoValue3,tempv2,tempv3,tempv;
   int limit;
   string cdrwsl,cdrwen,cdrwbe,cdrwtp;
   int counted_bars=IndicatorCounted();
   //CDRW Vars
   double spd1,spd2,v1,v2;
   
   //---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;   
      
   for(int i=limit; i>=0; i--)  
   //for(int i=0; i<limit; i++)   
      {
            
                     //---------- BEGIN Bet Vol Code   ---------------\\
         Value2=0;Value3=0;HiValue2=0;HiValue3=0;LoValue3=99999999;tempv2=0;tempv3=0;tempv=0;
         VolLowest = Volume[iLowest(NULL,0,MODE_VOLUME,20,i+1)];  
         Range = (High[i+1]-Low[i+1]);
         Value2 = Volume[i+1]*Range;
         if (  Range != 0 )
            Value3 = Volume[i+1]/Range;
         
         redVol = false;  
         whiteVol = false;              
         
         for ( int n=i+1;n<i+MAPeriod;n++ )
            {
               tempv= Volume[n+1] + tempv; 
            } 

          for ( n=i+1;n<i+LookBack;n++)
            {
               tempv2 = Volume[n]*((High[n]-Low[n])); 
               if ( tempv2 >= HiValue2 )
                  HiValue2 = tempv2;
                    
               if ( Volume[n]*((High[n]-Low[n])) != 0 )
                  {           
                     tempv3 = Volume[n] / ((High[n]-Low[n]));
                     if ( tempv3 > HiValue3 ) 
                        HiValue3 = tempv3; 
                     if ( tempv3 < LoValue3 )
                        LoValue3 = tempv3;
                  } 
            }
                                      
          if ( Value2 == HiValue2  && Close[i+1] > (High[i+1] + Low[i+1]) / 2 )
            {
               //red
               redVol = true;        
            }   

         if ( Value2 == HiValue2  && Close[i+1] <= (High[i+1] + Low[i+1]) / 2 )
            {
               whiteVol = true;                    
            } 
         //---------- END Bet Vol Code   ---------------\\    
                     
         //---------- BEGIN CDRW Code   ---------------\\

                     
         spd1 = High[i+1] - Low[i+1];
         spd2 = High[i+2] - Low[i+2];
         
         R[i]=0; D[i]=0; S[i]=0; W[i]=0;
         
         v1=iVolume(NULL,0,i+1);
         v2=iVolume(NULL,0,i+2);  
         if ( spd1 > spd2 )
            {
               if ( v1 < v2 )
                  {
                     if ( High[i+1]-Close[i+1] < Close[i+1]-Low[i+1] )
                        {
          
                           S[i+1] = 0;
                        }   
                     if ( High[i+1]-Close[i+1] > Close[i+1]-Low[i+1] )
                        {
 
                           D[i+1] = 0;
                        }
                  }           
               if ( v1 > v2 )
                  {
                     if ( High[i+1]-Close[i+1] < Close[i+1]-Low[i+1] )
                        {
                           if (redVol)//originaö
                              D[i+1] = Low[i+1] - Offset;            
                        }            
                     if ( High[i+1]-Close[i+1] > Close[i+1]-Low[i+1] )
                        {
                           if (whiteVol)
                              S[i+1] = High[i+1] + Offset;
                        }   
                  }      
            }
        
         //---------- END CDRW Code   ---------------\\
         

   }  //end for
   
   if ( AlertOn )
      {
         if ( (redVol && D[1] != 0) && alertonce != Time[0] )
            Alert("Demand Bar with Climax High Volume Detected on ", Symbol(),"  ",Period() );
         if ( (whiteVol && S[1] != 0) && alertonce != Time[0] )
            Alert("Support Bar with Climax Low Volume Detected on ", Symbol() ,"  ",Period()); 
         alertonce = Time[0];     
      }  
   return(0);
  }
//+------------------------------------------------------------------+
         