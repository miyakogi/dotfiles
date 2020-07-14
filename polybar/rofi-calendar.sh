#!/bin/sh

year=$(date '+%Y')
month=$(date '+%m')
date=$(date '+%A, %d. %B')

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
      -yoffset 24 \
      -no-custom \
      -p "$date" >/dev/null
