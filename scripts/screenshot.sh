#!/usr/bin/bash

grim_file="${XDG_PICTURES_DIR:-$HOME/Pictures}/screenshots/grim/grim-$(date +%Y%m%d-%H%M%S).jpg"
notify_file="$(echo $grim_file | sed "s|$HOME|~|")"

case "$1" in
  fullscreen)
    grim -t jpeg "$grim_file"
    notify-send -i camera "Screenshot saved to $notify_file"
    ;;
  window)
    hyprctl -j activewindow | jq -r '.at[0], .at[1], .size[0], .size[1]' | xargs printf '%d,%d %dx%d' | grim -g - -t jpeg "$grim_file"
    notify-send -i camera "Screenshot saved to $notify_file"
    ;;
  region)
    grim -g "$(slurp)" - | swappy -f -
    ;;
esac
