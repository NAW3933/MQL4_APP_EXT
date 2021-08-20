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

// Режим выбора диапазона. © FXcoder

#property strict

enum ENUM_VP_RANGE_MODE
{
	VP_RANGE_MODE_BETWEEN_LINES = 0,   // |<->|  Between lines
	VP_RANGE_MODE_LAST_MINUTES = 1,    //  --->]  Last minutes
	VP_RANGE_MODE_MINUTES_TO_LINE = 2  //  --->|  Minitues to line
};

string EnumVPRangeModeToString(ENUM_VP_RANGE_MODE mode)
{
	switch (mode)
	{
		case VP_RANGE_MODE_BETWEEN_LINES:   return("lines");
		case VP_RANGE_MODE_LAST_MINUTES:    return("last");
		case VP_RANGE_MODE_MINUTES_TO_LINE: return("2line");
	}

	return("?");
}
