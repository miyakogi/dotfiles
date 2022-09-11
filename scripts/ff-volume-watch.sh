#!/usr/bin/env bash

tmp_file="/tmp/ff-volume-fix-paused"

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

# check focused window is Firefox opening YouTube
if [[ $("$msg" -t get_tree | jq '.. | select(.focused?) | .name | test(" - YouTube . Mozilla Firefox$")') == "true" ]]; then
  modified_ff_sinks=$(pulsemixer --list-sinks | grep 'Name: Firefox' | grep -v '100%')
  if [[ -n "$modified_ff_sinks" ]]; then
    echo "$modified_ff_sinks" | while read -r line; do
      ff_sink_id=$(echo "$line" | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')
      pulsemixer --id "$ff_sink_id" --set-volume 100
    done
  fi
fi

echo "  "
