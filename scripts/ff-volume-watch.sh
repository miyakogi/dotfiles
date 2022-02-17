#!/usr/bin/env bash

tmp_file="/tmp/ff-volume-disabled"

# check if disabled
if [[ -e "$tmp_file" ]]; then
  echo "  罹"  # nf-mdi-sync_alert
  exit 0
fi

# check if i3 or sway
if [[ -n "$WAYLAND_DISPLAY" ]]; then
  msg="swaymsg"
else
  msg="i3-msg"
fi

if [[ $("$msg" -t get_tree | jq '.. | select(.focused?) | .name | test("youtube.*firefox$"; "ix")') == "true" ]]; then
  if [[ -n "$(pulsemixer --list-sinks | grep 'Name: Firefox' | grep -v '100%')" ]]; then
    pulsemixer --list-sinks | grep "Name: Firefox" | grep -v "100%" | while read -r line; do
      id=$(echo $line | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')
      pulsemixer --id $id --set-volume 100
    done
  fi
fi

echo "  "
