#!/usr/bin/env bash

sleep 0.1s

tmp_file="/tmp/ff-volume-fix-paused"
space="\u2006"
case "$XDG_CURRENT_DESKTOP" in
  sway*)
    class="state";;
  [Hh]yprland)
    class="class";;
  *)
    class="class";;
esac


# check if disabled
if [ -e "$tmp_file" ]; then
  echo -e "{\"text\": \" ${space} ${space}\", \"$class\": \"Idle\"}"  # nf-cod-sync_ignored + 1/4 rem unicode space (U+2005)
else
  # check if Firefox is playing
  if playerctl -l 2>&1 | grep -q firefox; then
    modified_ff_sinks=$(pulsemixer --list-sinks | grep -e 'Name: Firefox' -e 'Name: Cachy Browser' -e 'Name: Zen' | grep -v '100%')
    if [ -n "$modified_ff_sinks" ]; then
      echo "$modified_ff_sinks" | while read -r line; do
        ff_sink_id=$(echo "$line" | sed -r 's/^.*ID: ([a-zA-Z0-9\-]+).*$/\1/')
        pulsemixer --id "$ff_sink_id" --set-volume 100
      done
    fi
  fi
  echo -e "{\"text\": \" ${space} ${space}\", \"$class\": \"Info\"}"  # nf-cod-sync + 1/4 rem unicode space (U+2005)
fi

exec bash "$0"
