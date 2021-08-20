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

// VP tick parameters. © FXcoder

#property strict

#include "../s.mqh"
#include "enum/vp_tick_price.mqh"

class CVPTickParams
{
protected:

	ENUM_VP_TICK_PRICE  price_type_;
	int                 flags_;

public:

	_GET(ENUM_VP_TICK_PRICE,     price_type)
	_GET(int,                    flags)

	void CVPTickParams(
		ENUM_VP_TICK_PRICE     price_type,
		bool                   bid,
		bool                   ask,
		bool                   last,
		bool                   volume,
		bool                   buy,
		bool                   sell
	):
		price_type_(price_type),
		flags_((bid ? TICK_FLAG_BID : 0) | (ask ? TICK_FLAG_ASK : 0) | (ask ? TICK_FLAG_LAST : 0) | (volume ? TICK_FLAG_VOLUME : 0) | (buy ? TICK_FLAG_BUY : 0) | (sell ? TICK_FLAG_SELL : 0))
	{
	}

};
