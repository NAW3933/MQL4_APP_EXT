<chart>
comment=                        1:10 / 0.0
symbol=##T101##
period=15
leftpos=894
offline=1
digits=3
scale=8
graph=0
fore=0
grid=0
volume=0
scroll=1
shift=1
ohlc=1
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=0
window_top=0
window_right=1013
window_bottom=396
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=42495
bullcandle_color=0
bearcandle_color=0
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=136
<indicator>
name=main
<object>
type=21
object_name=[Price_Spread_CandleTime] CandleTime
period_flags=0
create_time=1312979951
description=                        1:10 / 0.0
color=65535
font=Arial Narrow
fontsize=13
angle=0
background=0
time_0=1312988400
value_0=101899.214286
</object>
<object>
type=23
object_name=[Price_Spread_CandleTime] Market_PriceA
period_flags=0
create_time=1312982023
description=0.00
color=65535
font=Arial Bold
fontsize=20
angle=0
background=1
corner=3
x_distance=15
y_distance=1
</object>
<object>
type=23
object_name=[Price_Spread_CandleTime] Market_PriceB
period_flags=0
create_time=1312982023
description=0
color=65535
font=Arial Bold
fontsize=20
angle=0
background=1
corner=3
x_distance=1
y_distance=1
</object>
<object>
type=1
object_name=Horizontal Line 43253
period_flags=0
create_time=1312467189
color=65535
style=0
weight=1
background=0
value_0=102185.065060
</object>
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Heiken_Ashi_SmoothedLHm_mtf
flags=339
window_num=0
<inputs>
MaPeriod=6
MaMetod=2
MaPeriod2=2
MaMetod2=3
DrawHisto=1
TimeFrame=240
note_TimeFrames=M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-CurrentTF
note_MA_Method=SMA0 EMA1 SMMA2 LWMA3
</inputs>
</expert>
shift_0=0
draw_0=2
color_0=-1
style_0=0
weight_0=1
shift_1=0
draw_1=2
color_1=-1
style_1=0
weight_1=1
shift_2=0
draw_2=2
color_2=255
style_2=0
weight_2=2
shift_3=0
draw_3=2
color_3=16748574
style_3=0
weight_3=2
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Price_Spread_CandleTime
flags=339
window_num=0
<inputs>
DnColor=255
UpColor=16711680
FlatColor=65535
d1_= : Corner : 0=Top Left
d2_= : : 1=Top Right
d3_= : : 2=Bottom Left
d4_= : : 3=Bottom Right
Display_Corner=3
color_text=65535
label_textsize=6
Show_Candle_Time=1
Show_Spread=1
Space=                        
Show_Market_Price=1
Size_Market_Price=20
Extra_Digit_SizeDiff=0
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=0
style_0=0
weight_0=0
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=smMTFTrioAvg_Signals_v6
flags=339
window_num=0
<inputs>
TimeFrameList=15,60
SignalShift=1
Method=_____0_TrioAvg___1_Trix_____
Avg_Method=1
sig=_____Signals_____
iArrowUP=233
iArrowDN=234
iArrowHeight=1
factor_SignalOffset=0.60000000
Alert_Signals=1
EMail_Signals=0
maxBars=200
IndicatorName=___0_NONE___1_Short___2_Long____
Show_IndicatorName=1
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=16760576
style_0=0
weight_0=1
arrow_0=233
shift_1=0
draw_1=3
color_1=16711935
style_1=0
weight_1=1
arrow_1=234
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=14
<indicator>
name=Custom Indicator
<expert>
name=Trix MTF meter roy 05 showing confirmed signals
flags=339
window_num=1
<inputs>
TimeFrame1=5
Line_ht=60
TRIX_Period=3
CountBars=5000
arrow=110
Notes=next drag 3 times into SAME window
new_settings=tf=30, ht=55, then 60,30, then 240,5,
ShowNext=1
arrowdown=234
arrowup=233
colour_arrowdown=255
colour_arrowup=32768
vertical_adjustment=6
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=17919
style_0=0
weight_0=0
arrow_0=110
shift_1=0
draw_1=3
color_1=32768
style_1=0
weight_1=0
arrow_1=110
min=0.000000
max=100.000000
period_flags=0
show_data=1
<object>
type=21
object_name=Period H1 TRIX 1
period_flags=0
create_time=1312981498
description=        ê
color=255
font=Wingdings
fontsize=8
angle=0
background=0
time_0=1312988400
value_0=26.000000
</object>
<object>
type=21
object_name=Period M15 TRIX 1
period_flags=0
create_time=1312981480
description=        ê
color=255
font=Wingdings
fontsize=8
angle=0
background=0
time_0=1312988400
value_0=46.000000
</object>
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Trix MTF meter roy 05 showing confirmed signals
flags=339
window_num=1
<inputs>
TimeFrame1=15
Line_ht=40
TRIX_Period=3
CountBars=5000
arrow=110
Notes=next drag 3 times into SAME window
new_settings=tf=30, ht=55, then 60,30, then 240,5,
ShowNext=1
arrowdown=234
arrowup=233
colour_arrowdown=255
colour_arrowup=32768
vertical_adjustment=6
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=17919
style_0=0
weight_0=0
arrow_0=110
shift_1=0
draw_1=3
color_1=32768
style_1=0
weight_1=0
arrow_1=110
min=0.000000
max=100.000000
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=Trix MTF meter roy 05 showing confirmed signals
flags=339
window_num=1
<inputs>
TimeFrame1=60
Line_ht=20
TRIX_Period=3
CountBars=5000
arrow=110
Notes=next drag 3 times into SAME window
new_settings=tf=30, ht=55, then 60,30, then 240,5,
ShowNext=1
arrowdown=234
arrowup=233
colour_arrowdown=255
colour_arrowup=32768
vertical_adjustment=6
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=17919
style_0=0
weight_0=0
arrow_0=110
shift_1=0
draw_1=3
color_1=32768
style_1=0
weight_1=0
arrow_1=110
min=0.000000
max=100.000000
period_flags=0
show_data=1
</indicator>
</window>
</chart>

