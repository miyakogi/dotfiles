#!/usr/bin/env bash

if ! type swaylock &>/dev/null; then
  echo "\`swaylock-effects\` should be installed to lock screen"
  exit 1
fi

cmd=(
  swaylock
  --daemonize
  --screenshots
  --font 'Liberation Sans'
  --clock
  --datestr '%b. %-d %Y'
  --indicator
  --indicator-radius 320
  --indicator-thickness 16
  --effect-blur 24x4
  # --effect-greyscale
  --effect-vignette 0.3:0.7
  --ring-color c4a500
  --key-hl-color fee14d
  --line-color 00000000
  --inside-color 00000000
  --separator-color 00000000
  --grace 2
  --fade-in 0.2
)

"${cmd[@]}"
