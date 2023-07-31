#!/usr/bin/env bash

case "$XDG_CURRENT_DESKTOP" in
  sway)
    state="state"
    ;;
  Hyprland)
    state="class"
    ;;
  *)
    exit 1
    ;;
esac

if pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | grep 'Mute: 0' &>/dev/null; then
  echo -n -e "{\"$state\": \"Info\", \"text\": \"\u2005\"}"
else
  echo -n -e "{\"$state\": \"Idle\", \"text\": \"\u2005\"}"
fi
