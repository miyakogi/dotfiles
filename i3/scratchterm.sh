#!/bin/sh

if [[ `pgrep -c -f "scratchkonsole"` -eq 0 ]]; then
  env DROPDOWN=1 konsole --title "scratchkonsole" &
  sleep 0.3
fi

i3-msg -q [class="konsole"] scratchpad show

if [[ $1 == "hide" ]]; then
  i3-msg -q [class="konsole"] scratchpad show
fi
