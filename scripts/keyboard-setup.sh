#!/usr/bin/env zsh

setxkbmap -layout jp -option 'ctrl:nocaps'
test -f $HOME/.Xkeymap && sleep 1 && xkbcomp $HOME/.Xkeymap $DISPLAY
