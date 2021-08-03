<chart>
id=132353794595034641
comment=2020.05.01 03:16:31
symbol=USDCAD
period=1
leftpos=1945
digits=5
scale=8
graph=1
fore=0
grid=0
volume=0
scroll=1
shift=1
ohlc=0
one_click=0
one_click_btn=0
askline=0
days=0
descriptions=0
shift_size=26
fixed_pos=0
window_left=26
window_top=26
window_right=1288
window_bottom=278
window_type=3
background_color=16448255
foreground_color=7559735
barup_color=12810275
bardown_color=3634165
bullcandle_color=12810275
bearcandle_color=3634165
chartline_color=12810275
volumes_color=51200
grid_color=12632256
askline_color=10526880
stops_color=17919

<window>
height=296
fixed_height=0
<indicator>
name=main
<object>
type=23
object_name=Label 2350
period_flags=0
create_time=1590429998
description=Tester Template
color=0
font=Arial
fontsize=10
angle=0
anchor_pos=0
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=0
x_distance=208
y_distance=1
</object>
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=ExactTrading\MQL\Indicator\HighLow_v1.6
flags=275
window_num=0
<inputs>
iWeeks=10
iMonths=10
iQuarters=10
iYears=10
cWeeks=16711680
cMonths=255
cQuarters=65280
cYears=55295
enStyle=3
enCorner=2
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=4294967295
style_0=0
weight_0=0
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=CCIarrow
flags=339
window_num=0
<inputs>
CCI_Period=14
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=16711680
style_0=0
weight_0=0
arrow_0=233
shift_1=0
draw_1=3
color_1=255
style_1=0
weight_1=0
arrow_1=234
shift_2=0
draw_2=3
color_2=32768
style_2=0
weight_2=0
arrow_2=252
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=ExactTrading\MQL\Indicator\Night-Nurse-Extra
flags=339
window_num=0
<inputs>
Section1=~~~~~~~ALERTS~~~~~~~
bAlert=false
bPush=false
bMail=false
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=16711680
style_0=0
weight_0=2
arrow_0=159
shift_1=0
draw_1=3
color_1=65407
style_1=0
weight_1=2
arrow_1=159
shift_2=0
draw_2=3
color_2=65535
style_2=0
weight_2=2
arrow_2=159
shift_3=0
draw_3=3
color_3=16711935
style_3=0
weight_3=2
arrow_3=159
shift_4=0
draw_4=3
color_4=16776960
style_4=0
weight_4=2
arrow_4=159
shift_5=0
draw_5=3
color_5=42495
style_5=0
weight_5=2
arrow_5=159
shift_6=0
draw_6=3
color_6=32768
style_6=0
weight_6=2
arrow_6=159
shift_7=0
draw_7=3
color_7=2763429
style_7=0
weight_7=2
arrow_7=159
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=mcginley-dynamic-indicator_with_2ATR_bands
flags=339
window_num=0
<inputs>
Note=NumberOfBars = 0 means all bars
NumberOfBars=1000
Periods=12
Smoothing=125
ShowATRBands=true
ATRupDistance=1.0
ATRdownDistance=1.0
BandsColor=16776960
ATR_Period=14
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=255
style_0=0
weight_0=2
shift_1=0
draw_1=0
color_1=16776960
style_1=0
weight_1=1
shift_2=0
draw_2=0
color_2=16776960
style_2=0
weight_2=1
shift_3=0
draw_3=0
color_3=16776960
style_3=0
weight_3=1
shift_4=0
draw_4=0
color_4=16776960
style_4=0
weight_4=1
period_flags=0
show_data=1
</indicator>
</window>
</chart>

