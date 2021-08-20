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

// VP levels parameters. © FXcoder

#property strict

#include "../s.mqh"

class CVPServiceParams
{
protected:

	bool                   show_horizon_;
	string                 id_;


public:

	_GET(bool,                   show_horizon);
	_GET(string,                 id);

	void CVPServiceParams(
		bool                   show_horizon,
		string                 id
	):
		show_horizon_(show_horizon),
		id_(id)
	{
	}

};
