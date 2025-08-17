#!/usr/bin/env bash

case "$XDG_CURRENT_DESKTOP" in
  sway*)
    cmd=(swaymsg -t get_outputs)
    ;;
  Hyprland)
    cmd=(hyprctl -j monitors)
    ;;
  *)
    exit 1
    ;;
esac

if [ "$("${cmd[@]}" | jq '.[] | select(.focused) | .name' | tr -d '"' )" = "DP-1" ]; then
  true
else
  false
fi
