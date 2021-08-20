//+------------------------------------------------------------------+
//|                                            SSL channel chart.mq4 |
//|                                                           mladen |
//|                                                                  |
//| initial SSL for metatrader developed by Kalenzo                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_width1 2
#property indicator_width2 2
//----
extern int  Lb           =10;
extern bool alertsOn     =false;
extern bool alertsMessage=false;
extern bool alertsSound  =false;
extern bool alertsEmail  =false;
//----
double ssld[];
double sslu[];
double Hlv[];
double bChange[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(4);
   SetIndexBuffer(0,ssld); SetIndexDrawBegin(0,Lb+1);
   SetIndexBuffer(1,sslu); SetIndexDrawBegin(0,Lb+1);
   SetIndexBuffer(2,Hlv);
   SetIndexBuffer(3, bChange);
   
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int i,limit;
//----
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//----
   for(i=limit;i>=0;i--)
     {
      Hlv[i]=Hlv[i+1];
      if(Close[i]>iMA(Symbol(),0,Lb,0,MODE_EMA,PRICE_HIGH,i+1)) Hlv[i]= 1;
      if(Close[i]<iMA(Symbol(),0,Lb,0,MODE_EMA,PRICE_LOW,i+1))  Hlv[i]=-1;
      if(Hlv[i]==-1)
        {
         ssld[i]=iMA(Symbol(),0,Lb,0,MODE_EMA,PRICE_HIGH,i+1);
         sslu[i]=iMA(Symbol(),0,Lb,0,MODE_EMA,PRICE_LOW ,i+1);
        }
      else
        {
         ssld[i]=iMA(Symbol(),0,Lb,0,MODE_EMA,PRICE_LOW ,i+1);
         sslu[i]=iMA(Symbol(),0,Lb,0,MODE_EMA,PRICE_HIGH,i+1);
        }
     }
//----
   //if (alertsOn)
      if (Hlv[0]!=Hlv[1])
         
         if (Hlv[0]==1)
            bChange[0]=1;
            //doAlert("up");
            
         else  //doAlert("down");
            bChange[0]=0;
         ;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void doAlert(string doWhat)
  {
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
//----
     if (previousAlert!=doWhat || previousTime!=Time[0]) 
     {
      previousAlert =doWhat;
      previousTime  =Time[0];
//----
      message= StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," SSL trend changed to ",doWhat);
      if (alertsMessage) Alert(message);
      if (alertsEmail)   SendMail(StringConcatenate(Symbol(),"SSL "),message);
      if (alertsSound)   PlaySound("alert2.wav");
     }
  }
//+------------------------------------------------------------------+