//+------------------------------------------------------------------+
//|                                               candle pattern.mq4 |
//|                                   Copyright c 2004, trendchaser. |
//+------------------------------------------------------------------+
/*
edited ha to be a candle stick pattern recognition indicator
*/
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 White
#property indicator_color2 White
#property indicator_color3 White
#property indicator_color4 White
#property indicator_color5 White
#property indicator_color6 White
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
//----
extern int ma_trend = 100;
extern int env_period = 50;
extern double dev = 0.25;
extern bool alert = true;
extern string sound = "short.wav";//alert.wav   short.wav
extern bool show_labels = true;
extern int label_pips = 25;
extern bool pin = true;
extern string bullish_reversals = "valid at bottoms";
extern bool morning_star = false;// good
extern bool morning_doji_star = false;// good
extern bool dragonfly_doji = false;// good
extern bool abandoned_baby = false;// good
extern bool three_inside_up = false;// good
extern bool hammer = false;
extern bool three_outside_up = false;// less reliable, only use at bottoms
extern bool three_white_soldiers = false;
extern bool breakaway = false;
extern string bullish_continuation = "valid in uptrend";
extern string bearishish_reversals = "valid at tops";
extern bool abandoned_baby_bear = false;// good
extern bool evening_star = false;// good
extern bool three_inside_down = false;// good
extern bool three_outside_down = false;
extern bool dark_cloud_cover = false;
extern bool gravestone_doji = false;
extern bool hanging_man = false;

extern string bearish_continuation = "valid in down trend";
extern bool on_neck = false;

extern color bullish = Blue;
extern color bearish = Red;
extern color neutral = White;
int count=0,count2=0,count3=0,count4=0,count5=0,count6=0,count7=0,count8=0,count9=0,count10=0
,count11=0,count12=0,count13=0,count14=0,count15=0,count16=0,count17=0,count18=0;
static datetime soundTag = D'1980.01.01';
int alert_bar= 0;  // 0= immediate   1= at bar close
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[],my_point;
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
    if (Point==0.0001)my_point=0.0001;
  if (Point==0.00001)my_point=0.0001;
  if (Point==0.01)my_point=0.01;
  if (Point==0.001)my_point=0.01;
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1, bullish);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1, bullish);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, 1, bearish);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM, 0, 1, bearish);
   SetIndexBuffer(3, ExtMapBuffer4);
   SetIndexStyle(4,DRAW_HISTOGRAM, 0, 1, neutral);
   SetIndexBuffer(4, ExtMapBuffer5);
   SetIndexStyle(5,DRAW_HISTOGRAM, 0, 1, neutral);
   SetIndexBuffer(5, ExtMapBuffer6);
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
   SetIndexDrawBegin(4,10);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
for(int i=0;i<=count;count--){

ObjectDelete("morning_star"+count+"");

} 
for(int i2=0;i2<=count2;count2--){

ObjectDelete("abandoned_baby"+count2+"");

} 
for(int i3=0;i3<=count3;count3--){

ObjectDelete("morning_doji_star"+count3+"");

} 
for(int i4=0;i4<=count4;count4--){

ObjectDelete("three_inside_up"+count4+"");

} 
for(int i5=0;i5<=count5;count5--){

ObjectDelete("three_outside_up"+count5+"");

} 
for(int i6=0;i6<=count6;count6--){

ObjectDelete("three_white_soldiers"+count6+"");

} 
for(int i7=0;i7<=count7;count7--){

ObjectDelete("breakaway"+count7+"");

} 
for(int i8=0;i8<=count8;count8--){

ObjectDelete("dragonfly_doji"+count8+"");

} 
for(int i9=0;i9<=count9;count9--){

ObjectDelete("hammer"+count9+"");

} 
for(int i10=0;i10<=count10;count10--){

ObjectDelete("abandoned_baby_bear"+count10+"");

} 
for(int i11=0;i11<=count11;count11--){

ObjectDelete("evening_star"+count11+"");

} 
for(int i12=0;i12<=count12;count12--){

ObjectDelete("three_inside_down"+count12+"");

} 
for(int i13=0;i13<=count13;count13--){

ObjectDelete("three_outside_down"+count13+"");

} 
for(int i14=0;i14<=count14;count14--){

ObjectDelete("dark_cloud_cover"+count14+"");

} 
for(int i15=0;i15<=count15;count15--){

ObjectDelete("gravestone_doji"+count15+"");

} 
for(int i16=0;i16<=count16;count16--){

ObjectDelete("hanging_man"+count16+"");

} 
for(int i17=0;i17<=count17;count17--){

ObjectDelete("on_neck"+count17+"");

} 

for(int i18=0;i18<=count18;count18--){

ObjectDelete("pin"+count18+"");

} 

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

     double   ma,  op5,cl5,lo5,hi5,    op,cl,lo,hi,    op4,cl4,lo4,hi4,  op3,cl3,lo3,hi3,   op2,cl2,lo2,hi2,    op1,cl1,lo1,hi1;
    if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   while(pos>=0)
     {
ma = iMA(NULL,0,ma_trend,0,MODE_EMA,PRICE_CLOSE,pos);
double env_up=iEnvelopes(NULL, 0, env_period,MODE_EMA,0,MODE_EMA,dev,MODE_UPPER,pos);
double env_dn=iEnvelopes(NULL, 0, env_period,MODE_SMA,0,MODE_EMA,dev,MODE_LOWER,pos);


cl=Close[pos];
op=Open[pos];
hi=High[pos];
lo=Low[pos];

cl1=Close[pos+1];
op1=Open[pos+1];
hi1=High[pos+1];
lo1=Low[pos+1];

cl2=Close[pos+2];
op2=Open[pos+2];
hi2=High[pos+2];
lo2=Low[pos+2];


cl3=Close[pos+3];
op3=Open[pos+3];
hi3=High[pos+3];
lo3=Low[pos+3];

cl4=Close[pos+4];
op4=Open[pos+4];
hi4=High[pos+4];
lo4=Low[pos+4];

cl5=Close[pos+5];
op5=Open[pos+5];
hi5=High[pos+5];
lo5=Low[pos+5];
  double fifty=hi+lo ;  
     fifty=fifty/2 ; 

  double fifty1=hi1+lo1 ;  
     fifty1=fifty1/2 ; 
    

        
  double fifty2=hi2+lo2  ;  
     fifty2=fifty2/2 ; 
     
   double fifty3=hi3+lo3  ;  
     fifty3=fifty3/2 ; 
     
      double fifty4=hi4+lo4  ;  
     fifty4=fifty4/2 ; 
     double size=hi-lo; 
     double size1=hi1-lo1;
     double size2=hi2-lo2;
     double size3=hi3-lo3;
     double size4=hi4-lo4;
     double size5=hi5-lo5;   




double atr=iATR(NULL,0,12,pos+1);
/*
if (lo1>lo&&cl>cl1  ) 
        {
         ExtMapBuffer1[pos]=hi;
         ExtMapBuffer2[pos]=lo;

               if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}   
        }  
        
        
   if (hi1<hi&&cl<cl1 ) 
        {
         ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;

               if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}   
        }  
             
*/
if (pin
&&cl2>op2
&&hi1>hi2
&&cl1<=hi2
&&op1<=hi2
//&&lo1>=fifty2 
//&&cl1<=op1
&&(hi1-hi2>=(hi2-lo1)*1)
//&&lo1>=fifty2 
) 
        {
         ExtMapBuffer3[pos+1]=hi1;
         ExtMapBuffer4[pos+1]=lo1;
if(show_labels){  ObjectCreate("pin"+count18+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("pin"+count18+"","pin", 10,"Times New Roman",Orange);
                  count18++;
                   ObjectCreate("pin"+count18+"", OBJ_TREND, 0, iTime(NULL,0,pos),lo1,  iTime(NULL,0,pos+1),lo1);
                  ObjectSet("pin"+count18+"", OBJPROP_RAY,0);
                  ObjectSet("pin"+count18+"", OBJPROP_COLOR,Red);
                  ObjectSet("pin"+count18+"", OBJPROP_WIDTH,1);
                  count18++;
                  /*
                  ObjectCreate("pin"+count18+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),(lo2-(hi1-lo2)*2),  iTime(NULL,0,pos-5),(lo2-(hi1-lo2)*2));
                  ObjectSet("pin"+count18+"", OBJPROP_RAY,0);
                  ObjectSet("pin"+count18+"", OBJPROP_COLOR,Blue);
                  ObjectSet("pin"+count18+"", OBJPROP_WIDTH,3);
                  count18++;
                 ObjectCreate("pin"+count18+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),((hi1-lo2)+hi1)+(hi1-lo2),  iTime(NULL,0,pos-5),((hi1-lo2)+hi1)+(hi1-lo2));
                  ObjectSet("pin"+count18+"", OBJPROP_RAY,0);
                  ObjectSet("pin"+count18+"", OBJPROP_COLOR,Red);
                  ObjectSet("pin"+count18+"", OBJPROP_WIDTH,3);
                  count18++;
                  */
                  }
                  
if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}

        } 
if (pin
&&cl2<op2
&&lo1<lo2
&&cl1>=lo2
&&op1>=lo2
//&&hi1<=fifty2
//&&cl1>=op1
&&(lo2-lo1>=(hi1-lo2)*1)
//&&hi1<=fifty2
 ) 
        {
         ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
if(show_labels){  ObjectCreate("pin"+count18+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("pin"+count18+"","pin", 10,"Times New Roman",DeepSkyBlue);
                    count18++;
                     ObjectCreate("pin"+count18+"", OBJ_TREND, 0, iTime(NULL,0,pos),hi1,  iTime(NULL,0,pos+1),hi1);
                  ObjectSet("pin"+count18+"", OBJPROP_RAY,0);
                  ObjectSet("pin"+count18+"", OBJPROP_COLOR,Blue);
                  ObjectSet("pin"+count18+"", OBJPROP_WIDTH,1);
                  count18++;
                  /*
                  ObjectCreate("pin"+count18+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),(hi2-(lo1-hi2)*2),  iTime(NULL,0,pos-5),(hi2-(lo1-hi2)*2));
                  ObjectSet("pin"+count18+"", OBJPROP_RAY,0);
                  ObjectSet("pin"+count18+"", OBJPROP_COLOR,Blue);
                  ObjectSet("pin"+count18+"", OBJPROP_WIDTH,3);
                  count18++;
                 ObjectCreate("pin"+count18+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),((lo1-hi2)+lo1)+(lo1-hi2),  iTime(NULL,0,pos-5),((lo1-hi2)+lo1)+(lo1-hi2));
                  ObjectSet("pin"+count18+"", OBJPROP_RAY,0);
                  ObjectSet("pin"+count18+"", OBJPROP_COLOR,Red);
                  ObjectSet("pin"+count18+"", OBJPROP_WIDTH,3);
                  count18++;
                  */
                  }
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&lo2<env_up&&on_neck&&cl2<op2&&cl1<=fifty2&&op1<=fifty2&&op1>=fifty1&&cl1>=fifty1&&op1<cl1  ) 
        {
         ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
        // ExtMapBuffer5[pos+1]=hi1;
       //  ExtMapBuffer6[pos+1]=lo1;



if(show_labels){  ObjectCreate("on_neck"+count17+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("on_neck"+count17+"","on neck", 10,"Times New Roman",Orange);
                  count17++;}
               if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}   
        }  
if (cl<ma&&lo2<env_up&&on_neck&&cl2<op2&&cl1<=fifty2&&op1<=fifty2&&op1>=fifty1&&cl1>=fifty1&&op1>cl1   ) 
        {
         ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
       //  ExtMapBuffer5[pos+1]=hi1;
         //ExtMapBuffer6[pos+1]=lo1;


if(show_labels){  ObjectCreate("on_neck"+count17+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("on_neck"+count17+"","on neck", 10,"Times New Roman",Orange);
                  count17++;}
 if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}                 
        }  
if (cl<ma&&hi2>env_dn&&hanging_man&&cl1>op1&&hi2>hi3&&cl2>hi2-2*my_point&&cl2<hi2+2*my_point  &&op2>fifty2&&cl2-op2<atr/5&&op2<cl2  &&hi1<hi2&&cl1<op1) 
        {
        ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
             //    ExtMapBuffer5[pos+2]=hi2;
         //ExtMapBuffer6[pos+2]=lo2;
             //    ExtMapBuffer1[pos+3]=hi3;
        // ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("hanging_man"+count16+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("hanging_man"+count16+"","hanging man", 10,"Times New Roman",Orange);
                  count16++;}
 if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}                 
        }  
if (cl<ma&&hi2>env_dn&&hanging_man&&cl3>op3&&hi2>hi3&&op2>hi2-2*my_point&&op2<hi2+2*my_point  &&cl2>fifty2&&op2-cl2<atr/5&&op2>cl2   &&hi1<hi2&&cl1<op1) 
        {
        ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
                // ExtMapBuffer5[pos+2]=hi2;
         //ExtMapBuffer6[pos+2]=lo2;
                // ExtMapBuffer1[pos+3]=hi3;
         //ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("hanging_man"+count16+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("hanging_man"+count16+"","hanging man", 10,"Times New Roman",Orange);
                  count16++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&gravestone_doji&&cl3>op3&&hi2>hi3&&op2>lo2-2*my_point&&op2<lo2+2*my_point  &&op2>cl2-2*my_point&&op2<cl2+2*my_point&&op1>cl1) 
        {
        ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
               //  ExtMapBuffer5[pos+2]=hi2;
        // ExtMapBuffer6[pos+2]=lo2;
                // ExtMapBuffer1[pos+3]=hi3;
        // ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("gravestone_doji"+count15+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("gravestone_doji"+count15+"","gravestone doji", 10,"Times New Roman",Orange);
                  count15++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&dark_cloud_cover&&cl3>op3&&cl2>op2&&cl1<op1&&cl1<fifty2&&hi1>hi2) 
        {
        ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
             //    ExtMapBuffer1[pos+2]=hi2;
         //ExtMapBuffer2[pos+2]=lo2;



if(show_labels){  ObjectCreate("dark_cloud_cover"+count14+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("dark_cloud_cover"+count14+"","dark cloud cover", 10,"Times New Roman",Orange);
                  count14++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&three_outside_down&&cl3>op3&&cl2<op2&&cl1<op1&&hi2>=hi3&&lo2<lo3&&lo1<lo2) 
        {
        ExtMapBuffer3[pos]=hi;
         ExtMapBuffer4[pos]=lo;
                // ExtMapBuffer3[pos+2]=hi2;
         //ExtMapBuffer4[pos+2]=lo2;
            //     ExtMapBuffer1[pos+3]=hi3;
         //ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("three_outside_down"+count13+"", OBJ_TEXT, 0, iTime(NULL,0,pos), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("three_outside_down"+count13+"","three outside down", 10,"Times New Roman",Orange);
                  count13++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&three_inside_down&&cl3>op3&&cl2<op2&&cl1<op1&&hi2<hi3&&lo2>lo3&&hi1<hi2&&lo1<lo3) 
        {
        ExtMapBuffer3[pos+1]=hi1;
         ExtMapBuffer4[pos+1]=lo1;
                 ExtMapBuffer3[pos+2]=hi2;
         ExtMapBuffer4[pos+2]=lo2;
                 ExtMapBuffer1[pos+3]=hi3;
         ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("three_inside_down"+count12+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("three_inside_down"+count12+"","three inside down", 10,"Times New Roman",Orange);
                  count12++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&evening_star&&cl3>op3&&hi2>hi3&&hi1<hi2&&cl1<lo2&&cl2>lo2-2*my_point&&cl2<lo2+2*my_point&&op2<fifty2) 
        {
        ExtMapBuffer3[pos+1]=hi1;
         ExtMapBuffer4[pos+1]=lo1;
                 ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
                 ExtMapBuffer1[pos+3]=hi3;
         ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("evening_star"+count11+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("evening_star"+count11+"","evening star", 10,"Times New Roman",Orange);
                  count11++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&evening_star&&cl3>op3&&hi2>hi3&&hi1<hi2&&cl1<lo2&&op2>lo2-2*my_point&&op2<lo2+2*my_point&&cl2<fifty2) 
        {
        ExtMapBuffer3[pos+1]=hi1;
         ExtMapBuffer4[pos+1]=lo1;
                 ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
                 ExtMapBuffer1[pos+3]=hi3;
         ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("evening_star"+count11+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("evening_star"+count11+"","evening star", 10,"Times New Roman",Orange);
                  count11++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl<ma&&hi2>env_dn&&abandoned_baby_bear&&cl3>op3&&hi2>hi3&&hi1<hi2&&cl1<lo2&&op2>cl2-2*my_point&&op2<cl2+2*my_point) 
        {
        ExtMapBuffer3[pos+1]=hi1;
         ExtMapBuffer4[pos+1]=lo1;
                 ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
                 ExtMapBuffer1[pos+3]=hi3;
         ExtMapBuffer2[pos+3]=lo3;


if(show_labels){  ObjectCreate("abandoned_baby_bear"+count10+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), High[iHighest(NULL,0,MODE_HIGH,7,pos)]+label_pips*my_point);
                  ObjectSetText("abandoned_baby_bear"+count10+"","abandoned baby", 10,"Times New Roman",Orange);
                  count10++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl>ma&&lo2<env_up&&hammer&&op1>cl2&&op2-cl2<atr/5&&op2>hi2-2*my_point&&op2<hi2+2*my_point&&cl2>fifty2&&cl3<op3&&lo3>lo2&&op1<cl1) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
                 ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
                 ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;


if(show_labels){  ObjectCreate("hammer"+count9+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("hammer"+count9+"","hammer", 10,"Times New Roman",DeepSkyBlue);
                  count9++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }  
if (cl>ma&&lo2<env_up&&hammer&&op1<cl2&&cl2-op2<atr/5&&cl2>hi2-2*my_point&&cl2<hi2+2*my_point&&cl2>fifty2&&cl3<op3&&lo3>lo2&&op1<cl1&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+4)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
                 ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
                 ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;


if(show_labels){  ObjectCreate("hammer"+count9+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("hammer"+count9+"","hammer", 10,"Times New Roman",DeepSkyBlue);
                  count9++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
if (cl>ma&&lo2<env_up&&dragonfly_doji&&op2>hi2-2*my_point&&op2<hi2+2*my_point&&cl2>hi2-2*my_point&&cl2<hi2+2*my_point&&cl1>op1&&lo1>lo2&&cl3<op3&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+4)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer1[pos+2]=hi2;
         ExtMapBuffer2[pos+2]=lo2;

if(show_labels){  ObjectCreate("dragonfly_doji"+count8+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("dragonfly_doji"+count8+"","dragonfly doji", 10,"Times New Roman",DeepSkyBlue);
                  count8++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
if (cl>ma&&lo2<env_up&&breakaway&&cl5<op5&&lo4<lo5&&lo3<lo4&&lo2<lo3&&lo1>lo2&&hi1>hi3&&op1<cl1&&hi5>hi4&&hi4>hi3&&hi3>hi2&&size5/2>size4&&size5/2>size3&&size5/2>size2&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+6)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer3[pos+2]=hi2;
         ExtMapBuffer4[pos+2]=lo2;
        ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;
        ExtMapBuffer3[pos+4]=hi4;
         ExtMapBuffer4[pos+4]=lo4;
        ExtMapBuffer3[pos+5]=hi5;
         ExtMapBuffer4[pos+5]=lo5;
if(show_labels){  ObjectCreate("breakaway"+count7+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("breakaway"+count7+"","breakaway", 10,"Times New Roman",DeepSkyBlue);
                  count7++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
if (cl<ma&&lo2<env_up&&three_white_soldiers&&cl3>op3&&cl2>op2&&cl1>op1&&lo3<lo2&&lo3<lo1&&hi3<hi2&&hi1>hi2&&cl3>fifty3&&op3<fifty3&&cl2>fifty2&&op2<fifty2&&cl1>fifty1&&op1<fifty1&&cl4<op4&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+6)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer1[pos+2]=hi2;
         ExtMapBuffer2[pos+2]=lo2;
        ExtMapBuffer1[pos+3]=hi3;
         ExtMapBuffer2[pos+3]=lo3;
if(show_labels){  ObjectCreate("three_white_soldiers"+count6+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("three_white_soldiers"+count6+"","three white soldiers", 10,"Times New Roman",DeepSkyBlue);
                  count6++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
if (cl>ma&&lo2<env_up&&three_outside_up&&cl3<op3&&cl2>op2&&cl1>op1&&hi2>hi3&&lo2<=lo3&&lo1>lo2&&hi1>hi2&&lo3<fifty2&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+4)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
        ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;
if(show_labels){  ObjectCreate("three_outside_up"+count5+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("three_outside_up"+count5+"","three outside up", 10,"Times New Roman",DeepSkyBlue);
                  count5++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
if (cl>ma&&lo2<env_up&&three_inside_up&&cl3<op3&&cl1>op1&&hi2<fifty3&&hi1>hi3&&lo2>lo3&&lo1>lo2&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+4)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
        ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;
if(show_labels){  ObjectCreate("three_inside_up"+count4+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("three_inside_up"+count4+"","three inside up", 10,"Times New Roman",DeepSkyBlue);
                  count4++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
if (cl>ma&&lo2<env_up&&abandoned_baby&&hi3>hi2&&op3>fifty3&&cl3<fifty3&&lo2<lo3&&lo1>=lo2&&op1<cl2&&op2>cl2-2*my_point&&op2<cl2+2*my_point&&hi2<fifty1&&op1<fifty1&&cl1>fifty1&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+4)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
        ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;
if(show_labels){  ObjectCreate("abandoned_baby"+count2+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("abandoned_baby"+count2+"","abandoned baby", 10,"Times New Roman",DeepSkyBlue);
                  count2++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   

if (cl>ma&&morning_star&&hi1<hi3&&hi2<hi1&&op3>cl3&&op1<cl1&&lo1>lo2&&lo2<lo3&&cl3<fifty1&&lo2<Low[iLowest(NULL,0,MODE_LOW,10,pos+4)]) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
        ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;
if(show_labels){  ObjectCreate("morning_star"+count+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("morning_star"+count+"","morning star", 10,"Times New Roman",DeepSkyBlue);
                 count++;
                  ObjectCreate("morning_star"+count+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),((hi2+lo1)/2),  iTime(NULL,0,pos-5),((hi2+lo1)/2));
                  ObjectSet("morning_star"+count+"", OBJPROP_RAY,0);
                  ObjectSet("morning_star"+count+"", OBJPROP_COLOR,Blue);
                  ObjectSet("morning_star"+count+"", OBJPROP_WIDTH,3);
                  count++;
                  ObjectCreate("morning_star"+count+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),(lo2-(hi1-lo2)),  iTime(NULL,0,pos-5),(lo2-(hi1-lo2)));
                  ObjectSet("morning_star"+count+"", OBJPROP_RAY,0);
                  ObjectSet("morning_star"+count+"", OBJPROP_COLOR,Red);
                  ObjectSet("morning_star"+count+"", OBJPROP_WIDTH,3);
                  count++;
                 ObjectCreate("morning_star"+count+"", OBJ_TREND, 0, iTime(NULL,0,pos+2),((hi1-lo2)+hi1),  iTime(NULL,0,pos-5),((hi1-lo2)+hi1));
                  ObjectSet("morning_star"+count+"", OBJPROP_RAY,0);
                  ObjectSet("morning_star"+count+"", OBJPROP_COLOR,Blue);
                  ObjectSet("morning_star"+count+"", OBJPROP_WIDTH,3);
                  count++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
                  
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
        
if (cl>ma&&lo2<env_up&&morning_doji_star&&hi1<hi3&&hi2<hi1&&op3>cl3&&op1<cl1&&lo1>lo2&&lo2<lo3&&cl3<fifty1&&op2>cl2-2*my_point&&op2<cl2+2*my_point) 
        {
        ExtMapBuffer1[pos+1]=hi1;
         ExtMapBuffer2[pos+1]=lo1;
        ExtMapBuffer5[pos+2]=hi2;
         ExtMapBuffer6[pos+2]=lo2;
        ExtMapBuffer3[pos+3]=hi3;
         ExtMapBuffer4[pos+3]=lo3;
if(show_labels){  ObjectCreate("morning_doji_star"+count3+"", OBJ_TEXT, 0, iTime(NULL,0,pos+1), Low[iLowest(NULL,0,MODE_LOW,7,pos)]-label_pips*my_point);
                  ObjectSetText("morning_doji_star"+count3+"","morning doji star", 10,"Times New Roman",DeepSkyBlue);
                  count3++;}
                  if (alert && pos==alert_bar && soundTag!=Time[0])
        {
PlaySound (sound);
soundTag = Time[0];}
        }   
        pos--;
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+