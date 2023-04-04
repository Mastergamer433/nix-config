hc() {
    herbstclient "$@"
}

hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1
hc set frame_border_active_color '#bd93f9'
hc set frame_border_normal_color '#44475a'
hc set frame_bg_normal_color '#282a36'
hc set frame_bg_active_color '#44475a'
hc set frame_border_width 1
hc set always_show_frame 0
hc set frame_bg_transparent 1
hc set frame_transparent_width 0
hc set frame_padding 0
hc set focus_follows_mouse 1

hc attr theme.active.color '#bd93f9'
hc attr theme.normal.color '#454545'
hc attr theme.urgent.color '#ffb86c'
hc attr theme.inner_width 0
hc attr theme.inner_color black
hc attr theme.border_width 1
hc attr theme.floating.border_width 1
hc attr theme.floating.outer_width 1
hc attr theme.floating.outer_color '#44475a'
hc attr theme.active.inner_color '#bd93f9'
hc attr theme.active.outer_color '#bd93f9'
hc attr theme.background_color '#282a36'

hc set window_gap 8
hc set smart_window_surroundings 0
hc set smart_frame_surroundings 1
hc set mouse_recenter_gap 0
hc set focus_crosses_monitor_boundaries 1
hc set swap_monitors_to_get_tag 1
