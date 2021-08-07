
//| BetterVolume 1.4_TRO_MODIFIED_VERSION                        |
//| MODIFIED BY AVERY T. HORTON, JR. AKA THERUMPLEDONE@GMAIL.COM     |
//| I am NOT the ORIGINAL author 
//  and I am not claiming authorship of this indicator. 
//  All I did was modify it. I hope you find my modifications useful.|
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 C'95,33,33'
#property indicator_color2 C'40,40,40'
#property indicator_color3 Sienna
#property indicator_color4 C'35,82,51'
#property indicator_color5 LightGray
#property indicator_color6 C'109,18,70'
#property indicator_color7 C'48,48,48'

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2


extern bool   Show.Legend  = true ;

extern int     NumberOfBars = 500;
//extern string  Note = "0 means Display all bars";
extern int     MAPeriod = 100;
extern int     LookBack = 20;

extern bool Show.Message = true ;

extern int myCorner= 1;
extern int x.offset= 80 ; 
extern int y.offset= 10 ; 


extern string myFont       = "Arial Bold" ;
extern int    myFontSize   = 12 ;



extern color ClimaxHighColor  = Red;
extern color NeutralColor     = C'40,40,40';
extern color LowColor         = Yellow;
extern color HighChurnColor   = Green;
extern color ClimaxLowColor   = White;
extern color ClimaxChurnColor = Magenta;

extern int    myBarWidth      = 2 ;

//+------------------------------------------------------------------+
int    redbarnum= -1 ,bluebarnum= -1 ,yellowbarnum= -1 ,greenbarnum= -1 ,whitebarnum= -1 ,magentabarnum= -1 ;

double red[],blue[],yellow[],green[],white[],magenta[],v4[];
//+------------------------------------------------------------------+

string symbol, tChartPeriod,  tShortName, TAG, tObjName06, tAlert, short_name ;  
int    digits, period, digits2,win  ; 
double point ;

int    barshift, index ;
double V,O,H,L,C,R1,V1,O1,H1,L1,C1,R2,V2,O2,H2,L2,C2,range, value;

double nHigh, nLow, nVolume, nRange ;
double Buf[] ;

color colorVolume;


double  cVOLUME, pVOLUME, VolumePct, AvgVolumePct;

string Arrow ;
//+------------------------------------------------------------------+

 
int init()
{
   Arrow        =  CharToStr(108) ;
   
   period       =  Period() ;    
   symbol       =  Symbol() ;
   digits       =  Digits ;   
   point        =  Point ;
    
 
//---- indicators
      SetIndexBuffer(0,red);
      SetIndexStyle(0,DRAW_HISTOGRAM, 0, myBarWidth, ClimaxHighColor);
      SetIndexLabel(0,"Climax High ");
      
      SetIndexBuffer(1,blue);
      SetIndexStyle(1,DRAW_HISTOGRAM, 0, myBarWidth, NeutralColor);
      SetIndexLabel(1,"Neutral");
      
      SetIndexBuffer(2,yellow);
      SetIndexStyle(2,DRAW_HISTOGRAM, 0,myBarWidth, LowColor);
      SetIndexLabel(2,"Low ");
      
      SetIndexBuffer(3,green);
      SetIndexStyle(3,DRAW_HISTOGRAM, 0,myBarWidth, HighChurnColor);
      SetIndexLabel(3,"HighChurn ");
      
      SetIndexBuffer(4,white);
      SetIndexStyle(4,DRAW_HISTOGRAM, 0,myBarWidth, ClimaxLowColor);
      SetIndexLabel(4,"Climax Low ");
      
      SetIndexBuffer(5,magenta);
      SetIndexStyle(5,DRAW_HISTOGRAM, 0,myBarWidth, ClimaxChurnColor);
      SetIndexLabel(5,"ClimaxChurn ");
      
      SetIndexBuffer(6,v4);
      SetIndexStyle(6,DRAW_LINE,0,2);
      SetIndexLabel(6,"Average("+MAPeriod+")");

      SetIndexBuffer(7,Buf);
      SetIndexStyle(7,DRAW_LINE);


      
      short_name = "Better Volume 1.4" ;
      IndicatorShortName(short_name);
      
      TAG = "betvol" ;

      tObjName06 = TAG + "06" ; 
      
      deinit() ;
//----
   return(0);
  }
//+------------------------------------------------------------------+
 

void ObDeleteObjectsByPrefix(string Prefix)
  {
   int L = StringLen(Prefix);
   int i = 0; 
   while(i < ObjectsTotal())
     {
       string ObjName = ObjectName(i);
       if(StringSubstr(ObjName, 0, L) != Prefix) 
         { 
           i++; 
           continue;
         }
       ObjectDelete(ObjName);
     }
  }  
//+------------------------------------------------------------------+
int deinit()
  {
       
   ObDeleteObjectsByPrefix(TAG); 
   
   TRO() ;   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   win =    WindowFind(short_name);
   
   double VolLowest,Range,Value2,Value3,HiValue2,HiValue3,LoValue3,tempv2,tempv3,tempv ;
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   if ( NumberOfBars == 0 ) 
      NumberOfBars = Bars-counted_bars;
   limit=NumberOfBars; //Bars-counted_bars;
   
   redbarnum= -1 ;bluebarnum= -1 ;yellowbarnum= -1 ;greenbarnum= -1 ;whitebarnum= -1 ;magentabarnum= -1 ;
      
   for(int i=0; i<limit; i++)   
   {      
         V = iVolume(symbol,period,i);
         H = iHigh(symbol,period,i);
         L = iLow(symbol,period,i);
         C = iClose(symbol,period,i);
         
         red[i]   = 0; 
         blue[i]  = V; 
                                
         yellow[i] = 0; green[i] = 0; white[i] = 0; magenta[i] = 0;
          
         
         Value2=0;Value3=0;HiValue2=0;HiValue3=0;LoValue3=99999999;tempv2=0;tempv3=0;tempv=0;
         
         index     = iLowest(symbol,period,MODE_VOLUME,LookBack,i) ;
         VolLowest = iVolume(symbol,period,index);
         
         if (V == VolLowest)
         {
               if(yellowbarnum == -1) { yellowbarnum = i ; }
               yellow[i]   = NormalizeDouble(V,0);
               blue[i]     = 0 ;
         }
               
         Range  = H-L;
         Value2 = V*Range;
         
         if ( Range != 0 ) { Value3 = V/Range; }          
         
         for ( int n=i;n<i+MAPeriod;n++ ) {tempv= iVolume(symbol,period,n) + tempv; } 
            
         v4[i] = NormalizeDouble(tempv/MAPeriod,0);
         

          for ( n=i;n<i+LookBack;n++)
          {
               nHigh   = iHigh(symbol,period,n);
               nLow    = iLow(symbol,period,n);
               nRange  = nHigh - nLow ;
               nVolume = iVolume(symbol,period,n);
               tempv2  = nVolume*nRange; 
               
               if ( tempv2 >= HiValue2 ) { HiValue2 = tempv2; }
                    
               if ( nVolume*nRange != 0 )
               {           
                     tempv3 = nVolume /nRange;
                     if ( tempv3 > HiValue3 ) 
                        HiValue3 = tempv3; 
                     if ( tempv3 < LoValue3 )
                        LoValue3 = tempv3;
               } 
          } // for n
                              
          if ( Value2 == HiValue2  && C > Range / 2 )
          {
               if(redbarnum == -1) { redbarnum = i ; }
               red[i]    = NormalizeDouble(V,0);
               blue[i]   = 0;
               yellow[i] = 0;
               
          }   
            
          if ( Value3 == HiValue3 )
          {
               if(greenbarnum == -1) { greenbarnum = i ; }
               green[i]  = NormalizeDouble(V,0);                
               blue[i]   = 0;
               yellow[i] = 0;
               red[i]    =0 ;
          }
          
          if ( Value2 == HiValue2 && Value3 == HiValue3 )
          {
               if(magentabarnum == -1) { magentabarnum = i ; }
               magenta[i] = NormalizeDouble(V,0);
               blue[i]    = 0;
               red[i]     = 0;
               green[i]   = 0;
               yellow[i]  = 0;
          } 
          
          if ( Value2 == HiValue2  && C <= Range / 2 )
          {
               if(whitebarnum == -1) { whitebarnum = i ; }
               white[i]   = NormalizeDouble(V,0);
               magenta[i] = 0 ;
               blue[i]    = 0 ;
               red[i]     = 0 ;
               green[i]   = 0 ;
               yellow[i]  = 0 ;
          } 
            
          if(bluebarnum <= 0 && blue[i] >= 0) { bluebarnum = i ; } 

            
         
      } // for
      
     

//----
   
    DoShow() ;  

    if(Show.Legend) { DoShowLegend(); }   
          
    WindowRedraw() ;
//----
   return(0);
  }


//+------------------------------------------------------------------+

void DoShow()
{
   for ( int z=2;z>=0;z--)
   {
   while(true)
   {
      if(red[z]    != 0 ) { Buf[z] = 1; colorVolume = ClimaxHighColor ;         tAlert = "Climax High" ; break;}
      if(blue[z]   != 0 ) { Buf[z] = 2; colorVolume = NeutralColor ; tAlert = "Neutral" ; break;}
      if(yellow[z] != 0 ) { Buf[z] = 3; colorVolume = LowColor ;      tAlert = "Low" ; break;}
      if(green[z]  != 0 ) { Buf[z] = 4; colorVolume = HighChurnColor ;       tAlert = "HighChurn" ; break;}
      if(white[z]  != 0 ) { Buf[z] = 5; colorVolume = ClimaxLowColor ;       tAlert = "Climax Low" ; break;}
      if(magenta[z]!= 0 ) { Buf[z] = 6; colorVolume = ClimaxChurnColor ;     tAlert = "ClimaxChurn" ; break;}      
      
      break; 
   } // while
   } // for
 
 
 
 if(  Show.Message ) 
 {  
   if(iVolume(symbol,period,0) > v4[0]) { tAlert = tAlert + " Above Average" ; }
   
   cVOLUME = iVolume(symbol,period,0); 
   pVOLUME = iVolume(symbol,period,1); 
   
   if( pVOLUME > 0 ) { VolumePct = 100 + 100 * ( cVOLUME - pVOLUME ) / pVOLUME ; }
   else { VolumePct = 0 ; }
   
   VolumePct  = MathAbs(VolumePct) ;
      

   tAlert = DoubleToStr(VolumePct,0) + "% Prev | " + tAlert ;

   if( v4[0] > 0 ) { AvgVolumePct = 100 + 100 * ( cVOLUME - v4[0] ) / v4[0] ; }
   else { AvgVolumePct = 0 ; }
   
   AvgVolumePct  = MathAbs(AvgVolumePct) ;
      

   tAlert = DoubleToStr(AvgVolumePct,0) + "% Avg | " + tAlert ;


   ObjectCreate(tObjName06, OBJ_LABEL, win, 0, 0);// 
   ObjectSetText(tObjName06, tAlert , myFontSize, myFont, colorVolume );  
   ObjectSet(tObjName06, OBJPROP_CORNER, 1);
   ObjectSet(tObjName06, OBJPROP_XDISTANCE, -70 + x.offset); // myCorner
   ObjectSet(tObjName06, OBJPROP_YDISTANCE,  y.offset); //     
 } // if
 
} // void
//+------------------------------------------------------------------+  
void DoShowLegend()
{ 

int yInc = 20 ;


   setObject(TAG+"CH","Climax High " ,50,yInc+20,ClimaxHighColor); setObject(TAG+"CH1",redbarnum ,11,yInc+21,ClimaxHighColor     ,"Courier New");
     
   setObject(TAG+"NE","Neutral     " ,50,yInc+33,NeutralColor); setObject(TAG+"NE1",bluebarnum ,11,yInc+34,NeutralColor     ,"Courier New");

   setObject(TAG+"LO","Low         " ,50,yInc+46,LowColor); setObject(TAG+"LO1",yellowbarnum ,11,yInc+46,LowColor,"Courier New");
  
   setObject(TAG+"HI","High        ",50,yInc+59,HighChurnColor); setObject(TAG+"HI1",greenbarnum ,11,yInc+59,HighChurnColor,"Courier New");

   setObject(TAG+"CL","Climax Low  " ,50,yInc+72,ClimaxLowColor); setObject(TAG+"CL1",whitebarnum ,11,yInc+72,ClimaxLowColor,"Courier New");
  
   setObject(TAG+"CC","Climax Churn",50,yInc+85,ClimaxChurnColor); setObject(TAG+"CC1",magentabarnum ,11,yInc+85,ClimaxChurnColor,"Courier New");
        
}

//+------------------------------------------------------------------+  

void setObject(string labelName,string text,int x,int y,color theColor, string font = "Courier New",int size=10,int angle=0)
{
 
      
      if (ObjectFind(labelName) == -1)
          {
             ObjectCreate(labelName,OBJ_LABEL,win,0,0);
             ObjectSet(labelName,OBJPROP_CORNER,1);
             if (angle != 0)
                  ObjectSet(labelName,OBJPROP_ANGLE,angle);
          }               
       ObjectSet(labelName,OBJPROP_XDISTANCE,x);
       ObjectSet(labelName,OBJPROP_YDISTANCE,y);
       ObjectSetText(labelName,text,size,font,theColor);
}
  
//+------------------------------------------------------------------+  
void TRO()
{   
   
   string tObjName03    = "TROTAG"  ;  
   ObjectCreate(tObjName03, OBJ_LABEL, 0, 0, 0);//HiLow LABEL
   ObjectSetText(tObjName03, CharToStr(78) , 12 ,  "Wingdings",  DimGray );
   ObjectSet(tObjName03, OBJPROP_CORNER, 3);
   ObjectSet(tObjName03, OBJPROP_XDISTANCE, 5 );
   ObjectSet(tObjName03, OBJPROP_YDISTANCE, 5 );  
}  
//+------------------------------------------------------------------+

/*
   setObject(TAG+"CH","Climax High " ,30,yInc+20,ClimaxHighColor); setObject(TAG+"CH1",Arrow ,11,yInc+21,ClimaxHighColor     ,"Wingdings");
     
   setObject(TAG+"NE","Neutral     " ,30,yInc+33,NeutralColor); setObject(TAG+"NE1",Arrow ,11,yInc+34,NeutralColor     ,"Wingdings");

   setObject(TAG+"LO","Low         " ,30,yInc+46,LowColor); setObject(TAG+"LO1",Arrow ,11,yInc+46,LowColor,"Wingdings");
  
   setObject(TAG+"HI","High        ",30,yInc+59,HighChurnColor); setObject(TAG+"HI1",Arrow ,11,yInc+59,HighChurnColor,"Wingdings");

   setObject(TAG+"CL","Climax Low  " ,30,yInc+72,ClimaxLowColor); setObject(TAG+"CL1",Arrow ,11,yInc+72,ClimaxLowColor,"Wingdings");
  
   setObject(TAG+"CC","Climax Churn",30,yInc+85,ClimaxChurnColor); setObject(TAG+"CC1",Arrow ,11,yInc+85,ClimaxChurnColor,"Wingdings");
     

Comment(
 

"v4[0]= ", DoubleToStr(v4[0],Digits) , "\n", 
"cVOLUME= ", DoubleToStr(cVOLUME,Digits) , "\n", 
  
"") ;  

Better Volume Indicator
EasyLanguage Code

Version 25 January 2009    Copyright www.Emini-Watch.com    All rights reserved


Better Volume Indicator

Inputs:	LowVol(True), ClimaxUp(True), ClimaxDown(True), Churn(True), ClimaxChurn(True), LowVolColor(Yellow), ClimaxUpColor(Red), 
ClimaxDownColor(White), ChurnColor(Green), ClimaxChurnColor(Magenta), Lookback(20), UseUpTicks(True), Use2Bars(True), Color(Cyan), ShowAvg(True), AvgColor(Red);
Variables:	BarColor(Cyan);

BarColor = Color;

If BarType > 1 or UseUpTicks = False then begin
	If C > O and Range <> 0 then Value1 = (Range/(2*Range+O-C))*UpTicks;
If C < O and Range <> 0 then Value1 = ((Range+C-O)/(2*Range+C-O))*UpTicks;
	If C = O then Value1 = 0.5*UpTicks;
	Value2 = UpTicks-Value1;
End;

If BarType <= 1 and UseUpTicks then begin
	Value1 = UpTicks;
	Value2 = DownTicks;
End;

Value3 = AbsValue(Value1+Value2);
Value4 = Value1*Range;
Value5 = (Value1-Value2)*Range;
Value6 = Value2*Range;
Value7 = (Value2-Value1)*Range;
If Range <> 0 then begin
	Value8 = Value1/Range;
	Value9 = (Value1-Value2)/Range;
	Value10 = Value2/Range;
	Value11 = (Value2-Value1)/Range;
	Value12 = Value3/Range;
End;
If Use2Bars then begin
	Value13 = Value3+Value3[1];
	Value14 = (Value1+Value1[1])*(Highest(H,2)-Lowest(L,2));
Value15 = (Value1+Value1[1]-Value2-Value2[1])*(Highest(H,2)-Lowest(L,2));
	Value16 = (Value2+Value2[1])*(Highest(H,2)-Lowest(L,2));
Value17 = (Value2+Value2[1]-Value1-Value1[1])*(Highest(H,2)-Lowest(L,2));
	If Highest(H,2) <> Lowest(L,2) then begin
		Value18 = (Value1+Value1[1])/(Highest(H,2)-Lowest(L,2));
Value19 = (Value1+Value1[1]-Value2-Value2[1])/(Highest(H,2)-Lowest(L,2));
		Value20 = (Value2+Value2[1])/(Highest(H,2)-Lowest(L,2));
Value21 = (Value2+Value2[1]-Value1-Value1[1])/(Highest(H,2)-Lowest(L,2));
		Value22 = Value13/(Highest(H,2)-Lowest(L,2));
	End;
End;

Condition1 = Value3 = Lowest(Value3,Lookback);
Condition2 = Value4 = Highest(Value4,Lookback) and C > O;
Condition3 = Value5 = Highest(Value5,Lookback) and C > O;
Condition4 = Value6 = Highest(Value6,Lookback) and C < O;
Condition5 = Value7 = Highest(Value7,Lookback) and C < O;
Condition6 = Value8 = Lowest(Value8,Lookback) and C < O;
Condition7 = Value9 = Lowest(Value9,Lookback) and C < O;
Condition8 = Value10 = Lowest(Value10,Lookback) and C > O;
Condition9 = Value11 = Lowest(Value11,Lookback) and C > O;
Condition10 = Value12 = Highest(Value12,Lookback);
If Use2Bars then begin
	Condition11 = Value13 = Lowest(Value13,Lookback);
Condition12 = Value14 = Highest(Value14,Lookback) and C > O and C[1] > O[1];
Condition13 = Value15 = Highest(Value15,Lookback) and C > O and C[1] > O[1];
Condition14 = Value16 = Highest(Value16,Lookback) and C < O and C[1] < O[1];
Condition15 = Value17 = Highest(Value17,Lookback) and C < O and C[1] < O[1];
Condition16 = Value18 = Lowest(Value18,Lookback) and C < O and C[1] < O[1];
Condition17 = Value19 = Lowest(Value19,Lookback) and C < O and C[1] < O[1];
Condition18 = Value20 = Lowest(Value20,Lookback) and C > O and C[1] > O[1];
Condition19 = Value21 = Lowest(Value21,Lookback) and C > O and C[1] > O[1];
	Condition20 = Value22 = Highest(Value22,Lookback);
End;

If BarType > 1 then begin
	If LowVol and (Condition1 or Condition11) then BarColor = LowVolColor;
If ClimaxUp and (Condition2 or Condition3 or Condition8 or Condition9 or Condition12 or Condition13 or Condition18 or Condition19) then BarColor = ClimaxUpColor;
If ClimaxDown and (Condition4 or Condition5 or Condition6 or Condition7 or Condition14 or Condition15 or Condition16 or Condition17) then BarColor = ClimaxDownColor;
	If Churn and (Condition10 or Condition20) then BarColor = ChurnColor;
If ClimaxChurn and (Condition10 or Condition20) and (Condition2 or Condition3 or Condition4 or Condition5 or Condition6 or Condition7 or Condition8 or Condition9 or Condition12 or Condition13 or Condition14 or Condition15 or Condition16 or Condition17 or Condition18 or Condition19) then BarColor = ClimaxChurnColor;
End;

If BarType <= 1 then begin
If LowVol and (Condition1 or (Condition11 and D=D[1])) then BarColor = LowVolColor;
If ClimaxUp and (Condition2 or Condition3 or Condition8 or Condition9 or ((Condition12 or Condition13 or Condition18 or Condition19) and D=D[1])) then BarColor = ClimaxUpColor;
If ClimaxDown and (Condition4 or Condition5 or Condition6 or Condition7 or ((Condition14 or Condition15 or Condition16 or Condition17) and D=D[1])) then BarColor = ClimaxDownColor;
If Churn and (Condition10 or (Condition20 and D=D[1])) then BarColor = ChurnColor;
If ClimaxChurn and (Condition10 or (Condition20 and D=D[1])) and (Condition2 or Condition3 or Condition4 or Condition5 or Condition6 or Condition7 or Condition8 or Condition9 or ((Condition12 or Condition13 or Condition14 or Condition15 or Condition16 or Condition17 or Condition18 or Condition19) and D=D[1])) then BarColor = ClimaxChurnColor;
End;

Plot1(Value3,"Volume",BarColor);
If ShowAvg then Plot2(Average(Value3,100),"Avg",AvgColor);


{************************ Change Log: ************************}
{23 November 2007 - Added LowChurn colored volume bars                      }
{19 April 2008 - Got rid of LowChurn and replaced with ClimaxDown           }
{19 April 2008 - Added open & close conditions with ClimaxUp and ClimaxDown }
{19 April 2008 - Added different calculations for tick/intra-day charts     }
{26 June 2008 - Added ability to turn average volume line on and off        }
{5 July 2008 - Changed Lookback from a variable to an input                 }
{13 July 2008 - Added 2 bar climax, churn and low volume conditions         }
{4 September 2008 - Changed daily bars calculation to match tick/intra-day  }
{25 January 2009 - Added condition total volume (Value3) could not be -ve   }

*/
         
         