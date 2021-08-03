<chart>
id=130984780191234674
symbol=NZDUSD
period=60
leftpos=3555
digits=5
scale=4
graph=1
fore=0
grid=1
volume=0
scroll=0
shift=1
ohlc=1
one_click=0
one_click_btn=1
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=414
window_top=672
window_right=828
window_bottom=896
window_type=3
background_color=16443367
foreground_color=0
barup_color=0
bardown_color=0
bullcandle_color=16777215
bearcandle_color=0
chartline_color=0
volumes_color=32768
grid_color=12632256
askline_color=17919
stops_color=17919

<window>
height=149
fixed_height=0
<indicator>
name=main
<object>
type=1
object_name=Horizontal Line 35633
period_flags=0
create_time=1424198449
color=255
style=0
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
value_0=1.138714
</object>
<object>
type=10
object_name=Fibo 43864
period_flags=0
create_time=1424206680
color=255
style=2
weight=1
background=0
filling=0
selectable=1
hidden=0
zorder=0
color2=16760576
style2=0
weight2=1
time_0=1424165400
value_0=1.134030
time_1=1424177100
value_1=1.144860
levels_ray=0
level_0=0.0000
description_0=0.0
level_1=0.2360
description_1=23.6
level_2=0.3820
description_2=38.2
level_3=0.5000
description_3=50.0
level_4=0.6180
description_4=61.8
level_5=1.0000
description_5=100.0
level_6=-0.6180
description_6=161.8
level_7=-0.3820
description_7=138.2
level_8=-0.2700
description_8=127
level_9=0.7820
description_9=78.2
level_10=-1.0000
description_10=200
</object>
</indicator>
<indicator>
name=Moving Average
period=55
shift=0
method=0
apply=0
color=7451452
style=0
weight=2
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=200
shift=0
method=0
apply=0
color=255
style=0
weight=2
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=100
shift=0
method=0
apply=0
color=13828244
style=0
weight=2
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=ChandelierStops_v1_YoYo
flags=275
window_num=0
<inputs>
Length=21
ATRperiod=21
Kv=3.7
Shift=1
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=16711680
style_0=0
weight_0=2
shift_1=0
draw_1=0
color_1=255
style_1=0
weight_1=2
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=45
fixed_height=0
<indicator>
name=Custom Indicator
<expert>
name=MACD True
flags=275
window_num=3
<inputs>
FastMAPeriod=21
SlowMAPeriod=33
SignalMAPeriod=12
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=16711680
style_0=0
weight_0=0
shift_1=0
draw_1=0
color_1=9109504
style_1=2
weight_1=0
shift_2=0
draw_2=2
color_2=32768
style_2=0
weight_2=0
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=27
fixed_height=0
<indicator>
name=Commodity Channel Index
period=33
apply=4
color=32768
style=0
weight=1
levels_color=12632256
levels_style=2
levels_weight=1
level_0=-100.00000000
level_1=100.00000000
period_flags=0
show_data=1
</indicator>
</window>
</chart>

