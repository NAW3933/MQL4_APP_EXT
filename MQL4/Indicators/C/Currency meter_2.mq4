//+------------------------------------------------------------------+
//|                                               Currency meter.mq4 |
//+------------------------------------------------------------------+
#property indicator_chart_window

extern bool   CurrenciesWindowBelowTable = FALSE;
extern bool   ShowCurrencies             = TRUE;
extern bool   ShowCurrenciesSorted       = TRUE;
extern bool   ShowSymbolsSorted          = TRUE;
extern color  HandleBackGroundColor      = LightSlateGray;
extern color  DataTableBackGroundColor_1 = LightSteelBlue;
extern color  DataTableBackGroundColor_2 = Lavender;
extern color  CurrencysBackGroundColor   = LightSlateGray;
extern color  HandleTextColor            = White;
extern color  DataTableTextColor         = Black;
extern color  CurrencysTextColor         = White;
extern color  TrendUpArrowsColor         = MediumBlue;
extern color  TrendDownArrowsColor       = Red;
extern ENUM_BASE_CORNER Corner           = CORNER_RIGHT_UPPER;
extern string DontShowThisPairs  = "";

int colBackGround;
int colDataTableBackGroundCol;
int colDataTableBackGroundCol2;
int colCurrencysBackGroundCol;
int colHandleTextCol;
int colDataTableTextCol;
int colCurrencysTextCol;
int colTrendUpArrowsCol;
int colTrendDownArrowsCol;


string arrValidSymbols[27];  //FZ symbols from market watch 
double lstSymblStrngth[10][3]; //0:strength 1:Symbol position 2:Strength IsCalculated?

//Led Colors
int arLdClr[] = {255, 17919, 5275647, 65535, 3145645, 65280};

string sObjectName;
int arIndiProps[12];


int gia_168[10]; //Font Size?
//Led Before Arrow - Moe 
int gia_172[21] = {15, 23, 31, 35, 43, 47, 55, 67, 75, 83, 87, 91, 95, 99, 119, 123, 127, 143, 148, 156, 164};  
//Backround Shapes alighment
int gia_176[21] = {11, 17, 23, 26, 32, 35, 41, 50, 56, 62, 65, 68, 71, 74, 89, 92, 95, 107, 110, 116, 122};
//No idea
//int gia_180[21] = {};//4,5, 6, 7, 9, 10, 12, 15, 17, 19, 20, 21, 22, 23, 28, 29, 30, 34, 36, 38, 40};
//Reduce vertical rows
int gia_184[21] = {-3, -2, -1, -1, -2, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0};

string sCurrAry[8] = {"USD","EUR","GBP","CHF","JPY","CAD","AUD","NZD"};



int f0_6(
            string as_0, 
            int ai_8, 
            int ai_12, 
            int iVert, 
            int ai_20 = 1, 
            int ai_24 = 1, 
            int ai_28 = 0, 
            int ai_32 = 0, 
            int ai_36 = 0, 
            int iCorner = 0, 
            int ai_44 = 0, 
            string as_48 = "", 
            int ai_56 = 16777215
)
{
   int li_60;
   int li_80;
   string ls_112;
   int iXPos;
   
   if (iCorner != 0 && iCorner != 1) iCorner = 0;
   if (ai_44 < 0) ai_44 = 0;
   if (as_48 != "")
      {
      if (f0_9(as_48))
         {
            ai_12 += arIndiProps[0];
            iVert += arIndiProps[1];
            iCorner = arIndiProps[6]; //Chart Corner
            ai_44 = arIndiProps[8];
            ai_32 += arIndiProps[4];
            li_60 = arIndiProps[9] + 1;
         }
      }
   
   gia_168[0] = ai_12;
   gia_168[1] = iVert;
   gia_168[2] = ai_12 + ai_20 * gia_172[ai_28] - 1;
   gia_168[3] = iVert + ai_24 * gia_172[ai_28] - (ai_24 * 2 - 1);
   gia_168[6] = ai_32;
   gia_168[9] = ai_8;
   
   int li_84 = 1;
   int li_88 = gia_172[ai_28] - 2;
   int li_92 = gia_176[ai_28];
   string ls_96 = "";
   string ls_104 = "g";
   
   if (ai_20 == 1 && ai_24 == 1) {
   
      gia_168[4] = 0;
      gia_168[5] = 0;
      gia_168[7] = li_60;
      gia_168[8] = li_60;
      ls_96 = f0_7(as_0, gia_168, as_48);
      if (!f0_4(ls_96, gia_168[0], gia_168[1] + gia_184[ai_28], ls_104, li_92, iCorner, ai_56, ai_44)) Print(GetLastError());
      if (ai_36 == ai_56) return (0);
      gia_168[4] = 0;
      gia_168[5] = 1;
      gia_168[7] = li_60;
      gia_168[8] = li_60 + 1;
      ls_96 = f0_7(as_0, gia_168, as_48);
      if (!f0_4(ls_96, gia_168[0] + li_84, gia_168[1] + li_84 + gia_184[ai_28], ls_104, li_92 - li_84, iCorner, ai_36, ai_44)) Print(GetLastError());
   
   } else {
   
      for (int li_64 = 1; li_64 < ai_20; li_64++) ls_104 = ls_104 + "g";
      
      for (int count_68 = 0; count_68 < ai_24; count_68++) {
         gia_168[4] = li_80 / 10;
         gia_168[5] = li_80 % 10;
         gia_168[7] = li_60;
         gia_168[8] = li_60;
         ls_96 = f0_7(as_0, gia_168, as_48);
         if (!f0_4(ls_96, gia_168[0], gia_168[1] + li_88 * count_68 + gia_184[ai_28], ls_104, li_92, iCorner, ai_56, ai_44)) Print(GetLastError());
         li_80++;
      }
      
      if (ai_36 == ai_56) return (0);
      
      gia_168[7] = li_60;
      gia_168[8] = li_60 + 1;
      
      for (count_68 = 0; count_68 < ai_24; count_68++) {
         if (ai_20 > 1) {
            gia_168[4] = li_80 / 10;
            gia_168[5] = li_80 % 10;
            ls_96 = f0_7(as_0, gia_168, as_48);
            ls_112 = "g";
            iXPos = ai_20 / 10 + 1;
            for (int count_72 = 0; count_72 < iXPos; count_72++) ls_112 = ls_112 + "g";
            if (!f0_4(ls_96, gia_168[0] + li_84, gia_168[1] + (li_88 * count_68 - count_68) + gia_184[ai_28] + ai_24, ls_112, li_92 - li_84, iCorner, ai_36, ai_44)) Print(GetLastError());
            li_80++;
         }
         
         gia_168[4] = li_80 / 10;
         gia_168[5] = li_80 % 10;
         
         ls_96 = f0_7(as_0, gia_168, as_48);
         
         if (!f0_4(ls_96, gia_168[0] + (ai_20 * 2 - li_84), gia_168[1] + (li_88 * count_68 - count_68) + gia_184[ai_28] + ai_24, ls_104, li_92 - li_84, iCorner, ai_36, ai_44)) Print(GetLastError());
         
         li_80++;
      }
      
      if (ai_24 < 2) return (0);
      
      for (count_72 = 0; count_72 <= ai_24 / li_88; count_72++)
      {
      
         gia_168[4] = li_80 / 10;
         gia_168[5] = li_80 % 10;
         ls_96 = f0_7(as_0, gia_168, as_48);
         if (!f0_4(ls_96, gia_168[0] + ai_20 * 2 - li_84, gia_168[1] + li_84 + gia_184[ai_28] + (li_88 - 1) * count_72, ls_104, li_92 - li_84, iCorner, ai_36, ai_44)) Print(GetLastError());
         li_80++;
         
         if (ai_20 > 1) {
            gia_168[4] = li_80 / 10;
            gia_168[5] = li_80 % 10;
            ls_96 = f0_7(as_0, gia_168, as_48);
            ls_112 = "g";
            iXPos = ai_20 / 10 + 1;
            for (int count_76 = 0; count_76 < iXPos; count_76++) ls_112 = ls_112 + "g";
            if (!f0_4(ls_96, gia_168[0] + li_84, gia_168[1] + li_84 + gia_184[ai_28] + (li_88 - 1) * count_72, ls_112, li_92 - li_84, iCorner, ai_36, ai_44)) Print(GetLastError());
            li_80++;
         }
      }
   }
   return (0);
}

//----------------------------------------------

int CreateText(string sObjctNm, string sParentObject, int ai_16, string sTxtToDsply, string sFntFc, int ai_36, bool ai_40 = TRUE, int ai_44 = 0, int iColor = 0, int ai_52 = 0, int ai_56 = 0, int ai_60 = 0, int ai_64 = 0, int ai_68 = 0) {
   
   int li_unused_108;
   double ld_112;
   double ld_120;
   int lia_72[19] = {10, 14, 20, 26, 32, 35, 41, 50, 56, 62, 65, 68, 71, 74, 77, 86, 89, 92, 95};
   int lia_76[7] = {0, 3, 2, 3, 2, 3, 4};
   int li_80 = 0;
   int li_84 = 0;
   int li_88 = 0;
   int li_unused_92 = 0;
   int li_96 = 0;
   int li_100 = 0;
   int li_unused_104 = 0;
   
   if (sParentObject != "")
   {
      if (f0_9(sParentObject))
      {
         ai_60 = arIndiProps[6];
         ai_64 = arIndiProps[8];
         li_80 = arIndiProps[0];
         li_84 = arIndiProps[1];
         li_88 = arIndiProps[2];
         li_96 += arIndiProps[4] + 1;
         li_100 = arIndiProps[9] + 1;
         ai_60 = arIndiProps[6];
         ai_64 = arIndiProps[8];
         li_unused_108 = arIndiProps[5];
         
         if (ai_56 == 0) ai_56 = lia_72[ai_52];
         
         if (ai_40) {
            ld_112 = StringLen(sTxtToDsply) * ai_56 / 1.6;
            ld_120 = li_88 - li_80;
            ai_44 = li_80 + (ld_120 - ld_112) / 2.0 + ai_44;
            iColor = li_84 + lia_76[ai_52];
            if (sFntFc == "Webdings") {
               if (ai_52 == 0) {
                  ai_56 = 11;
                  ai_44 = li_80;
                  iColor = li_84 - 3;
               } else {
                  ai_56 = 20;
                  ai_44 = li_80 - 2;
                  iColor = li_84 - 4;
               }
            } else {
               if (sFntFc == "Wingdings") {
                  ai_56 = 11;
                  ai_44 = li_80 + 1;
                  iColor = li_84 + 2;
               }
            }
         } else {
            ai_44 += li_80;
            iColor += li_84;
         }
      }
   }
   
   gia_168[0] = ai_44;
   gia_168[1] = iColor;
   gia_168[6] = li_96;
   gia_168[7] = li_100;
   gia_168[8] = li_100;
   gia_168[9] = ai_16;
   
   sObjctNm = f0_7(sObjctNm, gia_168, sParentObject);
   
   if (!f0_4(sObjctNm, ai_44, iColor, sTxtToDsply, ai_56, ai_60, ai_36, ai_64, sFntFc, ai_68)) return (GetLastError());
   
   return (0);
}

//----------------------------------------------------

int f0_10(

      string as_0, 
      int ai_8, 
      int ai_12, 
      int ai_16, 
      int ai_20 = 3, 
      int ai_24 = 1, 
      int ai_28 = 1, 
      int ai_32 = 0, 
      int ai_36 = 7346457, 
      int iCorner = 0, 
      int ai_44 = 0, 
      string as_48 = "",  
      int ai_56 = 16777215   //White
      
 )
 {
   string ls_60;
   
   int li_76;
   int li_80;
   int li_84;
   if (ai_8 < 70 || ai_8 > 75) return (1);
   if (ai_36 == 0) ai_36 = 9109504;
   if (ai_28 <= 1) ai_28 = 1;
   switch (ai_8) {
   case 70:
      if (ai_20 < 3) ai_20 = 3;
      f0_6(as_0, ai_8, ai_12, ai_16, ai_20, ai_24, ai_28, ai_32, ai_36, iCorner, ai_44, as_48, ai_56);
      break;
   case 71:
      if (ai_20 < 3) ai_20 = 3;
      f0_6(as_0, ai_8, ai_12, ai_16, ai_20, ai_24, ai_28, ai_32, ai_36, iCorner, ai_44, as_48, ai_56);
      if (iCorner == 0) li_76 = gia_168[2] - gia_168[0] - (7 * (ai_28 - 1) + 19);
      else li_76 = 4;
      ls_60 = StringSubstr(as_0, 0, 2) + "CL" + StringSubstr(as_0, 2);
      f0_6(ls_60, 52, li_76, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Clt", ls_60, 69, StringSetChar("", 0, 'r'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      break;
   case 72:
      if (ai_20 < 3) ai_20 = 3;
      f0_6(as_0, ai_8, ai_12, ai_16, ai_20, ai_24, ai_28, ai_32, ai_36, iCorner, ai_44, as_48, ai_56);
      if (iCorner == 0) li_76 = gia_168[2] - gia_168[0] - (7 * (ai_28 - 1) + 19);
      else li_76 = 4;
      ls_60 = StringSubstr(as_0, 0, 2) + "HD" + StringSubstr(as_0, 2);
      f0_6(ls_60, 53, li_80, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Hdt", ls_60, 69, StringSetChar("", 0, '0'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      break;
   case 73:
      if (ai_20 < 3) ai_20 = 3;
      f0_6(as_0, ai_8, ai_12, ai_16, ai_20, ai_24, ai_28, ai_32, ai_36, iCorner, ai_44, as_48, ai_56);
      if (iCorner == 0) {
         li_76 = gia_168[2] - gia_168[0] - (7 * (ai_28 - 1) + 19);
         li_80 = gia_168[2] - gia_168[0] - (15 * (ai_28 - 1) + 37);
      } else {
         li_76 = 4;
         li_80 = 7 * (ai_28 - 1) + 23;
      }
      ls_60 = StringSubstr(as_0, 0, 2) + "CL" + StringSubstr(as_0, 2);
      f0_6(ls_60, 52, li_76, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Clt", ls_60, 69, StringSetChar("", 0, 'r'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      ls_60 = StringSubstr(as_0, 0, 2) + "HD" + StringSubstr(as_0, 2);
      f0_6(ls_60, 53, li_80, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Hdt", ls_60, 69, StringSetChar("", 0, '0'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      break;
   case 74:
      if (ai_20 < 3) ai_20 = 3;
      f0_6(as_0, ai_8, ai_12, ai_16, ai_20, ai_24, ai_28, ai_32, ai_36, iCorner, ai_44, as_48, ai_56);
      if (iCorner == 0) {
         li_76 = gia_168[2] - gia_168[0] - (7 * (ai_28 - 1) + 19);
         li_80 = gia_168[2] - gia_168[0] - (15 * (ai_28 - 1) + 37);
         li_84 = gia_168[2] - gia_168[0] - (23 * (ai_28 - 1) + 55);
      } else {
         li_76 = 4;
         li_80 = 7 * (ai_28 - 1) + 23;
         li_84 = 14 * (ai_28 - 1) + 42;
      }
      ls_60 = StringSubstr(as_0, 0, 2) + "CL" + StringSubstr(as_0, 2);
      f0_6(ls_60, 52, li_76, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Clt", ls_60, 69, StringSetChar("", 0, 'r'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      ls_60 = StringSubstr(as_0, 0, 2) + "HD" + StringSubstr(as_0, 2);
      f0_6(ls_60, 53, li_80, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Hdt", ls_60, 69, StringSetChar("", 0, '0'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      ls_60 = StringSubstr(as_0, 0, 2) + "ST" + StringSubstr(as_0, 2);
      f0_6(ls_60, 55, li_84, 4, 1, 1, ai_28 - 1, ai_32 + 1, ai_36, iCorner, ai_44, as_0, ai_56);
      CreateText("Stt", ls_60, 69, StringSetChar("", 0, '@'), "Webdings", ai_56, 1, 4, 4, ai_28 - 1);
      break;
   default:
      return (1);
   }
   return (0);
}

//-------------------------------------------------------

int CreateLed(
            string as_0, 
            string as_8, 
            int X, 
            int ai_20, 
            int ai_24 = 1, 
            int ai_28 = 1, 
            int ai_32 = 0, 
            double ad_36 = 0.0, 
            double ad_44 = 1.0, 
            double ad_52 = 1.0, 
            int ai_60 = -1, 
            int ai_64 = -1, 
            int ai_68 = -1) 
{
   int li_80,li_84,li_88,li_92,li_96,li_100,li_104,li_112,li_116,li_188,li_192;
   
   
   
   if (as_8 == "")
   {
      if (ai_64 < 0) ai_64 = 0;
      if (ai_68 < 0) ai_68 = 16777215;
   }
   else
   {
      if (!f0_9(as_8)) return (-1);
      if (ai_64 < 0) ai_64 = 0;
      if (ai_68 < 0) ai_68 = 16777215;
      li_92 = arIndiProps[4] + 1;
   }
   
   if (ai_28 > 2) ai_28 = 2;
   if (ai_24 > 8) ai_24 = 8;
   if (ai_32 > 3) ai_32 = 3;
   if (ai_32 < 0) ai_32 = 0;
   switch (ai_32) {
   case 0:
      li_80 = ai_24;
      li_84 = 1;
      break;
   case 1:
      li_80 = 1;
      li_84 = ai_24;
      break;
   case 2:
      li_80 = ai_24;
      li_84 = 1;
      break;
   case 3:
      li_80 = 1;
      li_84 = ai_24;
   }
   
   CreateChartObject(as_0, as_8, 30, X, ai_20, li_80, li_84, ai_28, ai_64, ai_68, li_92);
   f0_9(as_0);
   int li_120 = arIndiProps[6];
   if (ai_32 % 2 == 0)
   {
      switch (li_80)
      {
      case 1:
         li_88 = 1;
         break;
      case 2:
         li_88 = 2;
         break;
      case 3:
         li_88 = 2;
         break;
      case 4:
         li_88 = 2;
         break;
      case 5:
         li_88 = 3;
         break;
      case 6:
         li_88 = 3;
         break;
      case 7:
         li_88 = 3;
         break;
      case 8:
         li_88 = 4;
      }
   } else {
      switch (li_84) {
      case 1:
         li_88 = 1;
         break;
      case 2:
         li_88 = 2;
         break;
      case 3:
         li_88 = 3;
         break;
      case 4:
         li_88 = 3;
         break;
      case 5:
         li_88 = 4;
         break;
      case 6:
         li_88 = 5;
         break;
      case 7:
         li_88 = 4;
         break;
      case 8:
         li_88 = 4;
      }
   }
   switch (ai_32) {
   case 0:
      switch (ai_28) {
      case 0:
         if (li_120 == 0) {
            li_96 = 1;
            li_100 = -2;
            li_104 = 9;
            li_112 = 5 * li_80 - 1;
            li_116 = 0;
         }
         if (li_120 != 1) break;
         li_96 = arIndiProps[2] - arIndiProps[0] - 1;
         li_100 = 17;
         li_104 = 9;
         li_112 = 5 * li_80 - 1;
         li_116 = 180;
         break;
      case 1:
         if (li_120 == 0) {
            li_96 = 1;
            li_100 = -2;
            li_104 = 9;
            li_112 = li_80 * 8 - li_88;
            li_116 = 0;
         }
         if (li_120 != 1) break;
         li_96 = arIndiProps[2] - arIndiProps[0] - 1;
         li_100 = 17;
         li_104 = 9;
         li_112 = li_80 * 8 - li_88;
         li_116 = 180;
         break;
      case 2:
         if (li_120 == 0) {
            li_96 = 1;
            li_100 = -5;
            li_104 = 15;
            li_112 = 5 * li_80;
            li_116 = 0;
         }
         if (li_120 != 1) break;
         li_96 = arIndiProps[2] - arIndiProps[0] - 1;
         li_100 = 28;
         li_104 = 15;
         li_112 = 5 * li_80;
         li_116 = 180;
      }
      break;
   case 1:
      switch (ai_28) {
      case 0:
         if (li_84 > 6) li_88++;
         if (li_120 == 0) {
            li_96 = -3;
            li_100 = arIndiProps[3] - arIndiProps[1];
            li_104 = 9;
            li_112 = 5 * li_84 - li_88;
            li_116 = 90;
         }
         if (li_120 != 1) break;
         li_96 = -3;
         li_100 = arIndiProps[3] - arIndiProps[1] - 1;
         li_104 = 9;
         li_112 = 5 * li_84 - li_88;
         li_116 = 270;
         break;
      case 1:
         if (li_120 == 0) {
            li_96 = -3;
            li_100 = arIndiProps[3] - arIndiProps[1];
            li_104 = 9;
            li_112 = 7 * li_84 - 1;
            li_116 = 90;
         }
         if (li_120 != 1) break;
         li_96 = -3;
         li_100 = arIndiProps[3] - arIndiProps[1] - 1;
         li_104 = 9;
         li_112 = 7 * li_84 - 1;
         li_116 = 270;
         break;
      case 2:
         if (li_120 == 0) {
            li_96 = -6;
            li_100 = arIndiProps[3] - arIndiProps[1];
            li_104 = 14;
            li_112 = 7 * li_84 - (li_84 + li_84 / 4);
            li_116 = 90;
         }
         if (li_120 != 1) break;
         li_96 = -6;
         li_100 = arIndiProps[3] - arIndiProps[1] + 1;
         li_104 = 14;
         li_112 = 7 * li_84 - (li_84 + li_84 / 4);
         li_116 = 270;
      }
      break;
   case 2:
      switch (ai_28) {
      case 0:
         if (li_120 == 1) {
            li_96 = 2;
            li_100 = -2;
            li_104 = 9;
            li_112 = 5 * li_80 - 1;
            li_116 = 0;
         }
         if (li_120 != 0) break;
         li_96 = arIndiProps[2] - arIndiProps[0];
         li_100 = 17;
         li_104 = 9;
         li_112 = 5 * li_80 - 1;
         li_116 = 180;
         break;
      case 1:
         if (li_120 == 1) {
            li_96 = 2;
            li_100 = -2;
            li_104 = 9;
            li_112 = li_80 * 8 - li_88;
            li_116 = 0;
         }
         if (li_120 != 0) break;
         li_96 = arIndiProps[2] - arIndiProps[0];
         li_100 = 17;
         li_104 = 9;
         li_112 = li_80 * 8 - li_88;
         li_116 = 180;
         break;
      case 2:
         if (li_120 == 1) {
            li_96 = 1;
            li_100 = -5;
            li_104 = 15;
            li_112 = 5 * li_80;
            li_116 = 0;
         }
         if (li_120 != 0) break;
         li_96 = arIndiProps[2] - arIndiProps[0] - 1;
         li_100 = 28;
         li_104 = 15;
         li_112 = 5 * li_80;
         li_116 = 180;
      }
      break;
   case 3:
      switch (ai_28) {
      case 0:
         if (li_120 == 0) {
            li_96 = 18;
            li_100 = 1;
            li_104 = 9;
            li_112 = 5 * li_84 - li_88;
            li_116 = 270;
         }
         if (li_120 != 1) break;
         li_96 = 18;
         li_100 = 1;
         li_104 = 9;
         li_112 = 5 * li_84 - li_88;
         li_116 = 90;
         break;
      case 1:
         if (li_120 == 0) {
            li_96 = 18;
            li_100 = 1;
            li_104 = 9;
            li_112 = 7 * li_84 - 1;
            li_116 = 270;
         }
         if (li_120 != 1) break;
         li_96 = 18;
         li_100 = 2;
         li_104 = 9;
         li_112 = 7 * li_84 - 1;
         li_116 = 90;
         break;
      case 2:
         if (li_120 == 0) {
            li_96 = 28;
            li_100 = 1;
            li_104 = 14;
            li_112 = 7 * li_84 - (li_84 + li_84 / 4);
            li_116 = 270;
         }
         if (li_120 != 1) break;
         li_96 = 28;
         li_100 = 1;
         li_104 = 14;
         li_112 = 7 * li_84 - (li_84 + li_84 / 4);
         li_116 = 90;
      }
   }
   double ld_172 = (ad_44 - ad_36) / MathAbs(li_112);
   string ls_180 = "";
   for (int count_72 = 0; count_72 < li_112; count_72++) {
      if (ad_52 <= ad_36 + ld_172 * count_72) break;
      ls_180 = ls_180 + "|";
   }
   if (ai_60 < 0) {
      li_188 = ArraySize(arLdClr) - 1;
      li_192 = count_72 / (li_112 / li_188);
      if (li_192 > li_188) li_192 = li_188;
      ai_60 = arLdClr[li_192];
   }
   CreateText("LedIn", as_0, 69, ls_180, "Arial black", ai_60, 0, li_96, li_100, 0, li_104, 0, 0, li_116);
   if (ai_28 > 0) {
      if (ai_32 == 1 || ai_32 == 3) li_96 += ai_28 - 1 + 8;
      else li_100 += 8;
      CreateText("LedIn", as_0, 69, ls_180, "Arial black", ai_60, 0, li_96, li_100, 0, li_104, 0, 0, li_116);
   }
   return (0);
}

//------------------------------------------------------------------
//Format
//wnd:z_XXXXXXYYYYYYZZZZZZ:c_XXXXXX:lu_XXXXXX_XXXXXX:rd_XXXXXX_XXXXXX:idXXXXXXYYYYYY:#XXXXXX|XXXXXX
string f0_7(string as_0, int aia_8[10], string sObjectType = "chart")
{
   //string ls_unused_20 = "";
   //if (as_12 == "") as_12 = "chart";
   return (StringConcatenate("wnd:", "z_", aia_8[6], StringSetChar("", 0, aia_8[7] + 97), StringSetChar("", 0, aia_8[8] + 97), ":", "c_", aia_8[9], ":", "lu_", aia_8[0], "_", aia_8[1], ":", "rd_", aia_8[2], "_", aia_8[3], ":", "id", aia_8[4], "", aia_8[5], ":", "#", as_0, "|", sObjectType));
}

//------------------------------------------------------------------

int CreateChartObject(  string sObjNm, string sPrntObj, int sObjTyp, 
                        int ai_20 = 0, int iVert = 0, int iWidth = 1, 
                        int ai_32 = 1, int ai_36 = 1, int iCorner = 0, 
                        int iColor = 16777215, int ai_48 = 0, int ai_52 = 0, 
                        int ai_56 = 0) 
{
   
   string ls_60,ls_68;
   
   switch (sObjTyp)
   {
   case 30:
      f0_6(sObjNm, sObjTyp, ai_20, iVert, iWidth, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   /*
   case 40:
      f0_6(sObjNm, sObjTyp, ai_20, ai_24, ai_28, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   case 70:
      f0_10(sObjNm, sObjTyp, ai_20, ai_24, ai_28, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   case 71:
      f0_10(sObjNm, sObjTyp, ai_20, ai_24, ai_28, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   case 72:
      f0_10(sObjNm, sObjTyp, ai_20, ai_24, ai_28, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   case 73:
      f0_10(sObjNm, sObjTyp, ai_20, ai_24, ai_28, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   case 74:
      f0_10(sObjNm, sObjTyp, ai_20, ai_24, ai_28, ai_32, ai_36, ai_48, iCorner, ai_52, ai_56, sPrntObj, iColor);
      break;
   case 44:
      ls_60 = "RevBb";
      ls_68 = "Revtt";
      f0_6(ls_60, 44, ai_20, ai_24, 4, 1, 0, ai_48 + 1, 16711935, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, "Reverse", "Tahoma", iColor);
      break;
   case 43:
      ls_60 = "ClBb";
      ls_68 = "Clott";
      f0_6(ls_60, 43, ai_20, ai_24, 4, 1, 0, ai_48 + 1, 65535, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, "Close", "Tahoma", 0);
      break;
   case 42:
      ls_60 = "Sbb";
      ls_68 = "Seltt";
      f0_6(ls_60, 42, ai_20, ai_24, 4, 1, 0, ai_48 + 1, 4678655, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, "Sell", "Tahoma", iColor);
      break;
   case 41:
      ls_60 = "Bbb";
      ls_68 = "Buytt";
      f0_6(ls_60, 41, ai_20, ai_24, 4, 1, 0, ai_48 + 1, 16748574, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, "Buy", "Tahoma", iColor);
      break;
   case 52:
      ls_60 = "Cls";
      ls_68 = "Clt";
      f0_6(ls_60, 52, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, StringSetChar("", 0, 'r'), "Webdings", iColor);
      break;
   case 53:
      ls_60 = "Hid";
      ls_68 = "Hdt";
      f0_6(ls_60, 53, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, StringSetChar("", 0, '0'), "Webdings", iColor);
      break;
   case 54:
      ls_60 = "Shw";
      ls_68 = "Sht";
      f0_6(ls_60, 54, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, StringSetChar("", 0, '2'), "Webdings", iColor);
      break;
   case 55:
      ls_60 = "Set";
      ls_68 = "Stt";
      f0_6(ls_60, 55, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 69, StringSetChar("", 0, '@'), "Webdings", iColor);
      break;
   case 56:
      ls_60 = "Alr";
      ls_68 = "Altx";
      f0_6(ls_60, 56, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, 12632256);
      CreateText(ls_68, ls_60, 69, StringSetChar("", 0, ']'), "Webdings", 12632256);
      break;
   case 57:
      ls_60 = "Snd";
      ls_68 = "Sndtx";
      f0_6(ls_60, 57, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, 12632256);
      CreateText(ls_68, ls_60, 57, StringSetChar("", 0, '¯'), "Webdings", 12632256);
      break;
   case 58:
      ls_60 = "Mil";
      ls_68 = "Mltx";
      f0_6(ls_60, 58, ai_20, 4, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, 12632256);
      CreateText(ls_68, ls_60, 58, StringSetChar("", 0, '*'), "Wingdings", 12632256);
      break;
   case 60:
      ls_60 = sObjNm;
      ls_68 = "Lftx";
      f0_6(ls_60, 60, ai_20, ai_24, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 60, StringSetChar("", 0, '3'), "Webdings", iColor);
      break;
   case 61:
      ls_60 = sObjNm;
      ls_68 = "Rttx";
      f0_6(ls_60, 61, ai_20, ai_24, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 61, StringSetChar("", 0, '4'), "Webdings", iColor);
      break;
   case 62:
      ls_60 = sObjNm;
      ls_68 = "Uptx";
      f0_6(ls_60, 62, ai_20, ai_24, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 62, StringSetChar("", 0, '5'), "Webdings", iColor);
      break;
   case 63:
      ls_60 = sObjNm;
      ls_68 = "Dntx";
      f0_6(ls_60, 63, ai_20, ai_24, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 63, StringSetChar("", 0, '6'), "Webdings", iColor);
      break;
   case 59:
      ls_60 = sObjNm;
      ls_68 = "Sltx";
      f0_6(ls_60, 59, ai_20, ai_24, 1, 1, 0, ai_48 + 1, iCorner, ai_52, ai_56, sPrntObj, iColor);
      CreateText(ls_68, ls_60, 59, StringSetChar("", 0, 'a'), "Webdings", iColor);
      break;
      */
   default:
      return (0);
   }
   return (1);
}

//-------------------------------------

int f0_9(string as_0)
{

   
   int iSubSrtPos,iCharPos ,iSubSubSrtPos;
   string strChartObjectName; //name_20;
 
   //Search all chart objects od a specified type
   
   for (int objs_total = ObjectsTotal(); objs_total >= 0; objs_total--)
   {
      //Get the name of chart object
      strChartObjectName = ObjectName(objs_total);
      
      //Get location of find string in search string
      iCharPos = StringFind(strChartObjectName, as_0);
      
      if (iCharPos  >= 0)
      {
         
         if (iCharPos != StringFind(strChartObjectName, "|") + 1)
         {
            //Look for "z_"
            iSubSrtPos = StringFind(strChartObjectName, "z_") + 2;
            arIndiProps[4] = StrToInteger(StringSubstr(strChartObjectName, iSubSrtPos, 1));
            arIndiProps[9] = StrToInteger(StringGetChar(StringSubstr(strChartObjectName, iSubSrtPos + 3, 1), 0));
            
            //Look for ":c_"
            iSubSrtPos = StringFind(strChartObjectName, ":c_") + 3;
            arIndiProps[5] = StrToInteger(StringSubstr(strChartObjectName, iSubSrtPos, 2));
            
            //Look for "lu_"
            iSubSrtPos = StringFind(strChartObjectName, "lu_") + 3;
            
            //Get pos of "_" in aboe
            iSubSubSrtPos = StringFind(strChartObjectName, "_", iSubSrtPos);
            
            arIndiProps[0] = StrToInteger(StringSubstr(strChartObjectName, iSubSrtPos, iSubSubSrtPos - iSubSrtPos));
            
            //Look for ":"
            iSubSrtPos = StringFind(strChartObjectName, ":", iSubSubSrtPos);
            arIndiProps[1] = StrToInteger(StringSubstr(strChartObjectName, iSubSubSrtPos + 1, iSubSrtPos - iSubSubSrtPos + 1));
            
            //Look for "rd_"
            iSubSrtPos = StringFind(strChartObjectName, "rd_") + 3;
            iSubSubSrtPos = StringFind(strChartObjectName, "_", iSubSrtPos);
            arIndiProps[2] = StrToInteger(StringSubstr(strChartObjectName, iSubSrtPos, iSubSubSrtPos - iSubSrtPos));
            
            //Look for ":"
            iSubSrtPos = StringFind(strChartObjectName, ":", iSubSubSrtPos);
            arIndiProps[3] = StrToInteger(StringSubstr(strChartObjectName, iSubSubSrtPos + 1, iSubSrtPos - iSubSubSrtPos + 1));
            
            arIndiProps[6] = ObjectGet(strChartObjectName, OBJPROP_CORNER);
            arIndiProps[7] = ObjectGet(strChartObjectName, OBJPROP_COLOR);
            arIndiProps[8] = ObjectFind(strChartObjectName);
            
            //Get Nanme 
            sObjectName = StringSubstr(strChartObjectName, StringFind(strChartObjectName, "|") + 1);
            
            return (1);
         }
      }
   }
   //Clean up
   ArrayInitialize(arIndiProps, -1);
   iSubSrtPos = 0;
   
   return (0);
}

//-----------------------------

void f0_3(string as_0)
{
   int li_12,li_16,li_64,li_68;
   string name_28,ls_44,ls_72;
   string lsa_52[5000];
   string lsa_56[5000];
   string ls_80;
   int li_60 = GetTickCount();
   
   for (int li_8 = ObjectsTotal() - 1; li_8 >= 0; li_8--)
   {
      name_28 = ObjectName(li_8);
      if (StringFind(name_28, "wnd:") >= 0) {
         if (StringFind(name_28, "#" + as_0) > 0) {ObjectDelete(name_28);continue;}
         if (StringFind(name_28, "|" + as_0) > 0)
            {
               li_64 = StringFind(name_28, "#") + 1;
               li_68 = StringFind(name_28, "|" + as_0) - li_64;
               lsa_52[li_12] = StringSubstr(name_28, li_64, li_68);
               li_12++;
               ObjectDelete(name_28);
               continue;
            }
         lsa_56[li_16] = name_28;
         li_16++;
      }
   }
   ArrayResize(lsa_56, li_16);
   for (li_8 = 0; li_8 < li_12; li_8++) {
      ls_72 = "|" + lsa_52[li_8];
      for (int index_20 = 0; index_20 < li_16; index_20++) {
         name_28 = lsa_56[index_20];
         if (name_28 != "") {
            if (StringFind(name_28, ls_72) >= 0) {
               li_64 = StringFind(name_28, "#") + 1;
               li_68 = StringFind(name_28, ls_72) - li_64;
               ls_80 = StringSubstr(name_28, li_64, li_68);
               if (ls_44 != ls_80) {
                  ls_44 = ls_80;
                  lsa_52[li_12] = ls_44;
                  li_12++;
               }
               lsa_56[index_20] = "";
               ObjectDelete(name_28);
            }
         }
      }
   }
}

void DeleteObject(string as_0, bool ai_8 = TRUE)
{
   int objs_total = 0;
   string name = "";
   if (ai_8) {
      for (objs_total = ObjectsTotal(); objs_total >= 0; objs_total--) {
         name = ObjectName(objs_total);
         if (StringFind(name, as_0) >= 0) ObjectDelete(name);
      }
   } else {
      for (objs_total = ObjectsTotal(); objs_total >= 0; objs_total--) {
         name = ObjectName(objs_total);
         if (StringFind(name, "#" + as_0) >= 0) ObjectDelete(name);
      }
   }
}


//f0_4(string sObjNm
bool f0_4(  string sObjNm, 
            int x, 
            int y, 
            string a_text_16 = "c", 
            int a_fontsize_24 = 14, 
            int iCorner = 0, 
            color a_color_32 = 0, 
            int window = 0, 
            string a_fontname_40 = "Webdings", 
            int a_angle_48 = FALSE)
{
   
   if (window > WindowsTotal() - 1) window = WindowsTotal() - 1;
   
   if (StringLen(sObjNm) < 1) return (false);

   ObjectDelete(sObjNm);
   ObjectCreate(sObjNm, OBJ_LABEL, window, 0, 0);
   ObjectSet(sObjNm, OBJPROP_XDISTANCE, x);
   ObjectSet(sObjNm, OBJPROP_YDISTANCE, y);
   ObjectSet(sObjNm, OBJPROP_CORNER, iCorner);
   ObjectSet(sObjNm, OBJPROP_BACK, FALSE);
   ObjectSet(sObjNm, OBJPROP_ANGLE, a_angle_48);
   ObjectSetText(sObjNm, a_text_16, a_fontsize_24, a_fontname_40, a_color_32);
   return (false);
}

//------------------------------------

void init()
{
   int iNoOfValidSymbols;
   string symbolString;
   string sSymbolIndi = "";
   
   colBackGround = HandleBackGroundColor;
   colDataTableBackGroundCol = DataTableBackGroundColor_1;
   colDataTableBackGroundCol2 = DataTableBackGroundColor_2;
   colCurrencysBackGroundCol = CurrencysBackGroundColor;
   colHandleTextCol = HandleTextColor;
   colDataTableTextCol = DataTableTextColor;
   colCurrencysTextCol = CurrencysTextColor;
   colTrendUpArrowsCol = TrendUpArrowsColor;
   colTrendDownArrowsCol = TrendDownArrowsColor;
   
  /*
   for (int index = 0; index < ArraySize(symbols)-1; index++)
      {
         symbolString = symbols[index];  //From custon str[] list aboe
         
         //if (MarketInfo(symbolString, MODE_POINT) == 0.0) 
         //{
         //   sSymbolIndi = sSymbolIndi + ":" + symbols[index]; 
         //}
         //else 
         //{
            
            arrValidSymbols[iNoOfValidSymbols]=symbolString;
            iNoOfValidSymbols++;
         //}
      }
    */
    
    iNoOfValidSymbols=0;
    for (int index = 0; index < SymbolsTotal(true)-1 ; index++)
      {
         symbolString = SymbolName(index,true);
         if (MarketInfo(symbolString, MODE_MARGINCALCMODE) == 0.0) //ie  forex
         {
            arrValidSymbols[index]=symbolString;
            iNoOfValidSymbols++;
         }
         
      } 
   
   //Redimension the array  
   ArrayResize(arrValidSymbols, iNoOfValidSymbols);
   
 
   
   if (UninitializeReason() != REASON_CHARTCHANGE)
   {
      if (sSymbolIndi != "")
      {
         sSymbolIndi = "Some currency pairs are not available\n for calculating the indices.\n" + sSymbolIndi;
         sSymbolIndi = sSymbolIndi + "\nCalculation formula will be changed.";
         Alert(sSymbolIndi);
      }
   }
   
}

void deinit()
{
   f0_3("Header");
   f0_3("Window");
   f0_3("Curs");
   f0_3("Pows");
}

void start()
{
   int li_20;
   int li_28;
   int color_32;
   int color_36;
   int iDsplySymblIndx;
   double lda_44[8][2];
   string sLedIndx;

   double ld_96;
   int iVSpc = 4;
   //string ls_48 = "Curs";
   //string ls_unused_56 = "Pows";

   
   
   int iVSpc2 = 14; 
    
   if (ShowCurrencies && (!CurrenciesWindowBelowTable))
      {
         CreateChartObject("Window", "", 30, 4, 18, 18, 1, 0,Corner, colBackGround, 0, 0, 0);
         CreateText("hdTxt", "Window", 69, "Currency Meter", "Courier new", colHandleTextCol, 0, 34, -2, 0, 11);
      }
   else
      {
         CreateChartObject("Window", "", 30, 4, 18, 11, 1, 0, Corner, colBackGround, 0, 0, 0);
         CreateText("hdTxt", "Window", 69, "Currency Meter", "Courier new", colHandleTextCol, 0, 1, -2, 0, 11);
      }
   
   
   //vertical spacing2 main indicator list  
   iVSpc = 2;
   
   ArrayInitialize(lstSymblStrngth, 0);
   
   int NoOfSymbolsProcessed = CalculateSymbolStrength();  //returns valid symbols
   
   if (ShowSymbolsSorted) ArraySort(lstSymblStrngth, WHOLE_ARRAY, 0, MODE_DESCEND);
   
   int rowCounter = 0;
   string sLoadedSymbols = "";
   
   for (int index = 0; index < NoOfSymbolsProcessed; index++)
   {
      
      iDsplySymblIndx = lstSymblStrngth[index][1];
      if (StringFind(DontShowThisPairs,arrValidSymbols[index]) < 0)
      {
         //alternate row background color
         if (rowCounter % 2 != 0) color_36 = colDataTableBackGroundCol; else color_36 = colDataTableBackGroundCol2;
 
         //Displays symbol list and strentgh
         DeleteObject("cWnd" + index);
         CreateChartObject("cWnd" + index, "Window", 30, 0, iVSpc2 + iVSpc, 11, 1, 0, color_36, color_36, 0, 0, 0);

         //Displays the symbols after loading  KEEP COMMENTED OUT LINES
         if (iDsplySymblIndx >= 0) {
            //We hae symbols
            //if (IsLoaded) {
               
               //if (gi_268 < 0) 
               //   sLoadedSymbols = StringSubstr(arrValidSymbols[iDsplySymblIndx], 0, -gi_268);
               //else 
                  sLoadedSymbols = StringSubstr(arrValidSymbols[iDsplySymblIndx], 0);
               
            //} else sLoadedSymbols = arrValidSymbols[iDsplySymblIndx];
         } 
         else 
            sLoadedSymbols = "LOADING";
         
         CreateText(sLoadedSymbols + "wnd", "cWnd" + index, 69, sLoadedSymbols, "Courier new", colDataTableTextCol, 0, 4, -2, 0, 11);
         
         if (iDsplySymblIndx >= 0) {
            
            DeleteObject(index + "sLED");
            
            if (lstSymblStrngth[index][0] < 0.0) {
               
               li_28 = 2;
               li_20 = -14;
               color_32 = colTrendDownArrowsCol;
               
               CreateLed(index + "sLED", "Window", li_20 + 75, iVSpc2 + iVSpc, 2, 0, li_28, 0, 100, -lstSymblStrngth[index][0], color_32, color_36, color_36);
               CreateText(index + "TrDn", "cWnd" + index, 69, StringSetChar("", 0, 'Ú'), "Wingdings", color_32, 0, 99, -2, 0, 14);
               if (lstSymblStrngth[index][0] < -99.99) CreateText("strench", "cWnd" + index, 69, "-100", "Courier new", colDataTableTextCol, 0, 122, -1, 0, 10);
               else CreateText("strench", "cWnd" + index, 69, DoubleToStr(lstSymblStrngth[index][0], 1), "Courier new", colDataTableTextCol, 0, 122, -1, 0, 10);
            
            } else {
            
               li_28 = 0;
               li_20 = 14;
               color_32 = colTrendUpArrowsCol;
               CreateLed(index + "sLED", "Window", li_20 + 75, iVSpc2 + iVSpc, 2, 0, li_28, 0, 100, lstSymblStrngth[index][0], color_32, color_36, color_36);
               CreateText(index + "TrUp", "cWnd" + index, 69, StringSetChar("", 0, 'Ù'), "Wingdings", color_32, 0, 65, -3, 0, 14);
               if (lstSymblStrngth[index][0] > 99.99) CreateText("strench", "cWnd" + index, 69, "100.0", "Courier new", colDataTableTextCol, 0, 122, -1, 0, 10);
               else CreateText("strench", "cWnd" + index, 69, DoubleToStr(lstSymblStrngth[index][0], 1), "Courier new", colDataTableTextCol, 0, 130, -1, 0, 10);
            
            }
         }
         iVSpc += 16;
         rowCounter++;
      }
   }
   
//------------------------------------------------
   
   if (ShowCurrencies)
   {
      if (!CurrenciesWindowBelowTable)
         {
            li_20 = iVSpc;
            CreateChartObject("Curs", "Window", 30, 166, 16, 7, 9, 0, colCurrencysBackGroundCol, colCurrencysBackGroundCol, 0, 0, 0);
            sLedIndx = "Led" + index;
            //li_unused_92 = gia_208[index];
            iVSpc = 0;
            for (NoOfSymbolsProcessed = 0; NoOfSymbolsProcessed < 8; NoOfSymbolsProcessed++)
               {
                  ld_96 = f0_5(sCurrAry[NoOfSymbolsProcessed]);
                  lda_44[NoOfSymbolsProcessed][0] = ld_96;
                  lda_44[NoOfSymbolsProcessed][1] = NoOfSymbolsProcessed;
               }
               
            if (ShowCurrenciesSorted) ArraySort(lda_44, WHOLE_ARRAY, 0, MODE_DESCEND);
            
            for (NoOfSymbolsProcessed = 0; NoOfSymbolsProcessed < 8; NoOfSymbolsProcessed++)
               {
                  ld_96 = lda_44[NoOfSymbolsProcessed][0];
                  iDsplySymblIndx = lda_44[NoOfSymbolsProcessed][1];
                  CreateText("CuCur" + NoOfSymbolsProcessed, "Curs", 69, sCurrAry[iDsplySymblIndx], "Courier new", colCurrencysTextCol, 0, 5, iVSpc + 0, 0, 11);
                  CreateText("CuDig" + NoOfSymbolsProcessed, "Curs", 69, DoubleToStr(lda_44[NoOfSymbolsProcessed][0], 1), "Courier new", colCurrencysTextCol, 0, 78, iVSpc + 1, 0, 10);
                  CreateLed("sLED" + NoOfSymbolsProcessed, "Curs", 32, iVSpc + 2, 3, 0, 0, 0, 10, ld_96, -1, colCurrencysBackGroundCol, colCurrencysBackGroundCol);
                  iVSpc += 14;
               }
         }
      else
         {
            CreateChartObject("Curs", "Window", 30, 0, iVSpc + 14, 11, 6, 0, colCurrencysBackGroundCol, colCurrencysBackGroundCol, 0, 0, 0);
            sLedIndx = "Led" + index;
            //li_unused_92 = gia_208[index];
            iVSpc = 0;
            for (NoOfSymbolsProcessed = 0; NoOfSymbolsProcessed < 8; NoOfSymbolsProcessed++)
               {
                  ld_96 = f0_5(sCurrAry[NoOfSymbolsProcessed]);
                  lda_44[NoOfSymbolsProcessed][0] = ld_96;
                  lda_44[NoOfSymbolsProcessed][1] = NoOfSymbolsProcessed;
               }
            if (ShowCurrenciesSorted) ArraySort(lda_44, WHOLE_ARRAY, 0, MODE_DESCEND);
            for (NoOfSymbolsProcessed = 0; NoOfSymbolsProcessed < 8; NoOfSymbolsProcessed++)
               {
                  ld_96 = lda_44[NoOfSymbolsProcessed][0];
                  iDsplySymblIndx = lda_44[NoOfSymbolsProcessed][1];
                  CreateText("CuCur" + NoOfSymbolsProcessed, "Curs", 69, sCurrAry[iDsplySymblIndx], "Courier new", colCurrencysTextCol, 0, iVSpc + 3, 76, 0, 12, 0, 0, 90);
                  CreateLed("sLED" + NoOfSymbolsProcessed, "Curs", iVSpc + 1, 0, 2, 1, 1, 0, 10, ld_96, -1, colCurrencysBackGroundCol, colCurrencysBackGroundCol);
                  iVSpc += 20;
               }
         }
   }
   WindowRedraw();
}

int CalculateSymbolStrength()
{
   double ihigh;
   double ilow;
   double iopen;
   double iclose;
   double point;
   double dbFllCndlPonts;
   double dbStrngth;
   
   int timeframe = 1440;  //ENUM_TIMEFRAMES  1 day
   string symbol = "";
   int arr_size = ArraySize(arrValidSymbols);
   ArrayResize(lstSymblStrngth, arr_size);
   
   for (int index = 0; index < arr_size; index++)
   {
      symbol = arrValidSymbols[index];
      point = MarketInfo(symbol, MODE_POINT);
      
      if (point == 0.0) {
         
         init(); 
         lstSymblStrngth[index][1] = -1;}
      
      else {
         
         ihigh = iHigh(symbol, timeframe, 0);
         ilow = iLow(symbol, timeframe, 0);
         iopen = iOpen(symbol, timeframe, 0);
         iclose = iClose(symbol, timeframe, 0);
         
         if (iopen > iclose) {
            
            dbFllCndlPonts = (ihigh - ilow) * point;  //bearish full 
            
            if (dbFllCndlPonts == 0.0) {
               init();
               lstSymblStrngth[index][1] = -1;  //no change
               continue;
            }
            
            dbStrngth = -100.0 * ((ihigh - iclose) / dbFllCndlPonts * point);
         
         } else {
         
            dbFllCndlPonts = (ihigh - ilow) * point; //bullish full
            
            if (dbFllCndlPonts == 0.0) {
               init(); 
               lstSymblStrngth[index][1] = -1; //no change
               continue;
            }
            
            
            dbStrngth = 100.0 * ((iclose - ilow) / dbFllCndlPonts * point);
         
         }
         
         lstSymblStrngth[index][0] = dbStrngth; //strength
         lstSymblStrngth[index][1] = index; //Symbol position
         lstSymblStrngth[index][2] = 1;     //Strength IsCalculated?
      }
   }
   return (arr_size);
}

//---------------------------------------

double f0_5(string as_0)
{
   double point_20;
   int li_36;
   string ls_40;
   double ld_48;
   double ld_56;
   int count_8 = 0;
   double ld_ret_12 = 0;
   int timeframe_28 = 1440;
   
   for (int index_32 = 0; index_32 < ArraySize(arrValidSymbols); index_32++)
   {
      li_36 = 0;
      ls_40 = arrValidSymbols[index_32];
      if (as_0 == StringSubstr(ls_40, 0, 3) || as_0 == StringSubstr(ls_40, 3, 3)) {
         point_20 = MarketInfo(ls_40, MODE_POINT);
         if (point_20 == 0.0) {init(); continue;}
         
         ld_48 = (iHigh(ls_40, timeframe_28, 0) - iLow(ls_40, timeframe_28, 0)) * point_20;
         if (ld_48 == 0.0) {init(); continue;}
         ld_56 = 100.0 * ((MarketInfo(ls_40, MODE_BID) - iLow(ls_40, timeframe_28, 0)) / ld_48 * point_20);
         if (ld_56 > 3.0)  li_36 = 1;
         if (ld_56 > 10.0) li_36 = 2;
         if (ld_56 > 25.0) li_36 = 3;
         if (ld_56 > 40.0) li_36 = 4;
         if (ld_56 > 50.0) li_36 = 5;
         if (ld_56 > 60.0) li_36 = 6;
         if (ld_56 > 75.0) li_36 = 7;
         if (ld_56 > 90.0) li_36 = 8;
         if (ld_56 > 97.0) li_36 = 9;
         count_8++;
         if (as_0 == StringSubstr(ls_40, 3, 3)) li_36 = 9 - li_36;
         ld_ret_12 += li_36;
      }
   }
   if (count_8 > 0) ld_ret_12 /= count_8; else ld_ret_12 = 0;
   return (ld_ret_12);
}