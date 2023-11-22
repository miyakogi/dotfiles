#!/usr/bin/env bash

options=(start --class wezterm)
if ! is-4k; then
  options+=(
    --config-file "$HOME/.config/wezterm/wezterm_fhd.lua"
  )
fi

wezterm "${options[@]}" "$@"
