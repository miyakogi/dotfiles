#!/usr/bin/env bash

options=(
  --class kitty-music
  --override background_opacity=0.7
  --override allow_remote_control=yes
  --override enabled_layouts='*'
  --override font_family='Fira Code Regular'
)
kitty "${options[@]}" kitty-music
