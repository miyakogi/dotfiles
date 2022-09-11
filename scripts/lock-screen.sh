#!/usr/bin/env bash

# Based on https://github.com/pavanjadhaw/betterlockscreen

# Define variables
font='Raleway'
white='ffffff88'
transparent='00000000'
ringcolor='01639266'
cyan='016392ff'
red='d23c3dff'

# Build command
cmd=(
  swaylock
  --daemonize
  --scaling fill
  --inside-color="$transparent"
  --ring-color="$ringcolor"
  --line-uses-inside
  --key-hl-color="$cyan"
  --bs-hl-color="$cyan"
  --separator-color="$transparent"
  --inside-color="$transparent"
  --inside-wrong-color="$red"
  --indicator-radius=120
  --indicator-thickness=32
  --ring-ver-color="$white"
  --font="$font"
)

# Set image paths
directory="${XDG_CONFIG_HOME:-${HOME}/.config}/sway"
f1=$(find "$directory"/lock.{png,jpg} 2>/dev/null | head -n 1)
f2=$(find "$directory"/lock_4k.{png,jpg} 2>/dev/null | head -n 1)
if [[ -n "$f1" ]] && [[ -n "$f2" ]]; then
  cmd+=(
    "--image=DP-1:${f2}"
    "--image=DP-2:${f1}"
  )
elif [[ -n "$f1" ]]; then
  cmd+=(
    "--image=$f1"
  )
elif [[ -n "$f2" ]]; then
  cmd+=(
    "--image=$f2"
  )
else
  cmd+=(
    "--image=blur"
  )
fi

"${cmd[@]}"
