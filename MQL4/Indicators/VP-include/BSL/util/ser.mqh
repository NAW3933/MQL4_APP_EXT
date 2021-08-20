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

// Функции серий, исторических данных. Better Standard Library. © FXcoder
// В отличие от класса CBSeries, здесь общие функции без привязки к символу или таймфрейму.

//TODO: возможно, следует изменить логику is_new_bar, запоминая также и точное время
//      (если оно то же самое, то считать это повторным вызовом на том же новом баре)


#property strict

#include "../type/uncopyable.mqh"
#include "tf.mqh"

class CBSeriesUtil: public CBUncopyable
{
private:

	static datetime prev_open_time_;


public:

	static bool is_new_bar(datetime time, datetime &prev_open_time)
	{
		time = _time.begin_of_bar(time, PERIOD_CURRENT);

		if (time == prev_open_time)
			return(false);

		prev_open_time = time;
		return(true);
	}

	//todo: оптимизация через сравнение только time/ps вместо (time/ps)*ps
	// uses .prev_open_time_
	static bool is_new_bar(datetime time)
	{
		return(is_new_bar(time, prev_open_time_));
	}

	// uses .prev_open_time_
	static bool is_new_bar()
	{
		return(is_new_bar(::TimeCurrent()));
	}

};

datetime CBSeriesUtil::prev_open_time_ = 0;

CBSeriesUtil _ser;
