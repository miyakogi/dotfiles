#!/usr/bin/env bash

options=(
  --class kitty-music
  --override background_opacity=0.7
  --override allow_remote_control=yes
  --override enabled_layouts='*'
)

if [[ "$XDG_CURRENT_DESKTOP" == "sway" ]] && [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  options+=(
    --override font_family="Iosevka"
    --override font_size="21"
  )
fi

kitty "${options[@]}" kitty-music
