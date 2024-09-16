#!/usr/bin/env bash

# Luanch alacritty terminal with different font size according to output name

options=()
if ! is-4k; then
  options+=(
    --option=window.padding.x=4
    --option=window.padding.y=4
  )
fi

alacritty "${options[@]}" "$@"
