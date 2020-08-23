#!/bin/sh

TERM=konsole
TERM_TITLE=scratchkonsole

wid=$(xdotool search --name $TERM_TITLE)
if [[ -z $wid ]]; then
  env DROPDOWN=1 $TERM --title $TERM_TITLE &
  wid=`xdotool search --sync --name $TERM_TITLE`
  bspc node $wid --flag hidden -f
else
  if [[ `xdotool getactivewindow` -eq $wid ]]; then
    bspc node $wid --flag hidden -f
  else
    if [[ ! `xdotool search --onlyvisible --name $TERM_TITLE` ]]; then
      bspc node $wid --flag hidden -f
    fi
    xdotool search --name $TERM_TITLE windowactivate
  fi
fi
