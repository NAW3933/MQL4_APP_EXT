//+------------------------------------------------------------------+
//|                                        VSA© BAR TEXT SIGNALS.mq4 |
//|                                    Copyright © 2008, FOREXflash. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, FOREXflash Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 7



extern int MA_Length  = 100; 

extern int ShiftUpText=0; //shift for place of text Demaind/Suppli  on Chart
extern int ShiftDownText=0; //shift for place of text Squad  on Chart

extern int  SizeText =7;
extern int  AngleText=90;

extern int  Corner =4;
extern bool displayAlert = false;



int     NumberOfBars            = 500;

//---- buffers
double ExtMapBuffer1[];
double SPREADHL[];
double AvgSpread[];
double v4[];
double Vol[];

string  WindowName;
int     PipFactor = 1;
double  shDS,shSQ;
static datetime lastAlertTime;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators      
SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(0,DRAW_NONE);
SetIndexBuffer(1,SPREADHL);
   SetIndexStyle(1,DRAW_NONE);
SetIndexBuffer(2,AvgSpread);     
   SetIndexStyle(2,DRAW_NONE);

SetIndexBuffer(5,v4);
   SetIndexStyle(5,DRAW_NONE);
SetIndexBuffer(6,Vol);
   SetIndexStyle(6,DRAW_NONE);         
      
      
string short_name = "VSA© BAR TEXT SIGNALS";     
IndicatorShortName(short_name);
WindowName = short_name;
IndicatorDigits(1);

shDS=ShiftUpText*Point;
shSQ=ShiftDownText*Point;
//----
return(1);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----
   datetime t;
   string name;
   for(int i=0;i<Bars;i++)
   {
          t=Time[i];
          name = "NDS_" + t;
          if(ObjectFind(name) >= 0) ObjectDelete(name);
          name = "Suppl_" + t;
          if(ObjectFind(name) >= 0) ObjectDelete(name);
   }
//----
ObjectsDeleteAll(0,OBJ_LABEL);
//----
return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
{
//----
AVGSpread();
//----
AVGVolume();
//----
return(0);
}
//+------------------------------------------------------------------+
//| AvgSpread                                                        |
//+------------------------------------------------------------------+
int AVGSpread()
{
   int    i,nLimit,nCountedBars;
//---- bars count that does not changed after last indicator launch.
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted
   if(nCountedBars>0) nCountedBars--;
   nLimit=Bars-nCountedBars;
//----


   for(i=0; i<nLimit; i++) 
   
   SPREADHL[i] =  ((iHigh(NULL, 0, i) - iLow(NULL, 0, i))/Point)/PipFactor;   // SPREAD 
   
   for(i=0; i<nLimit; i++)
   {
   AvgSpread[i] = iMAOnArray(SPREADHL,0,MA_Length,0,MODE_EMA,i);              // AVERAGE SPREAD 
          
   }        
//---- done
   return(0);
}
//+------------------------------------------------------------------+
//| AvgVolume                                                        |
//+------------------------------------------------------------------+
int AVGVolume()
{ 
   double tempv;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
   
      
   for(int i=0; i<limit; i++)   
      {
      tempv=0;
       
         
   for( int n=i;n<i+MA_Length;n++ )
      {
      tempv= Volume[n] + tempv; 
      } 
      v4[i] = NormalizeDouble(tempv/MA_Length,0);                         // AVERAGE VOLUME 
      Vol[i]= iVolume(NULL, 0, i);                                        // CURRENT VOLUME 

      
double MIDDLEOFBAR   = (High[i+1]+Low[i+1])/2;                             // EXACT MIDDLE 
double UPOFBAR       = (High[i+1]+Low[i+1])/2 + (High[i+1]-Low[i+1])/3.6;  // UP CLOSE    
double DOWNOFBAR     = (High[i+1]+Low[i+1])/2 - (High[i+1]-Low[i+1])/3.6;  // DOWN CLOSE  
 

// MIDDLECLOSE    if ( Close[i+1] > DOWNOFBAR2  && Close[i+1] < UPOFBAR2 )

// UP BAR         Close[i+1] > Close[i+2]  
// DOWN BAR       Close[i+1] < Close[i+2] 

// WIDE SPREAD    SPREADHL[i+1] > AvgSpread[i+1]*1.8
// NARROW SPREAD  SPREADHL[i+1] < AvgSpread[i+1]*0.8



if (High[i+1]>High[i+2] && SPREADHL[i+1] > AvgSpread[i+1]*1.8 && Close[i+1] < DOWNOFBAR && Vol[i+1] > Vol[i+2] && Vol[i+1] > v4[i+1] && Vol[i+1] > v4[i+1])
   {TextOutput(i, High[i+1]+shDS,1, i+1);  if(displayAlert == true)DisplayAlert("SM marked up the prices indicating strong bullishness. Get ready for MarkDown. ",Symbol());}  //REGULAR UPTHRUST / Weakness  
         
if (High[i+1]>High[i+2] && SPREADHL[i+1] > AvgSpread[i+1]*1.8 && Close[i+1] < DOWNOFBAR && Vol[i+1] > Vol[i+2] && Vol[i+1] > v4[i+1]*2)
   {TextOutput(i, High[i+1]+shDS,2, i+1);  if(displayAlert == true)DisplayAlert("SM marked up the prices indicating strong bullishness. Get ready for MarkDown. ",Symbol());}  //HighVol UPTHRUST / Weakness     
   
if (High[i+1]>High[i+2] && SPREADHL[i+1] > AvgSpread[i+1]*1.8 && Close[i+1] > DOWNOFBAR  && Close[i+1] < UPOFBAR && Vol[i+1] > Vol[i+2] && Vol[i+1] > v4[i+1])
   {TextOutput(i, High[i+1]+shDS,3, i+1);  if(displayAlert == true)DisplayAlert("SM was not successful in marking the price down. There was too much demand. ",Symbol());}  //Unsucessfull UPTHRUST / Demand stronger
    
if (High[i+1]>High[i+2] && SPREADHL[i+1] < AvgSpread[i+1] && Close[i+1] < DOWNOFBAR && Vol[i+1] > Vol[i+2] && Vol[i+1] < v4[i+1])
   {TextOutput(i, High[i+1]+shDS,4, i+1);  if(displayAlert == true)DisplayAlert("Upthrusts with low volume. Sign of weakness  ",Symbol());}  //PSEUDO UPTHRUST / Weakness    
    
if (Close[i+1] > Close[i+2] && Close[i+1] < MIDDLEOFBAR && SPREADHL[i+1] < AvgSpread[i+1]*0.8 && Vol[i+1] < v4[i+1])
   {TextOutput(i, High[i+1]+shDS,5, i+1);  if(displayAlert == true)DisplayAlert("No support from the SM. The SM is not interested in higher prices.  ",Symbol());}  //NO DEMAND / Weakness    
    
if (Close[i+1] > Close[i+2] && Close[i+1] > UPOFBAR && SPREADHL[i+1] > AvgSpread[i+1]*1.5 && Vol[i+1] > Vol[i+2])
   {TextOutput(i, High[i+1]+shDS,6, i+1);  if(displayAlert == true)DisplayAlert("Effort to move up. SM will test the market for supply before trying to move up further. ",Symbol());}  //MARK UP / Weakness      
    
if (Close[i+1] > Close[i+2] && Close[i+1] < MIDDLEOFBAR && SPREADHL[i+1] > AvgSpread[i+1]*1.5 && Vol[i+1] > Vol[i+2] && Vol[i+1] > v4[i+1])
   {TextOutput(i, Low[i+1]-shDS,7, i+1);  if(displayAlert == true)DisplayAlert("Effort to move up. SM will test the market for supply before trying to move up further.  ",Symbol());}  //FAILED MARK UP / Strenght  

if (Close[i+1] < Close[i+2] && Close[i+1] > UPOFBAR && Vol[i+1] < Vol[i+2] && Vol[i+1] < v4[i+1])
   {TextOutput(i, Low[i+1]-shDS,8, i+1);  if(displayAlert == true)DisplayAlert("Marking down the price. Low volume or less trading activity indicates a successful test. ",Symbol());}  //TESTING FOR SUPPLY / Strenght  

if (Close[i+1] < Close[i+2] && Close[i+1] > MIDDLEOFBAR && Vol[i+1] > v4[i+1])
   {TextOutput(i, Low[i+1]-shDS,9, i+1);  if(displayAlert == true)DisplayAlert("SM is absorbing the price. SM has decided to stop the down tide and start accumulating. ",Symbol());}  //STOPPING VOLUME / Strenght 

if (Close[i+1] > Close[i+2] && Close[i+1] > MIDDLEOFBAR && Low[i+1] < Low[i+2] && Low[i+2] < Low[i+3] && SPREADHL[i+1] > AvgSpread[i+1]*1.5 && Vol[i+1] > v4[i+1])
   {TextOutput(i, Low[i+1]-shDS,10, i+1);  if(displayAlert == true)DisplayAlert("This is a good sign of strength returning and you find the trend reversing almost immediately. ",Symbol());}  //REVERSE UPTHRUST / Strenght 
     
if (Close[i+1] < Close[i+2] && Close[i+1] < MIDDLEOFBAR && SPREADHL[i+1] < AvgSpread[i+1]*0.8 && Vol[1] < v4[1])
   {TextOutput(i, Low[i+1]-shDS,11, i+1);  if(displayAlert == true)DisplayAlert("In up trend are indications of continued trend. Strength, especially if they appear before/after test bars. ",Symbol());}  //NO SUPPLY / Strenght  
 
 
//+-------------- 

if (ObjectFind("001Vol") == -1 )
{
ObjectCreate("001Vol", OBJ_LABEL, 0, 0, 0);
ObjectSet("001Vol", OBJPROP_COLOR, Red);
ObjectSet("001Vol", OBJPROP_CORNER, Corner);
ObjectSet("001Vol", OBJPROP_XDISTANCE, 5);
ObjectSet("001Vol", OBJPROP_YDISTANCE, 15);}
ObjectSetText("001Vol","VOLUME: PENDING...", 10,"Tahoma Bold",White);

if (Vol[1] < v4[1]/2)                         { ObjectSetText("001Vol","VOLUME: VERY LOW ", 10,"Tahoma Bold",Red);}
if (Vol[1] < v4[1] && Vol[1] > v4[1]/2)       { ObjectSetText("001Vol","VOLUME: LOW ", 10,"Tahoma Bold",Red);}
if (Vol[1] > v4[1]*2)                         { ObjectSetText("001Vol","VOLUME: VERY HIGH", 10,"Tahoma Bold",Lime);}
if (Vol[1] > v4[1] && Vol[1] < v4[1]*2)       { ObjectSetText("001Vol","VOLUME: HIGH", 10,"Tahoma Bold",Lime);}


//+--------------  
if (ObjectFind("002") == -1 )
{
ObjectCreate("002", OBJ_LABEL, 0, 0, 0);
ObjectSet("002", OBJPROP_COLOR, Red);
ObjectSet("002", OBJPROP_CORNER, Corner);
ObjectSet("002", OBJPROP_XDISTANCE, 160);
ObjectSet("002", OBJPROP_YDISTANCE, 15);}
ObjectSetText("002","SPREAD: NORMAL", 10,"Tahoma Bold",White);
     
if (SPREADHL[1] > AvgSpread[1]*1.8)   {ObjectSetText("002","SPREAD: WIDE", 10,"Tahoma Bold",Lime);}
if (SPREADHL[1] < AvgSpread[1]*0.8)   {ObjectSetText("002","SPREAD: NARROW", 10,"Tahoma Bold",Red);}
//+--------------

if (ObjectFind("003") == -1 )
{
ObjectCreate("003", OBJ_LABEL, 0, 0, 0);
ObjectSet("003", OBJPROP_COLOR, Red);
ObjectSet("003", OBJPROP_CORNER, Corner);
ObjectSet("003", OBJPROP_XDISTANCE, 310);
ObjectSet("003", OBJPROP_YDISTANCE, 15);}
ObjectSetText("003","BAR POS:PENDING..", 10,"Tahoma Bold",White);
 
if (Close[1] > Close[2]){ ObjectSetText("003","BAR POS: UP BAR", 10,"Tahoma Bold",Lime);}
if (Close[1] < Close[2]){ ObjectSetText("003","BAR POS: DOWN BAR", 10,"Tahoma Bold",Red);}


//+--------------   
double UPOFBARTXT       = (High[1]+Low[1])/2 + (High[1]-Low[1])/3.6;  // UP CLOSE    
double DOWNOFBARTXT     = (High[1]+Low[1])/2 - (High[1]-Low[1])/3.6;  // DOWN CLOSE 

if (ObjectFind("004") == -1 )
{
ObjectCreate("004", OBJ_LABEL, 0, 0, 0);
ObjectSet("004", OBJPROP_COLOR, Red);
ObjectSet("004", OBJPROP_CORNER, Corner);
ObjectSet("004", OBJPROP_XDISTANCE, 470);
ObjectSet("004", OBJPROP_YDISTANCE, 15);}
ObjectSetText("004","BAR CLOSE: MIDCLOSE", 10,"Tahoma Bold",White);
 
if (Close[1] > UPOFBARTXT)    { ObjectSetText("004","BAR CLOSE: UP CLOSE", 10,"Tahoma Bold",Lime);}
if (Close[1] < DOWNOFBARTXT)  { ObjectSetText("004","BAR CLOSE: DOWN CLOSE", 10,"Tahoma Bold",Red);}

//+--------------  
  }
//----
   return(0);
  }
//+------------------------------------------------------------------+ 

void TextOutput(int i, double p, int ND, int NDN)
{
   datetime t=Time[i+1];
   string name = "NDS_" + t;
   if(ObjectFind(name) >= 0) ObjectDelete(name);
   
   ObjectCreate(name, OBJ_TEXT, 0, t, p);
    ObjectSet(name, OBJPROP_ANGLE, AngleText);
   
   string text;
   
   if(ND==1)
   {
      text = "UPTHRUST / Weakness_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }
   if(ND==2)
   {
      text = "HV UPTHRUST / Weakness_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }
   if(ND==3)
   {
      text = "LOW UPTHRUST / Demand stronger_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }
   if(ND==4)
   {
      text = "PSEUDO UPTHRUST / Weakness_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }   
   if(ND==5)
   {
      text = "NO DEMAND / Weakness_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }  
   if(ND==6)
   {
      text = "MARK UP / Strenght_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }     
   if(ND==7)
   {
      text = "FAILED MARK UP / Weakness_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }    
   if(ND==8)
   {
      text = "TESTING FOR SUPPLY / Strenght_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }    
   if(ND==9)
   {
      text = "STOPPING VOLUME / Strenght_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }   
   if(ND==10)
   {
      text = "REVERSE UPTHRUST / Strenght_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }    
   if(ND==11)
   {
      text = "NO SUPPLY / Strenght_" + NDN;
      ObjectSetText(name, text, SizeText, "Tahoma", White);
   }   
 }
   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayAlert(string message, int shift)
  {
   if(shift <= 2 && Time[shift] != lastAlertTime)
     {
       lastAlertTime = Time[shift];
       Alert(message, Symbol(), " , ", Period(), " minutes chart");
     }
  }