#!/usr/bin/env bash

if systemctl --user is-active --quiet swayidle.service &>/dev/null; then
  systemctl --user stop swayidle.service
else
  systemctl --user start swayidle.service
fi

if pgrep -x waybar &>/dev/null; then
  pkill -SIGRTMIN+6 waybar
fi
