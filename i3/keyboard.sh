#!/bin/sh

setxkbmap -layout jp -option 'ctrl:nocaps'
sleep 1
if test -f $HOME/.Xkeymap; then
  xkbcomp $HOME/.Xkeymap $DISPLAY
fi
