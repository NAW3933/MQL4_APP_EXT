
#property copyright "Copyright � 2010 www.wyfxco.com"
#property link      "www.wyfxco.com"

#property indicator_chart_window

extern int NitroMagicNumber = 1;
extern string NitroPlacement = "|||| NITRO+� Chart Position [X,Y]:";
extern int X_box = 0;
extern int Y_box = 0;
extern bool LeftSidePlacement = FALSE;
int g_window_100 = 0;
extern string DifferentModes = "|||| Turn Functions ON/OFF:";
extern bool CompactMode = FALSE;
extern bool ShowPrice = TRUE;
extern bool ShowSymbolInFullMode = TRUE;
extern bool ShowBackgroundInCompactMode = TRUE;
extern string MarketSymbol = "";
extern string EnterMarketSymbol = "Enter Symbol Like = EURUSD:";
extern string _ = "Enter symbol exactly as shown in";
extern string __ = "MarketWatch. Leave Blank=Current.";
extern string ColorSettings = "|||| Various Color Settings:";
extern bool UpColorBLUE = TRUE;
extern color SymbolColor = C'0xA0,0xA0,0xA0';
extern color LegendTagsTextColor = C'0x4B,0x4B,0x55';
extern color BlockValuesColor = Black;
extern color BlockTrendArrows = Black;
extern color BackgroundColor = C'0x0F,0x0F,0x21';
extern color BackShadowColor = C'0x30,0x30,0x45';
extern color CompactBackground = C'0x21,0x21,0x2F';
extern string AlertSettings = "|||| Message Box and/or Audible Alert:";
extern bool MessageBoxAlert = FALSE;
extern bool AudibleAlert = FALSE;
extern string AudibleAlertSoundFile = "alert2.wav";
extern int AlertTriggerPercentage = 90;
int gi_228 = 0;
string gs_232 = "";
double g_timeframe_240;
string gs_unused_248 = "=== Moving Average Settings ===";
int g_period_256 = 3;
int g_period_260 = 7;
int g_period_264 = 20;
int g_period_268 = 50;
int g_period_272 = 90;
int g_period_276 = 150;
int g_ma_method_280 = MODE_SMA;
int g_ma_method_284 = MODE_EMA;
int g_ma_method_288 = MODE_SMMA;
int g_applied_price_292 = PRICE_CLOSE;
string gs_unused_296 = "=== CCI Settings ===";
int g_period_304 = 14;
int g_applied_price_308 = PRICE_CLOSE;
string gs_unused_312 = "=== MACD Settings ===";
int g_period_320 = 12;
int g_period_324 = 26;
int g_period_328 = 9;
string gs_unused_332 = "=== ADX Settings ===";
int g_period_340 = 14;
int g_applied_price_344 = PRICE_CLOSE;
string gs_unused_348 = "=== BULLS Settings ===";
int g_period_356 = 13;
int g_applied_price_360 = PRICE_CLOSE;
string gs_unused_364 = "=== BEARS Settings ===";
int g_period_372 = 13;
int g_applied_price_376 = PRICE_CLOSE;
string gs_unused_380 = "=== STOCHASTIC Settings ===";
int g_period_388 = 5;
int g_period_392 = 3;
int g_slowing_396 = 3;
string gs_unused_400 = "=== RSI Settings ===";
int g_period_408 = 14;
string gs_unused_412 = "=== FORCE INDEX Settings ===";
int g_period_420 = 14;
int g_ma_method_424 = MODE_SMA;
int g_applied_price_428 = PRICE_CLOSE;
string gs_unused_432 = "=== MOMENTUM INDEX Settings ===";
int g_period_440 = 14;
int g_applied_price_444 = PRICE_CLOSE;
string gs_unused_448 = "=== DeMARKER Settings ===";
int g_period_456 = 14;
int g_timeframe_460;
int g_timeframe_464;
int g_timeframe_468;
int g_timeframe_472;
int g_timeframe_476;
int g_timeframe_480;
int g_timeframe_484;
int g_timeframe_488;
int g_timeframe_492;
string g_text_496;
string g_text_504;
int gi_512;
string g_text_516;
int gi_524;
string g_text_528;
int gi_536;
string g_text_540;
string g_text_548;
int gi_556;
double gd_560;
color g_color_568;
color g_color_572;
color g_color_580;
color g_color_584;
color g_color_588;
color g_color_592;
color g_color_596;
color g_color_600;
color g_color_604;
color g_color_608;
color g_color_612;
color g_color_616;
color g_color_624;
int gi_unused_628 = 3342110;
int gi_632 = 3014425;
int gi_636 = 2686740;
int gi_640 = 2162444;
int gi_644 = 1638148;
int gi_648 = 1376000;
int gi_652 = 1374720;
int gi_656 = 1372160;
int gi_660 = 1369600;
int gi_664 = 1367040;
int gi_668 = 1364224;
int gi_672 = 1361408;
int gi_676 = 1357568;
int gi_680 = 1354752;
int gi_684 = 1351424;
int gi_688 = 1348608;
int gi_692 = 1345280;
int gi_696 = 1341696;
int gi_700 = 1337856;
int gi_704 = 1334784;
int gi_708 = 1332480;
int gi_712 = 1331200;
int gi_716 = 1330432;
int gi_720 = 1329920;
int gi_724 = 5588550;
int gi_728 = 15425315;
int g_color_732 = C'0x23,0x5F,0xEB';
int gi_736 = 15425315;
int gi_740 = 15425315;
int gi_744 = 15425315;
int gi_748 = 3071;
int gi_752 = 2559;
int gi_756 = 1791;
int gi_760 = 767;
int gi_764 = 1310973;
int gi_768 = 1310970;
int gi_772 = 1310968;
int gi_776 = 1310964;
int gi_780 = 1310960;
int gi_784 = 1310955;
int gi_788 = 1310950;
int gi_792 = 1310945;
int gi_796 = 1310941;
int gi_800 = 1310937;
int gi_804 = 213;
int gi_808 = 209;
int gi_812 = 205;
int gi_816 = 200;
int gi_820 = 195;
int gi_824 = 190;
int gi_828 = 185;
int gi_832 = 180;
int gi_836 = 175;
int gi_840 = 170;
int gi_844 = 1050375;
int gi_848 = 1313290;
int gi_852 = 1773841;
int gi_856 = 2300185;
int gi_860 = 2760736;
int gi_864 = 3221287;
int gi_868 = 3943982;
int gi_872 = 4142389;
int gi_876 = 4602940;
int gi_880 = 5063491;
int gi_884 = 5524042;
int gi_888 = 5984593;
int gi_892 = 6445144;
int gi_896 = 6905695;
int gi_900 = 7366246;
int gi_904 = 7826797;
int gi_908 = 8221555;
int gi_912 = 8550520;
int gi_916 = 8813692;
int gi_920 = 9076864;
int gi_924 = 9340036;
int gi_928 = 9603208;
int gi_932 = 9866380;
int gi_unused_936 = 10129552;
int gi_940;
int gi_944;
string gs_unused_952;

int init() {
   if (UpColorBLUE) {
      gi_unused_628 = 15763806;
      gi_632 = 15695952;
      gi_636 = 15694923;
      gi_640 = 15628358;
      gi_644 = 15562307;
      gi_648 = 15561792;
      gi_652 = 15561277;
      gi_656 = 15559482;
      gi_660 = 15557941;
      gi_664 = 15490864;
      gi_668 = 15096107;
      gi_672 = 14111526;
      gi_676 = 13126945;
      gi_680 = 12142620;
      gi_684 = 11158296;
      gi_688 = 10173972;
      gi_692 = 9255184;
      gi_696 = 8336397;
      gi_700 = 6762251;
      gi_704 = 5843466;
      gi_708 = 4924681;
      gi_712 = 4268040;
      gi_716 = 3611143;
      gi_720 = 2757382;
      gi_724 = FALSE;
      gi_728 = 15425315;
      g_color_732 = C'0xA0,0xA0,0xA0';
      gi_736 = 11184810;
      gi_744 = 15425315;
   }
   return (0);
}

int deinit() {
   string ls_unused_0;
   ObjectDelete("[wyfxco.com]symbol" + NitroMagicNumber);
   ObjectDelete("�2010 www.wyfxco.com" + NitroMagicNumber);
   ObjectDelete("*�2010 www.wyfxco.com1" + NitroMagicNumber);
   ObjectDelete("*�2010 www.wyfxco.com2" + NitroMagicNumber);
   ObjectDelete("*�2010 www.wyfxco.com3" + NitroMagicNumber);
   ObjectDelete("*�2010 www.wyfxco.com4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_1" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_5" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_6" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_7" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_8" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_9" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_10" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_11" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_12" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_13" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_14" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_15" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_16" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_17" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_18" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_19" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_20" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_21" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_22" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_23" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]trend_logo_24" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_1" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_5" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_6" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_7" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_8" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_9" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_10" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_11" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_12" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_13" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_14" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_15" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_16" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_17" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_18" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_19" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_20" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_21" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_22" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_23" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]titan_logo_24" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]Direction" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber);
   ObjectDelete("**�2010 www.wyfxco.com || Distribution Is Prohibited." + NitroMagicNumber);
   ObjectDelete("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]T2_Z" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]T2_score" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]T2_logo" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]T2_logo2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]T2_logo3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]T2_logo4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]legend1" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]legend2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_comment_T2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]e_SS_logo" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]e_SS_logo2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]e_SS_logo3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]e_SS_logo4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]e_SS_score" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_comment_e_SS" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]d_DeM_logo" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]d_DeM_logo2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]d_DeM_logo3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]d_DeM_logo4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]d_DeM_score" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_comment_d_DeM" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]c_MFI_logo" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]c_MFI_logo2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]c_MFI_logo3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]c_MFI_logo4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]c_MFI_score" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_comment_c_MFI" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]b_RVI_logo" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]b_RVI_logo2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]b_RVI_logo3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]b_RVI_logo4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]b_RVI_score" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_comment_b_RVI" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]AO_logo" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]AO_logo2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]AO_logo3" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]AO_logo4" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]AO_score" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]X_comment_AO" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]Title1" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]Title2" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]copyright" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]NITRO_Price" + NitroMagicNumber);
   ObjectDelete("[wyfxco.com]highlight" + NitroMagicNumber);
   ObjectDelete("* �2010 www.wyfxco.com * Distribution Is Prohibited. *" + NitroMagicNumber);
   DelUnauthorized();
   return (0);
}

int start() {
   double ld_0;
   double ld_8;
   double ld_16;
   double ld_24;
   double ld_32;
   double ld_40;
   double ld_48;
   double ld_56;
   double ld_64;
   double ld_72;
   double ld_80;
   double ld_88;
   double ld_96;
   double ld_104;
   double ld_112;
   double ld_120;
   double ld_128;
   double ld_136;
   double ld_144;
   double ld_152;
   double ld_160;
   double ld_168;
   double ld_176;
   double ld_184;
   double ld_192;
   double ld_200;
   double ld_208;
   double ld_216;
   double ld_224;
   double ld_232;
   double ld_240;
   double ld_248;
   double ld_256;
   double ld_264;
   double ld_272;
   double ld_280;
   double ld_288;
   double ld_296;
   double ld_304;
   double ld_312;
   double ld_320;
   double ld_328;
   double ld_336;
   double ld_344;
   double ld_352;
   double ld_360;
   double ld_368;
   double ld_376;
   double ld_392;
   double ld_400;
   double ld_408;
   double ld_416;
   double ld_432;
   double ld_440;
   double ld_448;
   double ld_456;
   double ld_464;
   double ld_472;
   double ld_480;
   double ld_488;
   double ld_496;
   double ld_504;
   double ld_512;
   double ld_520;
   double ld_528;
   double ld_536;
   double ld_544;
   double ld_552;
   double ld_560;
   double ld_568;
   double ld_576;
   double ld_584;
   double ld_592;
   double ld_600;
   double ld_608;
   double ld_616;
   double ld_624;
   double ld_632;
   double ld_640;
   double ld_648;
   double ld_656;
   double ld_664;
   double ld_672;
   double ld_680;
   double ld_688;
   double ld_696;
   double ld_704;
   double ld_712;
   double ld_720;
   double ld_728;
   double ld_736;
   double ld_744;
   double ld_752;
   double ld_760;
   double ld_768;
   double ld_776;
   double ld_784;
   double ld_792;
   double ld_800;
   double ld_808;
   double ld_816;
   double ld_824;
   double ld_832;
   double ld_840;
   double ld_848;
   double ld_856;
   double ld_864;
   double ld_872;
   double ld_880;
   double ld_888;
   double ld_896;
   double ld_904;
   double ld_912;
   double ld_920;
   double ld_928;
   double ld_936;
   double ld_944;
   double ld_952;
   double ld_960;
   double ld_968;
   double ld_976;
   double ld_984;
   double ld_992;
   double ld_1000;
   double ld_1008;
   double ld_1016;
   double ld_1024;
   double ld_1032;
   double ld_1040;
   double ld_1048;
   double ld_1056;
   double ld_1064;
   double ld_1072;
   double ld_1080;
   double ld_1088;
   double ld_1096;
   double ld_1104;
   double ld_1112;
   double ld_1120;
   double ld_1128;
   double ld_1136;
   double ld_1144;
   double ld_1152;
   double ld_1160;
   double ld_1168;
   double ld_1176;
   double ld_1184;
   double ld_1192;
   double ld_1200;
   double ld_1208;
   double ld_1216;
   double ld_1224;
   double ld_1232;
   double ld_1240;
   double ld_1248;
   double ld_1256;
   double ld_1264;
   double ld_1272;
   double ld_1280;
   double ld_1288;
   double ld_1296;
   double ld_1304;
   double ld_1312;
   double ld_1320;
   double ld_1328;
   double ld_1336;
   double ld_1344;
   double ld_1352;
   double ld_1360;
   double ld_1368;
   double ld_1376;
   double ld_1384;
   double ld_1392;
   double ld_1400;
   double ld_1408;
   double ld_1416;
   double ld_1424;
   double ld_1432;
   double ld_1440;
   double ld_1448;
   double ld_1456;
   double ld_1464;
   double ld_1472;
   double ld_1480;
   double ld_1488;
   double ld_1496;
   double ld_1504;
   double ld_1512;
   double ld_1520;
   double ld_1528;
   double ld_1536;
   double ld_1544;
   double ld_1552;
   double ld_1560;
   double ld_1568;
   double ld_1576;
   double ld_1584;
   double ld_1592;
   double ld_1600;
   double ld_1608;
   double ld_1616;
   double ld_1624;
   double ld_1632;
   double ld_1640;
   double ld_1648;
   double ld_1656;
   double ld_1664;
   double ld_1672;
   double ld_1680;
   double ld_1688;
   double ld_1696;
   double ld_1704;
   double ld_1712;
   double ld_1720;
   double ld_1728;
   double ld_1736;
   double ld_1744;
   double ld_1752;
   double ld_1760;
   double ld_1768;
   double ld_1776;
   double ld_1784;
   double ld_1792;
   double ld_1800;
   double ld_1808;
   double ld_1816;
   double ld_1824;
   double ld_1832;
   double ld_1840;
   double ld_1848;
   double ld_1856;
   double ld_1864;
   double ld_1872;
   double ld_1880;
   double ld_1888;
   double ld_1896;
   double ld_1904;
   double ld_1912;
   double ld_1920;
   double ld_1928;
   double ld_1936;
   double ld_1944;
   double ld_1952;
   double ld_1960;
   double ld_1968;
   double ld_1976;
   double ld_1984;
   double ld_1992;
   double ld_2000;
   double ld_2008;
   double ld_2016;
   double ld_2024;
   double ld_2032;
   double ld_2040;
   double ld_2048;
   double ld_2056;
   double ld_2064;
   double ld_2072;
   double ld_2080;
   double ld_2088;
   double ld_2096;
   double ld_2104;
   double ld_2112;
   double ld_2120;
   double ld_2128;
   double ld_2136;
   double ld_2144;
   double ld_2152;
   double ld_2160;
   double ld_2168;
   double ld_2176;
   double ld_2184;
   double ld_2192;
   double ld_2200;
   double ld_2208;
   double ld_2216;
   double ld_2224;
   double ld_2232;
   double ld_2240;
   double ld_2248;
   string ls_unused_4280;
   string ls_unused_4288;
   string ls_unused_4296;
   string ls_unused_4316;
   string ls_unused_4324;
   string ls_unused_4332;
   string ls_unused_4340;
   string ls_unused_4348;
   string l_text_4384;
   color l_color_4396;
   color l_color_4400;
   color l_color_4404;
   color l_color_4408;
   color l_color_4412;
   color l_color_4416;
   color l_color_4420;
   color l_color_4424;
   color l_color_4428;
   color l_color_4432;
   color l_color_4436;
   color l_color_4440;
   color l_color_4444;
   color l_color_4448;
   color l_color_4452;
   color l_color_4456;
   color l_color_4460;
   color l_color_4464;
   color l_color_4468;
   color l_color_4472;
   color l_color_4476;
   color l_color_4480;
   color l_color_4484;
   color l_color_4488;
   color l_color_4492;
   color l_color_4496;
   color l_color_4500;
   color l_color_4504;
   color l_color_4508;
   color l_color_4512;
   color l_color_4516;
   color l_color_4520;
   color l_color_4524;
   color l_color_4528;
   color l_color_4532;
   color l_color_4536;
   color l_color_4540;
   color l_color_4544;
   color l_color_4548;
   color l_color_4552;
   color l_color_4556;
   color l_color_4560;
   color l_color_4564;
   color l_color_4568;
   color l_color_4572;
   color l_color_4576;
   color l_color_4580;
   color l_color_4584;
   color l_color_4588;
   color l_color_4600;
   color l_color_4604;
   int li_4628;
   int li_4624 = 30;
   int l_corner_4636 = 1;
   int li_4640 = 95;
   int li_4644 = 52;
   int li_4648 = 141;
   int li_4652 = 48;
   int li_4656 = 160;
   int li_4660 = 45;
   int li_4664 = 91;
   int li_4668 = 7;
   int li_4672 = 3;
   int li_4676 = 91;
   int li_4680 = 0;
   int li_4684 = -5;
   int li_4688 = 0;
   int li_4692 = 0;
   int li_4696 = 5;
   int li_4700 = 5;
   int li_4704 = 309;
   int li_4708 = 0;
   int l_angle_4712 = 0;
   int li_4716 = 3;
   int li_4720 = 0;
   DelUnauthorized();
   if (LeftSidePlacement == TRUE) {
      l_corner_4636 = 4;
      li_4640 = 78;
      li_4644 = 107;
      li_4648 = 124;
      li_4652 = 107;
      li_4656 = 194;
      li_4660 = 46;
      li_4664 = 227;
      li_4668 = 153;
      li_4676 = 228;
      li_4672 = 156;
      li_4688 = 9;
      li_4692 = 5;
      li_4696 = 9;
      li_4700 = 8;
      li_4704 = 338;
      li_4708 = 4;
      l_angle_4712 = 180;
      li_4716 = 5;
      li_4720 = 6;
   }
   if (ShowPrice == FALSE) {
      li_4680 = -109;
      li_4684 = -114;
      g_text_496 = "/////////";
   }
   if (ShowPrice == TRUE) g_text_496 = "////////////";
   if (MarketSymbol == "") MarketSymbol = Symbol();
   string ls_4616 = StringSubstr(MarketSymbol, 0, 6);
   string l_dbl2str_4724 = DoubleToStr(MarketInfo(MarketSymbol, MODE_BID), MarketInfo(MarketSymbol, MODE_DIGITS));
   g_timeframe_240 = Period();
   if (g_timeframe_240 == 1.0) gs_232 = "M1";
   if (g_timeframe_240 == 5.0) gs_232 = "M5";
   if (g_timeframe_240 == 15.0) gs_232 = "M15";
   if (g_timeframe_240 == 30.0) gs_232 = "M30";
   if (g_timeframe_240 == 60.0) gs_232 = "H1";
   if (g_timeframe_240 == 240.0) gs_232 = "H4";
   if (g_timeframe_240 == 1440.0) gs_232 = "D1";
   if (g_timeframe_240 == 10080.0) gs_232 = "W1";
   if (g_timeframe_240 == 43200.0) gs_232 = "MN";
   if (g_timeframe_240 == 1.0) g_timeframe_460 = 15;
   if (g_timeframe_240 == 5.0) g_timeframe_460 = 30;
   if (g_timeframe_240 == 15.0) g_timeframe_460 = 60;
   if (g_timeframe_240 == 30.0) g_timeframe_460 = 60;
   if (g_timeframe_240 == 60.0) g_timeframe_460 = 240;
   if (g_timeframe_240 == 240.0) g_timeframe_460 = 240;
   if (g_timeframe_240 == 1440.0) g_timeframe_460 = 1440;
   if (g_timeframe_240 == 10080.0) g_timeframe_460 = 10080;
   if (g_timeframe_240 == 43200.0) g_timeframe_460 = 43200;
   if (g_timeframe_240 == 1.0) g_timeframe_464 = 5;
   if (g_timeframe_240 == 5.0) g_timeframe_464 = 15;
   if (g_timeframe_240 == 15.0) g_timeframe_464 = 30;
   if (g_timeframe_240 == 30.0) g_timeframe_464 = 60;
   if (g_timeframe_240 == 60.0) g_timeframe_464 = 240;
   if (g_timeframe_240 == 240.0) g_timeframe_464 = 240;
   if (g_timeframe_240 == 1440.0) g_timeframe_464 = 1440;
   if (g_timeframe_240 == 10080.0) g_timeframe_464 = 10080;
   if (g_timeframe_240 == 43200.0) g_timeframe_464 = 43200;
   if (g_timeframe_240 == 1.0) {
      g_timeframe_468 = 15;
      g_timeframe_472 = 5;
      g_timeframe_476 = 30;
      g_timeframe_480 = 60;
      g_timeframe_484 = 1;
      g_timeframe_488 = 30;
      g_timeframe_492 = 60;
   }
   if (g_timeframe_240 == 5.0) {
      g_timeframe_468 = 30;
      g_timeframe_472 = 15;
      g_timeframe_476 = 240;
      g_timeframe_480 = 60;
      g_timeframe_484 = 15;
      g_timeframe_488 = 60;
      g_timeframe_492 = 5;
   }
   if (g_timeframe_240 == 15.0) {
      g_timeframe_468 = 60;
      g_timeframe_472 = 15;
      g_timeframe_476 = 30;
      g_timeframe_480 = 240;
      g_timeframe_484 = 30;
      g_timeframe_488 = 1440;
      g_timeframe_492 = 5;
   }
   if (g_timeframe_240 == 30.0) {
      g_timeframe_468 = 60;
      g_timeframe_472 = 30;
      g_timeframe_476 = 240;
      g_timeframe_480 = 1440;
      g_timeframe_484 = 240;
      g_timeframe_488 = 30;
      g_timeframe_492 = 15;
   }
   if (g_timeframe_240 == 60.0) {
      g_timeframe_468 = 60;
      g_timeframe_472 = 240;
      g_timeframe_476 = 1440;
      g_timeframe_480 = 30;
      g_timeframe_484 = 1440;
      g_timeframe_488 = 240;
      g_timeframe_492 = 15;
   }
   if (g_timeframe_240 == 240.0) {
      g_timeframe_468 = 240;
      g_timeframe_472 = 1440;
      g_timeframe_476 = 1440;
      g_timeframe_480 = 60;
      g_timeframe_484 = 240;
      g_timeframe_488 = 10080;
      g_timeframe_492 = 30;
   }
   if (g_timeframe_240 == 1440.0) {
      g_timeframe_468 = 1440;
      g_timeframe_472 = 240;
      g_timeframe_476 = 10080;
      g_timeframe_480 = 240;
      g_timeframe_484 = 1440;
      g_timeframe_488 = 60;
      g_timeframe_492 = 10080;
   }
   if (g_timeframe_240 == 10080.0) {
      g_timeframe_468 = 10080;
      g_timeframe_472 = 10080;
      g_timeframe_476 = 10080;
      g_timeframe_480 = 1440;
      g_timeframe_484 = 1440;
      g_timeframe_488 = 1440;
      g_timeframe_492 = 240;
   }
   if (g_timeframe_240 == 43200.0) {
      g_timeframe_468 = 43200;
      g_timeframe_472 = 43200;
      g_timeframe_476 = 10080;
      g_timeframe_480 = 10080;
      g_timeframe_484 = 1440;
      g_timeframe_488 = 1440;
      g_timeframe_492 = 1440;
   }
   double l_ima_2368 = iMA(MarketSymbol, g_timeframe_492, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2376 = iMA(MarketSymbol, g_timeframe_492, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2368 >= l_ima_2376) {
      ld_1584 = 1;
      ld_1640 = 0;
   }
   if (l_ima_2368 < l_ima_2376) {
      ld_1584 = 0;
      ld_1640 = 1;
   }
   double l_ima_2384 = iMA(MarketSymbol, g_timeframe_488, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2392 = iMA(MarketSymbol, g_timeframe_488, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2384 >= l_ima_2392) {
      ld_1592 = 1;
      ld_1648 = 0;
   }
   if (l_ima_2384 < l_ima_2392) {
      ld_1592 = 0;
      ld_1648 = 1;
   }
   double l_ima_2400 = iMA(MarketSymbol, g_timeframe_484, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2408 = iMA(MarketSymbol, g_timeframe_484, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2400 >= l_ima_2408) {
      ld_1600 = 1;
      ld_1656 = 0;
   }
   if (l_ima_2400 < l_ima_2408) {
      ld_1600 = 0;
      ld_1656 = 1;
   }
   double l_ima_2416 = iMA(MarketSymbol, g_timeframe_480, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2424 = iMA(MarketSymbol, g_timeframe_480, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2416 >= l_ima_2424) {
      ld_1608 = 2;
      ld_1664 = 0;
   }
   if (l_ima_2416 < l_ima_2424) {
      ld_1608 = 0;
      ld_1664 = 2;
   }
   double l_ima_2432 = iMA(MarketSymbol, g_timeframe_468, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2440 = iMA(MarketSymbol, g_timeframe_468, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2432 >= l_ima_2440) {
      ld_1616 = 3;
      ld_1672 = 0;
   }
   if (l_ima_2432 < l_ima_2440) {
      ld_1616 = 0;
      ld_1672 = 3;
   }
   double l_ima_2448 = iMA(MarketSymbol, g_timeframe_472, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2456 = iMA(MarketSymbol, g_timeframe_472, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2448 >= l_ima_2456) {
      ld_1624 = 2;
      ld_1680 = 0;
   }
   if (l_ima_2448 < l_ima_2456) {
      ld_1624 = 0;
      ld_1680 = 2;
   }
   double l_ima_2464 = iMA(MarketSymbol, g_timeframe_476, g_period_256, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2472 = iMA(MarketSymbol, g_timeframe_476, g_period_276, 0, g_ma_method_288, g_applied_price_292, 0);
   if (l_ima_2464 >= l_ima_2472) {
      ld_1632 = 2;
      ld_1688 = 0;
   }
   if (l_ima_2464 < l_ima_2472) {
      ld_1632 = 0;
      ld_1688 = 2;
   }
   double l_ima_2256 = iMA(MarketSymbol, g_timeframe_492, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2264 = iMA(MarketSymbol, g_timeframe_492, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2256 >= l_ima_2264) {
      ld_1472 = 1;
      ld_1528 = 0;
   }
   if (l_ima_2256 < l_ima_2264) {
      ld_1472 = 0;
      ld_1528 = 1;
   }
   double l_ima_2272 = iMA(MarketSymbol, g_timeframe_488, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2280 = iMA(MarketSymbol, g_timeframe_488, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2272 >= l_ima_2280) {
      ld_1480 = 1;
      ld_1536 = 0;
   }
   if (l_ima_2272 < l_ima_2280) {
      ld_1480 = 0;
      ld_1536 = 1;
   }
   double l_ima_2288 = iMA(MarketSymbol, g_timeframe_484, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2296 = iMA(MarketSymbol, g_timeframe_484, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2288 >= l_ima_2296) {
      ld_1488 = 1;
      ld_1544 = 0;
   }
   if (l_ima_2288 < l_ima_2296) {
      ld_1488 = 0;
      ld_1544 = 1;
   }
   double l_ima_2304 = iMA(MarketSymbol, g_timeframe_480, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2312 = iMA(MarketSymbol, g_timeframe_480, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2304 >= l_ima_2312) {
      ld_1496 = 2;
      ld_1552 = 0;
   }
   if (l_ima_2304 < l_ima_2312) {
      ld_1496 = 0;
      ld_1552 = 2;
   }
   double l_ima_2320 = iMA(MarketSymbol, g_timeframe_468, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2328 = iMA(MarketSymbol, g_timeframe_468, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2320 >= l_ima_2328) {
      ld_1504 = 3;
      ld_1560 = 0;
   }
   if (l_ima_2320 < l_ima_2328) {
      ld_1504 = 0;
      ld_1560 = 3;
   }
   double l_ima_2336 = iMA(MarketSymbol, g_timeframe_472, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2344 = iMA(MarketSymbol, g_timeframe_472, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2336 >= l_ima_2344) {
      ld_1512 = 2;
      ld_1568 = 0;
   }
   if (l_ima_2336 < l_ima_2344) {
      ld_1512 = 0;
      ld_1568 = 2;
   }
   double l_ima_2352 = iMA(MarketSymbol, g_timeframe_476, g_period_260, 0, g_ma_method_280, g_applied_price_292, 0);
   double l_ima_2360 = iMA(MarketSymbol, g_timeframe_476, g_period_260, 0, g_ma_method_280, g_applied_price_292, 1);
   if (l_ima_2352 >= l_ima_2360) {
      ld_1520 = 2;
      ld_1576 = 0;
   }
   if (l_ima_2352 < l_ima_2360) {
      ld_1520 = 0;
      ld_1576 = 2;
   }
   double l_ima_2480 = iMA(MarketSymbol, g_timeframe_492, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2488 = iMA(MarketSymbol, g_timeframe_492, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2480 >= l_ima_2488) {
      ld_0 = 1;
      ld_464 = 0;
   }
   if (l_ima_2480 < l_ima_2488) {
      ld_0 = 0;
      ld_464 = 1;
   }
   double l_ima_2496 = iMA(MarketSymbol, g_timeframe_488, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2504 = iMA(MarketSymbol, g_timeframe_488, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2496 >= l_ima_2504) {
      ld_8 = 1;
      ld_472 = 0;
   }
   if (l_ima_2496 < l_ima_2504) {
      ld_8 = 0;
      ld_472 = 1;
   }
   double l_ima_2512 = iMA(MarketSymbol, g_timeframe_484, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2520 = iMA(MarketSymbol, g_timeframe_484, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2512 >= l_ima_2520) {
      ld_16 = 1;
      ld_480 = 0;
   }
   if (l_ima_2512 < l_ima_2520) {
      ld_16 = 0;
      ld_480 = 1;
   }
   double l_ima_2528 = iMA(MarketSymbol, g_timeframe_480, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2536 = iMA(MarketSymbol, g_timeframe_480, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2528 >= l_ima_2536) {
      ld_24 = 2;
      ld_488 = 0;
   }
   if (l_ima_2528 < l_ima_2536) {
      ld_24 = 0;
      ld_488 = 2;
   }
   double l_ima_2544 = iMA(MarketSymbol, g_timeframe_468, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2552 = iMA(MarketSymbol, g_timeframe_468, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2544 >= l_ima_2552) {
      ld_32 = 3;
      ld_496 = 0;
   }
   if (l_ima_2544 < l_ima_2552) {
      ld_32 = 0;
      ld_496 = 3;
   }
   double l_ima_2560 = iMA(MarketSymbol, g_timeframe_472, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2568 = iMA(MarketSymbol, g_timeframe_472, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2560 >= l_ima_2568) {
      ld_40 = 2;
      ld_504 = 0;
   }
   if (l_ima_2560 < l_ima_2568) {
      ld_40 = 0;
      ld_504 = 2;
   }
   double l_ima_2576 = iMA(MarketSymbol, g_timeframe_476, g_period_264, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2584 = iMA(MarketSymbol, g_timeframe_476, g_period_264, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2576 >= l_ima_2584) {
      ld_48 = 2;
      ld_512 = 0;
   }
   if (l_ima_2576 < l_ima_2584) {
      ld_48 = 0;
      ld_512 = 2;
   }
   double l_ima_2592 = iMA(MarketSymbol, g_timeframe_492, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2600 = iMA(MarketSymbol, g_timeframe_492, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2592 >= l_ima_2600) {
      ld_56 = 1;
      ld_520 = 0;
   }
   if (l_ima_2592 < l_ima_2600) {
      ld_56 = 0;
      ld_520 = 1;
   }
   double l_ima_2608 = iMA(MarketSymbol, g_timeframe_488, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2616 = iMA(MarketSymbol, g_timeframe_488, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2608 >= l_ima_2616) {
      ld_64 = 1;
      ld_528 = 0;
   }
   if (l_ima_2608 < l_ima_2616) {
      ld_64 = 0;
      ld_528 = 1;
   }
   double l_ima_2624 = iMA(MarketSymbol, g_timeframe_484, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2632 = iMA(MarketSymbol, g_timeframe_484, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2624 >= l_ima_2632) {
      ld_72 = 1;
      ld_536 = 0;
   }
   if (l_ima_2624 < l_ima_2632) {
      ld_72 = 0;
      ld_536 = 1;
   }
   double l_ima_2640 = iMA(MarketSymbol, g_timeframe_480, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2648 = iMA(MarketSymbol, g_timeframe_480, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2640 >= l_ima_2648) {
      ld_80 = 2;
      ld_544 = 0;
   }
   if (l_ima_2640 < l_ima_2648) {
      ld_80 = 0;
      ld_544 = 2;
   }
   double l_ima_2656 = iMA(MarketSymbol, g_timeframe_468, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2664 = iMA(MarketSymbol, g_timeframe_468, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2656 >= l_ima_2664) {
      ld_88 = 3;
      ld_552 = 0;
   }
   if (l_ima_2656 < l_ima_2664) {
      ld_88 = 0;
      ld_552 = 3;
   }
   double l_ima_2672 = iMA(MarketSymbol, g_timeframe_472, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2680 = iMA(MarketSymbol, g_timeframe_472, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2672 >= l_ima_2680) {
      ld_96 = 2;
      ld_560 = 0;
   }
   if (l_ima_2672 < l_ima_2680) {
      ld_96 = 0;
      ld_560 = 2;
   }
   double l_ima_2688 = iMA(MarketSymbol, g_timeframe_476, g_period_268, 0, g_ma_method_284, g_applied_price_292, 0);
   double l_ima_2696 = iMA(MarketSymbol, g_timeframe_476, g_period_268, 0, g_ma_method_284, g_applied_price_292, 1);
   if (l_ima_2688 >= l_ima_2696) {
      ld_104 = 2;
      ld_568 = 0;
   }
   if (l_ima_2688 < l_ima_2696) {
      ld_104 = 0;
      ld_568 = 2;
   }
   double l_ima_2704 = iMA(MarketSymbol, g_timeframe_492, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2712 = iMA(MarketSymbol, g_timeframe_492, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2704 >= l_ima_2712) {
      ld_112 = 1;
      ld_576 = 0;
   }
   if (l_ima_2704 < l_ima_2712) {
      ld_112 = 0;
      ld_576 = 1;
   }
   double l_ima_2720 = iMA(MarketSymbol, g_timeframe_488, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2728 = iMA(MarketSymbol, g_timeframe_488, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2720 >= l_ima_2728) {
      ld_120 = 1;
      ld_584 = 0;
   }
   if (l_ima_2720 < l_ima_2728) {
      ld_120 = 0;
      ld_584 = 1;
   }
   double l_ima_2736 = iMA(MarketSymbol, g_timeframe_484, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2744 = iMA(MarketSymbol, g_timeframe_484, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2736 >= l_ima_2744) {
      ld_128 = 1;
      ld_592 = 0;
   }
   if (l_ima_2736 < l_ima_2744) {
      ld_128 = 0;
      ld_592 = 1;
   }
   double l_ima_2752 = iMA(MarketSymbol, g_timeframe_480, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2760 = iMA(MarketSymbol, g_timeframe_480, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2752 >= l_ima_2760) {
      ld_136 = 2;
      ld_600 = 0;
   }
   if (l_ima_2752 < l_ima_2760) {
      ld_136 = 0;
      ld_600 = 2;
   }
   double l_ima_2768 = iMA(MarketSymbol, g_timeframe_468, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2776 = iMA(MarketSymbol, g_timeframe_468, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2768 >= l_ima_2776) {
      ld_144 = 3;
      ld_608 = 0;
   }
   if (l_ima_2768 < l_ima_2776) {
      ld_144 = 0;
      ld_608 = 3;
   }
   double l_ima_2784 = iMA(MarketSymbol, g_timeframe_472, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2792 = iMA(MarketSymbol, g_timeframe_472, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2784 >= l_ima_2792) {
      ld_152 = 2;
      ld_616 = 0;
   }
   if (l_ima_2784 < l_ima_2792) {
      ld_152 = 0;
      ld_616 = 2;
   }
   double l_ima_2800 = iMA(MarketSymbol, g_timeframe_476, g_period_272, 0, g_ma_method_288, g_applied_price_292, 0);
   double l_ima_2808 = iMA(MarketSymbol, g_timeframe_476, g_period_272, 0, g_ma_method_288, g_applied_price_292, 1);
   if (l_ima_2800 >= l_ima_2808) {
      ld_160 = 2;
      ld_624 = 0;
   }
   if (l_ima_2800 < l_ima_2808) {
      ld_160 = 0;
      ld_624 = 2;
   }
   double l_icci_2816 = iCCI(MarketSymbol, g_timeframe_492, g_period_304, g_applied_price_308, 0);
   if (l_icci_2816 >= 0.0) {
      ld_168 = 1;
      ld_632 = 0;
   }
   if (l_icci_2816 < 0.0) {
      ld_168 = 0;
      ld_632 = 1;
   }
   double l_icci_2824 = iCCI(MarketSymbol, g_timeframe_488, g_period_304, g_applied_price_308, 0);
   if (l_icci_2824 >= 0.0) {
      ld_176 = 1;
      ld_640 = 0;
   }
   if (l_icci_2824 < 0.0) {
      ld_176 = 0;
      ld_640 = 1;
   }
   double l_icci_2832 = iCCI(MarketSymbol, g_timeframe_484, g_period_304, g_applied_price_308, 0);
   if (l_icci_2832 >= 0.0) {
      ld_184 = 1;
      ld_648 = 0;
   }
   if (l_icci_2832 < 0.0) {
      ld_184 = 0;
      ld_648 = 1;
   }
   double l_icci_2840 = iCCI(MarketSymbol, g_timeframe_480, g_period_304, g_applied_price_308, 0);
   if (l_icci_2840 >= 0.0) {
      ld_192 = 2;
      ld_656 = 0;
   }
   if (l_icci_2840 < 0.0) {
      ld_192 = 0;
      ld_656 = 2;
   }
   double l_icci_2848 = iCCI(MarketSymbol, g_timeframe_468, g_period_304, g_applied_price_308, 0);
   if (l_icci_2848 >= 0.0) {
      ld_200 = 3;
      ld_664 = 0;
   }
   if (l_icci_2848 < 0.0) {
      ld_200 = 0;
      ld_664 = 3;
   }
   double l_icci_2856 = iCCI(MarketSymbol, g_timeframe_472, g_period_304, g_applied_price_308, 0);
   if (l_icci_2856 >= 0.0) {
      ld_208 = 2;
      ld_672 = 0;
   }
   if (l_icci_2856 < 0.0) {
      ld_208 = 0;
      ld_672 = 2;
   }
   double l_icci_2864 = iCCI(MarketSymbol, g_timeframe_476, g_period_304, g_applied_price_308, 0);
   if (l_icci_2864 >= 0.0) {
      ld_216 = 2;
      ld_680 = 0;
   }
   if (l_icci_2864 < 0.0) {
      ld_216 = 0;
      ld_680 = 2;
   }
   double l_imacd_2872 = iMACD(MarketSymbol, g_timeframe_492, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2880 = iMACD(MarketSymbol, g_timeframe_492, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2872 >= l_imacd_2880) {
      ld_224 = 1;
      ld_688 = 0;
   }
   if (l_imacd_2872 < l_imacd_2880) {
      ld_224 = 0;
      ld_688 = 1;
   }
   double l_imacd_2888 = iMACD(MarketSymbol, g_timeframe_488, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2896 = iMACD(MarketSymbol, g_timeframe_488, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2888 >= l_imacd_2896) {
      ld_232 = 1;
      ld_696 = 0;
   }
   if (l_imacd_2888 < l_imacd_2896) {
      ld_232 = 0;
      ld_696 = 1;
   }
   double l_imacd_2904 = iMACD(MarketSymbol, g_timeframe_484, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2912 = iMACD(MarketSymbol, g_timeframe_484, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2904 >= l_imacd_2912) {
      ld_240 = 1;
      ld_704 = 0;
   }
   if (l_imacd_2904 < l_imacd_2912) {
      ld_240 = 0;
      ld_704 = 1;
   }
   double l_imacd_2920 = iMACD(MarketSymbol, g_timeframe_480, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2928 = iMACD(MarketSymbol, g_timeframe_480, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2920 >= l_imacd_2928) {
      ld_248 = 2;
      ld_712 = 0;
   }
   if (l_imacd_2920 < l_imacd_2928) {
      ld_248 = 0;
      ld_712 = 2;
   }
   double l_imacd_2936 = iMACD(MarketSymbol, g_timeframe_468, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2944 = iMACD(MarketSymbol, g_timeframe_468, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2936 >= l_imacd_2944) {
      ld_256 = 3;
      ld_720 = 0;
   }
   if (l_imacd_2936 < l_imacd_2944) {
      ld_256 = 0;
      ld_720 = 3;
   }
   double l_imacd_2952 = iMACD(MarketSymbol, g_timeframe_472, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2960 = iMACD(MarketSymbol, g_timeframe_472, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2952 >= l_imacd_2960) {
      ld_264 = 2;
      ld_728 = 0;
   }
   if (l_imacd_2952 < l_imacd_2960) {
      ld_264 = 0;
      ld_728 = 2;
   }
   double l_imacd_2968 = iMACD(MarketSymbol, g_timeframe_476, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_MAIN, 0);
   double l_imacd_2976 = iMACD(MarketSymbol, g_timeframe_476, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, MODE_SIGNAL, 0);
   if (l_imacd_2968 >= l_imacd_2976) {
      ld_272 = 2;
      ld_736 = 0;
   }
   if (l_imacd_2968 < l_imacd_2976) {
      ld_272 = 0;
      ld_736 = 2;
   }
   double l_iadx_2984 = iADX(MarketSymbol, g_timeframe_492, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_2992 = iADX(MarketSymbol, g_timeframe_492, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_2984 >= l_iadx_2992) {
      ld_280 = 1;
      ld_744 = 0;
   }
   if (l_iadx_2984 < l_iadx_2992) {
      ld_280 = 0;
      ld_744 = 1;
   }
   double l_iadx_3000 = iADX(MarketSymbol, g_timeframe_488, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_3008 = iADX(MarketSymbol, g_timeframe_488, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_3000 >= l_iadx_3008) {
      ld_288 = 1;
      ld_752 = 0;
   }
   if (l_iadx_3000 < l_iadx_3008) {
      ld_288 = 0;
      ld_752 = 1;
   }
   double l_iadx_3016 = iADX(MarketSymbol, g_timeframe_484, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_3024 = iADX(MarketSymbol, g_timeframe_484, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_3016 >= l_iadx_3024) {
      ld_296 = 1;
      ld_760 = 0;
   }
   if (l_iadx_3016 < l_iadx_3024) {
      ld_296 = 0;
      ld_760 = 1;
   }
   double l_iadx_3032 = iADX(MarketSymbol, g_timeframe_480, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_3040 = iADX(MarketSymbol, g_timeframe_480, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_3032 >= l_iadx_3040) {
      ld_304 = 2;
      ld_768 = 0;
   }
   if (l_iadx_3032 < l_iadx_3040) {
      ld_304 = 0;
      ld_768 = 2;
   }
   double l_iadx_3048 = iADX(MarketSymbol, g_timeframe_468, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_3056 = iADX(MarketSymbol, g_timeframe_468, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_3048 >= l_iadx_3056) {
      ld_312 = 3;
      ld_776 = 0;
   }
   if (l_iadx_3048 < l_iadx_3056) {
      ld_312 = 0;
      ld_776 = 3;
   }
   double l_iadx_3064 = iADX(MarketSymbol, g_timeframe_472, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_3072 = iADX(MarketSymbol, g_timeframe_472, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_3064 >= l_iadx_3072) {
      ld_320 = 2;
      ld_784 = 0;
   }
   if (l_iadx_3064 < l_iadx_3072) {
      ld_320 = 0;
      ld_784 = 2;
   }
   double l_iadx_3080 = iADX(MarketSymbol, g_timeframe_476, g_period_340, g_applied_price_344, MODE_PLUSDI, 0);
   double l_iadx_3088 = iADX(MarketSymbol, g_timeframe_476, g_period_340, g_applied_price_344, MODE_MINUSDI, 0);
   if (l_iadx_3080 >= l_iadx_3088) {
      ld_328 = 2;
      ld_792 = 0;
   }
   if (l_iadx_3080 < l_iadx_3088) {
      ld_328 = 0;
      ld_792 = 2;
   }
   double l_ibullspower_3096 = iBullsPower(MarketSymbol, g_timeframe_492, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3096 >= 0.0) {
      ld_336 = 1;
      ld_800 = 0;
   }
   if (l_ibullspower_3096 < 0.0) {
      ld_336 = 0;
      ld_800 = 1;
   }
   double l_ibullspower_3104 = iBullsPower(MarketSymbol, g_timeframe_488, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3104 >= 0.0) {
      ld_344 = 1;
      ld_808 = 0;
   }
   if (l_ibullspower_3104 < 0.0) {
      ld_344 = 0;
      ld_808 = 1;
   }
   double l_ibullspower_3112 = iBullsPower(MarketSymbol, g_timeframe_484, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3112 >= 0.0) {
      ld_352 = 1;
      ld_816 = 0;
   }
   if (l_ibullspower_3112 < 0.0) {
      ld_352 = 0;
      ld_816 = 1;
   }
   double l_ibullspower_3120 = iBullsPower(MarketSymbol, g_timeframe_480, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3120 >= 0.0) {
      ld_360 = 2;
      ld_824 = 0;
   }
   if (l_ibullspower_3120 < 0.0) {
      ld_360 = 0;
      ld_824 = 2;
   }
   double l_ibullspower_3128 = iBullsPower(MarketSymbol, g_timeframe_468, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3128 >= 0.0) {
      ld_368 = 3;
      ld_832 = 0;
   }
   if (l_ibullspower_3128 < 0.0) {
      ld_368 = 0;
      ld_832 = 3;
   }
   double l_ibullspower_3136 = iBullsPower(MarketSymbol, g_timeframe_472, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3136 >= 0.0) {
      ld_376 = 2;
      ld_840 = 0;
   }
   if (l_ibullspower_3136 < 0.0) {
      ld_376 = 0;
      ld_840 = 2;
   }
   double l_ibullspower_3144 = iBullsPower(MarketSymbol, g_timeframe_476, g_period_356, g_applied_price_360, 0);
   if (l_ibullspower_3144 >= 0.0) {
      ld_392 = 2;
      ld_848 = 0;
   }
   if (l_ibullspower_3144 < 0.0) {
      ld_392 = 0;
      ld_848 = 2;
   }
   double l_ibearspower_3152 = iBearsPower(MarketSymbol, g_timeframe_492, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3152 > 0.0) {
      ld_400 = 1;
      ld_856 = 0;
   }
   if (l_ibearspower_3152 <= 0.0) {
      ld_400 = 0;
      ld_856 = 1;
   }
   double l_ibearspower_3160 = iBearsPower(MarketSymbol, g_timeframe_488, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3160 > 0.0) {
      ld_408 = 1;
      ld_864 = 0;
   }
   if (l_ibearspower_3160 <= 0.0) {
      ld_408 = 0;
      ld_864 = 1;
   }
   double l_ibearspower_3168 = iBearsPower(MarketSymbol, g_timeframe_484, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3168 > 0.0) {
      ld_416 = 1;
      ld_872 = 0;
   }
   if (l_ibearspower_3168 <= 0.0) {
      ld_416 = 0;
      ld_872 = 1;
   }
   double l_ibearspower_3176 = iBearsPower(MarketSymbol, g_timeframe_480, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3176 > 0.0) {
      ld_432 = 2;
      ld_880 = 0;
   }
   if (l_ibearspower_3176 <= 0.0) {
      ld_432 = 0;
      ld_880 = 2;
   }
   double l_ibearspower_3184 = iBearsPower(MarketSymbol, g_timeframe_468, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3184 > 0.0) {
      ld_440 = 3;
      ld_888 = 0;
   }
   if (l_ibearspower_3184 <= 0.0) {
      ld_440 = 0;
      ld_888 = 3;
   }
   double l_ibearspower_3192 = iBearsPower(MarketSymbol, g_timeframe_472, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3192 > 0.0) {
      ld_448 = 2;
      ld_896 = 0;
   }
   if (l_ibearspower_3192 <= 0.0) {
      ld_448 = 0;
      ld_896 = 2;
   }
   double l_ibearspower_3200 = iBearsPower(MarketSymbol, g_timeframe_476, g_period_372, g_applied_price_376, 0);
   if (l_ibearspower_3200 > 0.0) {
      ld_456 = 2;
      ld_904 = 0;
   }
   if (l_ibearspower_3200 <= 0.0) {
      ld_456 = 0;
      ld_904 = 2;
   }
   double l_istochastic_3208 = iStochastic(MarketSymbol, g_timeframe_492, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3216 = iStochastic(MarketSymbol, g_timeframe_492, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3208 >= l_istochastic_3216) {
      ld_912 = 1;
      ld_1192 = 0;
   }
   if (l_istochastic_3208 < l_istochastic_3216) {
      ld_912 = 0;
      ld_1192 = 1;
   }
   double l_istochastic_3224 = iStochastic(MarketSymbol, g_timeframe_488, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3232 = iStochastic(MarketSymbol, g_timeframe_488, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3224 >= l_istochastic_3232) {
      ld_920 = 1;
      ld_1200 = 0;
   }
   if (l_istochastic_3224 < l_istochastic_3232) {
      ld_920 = 0;
      ld_1200 = 1;
   }
   double l_istochastic_3240 = iStochastic(MarketSymbol, g_timeframe_484, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3248 = iStochastic(MarketSymbol, g_timeframe_484, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3240 >= l_istochastic_3248) {
      ld_928 = 1;
      ld_1208 = 0;
   }
   if (l_istochastic_3240 < l_istochastic_3248) {
      ld_928 = 0;
      ld_1208 = 1;
   }
   double l_istochastic_3256 = iStochastic(MarketSymbol, g_timeframe_480, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3264 = iStochastic(MarketSymbol, g_timeframe_480, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3256 >= l_istochastic_3264) {
      ld_936 = 2;
      ld_1216 = 0;
   }
   if (l_istochastic_3256 < l_istochastic_3264) {
      ld_936 = 0;
      ld_1216 = 2;
   }
   double l_istochastic_3272 = iStochastic(MarketSymbol, g_timeframe_468, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3280 = iStochastic(MarketSymbol, g_timeframe_468, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3272 >= l_istochastic_3280) {
      ld_944 = 3;
      ld_1224 = 0;
   }
   if (l_istochastic_3272 < l_istochastic_3280) {
      ld_944 = 0;
      ld_1224 = 3;
   }
   double l_istochastic_3288 = iStochastic(MarketSymbol, g_timeframe_472, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3296 = iStochastic(MarketSymbol, g_timeframe_472, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3288 >= l_istochastic_3296) {
      ld_952 = 2;
      ld_1232 = 0;
   }
   if (l_istochastic_3288 < l_istochastic_3296) {
      ld_952 = 0;
      ld_1232 = 2;
   }
   double l_istochastic_3304 = iStochastic(MarketSymbol, g_timeframe_476, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_MAIN, 0);
   double l_istochastic_3312 = iStochastic(MarketSymbol, g_timeframe_476, g_period_388, g_period_392, g_slowing_396, MODE_SMA, 1, MODE_SIGNAL, 0);
   if (l_istochastic_3304 >= l_istochastic_3312) {
      ld_960 = 2;
      ld_1240 = 0;
   }
   if (l_istochastic_3304 < l_istochastic_3312) {
      ld_960 = 0;
      ld_1240 = 2;
   }
   double l_irsi_3320 = iRSI(MarketSymbol, g_timeframe_492, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3320 >= 50.0) {
      ld_968 = 1;
      ld_1248 = 0;
   }
   if (l_irsi_3320 < 50.0) {
      ld_968 = 0;
      ld_1248 = 1;
   }
   double l_irsi_3328 = iRSI(MarketSymbol, g_timeframe_488, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3328 >= 50.0) {
      ld_976 = 1;
      ld_1256 = 0;
   }
   if (l_irsi_3328 < 50.0) {
      ld_976 = 0;
      ld_1256 = 1;
   }
   double l_irsi_3336 = iRSI(MarketSymbol, g_timeframe_484, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3336 >= 50.0) {
      ld_984 = 1;
      ld_1264 = 0;
   }
   if (l_irsi_3336 < 50.0) {
      ld_984 = 0;
      ld_1264 = 1;
   }
   double l_irsi_3344 = iRSI(MarketSymbol, g_timeframe_480, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3344 >= 50.0) {
      ld_992 = 2;
      ld_1272 = 0;
   }
   if (l_irsi_3344 < 50.0) {
      ld_992 = 0;
      ld_1272 = 2;
   }
   double l_irsi_3352 = iRSI(MarketSymbol, g_timeframe_468, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3352 >= 50.0) {
      ld_1000 = 3;
      ld_1280 = 0;
   }
   if (l_irsi_3352 < 50.0) {
      ld_1000 = 0;
      ld_1280 = 3;
   }
   double l_irsi_3360 = iRSI(MarketSymbol, g_timeframe_472, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3360 >= 50.0) {
      ld_1008 = 2;
      ld_1288 = 0;
   }
   if (l_irsi_3360 < 50.0) {
      ld_1008 = 0;
      ld_1288 = 2;
   }
   double l_irsi_3368 = iRSI(MarketSymbol, g_timeframe_476, g_period_408, PRICE_CLOSE, 0);
   if (l_irsi_3368 >= 50.0) {
      ld_1016 = 2;
      ld_1296 = 0;
   }
   if (l_irsi_3368 < 50.0) {
      ld_1016 = 0;
      ld_1296 = 2;
   }
   double l_iobv_3824 = iOBV(MarketSymbol, g_timeframe_492, PRICE_CLOSE, 0);
   double l_iobv_3880 = iOBV(MarketSymbol, g_timeframe_492, PRICE_CLOSE, 20);
   if (l_iobv_3824 > l_iobv_3880) {
      ld_1808 = 1;
      ld_1864 = 0;
   }
   if (l_iobv_3824 <= l_iobv_3880) {
      ld_1808 = 0;
      ld_1864 = 1;
   }
   double l_iobv_3832 = iOBV(MarketSymbol, g_timeframe_488, PRICE_CLOSE, 0);
   double l_iobv_3888 = iOBV(MarketSymbol, g_timeframe_488, PRICE_CLOSE, 20);
   if (l_iobv_3832 > l_iobv_3888) {
      ld_1816 = 1;
      ld_1872 = 0;
   }
   if (l_iobv_3832 <= l_iobv_3888) {
      ld_1816 = 0;
      ld_1872 = 1;
   }
   double l_iobv_3840 = iOBV(MarketSymbol, g_timeframe_484, PRICE_CLOSE, 0);
   double l_iobv_3896 = iOBV(MarketSymbol, g_timeframe_484, PRICE_CLOSE, 20);
   if (l_iobv_3840 > l_iobv_3896) {
      ld_1824 = 1;
      ld_1880 = 0;
   }
   if (l_iobv_3840 <= l_iobv_3896) {
      ld_1824 = 0;
      ld_1880 = 1;
   }
   double l_iobv_3848 = iOBV(MarketSymbol, g_timeframe_480, PRICE_CLOSE, 0);
   double l_iobv_3904 = iOBV(MarketSymbol, g_timeframe_480, PRICE_CLOSE, 20);
   if (l_iobv_3848 > l_iobv_3904) {
      ld_1832 = 2;
      ld_1888 = 0;
   }
   if (l_iobv_3848 <= l_iobv_3904) {
      ld_1832 = 0;
      ld_1888 = 2;
   }
   double l_iobv_3856 = iOBV(MarketSymbol, g_timeframe_468, PRICE_CLOSE, 0);
   double l_iobv_3912 = iOBV(MarketSymbol, g_timeframe_468, PRICE_CLOSE, 20);
   if (l_iobv_3856 > l_iobv_3912) {
      ld_1840 = 3;
      ld_1896 = 0;
   }
   if (l_iobv_3856 <= l_iobv_3912) {
      ld_1840 = 0;
      ld_1896 = 3;
   }
   double l_iobv_3864 = iOBV(MarketSymbol, g_timeframe_472, PRICE_CLOSE, 0);
   double l_iobv_3920 = iOBV(MarketSymbol, g_timeframe_472, PRICE_CLOSE, 20);
   if (l_iobv_3864 > l_iobv_3920) {
      ld_1848 = 2;
      ld_1904 = 0;
   }
   if (l_iobv_3864 <= l_iobv_3920) {
      ld_1848 = 0;
      ld_1904 = 2;
   }
   double l_iobv_3872 = iOBV(MarketSymbol, g_timeframe_476, PRICE_CLOSE, 0);
   double l_iobv_3928 = iOBV(MarketSymbol, g_timeframe_476, PRICE_CLOSE, 20);
   if (l_iobv_3872 > l_iobv_3928) {
      ld_1856 = 2;
      ld_1912 = 0;
   }
   if (l_iobv_3872 <= l_iobv_3928) {
      ld_1856 = 0;
      ld_1912 = 2;
   }
   double l_iforce_3376 = iForce(MarketSymbol, g_timeframe_492, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3376 >= 0.0) {
      ld_1024 = 1;
      ld_1304 = 0;
   }
   if (l_iforce_3376 < 0.0) {
      ld_1024 = 0;
      ld_1304 = 1;
   }
   double l_iforce_3384 = iForce(MarketSymbol, g_timeframe_488, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3384 >= 0.0) {
      ld_1032 = 1;
      ld_1312 = 0;
   }
   if (l_iforce_3384 < 0.0) {
      ld_1032 = 0;
      ld_1312 = 1;
   }
   double l_iforce_3392 = iForce(MarketSymbol, g_timeframe_484, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3392 >= 0.0) {
      ld_1040 = 1;
      ld_1320 = 0;
   }
   if (l_iforce_3392 < 0.0) {
      ld_1040 = 0;
      ld_1320 = 1;
   }
   double l_iforce_3400 = iForce(MarketSymbol, g_timeframe_480, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3400 >= 0.0) {
      ld_1048 = 2;
      ld_1328 = 0;
   }
   if (l_iforce_3400 < 0.0) {
      ld_1048 = 0;
      ld_1328 = 2;
   }
   double l_iforce_3408 = iForce(MarketSymbol, g_timeframe_468, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3408 >= 0.0) {
      ld_1056 = 3;
      ld_1336 = 0;
   }
   if (l_iforce_3408 < 0.0) {
      ld_1056 = 0;
      ld_1336 = 3;
   }
   double l_iforce_3416 = iForce(MarketSymbol, g_timeframe_472, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3416 >= 0.0) {
      ld_1064 = 2;
      ld_1344 = 0;
   }
   if (l_iforce_3416 < 0.0) {
      ld_1064 = 0;
      ld_1344 = 2;
   }
   double l_iforce_3424 = iForce(MarketSymbol, g_timeframe_476, g_period_420, g_ma_method_424, g_applied_price_428, 0);
   if (l_iforce_3424 >= 0.0) {
      ld_1072 = 2;
      ld_1352 = 0;
   }
   if (l_iforce_3424 < 0.0) {
      ld_1072 = 0;
      ld_1352 = 2;
   }
   double l_imomentum_3432 = iMomentum(MarketSymbol, g_timeframe_492, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3432 >= 100.0) {
      ld_1080 = 1;
      ld_1360 = 0;
   }
   if (l_imomentum_3432 < 100.0) {
      ld_1080 = 0;
      ld_1360 = 1;
   }
   double l_imomentum_3440 = iMomentum(MarketSymbol, g_timeframe_488, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3440 >= 100.0) {
      ld_1088 = 1;
      ld_1368 = 0;
   }
   if (l_imomentum_3440 < 100.0) {
      ld_1088 = 0;
      ld_1368 = 1;
   }
   double l_imomentum_3448 = iMomentum(MarketSymbol, g_timeframe_484, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3448 >= 100.0) {
      ld_1096 = 1;
      ld_1376 = 0;
   }
   if (l_imomentum_3448 < 100.0) {
      ld_1096 = 0;
      ld_1376 = 1;
   }
   double l_imomentum_3456 = iMomentum(MarketSymbol, g_timeframe_480, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3456 >= 100.0) {
      ld_1104 = 2;
      ld_1384 = 0;
   }
   if (l_imomentum_3456 < 100.0) {
      ld_1104 = 0;
      ld_1384 = 2;
   }
   double l_imomentum_3464 = iMomentum(MarketSymbol, g_timeframe_468, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3464 >= 100.0) {
      ld_1112 = 3;
      ld_1392 = 0;
   }
   if (l_imomentum_3464 < 100.0) {
      ld_1112 = 0;
      ld_1392 = 3;
   }
   double l_imomentum_3472 = iMomentum(MarketSymbol, g_timeframe_472, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3472 >= 100.0) {
      ld_1120 = 2;
      ld_1400 = 0;
   }
   if (l_imomentum_3472 < 100.0) {
      ld_1120 = 0;
      ld_1400 = 2;
   }
   double l_imomentum_3480 = iMomentum(MarketSymbol, g_timeframe_476, g_period_440, g_applied_price_444, 0);
   if (l_imomentum_3480 >= 100.0) {
      ld_1128 = 2;
      ld_1408 = 0;
   }
   if (l_imomentum_3480 < 100.0) {
      ld_1128 = 0;
      ld_1408 = 2;
   }
   double l_idemarker_3488 = iDeMarker(MarketSymbol, g_timeframe_492, g_period_456, 0);
   if (l_idemarker_3488 >= 0.5) {
      ld_1136 = 1;
      ld_1416 = 0;
   }
   if (l_idemarker_3488 < 0.5) {
      ld_1136 = 0;
      ld_1416 = 1;
   }
   double l_idemarker_3504 = iDeMarker(MarketSymbol, g_timeframe_488, g_period_456, 0);
   if (l_idemarker_3504 >= 0.5) {
      ld_1144 = 1;
      ld_1424 = 0;
   }
   if (l_idemarker_3504 < 0.5) {
      ld_1144 = 0;
      ld_1424 = 1;
   }
   double l_idemarker_3520 = iDeMarker(MarketSymbol, g_timeframe_484, g_period_456, 0);
   if (l_idemarker_3520 >= 0.5) {
      ld_1152 = 1;
      ld_1432 = 0;
   }
   if (l_idemarker_3520 < 0.5) {
      ld_1152 = 0;
      ld_1432 = 1;
   }
   double l_idemarker_3536 = iDeMarker(MarketSymbol, g_timeframe_480, g_period_456, 0);
   if (l_idemarker_3536 >= 0.5) {
      ld_1160 = 2;
      ld_1440 = 0;
   }
   if (l_idemarker_3536 < 0.5) {
      ld_1160 = 0;
      ld_1440 = 2;
   }
   double l_idemarker_3552 = iDeMarker(MarketSymbol, g_timeframe_468, g_period_456, 0);
   if (l_idemarker_3552 >= 0.5) {
      ld_1168 = 3;
      ld_1448 = 0;
   }
   if (l_idemarker_3552 < 0.5) {
      ld_1168 = 0;
      ld_1448 = 3;
   }
   double l_idemarker_3568 = iDeMarker(MarketSymbol, g_timeframe_472, g_period_456, 0);
   if (l_idemarker_3568 >= 0.5) {
      ld_1176 = 2;
      ld_1456 = 0;
   }
   if (l_idemarker_3568 < 0.5) {
      ld_1176 = 0;
      ld_1456 = 2;
   }
   double l_idemarker_3584 = iDeMarker(MarketSymbol, g_timeframe_476, g_period_456, 0);
   if (l_idemarker_3584 >= 0.5) {
      ld_1184 = 2;
      ld_1464 = 0;
   }
   if (l_idemarker_3584 < 0.5) {
      ld_1184 = 0;
      ld_1464 = 2;
   }
   double l_iac_3600 = iAC(MarketSymbol, g_timeframe_492, 0);
   if (l_iac_3600 >= 0.0) {
      ld_2144 = 1;
      ld_2200 = 0;
   }
   if (l_iac_3600 < 0.0) {
      ld_2144 = 0;
      ld_2200 = 1;
   }
   double l_iac_3608 = iAC(MarketSymbol, g_timeframe_488, 0);
   if (l_iac_3608 >= 0.0) {
      ld_2152 = 1;
      ld_2208 = 0;
   }
   if (l_iac_3608 < 0.0) {
      ld_2152 = 0;
      ld_2208 = 1;
   }
   double l_iac_3616 = iAC(MarketSymbol, g_timeframe_484, 0);
   if (l_iac_3616 >= 0.0) {
      ld_2160 = 1;
      ld_2216 = 0;
   }
   if (l_iac_3616 < 0.0) {
      ld_2160 = 0;
      ld_2216 = 1;
   }
   double l_iac_3624 = iAC(MarketSymbol, g_timeframe_480, 0);
   if (l_iac_3624 >= 0.0) {
      ld_2168 = 2;
      ld_2224 = 0;
   }
   if (l_iac_3624 < 0.0) {
      ld_2168 = 0;
      ld_2224 = 2;
   }
   double l_iac_3632 = iAC(MarketSymbol, g_timeframe_468, 0);
   if (l_iac_3632 >= 0.0) {
      ld_2176 = 3;
      ld_2232 = 0;
   }
   if (l_iac_3632 < 0.0) {
      ld_2176 = 0;
      ld_2232 = 3;
   }
   double l_iac_3640 = iAC(MarketSymbol, g_timeframe_472, 0);
   if (l_iac_3640 >= 0.0) {
      ld_2184 = 2;
      ld_2240 = 0;
   }
   if (l_iac_3640 < 0.0) {
      ld_2184 = 0;
      ld_2240 = 2;
   }
   double l_iac_3648 = iAC(MarketSymbol, g_timeframe_476, 0);
   if (l_iac_3648 >= 0.0) {
      ld_2192 = 2;
      ld_2248 = 0;
   }
   if (l_iac_3648 < 0.0) {
      ld_2192 = 0;
      ld_2248 = 2;
   }
   double l_iwpr_3656 = iWPR(MarketSymbol, g_timeframe_492, 42, 0);
   if (l_iwpr_3656 >= -50.0) {
      ld_2032 = 1;
      ld_2088 = 0;
   }
   if (l_iwpr_3656 < -50.0) {
      ld_2032 = 0;
      ld_2088 = 1;
   }
   double l_iwpr_3664 = iWPR(MarketSymbol, g_timeframe_488, 42, 0);
   if (l_iwpr_3664 >= -50.0) {
      ld_2040 = 1;
      ld_2088 = 0;
   }
   if (l_iwpr_3664 < -50.0) {
      ld_2040 = 0;
      ld_2088 = 1;
   }
   double l_iwpr_3672 = iWPR(MarketSymbol, g_timeframe_484, 42, 0);
   if (l_iwpr_3672 >= -50.0) {
      ld_2048 = 1;
      ld_2096 = 0;
   }
   if (l_iwpr_3672 < -50.0) {
      ld_2048 = 0;
      ld_2096 = 1;
   }
   double l_iwpr_3680 = iWPR(MarketSymbol, g_timeframe_480, 42, 0);
   if (l_iwpr_3680 >= -50.0) {
      ld_2056 = 2;
      ld_2104 = 0;
   }
   if (l_iwpr_3680 < -50.0) {
      ld_2056 = 0;
      ld_2104 = 2;
   }
   double l_iwpr_3688 = iWPR(MarketSymbol, g_timeframe_468, 42, 0);
   if (l_iwpr_3688 >= -50.0) {
      ld_2064 = 3;
      ld_2112 = 0;
   }
   if (l_iwpr_3688 < -50.0) {
      ld_2064 = 0;
      ld_2112 = 3;
   }
   double l_iwpr_3696 = iWPR(MarketSymbol, g_timeframe_472, 42, 0);
   if (l_iwpr_3696 >= -50.0) {
      ld_2072 = 2;
      ld_2128 = 0;
   }
   if (l_iwpr_3696 < -50.0) {
      ld_2072 = 0;
      ld_2128 = 2;
   }
   double l_iwpr_3704 = iWPR(MarketSymbol, g_timeframe_476, 42, 0);
   if (l_iwpr_3704 >= -50.0) {
      ld_2080 = 2;
      ld_2136 = 0;
   }
   if (l_iwpr_3704 < -50.0) {
      ld_2080 = 0;
      ld_2136 = 2;
   }
   double l_iosma_3768 = iOsMA(MarketSymbol, g_timeframe_492, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3768 >= 0.0) {
      ld_1920 = 1;
      ld_1976 = 0;
   }
   if (l_iosma_3768 < 0.0) {
      ld_1920 = 0;
      ld_1976 = 1;
   }
   double l_iosma_3776 = iOsMA(MarketSymbol, g_timeframe_488, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3776 >= 0.0) {
      ld_1928 = 1;
      ld_1984 = 0;
   }
   if (l_iosma_3776 < 0.0) {
      ld_1928 = 0;
      ld_1984 = 1;
   }
   double l_iosma_3784 = iOsMA(MarketSymbol, g_timeframe_484, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3784 >= 0.0) {
      ld_1936 = 1;
      ld_1992 = 0;
   }
   if (l_iosma_3784 < 0.0) {
      ld_1936 = 0;
      ld_1992 = 1;
   }
   double l_iosma_3792 = iOsMA(MarketSymbol, g_timeframe_480, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3792 >= 0.0) {
      ld_1944 = 2;
      ld_2000 = 0;
   }
   if (l_iosma_3792 < 0.0) {
      ld_1944 = 0;
      ld_2000 = 2;
   }
   double l_iosma_3800 = iOsMA(MarketSymbol, g_timeframe_468, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3800 >= 0.0) {
      ld_1952 = 3;
      ld_2008 = 0;
   }
   if (l_iosma_3800 < 0.0) {
      ld_1952 = 0;
      ld_2008 = 3;
   }
   double l_iosma_3808 = iOsMA(MarketSymbol, g_timeframe_472, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3808 >= 0.0) {
      ld_1960 = 2;
      ld_2016 = 0;
   }
   if (l_iosma_3808 < 0.0) {
      ld_1960 = 0;
      ld_2016 = 2;
   }
   double l_iosma_3816 = iOsMA(MarketSymbol, g_timeframe_476, g_period_320, g_period_324, g_period_328, PRICE_CLOSE, 0);
   if (l_iosma_3816 >= 0.0) {
      ld_1968 = 2;
      ld_2024 = 0;
   }
   if (l_iosma_3816 < 0.0) {
      ld_1968 = 0;
      ld_2024 = 2;
   }
   double l_isar_3936 = iSAR(MarketSymbol, g_timeframe_492, 0.02, 0.2, 0);
   if (l_isar_3936 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1696 = 1;
      ld_1752 = 0;
   }
   if (l_isar_3936 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1696 = 0;
      ld_1752 = 1;
   }
   double l_isar_3944 = iSAR(MarketSymbol, g_timeframe_488, 0.02, 0.2, 0);
   if (l_isar_3944 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1704 = 1;
      ld_1760 = 0;
   }
   if (l_isar_3944 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1704 = 0;
      ld_1760 = 1;
   }
   double l_isar_3952 = iSAR(MarketSymbol, g_timeframe_484, 0.02, 0.2, 0);
   if (l_isar_3952 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1712 = 1;
      ld_1768 = 0;
   }
   if (l_isar_3952 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1712 = 0;
      ld_1768 = 1;
   }
   double l_isar_3960 = iSAR(MarketSymbol, g_timeframe_480, 0.02, 0.2, 0);
   if (l_isar_3960 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1720 = 2;
      ld_1776 = 0;
   }
   if (l_isar_3960 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1720 = 0;
      ld_1776 = 2;
   }
   double l_isar_3968 = iSAR(MarketSymbol, g_timeframe_468, 0.02, 0.2, 0);
   if (l_isar_3968 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1728 = 3;
      ld_1784 = 0;
   }
   if (l_isar_3968 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1728 = 0;
      ld_1784 = 3;
   }
   double l_isar_3976 = iSAR(MarketSymbol, g_timeframe_472, 0.02, 0.2, 0);
   if (l_isar_3976 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1736 = 2;
      ld_1792 = 0;
   }
   if (l_isar_3976 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1736 = 0;
      ld_1792 = 2;
   }
   double l_isar_3984 = iSAR(MarketSymbol, g_timeframe_476, 0.02, 0.2, 0);
   if (l_isar_3984 < MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1744 = 2;
      ld_1800 = 0;
   }
   if (l_isar_3984 >= MarketInfo(MarketSymbol, MODE_BID)) {
      ld_1744 = 0;
      ld_1800 = 2;
   }
   double ld_4056 = ld_0 + ld_56 + ld_112 + ld_168 + ld_224 + ld_280 + ld_336 + ld_400 + ld_912 + ld_968 + ld_1024 + ld_1080 + ld_1136 + ld_1808 + ld_1920 + ld_2032 +
      ld_2144 + ld_1696 + ld_1472 + ld_1584;
   double ld_4064 = ld_8 + ld_64 + ld_120 + ld_176 + ld_232 + ld_288 + ld_344 + ld_408 + ld_920 + ld_976 + ld_1032 + ld_1088 + ld_1144 + ld_1816 + ld_1928 + ld_2040 +
      ld_2152 + ld_1704 + ld_1480 + ld_1592;
   double ld_4072 = ld_16 + ld_72 + ld_128 + ld_184 + ld_240 + ld_296 + ld_352 + ld_416 + ld_928 + ld_984 + ld_1040 + ld_1096 + ld_1152 + ld_1824 + ld_1936 + ld_2048 +
      ld_2160 + ld_1712 + ld_1488 + ld_1600;
   double ld_4080 = ld_24 + ld_80 + ld_136 + ld_192 + ld_248 + ld_304 + ld_360 + ld_432 + ld_936 + ld_992 + ld_1048 + ld_1104 + ld_1160 + ld_1832 + ld_1944 + ld_2056 +
      ld_2168 + ld_1720 + ld_1496 + ld_1608;
   double ld_4088 = ld_32 + ld_88 + ld_144 + ld_200 + ld_256 + ld_312 + ld_368 + ld_440 + ld_944 + ld_1000 + ld_1056 + ld_1112 + ld_1168 + ld_1840 + ld_1952 + ld_2064 +
      ld_2176 + ld_1728 + ld_1504 + ld_1616;
   double ld_4096 = ld_40 + ld_96 + ld_152 + ld_208 + ld_264 + ld_320 + ld_376 + ld_448 + ld_952 + ld_1008 + ld_1064 + ld_1120 + ld_1176 + ld_1848 + ld_1960 + ld_2072 +
      ld_2184 + ld_1736 + ld_1512 + ld_1624;
   double ld_4104 = ld_48 + ld_104 + ld_160 + ld_216 + ld_272 + ld_328 + ld_392 + ld_456 + ld_960 + ld_1016 + ld_1072 + ld_1128 + ld_1184 + ld_1856 + ld_1968 + ld_2080 +
      ld_2192 + ld_1744 + ld_1520 + ld_1632;
   double ld_4112 = ld_4056 + ld_4064 + ld_4072 + ld_4080 + ld_4088 + ld_4096 + ld_4104;
   double ld_4120 = ld_464 + ld_520 + ld_576 + ld_632 + ld_688 + ld_744 + ld_800 + ld_856 + ld_1192 + ld_1248 + ld_1304 + ld_1360 + ld_1416 + ld_1864 + ld_1976 + ld_2088 +
      ld_2200 + ld_1752 + ld_1528 + ld_1640;
   double ld_4128 = ld_472 + ld_528 + ld_584 + ld_640 + ld_696 + ld_752 + ld_808 + ld_864 + ld_1200 + ld_1256 + ld_1312 + ld_1368 + ld_1424 + ld_1872 + ld_1984 + ld_2096 +
      ld_2208 + ld_1760 + ld_1536 + ld_1648;
   double ld_4136 = ld_480 + ld_536 + ld_592 + ld_648 + ld_704 + ld_760 + ld_816 + ld_872 + ld_1208 + ld_1264 + ld_1320 + ld_1376 + ld_1432 + ld_1880 + ld_1992 + ld_2104 +
      ld_2216 + ld_1768 + ld_1544 + ld_1656;
   double ld_4144 = ld_488 + ld_544 + ld_600 + ld_656 + ld_712 + ld_768 + ld_824 + ld_880 + ld_1216 + ld_1272 + ld_1328 + ld_1384 + ld_1440 + ld_1888 + ld_2000 + ld_2112 +
      ld_2224 + ld_1776 + ld_1552 + ld_1664;
   double ld_4152 = ld_496 + ld_552 + ld_608 + ld_664 + ld_720 + ld_776 + ld_832 + ld_888 + ld_1224 + ld_1280 + ld_1336 + ld_1392 + ld_1448 + ld_1896 + ld_2008 + ld_2120 +
      ld_2232 + ld_1784 + ld_1560 + ld_1672;
   double ld_4160 = ld_504 + ld_560 + ld_616 + ld_672 + ld_728 + ld_784 + ld_840 + ld_896 + ld_1232 + ld_1288 + ld_1344 + ld_1400 + ld_1456 + ld_1904 + ld_2016 + ld_2128 +
      ld_2240 + ld_1792 + ld_1568 + ld_1680;
   double ld_4168 = ld_512 + ld_568 + ld_624 + ld_680 + ld_736 + ld_792 + ld_848 + ld_904 + ld_1240 + ld_1296 + ld_1352 + ld_1408 + ld_1464 + ld_1912 + ld_2024 + ld_2136 +
      ld_2248 + ld_1800 + ld_1576 + ld_1688;
   double ld_4176 = ld_4120 + ld_4128 + ld_4136 + ld_4144 + ld_4152 + ld_4160 + ld_4168;
   double ld_4184 = NormalizeDouble(100.0 * (ld_4112 / 241.0), 0);
   double ld_4192 = NormalizeDouble(100.0 * (ld_4176 / 241.0), 0);
   if (ld_4184 < 51.0 || ld_4192 < 51.0) gi_940 = 0;
   if (ld_4184 >= 51.0) gi_940 = 1;
   if (ld_4184 >= 52.0) gi_940 = 2;
   if (ld_4184 >= 53.0) gi_940 = 3;
   if (ld_4184 >= 54.0) gi_940 = 4;
   if (ld_4184 >= 55.0) gi_940 = 5;
   if (ld_4184 >= 56.0) gi_940 = 6;
   if (ld_4184 >= 57.0) gi_940 = 7;
   if (ld_4184 >= 58.0) gi_940 = 8;
   if (ld_4184 >= 59.0) gi_940 = 9;
   if (ld_4184 >= 60.0) gi_940 = 10;
   if (ld_4184 >= 61.0) gi_940 = 11;
   if (ld_4184 >= 62.0) gi_940 = 12;
   if (ld_4184 >= 63.0) gi_940 = 13;
   if (ld_4184 >= 64.0) gi_940 = 14;
   if (ld_4184 >= 65.0) gi_940 = 15;
   if (ld_4184 >= 66.0) gi_940 = 16;
   if (ld_4184 >= 67.0) gi_940 = 17;
   if (ld_4184 >= 68.0) gi_940 = 18;
   if (ld_4184 >= 69.0) gi_940 = 19;
   if (ld_4184 >= 70.0) gi_940 = 20;
   if (ld_4184 >= 71.0) gi_940 = 21;
   if (ld_4184 >= 72.0) gi_940 = 22;
   if (ld_4184 >= 73.0) gi_940 = 23;
   if (ld_4184 >= 74.0) gi_940 = 24;
   if (ld_4184 >= 75.0) gi_940 = 25;
   if (ld_4184 >= 76.0) gi_940 = 26;
   if (ld_4184 >= 77.0) gi_940 = 27;
   if (ld_4184 >= 78.0) gi_940 = 28;
   if (ld_4184 >= 79.0) gi_940 = 29;
   if (ld_4184 >= 80.0) gi_940 = 30;
   if (ld_4184 >= 81.0) gi_940 = 31;
   if (ld_4184 >= 82.0) gi_940 = 32;
   if (ld_4184 >= 83.0) gi_940 = 33;
   if (ld_4184 >= 84.0) gi_940 = 34;
   if (ld_4184 >= 85.0) gi_940 = 35;
   if (ld_4184 >= 86.0) gi_940 = 36;
   if (ld_4184 >= 87.0) gi_940 = 37;
   if (ld_4184 >= 88.0) gi_940 = 38;
   if (ld_4184 >= 89.0) gi_940 = 39;
   if (ld_4184 >= 90.0) gi_940 = 40;
   if (ld_4184 >= 91.0) gi_940 = 41;
   if (ld_4184 >= 92.0) gi_940 = 42;
   if (ld_4184 >= 93.0) gi_940 = 43;
   if (ld_4184 >= 94.0) gi_940 = 44;
   if (ld_4184 >= 95.0) gi_940 = 45;
   if (ld_4184 >= 96.0) gi_940 = 46;
   if (ld_4184 >= 97.0) gi_940 = 47;
   if (ld_4184 >= 100.0) li_4624 = 26;
   if (ld_4192 >= 51.0) gi_940 = -1;
   if (ld_4192 >= 52.0) gi_940 = -2;
   if (ld_4192 >= 53.0) gi_940 = -3;
   if (ld_4192 >= 54.0) gi_940 = -4;
   if (ld_4192 >= 55.0) gi_940 = -5;
   if (ld_4192 >= 56.0) gi_940 = -6;
   if (ld_4192 >= 57.0) gi_940 = -7;
   if (ld_4192 >= 58.0) gi_940 = -8;
   if (ld_4192 >= 59.0) gi_940 = -9;
   if (ld_4192 >= 60.0) gi_940 = -10;
   if (ld_4192 >= 61.0) gi_940 = -11;
   if (ld_4192 >= 62.0) gi_940 = -12;
   if (ld_4192 >= 63.0) gi_940 = -13;
   if (ld_4192 >= 64.0) gi_940 = -14;
   if (ld_4192 >= 65.0) gi_940 = -15;
   if (ld_4192 >= 66.0) gi_940 = -16;
   if (ld_4192 >= 67.0) gi_940 = -17;
   if (ld_4192 >= 68.0) gi_940 = -18;
   if (ld_4192 >= 69.0) gi_940 = -19;
   if (ld_4192 >= 70.0) gi_940 = -20;
   if (ld_4192 >= 71.0) gi_940 = -21;
   if (ld_4192 >= 72.0) gi_940 = -22;
   if (ld_4192 >= 73.0) gi_940 = -23;
   if (ld_4192 >= 74.0) gi_940 = -24;
   if (ld_4192 >= 75.0) gi_940 = -25;
   if (ld_4192 >= 76.0) gi_940 = -26;
   if (ld_4192 >= 77.0) gi_940 = -27;
   if (ld_4192 >= 78.0) gi_940 = -28;
   if (ld_4192 >= 79.0) gi_940 = -29;
   if (ld_4192 >= 80.0) gi_940 = -30;
   if (ld_4192 >= 81.0) gi_940 = -31;
   if (ld_4192 >= 82.0) gi_940 = -32;
   if (ld_4192 >= 83.0) gi_940 = -33;
   if (ld_4192 >= 84.0) gi_940 = -34;
   if (ld_4192 >= 85.0) gi_940 = -35;
   if (ld_4192 >= 86.0) gi_940 = -36;
   if (ld_4192 >= 87.0) gi_940 = -37;
   if (ld_4192 >= 88.0) gi_940 = -38;
   if (ld_4192 >= 89.0) gi_940 = -39;
   if (ld_4192 >= 90.0) gi_940 = -40;
   if (ld_4192 >= 91.0) gi_940 = -41;
   if (ld_4192 >= 92.0) gi_940 = -42;
   if (ld_4192 >= 93.0) gi_940 = -43;
   if (ld_4192 >= 94.0) gi_940 = -44;
   if (ld_4192 >= 95.0) gi_940 = -45;
   if (ld_4192 >= 96.0) gi_940 = -46;
   if (ld_4192 >= 97.0) gi_940 = -47;
   if (ld_4192 >= 100.0) li_4624 = 26;
   if (ld_4184 >= 50.0) {
      gd_560 = ld_4184;
      g_text_548 = "5";
      g_color_624 = gi_632;
   } else {
      gd_560 = ld_4192;
      g_text_548 = "6";
      g_color_624 = gi_748;
   }
   if (ld_4184 >= 60.0) g_color_568 = gi_640;
   if (ld_4192 >= 60.0) g_color_568 = gi_824;
   if (ld_4184 < 60.0 && ld_4184 >= 45.0) g_color_568 = gi_920;
   if (ld_4192 < 60.0 && ld_4192 > 45.0) g_color_568 = gi_920;
   string l_symbol_4200 = MarketSymbol;
   string l_dbl2str_4208 = DoubleToStr(iHigh(l_symbol_4200, g_timeframe_460, iHighest(l_symbol_4200, g_timeframe_460, MODE_HIGH, 48, 0)), MarketInfo(MarketSymbol, MODE_DIGITS));
   string l_dbl2str_4216 = DoubleToStr(MarketInfo(l_symbol_4200, MODE_ASK), MarketInfo(MarketSymbol, MODE_DIGITS));
   string l_dbl2str_4224 = DoubleToStr(MarketInfo(l_symbol_4200, MODE_BID), MarketInfo(MarketSymbol, MODE_DIGITS));
   string l_dbl2str_4232 = DoubleToStr(iLow(l_symbol_4200, g_timeframe_460, iLowest(l_symbol_4200, g_timeframe_460, MODE_LOW, 48, 0)), MarketInfo(MarketSymbol, MODE_DIGITS));
   string l_dbl2str_4240 = DoubleToStr((StrToDouble(l_dbl2str_4208) - StrToDouble(l_dbl2str_4232)) / MarketInfo(MarketSymbol, MODE_POINT), 0);
   string l_dbl2str_4248 = DoubleToStr(100.0 * ((StrToDouble(l_dbl2str_4224) - StrToDouble(l_dbl2str_4232)) / StrToDouble(l_dbl2str_4240)) / MarketInfo(MarketSymbol, MODE_POINT), 2);
   double ld_4256 = Lookup(StrToDouble(l_dbl2str_4248));
   if (ld_4256 < 6.0 && ld_4256 > 3.0) gi_944 = 0;
   if (ld_4256 >= 6.0) gi_944 = 3;
   if (ld_4256 >= 7.0) gi_944 = 6;
   if (ld_4256 >= 8.0) gi_944 = 8;
   if (ld_4256 >= 9.0) gi_944 = 10;
   if (ld_4256 <= 3.0) gi_944 = -3;
   if (ld_4256 <= 2.0) gi_944 = -6;
   if (ld_4256 <= 1.0) gi_944 = -8;
   if (ld_4256 <= 0.0) gi_944 = -10;
   if (ld_4256 <= 2.0) g_color_572 = gi_812;
   if (ld_4256 > 2.0 && ld_4256 < 7.0) g_color_572 = gi_908;
   if (ld_4256 >= 7.0) g_color_572 = gi_660;
   RefreshRates();
   double l_idemarker_4016 = iDeMarker(MarketSymbol, 0, g_period_456, 0);
   double l_idemarker_4024 = iDeMarker(MarketSymbol, 0, g_period_456, 10);
   if (l_idemarker_4016 > l_idemarker_4024 && l_idemarker_4016 >= 0.5) {
      gi_512 = 4;
      g_text_504 = "55";
   } else {
      if (l_idemarker_4016 < l_idemarker_4024 && l_idemarker_4016 < 0.5) {
         gi_512 = -4;
         g_text_504 = "66";
      } else {
         gi_512 = 0;
         g_text_504 = "qq";
      }
   }
   if (l_idemarker_4016 > l_idemarker_4024 && l_idemarker_4016 >= 0.5 && ld_4184 >= 50.0) {
      g_color_580 = gi_672;
      g_color_604 = BlockTrendArrows;
   } else {
      if (l_idemarker_4016 < l_idemarker_4024 && l_idemarker_4016 < 0.5 && ld_4192 > 50.0) {
         g_color_580 = gi_800;
         g_color_604 = BlockTrendArrows;
      } else {
         g_color_580 = gi_896;
         g_color_604 = gi_744;
      }
   }
   double l_imfi_3992 = iMFI(MarketSymbol, g_timeframe_464, 14, 0);
   if (l_imfi_3992 >= 61.0) {
      gi_524 = 4;
      g_text_516 = "55";
   } else {
      if (l_imfi_3992 <= 39.0) {
         gi_524 = -4;
         g_text_516 = "66";
      } else {
         gi_524 = 0;
         g_text_516 = "qq";
      }
   }
   if (l_imfi_3992 >= 61.0 && ld_4184 >= 50.0) {
      g_color_584 = gi_688;
      g_color_608 = BlockTrendArrows;
   } else {
      if (l_imfi_3992 <= 39.0 && ld_4192 > 50.0) {
         g_color_584 = gi_784;
         g_color_608 = BlockTrendArrows;
      } else {
         g_color_584 = gi_880;
         g_color_608 = gi_744;
      }
   }
   double l_irvi_4040 = iRVI(MarketSymbol, 0, 10, MODE_MAIN, 0);
   double l_irvi_4048 = iRVI(MarketSymbol, 0, 10, MODE_SIGNAL, 0);
   if (l_irvi_4040 < 0.0 && l_irvi_4040 < l_irvi_4048) {
      gi_536 = -4;
      g_text_528 = "66";
   } else {
      if (l_irvi_4040 >= 0.0 && l_irvi_4040 > l_irvi_4048) {
         gi_536 = 4;
         g_text_528 = "55";
      } else {
         gi_536 = 0;
         g_text_528 = "qq";
      }
   }
   if (l_irvi_4040 < 0.0 && l_irvi_4040 < l_irvi_4048 && ld_4192 > 50.0) {
      g_color_588 = gi_768;
      g_color_612 = BlockTrendArrows;
   } else {
      if (l_irvi_4040 >= 0.0 && l_irvi_4040 > l_irvi_4048 && ld_4184 >= 50.0) {
         g_color_588 = gi_696;
         g_color_612 = BlockTrendArrows;
      } else {
         g_color_588 = gi_864;
         g_color_612 = gi_744;
      }
   }
   double l_iao_4000 = iAO(MarketSymbol, g_timeframe_464, 0);
   double l_iao_4008 = iAO(MarketSymbol, g_timeframe_464, 1);
   if (l_iao_4000 >= 0.00005 && l_iao_4000 > l_iao_4008) {
      gi_556 = 4;
      g_text_540 = "55";
   } else {
      if (l_iao_4000 < -0.00005 && l_iao_4000 < l_iao_4008) {
         gi_556 = -4;
         g_text_540 = "66";
      } else {
         gi_556 = 0;
         g_text_540 = "qq";
      }
   }
   if (l_iao_4000 >= 0.00005 && l_iao_4000 > l_iao_4008 && ld_4184 >= 50.0) {
      g_color_592 = gi_712;
      g_color_616 = BlockTrendArrows;
   } else {
      if (l_iao_4000 < -0.00005 && l_iao_4000 < l_iao_4008 && ld_4192 > 50.0) {
         g_color_592 = gi_752;
         g_color_616 = BlockTrendArrows;
      } else {
         g_color_592 = gi_848;
         g_color_616 = gi_744;
      }
   }
   int li_4372 = gi_940 + gi_944 + gi_512 + gi_524 + gi_536 + gi_556;
   double ld_4376 = 100.0 * (MathAbs(li_4372) / 73.0);
   if (li_4372 > 0) gs_unused_952 = "BUY";
   if (li_4372 < 0) gs_unused_952 = "SELL";
   string l_text_4608 = ls_4616;
   if (ld_4376 >= 96.0 && ld_4376 <= 100.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_736;
      l_color_4500 = gi_632;
      l_color_4504 = gi_636;
      l_color_4508 = gi_640;
      l_color_4512 = gi_644;
      l_color_4516 = gi_648;
      l_color_4520 = gi_652;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 92.0 && ld_4376 < 96.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_736;
      l_color_4504 = gi_636;
      l_color_4508 = gi_640;
      l_color_4512 = gi_644;
      l_color_4516 = gi_648;
      l_color_4520 = gi_652;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 88.0 && ld_4376 < 92.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_736;
      l_color_4508 = gi_640;
      l_color_4512 = gi_644;
      l_color_4516 = gi_648;
      l_color_4520 = gi_652;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 84.0 && ld_4376 < 88.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_736;
      l_color_4512 = gi_644;
      l_color_4516 = gi_648;
      l_color_4520 = gi_652;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 80.0 && ld_4376 < 84.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_736;
      l_color_4516 = gi_648;
      l_color_4520 = gi_652;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 76.0 && ld_4376 < 80.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_736;
      l_color_4520 = gi_652;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 72.0 && ld_4376 < 76.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_736;
      l_color_4524 = gi_656;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 68.0 && ld_4376 < 72.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_736;
      l_color_4528 = gi_660;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 64.0 && ld_4376 < 68.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_736;
      l_color_4532 = gi_664;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 60.0 && ld_4376 < 64.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_736;
      l_color_4536 = gi_668;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 56.0 && ld_4376 < 60.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_736;
      l_color_4540 = gi_672;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 52.0 && ld_4376 < 56.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_736;
      l_color_4544 = gi_676;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 48.0 && ld_4376 < 52.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_736;
      l_color_4548 = gi_680;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 44.0 && ld_4376 < 48.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_736;
      l_color_4552 = gi_684;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 39.0 && ld_4376 < 44.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_736;
      l_color_4556 = gi_688;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 34.0 && ld_4376 < 39.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_736;
      l_color_4560 = gi_692;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 28.0 && ld_4376 < 34.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_736;
      l_color_4564 = gi_696;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 22.0 && ld_4376 < 28.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_736;
      l_color_4568 = gi_700;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 18.0 && ld_4376 < 22.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_912;
      l_color_4568 = gi_736;
      l_color_4572 = gi_704;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 14.0 && ld_4376 < 18.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_912;
      l_color_4568 = gi_916;
      l_color_4572 = gi_736;
      l_color_4576 = gi_708;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 12.0 && ld_4376 < 14.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_912;
      l_color_4568 = gi_916;
      l_color_4572 = gi_920;
      l_color_4576 = gi_736;
      l_color_4580 = gi_712;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 8.0 && ld_4376 < 12.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_912;
      l_color_4568 = gi_916;
      l_color_4572 = gi_920;
      l_color_4576 = gi_924;
      l_color_4580 = gi_736;
      l_color_4584 = gi_716;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 4.0 && ld_4376 < 8.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_912;
      l_color_4568 = gi_916;
      l_color_4572 = gi_920;
      l_color_4576 = gi_924;
      l_color_4580 = gi_928;
      l_color_4584 = gi_736;
      l_color_4588 = gi_720;
   }
   if (ld_4376 >= 0.0 && ld_4376 < 4.0 && li_4372 >= 0) {
      l_text_4384 = "5";
      l_color_4492 = gi_652;
      l_color_4496 = gi_844;
      l_color_4500 = gi_848;
      l_color_4504 = gi_852;
      l_color_4508 = gi_856;
      l_color_4512 = gi_860;
      l_color_4516 = gi_864;
      l_color_4520 = gi_868;
      l_color_4524 = gi_872;
      l_color_4528 = gi_876;
      l_color_4532 = gi_880;
      l_color_4536 = gi_884;
      l_color_4540 = gi_888;
      l_color_4544 = gi_892;
      l_color_4548 = gi_896;
      l_color_4552 = gi_900;
      l_color_4556 = gi_904;
      l_color_4560 = gi_908;
      l_color_4564 = gi_912;
      l_color_4568 = gi_916;
      l_color_4572 = gi_920;
      l_color_4576 = gi_924;
      l_color_4580 = gi_928;
      l_color_4584 = gi_932;
      l_color_4588 = gi_736;
   }
   if (ld_4376 >= 96.0 && ld_4376 <= 100.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_772;
      l_color_4568 = gi_768;
      l_color_4572 = gi_764;
      l_color_4576 = gi_760;
      l_color_4580 = gi_756;
      l_color_4584 = gi_752;
      l_color_4588 = gi_740;
   }
   if (ld_4376 >= 92.0 && ld_4376 < 96.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_772;
      l_color_4568 = gi_768;
      l_color_4572 = gi_764;
      l_color_4576 = gi_760;
      l_color_4580 = gi_756;
      l_color_4584 = gi_740;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 88.0 && ld_4376 < 92.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_772;
      l_color_4568 = gi_768;
      l_color_4572 = gi_764;
      l_color_4576 = gi_760;
      l_color_4580 = gi_740;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 84.0 && ld_4376 < 88.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_772;
      l_color_4568 = gi_768;
      l_color_4572 = gi_764;
      l_color_4576 = gi_740;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 80.0 && ld_4376 < 84.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_772;
      l_color_4568 = gi_768;
      l_color_4572 = gi_740;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 76.0 && ld_4376 < 80.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_772;
      l_color_4568 = gi_740;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 72.0 && ld_4376 < 76.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_776;
      l_color_4564 = gi_740;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 68.0 && ld_4376 < 72.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_780;
      l_color_4560 = gi_740;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 64.0 && ld_4376 < 68.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_784;
      l_color_4556 = gi_740;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 60.0 && ld_4376 < 64.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_788;
      l_color_4552 = gi_740;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 56.0 && ld_4376 < 60.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_792;
      l_color_4548 = gi_740;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 52.0 && ld_4376 < 56.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_796;
      l_color_4544 = gi_740;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 48.0 && ld_4376 < 52.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_800;
      l_color_4540 = gi_740;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 44.0 && ld_4376 < 48.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_804;
      l_color_4536 = gi_740;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 39.0 && ld_4376 < 44.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_808;
      l_color_4532 = gi_740;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 34.0 && ld_4376 < 39.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_812;
      l_color_4528 = gi_740;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 28.0 && ld_4376 < 34.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_816;
      l_color_4524 = gi_740;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 22.0 && ld_4376 < 28.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_820;
      l_color_4520 = gi_740;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 18.0 && ld_4376 < 22.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_824;
      l_color_4516 = gi_740;
      l_color_4520 = gi_912;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 14.0 && ld_4376 < 18.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_828;
      l_color_4512 = gi_740;
      l_color_4516 = gi_916;
      l_color_4520 = gi_912;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 12.0 && ld_4376 < 14.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_832;
      l_color_4508 = gi_740;
      l_color_4512 = gi_920;
      l_color_4516 = gi_916;
      l_color_4520 = gi_912;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 8.0 && ld_4376 < 12.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_836;
      l_color_4504 = gi_740;
      l_color_4508 = gi_924;
      l_color_4512 = gi_920;
      l_color_4516 = gi_916;
      l_color_4520 = gi_912;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 4.0 && ld_4376 < 8.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_840;
      l_color_4500 = gi_740;
      l_color_4504 = gi_928;
      l_color_4508 = gi_924;
      l_color_4512 = gi_920;
      l_color_4516 = gi_916;
      l_color_4520 = gi_912;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4376 >= 0.0 && ld_4376 < 4.0 && li_4372 < 0) {
      l_text_4384 = "6";
      l_color_4492 = gi_748;
      l_color_4496 = gi_740;
      l_color_4500 = gi_932;
      l_color_4504 = gi_928;
      l_color_4508 = gi_924;
      l_color_4512 = gi_920;
      l_color_4516 = gi_916;
      l_color_4520 = gi_912;
      l_color_4524 = gi_908;
      l_color_4528 = gi_904;
      l_color_4532 = gi_900;
      l_color_4536 = gi_896;
      l_color_4540 = gi_892;
      l_color_4544 = gi_888;
      l_color_4548 = gi_884;
      l_color_4552 = gi_880;
      l_color_4556 = gi_876;
      l_color_4560 = gi_872;
      l_color_4564 = gi_868;
      l_color_4568 = gi_864;
      l_color_4572 = gi_860;
      l_color_4576 = gi_856;
      l_color_4580 = gi_852;
      l_color_4584 = gi_848;
      l_color_4588 = gi_844;
   }
   if (ld_4184 >= 97.0) {
      l_color_4396 = gi_736;
      l_color_4400 = gi_632;
      l_color_4404 = gi_636;
      l_color_4408 = gi_640;
      l_color_4412 = gi_644;
      l_color_4416 = gi_648;
      l_color_4420 = gi_652;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 95.0 && ld_4184 < 97.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_736;
      l_color_4404 = gi_636;
      l_color_4408 = gi_640;
      l_color_4412 = gi_644;
      l_color_4416 = gi_648;
      l_color_4420 = gi_652;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 93.0 && ld_4184 < 95.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_736;
      l_color_4408 = gi_640;
      l_color_4412 = gi_644;
      l_color_4416 = gi_648;
      l_color_4420 = gi_652;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 91.0 && ld_4184 < 93.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_736;
      l_color_4412 = gi_644;
      l_color_4416 = gi_648;
      l_color_4420 = gi_652;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 89.0 && ld_4184 < 91.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_736;
      l_color_4416 = gi_648;
      l_color_4420 = gi_652;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 87.0 && ld_4184 < 89.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_736;
      l_color_4420 = gi_652;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 85.0 && ld_4184 < 87.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_736;
      l_color_4424 = gi_656;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 83.0 && ld_4184 < 85.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_736;
      l_color_4428 = gi_660;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 81.0 && ld_4184 < 83.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_736;
      l_color_4432 = gi_664;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 79.0 && ld_4184 < 81.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_736;
      l_color_4436 = gi_668;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 77.0 && ld_4184 < 79.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_736;
      l_color_4440 = gi_672;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 75.0 && ld_4184 < 77.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_736;
      l_color_4444 = gi_676;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 73.0 && ld_4184 < 75.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_736;
      l_color_4448 = gi_680;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 71.0 && ld_4184 < 73.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_736;
      l_color_4452 = gi_684;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 69.0 && ld_4184 < 71.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_736;
      l_color_4456 = gi_688;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 67.0 && ld_4184 < 69.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_736;
      l_color_4460 = gi_692;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 65.0 && ld_4184 < 67.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_736;
      l_color_4464 = gi_696;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 63.0 && ld_4184 < 65.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_736;
      l_color_4468 = gi_700;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 61.0 && ld_4184 < 63.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_912;
      l_color_4468 = gi_736;
      l_color_4472 = gi_704;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 59.0 && ld_4184 < 61.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_912;
      l_color_4468 = gi_916;
      l_color_4472 = gi_736;
      l_color_4476 = gi_708;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 57.0 && ld_4184 < 59.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_912;
      l_color_4468 = gi_916;
      l_color_4472 = gi_920;
      l_color_4476 = gi_736;
      l_color_4480 = gi_712;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 55.0 && ld_4184 < 57.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_912;
      l_color_4468 = gi_916;
      l_color_4472 = gi_920;
      l_color_4476 = gi_924;
      l_color_4480 = gi_736;
      l_color_4484 = gi_716;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 53.0 && ld_4184 < 55.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_912;
      l_color_4468 = gi_916;
      l_color_4472 = gi_920;
      l_color_4476 = gi_924;
      l_color_4480 = gi_928;
      l_color_4484 = gi_736;
      l_color_4488 = gi_720;
   }
   if (ld_4184 >= 49.0 && ld_4184 < 53.0) {
      l_color_4396 = gi_844;
      l_color_4400 = gi_848;
      l_color_4404 = gi_852;
      l_color_4408 = gi_856;
      l_color_4412 = gi_860;
      l_color_4416 = gi_864;
      l_color_4420 = gi_868;
      l_color_4424 = gi_872;
      l_color_4428 = gi_876;
      l_color_4432 = gi_880;
      l_color_4436 = gi_884;
      l_color_4440 = gi_888;
      l_color_4444 = gi_892;
      l_color_4448 = gi_896;
      l_color_4452 = gi_900;
      l_color_4456 = gi_904;
      l_color_4460 = gi_908;
      l_color_4464 = gi_912;
      l_color_4468 = gi_916;
      l_color_4472 = gi_920;
      l_color_4476 = gi_924;
      l_color_4480 = gi_928;
      l_color_4484 = gi_932;
      l_color_4488 = gi_736;
   }
   if (ld_4192 >= 97.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_772;
      l_color_4468 = gi_768;
      l_color_4472 = gi_764;
      l_color_4476 = gi_760;
      l_color_4480 = gi_756;
      l_color_4484 = gi_752;
      l_color_4488 = gi_740;
   }
   if (ld_4192 >= 95.0 && ld_4192 < 97.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_772;
      l_color_4468 = gi_768;
      l_color_4472 = gi_764;
      l_color_4476 = gi_760;
      l_color_4480 = gi_756;
      l_color_4484 = gi_740;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 93.0 && ld_4192 < 95.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_772;
      l_color_4468 = gi_768;
      l_color_4472 = gi_764;
      l_color_4476 = gi_760;
      l_color_4480 = gi_740;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 91.0 && ld_4192 < 93.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_772;
      l_color_4468 = gi_768;
      l_color_4472 = gi_764;
      l_color_4476 = gi_740;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 89.0 && ld_4192 < 91.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_772;
      l_color_4468 = gi_768;
      l_color_4472 = gi_740;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 87.0 && ld_4192 < 89.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_772;
      l_color_4468 = gi_740;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 85.0 && ld_4192 < 87.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_776;
      l_color_4464 = gi_740;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 83.0 && ld_4192 < 85.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_780;
      l_color_4460 = gi_740;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 81.0 && ld_4192 < 83.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_784;
      l_color_4456 = gi_740;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 79.0 && ld_4192 < 81.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_788;
      l_color_4452 = gi_740;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 77.0 && ld_4192 < 79.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_792;
      l_color_4448 = gi_740;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 75.0 && ld_4192 < 77.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_796;
      l_color_4444 = gi_740;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 73.0 && ld_4192 < 75.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_800;
      l_color_4440 = gi_740;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 71.0 && ld_4192 < 73.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_804;
      l_color_4436 = gi_740;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 69.0 && ld_4192 < 71.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_808;
      l_color_4432 = gi_740;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 67.0 && ld_4192 < 69.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_812;
      l_color_4428 = gi_740;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 65.0 && ld_4192 < 67.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_816;
      l_color_4424 = gi_740;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 63.0 && ld_4192 < 65.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_820;
      l_color_4420 = gi_740;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 61.0 && ld_4192 < 63.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_824;
      l_color_4416 = gi_740;
      l_color_4420 = gi_912;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 59.0 && ld_4192 < 61.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_828;
      l_color_4412 = gi_740;
      l_color_4416 = gi_916;
      l_color_4420 = gi_912;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 57.0 && ld_4192 < 59.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_832;
      l_color_4408 = gi_740;
      l_color_4412 = gi_920;
      l_color_4416 = gi_916;
      l_color_4420 = gi_912;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 55.0 && ld_4192 < 57.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_836;
      l_color_4404 = gi_740;
      l_color_4408 = gi_924;
      l_color_4412 = gi_920;
      l_color_4416 = gi_916;
      l_color_4420 = gi_912;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 >= 53.0 && ld_4192 < 55.0) {
      l_color_4396 = gi_840;
      l_color_4400 = gi_740;
      l_color_4404 = gi_928;
      l_color_4408 = gi_924;
      l_color_4412 = gi_920;
      l_color_4416 = gi_916;
      l_color_4420 = gi_912;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (ld_4192 > 50.0 && ld_4192 < 53.0) {
      l_color_4396 = gi_740;
      l_color_4400 = gi_932;
      l_color_4404 = gi_928;
      l_color_4408 = gi_924;
      l_color_4412 = gi_920;
      l_color_4416 = gi_916;
      l_color_4420 = gi_912;
      l_color_4424 = gi_908;
      l_color_4428 = gi_904;
      l_color_4432 = gi_900;
      l_color_4436 = gi_896;
      l_color_4440 = gi_892;
      l_color_4444 = gi_888;
      l_color_4448 = gi_884;
      l_color_4452 = gi_880;
      l_color_4456 = gi_876;
      l_color_4460 = gi_872;
      l_color_4464 = gi_868;
      l_color_4468 = gi_864;
      l_color_4472 = gi_860;
      l_color_4476 = gi_856;
      l_color_4480 = gi_852;
      l_color_4484 = gi_848;
      l_color_4488 = gi_844;
   }
   if (li_4372 >= 0 && ld_4376 >= 50.0) {
      l_color_4600 = gi_652;
      g_color_596 = gi_724;
   } else {
      if (li_4372 < 0 && ld_4376 >= 50.0) {
         l_color_4600 = gi_776;
         g_color_596 = gi_724;
      } else {
         l_color_4600 = BackgroundColor;
         g_color_596 = gi_728;
      }
   }
   if (ld_4184 >= 75.0 && ld_4192 < 50.0) {
      l_color_4604 = gi_652;
      g_color_600 = gi_724;
   } else {
      if (ld_4192 >= 75.0 && ld_4184 < 50.0) {
         l_color_4604 = gi_776;
         g_color_600 = gi_724;
      } else {
         l_color_4604 = BackgroundColor;
         g_color_600 = gi_728;
      }
   }
   if (ld_4376 >= AlertTriggerPercentage && li_4372 > 0 && gi_228 != Time[0]) {
      if (MessageBoxAlert) Alert("NITRO+ LONG  ", MarketSymbol, " ", gs_232, " @ ", DoubleToStr(MarketInfo(l_symbol_4200, MODE_BID), MarketInfo(MarketSymbol, MODE_DIGITS)));
      if (AudibleAlert) PlaySound(AudibleAlertSoundFile);
      gi_228 = Time[0];
   }
   if (ld_4376 >= AlertTriggerPercentage && li_4372 < 0 && gi_228 != Time[0]) {
      if (MessageBoxAlert) Alert("NITRO+ SHORT ", MarketSymbol, " ", gs_232, " @ ", DoubleToStr(MarketInfo(l_symbol_4200, MODE_BID), MarketInfo(MarketSymbol, MODE_DIGITS)));
      if (AudibleAlert) PlaySound(AudibleAlertSoundFile);
      gi_228 = Time[0];
   }
   if (CompactMode) {
      if (ShowPrice) {
         ObjectCreate("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
         ObjectSetText("[wyfxco.com]NITRO_Price" + NitroMagicNumber, l_dbl2str_4724, 17, "Arial Black", l_color_4492);
         ObjectSet("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
         ObjectSet("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4708 + 208);
         ObjectSet("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 6);
      }
      if (ShowBackgroundInCompactMode) {
         ObjectCreate("* �2010 www.wyfxco.com * Distribution Is Prohibited. *" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
         ObjectSetText("* �2010 www.wyfxco.com * Distribution Is Prohibited. *" + NitroMagicNumber, g_text_496, 22, "Webdings", CompactBackground);
         ObjectSet("* �2010 www.wyfxco.com * Distribution Is Prohibited. *" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
         ObjectSet("* �2010 www.wyfxco.com * Distribution Is Prohibited. *" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 1);
         ObjectSet("* �2010 www.wyfxco.com * Distribution Is Prohibited. *" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 7);
      }
      ObjectCreate("[wyfxco.com]copyright" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]copyright" + NitroMagicNumber, "�2010 www.wyfxco.com", 6, "Arial", C'0x78,0x78,0x78');
      ObjectSet("[wyfxco.com]copyright" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]copyright" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 105);
      ObjectSet("[wyfxco.com]copyright" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 28);
      ObjectCreate("[wyfxco.com]symbol" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]symbol" + NitroMagicNumber, l_text_4608, 14, "Arial Black", SymbolColor);
      ObjectSet("[wyfxco.com]symbol" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]symbol" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4692 + 101);
      ObjectSet("[wyfxco.com]symbol" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 8);
      ObjectCreate("[wyfxco.com]Direction" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]Direction" + NitroMagicNumber, l_text_4384, 30, "Webdings", l_color_4492);
      ObjectSet("[wyfxco.com]Direction" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]Direction" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4688 + 54);
      ObjectSet("[wyfxco.com]Direction" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 2);
      if (ld_4376 >= 10.0 && ld_4376 <= 99.9) li_4628 = 4;
      else {
         if (ld_4376 < 10.0) li_4628 = 12;
         else li_4628 = 0;
      }
      ObjectCreate("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, " " + DoubleToStr(ld_4376, 0) + "%", 15, "Arial Black", l_color_4492);
      ObjectSet("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJPROP_XDISTANCE, li_4628 + X_box + 1);
      ObjectSet("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 8);
      ObjectCreate("[wyfxco.com]Title2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]Title2" + NitroMagicNumber, "�", 7, "Arial Black", g_color_732);
      ObjectSet("[wyfxco.com]Title2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]Title2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4684 + li_4700 + li_4704);
      ObjectSet("[wyfxco.com]Title2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 13);
      ObjectCreate("[wyfxco.com]Title1" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]Title1" + NitroMagicNumber, "~", 22, "Webdings", g_color_732);
      ObjectSet("[wyfxco.com]Title1" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]Title1" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4680 + li_4696 + 308);
      ObjectSet("[wyfxco.com]Title1" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 8);
   } else {
      ObjectCreate("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber, "�", 98, "WingDings", BackgroundColor);
      ObjectSet("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4664);
      ObjectSet("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + li_4668);
      ObjectSet("***�2010 www.wyfxco.com - Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_ANGLE, l_angle_4712);
      ObjectCreate("[wyfxco.com]highlight" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]highlight" + NitroMagicNumber, "�", 99, "WingDings", BackShadowColor);
      ObjectSet("[wyfxco.com]highlight" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]highlight" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4676);
      ObjectSet("[wyfxco.com]highlight" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + li_4672);
      ObjectSet("[wyfxco.com]highlight" + NitroMagicNumber, OBJPROP_BACK, TRUE);
      ObjectSet("[wyfxco.com]highlight" + NitroMagicNumber, OBJPROP_ANGLE, l_angle_4712);
      ObjectCreate("**�2010 www.wyfxco.com || Distribution Is Prohibited." + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("**�2010 www.wyfxco.com || Distribution Is Prohibited." + NitroMagicNumber, "g", 71, "WebDings", BackgroundColor);
      ObjectSet("**�2010 www.wyfxco.com || Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("**�2010 www.wyfxco.com || Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 61);
      ObjectSet("**�2010 www.wyfxco.com || Distribution Is Prohibited." + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 32);
      ObjectCreate("*�2010 www.wyfxco.com1" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("*�2010 www.wyfxco.com1" + NitroMagicNumber, "|", 70, "Webdings", l_color_4604);
      ObjectSet("*�2010 www.wyfxco.com1" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("*�2010 www.wyfxco.com1" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 38);
      ObjectSet("*�2010 www.wyfxco.com1" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 32);
      ObjectCreate("*�2010 www.wyfxco.com2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("*�2010 www.wyfxco.com2" + NitroMagicNumber, "|", 70, "Webdings", l_color_4604);
      ObjectSet("*�2010 www.wyfxco.com2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("*�2010 www.wyfxco.com2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 43);
      ObjectSet("*�2010 www.wyfxco.com2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 32);
      ObjectCreate("*�2010 www.wyfxco.com3" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("*�2010 www.wyfxco.com3" + NitroMagicNumber, "|", 70, "Webdings", l_color_4600);
      ObjectSet("*�2010 www.wyfxco.com3" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("*�2010 www.wyfxco.com3" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 84);
      ObjectSet("*�2010 www.wyfxco.com3" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 32);
      ObjectCreate("*�2010 www.wyfxco.com4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("*�2010 www.wyfxco.com4" + NitroMagicNumber, "|", 70, "Webdings", l_color_4600);
      ObjectSet("*�2010 www.wyfxco.com4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("*�2010 www.wyfxco.com4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 88);
      ObjectSet("*�2010 www.wyfxco.com4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 32);
      ObjectCreate("[wyfxco.com]trend_logo_1" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_1" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4496);
      ObjectSet("[wyfxco.com]trend_logo_1" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_1" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 155);
      ObjectSet("[wyfxco.com]trend_logo_1" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 69);
      ObjectSet("[wyfxco.com]trend_logo_1" + NitroMagicNumber, OBJPROP_ANGLE, 180);
      ObjectCreate("[wyfxco.com]trend_logo_2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_2" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4500);
      ObjectSet("[wyfxco.com]trend_logo_2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 1);
      ObjectCreate("[wyfxco.com]trend_logo_3" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_3" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4504);
      ObjectSet("[wyfxco.com]trend_logo_3" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_3" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_3" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 5);
      ObjectCreate("[wyfxco.com]trend_logo_4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_4" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4508);
      ObjectSet("[wyfxco.com]trend_logo_4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 9);
      ObjectCreate("[wyfxco.com]trend_logo_5" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_5" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4512);
      ObjectSet("[wyfxco.com]trend_logo_5" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_5" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_5" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 13);
      ObjectCreate("[wyfxco.com]trend_logo_6" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_6" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4516);
      ObjectSet("[wyfxco.com]trend_logo_6" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_6" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_6" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 17);
      ObjectCreate("[wyfxco.com]trend_logo_7" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_7" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4520);
      ObjectSet("[wyfxco.com]trend_logo_7" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_7" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_7" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 21);
      ObjectCreate("[wyfxco.com]trend_logo_8" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_8" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4524);
      ObjectSet("[wyfxco.com]trend_logo_8" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_8" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_8" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 25);
      ObjectCreate("[wyfxco.com]trend_logo_9" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_9" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4528);
      ObjectSet("[wyfxco.com]trend_logo_9" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_9" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_9" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 29);
      ObjectCreate("[wyfxco.com]trend_logo_10" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_10" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4532);
      ObjectSet("[wyfxco.com]trend_logo_10" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_10" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_10" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 33);
      ObjectCreate("[wyfxco.com]trend_logo_11" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_11" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4536);
      ObjectSet("[wyfxco.com]trend_logo_11" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_11" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_11" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 37);
      ObjectCreate("[wyfxco.com]trend_logo_12" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_12" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4540);
      ObjectSet("[wyfxco.com]trend_logo_12" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_12" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_12" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 41);
      ObjectCreate("[wyfxco.com]trend_logo_13" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_13" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4544);
      ObjectSet("[wyfxco.com]trend_logo_13" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_13" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_13" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 45);
      ObjectCreate("[wyfxco.com]trend_logo_14" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_14" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4548);
      ObjectSet("[wyfxco.com]trend_logo_14" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_14" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_14" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 49);
      ObjectCreate("[wyfxco.com]trend_logo_15" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_15" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4552);
      ObjectSet("[wyfxco.com]trend_logo_15" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_15" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_15" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 53);
      ObjectCreate("[wyfxco.com]trend_logo_16" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_16" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4556);
      ObjectSet("[wyfxco.com]trend_logo_16" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_16" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_16" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 57);
      ObjectCreate("[wyfxco.com]trend_logo_17" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_17" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4560);
      ObjectSet("[wyfxco.com]trend_logo_17" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_17" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_17" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 61);
      ObjectCreate("[wyfxco.com]trend_logo_18" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_18" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4564);
      ObjectSet("[wyfxco.com]trend_logo_18" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_18" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_18" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 65);
      ObjectCreate("[wyfxco.com]trend_logo_19" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_19" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4568);
      ObjectSet("[wyfxco.com]trend_logo_19" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_19" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_19" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 69);
      ObjectCreate("[wyfxco.com]trend_logo_20" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_20" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4572);
      ObjectSet("[wyfxco.com]trend_logo_20" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_20" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_20" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 73);
      ObjectCreate("[wyfxco.com]trend_logo_21" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_21" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4576);
      ObjectSet("[wyfxco.com]trend_logo_21" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_21" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_21" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 77);
      ObjectCreate("[wyfxco.com]trend_logo_22" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_22" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4580);
      ObjectSet("[wyfxco.com]trend_logo_22" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_22" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_22" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 81);
      ObjectCreate("[wyfxco.com]trend_logo_23" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_23" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4584);
      ObjectSet("[wyfxco.com]trend_logo_23" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_23" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_23" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 85);
      ObjectCreate("[wyfxco.com]trend_logo_24" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]trend_logo_24" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4588);
      ObjectSet("[wyfxco.com]trend_logo_24" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]trend_logo_24" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 110);
      ObjectSet("[wyfxco.com]trend_logo_24" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 89);
      ObjectCreate("[wyfxco.com]titan_logo_1" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_1" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4396);
      ObjectSet("[wyfxco.com]titan_logo_1" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_1" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 109);
      ObjectSet("[wyfxco.com]titan_logo_1" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 69);
      ObjectSet("[wyfxco.com]titan_logo_1" + NitroMagicNumber, OBJPROP_ANGLE, 180);
      ObjectCreate("[wyfxco.com]titan_logo_2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_2" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4400);
      ObjectSet("[wyfxco.com]titan_logo_2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 1);
      ObjectCreate("[wyfxco.com]titan_logo_3" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_3" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4404);
      ObjectSet("[wyfxco.com]titan_logo_3" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_3" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_3" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 5);
      ObjectCreate("[wyfxco.com]titan_logo_4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_4" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4408);
      ObjectSet("[wyfxco.com]titan_logo_4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 9);
      ObjectCreate("[wyfxco.com]titan_logo_5" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_5" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4412);
      ObjectSet("[wyfxco.com]titan_logo_5" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_5" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_5" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 13);
      ObjectCreate("[wyfxco.com]titan_logo_6" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_6" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4416);
      ObjectSet("[wyfxco.com]titan_logo_6" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_6" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_6" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 17);
      ObjectCreate("[wyfxco.com]titan_logo_7" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_7" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4420);
      ObjectSet("[wyfxco.com]titan_logo_7" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_7" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_7" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 21);
      ObjectCreate("[wyfxco.com]titan_logo_8" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_8" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4424);
      ObjectSet("[wyfxco.com]titan_logo_8" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_8" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_8" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 25);
      ObjectCreate("[wyfxco.com]titan_logo_9" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_9" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4428);
      ObjectSet("[wyfxco.com]titan_logo_9" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_9" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_9" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 29);
      ObjectCreate("[wyfxco.com]titan_logo_10" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_10" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4432);
      ObjectSet("[wyfxco.com]titan_logo_10" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_10" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_10" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 33);
      ObjectCreate("[wyfxco.com]titan_logo_11" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_11" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4436);
      ObjectSet("[wyfxco.com]titan_logo_11" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_11" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_11" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 37);
      ObjectCreate("[wyfxco.com]titan_logo_12" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_12" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4440);
      ObjectSet("[wyfxco.com]titan_logo_12" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_12" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_12" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 41);
      ObjectCreate("[wyfxco.com]titan_logo_13" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_13" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4444);
      ObjectSet("[wyfxco.com]titan_logo_13" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_13" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_13" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 45);
      ObjectCreate("[wyfxco.com]titan_logo_14" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_14" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4448);
      ObjectSet("[wyfxco.com]titan_logo_14" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_14" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_14" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 49);
      ObjectCreate("[wyfxco.com]titan_logo_15" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_15" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4452);
      ObjectSet("[wyfxco.com]titan_logo_15" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_15" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_15" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 53);
      ObjectCreate("[wyfxco.com]titan_logo_16" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_16" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4456);
      ObjectSet("[wyfxco.com]titan_logo_16" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_16" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_16" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 57);
      ObjectCreate("[wyfxco.com]titan_logo_17" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_17" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4460);
      ObjectSet("[wyfxco.com]titan_logo_17" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_17" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_17" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 61);
      ObjectCreate("[wyfxco.com]titan_logo_18" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_18" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4464);
      ObjectSet("[wyfxco.com]titan_logo_18" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_18" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_18" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 65);
      ObjectCreate("[wyfxco.com]titan_logo_19" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_19" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4468);
      ObjectSet("[wyfxco.com]titan_logo_19" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_19" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_19" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 69);
      ObjectCreate("[wyfxco.com]titan_logo_20" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_20" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4472);
      ObjectSet("[wyfxco.com]titan_logo_20" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_20" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_20" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 73);
      ObjectCreate("[wyfxco.com]titan_logo_21" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_21" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4476);
      ObjectSet("[wyfxco.com]titan_logo_21" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_21" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_21" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 77);
      ObjectCreate("[wyfxco.com]titan_logo_22" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_22" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4480);
      ObjectSet("[wyfxco.com]titan_logo_22" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_22" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_22" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 81);
      ObjectCreate("[wyfxco.com]titan_logo_23" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_23" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4484);
      ObjectSet("[wyfxco.com]titan_logo_23" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_23" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_23" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 85);
      ObjectCreate("[wyfxco.com]titan_logo_24" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]titan_logo_24" + NitroMagicNumber, "_ _", 25, "Arial Bold", l_color_4488);
      ObjectSet("[wyfxco.com]titan_logo_24" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]titan_logo_24" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 64);
      ObjectSet("[wyfxco.com]titan_logo_24" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 89);
      ObjectCreate("[wyfxco.com]Direction" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]Direction" + NitroMagicNumber, l_text_4384, 43, "Webdings", l_color_4492);
      ObjectSet("[wyfxco.com]Direction" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]Direction" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 155);
      ObjectSet("[wyfxco.com]Direction" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 77);
      if (ld_4376 >= 9.5 && ld_4376 <= 99.9) li_4628 = 2;
      else {
         if (ld_4376 < 10.0) li_4628 = 7;
         else li_4628 = 0;
      }
      ObjectCreate("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, DoubleToStr(ld_4376, 0) + "%", 15, "Arial Black", l_color_4492);
      ObjectSet("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJPROP_XDISTANCE, li_4628 + X_box + 155 + li_4720);
      ObjectSet("[wyfxco.com]X_Global_Percentage" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 70);
      ObjectCreate("[wyfxco.com]T2_logo" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]T2_logo" + NitroMagicNumber, "n", 27, "Wingdings", g_color_568);
      ObjectSet("[wyfxco.com]T2_logo" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]T2_logo" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 40);
      ObjectSet("[wyfxco.com]T2_logo" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 24);
      ObjectCreate("[wyfxco.com]T2_logo2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]T2_logo2" + NitroMagicNumber, "n", 27, "Wingdings", g_color_568);
      ObjectSet("[wyfxco.com]T2_logo2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]T2_logo2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 25);
      ObjectSet("[wyfxco.com]T2_logo2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 24);
      ObjectCreate("[wyfxco.com]T2_logo4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]T2_logo4" + NitroMagicNumber, "n", 27, "Wingdings", g_color_568);
      ObjectSet("[wyfxco.com]T2_logo4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]T2_logo4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 17);
      ObjectSet("[wyfxco.com]T2_logo4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 24);
      ObjectCreate("[wyfxco.com]T2_logo3" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]T2_logo3" + NitroMagicNumber, "0", 21, "Wingdings", g_color_568);
      ObjectSet("[wyfxco.com]T2_logo3" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]T2_logo3" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 1);
      ObjectSet("[wyfxco.com]T2_logo3" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 27);
      ObjectCreate("[wyfxco.com]T2_score" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]T2_score" + NitroMagicNumber, DoubleToStr(gd_560, 0), 12, "Arial Black", BlockValuesColor);
      ObjectSet("[wyfxco.com]T2_score" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]T2_score" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4624);
      ObjectSet("[wyfxco.com]T2_score" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 31);
      ObjectCreate("[wyfxco.com]T2_Z" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]T2_Z" + NitroMagicNumber, g_text_548, 12, "Webdings", g_color_624);
      ObjectSet("[wyfxco.com]T2_Z" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]T2_Z" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4716);
      ObjectSet("[wyfxco.com]T2_Z" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 38);
      ObjectCreate("[wyfxco.com]X_comment_T2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_comment_T2" + NitroMagicNumber, "T2", 8, "Arial Black", LegendTagsTextColor);
      ObjectSet("[wyfxco.com]X_comment_T2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_comment_T2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 5);
      ObjectSet("[wyfxco.com]X_comment_T2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 33);
      ObjectCreate("[wyfxco.com]e_SS_logo" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]e_SS_logo" + NitroMagicNumber, "g", 18, "Webdings", g_color_572);
      ObjectSet("[wyfxco.com]e_SS_logo" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]e_SS_logo" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 40);
      ObjectSet("[wyfxco.com]e_SS_logo" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 42);
      ObjectCreate("[wyfxco.com]e_SS_logo2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]e_SS_logo2" + NitroMagicNumber, "g", 17, "Webdings", g_color_572);
      ObjectSet("[wyfxco.com]e_SS_logo2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]e_SS_logo2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 20);
      ObjectSet("[wyfxco.com]e_SS_logo2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 43);
      ObjectCreate("[wyfxco.com]e_SS_logo4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]e_SS_logo4" + NitroMagicNumber, "0", 15, "Wingdings", g_color_572);
      ObjectSet("[wyfxco.com]e_SS_logo4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]e_SS_logo4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 2);
      ObjectSet("[wyfxco.com]e_SS_logo4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 49);
      ObjectCreate("[wyfxco.com]e_SS_score" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]e_SS_score" + NitroMagicNumber, DoubleToStr(ld_4256, 0), 10, "Arial Black", BlockValuesColor);
      ObjectSet("[wyfxco.com]e_SS_score" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]e_SS_score" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 37);
      ObjectSet("[wyfxco.com]e_SS_score" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 52);
      ObjectCreate("[wyfxco.com]X_comment_e_SS" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_comment_e_SS" + NitroMagicNumber, "SS", 6, "Arial Black", LegendTagsTextColor);
      ObjectSet("[wyfxco.com]X_comment_e_SS" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_comment_e_SS" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 6);
      ObjectSet("[wyfxco.com]X_comment_e_SS" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 55);
      ObjectCreate("[wyfxco.com]d_DeM_logo" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]d_DeM_logo" + NitroMagicNumber, "<", 59, "Webdings", g_color_580);
      ObjectSet("[wyfxco.com]d_DeM_logo" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]d_DeM_logo" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 3);
      ObjectSet("[wyfxco.com]d_DeM_logo" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 20);
      ObjectCreate("[wyfxco.com]d_DeM_logo4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]d_DeM_logo4" + NitroMagicNumber, "0", 16, "Wingdings", g_color_580);
      ObjectSet("[wyfxco.com]d_DeM_logo4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]d_DeM_logo4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 2);
      ObjectSet("[wyfxco.com]d_DeM_logo4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 63);
      ObjectCreate("[wyfxco.com]d_DeM_score" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]d_DeM_score" + NitroMagicNumber, g_text_504, 13, "Webdings", g_color_604);
      ObjectSet("[wyfxco.com]d_DeM_score" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]d_DeM_score" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 24);
      ObjectSet("[wyfxco.com]d_DeM_score" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 65);
      ObjectCreate("[wyfxco.com]X_comment_d_DeM" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_comment_d_DeM" + NitroMagicNumber, "DeM", 5, "Arial Black", LegendTagsTextColor);
      ObjectSet("[wyfxco.com]X_comment_d_DeM" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_comment_d_DeM" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 4);
      ObjectSet("[wyfxco.com]X_comment_d_DeM" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 71);
      ObjectCreate("[wyfxco.com]c_MFI_logo" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]c_MFI_logo" + NitroMagicNumber, "<", 59, "Webdings", g_color_584);
      ObjectSet("[wyfxco.com]c_MFI_logo" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]c_MFI_logo" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 3);
      ObjectSet("[wyfxco.com]c_MFI_logo" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 35);
      ObjectCreate("[wyfxco.com]c_MFI_logo4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]c_MFI_logo4" + NitroMagicNumber, "0", 16, "Wingdings", g_color_584);
      ObjectSet("[wyfxco.com]c_MFI_logo4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]c_MFI_logo4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 2);
      ObjectSet("[wyfxco.com]c_MFI_logo4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 78);
      ObjectCreate("[wyfxco.com]c_MFI_score" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]c_MFI_score" + NitroMagicNumber, g_text_516, 13, "Webdings", g_color_608);
      ObjectSet("[wyfxco.com]c_MFI_score" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]c_MFI_score" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 24);
      ObjectSet("[wyfxco.com]c_MFI_score" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 80);
      ObjectCreate("[wyfxco.com]X_comment_c_MFI" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_comment_c_MFI" + NitroMagicNumber, "MFI", 6, "Arial Black", LegendTagsTextColor);
      ObjectSet("[wyfxco.com]X_comment_c_MFI" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_comment_c_MFI" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 4);
      ObjectSet("[wyfxco.com]X_comment_c_MFI" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 85);
      ObjectCreate("[wyfxco.com]b_RVI_logo" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]b_RVI_logo" + NitroMagicNumber, "<", 59, "Webdings", g_color_588);
      ObjectSet("[wyfxco.com]b_RVI_logo" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]b_RVI_logo" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 3);
      ObjectSet("[wyfxco.com]b_RVI_logo" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 50);
      ObjectCreate("[wyfxco.com]b_RVI_logo4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]b_RVI_logo4" + NitroMagicNumber, "0", 16, "Wingdings", g_color_588);
      ObjectSet("[wyfxco.com]b_RVI_logo4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]b_RVI_logo4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 2);
      ObjectSet("[wyfxco.com]b_RVI_logo4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 93);
      ObjectCreate("[wyfxco.com]b_RVI_score" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]b_RVI_score" + NitroMagicNumber, g_text_528, 13, "Webdings", g_color_612);
      ObjectSet("[wyfxco.com]b_RVI_score" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]b_RVI_score" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 24);
      ObjectSet("[wyfxco.com]b_RVI_score" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 95);
      ObjectCreate("[wyfxco.com]X_comment_b_RVI" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_comment_b_RVI" + NitroMagicNumber, "RVI", 6, "Arial Black", LegendTagsTextColor);
      ObjectSet("[wyfxco.com]X_comment_b_RVI" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_comment_b_RVI" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 5);
      ObjectSet("[wyfxco.com]X_comment_b_RVI" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 100);
      ObjectCreate("[wyfxco.com]AO_logo" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]AO_logo" + NitroMagicNumber, "<", 59, "Webdings", g_color_592);
      ObjectSet("[wyfxco.com]AO_logo" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]AO_logo" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 3);
      ObjectSet("[wyfxco.com]AO_logo" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 65);
      ObjectCreate("[wyfxco.com]AO_logo4" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]AO_logo4" + NitroMagicNumber, "0", 16, "Wingdings", g_color_592);
      ObjectSet("[wyfxco.com]AO_logo4" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]AO_logo4" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 2);
      ObjectSet("[wyfxco.com]AO_logo4" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 108);
      ObjectCreate("[wyfxco.com]AO_score" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]AO_score" + NitroMagicNumber, g_text_540, 13, "Webdings", g_color_616);
      ObjectSet("[wyfxco.com]AO_score" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]AO_score" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 24);
      ObjectSet("[wyfxco.com]AO_score" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 110);
      ObjectCreate("[wyfxco.com]X_comment_AO" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]X_comment_AO" + NitroMagicNumber, "AO", 6, "Arial Black", LegendTagsTextColor);
      ObjectSet("[wyfxco.com]X_comment_AO" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]X_comment_AO" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 6);
      ObjectSet("[wyfxco.com]X_comment_AO" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 115);
      ObjectCreate("[wyfxco.com]Title2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]Title2" + NitroMagicNumber, "�", 8, "Arial Black", g_color_732);
      ObjectSet("[wyfxco.com]Title2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]Title2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4656);
      ObjectSet("[wyfxco.com]Title2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + li_4660);
      ObjectCreate("[wyfxco.com]Title1" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]Title1" + NitroMagicNumber, "~", 26, "Webdings", g_color_732);
      ObjectSet("[wyfxco.com]Title1" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]Title1" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 166);
      ObjectSet("[wyfxco.com]Title1" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 39);
      ObjectCreate("[wyfxco.com]legend1" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]legend1" + NitroMagicNumber, "TITAN II�", 8, "Arial Black", g_color_600);
      ObjectSet("[wyfxco.com]legend1" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]legend1" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4640);
      ObjectSet("[wyfxco.com]legend1" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + li_4644);
      ObjectSet("[wyfxco.com]legend1" + NitroMagicNumber, OBJPROP_ANGLE, 90);
      ObjectCreate("[wyfxco.com]legend2" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]legend2" + NitroMagicNumber, "GLOBAL %", 8, "Arial Black", g_color_596);
      ObjectSet("[wyfxco.com]legend2" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]legend2" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + li_4648);
      ObjectSet("[wyfxco.com]legend2" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + li_4652);
      ObjectSet("[wyfxco.com]legend2" + NitroMagicNumber, OBJPROP_ANGLE, 90);
      ObjectCreate("[wyfxco.com]copyright" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
      ObjectSetText("[wyfxco.com]copyright" + NitroMagicNumber, "�2010 www.wyfxco.com", 8, "Arial Narrow", Silver);
      ObjectSet("[wyfxco.com]copyright" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
      ObjectSet("[wyfxco.com]copyright" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 4);
      ObjectSet("[wyfxco.com]copyright" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 126);
      if (ShowPrice) {
         ObjectCreate("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
         ObjectSetText("[wyfxco.com]NITRO_Price" + NitroMagicNumber, l_dbl2str_4724, 18, "Arial Black", l_color_4492);
         ObjectSet("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
         ObjectSet("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 108);
         ObjectSet("[wyfxco.com]NITRO_Price" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 1);
      }
      if (ShowSymbolInFullMode) {
         ObjectCreate("[wyfxco.com]symbol" + NitroMagicNumber, OBJ_LABEL, g_window_100, 0, 0);
         ObjectSetText("[wyfxco.com]symbol" + NitroMagicNumber, l_text_4608, 15, "Arial Black", SymbolColor);
         ObjectSet("[wyfxco.com]symbol" + NitroMagicNumber, OBJPROP_CORNER, l_corner_4636);
         ObjectSet("[wyfxco.com]symbol" + NitroMagicNumber, OBJPROP_XDISTANCE, X_box + 2);
         ObjectSet("[wyfxco.com]symbol" + NitroMagicNumber, OBJPROP_YDISTANCE, Y_box + 4);
      }
   }
   return (0);
}

int Lookup(double ad_0) {
   int li_ret_8;
   int lia_12[10] = {0, 3, 10, 25, 40, 50, 60, 75, 90, 97};
   if (ad_0 <= lia_12[0]) li_ret_8 = 0;
   else {
      if (ad_0 < lia_12[1]) li_ret_8 = 0;
      else {
         if (ad_0 < lia_12[2]) li_ret_8 = 1;
         else {
            if (ad_0 < lia_12[3]) li_ret_8 = 2;
            else {
               if (ad_0 < lia_12[4]) li_ret_8 = 3;
               else {
                  if (ad_0 < lia_12[5]) li_ret_8 = 4;
                  else {
                     if (ad_0 < lia_12[6]) li_ret_8 = 5;
                     else {
                        if (ad_0 < lia_12[7]) li_ret_8 = 6;
                        else {
                           if (ad_0 < lia_12[8]) li_ret_8 = 7;
                           else {
                              if (ad_0 < lia_12[9]) li_ret_8 = 8;
                              else li_ret_8 = 9;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
   return (li_ret_8);
}

int DelUnauthorized() {
   ObjectDelete("_Alert1");
   ObjectDelete("_Alert2");
   ObjectDelete("_Alert3");
   ObjectDelete("_Alert4");
   return (0);
}
