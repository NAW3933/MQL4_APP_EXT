//+------------------------------------------------------------------+
//|                                              repaint_checker.mq4 |
//|                                      Copyright 2019, Joshua Chen |
//|                                              iesugrace@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Joshua Chen"
#property link      "iesugrace@gmail.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property description "Check if an indicator repaints, automatically."
#property description "It shall be run on an offline chart, \"DLL imports\" is required."

#import "user32.dll"
    int PostMessageA(int hWnd,int Msg,int wParam,int lParam);
#import

#include <Arrays\ArrayDouble.mqh>

#define WM_COMMAND 0x0111
#define HISTORY_HEADER_SIZE 148
#define OLD_HISTORY_RECORD_SIZE 44
#define NEW_HISTORY_RECORD_SIZE 60
#define OLD_VERSION 400
#define NEW_VERSION 401
#define KEY_LEFT 37
#define KEY_UP 38
#define KEY_RIGHT 39
#define KEY_DOWN 40

struct header {
    int     version;        // database version - 400/401                4 bytes
    char    copyright[64];  // copyright info                            64 bytes
    char    symbol[12];     // symbol name                               12 bytes
    int     period;         // symbol timeframe                          4 bytes
    int     digits;         // the amount of digits after decimal point  4 bytes
    int     timesign;       // timesign of the database creation         4 bytes
    int     last_sync;      // the last synchronization time             4 bytes
    int     unused[13];     // to be used in future                      52 bytes
};

/*
// old format
struct record {
    int     ctm;     // bar start time  4 bytes
    double  open;    // open price      8 bytes
    double  low;     // lowest price    8 bytes
    double  high;    // highest price   8 bytes
    double  close;   // close price     8 bytes
    double  volume;  // tick count      8 bytes
};
*/

// new format
struct record {
    long    ctm;          // bar start time  8 bytes
    double  open;         // open price      8 bytes
    double  high;         // highest price   8 bytes
    double  low;          // lowest price    8 bytes
    double  close;        // close price     8 bytes
    long    volume;       // tick count      8 bytes
    int     spread;       // spread          4 bytes
    long    real_volume;  // real volume     8 bytes
};


// parameters
extern string indicator_id = "SSL";  // id of the indicator
extern int buffer_count = 1;        // how many values the indicator has?
extern int bars_to_check = 100;     // how many bars back in history to check?
extern int timer_interval = 50;    // how fast to draw? (millisecond)
extern bool export_data = false;    // export indicator data?

CArrayDouble *rt_bufs[];
CArrayDouble *hs_bufs[];
record records[];
int idx = 0;
int window_handle;
bool timer_on = false;
bool is_end = false;
bool initialized = false;


int OnInit() {
    if (IsDllsAllowed()==false) {
        Print("|");
        Print("|   DLL call is not allowed, indicator can not run.");
        Print("|");
        return(INIT_FAILED);
    }
    reset(bars_to_check);
    initialized = true;
    return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason) {
    if (initialized)
        release_all_arrays();
}


void release_all_arrays() {
    for (int i = 0; i < buffer_count; i++) {
        delete rt_bufs[i];
        delete hs_bufs[i];
    }
}


void reset(int bars) {
    ArrayResize(rt_bufs, buffer_count);
    ArrayResize(hs_bufs, buffer_count);
    ArrayResize(records, bars_to_check);

    for (int i = 0; i < buffer_count; i++) {
        rt_bufs[i] = new CArrayDouble;
        hs_bufs[i] = new CArrayDouble;
    }

    // copy the last N bars
    copy_last_bars(bars);

    // delete the last N bars from the chart
    delete_last_bars(bars);
    idx = 0;
    is_end = false;

    // feed the first bar
    feed_one_bar();

    // refresh chart
    window_handle = WindowHandle(_Symbol, _Period);
    refresh_chart(window_handle);
}


void step_back() {
    // when step back from the very end
    if (is_end) {
        is_end = false;
        for (int i = 0; i < buffer_count; i++) {
            rt_bufs[i].Delete(idx - 1);
            hs_bufs[i].Clear();
        }
    }

    // delete the last collected values.
    for (int i = 0; i < buffer_count; i++) {
        rt_bufs[i].Delete(idx - 2);
    }

    // delete the latest bar from the chart
    delete_last_bars(1);
    idx--;

    // refresh chart
    window_handle = WindowHandle(_Symbol, _Period);
    refresh_chart(window_handle);
}


void step_forward() {
    // collect indicator data
    collect_data();

    // all processed, stop timer, analyze and report.
    if (idx == bars_to_check) {
        stop_timer();
        analyze();
        is_end = true;
        return;
    }

    feed_one_bar();
    refresh_chart(window_handle);
}


void OnTimer() {
    step_forward();
}


void feed_one_bar() {
    int handle = open_hist_file(_Symbol, _Period);
    FileSeek(handle, 0, SEEK_END);
    FileWriteStruct(handle, records[idx++]);
    FileClose(handle);
}


void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
    if (id == CHARTEVENT_KEYDOWN) {
        if (lparam == KEY_UP) {
            if (!is_running() && is_started()) {
                release_all_arrays();
                reset(fmin(idx, bars_to_check));
            }
        } else if (lparam == KEY_DOWN) {
            if (is_end)
                return;
            if (is_running())
                stop_timer();
            else
                start_timer();
        } else if (lparam == KEY_LEFT) {
            if (is_started() && !is_running()) {
                step_back();
            }
        } else if (lparam == KEY_RIGHT) {
            if (!is_end && !is_running())
                step_forward();
        }
    }
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
    return(rates_total);
}


bool refresh_chart(int hdl) {
    if (! PostMessageA(hdl, WM_COMMAND, 33324, 0)) {
        Print("failed to refresh chart.");
        return false;
    }
    return true;
}


void copy_last_bars(int bars) {
    int hdl, onchart_bars;
    header hdr;
    record all_records[];

    // open history for shared read
    hdl = open_hist_file(_Symbol, _Period, FILE_BIN|FILE_READ|FILE_SHARE_READ);
    FileSeek(hdl, 0, SEEK_SET);

    // read header.
    FileReadStruct(hdl, hdr);

    // we do new format only.
    if (hdr.version != NEW_VERSION) {
        Print("history file format not compatible: ", hdr.version);
        return;
    }

    // read all records
    FileReadArray(hdl, all_records);
    FileClose(hdl);

    onchart_bars = ArraySize(all_records) - bars;
    ArrayCopy(records, all_records, 0, onchart_bars, bars);
}


void delete_last_bars(int bars) {
    int hdl, onchart_bars;
    header hdr;
    record all_records[];

    // open history for shared read
    hdl = open_hist_file(_Symbol, _Period, FILE_BIN|FILE_READ);
    FileSeek(hdl, 0, SEEK_SET);

    // read header.
    FileReadStruct(hdl, hdr);

    // we do new format only.
    if (hdr.version != NEW_VERSION) {
        Print("history file format not compatible: ", hdr.version);
        return;
    }

    // read all records
    FileReadArray(hdl, all_records);
    FileClose(hdl);

    // re-open the history file in exclusive write mode.
    hdl = open_hist_file(_Symbol, _Period, FILE_BIN|FILE_WRITE);

    // write back to the same file in order to delete the last N bars.
    onchart_bars = ArraySize(all_records) - bars;
    FileWriteStruct(hdl, hdr);
    FileWriteArray(hdl, all_records, 0, onchart_bars);
    FileClose(hdl);
}


int open_hist_file(string symbol, int period, int mode=FILE_BIN|FILE_READ|FILE_SHARE_READ|FILE_WRITE|FILE_SHARE_WRITE) {
    string fname = symbol + IntegerToString(period) + ".hst";
    int hdl = FileOpenHistory(fname, mode);
    if (hdl < 1)
        Print("can not open file ", fname);
    return hdl;
}


void collect_data() {
    double val;
    for (int i = 0; i < buffer_count; i++) {
        val = iCustom(NULL, 0, indicator_id, i, 0);
        rt_bufs[i].Add(val);
    }
}


void analyze() {
    int bar_idx, i, j;
    bool repaint = false;
    double val;

    // read the last N bars
    for (i = 0; i < buffer_count; i++) {
        for (j = 0, bar_idx = bars_to_check - 1; j < bars_to_check; j++, bar_idx--) {
            val = iCustom(NULL, 0, indicator_id, i, bar_idx);
            hs_bufs[i].Add(val);
        }
    }

    // compare
    for (i = 0; i < buffer_count; i++) {
        for (j = 0, bar_idx = bars_to_check - 1; j < bars_to_check; j++, bar_idx--) {
            if (rt_bufs[i].At(j) != hs_bufs[i].At(j)) {
                Print("|   repaint buffer #", i + 1, " on bar ", TimeToStr(iTime(NULL, 0, bar_idx), TIME_DATE|TIME_SECONDS),
                      ", ", rt_bufs[i][j], " <--> ", hs_bufs[i][j]);
                repaint = true;
            }
        }
    }

    if (! repaint) {
        Print("|");
        Print("|");
        Print("|   no repaint detected");
        Print("|");
        Print("|");
    }

    // export indicator data
    if (export_data) {
        string fname = "repaint_checker_export_" + IntegerToString(TimeLocal()) + ".csv";
        int ofile = FileOpen(fname, FILE_CSV|FILE_WRITE, ",");

        // write header
        FileWriteString(ofile, "time");
        for (i = 0; i < buffer_count; i++) {
            FileWriteString(ofile, ",b" + IntegerToString(i + 1) + "rt");
            FileWriteString(ofile, ",b" + IntegerToString(i + 1) + "hs");
        }
        FileWriteString(ofile, "\n");

        // write data
        for (j = 0, bar_idx = bars_to_check - 1; j < bars_to_check; j++, bar_idx--) {
            FileWriteString(ofile, TimeToStr(iTime(NULL, 0, bar_idx)));
            for (i = 0; i < buffer_count; i++) {
                FileWriteString(ofile, "," + DoubleToString(rt_bufs[i].At(j)));
                FileWriteString(ofile, "," + DoubleToString(hs_bufs[i].At(j)));
            }
            FileWriteString(ofile, "\n");
        }
        FileClose(ofile);

        Print("|   exported indicator data to file: ", fname);
    }
}


bool is_started() {
    return idx > 1;
}


void stop_timer() {
    EventKillTimer();
    timer_on = false;
}


void start_timer() {
    EventSetMillisecondTimer(timer_interval);
    timer_on = true;
}


bool is_running() {
    return timer_on;
}
