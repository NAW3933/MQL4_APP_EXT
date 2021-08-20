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

// VP calculator. © FXcoder

#property strict

#include "../bsl.mqh"
#include "../s.mqh"

#include "../enum/applied_volume.mqh"
#include "../enum/quantile.mqh"
#include "enum/vp_source.mqh"
#include "enum/vp_tick_price.mqh"
#include "vp_histogram.mqh"

class CVPCalc
{
protected:

	const ENUM_VP_SOURCE data_source_;
	const ENUM_TIMEFRAMES data_period_;
	const ENUM_APPLIED_VOLUME applied_volume_;
	const double point_;
	const double point_inverse_; // inverse for faster calculation

	const ENUM_VP_TICK_PRICE tick_price_type_;
	const int tick_flags_;
	CBSeries *data_ser_;

	double  quantiles_[];
	int     quantiles_count_;


public:

	_GET(ENUM_TIMEFRAMES, data_period)

	void CVPCalc(
		ENUM_VP_SOURCE data_source,
		ENUM_APPLIED_VOLUME applied_volume,
		double point,
		ENUM_VP_TICK_PRICE tick_price_type,
		int tick_flags,
		ENUM_QUANTILE quantiles
	):
		data_source_(data_source),
		data_period_(_tf.find_closest((int)data_source)),
		applied_volume_(applied_volume),
		point_(point),
		point_inverse_(point == 0 ? _math.nan : (1.0 / point)),
		tick_price_type_(tick_price_type),
		tick_flags_(tick_flags)
	{
		data_ser_ = new CBSeries(_Symbol, data_period_);
		quantiles_count_ = EnumQuantileToArray(quantiles, quantiles_);
	}

	void ~CVPCalc()
	{
		_ptr.safe_delete(data_ser_);
	}

	bool get_tick_price(const MqlTick &tick, double &tick_price) const
	{
		if ((tick_flags_ & tick.flags) == 0)
			return(false);

		switch (tick_price_type_)
		{
			case VP_TICK_PRICE_BID:
				tick_price = tick.bid;
				break;

			case VP_TICK_PRICE_ASK:
				tick_price = tick.ask;
				break;

			case VP_TICK_PRICE_LAST:
				tick_price = tick.last;
				break;

			default:
				return(false);
		}

		return(tick_price > 0.0);
	}

	/**
	Get (calculate) histogram by ticks.

	Possible result:
		-1: loading error
		-1: no ticks in history (consider a loading error)
		 0: no filtered ticks
		>0: hg_size
	*/
	int get_hg_by_ticks(datetime time_from, datetime time_to, double &low, double &volumes[]) const
	{
#ifdef __MQL4__
		return(0);
#else
		const long time_from_ms = time_from * 1000;
		const long time_to_ms   = time_to * 1000;

		// COPY_TICKS_ALL because (from MQL's help) "Call of CopyTicks() with the COPY_TICKS_ALL ... in other modes ... do not provide significant speed advantage.",
		//   and was confirmed by tests.
		_err.reset();
		MqlTick ticks[];
		int tick_count = CopyTicksRange(_Symbol, ticks, COPY_TICKS_ALL, time_from_ms, time_to_ms - 1);

		if (tick_count <= 0)
			PRINT_RETURN("CopyTicksRange<=0" + VAR(tick_count) + VAR(time_from) + VAR(time_to), -1);

		// First pass: determine the minimum and maximum, the size of the histogram array.
		// The prices are supposed to be positive.

		int positions[];
		ArrayResize(positions, tick_count);
		ArrayInitialize(positions, -1);

		int pos_max = INT_MIN;
		int pos_min = INT_MAX;

		for (int i = 0; i < tick_count; i++)
		{
			// Sometimes obtained tics are outside the specified range (due to error in the data on the server, for example).
			// In this case, trim the excess. The array itself can be left unchanged; just specify the number of correct ticks.
			// It is assumed that there is no problem of leaving the left border.
			if (ticks[i].time_msc > time_to_ms)
			{
				tick_count = i;
				break;
			}

			double tick_price;
			if (!get_tick_price(ticks[i], tick_price))
				continue;

			const int pos = price_to_points(tick_price);
			positions[i] = pos;

			if (pos < pos_min)
				pos_min = pos;

			if (pos > pos_max)
				pos_max = pos;
		}

		if ((pos_min == INT_MAX) || (pos_max == INT_MIN))
			return(0);

		low = pos_min * point_;

		const int hg_size = pos_max - pos_min + 1; // the number of prices in the histogram
		ArrayResize(volumes, hg_size);
		ArrayInitialize(volumes, 0.0);

		// Collect all ticks in one histogram.

		double total_volume = 0.0;

		for (int i = 0; i < tick_count; i++)
		{
			const int pos = positions[i];

			if (pos < 0)
				continue;

			const int pri = pos - pos_min;

			// If you need a real volume, take it from the tick information.
			// If you need tick volume, then it is enough to take into account each tick exactly once.

			if (applied_volume_ == VOLUME_REAL)
			{
				total_volume += ticks[i].volume_real;
				volumes[pri] += ticks[i].volume_real;
			}
			else
			{
				volumes[pri]++;
			}
		}

		// The broker may not give real volumes for the instrument.
		if ((applied_volume_ == VOLUME_REAL) && (total_volume == 0.0))
			return(0);

		return(hg_size);
#endif
	}

	// Get (calculate) the histogram using bars.
	// Returns -1 on history load error.
	int get_hg(datetime time_from, datetime time_to, double &low, double &volumes[], bool debug = false) const
	{
		_err.reset();

		// Get calculation timeframe bars (usually M1).
		MqlRates rates[];
		const int rate_count = data_ser_.copy_rates(time_from, time_to, rates);

		if (rate_count <= 0)
			return(rate_count);

		//todo: -> mki
		//hack: непонятный баг с запросом вне истории, отдаётся один бар вне запрашиваемой истории
		if ((rate_count == 1) && (rates[0].time > time_to))
			return(-1);

		// Determine the minimum and maximum, the size of the histogram array.
		int low_index = price_to_points(rates[0].low);
		int high_index = price_to_points(rates[0].high);

		for (int i = 1; i < rate_count; i++)
		{
			const int rate_high_index = price_to_points(rates[i].high);
			const int rate_low_index  = price_to_points(rates[i].low);

			if (rate_low_index < low_index)
				low_index = rate_low_index;

			if (rate_high_index > high_index)
				high_index = rate_high_index;
		}

		low = points_to_price(low_index);
		const int hg_size = high_index - low_index + 1; // количество цен в гистограмме
		ArrayResize(volumes, hg_size);
		ArrayInitialize(volumes, 0);

		// Collect all ticks in one histogram.

		int pri, oi, hi, li, ci;
		double dv, v;

		for (int i = 0; i < rate_count; i++)
		{
			// the copying gives speed here due to the frequent use of the rate
			const MqlRates rate = rates[i];

			// relative indexes
			oi = price_to_points(rate.open)  - low_index;
			hi = price_to_points(rate.high)  - low_index;
			li = price_to_points(rate.low)   - low_index;
			ci = price_to_points(rate.close) - low_index;

			v = (applied_volume_ == VOLUME_REAL) ? (double)rate.real_volume : (double)rate.tick_volume;

			// Tick imitation
			if (ci >= oi)
			{
				/* Bull bar */

				// average tick volume
				dv = v / (oi - li + hi - li + hi - ci + 1.0);

				// [open --> low]
				for (pri = oi; pri >= li; pri--)
					volumes[pri] += dv;

				// (low ++> high]
				for (pri = li + 1; pri <= hi; pri++)
					volumes[pri] += dv;

				// (high --> close]
				for (pri = hi - 1; pri >= ci; pri--)
					volumes[pri] += dv;
			}
			else
			{
				/* Bear bar */

				// average tick volume
				dv = v / (hi - oi + hi - li + ci - li + 1.0);

				// [open ++> high]
				for (pri = oi; pri <= hi; pri++)
					volumes[pri] += dv;

				// (high --> low]
				for (pri = hi - 1; pri >= li; pri--)
					volumes[pri] += dv;

				// (low ++> close]
				for (pri = li + 1; pri <= ci; pri++)
					volumes[pri] += dv;
			}
		}

		return(hg_size);
	}

	// Get the time of the first available data
	datetime get_horizon() const
	{
#ifndef __MQL4__
		if (data_source_ == VP_SOURCE_TICKS)
		{
			MqlTick ticks[];
			const int tick_count = CopyTicks(_Symbol, ticks, COPY_TICKS_ALL, 1, 1);

			// If there is no data, return current time + 1 second
			if (tick_count <= 0)
				return(TimeCurrent() + 1);

			return(ticks[0].time);
		}
#endif

		return(data_ser_.time(data_ser_.bars_count() - 1));
	}

//todo: использовать только 1 доп. массив
	// Smooth histogram step by step.
	// There is a faster version of the same algorithm based on the sum of the columns of the Pascal's
	//   pyramid, but it requires working with very large numbers outside the standard data types.
	// The function leaves zero tails, but they will be truncated when displayed.
	void smooth_hg(const int depth, CVPHistogram &hg)
	{
		smooth_hg(depth, hg.point, hg.low_price, hg.volumes);
	}

	void smooth_hg(const int depth, const double hg_point, double &low_price, double &volumes[])
	{
		if (depth <= 0)
			return;

		const int hg_size = ArraySize(volumes);
		const int new_hg_size = hg_size + 2 * (depth + 1);

		// copy and expand hg with zeroes on both sides

		double hg_prev[];
		_arr.resize_fill(hg_prev, new_hg_size, 0.0);

		double hg_next[];
		_arr.resize_fill(hg_next, new_hg_size, 0.0);

		// step by step averaging

		ArrayCopy(hg_prev, volumes, depth + 1, 0);

		// It is necessary to divide by 3 (average) instead of summing up at each step because of the probability of overflow.
		// This constant is for speed.
		const double one_third = 1.0 / 3.0;
		for (int d = 1; d <= depth; d++)
		{
			for (int i = depth + 1 - d, last = depth + 1 + hg_size - 1 + d; i <= last; i++)
				hg_next[i] = (hg_prev[i - 1] + hg_prev[i] + hg_prev[i + 1]) * one_third;

			ArrayCopy(hg_prev, hg_next);
		}

		low_price -= hg_point * (depth + 1);
		_arr.clone(volumes, hg_prev);
	}

	// Индексы квантилей в гистограмме. Смещаются к центру, что может приводить к небольшм искажениям.
	int quantiles_indexes(const double &data[], int &q_indexes[])
	{
		ArrayResize(q_indexes, quantiles_count_);

		for (int i = 0; i < quantiles_count_; ++i)
		{
			double probe = quantiles_[i];
			double pos = quantile_pos(data, probe);

			if (pos == -1)
				q_indexes[i] = -1;
			else if (probe > 0.5)
				q_indexes[i] = (int)floor(pos);
			else // if (probe <= 0.5)
				q_indexes[i] = (int)ceil(pos);
		}

		return(quantiles_count_);
	}

//todo: расчёт сразу всех квантилей
	// Найти позицию квантиля.
	// Может находиться между элементами, метод округления выбирается вызывающей стороной.
	// Это упрощённый и адаптированный метод, использовать только с VP и подобными данными.
	// Для пустого массива вернётся -1.
	double quantile_pos(const double &data[], double probe)
	{
		const int n = ArraySize(data);

		if (probe <= 0)
			return(-0.5);

		if (probe >= 1)
			return(n - 0.5);

		const double sum = _math.sum(data, 0, n);
		const double stop_sum_f = sum * probe;

		// forward
		double index_f = -1;
		double cum_sum_f = 0;

		for (int i = 0; i < n; ++i)
		{
			cum_sum_f += data[i];

			if (cum_sum_f == stop_sum_f)
			{
				index_f = i + 0.5;
				break;
			}

			if (cum_sum_f > stop_sum_f)
			{
				index_f = i - 0.5;
				break;
			}
		}

		if (index_f == -1)
			return(-1);

		const double stop_sum_b = sum * (1.0 - probe);
		double index_b = -1;
		double cum_sum_b = 0;

		// backward

		for (int i = 0; i < n; ++i)
		{
			cum_sum_b += data[n - 1 - i];

			if (cum_sum_b == stop_sum_b)
			{
				index_b = i + 0.5;
				break;
			}

			if (cum_sum_b > stop_sum_b)
			{
				index_b = i - 0.5;
				break;
			}
		}

		if (index_b == -1)
			return(-1);

		index_b = n - 1 - index_b;

		return((index_f + index_b) / 2.0);
	}


protected:

	int price_to_points(const double price) const
	{
		return((int)(price * point_inverse_ + 0.5));
	}

	double points_to_price(const int points) const
	{
		return(points * point_);
	}

};
