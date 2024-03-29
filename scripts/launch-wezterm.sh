#!/usr/bin/env bash

options=()
if ! is-4k; then
  options+=(
    --config-file="$HOME/.config/wezterm/wezterm_fhd.lua"
  )
fi
options+=(start)

if [ "$1" = "--class" ]; then
  options+=("$1" "$2")
  shift
  shift
else
  options+=(--class wezterm)
fi

wezterm "${options[@]}" "$@"
