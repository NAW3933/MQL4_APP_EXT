// BetterVolume 1.5.mq4 
// modified to correct start loop 

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 Red 	// Climax High 	Red 
#property indicator_color2 Gray 	// Neutral 	DeepSkyBlue 
#property indicator_color3 Yellow 	// Low 		Yellow 
#property indicator_color4 Lime 	// High Churn 	Lime 
#property indicator_color5 DarkSlateGray 	// Climax Low 	CadetBlue LightSeaGreen White 
#property indicator_color6 Magenta 	// Climax Churn 
#property indicator_color7 White 	// Ma 		Maroon 

#property indicator_width1 4
#property indicator_width2 4
#property indicator_width3 4
#property indicator_width4 4
#property indicator_width5 4
#property indicator_width6 4

extern int     NumberOfBars = 1000 ; // 1500 ; 500;
extern string  Note = "0 means Display all bars";
extern int     MAPeriod = 12 ;
extern int     LookBack = 20;
extern int     width1 = 2 ;
extern int     width2 = 3 ;

extern bool UseNotificationAlert = true;
extern bool UseVisualAlert = true;
extern bool UseSoundAlert = true;
extern bool UseEmailAlert = true;

extern bool IgnoreClimax = false;
extern bool IgnoreVolumeIncrease = true;
extern bool IgnoreLowVolume = false;
extern bool IgnoreChurn = false;
extern bool IgnoreVolumeDecrease = true;
extern bool IgnoreClimaticChurn = false;
extern color   Trending=  C'0,21,0';
extern color   Ranging= C'60,0,0';

double red[],blue[],yellow[],green[],white[],magenta[],v4[];

// Variables for alerts:
color CurrentColor[3] = {White, White, White};
datetime LastAlertTime = D'1980.01.01';

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
      SetIndexBuffer(0,red);
      SetIndexStyle(0,DRAW_HISTOGRAM,0,width2);
      SetIndexLabel(0,"Climax High ");
      
      SetIndexBuffer(1,blue);
      SetIndexStyle(1,DRAW_HISTOGRAM,0,width1);
      SetIndexLabel(1,"Neutral");
      
      SetIndexBuffer(2,yellow);
      SetIndexStyle(2,DRAW_HISTOGRAM,0,width2);
      SetIndexLabel(2,"Low ");
      
      SetIndexBuffer(3,green);
      SetIndexStyle(3,DRAW_HISTOGRAM,0,width2);
      SetIndexLabel(3,"HighChurn ");

      SetIndexBuffer(4,white);
      SetIndexStyle(4,DRAW_HISTOGRAM,0,width1);
      SetIndexLabel(4,"Climax Low ");

      SetIndexBuffer(5,magenta);
      SetIndexStyle(5,DRAW_HISTOGRAM,0,width2);
      SetIndexLabel(5,"ClimaxChurn ");

      SetIndexBuffer(6,v4);
      SetIndexStyle(6,DRAW_LINE,0,1);
      SetIndexLabel(6,"Average("+MAPeriod+")");

      IndicatorShortName("Better Volume 1.5" );

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
int Window=WindowFind("BetterVolume 1.5 new with Alerts mod");
   double VolLowest,Range,Value2,Value3,HiValue2,HiValue3,LoValue3,tempv2,tempv3,tempv;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
   
   
   for(int i=0; i<limit; i++)   
      {
         red[i] = 0; blue[i] = Volume[i]; yellow[i] = 0; green[i] = 0; white[i] = 0; magenta[i] = 0;
         Value2=0;Value3=0;HiValue2=0;HiValue3=0;LoValue3=99999999;tempv2=0;tempv3=0;tempv=0;
         if (i <= 2) CurrentColor[i] = White;


         VolLowest = Volume[iLowest(NULL,0,MODE_VOLUME,LookBack,i)];
         if (Volume[i] == VolLowest)
            {
               yellow[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               if (i <= 2) CurrentColor[i] = FireBrick;
            }

         Range = (High[i]-Low[i]);
         Value2 = Volume[i]*Range;

         if (  Range != 0 )
            Value3 = Volume[i]/Range;

         for ( int n=i;n<i+MAPeriod;n++ )
            {
               tempv= Volume[n] + tempv; 
            } 
          v4[i] = NormalizeDouble(tempv/MAPeriod,0);

          for ( n=i;n<i+LookBack;n++)
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

          if ( Value2 == HiValue2)
            {
               red[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               yellow[i]=0;
               if (i <= 2) CurrentColor[i] = LightSeaGreen;
            }   

          if ( Value3 == HiValue3 )
            {
               green[i] = NormalizeDouble(Volume[i],0);                
               blue[i] =0;
               yellow[i]=0;
               red[i]=0;
               if (i <= 2) CurrentColor[i] = DodgerBlue;
            }
          if ( Value2 == HiValue2 && Value3 == HiValue3 )
            {
               magenta[i] = NormalizeDouble(Volume[i],0);
               blue[i]=0;
               red[i]=0;
               green[i]=0;
               yellow[i]=0;
               if (i <= 2) CurrentColor[i] = Magenta;
            } 
         if ( Volume[i]<Volume[i+1] && Value2 != HiValue2 && Value3 != HiValue3 && Volume[i] != Volume[iLowest(NULL,0,MODE_VOLUME,LookBack,i)])
            {
               white[i] = NormalizeDouble(Volume[i],0);
               magenta[i]=0;
               blue[i]=0;
               red[i]=0;
               green[i]=0;
               yellow[i]=0;
               if (i <= 2) CurrentColor[i] = LightSalmon;
            }
      }

//----        

//----
   if ((CurrentColor[1] != CurrentColor[2]) && (LastAlertTime != Time[1]))
   {
      if ((CurrentColor[1] == LightSeaGreen) && (IgnoreClimax)) return;
      if ((CurrentColor[1] == White) && (IgnoreVolumeIncrease)) return;
      if ((CurrentColor[1] == FireBrick) && (IgnoreLowVolume)) return;
      if ((CurrentColor[1] == DodgerBlue) && (IgnoreChurn)) return;
      if ((CurrentColor[1] == LightSalmon) && (IgnoreVolumeDecrease)) return;
      if ((CurrentColor[1] == Magenta) && (IgnoreClimaticChurn)) return;
      
      if (UseNotificationAlert) SendNotification (Symbol() +"BetterVolume - Color changed");
      if (UseVisualAlert) Alert(Symbol() +"BetterVolume - Color changed");
      if (UseSoundAlert) PlaySound(Symbol() +"alert.wav");
      if (UseEmailAlert) SendMail(Symbol() + "Better Volume Alert","Better Volume Alert" );
      LastAlertTime = Time[1];
   }
//----
string Label;

   int cnt=0;   
   for(i=limit-1;i>0;i--) 
   {
      if(v4[i]>Volume[i]) { // If its a cross point
         cnt++; // calculate the number of crosses.
         Label="Trend2" + cnt;
         if(ObjectFind(Label)==-1)
         ObjectCreate(Label,OBJ_RECTANGLE,0,0,0);
         ObjectSet(Label,OBJPROP_COLOR,Ranging);
         ObjectSet(Label,OBJPROP_PRICE1,100000000);
         ObjectSet(Label,OBJPROP_PRICE2,0);
         ObjectSet(Label,OBJPROP_TIME1,Time[i]);
         ObjectSet(Label,OBJPROP_TIME2,Time[i-1]);
    }
    else 
    {
         if(v4[i]<Volume[i]) { // If its a cross point
            cnt++; // calculate the number of crosses.
            Label="Trend2" + cnt;
            if(ObjectFind(Label)==-1)
               ObjectCreate(Label,OBJ_RECTANGLE,0,0,0);
            ObjectSet(Label,OBJPROP_COLOR,Trending);
            ObjectSet(Label,OBJPROP_PRICE1,100000000);
            ObjectSet(Label,OBJPROP_PRICE2,0);
            ObjectSet(Label,OBJPROP_TIME1,Time[i]);
            ObjectSet(Label,OBJPROP_TIME2,Time[i-1]);
     }
     else 
            
            ObjectSet(Label,OBJPROP_TIME2,Time[i-1]); // drag the current shadow
     }
   }          

//----
   return(0);
  }
  
/*string ColorToString(color Color)
{
   switch(Color)
   {
      case LightSeaGreen: return("LightSeaGreen");
      case White: return("White");
      case FireBrick: return("FireBrick");
      case DodgerBlue: return("DodgerBlue");
      case LightSalmon: return("LightSalmon");
      case Magenta: return("Magenta");
      default: return("Unknown");
   }
}*/
//+------------------------------------------------------------------+