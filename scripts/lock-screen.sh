#!/usr/bin/env zsh

# Based on https://github.com/pavanjadhaw/betterlockscreen

function get_image() {
  local f=$(ls ${XDG_CONFIG_HOME:-$HOME/.config}/$1/lock.{png,jpg} 2>/dev/null | head -n 1)
  if [[ -z $f ]]; then
    echo "--blur=8"
  else
    echo "--image=$f"
  fi
}

function xlock() {
  i3lock \
    --centered -p default $image \
    --timepos='x+110:h-70' --datepos='x+60:h-45' \
    --clock --date-align 1 --datestr="Screen Locked" \
    --insidecolor="$transparent" --ringcolor="$ringcolor" --line-uses-inside \
    --keyhlcolor="$cyan" --bshlcolor="$cyan" --separatorcolor="$transparent" \
    --insidevercolor="$transparent" --insidewrongcolor="$red" --indpos="x+960:y+480" \
    --radius=120 --ring-width=32 --veriftext='Checking...' --wrongtext='WRONG' \
    --greetertext="Enter Password" --greetercolor="$white"\
    --verifcolor="$white" --timecolor="$white" --datecolor="$white" \
    --time-font="$font" --date-font="$font" --layout-font="$font" --verif-font="$font" --wrong-font="$font" greeter-font="$font" --greetersize=124 --greeterpos="x+960:y+$y" \
    --noinputtext='' --force-clock --pass-media-keys
}

function wlock() {
  swaylock -f $image \
    --scaling center \
    --inside-color="$transparent" --ring-color="$ringcolor" --line-uses-inside \
    --key-hl-color="$cyan" --bs-hl-color="$cyan" --separator-color="$transparent" \
    --inside-color="$transparent" --inside-wrong-color="$red" \
    --indicator-radius=120 --indicator-thickness=32 \
    --ring-ver-color="$white" \
    --font="$font"
}

WM=$(wmctrl -m | grep "Name: " | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]')
y=1000

font='Raleway'
white='ffffff88'
transparent='00000000'
ringcolor='01639266'
cyan='016392ff'
red='d23c3dff'

case $WM in
  i3)
    y=200
    image=$(get_image i3)
    xlock;;
  bspwm)
    y=120
    image=$(get_image bspwm)
    xlock;;
  kwin)
    image=$(get_image lxqt)
    xlock;;
  wlroots*)  # sway
    image=$(get_image sway)
    wlock;;
  *)
    image="--blur=8"
    xlock;;
esac
