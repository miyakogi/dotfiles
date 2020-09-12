#!/usr/bin/env zsh

WM=$(wmctrl -m | grep "Name: " | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

setxkbmap -layout jp -option 'ctrl:nocaps'

if [[ -f $HOME/.Xkeymap ]]; then
  sleep 1
  xkbcomp $HOME/.Xkeymap $DISPLAY
fi

# start sxhkd for bspwm
if [[ $WM = bspwm ]]; then
  if pgrep -x sxhkd > /dev/null; then
    pkill -USR1 -x sxhkd
  else
    sxhkd -c ~/.config/bspwm/sxhkdrc
  fi
fi
