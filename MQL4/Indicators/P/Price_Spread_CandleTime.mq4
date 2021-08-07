//+-----------------------------------------------------------------------+
//|Price_Spread_CandleTime.mq4                                  by xecret |
//+-----------------------------------------------------------------------+

#property indicator_chart_window


static string   Indicator_Name      ="Price_Spread_CandleTime";
static string   Version             ="1.0";

extern color    DnColor           =Red;
extern color    UpColor           =Blue;
extern color    FlatColor         =Yellow;



extern string   d1_                     =" : Corner : 0=Top Left";
extern string   d2_                     =" : : 1=Top Right";
extern string   d3_                     =" : : 2=Bottom Left";
extern string   d4_                     =" : : 3=Bottom Right";
extern int      Display_Corner          =3;
extern color    color_text              =Yellow;
extern int      label_textsize          =6;
extern bool     Show_Candle_Time        =TRUE,
                Show_Spread             =TRUE;

extern string   Space="                        ";
extern bool     Show_Market_Price       =TRUE;
extern int      Size_Market_Price       =20;
extern int      Extra_Digit_SizeDiff    =0;



static double   Market_Old_Price;

                
static int      PipDelta=1;
                

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if( Digits==3 || Digits==5 )
     {
      PipDelta=PipDelta*10;
     }
   
   
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   int _ObjectsTotal=ObjectsTotal();
   for( int _Object=_ObjectsTotal; _Object>=0; _Object-- )
     {
      string _ObjectName=ObjectName( _Object );
      if( StringSubstr( _ObjectName, 0, StringLen( Indicator_Name )+2 )=="["+Indicator_Name+"]" ) ObjectDelete( _ObjectName );
     }    
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if( Show_Candle_Time )
     {
      int m,s,k;
      m=Time[0]+Period()*60-CurTime();
      s=m%60;
      m=(m-m%60)/60;
      string candle_text=Space+m;
      if( s<10 )
        {
         candle_text=candle_text+":0"+s;
        }
      else
        {
         candle_text=candle_text+":"+s;
        }
      if( Show_Spread )
         candle_text=candle_text+" / "+DoubleToStr( MarketInfo( Symbol(), MODE_SPREAD )/PipDelta, 1 );
      if( ObjectFind( "["+Indicator_Name+"] CandleTime")!=0 ) ObjectCreate( "["+Indicator_Name+"] CandleTime", OBJ_TEXT, 0, Time[0], Close[0] );
      else                                                    ObjectMove( "["+Indicator_Name+"] CandleTime", 0, Time[0], Close[0] );
      ObjectSetText( "["+Indicator_Name+"] CandleTime", candle_text, label_textsize+7, "Arial Narrow", color_text);
      Comment(candle_text);
     }
   if( Show_Market_Price )
     {
      color Market_Color=FlatColor;
      string BidA, BidB, Market_Price; 
      BidA=DoubleToStr( Bid, Digits );   // Full base as string
      int SLength=StringLen( BidA ), DigitOffset=0;
      BidB=StringSubstr( BidA, SLength-1, 1 );
      if( Bid>Market_Old_Price ) Market_Color=UpColor;
      if( Bid<Market_Old_Price ) Market_Color=DnColor;
      Market_Old_Price=Bid;
      if( Digits==3 || Digits==5 )
        {
         DigitOffset=Size_Market_Price-( Extra_Digit_SizeDiff/2 );
         BidA=StringSubstr( BidA, 0, SLength-1 );
         _Draw_Label( 1, 1, Size_Market_Price-Extra_Digit_SizeDiff, "Market_PriceB", BidB, Market_Color, "Arial Bold" );
         _Draw_Label( DigitOffset-5, 1, Size_Market_Price, "Market_PriceA", BidA, Market_Color, "Arial Bold" );
        }
      else
         _Draw_Label( 1, 1, Size_Market_Price, "Market_PriceA", BidA, Market_Color, "Arial Bold" );
     }
     
    
     
   return(0);
  }

//+------------------------------------------------------------------+
//| Draws a label                                                    |
//+------------------------------------------------------------------+
void _Draw_Label( int _x, int _y, int _fontSize, string _name, string _text, color _color, string _fontName, int _Display_Corner=-1 )
  {
   if( _Display_Corner==-1 ) _Display_Corner=Display_Corner;
   ObjectDelete( "["+Indicator_Name+"] "+_name );
   ObjectCreate( "["+Indicator_Name+"] "+_name, OBJ_LABEL, 0, 0, 0 );
   ObjectSetText( "["+Indicator_Name+"] "+_name, _text, _fontSize, _fontName, _color );
   ObjectSet( "["+Indicator_Name+"] "+_name, OBJPROP_BACK, TRUE );
   ObjectSet( "["+Indicator_Name+"] "+_name, OBJPROP_CORNER, _Display_Corner );
   ObjectSet( "["+Indicator_Name+"] "+_name, OBJPROP_XDISTANCE, _x );
   ObjectSet( "["+Indicator_Name+"] "+_name, OBJPROP_YDISTANCE, _y );
  }

