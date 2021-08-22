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

// VP calculation parameters. © FXcoder

#property strict

#include "../s.mqh"
#include "../enum/point_scale.mqh"

class CVPCalcParams
{
protected:

	int                    mode_step_;
	ENUM_POINT_SCALE       hg_point_scale_;
	int                    smooth_;


public:

	_GET(int,                    mode_step)
	_GET(ENUM_POINT_SCALE,       hg_point_scale)
	_GET(int,                    smooth)

	void CVPCalcParams(
		int                    mode_step,
		ENUM_POINT_SCALE       hg_point_scale,
		int                    smooth
	):
		mode_step_(mode_step),
		hg_point_scale_(hg_point_scale),
		smooth_(smooth)
	{
	}

};