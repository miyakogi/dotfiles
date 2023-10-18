#!/usr/bin/env bash

pulsemixer --id "$(pulsemixer --list-sources | grep 'Name: USB PnP Audio Device Mono' | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')" --toggle-mute

pkill -SIGRTMIN+8 waybar
