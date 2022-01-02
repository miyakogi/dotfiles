#!/usr/bin/env bash

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
WM=$(wmctrl -m | grep "Name:" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')
DE=$(echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]')
if [[ -n $DE ]]; then
  WM=$WM-$DE
fi

function run() {
  if ! pgrep -x $1 > /dev/null; then
    $@ &
  fi
}

if [[ $DE != "kde" ]]; then
  # keyboard
  keyboard-setup &

  # numlock on
  numlockx on &

  # set display settings
  xset s off &
  xset dpms 0 0 600 &

  # set keyboard repeat rate
  xset r rate 300 36

  # enable screen locker
  run xautolock -time 5 -locker lock-screen

  # notification manager
  run dunst
fi

if [[ $WM == kwin* ]]; then
  # start yakuake
  run yakuake

  # klipboard manager
  run klipper
else
  # start redshift
  # need to set $LATITUDE and $LONGITUDE in ~/.zsh/.zshenv.local
  # run redshift -l ${LATITUDE}:${LONGITUDE} -t 6500:5200
  run redshift -l ${LATITUDE}:${LONGITUDE}

  # picom compositor
  run picom
fi

if [[ -z $DE ]]; then
  # run polkit agent for non-DE environment (for bspwm and i3)
  run /usr/lib/polkit-kde-authentication-agent-1
fi

# set mouse buttons profile for X11 by piper/ratbagd
ratbagctl warbling-mara profile active set 0 &

# IME (daemon mode)
run fcitx5 -d

# WM/DE specific setup
case $WM in
  bspwm)
    # wallpaper
    feh --bg-scale $(ls $CONFIG_HOME/bspwm/bg.{jpg,png} 2>/dev/null | head -n 1) &

    # start polybar
    $CONFIG_HOME/polybar/launch.sh &

    # sxhkd (keyboard shortcut)
    if pgrep -x sxhkd > /dev/null; then
      pkill -USR1 -x sxhkd &
    else
      sxhkd -m -1 -c $CONFIG_HOME/bspwm/sxhkdrc &
    fi
    ;;
  i3)
    /usr/lib/pam_kwallet_init &

    # wallpaper
    feh --bg-scale $(ls $CONFIG_HOME/i3/bg.{jpg,png} 2>/dev/null | head -n 1) &

    # enable auto titling
    autotiling &
    ;;
  kwin-lxqt)
    # enable krohnkite
    run krohnkite-control enable

    # start polybar
    $CONFIG_HOME/polybar/launch.sh &

    # lxqt monitor setup
    # run lxqt-config-monitor -l
    ;;
  kwin-kde)
    # disable krohnkite
    run krohnkite-control disable

    # KDE keyboard setup
    run ksuperkey
    run xbindkeys
    ;;
esac
