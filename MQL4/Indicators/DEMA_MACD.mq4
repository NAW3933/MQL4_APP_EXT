//+------------------------------------------------------------------+
//|                                                    DEMA_MACD.mq4 |
//+------------------------------------------------------------------+
#property link "http://www.forexfactory.com/showthread.php?t=29419"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1  Green
#property indicator_color2  Red
#property indicator_width1  2
#property indicator_width2  1

//---- input parameters
extern int	FastEMA		= 12,
				SlowEMA		= 26,
				SignalSMA	= 9;

//---- indicator buffers
double	Buffer1[],
			Buffer2[];

//---- help buffers
double	EMA1[],	EMAofEMA1[],
			EMA2[],	EMAofEMA2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
	IndicatorShortName("MACD of DEMA("+FastEMA+","+SlowEMA+","+SignalSMA+")");
	IndicatorBuffers(6);

//---- indicator buffers
	SetIndexStyle(0,DRAW_HISTOGRAM);
	SetIndexStyle(1,DRAW_LINE);
	SetIndexBuffer(0,Buffer1);
	SetIndexBuffer(1,Buffer2);

//---- help buffers
	SetIndexBuffer(2,EMA1);
	SetIndexBuffer(3,EMAofEMA1);
	SetIndexBuffer(4,EMA2);
	SetIndexBuffer(5,EMAofEMA2);
}

int start()
{
	int limit = MathMax(Bars-1-SlowEMA-IndicatorCounted(),1);

//---- EMAs
	for(int i = limit; i>=0; i--)
	{
		EMA1[i] = iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i);
		EMA2[i] = iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
	}

//---- EMAs of EMAs
	for(i = limit; i >=0; i--)
	{
		EMAofEMA1[i] = iMAOnArray(EMA1,Bars,FastEMA,0,MODE_EMA,i);
		EMAofEMA2[i] = iMAOnArray(EMA2,Bars,SlowEMA,0,MODE_EMA,i);
	}


//---- DEMAs and MACD
	for(i = limit; i >=0; i--)
	{
		double DEMA1 = 2.0 * EMA1[i] - EMAofEMA1[i],
				 DEMA2 = 2.0 * EMA2[i] - EMAofEMA2[i];

		Buffer1[i] = DEMA1 - DEMA2;
//		Buffer2[i] = DEMA2;
	}

//---- Signal Line
	for(i = limit; i >=0; i--)
		Buffer2[i] = iMAOnArray(Buffer1,Bars,SignalSMA,0,MODE_SMA,i);

//----
	return(0);
}

