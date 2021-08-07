//=============================================================================================
//Decompiled by lptuyen at www.forexisbiz.com (FIB Forum)
//Profile: http://www.forexisbiz.com/member.php/11057-lptuyen?tab=aboutme#aboutme
//Email: Lptuyen_fx@yahoo.com
//Another forum: lptuyen at WWI
//Profile: http://worldwide-invest.org/members/48543-lptuyen?tab=aboutme#aboutme
//=============================================================================================

#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 6

#property indicator_color1 Black
#property indicator_color2 LightSteelBlue   //Blue
#property indicator_color3 Crimson   //Red
#property indicator_color4 Black
#property indicator_color5 DarkOrange   //Yellow
#property indicator_color6 DodgerBlue   //Yellow
#property indicator_width1 2

extern int           HiLowPeriod  =  84;
extern int           SigMAPeriod  =  20;
extern ENUM_MA_METHOD  SigMAMode  =  MODE_SMA;
extern int            SigMAShift  =  5;
extern int           BandsPeriod  =  20;
extern int            BandsShift  =  5;
extern double     BandsDeviation  =  2.0;
extern bool             ShowText  =  true;
extern string            IndName  =  "TRENDANATOR TT";

//---
double G_ibuf_108[];
double G_ibuf_112[];
double G_ibuf_116[];
double G_ibuf_120[];
string Gs_124 = "";
double Gda_unused_140[];
double G_ibuf_144[];
double G_ibuf_148[];
double Gda_152[5000];
bool Gi_unused_156 = TRUE;
int G_datetime_160 = 0;
//---

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexStyle(2, DRAW_HISTOGRAM);
   SetIndexStyle(3, DRAW_NONE);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexBuffer(4, G_ibuf_144);
   SetIndexStyle(5, DRAW_LINE);
   SetIndexBuffer(5, G_ibuf_148);
   IndicatorDigits(Digits + 1);
   SetIndexBuffer(0, G_ibuf_108);
   SetIndexBuffer(1, G_ibuf_112);
   SetIndexBuffer(2, G_ibuf_116);
   SetIndexBuffer(3, G_ibuf_120);
   SetIndexDrawBegin(4, BandsPeriod + BandsShift);
   SetIndexDrawBegin(5, BandsPeriod + BandsShift);
   IndicatorShortName(IndName);
   SetIndexLabel(1, "UP");
   SetIndexLabel(2, "DOWN");
   SetIndexLabel(3, NULL);
   SetIndexLabel(4, "BB UP");
   SetIndexLabel(5, "BB DOWN");
   ArraySetAsSeries(Gda_152, TRUE);
   return (0);
}
	 	  	 	 	  	    	    	   	 			  	 		 		  	  			 	  		    		  			 				 		     	 		 		   		 	 	  				   	  		 	  				   		 		     	    						 	   
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_0;
   if (ArraySize(Gda_152) < Bars) ArrayResize(Gda_152, Bars);
   int Li_8 = IndicatorCounted();
   double Ld_12 = 0;
   double Ld_20 = 0;
   double Ld_28 = 0;
   double low_36 = 0;
   double high_44 = 0;
   if (ShowText) f0_0();
   int Li_52 = 0;
   int Li_56 = f0_1();
   if (Li_8 > 0) Li_8--;
   int Li_60 = Bars - Li_8;
   if (Li_60 < 35) Li_60 = 35;
   if (Li_56 && Li_60 < 40) Li_60 = 300;
   for (int Li_64 = 0; Li_64 < Li_60; Li_64++) {
      high_44 = High[iHighest(NULL, 0, MODE_HIGH, HiLowPeriod, Li_64)];
      low_36 = Low[iLowest(NULL, 0, MODE_LOW, HiLowPeriod, Li_64)];
      Ld_0 = (High[Li_64] + Low[Li_64] + Close[Li_64]) / 3.0;
      Ld_12 = 0.66 * ((Ld_0 - low_36) / (high_44 - low_36) - 0.5) + 0.67 * Ld_20;
      Ld_12 = MathMin(MathMax(Ld_12, -0.999), 0.999);
      Gda_152[Li_64] = MathLog((Ld_12 + 1.0) / (1 - Ld_12)) / 2.0 + Ld_28 / 2.0;
      Ld_20 = Ld_12;
      Ld_28 = Gda_152[Li_64];
      G_ibuf_108[Li_64] = Gda_152[Li_64];
   }
   for (Li_64 = 0; Li_64 < Li_60; Li_64++) G_ibuf_120[Li_64] = iMAOnArray(Gda_152, 0, SigMAPeriod, SigMAShift, SigMAMode, Li_64);
   bool Li_68 = TRUE;
   for (Li_64 = Li_60; Li_64 >= 0; Li_64--) {
      if (G_ibuf_108[Li_64] < G_ibuf_120[Li_64]) Li_68 = FALSE;
      else Li_68 = TRUE;
      if (!Li_68) {
         G_ibuf_116[Li_64] = G_ibuf_108[Li_64];
         G_ibuf_112[Li_64] = 0.0;
         Gs_124 = "SHORT";
         Li_52 = 255;
      } else {
         if (Li_68) {
            G_ibuf_112[Li_64] = G_ibuf_108[Li_64];
            G_ibuf_116[Li_64] = 0.0;
            Gs_124 = "LONG";
            Li_52 = 65280;
         }
      }
   }
   if (ShowText) f0_2(IndName, Gs_124, 20, Li_52, 100, 15);
   for (Li_64 = 0; Li_64 < Li_60; Li_64++) {
      G_ibuf_144[Li_64] = iBandsOnArray(Gda_152, 0, BandsPeriod, BandsDeviation, BandsShift, 1, Li_64);
      G_ibuf_148[Li_64] = iBandsOnArray(Gda_152, 0, BandsPeriod, BandsDeviation, BandsShift, 2, Li_64);
   }
   WindowRedraw();
   return (0);
}
		 	  	 	 							 		 	 			 		  		 	 		  		 	    	 			 				   	   	  	 	  			 	 	  	 				  	   		     		 		    		     		  	   				 		 	        			
// 19F6B3E57E7C3D034D6318C3C69149B4
void f0_0() {
   if (ObjectFind(IndName) == -1) ObjectCreate(IndName, OBJ_LABEL, WindowFind(IndName), 0, 0);
   f0_2(IndName, "", 20, White, 100, 15);
}
		 			 		 		    	 			 	 		 	 		 	 	   				 						 		 	  		  	 		 	   	 	 				 	   	       	 		      	  			  		      	  	 	  	   	 			 		    		  	
// F412C23B721CFEB0738FBC3525A5D9AC
void f0_2(string A_name_0, string A_text_8, int A_fontsize_16, color A_color_20, int A_x_24, int A_y_28) {
   ObjectSet(A_name_0, OBJPROP_CORNER, 1);
   ObjectSet(A_name_0, OBJPROP_XDISTANCE, A_x_24);
   ObjectSet(A_name_0, OBJPROP_YDISTANCE, A_y_28);
   ObjectSetText(A_name_0, A_text_8, A_fontsize_16, "Arial Black", A_color_20);
}
		     		 	 		  	 	  		 		  	 	 	 								    			 	 	   		 	 			 	 		  	 		  		   				    		       	 	 			 	       	 	 	 	 	 	  	 	  			   	    	
// 88F3AD7A7E7B65F5E0D00334A43C38C7
int f0_1() {
   int datetime_0 = iTime(Symbol(), PERIOD_M1, 0);
   if (G_datetime_160 == 0) G_datetime_160 = datetime_0;
   if (G_datetime_160 != datetime_0) {
      G_datetime_160 = datetime_0;
      return (1);
   }
   return (0);
}