#!/usr/bin/env bash

space="\u2006"
case "$XDG_CURRENT_DESKTOP" in
  sway)
    class="state";;
  [Hh]yprland)
    class="class";;
  *)
    class="class";;
esac

if systemctl --user -q is-active quiet swayidle.service; then
  echo -n -e "{ \"text\": \"${space}\", \"$class\": \"Idle\" }"  # U+2005: 1/4 space
else
  echo -n -e "{ \"text\": \"${space}\", \"$class\": \"Info\" }"  # U+2005: 1/4 space
fi
