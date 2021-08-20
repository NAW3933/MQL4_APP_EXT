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

// VP indicator. © FXcoder

#property strict

#include "../bsl.mqh"
#include "../s.mqh"

#include "../enum/hg_coloring.mqh"
#include "../enum/quantile.mqh"
#include "../class/timer.mqh"
#include "../util/stat.mqh"

#include "enum/vp_mode.mqh"
#include "vp_histogram.mqh"
#include "vp_visual.mqh"
#include "vp_calc.mqh"

#include "vp_period_mode_params.mqh"
#include "vp_range_mode_params.mqh"
#include "vp_data_params.mqh"
#include "vp_tick_params.mqh"
#include "vp_calc_params.mqh"
#include "vp_hg_params.mqh"
#include "vp_levels_params.mqh"
#include "vp_service_params.mqh"


class CVPIndicator
{
protected:

	// input parameters
	const ENUM_VP_MODE         mode_;
	const CVPPeriodModeParams *period_;
	const CVPRangeModeParams  *range_;
	const CVPDataParams       *data_;
	const CVPTickParams       *tick_;
	const CVPCalcParams       *calc_;
	const CVPHgParams         *hg_;
	const CVPLevelsParams     *lvl_;
	const CVPServiceParams    *service_;

	// common
	bool   is_range_mode_;
	ENUM_TIMEFRAMES data_period_;
	string hz_line_name_;
	string prefix_;
	bool   last_ok_;
	int    mode_step_;
	double hg_width_fraction_;

	int     mql_timer_ms_;
	int     update_timer_ms_;
	CTimer *update_timer_;

	// working time limits (period mode only)
	const int    calc_time_limit_ms_;   // calculation time limit, ms
	const int    draw_time_limit_ms_;   // drawing time limit, ms
	bool  wait_for_history_;
	int   wait_for_history_factor_;

	// guaranteed time gap between work, ms
	const int time_gap_ms_;
	long prev_work_end_time_ms_;

	CVPVisual *vpvis_;
	CVPCalc   *vpcalc_;

	// period mode
	int      tz_shift_seconds_;
	int      range_count_;
	datetime draw_history_[];
	double   global_max_volume_;
	// session
	int      session_start_minute_;
	int      session_end_minute_;

	CBDict<datetime, int> *load_counts_;
	int      load_stop_threshold_;

	// range mode
	bool update_on_tick_;

	CVPHistogram *hgs_[];


public:

	void CVPIndicator(
		ENUM_VP_MODE           mode,

		//period
		ENUM_TIMEFRAMES        range_period,
		int                    range_count,
		ENUM_VP_TIME_SHIFT     time_shift,
		ENUM_HG_DIRECTION      draw_direction,
		ENUM_VP_ZOOM           zoom_type,
		double                 zoom_custom,

		// range
		ENUM_VP_RANGE_MODE     range_mode,
		int                    range_minutes,
		ENUM_VP_HG_POSITION    hg_position,

		// data
		ENUM_VP_SOURCE         data_source,
		ENUM_APPLIED_VOLUME    volume_type,

		// tick
		ENUM_VP_TICK_PRICE     tick_price_type,
		bool                   tick_bid,
		bool                   tick_ask,
		bool                   tick_last,
		bool                   tick_volume,
		bool                   tick_buy,
		bool                   tick_sell,

		// calc
		int                    mode_step,
		ENUM_POINT_SCALE       hg_point_scale,
		int                    smooth,

		// hg
		ENUM_VP_BAR_STYLE      hg_bar_style,
		ENUM_HG_COLORING       hg_coloring,
		color                  hg_color,
		color                  hg_color2,
		int                    hg_line_width,
		uint                   hg_width_pct,

		// levels
		color                  mode_color,
		color                  max_color,
		color                  quantile_color,
		color                  vwap_color,
		int                    mode_line_width,
		int                    stat_line_width,
		ENUM_LINE_STYLE        stat_line_style,
		color                  mode_level_color,
		int                    mode_level_width,
		ENUM_LINE_STYLE        mode_level_style,
		ENUM_QUANTILE          quantiles,

		// service
		bool                   show_horizon,
		string                 id
	):
		mode_(mode),
		period_(new CVPPeriodModeParams(range_period, range_count, time_shift,/** session_start, session_end,**/ draw_direction, zoom_type, zoom_custom)),
		range_(new CVPRangeModeParams(range_mode, range_minutes, hg_position)),
		data_(new CVPDataParams(data_source, volume_type)),
		tick_(new CVPTickParams(tick_price_type, tick_bid, tick_ask, tick_last, tick_volume, tick_buy, tick_sell)),
		calc_(new CVPCalcParams(mode_step, hg_point_scale, smooth)),
		hg_(new CVPHgParams(hg_bar_style, hg_coloring, hg_color, hg_color2, hg_line_width, hg_width_pct)),
		lvl_(new CVPLevelsParams(mode_color, max_color, quantile_color, vwap_color, mode_line_width, stat_line_width, stat_line_style, mode_level_color, mode_level_width, mode_level_style, quantiles)),
		service_(new CVPServiceParams(show_horizon, id)),
		calc_time_limit_ms_(400),
		draw_time_limit_ms_(600),
		time_gap_ms_(500)
	{
		// common

		is_range_mode_        = mode == VP_MODE_RANGE;
		data_period_          = PERIOD_M1;
		hz_line_name_         = id + "-" + string((int(data_source))) + "-hz";
		prefix_               = id + (is_range_mode_ ? (" rng:" + EnumVPRangeModeToString(range_mode)) : (" per:" + _tf.to_string(range_period))) + " ";
		last_ok_              = false;
		mode_step_            = mode_step / hg_point_scale;
		hg_width_fraction_    = 0.01 * hg_width_pct;

		mql_timer_ms_         = 111; // built-in timer period (OnTimer), ms
		update_timer_ms_      = is_range_mode_ ? 500 : 1000; // период для таймера обновления (проверяется при любом событии), мс
		update_timer_ = new CTimer(update_timer_ms_, false);

		wait_for_history_     = false; // признак того, что при прошлая загрузка истории не удалась, и надо подождать подольше
		wait_for_history_factor_ = 3;  // коэффициет замедления повторной загрузки истории после неудачи

		vpvis_ = new CVPVisual(id, hg_, lvl_);
		vpcalc_ = new CVPCalc(data_source, volume_type, _Point * hg_point_scale, tick_price_type, tick_.flags(), quantiles);

		// period mode

		tz_shift_seconds_ = 0;
		range_count_        = range_count > 0 ? range_count : 1;
		global_max_volume_ = 0; // global max volume
		load_counts_ = new CBDict<datetime, int>();
		load_stop_threshold_ = 10; // number of attempts before stopping of loading

		// range mode

		update_on_tick_ = true;
	}

	void ~CVPIndicator()
	{
		_ptr.safe_delete(period_);
		_ptr.safe_delete(range_);
		_ptr.safe_delete(data_);
		_ptr.safe_delete(tick_);
		_ptr.safe_delete(calc_);
		_ptr.safe_delete(hg_);
		_ptr.safe_delete(lvl_);
		_ptr.safe_delete(service_);

		_ptr.safe_delete(update_timer_);
		_ptr.safe_delete(vpvis_);
		_ptr.safe_delete(vpcalc_);
		_ptr.safe_delete(load_counts_);
	}


	void init()
	{
		// source's period
		data_period_ = get_data_source_tf(data_.source());

		/* Period mode */

		// shift cannot be more than RangePeriod
		tz_shift_seconds_ = (((int)period_.time_shift() * 60) % PeriodSeconds(period_.tf()));

		// delete range line after switching to period mode
		if (!is_range_mode_)
			vpvis_.delete_range_lines();
	}

	void chart_event()
	{
		if (is_range_mode_)
		{
			// If range lines moved, update histogram
			if (_chartevent.is_object_move_event(vpvis_.line_from().name()) || _chartevent.is_object_move_event(vpvis_.line_to().name()))
			{
		 		check_timer();
			}

			//TODO: выделить случаи, когда нужна перерисовка без перерасчёта
			// Chart changes (scale, position, back color)
			if (_chartevent.is_chart_change_event())
			{
				static int first_visible_bar_prev = 0;
				static int last_visible_bar_prev = 0;

				const int first_visible_bar = _chart.first_visible_bar();
				const int last_visible_bar = _chart.last_visible_bar();

				bool update =
					(first_visible_bar_prev == last_visible_bar_prev) ||
					(
						((first_visible_bar != first_visible_bar_prev) || (last_visible_bar != last_visible_bar_prev)) &&
						((range_.hg_position() == VP_HG_POSITION_CHART_LEFT) || (range_.hg_position() == VP_HG_POSITION_CHART_RIGHT))
					);

				first_visible_bar_prev = first_visible_bar;
				last_visible_bar_prev = last_visible_bar;

				if (vpvis_.update_auto_colors())
				{
					last_ok_ = false;
					check_timer();
				}
				else if (update)
				{
					check_timer();
				}
			}
		}
		else
		{
			if (_chartevent.is_chart_change_event())
			{
				// If chart's back color changed, redraw all histograms
				if (vpvis_.update_auto_colors())
				{
					ArrayFree(draw_history_);
					check_timer();
				}
			}
		}
	}

	int calculate()//const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[])
	{
		if (is_range_mode_)
		{
			if (vpvis_.update_auto_colors())
			{
				// при обновлении цвета фона обновлять сразу, сбросив признак последнего успешного выполнения
				last_ok_ = false;
				check_timer();
			}
			else if (update_on_tick_)
			{
				// обновлять на каждом тике, если выставлен такой признак при анализе правой границы
				check_timer();
			}
		}
		else
		{
			// если цвет фона изменился, перерисовать все гистограммы
			if (vpvis_.update_auto_colors())
				ArrayFree(draw_history_);

			check_timer();
		}

		return(0);
	}

	void timer()
	{
		check_timer();
	}

	void deinit(const int reason)
	{
		// удалить гистограммы и их производные
		_chart.objects_delete_all(prefix_);
		_go[hz_line_name_].del();

		if (is_range_mode_)
		{
			// удалить линии только при явном удалении индикатора с графика
			if (reason == REASON_REMOVE)
				vpvis_.delete_range_lines();
		}
	}


protected:

	/**
	Проверить таймер. Если сработал, обновить индикатор.
	*/
	void check_timer()
	{
		// отложить проверку, если таймер проверяется слишком рано после последней работы
		if (_time.tick_count_long() - prev_work_end_time_ms_ < time_gap_ms_)
		{
			_event.reset_millisecond_timer(mql_timer_ms_);
			return;
		}

		// Выключить резервный таймер
		_event.kill_timer();

		// Если таймер сработал, нарисовать картинку
		if (update_timer_.check())
		{
			// Обновить. В случае неудачи поставить таймер на 3 секунды, чтобы попробовать снова ещё раз.
			// 1 секунды должно быть достаточно для подгрузки последней истории. Иначе всё просто повторится ещё через 1.
			last_ok_ = is_range_mode_ ? update_range() : update();

			int timer_factor = wait_for_history_ ? wait_for_history_factor_ : 1;

			if (!last_ok_)
				_event.reset_millisecond_timer(mql_timer_ms_ * timer_factor);

			_chart.redraw();

			// расчёт и рисование могут быть длительными, лучше перезапустить таймер
			update_timer_.reset(update_timer_ms_ * timer_factor);
		}
		else
		{
			// На случай, если свой таймер больше не будет проверяться, добавить принудительную проверку через 2-4 секунды
			int timer_factor = wait_for_history_ ? wait_for_history_factor_ : 1;
			_event.reset_millisecond_timer(update_timer_ms_ * timer_factor);
		}
	}

//todo: для указанного диапазона времени
	// получить список диапазонов, отсчёт справа налево
	// -1 в случае ошибки
	int get_period_mode_ranges(int count, datetime last_tick_time, datetime &starts[], datetime &ends[])
	{
		_arr.resize(starts, 0, count);
		_arr.resize(ends, 0, count);

		const datetime first_time = _series.first_date();

		if (first_time <= 0)
		{
			PRINT(VAR(first_time) + VAR(_series.bars_count()));
			return(-1);
		}

		const int range_seconds = PeriodSeconds(period_.tf());
		const ENUM_TIMEFRAMES data_tf = period_.tf();

		int real_count = 0;

		// Найти самый правый диапазон, для этого сначала установить значение на предполагаемый первый правый диапазон
		//   со сдвигом, после чего возвращаться назад, пока время не окажется внутри истории.
		datetime start_time = _time.add_bars(_time.begin_of_bar(last_tick_time, data_tf), 1, data_tf) + tz_shift_seconds_;

		while ((real_count < count) && (start_time >= first_time) && (start_time > 0))
		{
			const datetime end_time = start_time + range_seconds - 1;

			// Посчитать число баров между началом и концом. Добавить в список, если есть бары.
			if (_series.bars(start_time, end_time) > 0)
			{
				// скорректировать по реальным барам
				_arr.add(starts, _series.time_to_open_right(start_time));
				_arr.add(ends, _series.time_to_open_right(end_time) - 1);
				real_count++;
			}

			const datetime prev_start_time = start_time;
			start_time = _time.begin_of_bar(start_time, data_tf) + tz_shift_seconds_;

			if (start_time == prev_start_time)
				start_time = _time.add_bars(_time.begin_of_bar(start_time, data_tf), -1, data_tf) + tz_shift_seconds_;

			ASSERT_MSG_RETURN(start_time != 0, VAR(start_time) + VAR(first_time), -1);
			ASSERT_MSG_RETURN(start_time != prev_start_time, VAR(start_time) + VAR(first_time), -1);
		}

		return(real_count);
	}

	string get_period_mode_hg_prefix(datetime range_start)
	{
		return(prefix_ + _time.to_string_format(range_start, "yyMMdd.HHmm") + " ");
	}

	/**
	Update (period mode).
	@return  false on fail.
	*/
	bool update()
	{
		wait_for_history_ = false;

		// Все проверки достаточно быстрые, поэтому можно на случай их провала заранее
		//   выставить время окончания последней работы.
		prev_work_end_time_ms_ = _time.tick_count_long();

		// Составить список диапазонов

		// время последнего тика
		MqlTick tick;
		if (!_symbol.tick(tick))
			return(false);

		const datetime last_tick_time = tick.time;

		datetime ranges_starts[];
		datetime ranges_ends[];
		const int real_range_count = get_period_mode_ranges(range_count_, last_tick_time, ranges_starts, ranges_ends);

		// Удалить гистограммы, которых нет в списке диапазонов

		for (int i = ArraySize(draw_history_) - 1; i >= 0; i--)
		{
			if (!_arr.contains(ranges_starts, draw_history_[i]))
			{
				_chart.objects_delete_all(get_period_mode_hg_prefix(draw_history_[i]));
				_arr.remove(draw_history_, i);
			}
		}
		// полное отсутствие диапазонов считать ошибкой
		if (real_range_count <= 0)
		{
			PRINT("real_range_count < 0");
			return(false);
		}

		// If Zoom=Automatic Zoom (local), limit rightmost histogram to the zero bar
		if (period_.zoom_type() == VP_ZOOM_AUTO_LOCAL)
		{
			if (ranges_ends[0] > tick.time)
				ranges_ends[0] = tick.time;
		}

//todo: для чего? документировать лучше
		// Проверить наличие необходимых котировок

		datetime data_rates[];
		datetime ranges_start = ranges_starts[real_range_count - 1];
		datetime ranges_end = ranges_ends[0];

		if (CopyTime(_Symbol, data_period_, ranges_start, ranges_end, data_rates) <= 0)
		{
			LOG("!CopyTime: " + VAR(ranges_start) + VAR(ranges_end));
			wait_for_history_ = true;
			return(false);
		}

		// Показать горизонт данных - самые старые доступные данные

		datetime horizon = vpcalc_.get_horizon();
		if (service_.show_horizon())
			vpvis_.draw_horizon(hz_line_name_, horizon);

		// Рассчитать гистограммы
		bool total_result = true;
		ArrayResize(hgs_, real_range_count);

		// предварительная инициализация на случай прерывания расчётов
		for (int i = 0; i < real_range_count; i++)
		{
			hgs_[i] = new CVPHistogram();
			hgs_[i].point = _Point * calc_.hg_point_scale();
		}

		CTimer calc_timer(calc_time_limit_ms_);

		for (int i = 0; i < real_range_count; i++)
		{
			CVPHistogram *hg = hgs_[i];

			const datetime range_start = ranges_starts[i];
			const datetime range_end = ranges_ends[i];

			// Границы диапазона

			// do not request inaccessible data
			if (range_end < horizon)
				continue;

			// если гистограмма уже была успешно нарисована, пропустить. Кроме крайней правой.
			if ((i > 0) && (_arr.contains(draw_history_, range_start)))
				continue;

			// если гистограмма превысила порог попыток загрузки, пропустить. Кроме крайней правой.
			if ((i > 0) && (load_counts_.get(range_start, 0) >= load_stop_threshold_))
				continue;

			if (!time_range_to_bars(range_start, range_end, hg.bar_from, hg.bar_to))
			{
				LOG("!vpvis_.time_range_to_bars: " + VAR(range_start) + VAR(range_end) + VAR(hg.bar_from) + VAR(hg.bar_to));
				// в случае ошибки загрузки истории прерваться
				total_result = false;
				wait_for_history_ = true;
				break;
			}

			// префикс для каждой гистограммы свой
			hg.prefix = get_period_mode_hg_prefix(range_start);

			// Расчёт

#ifdef __MQL4__
			const int count = vpcalc_.get_hg(range_start, range_end, hg.low_price, hg.volumes, i == 15);
#else
			const int count = (data_.source() == VP_SOURCE_TICKS)
				? vpcalc_.get_hg_by_ticks   (range_start, range_end, hg.low_price, hg.volumes)
				: vpcalc_.get_hg            (range_start, range_end, hg.low_price, hg.volumes, i == 15);
#endif

//todo: при < 0 проверять на выход за пределы TERMINAL_MAXBARS
			if (count < 0)
			{
				LOG("get_hg / get_hg_by_ticks < 0: " + VAR(range_start) + VAR(range_end));
				// в случае ошибки загрузки истории прерваться
				total_result = false;
				wait_for_history_ = true;
				break;
			}
			else if (count == 0)
			{
				int load_count = load_counts_.get(range_start, 0);

				if (load_count < load_stop_threshold_)
					load_counts_.set(range_start, load_count + 1);

				if (load_count + 1 >= load_stop_threshold_)
					PRINT("BLACKLISTED: " + VAR(range_start) + VAR(range_end));

				LOG("count == 0: " + VAR(load_count) + VAR(range_start) + VAR(range_end));
				continue;
			}

			// Сглаживание

			if (calc_.smooth() > 0)
				vpcalc_.smooth_hg(calc_.smooth(), hg);

			// Параметры отображения

			hg.need_redraw = true;

			// учесть нулевые объёмы всех баров источника
			hg.max_volume = _math.limit_below(_math.max(hg.volumes), 1.0);

			if ((period_.zoom_type() == VP_ZOOM_AUTO_GLOBAL) && (hg.max_volume > global_max_volume_))
				global_max_volume_ = hg.max_volume;

			if (calc_timer.check())
			{
				PRINT("Stopped calculation hg #" + string(i + 1) + " of " + string(real_range_count));
				total_result = false;
				break;
			}
		}

		// Отображение. Отдельно от расчётов, т.к. может быть нужно значение максимального максимума (global_max_volume_)

		CTimer draw_timer(draw_time_limit_ms_);

		for (int i = 0; i < real_range_count; i++)
		{
			CVPHistogram *hg = hgs_[i];
			if (!hg.need_redraw)
				continue;

			// Удалить старую гистограмму с графика
			_chart.objects_delete_all(hg.prefix);

			const datetime range_start = ranges_starts[i];
			const datetime range_end = ranges_ends[i];

			if (load_counts_.get(range_start, 0) >= load_stop_threshold_)
				continue;

			// Уровни

			hg.mode_count  = vpvis_.show_modes()  ? hg_modes(hg.volumes, mode_step_, hg.modes)  : -1;
			hg.max_pos     = vpvis_.show_max()    ? _arr.max_index(hg.volumes)               : -1;
			hg.vwap_pos    = vpvis_.show_vwap()   ? hg_vwap_index(hg.volumes, hg.low_price, hg.point) : -1;
			vpcalc_.quantiles_indexes(hg.volumes, hg.quantiles);

			// Масштаб и направление

			double zoom = period_.zoom_custom();

			if (hg_.bar_style == VP_BAR_STYLE_COLOR)
			{
				zoom = 1.0;
			}
			else
			{
				if (period_.zoom_type() == VP_ZOOM_AUTO_GLOBAL)
				{
					zoom = (hg.bar_from - hg.bar_to) / global_max_volume_;
				}
				else if (period_.zoom_type() == VP_ZOOM_AUTO_LOCAL)
				{
					zoom = (hg.bar_from - hg.bar_to) / hg.max_volume;
				}
			}

			zoom *= hg_width_fraction_;

			if (period_.draw_direction() == HG_DIRECTION_LEFT)
				swap(hg.bar_from, hg.bar_to);

			// Нарисовать гистограмму и добавить гистограмму в список выполненных, если её правая граница левее текущего тика

			if ((vpvis_.draw_hg(hg, zoom, global_max_volume_)) && (range_end < last_tick_time))
				_arr.set(draw_history_, range_start);

			//_go[hg.prefix + " hg.start"].create(OBJ_VLINE, 0, range_start, 0.0).back(false).text(_time.to_string(range_start) + " [" + (string)i + "]");
			//_go[hg.prefix + " hg.start"].selectable(true).style(STYLE_DASH);

			if (draw_timer.check())
			{
				PRINT("Stopped drawing hg #" + string(i + 1) + " of " + string(real_range_count));
				total_result = false;
				break;
			}
		}

		_ptr.safe_delete_array(hgs_);

		prev_work_end_time_ms_ = _time.tick_count_long();
		return(total_result);
	}

	bool get_range_mode_range(datetime &time_from, datetime &time_to)
	{
		if (range_.sel_mode() == VP_RANGE_MODE_BETWEEN_LINES)  // между двух линий
		{
			// найти линии границ
			time_from = vpvis_.line_from().time1();
			time_to = vpvis_.line_to().time1();

			if ((time_from == 0) || (time_to == 0))
			{
				// если границы диапазона не заданы, установить их заново в видимую часть экрана
				const datetime time_left  = _series.time(_chart.first_visible_bar(), false);
				const datetime time_right = _series.time(_chart.last_visible_bar(), false);
				ulong time_range = time_right - time_left;

				time_from = (datetime)(time_left + time_range / 3);
				time_to = (datetime)(time_left + time_range * 2 / 3);

				// нарисовать линии
				vpvis_.draw_range_lines(time_from, time_to);
			}

			vpvis_.enable_range_lines();

			// если линии перепутаны местами, поменять местами времена начала и конца
			if (time_from > time_to)
				swap(time_from, time_to);
		}
		else if (range_.sel_mode() == VP_RANGE_MODE_MINUTES_TO_LINE)  // от правой линии range_.range_minutes() минут
		{
			// найти правую линию
			time_to = vpvis_.line_to().time1();
			int bar;

			if (time_to == 0)
			{
				// если линии нет, установить его в видимую часть экрана
				const int left_bar = _chart.first_visible_bar();
				const int right_bar = _chart.last_visible_bar();
				const int bar_range = left_bar - right_bar;

				bar = fmax(0, left_bar - bar_range / 3);
				time_to = _series.time(bar, false);
			}
			else
			{
				bar = _series.bar_shift(time_to);
			}

			bar += range_.minutes() / _tf.current_minutes;
			time_from = _series.time(bar, false);

			vpvis_.draw_line_from(time_from);

//todo: лишняя проверка?
			// нарисовать левую границу и отключить возможность её выделения
			if (!vpvis_.line_to().exists())
			{
				vpvis_.draw_line_to(time_to);
			}

			vpvis_.disable_line_from();
			vpvis_.enable_line_to();
		}
		else if (range_.sel_mode() == VP_RANGE_MODE_LAST_MINUTES)
		{
			CBSeries m1_ser(_Symbol, PERIOD_M1);
			time_from = m1_ser.time(range_.minutes() - 1, false);
			time_to = m1_ser.time(-1, false);

			// удалить линии границ
			vpvis_.delete_range_lines();
		}
		else
		{
			return(false);
		}

		return true;
	}

	/**
	Update (range mode).
	@return  false on fail (no rates, wrong params).
	*/
	bool update_range()
	{
		// Все проверки достаточно быстрые, поэтому можно на случай их провала заранее
		//   выставить время окончания последней работы.
		prev_work_end_time_ms_ = _time.tick_count_long();

		// delete old hg
		_chart.objects_delete_all(prefix_);

		// calc work range
		datetime time_from, time_to;
		if (!get_range_mode_range(time_from, time_to))
			return(false);

		// source data's horizon
		if (service_.show_horizon())
			vpvis_.draw_horizon(hz_line_name_, vpcalc_.get_horizon());


		// Calculate

		CVPHistogram hg;
		hg.point = _Point * calc_.hg_point_scale();

#ifdef __MQL4__
		const int count = vpcalc_.get_hg(time_from, time_to - 1, hg.low_price, hg.volumes);
#else
		const int count = (data_.source() == VP_SOURCE_TICKS)
			? vpcalc_.get_hg_by_ticks   (time_from, time_to - 1, hg.low_price, hg.volumes)
			: vpcalc_.get_hg            (time_from, time_to - 1, hg.low_price, hg.volumes);
#endif

		if (count <= 0)
		{
			prev_work_end_time_ms_ = _time.tick_count_long();
			return(false);
		}

		// Smooth
		if (calc_.smooth() != 0)
			vpcalc_.smooth_hg(calc_.smooth(), hg);


		// Levels

		hg.mode_count  = vpvis_.show_modes()  ? hg_modes(hg.volumes, mode_step_, hg.modes)        : -1;
		hg.max_pos     = vpvis_.show_max()    ? _arr.max_index(hg.volumes)                     : -1;
		hg.vwap_pos    = vpvis_.show_vwap()   ? hg_vwap_index(hg.volumes, hg.low_price, hg.point) : -1;
		vpcalc_.quantiles_indexes(hg.volumes, hg.quantiles);

		// учесть нулевые объёмы всех баров источника
		hg.max_volume = _math.limit_below(_math.max(hg.volumes), 1.0);

		// Границы диапазона

		if (!time_range_to_bars(time_from, time_to, hg.bar_from, hg.bar_to))
			return(false);

		// если правая граница правее нулевого бара, то гистограмму обновлять на каждом тике
		update_on_tick_ = hg.bar_to < 0;


		// Определить масштаб. В Range Mode обе автоматики одинаковы, т.к. гг одна

		const int hg_width_in_bars = range_.hg_position_is_inside_range() ? (hg.bar_from - hg.bar_to) : _chart.width_in_bars();

		double zoom = period_.zoom_custom();

		if (hg_.bar_style == VP_BAR_STYLE_COLOR)
		{
			zoom = 1.0;
		}
		else
		{
			zoom = hg_width_in_bars / hg.max_volume;
		}

		if (!range_.hg_position_is_inside_range())
			zoom *= 0.15;

		zoom *= hg_width_fraction_;

		// Скорректировать диапазон баров отображения

		double range_size = (hg_.bar_style == VP_BAR_STYLE_COLOR) ? (hg_width_in_bars) : (zoom * hg.max_volume);

		if (range_.hg_position() == VP_HG_POSITION_CHART_LEFT)
		{
			// левая граница окна [> ¦  ¦  ]
			hg.bar_from = _chart.leftmost_visible_bar();
			hg.bar_to = (int)(hg.bar_from - range_size);
		}
		else if (range_.hg_position() == VP_HG_POSITION_CHART_RIGHT)
		{
			// правая граница окна [  ¦  ¦ <]
			hg.bar_from = _chart.rightmost_visible_bar();
			hg.bar_to = (int)(hg.bar_from + range_size);
		}
		else if (range_.hg_position() == VP_HG_POSITION_LEFT_OUTSIDE)
		{
			// левая граница диапазона влево наружу [  <¦  ¦  ]
			//hg.bar_from = hg.bar_from;
			hg.bar_to = (int)(hg.bar_from + range_size);
		}
		else if (range_.hg_position() == VP_HG_POSITION_RIGHT_OUTSIDE)
		{
			// правая граница диапазона наружу [   ¦  ¦>  ]
			swap(hg.bar_from, hg.bar_to);
			hg.bar_to = (int)(hg.bar_from - range_size);
		}
		else if (range_.hg_position() == VP_HG_POSITION_LEFT_INSIDE)
		{
			// левая граница диапазона влево внутрь [   ¦>  ¦  ]
			//hg.bar_from = hg.bar_from;
			//hg.bar_to = hg.bar_from;
		}
		else //if (range_.hg_position() == VP_HG_POSITION_RIGHT_INSIDE)
		{
			// правая граница диапазона [   ¦ <¦  ]
			swap(hg.bar_from, hg.bar_to);
		}

		// Отображение

		hg.prefix = prefix_;
		vpvis_.draw_hg(hg, zoom, 0);

		prev_work_end_time_ms_ = _time.tick_count_long();
		return(true);
	}

	/**
	Получить таймфрейм источника данных
	*/
	ENUM_TIMEFRAMES get_data_source_tf(const ENUM_VP_SOURCE data_source)
	{
#ifndef __MQL4__
		// без разницы
		if (data_source == VP_SOURCE_TICKS)
			return(PERIOD_CURRENT);
#endif

		return(_tf.find_closest((int)data_source));
	}

	// получить диапазон баров в текущем ТФ (для рисования)
	bool time_range_to_bars(const datetime time_from, const datetime time_to, int &bar_from, int &bar_to)
	{
		bar_from = _series.bar_shift_right(time_from);
		bar_to = _series.bar_shift_right(time_to); // ..right для того, чтобы работали 1-баровые режимы
		return(true);
	}

};
