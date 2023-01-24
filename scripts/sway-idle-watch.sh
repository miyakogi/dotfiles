#!/usr/bin/env bash

case "$XDG_CURRENT_DESKTOP" in
  sway)
    state="state"
    ;;
  Hyprland)
    state="class"
    ;;
  *)
    state=""
    ;;
esac

if systemctl --user is-active --quiet swayidle.service &>/dev/null; then
  echo -n "{ \"text\": \"\", \"$state\": \"Idle\" }"
else
  echo -n "{ \"text\": \"\", \"$state\": \"Info\" }"
fi
