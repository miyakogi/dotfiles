#!/usr/bin/env bash

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  loginctl lock-session &
else
  pidof hypridle || hypridle &
fi
