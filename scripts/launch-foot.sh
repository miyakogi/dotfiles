#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--override=font="IBM Plex Mono:size=19.5" --override=font-bold="IBM Plex Mono SmBld:size=19.5" --override=pad=12x12)
fi

foot "${options[@]}" "$@"
