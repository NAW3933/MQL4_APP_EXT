//+------------------------------------------------------------------+
//|                                           MTF Moving Average.mq4 |
//|													2007, Christof Risch (iya)	|
//| Moving average from any timeframe.											|
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers	2
#property indicator_color1		Red
#property indicator_color2		LightSalmon

//---- input parameters
extern int	TimeFrame	= 0,		//	{1=M1, 5=M5, 15=M15, ..., 1440=D1, 10080=W1, 43200=MN1}
				PERIOD		= 14,
				Method		= 0,		//	{0=SMA, 1=EMA, 2=SMMA, 3=LWMA}
				AppliedPrice= 0;		//	{0=Close,1=Open,2=High,3=Low,4=Median,5=Typical,6=Weighted}
extern bool Backtesting	= false;	// Check to avoid problems in the visual backtesting mode.

//---- indicator buffers
double		Buffer[],
				BufferCurrent[];

//----
string	IndicatorName = "";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- name for DataWindow and indicator subwindow label
	switch(TimeFrame)
	{
		case 1:		IndicatorName="Period M1";		break;
		case 5:		IndicatorName="Period M5";		break;
		case 15:		IndicatorName="Period M15";	break;
		case 30:		IndicatorName="Period M30";	break;
		case 60:		IndicatorName="Period H1";		break;
		case 240:	IndicatorName="Period H4";		break;
		case 1440:	IndicatorName="Period D1";		break;
		case 10080:	IndicatorName="Period W1";		break;
		case 43200:	IndicatorName="Period MN1";	break;
		default:	  {TimeFrame = Period(); return(init());}
	}

	switch(Method)
	{
		case MODE_SMA:		IndicatorName = IndicatorName+" SMA("+PERIOD+")";	break;
		case MODE_EMA:		IndicatorName = IndicatorName+" EMA("+PERIOD+")";	break;
		case MODE_SMMA:	IndicatorName = IndicatorName+" SMMA("+PERIOD+")";	break;
		case MODE_LWMA:	IndicatorName = IndicatorName+" LWMA("+PERIOD+")";	break;
		default:			  {Method = MODE_SMA; return(init());}
	}

	IndicatorShortName(IndicatorName);
	SetIndexBuffer(0,Buffer);
	SetIndexBuffer(1,BufferCurrent);
	SetIndexStyle(0,DRAW_LINE);
	SetIndexStyle(1,DRAW_LINE);
	SetIndexLabel(0,IndicatorName);
	SetIndexLabel(1,IndicatorName+" Current Candle");
}


//+------------------------------------------------------------------+
//| MTF Moving Average                                               |
//+------------------------------------------------------------------+
int start()
{
//----
//	counted bars from indicator time frame
	static int countedBars1 = 0;

//----
//	Comment(TimeFrame+" Time[0] = "+iTime(NULL,TimeFrame,0));

//----
//	counted bars from display time frame
	if(Bars-1-IndicatorCounted() > 1 && countedBars1!=0)
		countedBars1 = 0;

	int bars1 = iBars(NULL,TimeFrame),
		 start1 = bars1-1-countedBars1,
		 limit1 = iBarShift(NULL,TimeFrame,Time[Bars-1]);

	if(countedBars1 != bars1-1)
	{
		if(!Backtesting)
			countedBars1  = bars1-1;

		ArrayInitialize(BufferCurrent,EMPTY_VALUE);
	}


	if(start1 > limit1 && limit1 != -1)
		start1 = limit1;

//----
//	3... 2... 1... GO!
	for(int i = start1; i >= 0; i--)
	{
		int shift1 = i;

		if(TimeFrame < Period())
			shift1 = iBarShift(NULL,TimeFrame,Time[i]);

		int time1  = iTime    (NULL,TimeFrame,shift1),
			 shift2 = iBarShift(NULL,0,time1);

		double ma = iMA(NULL,TimeFrame,PERIOD,0,Method,AppliedPrice,shift1);

	//----
	//	old (closed) candles
		if(shift1>=1)
		{
			Buffer[shift2] = ma;
		}

	//----
	//	current candle
		if((TimeFrame >=Period() && shift1<=1)
		|| (TimeFrame < Period() &&(shift1==0||shift2==1)))
		{
			BufferCurrent[shift2] = ma;
		}

	//----
	//	linear interpolatior for the number of intermediate bars, between two higher timeframe candles.
		int n = 1;
		if(TimeFrame > Period())
		{
			int shift2prev = iBarShift(NULL,0,iTime(NULL,TimeFrame,shift1+1));

			if(shift2prev!=-1 && shift2prev!=shift2)
				n = shift2prev - shift2;
		}

	//----
	//	apply interpolation
		double factor = 1.0 / n;
		if(shift1>=1)
		if(Buffer[shift2+n]!=EMPTY_VALUE && Buffer[shift2]!=EMPTY_VALUE)
		{
			for(int k = 1; k < n; k++)
			{
				Buffer[shift2+k] = k*factor*Buffer[shift2+n] + (1.0-k*factor)*Buffer[shift2];
			}
		}

	//----
	//	current candle
		if(shift1==0)
		if(BufferCurrent[shift2+n]!=EMPTY_VALUE && BufferCurrent[shift2]!=EMPTY_VALUE)
		{
			for(k = 1; k < n; k++)
			{
				BufferCurrent[shift2+k] = k*factor*BufferCurrent[shift2+n] + (1.0-k*factor)*BufferCurrent[shift2];
			}
		}
	}

	if(Backtesting && Period()!=TimeFrame)
	{
		Buffer[0]			= EMPTY_VALUE;
		BufferCurrent[0]	= EMPTY_VALUE;
	}

	return(0);
}


