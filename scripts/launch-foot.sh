#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if [ ! "$(is-4k)" = true ]; then
  options+=(--override=font="IBM Plex Mono:size=12.0" --override=font-bold="IBM Plex Mono SmBld:size=12.0" --override=pad=8x8)
fi

foot "${options[@]}" "$@"
