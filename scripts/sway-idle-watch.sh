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
  echo -n -e "{ \"text\": \"\u2005\", \"$state\": \"Idle\" }"  # U+2005: 1/4 space
else
  echo -n -e "{ \"text\": \"\u2005\", \"$state\": \"Info\" }"  # U+2005: 1/4 space
fi
