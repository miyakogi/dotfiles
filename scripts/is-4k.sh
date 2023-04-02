#!/usr/bin/bash

case "$XDG_CURRENT_DESKTOP" in
  sway)
    cmd=(swaymsg -t get_outputs)
    ;;
  Hyprland)
    cmd=(hyprctl -j monitors)
    ;;
  *)
    echo false
    exit
    ;;
esac

if [ "$("${cmd[@]}" | jq '.[] | select(.focused) | .name' | tr -d '"' )" = "DP-1" ]; then
  echo true
else
  echo false
fi
