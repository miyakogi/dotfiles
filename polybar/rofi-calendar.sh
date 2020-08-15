#!/bin/sh

year=$(date '+%Y')
month=$(date '+%m')
date=$(date '+%A, %d. %B')

if [[ $POLYBAR_SPLIT -eq 1 ]]; then
  yoffset=32
else
  yoffset=24
fi

cal --color=always $month $year \
  | sed 's/\x1b\[[7;]*m/\<b\>\<u\>/g' \
  | sed 's/\x1b\[[27;]*m/\<\/u\>\<\/b\>/g' \
  | tail -n +2 \
  | rofi \
      -dmenu \
      -markup-rows \
      -no-fullscreen \
      -hide-scrollbar \
      -theme "calendar-theme" \
      -bw 2 \
      -monitor -1 \
      -location 2 \
      -lines 6 \
      -width 16 \
      -yoffset $yoffset \
      -no-custom \
      -p "$date" >/dev/null
