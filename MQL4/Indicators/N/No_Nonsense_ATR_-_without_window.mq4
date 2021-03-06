//+------------------------------------------------------------------+
//|                             No Nonsense ATR - without_window.mq4 |
//|                                   Based on No Nonsense ATR V4.33 |
//|          Developed by rpsreal - PORTUGAL - 5/2019 - Version 1.23 |
//|                                        V1.23     PORTUGAL 5/2019 |
//|                                                                  |
//| Filter ATR is based on:                                          |
//|                      FilteredATR.mq4 Developed by vitelot 1/2019 |
//|                                                                  |
//| Disclaimer:                             No warranties are given! |
//| By using the No Nonsense ATR indicator you agree that the        |
//| programer will not be held liable for any losses that            |
//| may be incured, or any faults or bugs that may be encountered    |
//| whilst using the No Nonsense ATR indicator.                      |
//|                                                                  |
//|         Licence:        Attribution 4.0 International (CC BY 4.0)|
//|                     https://creativecommons.org/licenses/by/4.0/ |
//+------------------------------------------------------------------+
#property strict
#property version   "1.23"
#property link      "https://nononsenseforex.com/"
#property copyright "Developed by rpsreal - PORTUGAL - 5/2019 - Version 1.23"
#property description "The ATR Indicator for the NNF Traders"
#property description " "
#property description "Licence:        Attribution 4.0 International (CC BY 4.0) https://creativecommons.org/licenses/by/4.0/"
#property description " "
#property description "Disclaimer:  By using the No Nonsense ATR indicator you agree that the programer will not be held liable for any losses that may be incured, or any faults or bugs that may be encountered whilst using the No Nonsense ATR indicator."
#property description "No warranties are given!"

#property indicator_chart_window       // Indicator is drawn in the main window
#property indicator_buffers 2          // Number of buffers
#property indicator_color1 CLR_NONE    // SL Color sem cor
#property indicator_color2 CLR_NONE    // TP Color sem cor

//---- input parameters
input int        ATR_TP_PERIOD        = 14;         // TP ATR PERIOD       
input double     ATR_TP_MULTIPLIER    = 1;          // TP MULTIPLIER            
input int        ATR_SL_PERIOD        = 14;         // SL ATR PERIOD  
input double     ATR_SL_MULTIPLIER    = 1.5;        // SL MULTIPLIER 
input char       ATR_SHIFT            = 0;          // ATR SHIFT
input int        ATR_digits           = 0;          // Nº OF DIGITS TO THE RIGHT OF a DECIMAL POINT
extern string     desc0               = "==========================";  //===================================
input bool       FILTER_ATR           = False;      // FILTER ATR?
input double     SD_multi             = 3;          // STANDARD DEVIATION MULTIPLIER
input int        sample_size          = 200;        // SAMPLE SIZE
extern string     desc1               = "==========================";  //===================================
input bool       SHOW_CORNER_TEXT     = True;       // SHOW CORNER TEXT?
input char       text_corner          = 0;          // TEXT CORNER 0-UL 1-UR 2-LL 3-LR
input int        text_size            = 14;         // FONT SIZE
input color      text_color           = Gold;       // TEXT COLOR
input bool       text_background      = True;       // SHOW CORNER TEXT BACKGROUND?
input color      solid_color          = Black;      // BACKGROUND COLOR
extern string     desc2               = "==========================";  //===================================
input bool       CLICK_TO_PAUSE       = True;       // MOUSE CLICK TO HOLD TEXT?
input bool       SHOW_LINES_ON_CLICK  = True;       // SHOW TP/SL LINES ON CLICK?
input int        tp_line_size         = 0;          // TP LINE SIZE
input color      tp_line_color        = DeepSkyBlue;// TP LINE COLOR
input int        sl_line_size         = 0;          // SL LINE SIZE
input color      sl_line_color        = Red;        // SL LINE COLOR
extern string     desc3               = "==========================";  //===================================
input bool       HOLD_TEXT            = True;       // SHOW HISTORY VALUES IN CORNER TEXT?
input int        n_of_bars            = 500;        // N OF HISTORY BARS



double NNF_SL[],NNF_TP[];
char user_mouseclick=0;
int barstocursor=0;
double SL, TP;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
   SetIndexBuffer(0,NNF_SL);         // Assigning an array to a buffer
   SetIndexLabel(0,"SL");
   SetIndexBuffer(1,NNF_TP);         // Assigning an array to a buffer
   SetIndexLabel(1,"TP");
   
   if(SHOW_CORNER_TEXT==True){
      
      if(text_background==True){
         //https://www.mql5.com/en/forum/130520 https://www.mql5.com/en/forum/208082
         ObjectCreate("NO_NONSENSE_ATR_RECT", OBJ_LABEL, 0, 0, 0, 0 ,0);
         ObjectSetText("NO_NONSENSE_ATR_RECT", "gggggg", text_size*2, "Webdings", solid_color);
         ObjectSet("NO_NONSENSE_ATR_RECT", OBJPROP_CORNER, text_corner);
         ObjectSet("NO_NONSENSE_ATR_RECT", OBJPROP_XDISTANCE, 0);
         ObjectSet("NO_NONSENSE_ATR_RECT", OBJPROP_YDISTANCE, 5+text_size);
         ObjectSet("NO_NONSENSE_ATR_RECT", OBJPROP_BACK, false);
      }
   
      ObjectCreate("NO_NONSENSE_ATR", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("NO_NONSENSE_ATR"," No Nonsense ATR",text_size, "Verdana", text_color);
      ObjectSet("NO_NONSENSE_ATR", OBJPROP_CORNER, text_corner);
      ObjectSet("NO_NONSENSE_ATR", OBJPROP_XDISTANCE, 0);
      ObjectSet("NO_NONSENSE_ATR", OBJPROP_YDISTANCE, 5+text_size);
      
      ObjectCreate("NO_NONSENSE_ATR_FIXED", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("NO_NONSENSE_ATR_FIXED","",text_size, "Verdana", text_color);
      ObjectSet("NO_NONSENSE_ATR_FIXED", OBJPROP_CORNER, text_corner);
      ObjectSet("NO_NONSENSE_ATR_FIXED", OBJPROP_XDISTANCE, 0);
      ObjectSet("NO_NONSENSE_ATR_FIXED", OBJPROP_YDISTANCE, 5+text_size*2+text_size/4); // distancia relativa ao tamanho do texto
   
   }
   
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,1); // enable CHART_EVENT_MOUSE_MOVE messages

   
   return(INIT_SUCCEEDED);
}
 

 
 
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit(){
   ObjectDelete("NO_NONSENSE_ATR"); // apagar objetos
   ObjectDelete("NO_NONSENSE_ATR_FIXED");
   ObjectDelete("NO_NONSENSE_ATR_RECT");
   
   ObjectDelete("NO_NONSENSE_ATR_ORDER_LINE");
   ObjectDelete("NO_NONSENSE_ATR_TP_LINE_BUY");
   ObjectDelete("NO_NONSENSE_ATR_TP_TEXT_BUY");
   ObjectDelete("NO_NONSENSE_ATR_TP_LINE_SELL");
   ObjectDelete("NO_NONSENSE_ATR_TP_TEXT_SELL");
   
   ObjectDelete("NO_NONSENSE_ATR_SL_LINE_BUY");
   ObjectDelete("NO_NONSENSE_ATR_SL_TEXT_BUY");
   ObjectDelete("NO_NONSENSE_ATR_SL_LINE_SELL");
   ObjectDelete("NO_NONSENSE_ATR_SL_TEXT_SELL");
   return(0);
}



//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

   if (n_of_bars>Bars){ // tratar erro
      Alert("The N OF HISTORY BARS can not be higher than the number of candles available in the chart (",Bars,")!");
   }
   if(FILTER_ATR==false){
      for(int i=0; i<n_of_bars-ATR_SHIFT; i++) {
         NNF_TP[i]=NormalizeDouble(((iATR(NULL,0,ATR_TP_PERIOD,ATR_SHIFT+i)/Point)/10)*ATR_TP_MULTIPLIER,ATR_digits);
         NNF_SL[i]=NormalizeDouble(((iATR(NULL,0,ATR_SL_PERIOD,ATR_SHIFT+i)/Point)/10)*ATR_SL_MULTIPLIER,ATR_digits);
      }
   }else{
      int limit;
      if (sample_size>n_of_bars){ // tratar erro
         Alert("The SAMPLE SIZE can not be higher than N OF HISTORY BARS!");
      }
      if(ATR_TP_PERIOD>=ATR_SL_PERIOD){ // Calcula mais valores do que são necessarios de modo a mostrar apenas os valores corretos 
         limit=n_of_bars+sample_size+ATR_TP_PERIOD;
      }else{
         limit=n_of_bars+sample_size+ATR_SL_PERIOD;
      }
      if (limit>=Bars){ // tratar erro
         Alert("There must be at least ",limit," candles available to calculate the filtered ATR! Candles available in the chart = ",Bars,".");
      }
      
      double         atr_1[];
      double         atr_medio[];
      double         atr_sd[];
      double         filted_atr[];
      
      ArrayResize(atr_1,Bars);
      ArrayResize(atr_medio,Bars);
      ArrayResize(atr_sd,Bars);
      ArrayResize(filted_atr,0);
      
      for(int i=0; i<Bars; i++) {
         atr_medio[i] = iATR(NULL, 0, sample_size, i);
         atr_1[i] = iATR(NULL, 0, 1, i);
      }
   
      for(int i=0; i<Bars; i++) {
         atr_sd[i]=iStdDevOnArray(atr_1,limit,sample_size,0,MODE_SMA,i);
      }
   
      for(int i=0; i<limit; i++) {
        ArrayResize(filted_atr,ArraySize(filted_atr)+1);
        if( atr_1[i] > (atr_medio[i] + SD_multi*atr_sd[i]) ){
            filted_atr[i] = atr_medio[i];
            //Print(i," --- ",atr_1[i], " > ", (atr_medio[i] + SD_multi*atr_sd[i]));
        } else { 
            filted_atr[i] = atr_1[i];
        }
      }
   
      for(int i=0; i<n_of_bars-ATR_SHIFT; i++) {
         NNF_TP[i]=NormalizeDouble(((iMAOnArray(filted_atr,limit,ATR_TP_PERIOD,-ATR_TP_PERIOD-ATR_SHIFT,0,limit-i)/Point)/10)*ATR_TP_MULTIPLIER,ATR_digits);
         NNF_SL[i]=NormalizeDouble(((iMAOnArray(filted_atr,limit,ATR_SL_PERIOD,-ATR_SL_PERIOD-ATR_SHIFT,0,limit-i)/Point)/10)*ATR_SL_MULTIPLIER,ATR_digits);
      }
      
      // Calcular historico
      //for(int i=0; i<n_of_bars; i++) {
      //   NNF_TP[i]=calc_TP(i+ATR_SHIFT);
      //   NNF_SL[i]=calc_SL(i+ATR_SHIFT);
      //}
  
   }
   
   



   if(SHOW_CORNER_TEXT==True && user_mouseclick==0 && barstocursor==0){
      string text; 
      
      //TP=calc_TP(ATR_SHIFT);
      //SL=calc_SL(ATR_SHIFT);
      TP=NNF_TP[0]; // mais rapido
      SL=NNF_SL[0];
      
      text=StringConcatenate("\n SL = ", SL, " pips     TP = ",  TP, " pips");  
      
      if(text_background==True){
         string backtext="g";
         for(char x=0;x<(StringLen(text)/4); x++){ // Ajustar background ao texto
            if(IsStopped())
               break;
            StringAdd(backtext,"g");
         }
         ObjectSetText("NO_NONSENSE_ATR_RECT", backtext, text_size*2, "Webdings", solid_color);
      }
      
      ObjectSetText("NO_NONSENSE_ATR",text,text_size, "Verdana", text_color);
   }  

   return(rates_total); //--- return value of prev_calculated for next call
  }
  
  
  
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam){
   if(id==CHARTEVENT_MOUSE_MOVE && HOLD_TEXT==true && user_mouseclick==0){
      
      //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      datetime dt    =0;
      double   price =0;
      int      window=0;
      if(ChartXYToTimePrice(0,x,y,window,dt,price)){
         //PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price);
         
         barstocursor=Bars(NULL, 0, dt, iTime(NULL, 0, 0))-1;
         //Print(barstocursor);
         
         if((barstocursor) >= n_of_bars-ATR_SHIFT){ // nao mostra valores depois do limite
            TP=0;
            SL=0;
         }else{
            TP=NNF_TP[barstocursor]; // mais rapido
            SL=NNF_SL[barstocursor];
         }
         
         
         if(SHOW_CORNER_TEXT==True){
            string text;
            text=StringConcatenate("\n SL = ", SL, " pips     TP = ",  TP, " pips");  
            if(text_background==True){
               string backtext="g";
               for(char i=0;i<(StringLen(text)/4); i++){ // Ajustar background ao texto
                  if(IsStopped())
                     break;
                  StringAdd(backtext,"g");
               }
               ObjectSetText("NO_NONSENSE_ATR_RECT", backtext, text_size*2, "Webdings", solid_color);
            }
            ObjectSetText("NO_NONSENSE_ATR",text,text_size, "Verdana", text_color);
         }  
      //}else{
      //   Print("ChartXYToTimePrice return error code: ",GetLastError());
      }
   }
   if(id==CHARTEVENT_CLICK && CLICK_TO_PAUSE==True){
      if(user_mouseclick==0){
         user_mouseclick=1;
         if((barstocursor) >= n_of_bars-ATR_SHIFT){ // nao mostra valores depois do limite
            ObjectSetText("NO_NONSENSE_ATR_FIXED"," -- NO DATA --",text_size, "Verdana", text_color);
         }else{    
            ObjectSetText("NO_NONSENSE_ATR_FIXED"," -- FIXED --",text_size, "Verdana", text_color);
         
            if(SHOW_LINES_ON_CLICK==True && CLICK_TO_PAUSE==True){// -- desenhar linhas
            
               ObjectCreate("NO_NONSENSE_ATR_ORDER_LINE", OBJ_TREND, 0, Time[barstocursor+1], Close[barstocursor], Time[barstocursor], Close[barstocursor]);
               ObjectSet("NO_NONSENSE_ATR_ORDER_LINE", OBJPROP_WIDTH, 0);
               ObjectSet("NO_NONSENSE_ATR_ORDER_LINE", OBJPROP_COLOR, text_color);
               ObjectSet("NO_NONSENSE_ATR_ORDER_LINE", OBJPROP_RAY_RIGHT, 0);
               
               ObjectCreate("NO_NONSENSE_ATR_TP_LINE_BUY", OBJ_TREND, 0, Time[barstocursor+1], Close[barstocursor] + TP * 10 * Point, Time[barstocursor], Close[barstocursor]+ TP *10 * Point);
               ObjectCreate("NO_NONSENSE_ATR_SL_LINE_BUY", OBJ_TREND, 0, Time[barstocursor+1], Close[barstocursor] - SL * 10 * Point, Time[barstocursor], Close[barstocursor]- SL *10 * Point);
                  
               ObjectCreate("NO_NONSENSE_ATR_TP_LINE_SELL", OBJ_TREND, 0, Time[barstocursor+1], Close[barstocursor] - TP * 10 * Point, Time[barstocursor], Close[barstocursor]- TP *10 * Point);
               ObjectCreate("NO_NONSENSE_ATR_SL_LINE_SELL", OBJ_TREND, 0, Time[barstocursor+1], Close[barstocursor] + SL * 10 * Point, Time[barstocursor], Close[barstocursor]+ SL *10 * Point);
   
               
               ObjectSet("NO_NONSENSE_ATR_TP_LINE_BUY", OBJPROP_WIDTH, tp_line_size);
               ObjectSet("NO_NONSENSE_ATR_TP_LINE_BUY", OBJPROP_COLOR, tp_line_color);
               ObjectSet("NO_NONSENSE_ATR_TP_LINE_BUY", OBJPROP_RAY_RIGHT, 1);
               ObjectCreate("NO_NONSENSE_ATR_TP_TEXT_BUY", OBJ_TEXT, 0, Time[barstocursor], Close[barstocursor] + TP * 10 * Point);
               ObjectSetText("NO_NONSENSE_ATR_TP_TEXT_BUY","  BUY TP",10, "Verdana", tp_line_color);
               
               ObjectSet("NO_NONSENSE_ATR_TP_LINE_SELL", OBJPROP_WIDTH, tp_line_size);
               ObjectSet("NO_NONSENSE_ATR_TP_LINE_SELL", OBJPROP_COLOR, tp_line_color);
               ObjectSet("NO_NONSENSE_ATR_TP_LINE_SELL", OBJPROP_RAY_RIGHT, 1);
               ObjectCreate("NO_NONSENSE_ATR_TP_TEXT_SELL", OBJ_TEXT, 0, Time[barstocursor], Close[barstocursor] - TP * 10 * Point);
               ObjectSetText("NO_NONSENSE_ATR_TP_TEXT_SELL","  SELL TP",10, "Verdana", tp_line_color);
   
               
               ObjectSet("NO_NONSENSE_ATR_SL_LINE_BUY", OBJPROP_WIDTH, sl_line_size);
               ObjectSet("NO_NONSENSE_ATR_SL_LINE_BUY", OBJPROP_COLOR, sl_line_color);
               ObjectSet("NO_NONSENSE_ATR_SL_LINE_BUY", OBJPROP_RAY_RIGHT, 1);
               ObjectCreate("NO_NONSENSE_ATR_SL_TEXT_BUY", OBJ_TEXT, 0, Time[barstocursor], Close[barstocursor] - SL * 10 * Point);
               ObjectSetText("NO_NONSENSE_ATR_SL_TEXT_BUY","  BUY SL",10, "Verdana", sl_line_color);
               
               ObjectSet("NO_NONSENSE_ATR_SL_LINE_SELL", OBJPROP_WIDTH, sl_line_size);
               ObjectSet("NO_NONSENSE_ATR_SL_LINE_SELL", OBJPROP_COLOR, sl_line_color);
               ObjectSet("NO_NONSENSE_ATR_SL_LINE_SELL", OBJPROP_RAY_RIGHT, 1);
               ObjectCreate("NO_NONSENSE_ATR_SL_TEXT_SELL", OBJ_TEXT, 0, Time[barstocursor], Close[barstocursor] + SL * 10 * Point);
               ObjectSetText("NO_NONSENSE_ATR_SL_TEXT_SELL","  SELL SL",10, "Verdana", sl_line_color);
               
            }
         
         }
         
         

         
      }else{
         user_mouseclick=0;
         ObjectSetText("NO_NONSENSE_ATR_FIXED","",text_size, "Verdana", text_color);
         
         if(SHOW_LINES_ON_CLICK==True && CLICK_TO_PAUSE==True){   // -- apagar linhas
            ObjectDelete("NO_NONSENSE_ATR_ORDER_LINE");
         
            ObjectDelete("NO_NONSENSE_ATR_TP_LINE_BUY");
            ObjectDelete("NO_NONSENSE_ATR_TP_TEXT_BUY");
            ObjectDelete("NO_NONSENSE_ATR_TP_LINE_SELL");
            ObjectDelete("NO_NONSENSE_ATR_TP_TEXT_SELL");
            
            ObjectDelete("NO_NONSENSE_ATR_SL_LINE_BUY");
            ObjectDelete("NO_NONSENSE_ATR_SL_TEXT_BUY");
            ObjectDelete("NO_NONSENSE_ATR_SL_LINE_SELL");
            ObjectDelete("NO_NONSENSE_ATR_SL_TEXT_SELL");
         }
         
      }
   }
   
   
}
//+------------------------------------------------------------------+
