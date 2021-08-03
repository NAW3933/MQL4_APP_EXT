//+------------------------------------------------------------------+
//|                                          Momentum-Multi.mq4 v1.0 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http: //www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Aqua
#property indicator_color3 YellowGreen
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_level1 0.0
#property indicator_levelcolor Red
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_SOLID

#define INDICATOR_VERSION "v1.0"

//---- input parameters
extern int MomPeriod1 = 14;
extern int MomPeriod2 = 10;
extern int MomPeriod3 = 1;

//---- buffers
double MomBuffer1[];
double MomBuffer2[];
double MomBuffer3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
    string short_name;
//---- indicator line
    SetIndexStyle( 0, DRAW_LINE );
    SetIndexStyle( 1, DRAW_LINE );
    SetIndexStyle( 2, DRAW_LINE );
    SetIndexBuffer( 0, MomBuffer1 );
    SetIndexBuffer( 1, MomBuffer2 );
    SetIndexBuffer( 2, MomBuffer3 );
//---- name for DataWindow and indicator subwindow label
    short_name = "Momentum-Multi " + INDICATOR_VERSION + "(" + MomPeriod1 + "," + MomPeriod2 + "," + MomPeriod3 + ")";
    IndicatorShortName( short_name );
    SetIndexLabel( 0, "Momentum-Multi(" + MomPeriod1 + ")" );
    SetIndexLabel( 1, "Momentum-Multi(" + MomPeriod2 + ")" );
    SetIndexLabel( 2, "Momentum-Multi(" + MomPeriod3 + ")" );
//----
    SetIndexDrawBegin( 0, MomPeriod1 );
    SetIndexDrawBegin( 1, MomPeriod2 );
    SetIndexDrawBegin( 2, MomPeriod3 );
//----
    return( 0 );
}

//+------------------------------------------------------------------+
//| Momentum                                                         |
//+------------------------------------------------------------------+
int start() {
    int counted_bars = IndicatorCounted();
    
    // Check for errors
    if ( counted_bars < 0 ) {
        return( -1 );
    }

    // Last bar will be recounted
    if ( counted_bars > 0 ) {
        counted_bars--;
    }
    
    // Get the upper limit
    int limit = Bars - counted_bars;
    
    for ( int ictr = 0; ictr < limit; ictr++ ) {
        MomBuffer1[ictr] = iMomentum( NULL, 0, MomPeriod1, PRICE_CLOSE, ictr ) - 100.0;
        MomBuffer2[ictr] = iMomentum( NULL, 0, MomPeriod2, PRICE_CLOSE, ictr ) - 100.0;
        MomBuffer3[ictr] = iMomentum( NULL, 0, MomPeriod3, PRICE_CLOSE, ictr ) - 100.0;
    }
    return( 0 );
}

//+------------------------------------------------------------------+