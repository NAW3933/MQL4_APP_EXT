#property  copyright "BECEMAL"
#property  link      "http://www.becemal.ru/mql"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red

extern int BBPeriod=14;

double BearsBuff[];
double BullsBuff[];

int init()  {
IndicatorShortName("BvsB("+BBPeriod+")");
SetIndexBuffer(0,BearsBuff);
SetIndexBuffer(1,BullsBuff);
SetIndexStyle(0,DRAW_LINE);
SetIndexStyle(1,DRAW_LINE);
SetIndexLabel(0,"Bears");
SetIndexLabel(1,"Bulls");
return(0);  }

int start() {
int counted_bars=IndicatorCounted();
if(Bars<=BBPeriod) return(0);
int limit=Bars-counted_bars-1;
if(limit < 2) limit = 2;
for(int  i = limit;i >= 0;i--)   {
   double   SMMA = iMA(NULL,0,BBPeriod,0,MODE_SMMA,PRICE_CLOSE,i);
   BearsBuff[i] = SMMA - Low[i];
   BullsBuff[i] = High[i]-SMMA;  }
return(0);  }