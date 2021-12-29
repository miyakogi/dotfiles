#!/usr/bin/bash

### Prompt
# use startship only on graphical session
if [[ -n $DISPLAY ]] && which starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

### Load local settings
if [ -f $HOME/.bashrc.local ]; then
  source "${HOME}/.bashrc.local"
fi

# vim: sw=2 et ft=bash
