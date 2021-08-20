//+------------------------------------------------------------------+
//|                                             Aroon-oscillator_BO.mq4 |
//|                              Modified by      www.DodaCharts.com |
//+------------------------------------------------------------------+
#property copyright "DodaCharts.com"
#property link      "contact@dodacharts.com"

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1  clrLightSlateGray
#property indicator_color2  Purple
#property indicator_color3  Blue
#property indicator_color4  Pink
#property indicator_color5  Brown
#property indicator_color6  Lime
#property indicator_color7  Red
#property indicator_levelcolor DarkSlateGray
#property indicator_width1  1
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2
#property indicator_minimum -100
#property indicator_maximum  100


extern int    AroonPeriod      = 25;
extern int    Filter           = 50;
string Alerts_Settings  = "Settings for alerts";
extern bool   Alerts_On        = false;
extern bool   alerts_OnCurrent = false;
extern bool   alerts_Message   = false;
extern bool   alerts_Sound     = false;
extern bool   alerts_Email     = false;



double buffer1[];
double buffer2[];
double buffer3[];
double buffer4[];
double buffer5[];
double buffer6[];
double buffer7[];


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


int init()
{
   SetIndexBuffer(0,buffer1);
   SetIndexBuffer(1,buffer2);
   SetIndexBuffer(2,buffer3);
   SetIndexBuffer(3,buffer4);
   SetIndexBuffer(4,buffer5);
   SetIndexBuffer(5,buffer6); SetIndexStyle(5,DRAW_ARROW); SetIndexArrow(5,108);
   SetIndexBuffer(6,buffer7); SetIndexStyle(6,DRAW_ARROW); SetIndexArrow(6,108);

   SetLevelValue(0, Filter);
   SetLevelValue(1,0);
   SetLevelValue(2,-50);   
   
   IndicatorShortName("Aroon oscillator ("+AroonPeriod+")");
   return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int start()
{
   int counted_bars=IndicatorCounted();
   int i,limit;
   
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=Bars-counted_bars;

   
      if (buffer1[limit] >  50) CleanPoint(limit,buffer2,buffer3);
      if (buffer1[limit] < -50) CleanPoint(limit,buffer4,buffer5);
      
  
   for(i=limit; i>=0; i--)
   {
      double AroonUp = 100.0*(AroonPeriod-iHighest(NULL,0,MODE_HIGH,AroonPeriod,i)+i)/AroonPeriod;
      double AroonDn = 100.0*(AroonPeriod- iLowest(NULL,0,MODE_LOW ,AroonPeriod,i)+i)/AroonPeriod;
      
      buffer1[i] = AroonUp-AroonDn;
      buffer2[i] = EMPTY_VALUE;
      buffer3[i] = EMPTY_VALUE;
      buffer4[i] = EMPTY_VALUE;
      buffer5[i] = EMPTY_VALUE;
      buffer6[i] = EMPTY_VALUE;
      buffer7[i] = EMPTY_VALUE;
      
      
      
      if (buffer1[i]> Filter){PlotPoint(i,buffer2,buffer3,buffer1);}
      if (buffer1[i]<-Filter){PlotPoint(i,buffer4,buffer5,buffer1);}
      if (buffer1[i]> Filter && buffer1[i+1]< Filter) buffer6[i]= buffer1[i];
      if (buffer1[i]<-Filter && buffer1[i+1]>-Filter) buffer7[i]= buffer1[i];
      
         
   }
 

 /*  
   if (Alerts_On)
   {
      if (alerts_OnCurrent)
            int forBar = 0;
      else      forBar = 1;


      if (buffer6[forBar]!= EMPTY_VALUE) doAlert("Arron oscillator trend chaned to UP");
      if (buffer7[forBar]!= EMPTY_VALUE) doAlert("Arron oscillator trend chaned to DOWN");
   }
   */
         
   return(0);
}


//+----------------------------------------------------------------------------------+
//|                                                                                  |
//+----------------------------------------------------------------------------------+
/*
void doAlert(string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[0]) {
       previousAlert  = doWhat;
       previousTime   = Time[0];

       message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," Aroon oscillator - ",doWhat);
          if (alerts_Message) Alert(message);
          if (alerts_Email)   SendMail("Arron oscillator",message);
          if (alerts_Sound)   PlaySound("alert2.wav");
   }
}
*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CleanPoint(int i,double& first[],double& second[])
{
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}


void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (first[i+1] == EMPTY_VALUE)
      {
      if (first[i+2] == EMPTY_VALUE) {
          first[i]    = from[i];
          first[i+1]  = from[i+1];
          second[i]   = EMPTY_VALUE;
         }
      else {
          second[i]   = from[i];
          second[i+1] = from[i+1];
          first[i]    = EMPTY_VALUE;
         }
      }
   else
      {
         first[i]   = from[i];
         second[i]  = EMPTY_VALUE;
      }  
}