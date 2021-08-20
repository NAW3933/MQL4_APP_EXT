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

// VP period mode parameters. © FXcoder

#property strict

#include "../s.mqh"
#include "../enum/hg_direction.mqh"
#include "enum/vp_time_shift.mqh"
#include "enum/vp_zoom.mqh"

class CVPPeriodModeParams
{
protected:

	ENUM_TIMEFRAMES        tf_;
	int                    count_;
	ENUM_VP_TIME_SHIFT     time_shift_;
	ENUM_HG_DIRECTION      draw_direction_;
	ENUM_VP_ZOOM           zoom_type_;
	double                 zoom_custom_;


public:

	_GET(ENUM_TIMEFRAMES,        tf);
	_GET(int,                    count);
	_GET(ENUM_VP_TIME_SHIFT,     time_shift);
	_GET(ENUM_HG_DIRECTION,      draw_direction);
	_GET(ENUM_VP_ZOOM,           zoom_type);
	_GET(double,                 zoom_custom);


	void CVPPeriodModeParams(
		ENUM_TIMEFRAMES        tf,
		int                    count,
		ENUM_VP_TIME_SHIFT     time_shift,
		ENUM_HG_DIRECTION      draw_direction,
		ENUM_VP_ZOOM           zoom_type,
		double                 zoom_custom
	):
		tf_(tf),
		count_(count),
		time_shift_(time_shift),
		draw_direction_(draw_direction),
		zoom_type_(zoom_type),
		zoom_custom_(zoom_custom)
	{
	}

};
