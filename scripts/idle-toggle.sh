#!/usr/bin/env bash

case "$XDG_CURRENT_DESKTOP" in
  sway*)
    service="swayidle.service"
    ;;
  [Hh]yprland|niri)
    service="hypridle.service"
    ;;
  *)
    ;;
esac

if systemctl --user is-active --quiet "$service" &>/dev/null; then
  systemctl --user stop "$service"
else
  systemctl --user start "$service"
fi

if pgrep -x waybar &>/dev/null; then
  pkill -SIGRTMIN+6 waybar
fi
