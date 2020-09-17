#!/usr/bin/env zsh

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
if grep "gaps" $CONFIG_HOME/i3/config > /dev/null; then
  cat $CONFIG_HOME/i3/config.base $CONFIG_HOME/i3/config.gaps > $CONFIG_HOME/i3/config
else
  cp -f $CONFIG_HOME/i3/config.base $CONFIG_HOME/i3/config
fi
