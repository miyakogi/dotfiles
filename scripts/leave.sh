#!/usr/bin/env bash

# get WM name
#WM=$(wmctrl -m | grep "Name" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')
WM="wlroots wm"

# show menu by rofi (first space is trimmed by sh/bash, so use ASCII code (0x20))
menu=" Lock\n Suspend \n Hibernate \n Exit \n Restart \n Shutdown"

if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  font="Fira Code 28"
else
  font="Fira Code 16.5"
fi

# define colors
white="#c3c7d1"
black="#161925"
red="#ed254e"
green="#00e8c6"
yellow="#f9dc5c"
blue="#7cb7ff"
magenta="#c74ded"
cyan="#00c1e1"

cmd=(
  bemenu
  --prompt "Leave:"  # prompt
  --ignorecase
  --fn "$font"  # font
  --tb "$magenta"   # title background color
  --tf "$black"  # title foreground color
  --fb "$black"  # filter background color
  --ff "$white"  # filter foreground color
  --nb "$black"  # normal background color
  --nf "$white"  # normal foreground color
  --hb "$magenta"   # selected background color
  --hf "$black"  # selected foreground color
  --sb "$magenta"   # selected background color
  --sf "$black"  # selected foreground color
)

RET=$(echo -en $menu | "${cmd[@]}" | tr -d '[:space:]')

_lock() {
  lock-screen
}

_suspend() {
  lock-screen
  sleep 3
  systemctl suspend
}

_hibernate() {
  lock-screen
  sleep 3
  systemctl hibernate
}

_exit() {
  killall redshift
  case $WM in
    bspwm)
      bspc quit;;
    i3)
      i3-msg exit;;
    wlroots*)  # sway
      swaymsg exit;;
    *)
      ;;
  esac
}

_reboot() {
  systemctl reboot
}

_shutdown() {
  systemctl poweroff -i
}

case $RET in
  Lock)
    _lock;;
  Suspend)
    _suspend;;
  Hibernate)
    _hibernate;;
  Exit)
    _exit;;
  Restart)
    _reboot;;
  Shutdown)
    _shutdown;;
  *)
    ;;
esac
