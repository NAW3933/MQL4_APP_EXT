//+------------------------------------------------------------------+
//|                                         Indicator Market Way.mq4 |
//|                       Copyright � 2007, O.Konovalov aka Regul    |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2007 O.Konovalov"
#property link      "E-mail:O_Konovalov@ukr.net"
#property link      "E-mail:RegulStar@gmail.com"

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 SteelBlue
#property indicator_color2 Goldenrod
#property indicator_color3 Navy
#property indicator_color4 YellowGreen
#property indicator_color5 DeepPink
#property indicator_color6 OrangeRed
#property indicator_color7 DarkOliveGreen
#property indicator_color8 MediumPurple

//---- input parameters
extern int       IdMain   = 12; // main line
extern int       IdBull   = 12; // bull line 
extern int       IdBear   = 12; // bear line 
extern int       IdArray  = 12; // all sma line  

//---- buffers
double ExtMapBuffer[];
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- ��������� �����������
   SetIndexStyle(0,DRAW_HISTOGRAM,0,4);
   SetIndexBuffer(0,ExtMapBuffer);
   SetIndexArrow(0,158);
   //---
   SetIndexStyle(1,DRAW_HISTOGRAM,0,4);
   SetIndexBuffer(1,ExtMapBuffer1);
   SetIndexArrow(1,158);
   //---
   SetIndexStyle(2,DRAW_ARROW,0,3);
   SetIndexBuffer(2,ExtMapBuffer2);
   SetIndexArrow(2,158);
   //---
   SetIndexStyle(3,DRAW_LINE,0,1);
   SetIndexBuffer(3,ExtMapBuffer3);
   //---
   SetIndexStyle(4,DRAW_LINE,0,1);
   SetIndexBuffer(4,ExtMapBuffer4);
   //---
   SetIndexStyle(5,DRAW_LINE,0,1);
   SetIndexBuffer(5,ExtMapBuffer5);
   SetIndexArrow(5,158);
   //---
   SetIndexStyle(6,DRAW_LINE,0,1);
   SetIndexBuffer(6,ExtMapBuffer6);
   SetIndexArrow(3,158);
   //---
   SetIndexStyle(7,DRAW_LINE,0,1);
   SetIndexBuffer(7,ExtMapBuffer7);


   //--- ������������ ���������� � ��������� �������� �� ������
   IndicatorShortName("Market Way");
   //---
   SetIndexLabel(0, "Bull Pressue_MW0");
   SetIndexLabel(1, "Bear Pressue_MW1");
   SetIndexLabel(2, "Main Accumulation_MW2"); 
   SetIndexLabel(3, "Bull Accumulation_MW3");
   SetIndexLabel(4, "Bear Accumulation_MW4");
   SetIndexLabel(5, "Main SMA_MW5");
   SetIndexLabel(6, "Bull SMA_MW6");
   SetIndexLabel(7, "Bear SMA_MW7");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
   double   bull,bear,faster,fast,main;
//----
   int counted_bars=IndicatorCounted();
   if  (counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars-1;
   int i=limit;
   //--- �������� ����������
   //---
//***********************************************������ ��� ��������**********************************************
   while (i>=0)
   {
      //--- MW2 ����� ���������(���� � �������) ����������� ����������� �������� �����
      //�� �� ��� � ���� ���� IdMain-�� ��������� (SMA) ���������� �� ��������� � ���������  
      //������������ �������� ��������� �� ���������� SMA �� Close ���� ��� SMA �� Open, ������������� ��������! 
      main=0;
      for(int m=0;m<IdMain;m++)
         {
         main = main+(Close[i+m]-Open[i+m]); //����� ������� �������� � �������� �� IdMain ������
         }
         ExtMapBuffer2[i]=NormalizeDouble(main,Digits);
      
      //--- MW3 ����� ����� ����������� ����������� �������� (�� ��, ��� � S�� �� Close)
      //����� ��������� ������ ����� ���� � ���� �� �������� ������, �.�. ��, ������� ������� ������� Close-Open>=0
      bull=0;
      for(int bu=0;bu<IdBull;bu++)
         {
         if (Close[i+bu]-Open[i+bu]>=0.0000)
         bull = bull+(Close[i+bu]-Open[i+bu]); 
         }
         ExtMapBuffer3[i]=NormalizeDouble(bull,Digits);
   
      //--- MW4 ����� �������� ����������� ����������� �������� (�� ��, ��� � S�� �� Open)
      //����� ��������� ������ �������� ���� � ���� �� �������� ������, �.�. ��, ������� ������� ������� Close-Open<=0
      bear=0;
      for(int be=0;be<IdBear;be++)
         {
         if (Close[i+be]-Open[i+be]<=0.0000)
         bear = bear+(Close[i+be]-Open[i+be]); 
         }
         ExtMapBuffer4[i]=NormalizeDouble(bear,Digits);
   i--; //���������� �������� �������
   }
//----------------------------------------------------- SMA 
      //--- MW5 �����  SMA �� ��������� ����������� 
      for(i=0; i<limit; i++)
      ExtMapBuffer5[i] = NormalizeDouble(iMAOnArray(ExtMapBuffer2,0,IdArray,0,MODE_SMA,i),Digits);
      
      //--- MW6 �����  SMA ������ �����������
      for(i=0; i<limit; i++)
      ExtMapBuffer6[i] = NormalizeDouble(iMAOnArray(ExtMapBuffer3,0,IdArray,0,MODE_SMA,i),Digits);

      //--- MW7 �����  SMA ��������� �����������
      for(i=0; i<limit; i++)
      ExtMapBuffer7[i] = NormalizeDouble(iMAOnArray(ExtMapBuffer4,0,IdArray,0,MODE_SMA,i),Digits);

//----------------------------------------------------- �������� SMA � ��������� ������ 
      //--- MW0 ����� "����� ��������"
      //"���� �����" ��������� "�������" ����� �� ������ "+"
      //��� �������� �� ������ "-" ����� �������� ����� "��������")
      //������������ ����������� �������� �/��� ��������� ������� ����������� � �� ��� "�� �����" �� ��������� ������
      for(i=0; i<limit; i++)
      ExtMapBuffer[i] = ExtMapBuffer3[i]-ExtMapBuffer6[i];
      
      //--- MW1 ����� "�������� ��������"
      //"���� ��������" ��������� "�������" ����� �� ������ "-"
      //��� �������� �� ������ "+" ����� �������� ����� "��������")
      //������������ ����������� �������� �/��� ��������� ������� ����������� � �� ��� "�� �����" �� ��������� ������
      for(i=0; i<limit; i++)
      ExtMapBuffer1[i] = ExtMapBuffer4[i]-ExtMapBuffer7[i];

//----
   return(0);
  }
//+------------------------------------------------------------------+

