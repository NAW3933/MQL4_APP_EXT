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

// VP data source type. © FXcoder

#property strict

enum ENUM_VP_SOURCE
{
#ifndef __MQL4__

	VP_SOURCE_TICKS   = 0,  // Ticks

	VP_SOURCE_M1      = 1,  // M1 bars
	VP_SOURCE_M2      = 2,  // M2 bars
	VP_SOURCE_M3      = 3,  // M3 bars
	VP_SOURCE_M4      = 4,  // M4 bars
	VP_SOURCE_M5      = 5,  // M5 bars
	VP_SOURCE_M6      = 6,  // M6 bars
	VP_SOURCE_M10     = 10, // M10 bars
	VP_SOURCE_M12     = 12, // M12 bars
	VP_SOURCE_M15     = 15, // M15 bars
	VP_SOURCE_M20     = 20, // M20 bars
	VP_SOURCE_M30     = 30, // M30 bars

#else

	VP_SOURCE_M1      = 1,  // M1 bars
	VP_SOURCE_M5      = 5,  // M5 bars
	VP_SOURCE_M15     = 15, // M15 bars
	VP_SOURCE_M30     = 30, // M30 bars

#endif

};
