#!/bin/sh

TERM=konsole
TERM_TITLE=scratchkonsole

pid=$(xdotool search --name $TERM_TITLE)
if [[ -z $pid ]]; then
  env DROPDOWN=1 $TERM --title $TERM_TITLE &
else
  bspc node $pid --flag hidden -f
fi
