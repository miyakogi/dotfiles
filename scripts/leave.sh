#!/usr/bin/env bash

# List up menu items
function menu() {
  items=(
    "Lock"
    "Sleep"
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
if [ "$(is-4k)" = true ]; then
  font="JetBrainsMono Nerd Font 26"
else
  font="JetBrainsMono Nerd Font 16"
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

RET=$(menu | "${cmd[@]}" | tr -d '[:space:]')

_lock() {
  lock-screen
}

_sleep() {
  if [ "$XDG_CURRENT_DESKTOP" = sway ]; then
    dpms_on='swaymsg "output * power on"'
    dpms_off='swaymsg "output * power off"'
  elif [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    dpms_on='hyprctl dispatch dpms on DP-1 && sleep 1 && hyprctl dispatch dpms on DP-2'
    dpms_off='hyprctl dispatch dpms off DP-2 && sleep 1 && hyprctl dispatch dpms off DP-1'
    # dpms_on='hyprctl dispatch dpms on && sleep 1 && hyprctl keyword monitor DP-2,1920x1080@144,3840x540,1'
    # dpms_off='hyprctl keyword monitor DP-2,disable && sleep 1 && hyprctl dispatch dpms off'
  fi

  resumecmd="${dpms_on}"
  resumecmd+=" && sleep 1"
  resumecmd+=" && killall swayidle"
  resumecmd+=" && sleep 3"
  resumecmd+=" && systemctl --user restart swayidle.service"

  if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
    resumecmd+=" && if pgrep -x waybar; then; killall waybar; fi"
    resumecmd+=" && if pgrep -x waybar-mpris; then; killall waybar-mpris; fi"
    resumecmd+=" && sleep 1"
    resumecmd+=" && waybar"
  fi

  # execute commands
  systemctl --user stop swayidle.service
  sleep 2
  lock-screen
  swayidle timeout 2 "${dpms_off}" resume "${resumecmd}"
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
  Sleep)
    _sleep;;
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
