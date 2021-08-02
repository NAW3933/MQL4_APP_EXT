#property  copyright ""

#define N 100

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_width1 2

extern double x1 = 1;
extern double x2 = 1;
extern double x3 = 1;
extern double x4 = 2;
extern double y1 = 8;
extern double y2 = 4;
extern double y3 = 2;
extern double y4 = 1;


//---- buffers
double Y[];


int init()
  {
    IndicatorBuffers(1);
    SetIndexStyle(0,DRAW_LINE);
    SetIndexBuffer(0,Y);
    SetIndexDrawBegin(0, N);
    return(0);
  }

double func(int i){
return(x1*MathCos(y1*i) + x2*MathCos(y2*i) + x3*MathCos(y3*i) + x4*MathCos(y4*i));
}


int start()
  {   
    for (int i=0;i<N;i++)Y[i]=func(i);

return(0);
  }
//+------------------------------------------------------------------+