#!/usr/bin/env bash

options=()
if [ ! "$(is-4k)" = true ]; then
  options+=(--config-file "$HOME/.config/wezterm/wezterm_fhd.lua")
fi

wezterm "${options[@]}" "$@"
