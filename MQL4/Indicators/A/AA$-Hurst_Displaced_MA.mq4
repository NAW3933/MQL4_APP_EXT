//+------------------------------------------------------------------+
//|                                          $AA-Hurst indicator.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window


#property indicator_buffers 1
#property indicator_color1 Yellow

//---- input parameters
extern int       dmaPeriod=199;
extern int       dmaPeriodShift = -99;
extern int   isRay = 0;
extern int samplePoint = 5;
extern color trendLineColor;

//---- buffers
double dmaBuffer[];
int dmaPeriodShifted;


int init()
  {
  dmaPeriodShifted = (-1 )* dmaPeriodShift;
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(0,dmaBuffer);
   return(0);
  }

   

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
 
   int limit;
   int counted_bars = IndicatorCounted();
   //---- check for possible errors
   if (counted_bars<0) return(-1);
   //---- last counted bar will be recounted
   if (counted_bars>0) counted_bars--;
   limit = Bars - counted_bars;

   for(int i=0; i<=limit; i++)
   {
      dmaBuffer[i+dmaPeriodShifted] = iMA(NULL,0,dmaPeriod,0,MODE_SMA,PRICE_CLOSE,i) ;

   }
      deleteAllObjects();
      double m = (dmaBuffer[dmaPeriodShifted] - dmaBuffer[dmaPeriodShifted+samplePoint])/(Time[dmaPeriodShifted] - Time[dmaPeriodShifted+samplePoint]);
      double c = dmaBuffer[dmaPeriodShifted]  - m * Time[dmaPeriodShifted];
      double y =  m*Time[0] + c;
      
      ObjectCreate("HurstDisplaced-" + dmaPeriod + dmaPeriodShift +"1",OBJ_TREND,0,Time[dmaPeriodShifted],dmaBuffer[dmaPeriodShifted] ,Time[0],y );
      ObjectSet("HurstDisplaced-" + dmaPeriod + dmaPeriodShift +"1",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("HurstDisplaced-" + dmaPeriod + dmaPeriodShift +"1",OBJPROP_COLOR, trendLineColor);
      ObjectSet("HurstDisplaced-" + dmaPeriod + dmaPeriodShift +"1",OBJPROP_RAY, isRay );

      
      
   return(0);
  }


int deinit()
{

   return (0);
}


void deleteAllObjects()
{
   int objs = ObjectsTotal();
   string name;
   for(int cnt=ObjectsTotal()-1;cnt>=0;cnt--)
   {
      name=ObjectName(cnt);
      if (StringFind(name,"HurstDisplaced-" + dmaPeriod + dmaPeriodShift,0)>-1) ObjectDelete(name);
      WindowRedraw();
   }
}