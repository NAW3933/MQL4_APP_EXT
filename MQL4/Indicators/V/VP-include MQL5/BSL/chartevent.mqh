/*
Copyright 2020 FXcoder

This file is part of VP.

VP is free software: you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

VP is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with VP. If not, see
http://www.gnu.org/licenses/.
*/

// Свойства события графика OnChartEvent. Better Standard Library. © FXcoder

#property strict

#include "type/uncopyable.mqh"
#include "util/math.mqh"
#include "util/time.mqh"
#include "chart.mqh"

class CBChartEvent: public CBUncopyable
{
private:

	static int    id_;
	static long   lparam_;
	static double dparam_;
	static string sparam_;

	// время предыдущего клика в мс для определения двойного клика
	static long            chart_dbl_click_prev_click_time_msc_;
	static string          chart_dbl_click_prev_symbol_;
	static ENUM_TIMEFRAMES chart_dbl_click_prev_period_;


public:

	static long   lparam() { return(lparam_); }
	static double dparam() { return(dparam_); }
	static string sparam() { return(sparam_); }

	static void init(const int id, const long &lparam, const double &dparam, const string &sparam)
	{
		id_ = id;
		lparam_ = lparam;
		dparam_ = dparam;
		sparam_ = sparam;
	}

	static bool is_click_event()        { return(id_ == CHARTEVENT_CLICK); }
	static bool is_chart_change_event() { return(id_ == CHARTEVENT_CHART_CHANGE); }

	// вызов должен производиться только из одного места
	static bool is_double_click_event(int gap_msc = 333)
	{
		if (!is_click_event())
			return(false);

		long time = _time.tick_count_long();

		//if (time == chart_dbl_click_prev_click_time_msc_)
		//	return(false);

		bool res = time - chart_dbl_click_prev_click_time_msc_ <= gap_msc;
		// без этого нельзя располагать переключатели символов или таймфреймов в зонах двойного клика
		res = res && (chart_dbl_click_prev_symbol_ == _Symbol);
		res = res && (chart_dbl_click_prev_period_ == _Period);

		chart_dbl_click_prev_click_time_msc_ = time;
		chart_dbl_click_prev_symbol_ = _Symbol;
		chart_dbl_click_prev_period_ = (ENUM_TIMEFRAMES)_Period;
		return(res);
	}


	static bool is_mouse_move_event()
	{
		return(id_ == CHARTEVENT_MOUSE_MOVE);
	}

	static bool is_mouse_move_event(int &mouse_x, int &mouse_y)
	{
		if (!is_mouse_move_event())
			return(false);

		mouse_x = CBChartEvent::mouse_x();
		mouse_y = CBChartEvent::mouse_y();
		return(true);
	}

	// mouse_y will be relative to window
	static bool is_mouse_move_event(int window, int &mouse_x, int &mouse_y)
	{
		if (!is_mouse_move_event())
			return(false);

		mouse_x = CBChartEvent::mouse_x();
		if (!_math.is_in_range(mouse_x, 0, _chart.width_in_pixels() - 1))
			return(false);

		mouse_y = CBChartEvent::mouse_y(window);
		if (!_math.is_in_range(mouse_y, 0, _chart.height_in_pixels(window) - 1))
			return(false);

		return(true);
	}

	static bool is_custom_event()
	{
		return(_math.is_in_range(id_, (int)CHARTEVENT_CUSTOM, (int)CHARTEVENT_CUSTOM_LAST));
	}

	static bool is_custom_event(int event_n)
	{
		int check_id = CHARTEVENT_CUSTOM + event_n;
		return((check_id == id_) && _math.is_in_range(check_id, (int)CHARTEVENT_CUSTOM, (int)CHARTEVENT_CUSTOM_LAST));
	}

	// подразумеваются все действия, изменяющие координаты, включая создание и удаление объекта
	static bool is_object_move_event()
	{
		return
		(
			(id_ == CHARTEVENT_OBJECT_CREATE) ||
			(id_ == CHARTEVENT_OBJECT_CHANGE) ||
			(id_ == CHARTEVENT_OBJECT_DRAG)   ||
			(id_ == CHARTEVENT_OBJECT_DELETE)
		);
	}

	// подразумеваются все действия, изменяющие координаты, включая создание и удаление объекта
	static bool is_object_move_event(string name)
	{
		return(is_object_move_event() && (sparam_ == name));
	}

	static bool is_key_down_event()
	{
		return(id_ == CHARTEVENT_KEYDOWN);
	}

	static bool is_key_down_event(ushort key)
	{
		return(is_key_down_event() && (key == lparam_));
	}

	static bool is_object_click_event()
	{
		return(id_ == CHARTEVENT_OBJECT_CLICK);
	}

	static bool is_object_click_event(string name)
	{
		return(is_object_click_event() && (sparam_ == name));
	}

	static bool is_object_click_event_prefix(string prefix)
	{
		if (!is_object_click_event())
			return(false);

		return((prefix == "") ? true : _str.starts_with(sparam_, prefix));
	}


	static int mouse_x() { return(int(lparam_)); }
	static int mouse_y() { return(int(dparam_)); }

	static int mouse_y(int window)
	{
		return(int(dparam_) - _chart.window_y_distance(window));
	}

	static ushort key()
	{
		return(ushort(lparam_));
	}

	static string key_string()
	{
		return(::ShortToString(CBChartEvent::key()));
	}

	// -1 в случае ошибки
	static int custom_event_n()
	{
		return(is_custom_event() ? (id_ - CHARTEVENT_CUSTOM) : -1);
	}
};

int      CBChartEvent::id_     = 0;
long     CBChartEvent::lparam_ = 0;
double   CBChartEvent::dparam_ = 0.0;
string   CBChartEvent::sparam_ = "";

long               CBChartEvent::chart_dbl_click_prev_click_time_msc_     = 0;
string             CBChartEvent::chart_dbl_click_prev_symbol_             = "";
ENUM_TIMEFRAMES    CBChartEvent::chart_dbl_click_prev_period_             = PERIOD_CURRENT;

CBChartEvent _chartevent;
