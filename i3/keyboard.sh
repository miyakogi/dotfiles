#!/bin/sh

setxkbmap -layout jp -option 'ctrl:nocaps'
sleep 1
if test -f $HOME/.Xkeymap; then
  xkbcomp $HOME/.Xkeymap $DISPLAY
fi

# start sxhkd for bspwm
if wmctrl -m | grep bspwm > /dev/null; then
  if pgrep -x sxhkd > /dev/null; then
    pkill -USR1 -x sxhkd
  else
    sxhkd -c ~/.config/bspwm/sxhkdrc
  fi
fi
