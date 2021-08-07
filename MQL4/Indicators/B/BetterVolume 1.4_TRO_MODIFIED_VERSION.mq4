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
#property indicator_color1 Red
#property indicator_color2 DeepSkyBlue
#property indicator_color3 Yellow
#property indicator_color4 Lime
#property indicator_color5 White
#property indicator_color6 Magenta
#property indicator_color7 Orange

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2

//+------------------------------------------------------------------+

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
extern int    myFontSize   = 20 ;



extern color ClimaxHighColor  = Red;
extern color NeutralColor     = DeepSkyBlue;
extern color LowColor         = Yellow;
extern color HighChurnColor   = Green;
extern color ClimaxLowColor   = White;
extern color ClimaxChurnColor = Magenta;

extern int    myBarWidth      = 2 ;

//+------------------------------------------------------------------+

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
         
         index     = iLowest(NULL,0,MODE_VOLUME,20,i) ;
         VolLowest = iVolume(symbol,period,index);
         
         if (V == VolLowest)
         {
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
               red[i]    = NormalizeDouble(V,0);
               blue[i]   = 0;
               yellow[i] = 0;
          }   
            
          if ( Value3 == HiValue3 )
          {
               green[i]  = NormalizeDouble(V,0);                
               blue[i]   = 0;
               yellow[i] = 0;
               red[i]    =0 ;
          }
          
          if ( Value2 == HiValue2 && Value3 == HiValue3 )
          {
               magenta[i] = NormalizeDouble(V,0);
               blue[i]    = 0;
               red[i]     = 0;
               green[i]   = 0;
               yellow[i]  = 0;
          } 
          
          if ( Value2 == HiValue2  && C <= Range / 2 )
          {
               white[i]   = NormalizeDouble(V,0);
               magenta[i] = 0 ;
               blue[i]    = 0 ;
               red[i]     = 0 ;
               green[i]   = 0 ;
               yellow[i]  = 0 ;

          } 
            
            
         
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
   ObjectSet(tObjName06, OBJPROP_XDISTANCE,  x.offset); // myCorner
   ObjectSet(tObjName06, OBJPROP_YDISTANCE,  y.offset); //     
 } // if
 
} // void
//+------------------------------------------------------------------+  
void DoShowLegend()
{ 

int yInc = 20 ;

   setObject(TAG+"CH","Climax High " ,30,yInc+20,ClimaxHighColor); setObject(TAG+"CH1",Arrow ,11,yInc+21,ClimaxHighColor     ,"Wingdings");
     
   setObject(TAG+"NE","Neutral     " ,30,yInc+33,NeutralColor); setObject(TAG+"NE1",Arrow ,11,yInc+34,NeutralColor     ,"Wingdings");

   setObject(TAG+"LO","Low         " ,30,yInc+46,LowColor); setObject(TAG+"LO1",Arrow ,11,yInc+46,LowColor,"Wingdings");
  
   setObject(TAG+"HI","High        ",30,yInc+59,HighChurnColor); setObject(TAG+"HI1",Arrow ,11,yInc+59,HighChurnColor,"Wingdings");

   setObject(TAG+"CL","Climax Low  " ,30,yInc+72,ClimaxLowColor); setObject(TAG+"CL1",Arrow ,11,yInc+72,ClimaxLowColor,"Wingdings");
  
   setObject(TAG+"CC","Climax Churn",30,yInc+85,ClimaxChurnColor); setObject(TAG+"CC1",Arrow ,11,yInc+85,ClimaxChurnColor,"Wingdings");
        
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


Comment(
 

"v4[0]= ", DoubleToStr(v4[0],Digits) , "\n", 
"cVOLUME= ", DoubleToStr(cVOLUME,Digits) , "\n", 
  
"") ;  


*/
         