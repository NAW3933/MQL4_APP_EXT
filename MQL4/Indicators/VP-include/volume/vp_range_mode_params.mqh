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

// VP range mode parameters. © FXcoder

#property strict

#include "../s.mqh"

#include "enum/vp_hg_position.mqh"
#include "enum/vp_range_mode.mqh"

class CVPRangeModeParams
{
protected:

	ENUM_VP_RANGE_MODE     sel_mode_;
	int                    minutes_;
	ENUM_VP_HG_POSITION    hg_position_;


public:

	_GET(ENUM_VP_RANGE_MODE,     sel_mode)
	_GET(int,                    minutes)
	_GET(ENUM_VP_HG_POSITION,    hg_position)

	void CVPRangeModeParams(
		ENUM_VP_RANGE_MODE     sel_mode,
		int                    minutes,
		ENUM_VP_HG_POSITION    hg_position
	):
		sel_mode_(sel_mode),
		minutes_(minutes),
		hg_position_(hg_position)
	{
	}

	bool hg_position_is_chart_side() const
	{
		return((hg_position_ == VP_HG_POSITION_CHART_LEFT) || (hg_position_ == VP_HG_POSITION_CHART_RIGHT));
	}

	bool hg_position_is_inside_range() const
	{
		return((hg_position_ == VP_HG_POSITION_LEFT_INSIDE) || (hg_position_ == VP_HG_POSITION_RIGHT_INSIDE));
	}

};
