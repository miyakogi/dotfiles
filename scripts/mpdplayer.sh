#!/usr/bin/env bash

options=(
  --class kitty-music
  --override font_family="Sarasa Term J"
  --override bold_font="Sarasa Term J Bold"
  --override font_size="13.5"
  --override background_opacity=0.7
  --override allow_remote_control=yes
  --override enabled_layouts='*'
)
kitty "${options[@]}" kitty-music
