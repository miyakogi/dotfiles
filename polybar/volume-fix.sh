#!/bin/sh

for playback_input in `pactl list sink-inputs short | awk '{print $1}'`; do
  if [[ $playback_input != 0 ]]; then  # skip id=0 (Null Sink)
    pactl set-sink-input-volume $playback_input 100%
  fi
done
