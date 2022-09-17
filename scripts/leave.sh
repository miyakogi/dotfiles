#!/usr/bin/env bash

# get WM name
#WM=$(wmctrl -m | grep "Name" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')
WM="wlroots wm"

# show menu by rofi (first space is trimmed by sh/bash, so use ASCII code (0x20))
menu=" Lock \n Sleep \n Suspend \n Hibernate \n Exit \n Restart \n Shutdown "

if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  font="Fira Code 30"
else
  font="Fira Code 16.5"
fi

# Define colors
# these colors may not be used - disable shellcheck warnings

# shellcheck disable=SC2034
white="#edf0f5"
# shellcheck disable=SC2034
black="#282828"
# shellcheck disable=SC2034
red="#e64e42"
# shellcheck disable=SC2034
green="#48d684"
# shellcheck disable=SC2034
yellow="#f9a55b"
# shellcheck disable=SC2034
blue="#00ad9f"
# shellcheck disable=SC2034
magenta="#9059c8"
# shellcheck disable=SC2034
cyan="#6699ee"


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

RET=$(echo -en "$menu" | "${cmd[@]}" | tr -d '[:space:]')

_lock() {
  lock-screen
}

_sleep() {
  resumecmd='swaymsg "output * power on"'
  resumecmd+=' && sleep 1'
  resumecmd+=' && pkill swayidle'
  resumecmd+=' && sleep 1'
  resumecmd+=' && systemctl --user restart swayidle.service'
  systemctl --user stop swayidle.service
  lock-screen
  swayidle -w timeout 1 'swaymsg "output * power off"' resume "$resumecmd"
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
  Sleep)
    _sleep;;
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
