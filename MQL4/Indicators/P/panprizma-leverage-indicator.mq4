//|                                Copyright 2018, Aleksey Panfilov. |
//|                                                filpan1@yandex.ru |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.2"
#property strict

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3

#property indicator_label1  "Line1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

#property indicator_label2  "Line2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrOrangeRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  6

#property indicator_label3  "Line3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrSilver
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2

input        int line_power = 2;
input        int leverage = 72;
input        int line1_SHIFT = 0;

double a1_Buffer[];
double a2_Buffer[];
double a3_Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,a1_Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,a2_Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,a3_Buffer,INDICATOR_DATA);
   
   ArraySetAsSeries(a3_Buffer,true);
   ArraySetAsSeries(a2_Buffer,true);
   ArraySetAsSeries(a1_Buffer,true);
//----
  SetIndexShift(0,line1_SHIFT);
  SetIndexShift(1,-72);
  SetIndexShift(2,20);
//----
   SetIndexLabel(0,"a1_Buffer");
   SetIndexLabel(1,"a2_Buffer");
   SetIndexLabel(2,"a3_Buffer");
//----


   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int i,z,limit;
   ArraySetAsSeries(open,true);
   if(prev_calculated==0)// first calculation    
     {
      limit=rates_total-300;
      if(limit<1)return(0);
      for(i=rates_total-1;i>=limit;i--)
        {
         a1_Buffer[i]=open[limit];
         a2_Buffer[i]=open[limit];
         a3_Buffer[i]=open[limit];
        }
     }
   else limit=rates_total-prev_calculated;
   for(i=limit;i>=0 && !IsStopped();i--)
     {
      a2_Buffer[i]=((open[i])+5061600*a2_Buffer[i+1]-7489800*a2_Buffer[i+2]+4926624*a2_Buffer[i+3]-1215450*a2_Buffer[i+4 ])/1282975;

      if(line_power ==1)   {    a3_Buffer[i+92]=a2_Buffer[i];   if(i<=1000) { for(z=92-1;z>=0;z--){        a3_Buffer[i+0+z]=  2*a3_Buffer[i+1+z]  -  1*a3_Buffer[i+2+z];  }}}
      if(line_power ==2)   {    a3_Buffer[i+92]=a2_Buffer[i];   if(i<=1000) { for(z=92-1;z>=0;z--){        a3_Buffer[i+0+z]=  3*a3_Buffer[i+1+z]  -  3*a3_Buffer[i+2+z]  +  1*a3_Buffer[i+3+z];  }}}
      if(line_power ==3)   {    a3_Buffer[i+92]=a2_Buffer[i];   if(i<=1000) { for(z=92-1;z>=0;z--){        a3_Buffer[i+0+z]=  4*a3_Buffer[i+1+z]  -  6*a3_Buffer[i+2+z]  +  4*a3_Buffer[i+3+z]  - 1*a3_Buffer[i+4+z];  }}}
      if(line_power ==4)   {    a3_Buffer[i+92]=a2_Buffer[i];   if(i<=1000) { for(z=92-1;z>=0;z--){        a3_Buffer[i+0+z]=  5*a3_Buffer[i+1+z]  - 10*a3_Buffer[i+2+z]  +  10*a3_Buffer[i+3+z] - 5*a3_Buffer[i+4+z]  +  1*a3_Buffer[i+5+z];  }}}

      a1_Buffer[i]=a3_Buffer[i+92-leverage];
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
