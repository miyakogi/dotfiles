#!/bin/sh

if grep "gaps" ~/.config/i3/config >/dev/null; then
  cat ~/.config/i3/config.base ~/.config/i3/config.gaps > ~/.config/i3/config
else
  cp -f ~/.config/i3/config.base ~/.config/i3/config
fi
