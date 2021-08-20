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

//Направление отображения гистограммы. © FXcoder

#property strict

/**
	- справа налево
	- слева направо
*/
enum ENUM_HG_DIRECTION
{
	HG_DIRECTION_LEFT = 0,   // |<|  Right to left
	HG_DIRECTION_RIGHT = 1,  // |>|  Left to right
};
