#!/usr/bin/env bash

pulsemixer --id "$(pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')" --toggle-mute

case "$XDG_CURRENT_DESKTOP" in
  [Hh]yprland)
    pkill -SIGRTMIN+8 waybar;;
  sway)
    ;;
  *)
    ;;
esac
