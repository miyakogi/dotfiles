#!/usr/bin/env bash

if systemctl --user is-active --quiet swayidle.service &>/dev/null; then
  systemctl --user stop swayidle.service
else
  systemctl --user start swayidle.service
fi

case "$XDG_CURRENT_DESKTOP" in
  [Hh]yprland)
    pkill -SIGRTMIN+6 waybar;;
  sway)
    ;;
  *)
    ;;
esac
