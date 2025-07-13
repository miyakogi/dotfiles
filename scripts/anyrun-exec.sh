#!/bin/env bash

cmd=(app2unit)

if [ "$1" == term ]; then
  cmd+=('-T')
  shift
elif [ "$1" == no-term ]; then
  shift
else
  notify-send -u critical "Invalid app command"
  exit 1
fi

killall anyrun
"${cmd[*]}" -- "$@"
