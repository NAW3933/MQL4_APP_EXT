#property indicator_chart_window
#property indicator_buffers      2
#property indicator_label1       "DCBands H"
#property indicator_color1       clrBlue
#property indicator_type1        DRAW_LINE
#property indicator_style1       STYLE_SOLID
#property indicator_width1       1
#property indicator_label2       "DCBands L"
#property indicator_color2       clrRed
#property indicator_type2        DRAW_LINE
#property indicator_style2       STYLE_SOLID
#property indicator_width2       1

enum eDir {
	UP,
	DOWN
};

extern color Fill             = clrAqua;
extern int   ChannelPeriod    = 9;
extern int   ChannelPeriod2   = 26;
extern int   ChannelShift     = 0;
extern int   MaxBarsFill      = 4000;

color  goFill;
int    giChannelPeriod,
       giChannelShift,
       giMaxBarsFill;

double gadBufHigh[],
       gadBufLow[];
string gsDatawinName;
int    giMaxBarFilled;


int
OnInit() {
	giMaxBarFilled = 0;

	goFill      = Fill;
	
	if (ChannelPeriod >= 1)
		giChannelPeriod = ChannelPeriod;
	else
		giChannelPeriod = 1;
	
		giChannelShift = ChannelShift;

	
	if (MaxBarsFill >= 1)
		giMaxBarsFill = MaxBarsFill;
	else
		giMaxBarsFill = 1;
	
	SetIndexBuffer(0, gadBufHigh);
	SetIndexShift (0, giChannelShift);
	
	SetIndexBuffer(1, gadBufLow);
	SetIndexShift (1, giChannelShift);

	int    iMaxBarFillPrev = Min(Bars+1000, giMaxBarsFill-1);
	string sObjNameUP,
	       sObjNameDOWN;

	for (int iBarNum = 0;  iBarNum <= iMaxBarFillPrev;  iBarNum++) {
		sObjNameUP   = ObjName(iBarNum, UP);
		sObjNameDOWN = ObjName(iBarNum, DOWN);
		if (ObjectFind(sObjNameUP) >= 0  ||  ObjectFind(sObjNameDOWN) >= 0) {
			ObjectDelete(sObjNameUP);
			ObjectDelete(sObjNameDOWN);
		}
		else
			break;
	}
	
	return 0;
}

void
OnDeinit (const int ciReason) {
	int    iMaxBar = Min(giMaxBarsFill-1, Bars-1),
	       iMaxBarWithObj = iMaxBar-1;
	string sObjNameUP,
	       sObjNameDOWN;
	
	for (int iBarNum = giMaxBarFilled;  iBarNum >= 0;  iBarNum--) {
		sObjNameUP   = ObjName(iBarNum, UP);
		sObjNameDOWN = ObjName(iBarNum, DOWN);
		ObjectDelete(sObjNameUP);
		ObjectDelete(sObjNameDOWN);
	}
}

int
OnCalculate (const int       ciNumBars,
             const int       ciNumBarsUnchanged,
             const datetime& calTime[],
             const double&   cadOpen[],
             const double&   cadHigh[],
             const double&   cadLow[],
             const double&   cadClose[],
             const long&     calTickVolume[],
             const long&     calBarVolume[],
             const int&      caiSpread[]) {
	
	int    iNumBarsChanged = ciNumBars - ciNumBarsUnchanged,
	       iMaxBar     = Min(iNumBarsChanged-1, Bars-1-giChannelPeriod),
	       iMaxBarFill = Min(iMaxBar-1, giMaxBarsFill-1);
	datetime lTime0,
	         lTime1;
	string sObjNameUP,
	       sObjNameDOWN;

	if (iMaxBarFill > giMaxBarFilled)
		giMaxBarFilled = iMaxBarFill;
	
	for (int iBarNum = iMaxBar;  iBarNum >= 0;  iBarNum--) {
		gadBufHigh[iBarNum] = (cadHigh[iHighest(NULL, 0, MODE_HIGH, ChannelPeriod2, iBarNum)] +cadLow[iLowest(NULL, 0, MODE_LOW, ChannelPeriod2,  iBarNum)])/2;
		gadBufLow [iBarNum] = (cadHigh[iHighest(NULL, 0, MODE_HIGH, giChannelPeriod, iBarNum)]+cadLow[iLowest(NULL, 0, MODE_LOW, giChannelPeriod, iBarNum)])/2;
		
		if (iBarNum <= iMaxBarFill) {
			if (iBarNum >= giChannelShift) {
				lTime0 = calTime[iBarNum  -giChannelShift];
				lTime1 = calTime[iBarNum+1-giChannelShift];
			}
			else {
				lTime0 = calTime[iBarNum]   + giChannelShift*_Period*60;
				lTime1 = calTime[iBarNum+1] + giChannelShift*_Period*60;
			}

			sObjNameUP   = ObjName(iBarNum, UP);
			sObjNameDOWN = ObjName(iBarNum, DOWN);
			if (ObjectFind(sObjNameUP) < 0  ||  ObjectFind(sObjNameDOWN) < 0) {
				ObjectDelete(sObjNameUP);
				
				ObjectCreate    (0, sObjNameUP,   OBJ_TRIANGLE, 0, lTime1, gadBufHigh[iBarNum+1],
				                                                   lTime0, gadBufHigh[iBarNum],
				                                                   lTime0, gadBufLow [iBarNum]);
				ObjectDelete(sObjNameDOWN);
				ObjectCreate    (0, sObjNameDOWN, OBJ_TRIANGLE, 0, lTime0, gadBufLow [iBarNum],
				                                                   lTime1, gadBufLow [iBarNum+1],
				                                                   lTime1, gadBufHigh[iBarNum+1]);
			}
			else {

				ObjectSetInteger(0, sObjNameUP,   OBJPROP_TIME,  0, lTime1);
				ObjectSetDouble (0, sObjNameUP,   OBJPROP_PRICE, 0, gadBufHigh[iBarNum+1]);
				
				ObjectSetInteger(0, sObjNameUP,   OBJPROP_TIME,  1, lTime0);
				ObjectSetDouble (0, sObjNameUP,   OBJPROP_PRICE, 1, gadBufHigh[iBarNum]);
				
				ObjectSetInteger(0, sObjNameUP,   OBJPROP_TIME,  2, lTime0);
				ObjectSetDouble (0, sObjNameUP,   OBJPROP_PRICE, 2, gadBufLow [iBarNum]);
				
				
				ObjectSetInteger(0, sObjNameDOWN, OBJPROP_TIME,  0, lTime0);
				ObjectSetDouble (0, sObjNameDOWN, OBJPROP_PRICE, 0, gadBufLow [iBarNum]);
				
				ObjectSetInteger(0, sObjNameDOWN, OBJPROP_TIME,  1, lTime1);
				ObjectSetDouble (0, sObjNameDOWN, OBJPROP_PRICE, 1, gadBufLow [iBarNum+1]);
				
				ObjectSetInteger(0, sObjNameDOWN, OBJPROP_TIME,  2, lTime1);
				ObjectSetDouble (0, sObjNameDOWN, OBJPROP_PRICE, 2, gadBufHigh[iBarNum+1]);
			}

			ObjectSetString (0, sObjNameUP,   OBJPROP_TOOLTIP, "\n");
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_COLOR,      goFill);
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_STYLE,      STYLE_SOLID);
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_WIDTH,      1);
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_BACK,       TRUE);
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_SELECTABLE, FALSE);
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_SELECTED,   FALSE);
			ObjectSetInteger(0, sObjNameUP,   OBJPROP_HIDDEN,     TRUE);

			ObjectSetString (0, sObjNameDOWN, OBJPROP_TOOLTIP, "\n");
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_COLOR,      goFill);
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_STYLE,      STYLE_SOLID);
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_WIDTH,      1);
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_BACK,       TRUE);
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_SELECTABLE, FALSE);
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_SELECTED,   FALSE);
			ObjectSetInteger(0, sObjNameDOWN, OBJPROP_HIDDEN,     TRUE);

		}
	}
	
	return ciNumBars;
}

int
Max (int i1, int i2)
{
	if (i1 > i2)
		return(i1);
	return(i2);
}

int
Min (int i1, int i2)
{
	if (i1 < i2)
		return(i1);
	return(i2);
}

int
Max (int i1, int i2, int i3)
{
	return(  Max( Max(i1, i2), i3 )  );
}

int
Min (int i1, int i2, int i3)
{
	return(  Min( Min(i1, i2), i3 )  );
}


string
itoa     (int iNum, int iStrLen = 0, ushort uFill = ' ')
{
	return( IntegerToString((int)iNum, iStrLen, uFill) );
}

string
ObjName (int iNum, eDir iDir)
{
	if (iDir == UP)  return "DCBands_Tri_" + itoa(iNum,4) + "u";
	else             return "DCBands_Tri_" + itoa(iNum,4) + "d";
}