#!/usr/bin/env bash

options=(
  --class kitty-music
  --override font_family="Iosevka Term"
  --override bold_font="Iosevka Term Heavy"
  --override background_opacity=0.7
  --override allow_remote_control=yes
  --override enabled_layouts='*'
)
kitty "${options[@]}" kitty-music
