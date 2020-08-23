#!/bin/sh

term=konsole
term_title=scratchkonsole
term_class=konsole

wid=$(xdotool search --class $term_class)
if [[ -z $wid ]]; then
  env DROPDOWN=1 $term --title $term_title &
  wid=`xdotool search --sync --name $term_title`
  bspc node $wid --flag hidden -f
else
  if [[ `xdotool getactivewindow` -eq $wid ]]; then
    bspc node $wid --flag hidden -f
  else
    if [[ ! `xdotool search --onlyvisible --class $term_class` ]]; then
      bspc node $wid --flag hidden -f
    fi
    xdotool search --class $term_class windowactivate
  fi
fi
