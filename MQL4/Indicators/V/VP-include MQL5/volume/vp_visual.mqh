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

// VP visual utilities. © FXcoder

#property strict

#include "../bsl.mqh"
#include "../s.mqh"
#include "../enum/hg_coloring.mqh"
#include "../enum/quantile.mqh"
#include "../hist/rates_cache.mqh"
#include "enum/vp_bar_style.mqh"
#include "enum/vp_range_mode.mqh"
#include "vp_hg_params.mqh"
#include "vp_histogram.mqh"
#include "vp_levels_params.mqh"

class CVPVisual
{
protected:

	const string id_;

	const color line_from_color_;            // Left border line color
	const color line_to_color_;              // Right border line color
	const ENUM_LINE_STYLE line_from_style_;  // Left border line style
	const ENUM_LINE_STYLE line_to_style_;    // Right border line style

	const CVPLevelsParams *lvlpar_;
	const CVPHgParams     *hgpar_;

	CBGO *line_from_;
	CBGO *line_to_;

	bool show_hg_;
	bool show_modes_;
	bool show_max_;
	bool show_quantiles_;
	bool show_vwap_;
	bool show_mode_level_;

	double percentiles_[]; // for tooltips

	// auto colors
	color hg_color1_;
	color hg_color2_;
	color prev_background_color_;

	CRatesCache *ratescache_;

public:

	_GET(CBGO*, line_from);
	_GET(CBGO*, line_to);
	_GET(bool, show_modes);
	_GET(bool, show_max);
	_GET(bool, show_quantiles);
	_GET(bool, show_vwap);

	void CVPVisual(
		string id,
		const CVPHgParams &hgpar,
		const CVPLevelsParams &lvlpar
		):
			id_(id),
			hgpar_(&hgpar),
			lvlpar_(&lvlpar),
			line_from_color_(clrBlue),
			line_from_style_(STYLE_DASH),
			line_to_color_(clrCrimson),
			line_to_style_(STYLE_DASH)
	{
		prev_background_color_ = _color.none;
		hg_color1_ = _color.none;
		hg_color2_ = _color.none;

		show_hg_         = (hgpar_.coloring != HG_COLORING_NONE) && (_color.is_valid(hgpar_.color1) || _color.is_valid(hgpar_.color2));
		show_modes_      = _color.is_valid(lvlpar.mode_color);
		show_max_        = _color.is_valid(lvlpar.max_color);
		show_quantiles_  = _color.is_valid(lvlpar.quantile_color) && (lvlpar.quantiles != QUANTILE_NONE);
		show_vwap_       = _color.is_valid(lvlpar.vwap_color);
		show_mode_level_ = _color.is_valid(lvlpar.mode_level_color);

		for (int i = EnumQuantileToArray(lvlpar.quantiles, percentiles_) - 1; i >= 0; --i)
			percentiles_[i] *= 100.0;

		// range lines
		line_from_ = _go[id_ + "-from"];
		line_to_   = _go[id_ + "-to"];

		ratescache_ = new CRatesCache();
	}

	void ~CVPVisual()
	{
		_ptr.safe_delete(ratescache_);
	}

	// draw horizon line
	void draw_horizon(string line_name, datetime hz_time)
	{
		CBGO hz(line_name, OBJ_VLINE, hz_time, 0);
		hz.colour(clrRed).width(1).style(STYLE_DOT);
		hz.selectable(false).hidden(true).back(false);
		hz.text("VP: no data behind this line");
		hz.tooltip(hz.text());
	}

	// draw histogram's bar
	void draw_bar(string name, datetime time1, datetime time2, double price,
		color line_color, int width, double hg_point, ENUM_VP_BAR_STYLE bar_style, ENUM_LINE_STYLE line_style, bool back, string tooltip = "\n")
	{
		CBGO bar(name);

		if (bar_style == VP_BAR_STYLE_BAR)
		{
#ifdef __MQL4__
			CBGO bar1(name + "+1");
			CBGO bar2(name + "+2");
			CBGO bar3(name + "+3");

			// имитация прямоугольника из-за невозможности нарисовать в MT4 пустой прямоугольник фоном
			bar.recreate(OBJ_TREND, 0, time2, price - hg_point / 2.0, time2, price + hg_point / 2.0);
			bar1.recreate(OBJ_TREND, 0, time1, price - hg_point / 2.0, time2, price - hg_point / 2.0).tooltip(tooltip);
			bar2.recreate(OBJ_TREND, 0, time1, price + hg_point / 2.0, time2, price + hg_point / 2.0).tooltip(tooltip);
			bar3.recreate(OBJ_TREND, 0, time1, price - hg_point / 2.0, time1, price + hg_point / 2.0).tooltip(tooltip);
#else
			bar.recreate(OBJ_RECTANGLE, 0, time1, price - hg_point / 2.0, time2, price + hg_point / 2.0);
#endif
		}
		else if ((bar_style == VP_BAR_STYLE_FILLED) || (bar_style == VP_BAR_STYLE_COLOR))
		{
			bar.recreate(OBJ_RECTANGLE, 0, time1, price - hg_point / 2.0, time2, price + hg_point / 2.0);
		}
		else if (bar_style == VP_BAR_STYLE_OUTLINE)
		{
			bar.recreate(OBJ_TREND, 0, time1, price, time2, price + hg_point);
		}
		else
		{
			bar.recreate(OBJ_TREND, 0, time1, price, time2, price);
		}

		bool filled = (bar_style == VP_BAR_STYLE_FILLED) || (bar_style == VP_BAR_STYLE_COLOR);
		set_bar_style(name, line_color, width, bar_style, line_style, back, filled);
		bar.tooltip(tooltip);

#ifdef __MQL4__
		if (bar_style == VP_BAR_STYLE_BAR)
		{
			set_bar_style(name + "+1", line_color, width, bar_style, line_style, back, filled);
			set_bar_style(name + "+2", line_color, width, bar_style, line_style, back, filled);
			set_bar_style(name + "+3", line_color, width, bar_style, line_style, back, filled);
		}
#endif
	}

	void set_bar_style(string name, color line_color, int width, ENUM_VP_BAR_STYLE bar_style, ENUM_LINE_STYLE line_style, bool back, bool filled)
	{
		CBGO bar(name);
		bar.hidden(true).selectable(false);
		bar.line_style(line_style, width, line_color);
		bar.ray_left_right(false);

#ifdef __MQL4__
		bar.back(back || filled);
#else
		bar.back(back).fill(filled);
#endif
	}

	void draw_level(string name, double price, string tooltip)
	{
		CBGO level(name);
		level.recreate(OBJ_HLINE, 0, 0, price);
		level.hidden(true).selectable(false);
		level.colour(lvlpar_.mode_level_color).style(lvlpar_.mode_level_style).width(lvlpar_.mode_level_style == STYLE_SOLID ? lvlpar_.mode_level_width : 1);
		level.tooltip(tooltip);

		// must not be at back to show price at right
		level.back(false);
	}

	bool draw_hg(CVPHistogram &hg, double zoom, double global_max_volume)
	{
		const int size = ArraySize(hg.volumes);
		if (size <= 0)
			return(true);

		if ((hg.bar_from > hg.bar_to) && (hgpar_.bar_style != VP_BAR_STYLE_COLOR))
			zoom = -zoom;

		color cl = hg_color1_;

		double max_volume = global_max_volume > 0 ? global_max_volume : hg.max_volume;

		// outline style's things
		double next_volume = 0;
		const bool is_outline = hgpar_.bar_style == VP_BAR_STYLE_OUTLINE;

		int min_bar = _math.min(hg.bar_from, hg.bar_to);
		int max_bar = _math.max(hg.bar_from, hg.bar_to);

		// update cache on new bar
		if (_ser.is_new_bar())
		{
			ratescache_.clear();
		}

		MqlRates rate;

		int bar1 = hg.bar_from;
		int bar2 = hg.bar_to;
		int mode_bar2 = hg.bar_to;
		const datetime time_from = ratescache_.time(hg.bar_from);
		const datetime time_to   = ratescache_.time(hg.bar_to);
		ASSERT_RETURN(time_from > 0 && time_to > 0, false);

		const int first = is_outline ? -1 : 0;
		const int hg_point_norm_digits = _math.limit_below(_conv.point_to_digits(hg.point, _Digits), 0);;

		// calculate bars
		int bars[];
		ArrayResize(bars, size);
		for (int i = 0; i < size; i++)
			bars[i] = _math.round_to_int(hg.bar_from + hg.volumes[i] * zoom);

		// remove zero tails
		int start_bar = 0;
		int end_bar = size - 1;

		while ((start_bar < size) && (bars[start_bar] == bar1))
			start_bar++;

		while ((end_bar >= 0) && (bars[end_bar] == bar1))
			end_bar--;

		// the outline style has the extra bar
		if (is_outline)
			start_bar--;

		double cl_levels[];
		int cl_count = EnumHGColoringToLevels(hgpar_.coloring, hg.volumes, cl_levels);

		for (int i = first; i < size; i++)
		{
			if (!is_outline && (i <= first))
				continue;

			const double price = NormalizeDouble(hg.low_price + i * hg.point, hg_point_norm_digits);
			const string price_string = DoubleToString(price, hg_point_norm_digits);
			const string name = hg.prefix + price_string;

			double volume = 0;

			if (is_outline)
			{
				if (i <= first)
				{
					// below
					volume = 0;
					next_volume = hg.volumes[0];
					bar1 = hg.bar_from;
					bar2 = bars[0];
				}
				else if (i < size - 1)
				{
					volume = hg.volumes[i];
					next_volume = hg.volumes[i + 1];
					bar1 = bars[i];
					bar2 = bars[i + 1];
					mode_bar2 = bar1;
				}
				else
				{
					// above
					volume = hg.volumes[i];
					next_volume = 0;
					bar1 = bars[i];
					bar2 = hg.bar_from;
				}
			}
			else
			{
				volume = hg.volumes[i];

				if (hgpar_.bar_style == VP_BAR_STYLE_COLOR)
					bar2 = _math.round_to_int(hg.bar_from + (hg.bar_to - hg.bar_from) * zoom);
				else
					bar2 = bars[i];

				mode_bar2 = bar2;
			}

			// skip zero tails
			if ((i < start_bar) || (i > end_bar))
				continue;

//todo: rename t1, t2
			const datetime t1 = ratescache_.time(bar1);
			const datetime t2 = ratescache_.time(bar2);

			const string tooltip = (string)_math.round_to_long(volume) + " @ " + price_string;

			// Draw only one level on the same price using priority: max, quantiles, vwap_pos, mode.
			// If nothing fits, draw hg bar.

			if (show_mode_level_ && (_arr.contains(hg.modes, i)))
			{
				draw_level(name + " level", price, tooltip);
			}

			if (show_hg_)
			{
				cl = hg_color1_;
				double check_volume = is_outline ? fmax(volume, next_volume) : volume;

				for (int k = cl_count - 1; k >= 0; --k)
				{
					if (check_volume >= cl_levels[k])
					{
						cl = _color.mix(hg_color1_, hg_color2_, double(k) / (cl_count - 1.0), 1);
						break;
					}
				}

				draw_bar(name, t1, t2, price, cl, hgpar_.line_width, hg.point, hgpar_.bar_style, STYLE_SOLID, true, tooltip);
			}

			const int qi = _arr.index_of(hg.quantiles, i);

			if (show_quantiles_ && (qi >= 0))
			{
				const datetime q_t2  = hgpar_.bar_style == VP_BAR_STYLE_COLOR ? t2 : time_to;
				draw_bar(
					name + " q." + (string)i,
					time_from, q_t2, price,
					lvlpar_.quantile_color, lvlpar_.stat_line_width, hg.point, VP_BAR_STYLE_LINE, lvlpar_.stat_line_style, false,
					"P" + _double.to_string_compact(percentiles_[qi], 1) + ", " + tooltip);
			}
			else if (show_vwap_ && (i == hg.vwap_pos))
			{
				const datetime vwap_t2  = hgpar_.bar_style == VP_BAR_STYLE_COLOR ? t2 : time_to;
				draw_bar(name + " vwap", time_from, vwap_t2, price, lvlpar_.vwap_color, lvlpar_.stat_line_width, hg.point, VP_BAR_STYLE_LINE, lvlpar_.stat_line_style, false, "VWAP " + tooltip);
			}
			else if ((show_max_ && (i == hg.max_pos)) || (show_modes_ && (_arr.contains(hg.modes, i))))
			{
				const datetime mode_t2 = ratescache_.time(mode_bar2);
				const bool is_max = (show_max_ && (i == hg.max_pos));
				const color mode_color = is_max ? lvlpar_.max_color : lvlpar_.mode_color;
				const string mode_tooltip = (is_max ? "max " : "mode ") + tooltip;

				if (hgpar_.bar_style == VP_BAR_STYLE_LINE)
				{
					draw_bar(name, time_from, mode_t2, price, mode_color, lvlpar_.mode_line_width, hg.point, VP_BAR_STYLE_LINE, STYLE_SOLID, false, mode_tooltip);
				}
				else if (hgpar_.bar_style == VP_BAR_STYLE_BAR)
				{
					draw_bar(name, time_from, mode_t2, price, mode_color, lvlpar_.mode_line_width, hg.point, VP_BAR_STYLE_BAR, STYLE_SOLID, false, mode_tooltip);
				}
				else if (hgpar_.bar_style == VP_BAR_STYLE_FILLED)
				{
					draw_bar(name, time_from, mode_t2, price, mode_color, lvlpar_.mode_line_width, hg.point, VP_BAR_STYLE_FILLED, STYLE_SOLID, false, mode_tooltip);
				}
				else if (hgpar_.bar_style == VP_BAR_STYLE_OUTLINE)
				{
					draw_bar(name + "+", time_from, mode_t2, price, mode_color, lvlpar_.mode_line_width, hg.point, VP_BAR_STYLE_LINE, STYLE_SOLID, false, mode_tooltip);
				}
				else if (hgpar_.bar_style == VP_BAR_STYLE_COLOR)
				{
					draw_bar(name, time_from, mode_t2, price, mode_color, lvlpar_.mode_line_width, hg.point, VP_BAR_STYLE_FILLED, STYLE_SOLID, false, mode_tooltip);
				}
			}
		}

		return(true);
	}

	// returns true if any color changes
	bool update_auto_colors()
	{
		if (!show_hg_)
			return(false);

		const bool is_none1 = _color.is_none(hgpar_.color1);
		const bool is_none2 = _color.is_none(hgpar_.color2);
		if (is_none1 && is_none2)
			return(false);

		const color new_bg_color = _chart.color_background();
		if (new_bg_color == prev_background_color_)
			return(false);

		hg_color1_ = is_none1 ? new_bg_color : hgpar_.color1;
		hg_color2_ = is_none2 ? new_bg_color : hgpar_.color2;

		prev_background_color_ = new_bg_color;
		return(true);
	}

	void draw_line_from(datetime time_from)
	{
		line_from_.recreate(OBJ_VLINE, 0, time_from, 0);
		line_from_.colour(line_from_color_).back(false).style(line_from_style_).width(1);
		line_from_.tooltip("VP range line");
	}

	void draw_line_to(datetime time_to)
	{
		line_to_.recreate(OBJ_VLINE, 0, time_to, 0);
		line_to_.colour(line_to_color_).back(false).style(line_to_style_).width(1);
		line_to_.tooltip("VP range line");
	}

	void draw_range_lines(datetime time_from, datetime time_to)
	{
		draw_line_from(time_from);
		draw_line_to(time_to);
	}

	void enable_line_from()
	{
		line_from_.selectable(true).hidden(false);
	}

	void enable_line_to()
	{
		line_to_.selectable(true).hidden(false);
	}

	void enable_range_lines()
	{
		enable_line_from();
		enable_line_to();
	}

	void disable_line_from()
	{
		line_from_.selectable(false).hidden(true);
	}

	void disable_line_to()
	{
		line_to_.selectable(false).hidden(true);
	}

	void disable_range_lines()
	{
		disable_line_from();
		disable_line_to();
	}

	void delete_range_lines()
	{
		line_from_.del();
		line_to_.del();
	}

};
