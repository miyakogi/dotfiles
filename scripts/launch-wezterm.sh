#!/usr/bin/env bash

options=()
if ! is-4k; then
  options+=(
    --config-file="$HOME/.config/wezterm/wezterm_fhd.lua"
  )
fi
options+=(start --class wezterm)

wezterm "${options[@]}" "$@"
