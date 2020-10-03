#!/usr/bin/env zsh

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
  xset dpms 0 0 1200 &

  # set keyboard repeat rate
  xset r rate 300 36

  # enable screen locker
  run xautolock -time 5 -locker lock-screen

  # start polybar
  $CONFIG_HOME/polybar/launch.sh &

  # notification manager
  run dunst

  # klipboard manager
  run klipper
fi

if [[ $WM == kwin* ]]; then
  # start yakuake
  run yakuake
else
  # start redshift
  # need to set $LATITUDE and $LONGITUDE in ~/.zsh/.zshenv.local
  run redshift -l ${LATITUDE}:${LONGITUDE}
fi

if [[ -z $DE ]]; then
  # run polkit agent for non-DE environment (for bspwm and i3)
  run /usr/lib/polkit-kde-authentication-agent-1
fi

# IME
run ibus-daemon -drx

# mouse gesture
run easystroke

# WM/DE specific setup
case $WM in
  bspwm)
    # wallpaper
    feh --bg-scale $(ls $CONFIG_HOME/bspwm/bg.{jpg,png} 2>/dev/null | head -n 1) &

    # sxhkd (keyboard shortcut)
    if pgrep -x sxhkd > /dev/null; then
      pkill -USR1 -x sxhkd &
    else
      sxhkd -c $CONFIG_HOME/bspwm/sxhkdrc &
    fi

    # scratchpad terminal
    pgrep -f scratchkitty > /dev/null || $CONFIG_HOME/bspwm/scratchterm.sh hide &
    ;;
  i3)
    /usr/lib/pam_kwallet_init &

    # wallpaper
    feh --bg-scale $(ls $CONFIG_HOME/i3/bg.{jpg,png} 2>/dev/null | head -n 1) &

    # enable auto titling
    autotiling &

    # setup scratchpad
    $CONFIG_HOME/i3/scratchterm.py hide &
    ;;
  kwin-lxqt)
    # enable krohnkite
    run krohnkite-control enable

    # lxqt monitor setup
    run lxqt-config-monitor -l
    ;;
  kwin-kde)
    # disable krohnkite
    run krohnkite-control disable

    # KDE keyboard setup
    run ksuperkey
    run xbindkeys
    ;;
esac
