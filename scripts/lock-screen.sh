#!/usr/bin/env bash

if ! type swaylock &>/dev/null; then
  echo "\`swaylock-effects\` should be installed to lock screen"
  exit 1
fi

cmd=(
  swaylock
  --daemonize
  --screenshots
  --font 'GoMono Nerd Font'
  --clock
  --datestr '%b. %-d, %Y'
  --indicator --indicator-radius 320
  --indicator-thickness 16
  --effect-blur 24x4
  --effect-vignette 0.3:0.7
  --ring-color c6a0f6  # mauve
  --ring-clear-color b7bdf8  # lavender
  --ring-ver-color 9ad7e3  # sky
  --ring-wrong-color f5a97f  # peach
  --bs-hl-color ed8796  # red
  --key-hl-color 8aadf4  # blue
  --line-color 00000000
  --line-clear-color 00000000
  --line-ver-color 00000000
  --line-wrong-color 00000000
  --inside-color 00000000
  --inside-clear-color b7bdf899  # lavender
  --inside-ver-color 91d7e399  # sky
  --inside-wrong-color f5a97f99  # peach
  --separator-color 00000000
  --text-color f5bde6  # pink
  --text-clear-color 24273a  # base
  --text-ver-color 24273a  # base
  --text-wrong-color 24273a  # base
  --grace 2
  --fade-in 0.2
)

"${cmd[@]}"
