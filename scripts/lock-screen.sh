#!/usr/bin/env bash

if ! type swaylock &>/dev/null; then
  echo "\`swaylock-effects\` should be installed to lock screen"
  exit 1
fi

cmd=(
  swaylock
  --daemonize
)

"${cmd[@]}"
