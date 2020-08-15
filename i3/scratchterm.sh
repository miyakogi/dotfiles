#!/bin/sh

if [[ `pgrep -c -f "scratchkonsole"` -eq 0 ]]; then
  konsole --title "scratchkonsole" &
  sleep 0.5
fi

i3-msg -q [class="konsole"] scratchpad show
