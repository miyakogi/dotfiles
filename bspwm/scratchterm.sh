#!/bin/sh

term=konsole
term_title=scratchkonsole

wid=$(xdotool search --name $term_title)
if [[ -z $wid ]]; then
  env DROPDOWN=1 $term --title $term_title &
  wid=`xdotool search --sync --name $term_title`
  bspc node $wid --flag hidden -f
else
  if [[ `xdotool getactivewindow` -eq $wid ]]; then
    bspc node $wid --flag hidden -f
  else
    if [[ ! `xdotool search --onlyvisible --name $term_title` ]]; then
      bspc node $wid --flag hidden -f
    fi
    xdotool search --name $term_title windowactivate
  fi
fi
