#!/usr/bin/sh

# get WM name
WM=$(wmctrl -m | grep "Name" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')

# show menu by rofi (first space is trimmed by sh/bash, so use ASCII code (0x20))
menu="\x20Lock\0icon\x1fsystem-lock-screen\n Exit\0icon\x1fsystem-logout\n Restart\0icon\x1fsystem-reboot\n Shutdown\0icon\x1fsystem-shutdown"
RET=$(echo -en $menu | rofi -dmenu -i -p "Select" -theme leave-theme -icon-theme Numix | tr -d '[:space:]')

function lock() {
  lock-screen
}

function _exit() {
  killall redshift
  case $WM in
    awesome)
      awesome-client "awesome.quit()";;
    bspwm)
      bspc quit;;
    i3)
      i3-msg exit;;
    kwin)
      lxqt-leave --logout;;
    wlroots*)  # sway
      swaymsg exit;;
    *)
      ;;
  esac
}

function reboot() {
  if [[ $WM == "kwin" ]]; then
    lxqt-leave --reboot
  else
    systemctl reboot
  fi
}

function shutdown() {
  if [[ $WM == "kwin" ]]; then
    lxqt-leave --shutdown
  else
    systemctl poweroff -i
  fi
}

case $RET in
  Lock)
    lock;;
  Exit)
    _exit;;
  Restart)
    reboot;;
  Shutdown)
    shutdown;;
  *)
    ;;
esac
