#!/usr/bin/env bash

# List up menu items
function menu() {
  items=(
    "Lock"
    "Sleep"
    "Suspend"
    "Hibernate"
    "Exit"
    "Restart"
    "Shutdown"
  )
  for item in "${items[@]}"; do
    echo " $item "
  done
}

# Setup bemenu parameters
if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  font="Fira Code 30"
else
  font="Fira Code 16.5"
fi

# Define colors
# these colors may not be used - disable shellcheck warnings

# shellcheck disable=SC2034
white="#cad3f5"
# shellcheck disable=SC2034
black="#24273a"
# shellcheck disable=SC2034
red="#ed8796"
# shellcheck disable=SC2034
green="#a6da95"
# shellcheck disable=SC2034
yellow="#eed49f"
# shellcheck disable=SC2034
blue="#8aadf4"
# shellcheck disable=SC2034
magenta="#f5bde6"
# shellcheck disable=SC2034
cyan="#8bd5ca"

basecolor="$red"
cmd=(
  bemenu
  --prompt "Leave:"  # prompt
  --ignorecase
  --fn "$font"  # font
  --tb "$basecolor"   # title background color
  --tf "$black"  # title foreground color
  --fb "$black"  # filter background color
  --ff "$white"  # filter foreground color
  --nb "$black"  # normal background color
  --nf "$white"  # normal foreground color
  --hb "$basecolor"   # selected background color
  --hf "$black"  # selected foreground color
  --sb "$basecolor"   # selected background color
  --sf "$black"  # selected foreground color
)

RET=$(menu | "${cmd[@]}" | tr -d '[:space:]')

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
  swaymsg exit
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
