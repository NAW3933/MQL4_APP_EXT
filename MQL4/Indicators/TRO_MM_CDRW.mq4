//+------------------------------------------------------------------+ 
//|   TRO_MM_CDRW                                                    | 
//|                                                                  | 
//|   Copyright © 2009, Avery T. Horton, Jr. aka TheRumpledOne       |
//|                                                                  |
//|   PO BOX 43575, TUCSON, AZ 85733                                 |
//|                                                                  |
//|   GIFTS AND DONATIONS ACCEPTED                                   | 
//|   All my indicators should be considered donationware. That is   |
//|   you are free to use them for your personal use, and are        |
//|   under no obligation to pay for them. However, if you do find   |
//|   this or any of my other indicators help you with your trading  |
//|   then any Gift or Donation as a show of appreciation is         |
//|   gratefully accepted.                                           |
//|                                                                  |
//|   Gifts or Donations also keep me motivated in producing more    |
//|   great free indicators. :-)                                     |
//|                                                                  |
//|   PayPal - THERUMPLEDONE@GMAIL.COM                               |  
//+------------------------------------------------------------------+ 
//| Use http://therumpledone.mbtrading.com/fx/ as your forex broker  |  
//| ...tell them therumpledone sent you!                             |  
//+------------------------------------------------------------------+ 


#property  copyright "Copyright © 2009, Avery T. Horton, Jr. aka TRO" 
#property  link      "http://www.therumpledone.com/" 
 

#property indicator_chart_window
  

//+------------------------------------------------------------------+  
  
extern int  yAxis  = 50 ;
extern int  Corner = 1;


extern bool   Show.Legend  = true ;

extern color TextColor    = DodgerBlue;
extern color HiLightColor = Magenta;

extern color ReverseColor  = Magenta;
extern color DemandColor   = Aqua;
extern color SupplyColor   = Red;
extern color WarningColor  = Yellow;
extern color NoSignalColor = DimGray;

extern int     NumberOfBars = 300;
extern double  Offset = 5;


//+------------------------------------------------------------------+

double num, denom;

int tframe[]={1,5,15,30,60,240,1440,10080,43200};

string tf[]={"M1","M5","M15","M30","H1","H4","D1","W1","MN","TOT"};

int tfnumber=9,columns=9 ;  

double cValue, pValue, buyers, sellers, H,C,O,L, candle, CCI, demon ;

string TimeFrameStr;
double IndValLONG[9],IndValD[9] , CMI[9];

int xpos[10], ypos[10];
int w , j , xposTAG, LONG,   CC, nHH, nLL;

string TAG = "CDRWmm"   ;

string ArrowReverse   ; 
string ArrowDemand  ;  
string ArrowSupply   ;  
string ArrowWarning   ;  
string ArrowNoSignal   ;  

string theArrowLONG[10],theArrowD[10] ;
color   theColorLONG[10], theColorD[10] ;



string symbol, tChartPeriod,  tLONGName ;  
int    digits, period , i ; 
 
double point ;

color thecolor, hdColor ;  

double   CDRW_R, CDRW_D, CDRW_S, CDRW_W ;

bool BreakOutUp, BreakOutDn, TrendingUp, TrendingDn, CounterTrend ; 
bool CloseAboveHigh, CloseBelowLow, CrossAboveHigh, CrossBelowLow, candlegreen, candlered; 

string CustomName ;

int shift = 1;

//+------------------------------------------------------------------+
int init()
{

ArrowReverse  =  CharToStr(119) ;
ArrowDemand   =  CharToStr(233) ; 
ArrowSupply   =  CharToStr(234) ;  
ArrowWarning  =  CharToStr(251) ; 
ArrowNoSignal =  CharToStr(108) ; 

 

deinit();

   period       = Period() ;   
   symbol       = Symbol() ;
   digits       =  Digits ;   
   point        =  Point ; 

   if(digits == 5 || digits == 3) { digits = digits - 1 ; point = point * 10 ; }   
 

if(Corner == 1 || Corner == 3)
{ 
   for( w = 0 ; w < columns ; w++) { xpos[w] = 15 + ((10 - w)*23) ; } 
   xposTAG = 270 ;
} 
else
{
   for( w=0;w<columns;w++) { xpos[w] = w*23 + 50 ; }
   xposTAG = 10 ;
}

         ObjectCreate(TAG+"HD1",OBJ_LABEL,0,0,0,0,0);
         ObjectSet(TAG+"HD1",OBJPROP_CORNER,Corner);
         ObjectSet(TAG+"HD1",OBJPROP_XDISTANCE,xposTAG);
         ObjectSet(TAG+"HD1",OBJPROP_YDISTANCE,yAxis+30);
         ObjectSetText(TAG+"HD1","CDRW" ,8,"Tahoma",TextColor);
         
/*
         ObjectCreate(TAG+"HD",OBJ_LABEL,0,0,0,0,0);
         ObjectSet(TAG+"HD",OBJPROP_CORNER,Corner);
         ObjectSet(TAG+"HD",OBJPROP_XDISTANCE,xposTAG);
         ObjectSet(TAG+"HD",OBJPROP_YDISTANCE,yAxis+50);
         ObjectSetText(TAG+"HD","LONG",8,"Tahoma",TextColor);

 
         
         ObjectCreate(TAG+"HD2",OBJ_LABEL,0,0,0,0,0);
         ObjectSet(TAG+"HD2",OBJPROP_CORNER,Corner);
         ObjectSet(TAG+"HD2",OBJPROP_XDISTANCE,xposTAG);
         ObjectSet(TAG+"HD2",OBJPROP_YDISTANCE,yAxis+70);
         ObjectSetText(TAG+"HD2","C-C",8,"Tahoma",TextColor);         
*/

   for( w=0;w<columns;w++)
      {
      
         if(tframe[w] == period) { hdColor = HiLightColor ; }
         else  { hdColor = TextColor ; }
      
         ObjectCreate(TAG+tf[w],OBJ_LABEL,0,0,0,0,0);
         ObjectSet(TAG+tf[w],OBJPROP_CORNER,Corner);
         ObjectSet(TAG+tf[w],OBJPROP_XDISTANCE,xpos[w]);
         ObjectSet(TAG+tf[w],OBJPROP_YDISTANCE,yAxis+15);
         ObjectSetText(TAG+tf[w],tf[w],8,"Tahoma",hdColor);                     
      }

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
int start()
  {
   
//----
   

   for( j=0;j<columns ;j++)
   {
      if (ObjectFind(TAG+j) != 0)
      {
      
         ObjectCreate(TAG+j+"C",OBJ_LABEL,0,0,0,0,0);        
         ObjectSet(TAG+j+"C",OBJPROP_CORNER,Corner);
         ObjectSet(TAG+j+"C",OBJPROP_XDISTANCE,xpos[j]);
         ObjectSet(TAG+j+"C",OBJPROP_YDISTANCE,yAxis+30);
         ObjectSetText(TAG+j+"C","00",8,"Tahoma",White);
         
/*                 
         ObjectCreate(TAG+j,OBJ_LABEL,0,0,0,0,0);
         ObjectSet(TAG+j,OBJPROP_CORNER,Corner);
         ObjectSet(TAG+j,OBJPROP_XDISTANCE,xpos[j]);
         ObjectSet(TAG+j,OBJPROP_YDISTANCE,yAxis+50);
         ObjectSetText(TAG+j,CharToStr(108),12,"Wingdings",White);
       
         
         ObjectCreate(TAG+j+"D",OBJ_LABEL,0,0,0,0,0);         
         ObjectSet(TAG+j+"D",OBJPROP_CORNER,Corner);
         ObjectSet(TAG+j+"D",OBJPROP_XDISTANCE,xpos[j]);
         ObjectSet(TAG+j+"D",OBJPROP_YDISTANCE,yAxis+70);
         ObjectSetText(TAG+j+"D",CharToStr(110),12,"Tahoma",White);              
*/         
         
      }// if
   } // for

    
   for(int x=0;x<tfnumber;x++)
   {
 
   CustomName = "CDRW_TRO_MODIFIED_VERSION"; 
   
   CDRW_R = iCustom(symbol, tframe[x], CustomName, NumberOfBars,Offset,   0,shift);       
   CDRW_D = iCustom(symbol, tframe[x], CustomName, NumberOfBars,Offset,   1,shift);
   CDRW_S = iCustom(symbol, tframe[x], CustomName, NumberOfBars,Offset,   2,shift);
   CDRW_W = iCustom(symbol, tframe[x], CustomName, NumberOfBars,Offset,   3,shift);  
         
 
   
 
        if (CDRW_R > 0 )
        {       
         theArrowLONG[x] = ArrowReverse ;
         theColorLONG[x] = ReverseColor ;
        }
        else if (CDRW_D > 0 )
        {
         theArrowLONG[x] = ArrowDemand ;
         theColorLONG[x] = DemandColor ;         
        }
        else if (CDRW_S > 0 )
        {
         theArrowLONG[x] = ArrowSupply ;
         theColorLONG[x] = SupplyColor ;         
        }  
        else if (CDRW_W > 0 )
        {
         theArrowLONG[x] = ArrowWarning ;
         theColorLONG[x] = WarningColor ;         
        }               
        else 
        {
         theArrowLONG[x] = ArrowNoSignal ;
         theColorLONG[x] = NoSignalColor ;
        } 
 
          
      for(int  y=0;y<columns;y++)
      { 
//         ObjectSetText(TAG+y,theArrowLONG[y],12,"Wingdings",theColorLONG[y]);
         ObjectSetText(TAG+y+"C",theArrowLONG[y] ,9,"Wingdings",theColorLONG[y]);
//         ObjectSetText(TAG+y+"D",theArrowD[y],12,"Wingdings",theColorD[y]);
      }  
  
  } // for
//----


      if(Show.Legend) { DoShowLegend(); }   

   return(0);
  }
//+------------------------------------------------------------------+  
void DoShowLegend()
{ 

   setObject(TAG+"gz","Reverse " ,30,20,ReverseColor); setObject(TAG+"gz1",ArrowReverse,11,21,ReverseColor     ,"Wingdings");
     
   setObject(TAG+"gl","Demand  " ,30,33,DemandColor); setObject(TAG+"gl1",ArrowDemand,11,34,DemandColor     ,"Wingdings");

   setObject(TAG+"biH","Supply " ,30,46,SupplyColor); setObject(TAG+"biD1",ArrowSupply,11,46,SupplyColor,"Wingdings");
  
   setObject(TAG+"biD","Warning ",30,59,WarningColor); setObject(TAG+"biH1",ArrowWarning,11,59,WarningColor,"Wingdings");
    
}
//+------------------------------------------------------------------+  

void setObject(string labelName,string text,int x,int y,color theColor, string font = "Courier New",int size=10,int angle=0)
{
 
      
      if (ObjectFind(labelName) == -1)
          {
             ObjectCreate(labelName,OBJ_LABEL,0,0,0);
             ObjectSet(labelName,OBJPROP_CORNER,0);
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

if( tframe[x] == 30 ) 
{ 
Comment(
"shift " , shift , "\n" ,
"tframe[x] " , tframe[x] , "\n" ,
"CDRW_R " , DoubleToStr(CDRW_R,Digits) , "\n" ,
"CDRW_D " , DoubleToStr(CDRW_D,Digits) , "\n" , 
"CDRW_S " , DoubleToStr(CDRW_S,Digits) , "\n" ,
"CDRW_W " , DoubleToStr(CDRW_W,Digits) , "\n" ,
 

"") ;  
}
   

 

Comment(
"tframe[x] " , tframe[x] , "\n" ,
"HH " , DoubleToStr(HH,Digits) , "\n" ,
"LL " , DoubleToStr(LL,Digits) , "\n" , 
"CMI[x] " , DoubleToStr(CMI[x],Digits) , "\n" ,
"close " , DoubleToStr(close,Digits) , "\n" ,
"pclose " , DoubleToStr(pclose,Digits) , "\n" ,
"denom " , DoubleToStr(denom,Digits) , "\n" ,
"num " , DoubleToStr(num,Digits) , "\n" ,
"CCI " , DoubleToStr(CCI,Digits) , "\n" ,

"") ; 

*/