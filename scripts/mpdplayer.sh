#!/usr/bin/env bash

options=(
  --class kitty-music
  --override background_opacity=0.7
  --override allow_remote_control=yes
  --override enabled_layouts='*'
)

if [ "$(is-4k)" = true ]; then
  options+=(
    --override font_family="Iosevka"
    --override font_size="21"
  )
fi

kitty "${options[@]}" kitty-music
