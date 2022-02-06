#!/usr/bin/env bash

# Based on https://github.com/pavanjadhaw/betterlockscreen

get_image() {
  local f=$(ls ${XDG_CONFIG_HOME:-$HOME/.config}/$1/lock.{png,jpg} 2>/dev/null | head -n 1)
  if [[ -z $f ]]; then
    echo "--blur=8"
  else
    echo "--image=$f"
  fi
}

xlock() {
  i3lock \
    --centered -p default $image \
    --time-pos='x+110:h-70' --date-pos='x+60:h-45' \
    --clock --date-align 1 --date-str="Screen Locked" \
    --inside-color="$transparent" --ring-color="$ringcolor" --line-uses-inside \
    --keyhl-color="$cyan" --bshl-color="$cyan" --separator-color="$transparent" \
    --insidever-color="$transparent" --insidewrong-color="$red" --ind-pos="x+960:y+480" \
    --radius=120 --ring-width=32 --verif-text='Checking...' --wrong-text='WRONG' \
    --greeter-text="Enter Password" --greeter-color="$white"\
    --verif-color="$white" --time-color="$white" --date-color="$white" \
    --time-font="$font" --date-font="$font" --layout-font="$font" --verif-font="$font" --wrong-font="$font" --greeter-font="$font" --greeter-size=124 --greeter-pos="x+960:y+$y" \
    --noinput-text='' --force-clock --pass-media-keys
}

wlock() {
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
  wlroots*)  # sway
    image=$(get_image sway)
    wlock;;
  *)
    image="--blur=8"
    xlock;;
esac
