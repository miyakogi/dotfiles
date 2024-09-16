#!/usr/bin/env bash

# List up menu items
function menu() {
  items=(
    "Lock"
    "Suspend"
    "Hibernate"
    "Exit"
    "Reboot"
    "Shutdown"
  )
  for item in "${items[@]}"; do
    echo " $item "
  done
}

# Setup bemenu parameters
if is-4k; then
  font="Moralerspace Neon NF 20"
else
  font="Moralerspace Neon NF 16"
fi

# Define colors
# these colors may not be used - disable shellcheck warnings

# shellcheck disable=SC2034
white="#f2f4f8"
# shellcheck disable=SC2034
black="#000000"
# shellcheck disable=SC2034
red="#ee5396"
# shellcheck disable=SC2034
green="#25be6a"
# shellcheck disable=SC2034
yellow="#08bdba"
# shellcheck disable=SC2034
blue="#78a9ff"
# shellcheck disable=SC2034
magenta="#be95ff"
# shellcheck disable=SC2034
cyan="#33b1ff"

# set bemenu command options
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
  --fbb "$black"  # feedback background color
  --fbf "$white"  # feedback foreground color
  --sb "$basecolor"   # selected background color
  --sf "$black"  # selected foreground color
  --ab "$black"   # alternating background color
  --af "$white"  # alternating foreground color
)

if ! is-4k; then
  cmd+=(--bottom)
fi

RET=$(menu | "${cmd[@]}" | tr -d '[:space:]')

_lock() {
  lock-screen
}

_suspend() {
  _lock
  sleep 3
  systemctl suspend
}

_hibernate() {
  _lock
  sleep 3
  systemctl hibernate
}

_exit() {
  if [ "$XDG_CURRENT_DESKTOP" = sway ]; then
    swaymsg exit
  elif [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    hyprctl dispatch exit ""
  fi
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
  Reboot)
    _reboot;;
  Shutdown)
    _shutdown;;
  *)
    ;;
esac
