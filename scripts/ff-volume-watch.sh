#!/usr/bin/env bash

tmp_file="/tmp/ff-volume-fix-paused"

# check if disabled
if [[ -e "$tmp_file" ]]; then
  echo -n "  罹"  # nf-mdi-sync_alert
  exit 0
fi

# check if Firefox is playing
if [ "$(playerctl -p firefox status)" = "Playing" ]; then
  modified_ff_sinks=$(pulsemixer --list-sinks | grep 'Name: Firefox' | grep -v '100%')
  if [[ -n "$modified_ff_sinks" ]]; then
    echo "$modified_ff_sinks" | while read -r line; do
      ff_sink_id=$(echo "$line" | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')
      pulsemixer --id "$ff_sink_id" --set-volume 100
    done
  fi
fi

echo -n "  "
