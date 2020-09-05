#!/bin/sh

WM=$(wmctrl -m | grep "Name: " | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

setxkbmap -layout jp -option 'ctrl:nocaps'
sleep 1
test -f $HOME/.Xkeymap && xkbcomp $HOME/.Xkeymap $DISPLAY

# start sxhkd for bspwm
if [[ $WM = bspwm ]]; then
  if pgrep -x sxhkd > /dev/null; then
    pkill -USR1 -x sxhkd
  else
    sxhkd -c ~/.config/bspwm/sxhkdrc
  fi
fi
