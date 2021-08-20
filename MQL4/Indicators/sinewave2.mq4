#property copyright "www,forex-tsd.com"
#property link      "www,forex-tsd.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

#property indicator_minimum -1
#property indicator_maximum 1
#property indicator_level1 0

double Sine[];
double LeadSine[];
double Cycle[];
double Smooth[];

extern double Alpha = 0.07;
int buffers = 0;
int drawBegin = 0;

double tempReal, rad2Deg, deg2Rad;

int init() {
    drawBegin = 8;
    IndicatorBuffers(4);
    SetIndexBuffer(0,Sine);
    SetIndexBuffer(1,LeadSine);
    SetIndexBuffer(2,Cycle);
    SetIndexBuffer(3,Smooth);
    IndicatorShortName("Sinewave [" + DoubleToStr(Alpha, 2) + "]");      
    tempReal = MathArctan(1.0);
    rad2Deg = 45.0 / tempReal;
    deg2Rad = 1.0 / rad2Deg;
    return (0);
}
  
int start() {
    if (Bars <= drawBegin) return (0);
    int countedBars = IndicatorCounted();
    if (countedBars < 0) return (-1);
    if (countedBars > 0) countedBars--;
    int s, limit = Bars - countedBars - 1;
    for (s = limit; s >= 0; s--) {
        Smooth[s] = (P(s) + 2.0 * P(s + 1) + 2.0 * P(s + 2) + P(s + 3)) / 6.0;
        Cycle[s] = (1.0 - 0.5 * Alpha) * (1.0 - 0.5 * Alpha) * (Smooth[s] - 2.0 * Smooth[s + 1] + Smooth[s + 2]) 
            + 2.0 * (1.0 - Alpha) * Cycle[s + 1]
            - (1.0 - Alpha) * (1.0 - Alpha) * Cycle[s + 2];    
        double period = iCustom(0, 0, "CyclePeriod", Alpha, 0, s);
        int DCPeriod = MathFloor(period);
        double RealPart = 0.0;
        double ImagPart = 0.0;
        for (int count = 0; count < DCPeriod; count++) {
            RealPart += MathSin(deg2Rad * 360.0 * count / DCPeriod) * Cycle[s + count];
            ImagPart += MathCos(deg2Rad * 360.0 * count / DCPeriod) * Cycle[s + count];
        }
        double DCPhase;
        if (MathAbs(ImagPart) > 0.0000001) {
            DCPhase = rad2Deg * MathArctan(RealPart / ImagPart);
        } else if (MathAbs(ImagPart) <= 0.0000001) {
    	      if (RealPart >= 0.0) {
    	          DCPhase = 90.0;
    	      } else { 
    	          DCPhase = -90.0;
    	      }
        }
        DCPhase += 90.0;
        if (ImagPart < 0) {
            DCPhase += 180.0;
        }
        if (DCPhase > 315.0) {
            DCPhase -= 360.0;
        }
        Sine[s] = MathSin(DCPhase * deg2Rad);
        LeadSine[s] = MathSin((DCPhase + 45.0) * deg2Rad);        
        if (DCPhase == 180 && LeadSine[s + 1] > 0) {
            LeadSine[s] = MathSin(45 * deg2Rad);
        }
        if (DCPhase == 0 && LeadSine[s + 1] < 0) {
            LeadSine[s] = MathSin(225 * deg2Rad);
        }
    }
    return (0);
}

double P(int index) {
    return ((High[index] + Low[index]) / 2.0);
}

void initBuffer(double array[], string label = "", int type = DRAW_NONE, int arrow = 0, int style = EMPTY, int width = EMPTY, color clr = CLR_NONE) {
    SetIndexBuffer(buffers, array);
    SetIndexLabel(buffers, label);
    SetIndexEmptyValue(buffers, EMPTY_VALUE);
    SetIndexDrawBegin(buffers, drawBegin);
    SetIndexShift(buffers, 0);
    SetIndexStyle(buffers, type, style, width);
    SetIndexArrow(buffers, arrow);
    buffers++;
}