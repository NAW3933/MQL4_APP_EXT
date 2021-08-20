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

// VP data parameters. © FXcoder

#property strict

#include "../s.mqh"
#include "enum/vp_source.mqh"

class CVPDataParams
{
protected:

	ENUM_VP_SOURCE         source_;
	ENUM_APPLIED_VOLUME    volume_type_;


public:

	_GET(ENUM_VP_SOURCE,         source)
	_GET(ENUM_APPLIED_VOLUME,    volume_type)

	void CVPDataParams(
		ENUM_VP_SOURCE         source,
		ENUM_APPLIED_VOLUME    volume_type
	):
		source_(source),
		volume_type_(volume_type)
	{
	}

};
