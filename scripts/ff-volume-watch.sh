#!/usr/bin/env bash

tmp_file="/tmp/ff-volume-fix-paused"

# check if disabled
if [ -e "$tmp_file" ]; then
  echo -e '{"text": " \u2005 \u2005"}'  # nf-cod-sync_ignored + 1/4 rem unicode space (U+2005)
else
  # check if Firefox is playing
  if playerctl -l 2>&1 | grep -q firefox; then
    modified_ff_sinks=$(pulsemixer --list-sinks | grep -e 'Name: Firefox' -e 'Name: Cachy Browser' | grep -v '100%')
    if [ -n "$modified_ff_sinks" ]; then
      echo "$modified_ff_sinks" | while read -r line; do
        ff_sink_id=$(echo "$line" | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')
        pulsemixer --id "$ff_sink_id" --set-volume 100
      done
    fi
  fi
  echo -e '{"text": " \u2005 \u2005"}'  # nf-cod-sync + 1/4 rem unicode space (U+2005)
fi

# sleep 0.1s

# exec bash "$0"
