#!/usr/bin/env bash

if systemctl --user is-active --quiet swayidle.service &>/dev/null; then
  systemctl --user stop swayidle.service
else
  systemctl --user start swayidle.service
fi

pkill -SIGRTMIN+8 waybar
