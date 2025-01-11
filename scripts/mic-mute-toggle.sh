#!/usr/bin/env bash

pulsemixer --id "$(pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')" --toggle-mute
sloop 0.5
pulsemixer --id "$(pulsemixer --list-sources | grep 'Name: ArctisX PnP Microphone Mono' | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')" --toggle-mute

if pgrep -x waybar &>/dev/null; then
  pkill -SIGRTMIN+8 waybar
fi
