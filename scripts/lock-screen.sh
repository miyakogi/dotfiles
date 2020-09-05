#!/bin/sh

# Based on https://github.com/pavanjadhaw/betterlockscreen

font='Raleway'
white='ffffff88'
transparent='00000000'
ringcolor='01639266'
cyan='016392ff'
red='d23c3dff'

i3lock \
  -t -p default -i $HOME/.config/i3/lock.png \
  --timepos='x+110:h-70' --datepos='x+60:h-45' \
  --clock --date-align 1 --datestr="Screen Locked" \
  --insidecolor="$transparent" --ringcolor="$ringcolor" --line-uses-inside \
  --keyhlcolor="$cyan" --bshlcolor="$cyan" --separatorcolor="$transparent" \
  --insidevercolor="$transparent" --insidewrongcolor="$red" --indpos="x+960:y+480" \
  --radius=120 --ring-width=32 --veriftext='Checking...' --wrongtext='WRONG' \
  --greetertext="Enter Password" --greetercolor="$white"\
  --verifcolor="$white" --timecolor="$white" --datecolor="$white" \
  --time-font="$font" --date-font="$font" --layout-font="$font" --verif-font="$font" --wrong-font="$font" greeter-font="$font" --greetersize=124 --greeterpos="x+960:y+200" \
  --noinputtext='' --force-clock --pass-media-keys
