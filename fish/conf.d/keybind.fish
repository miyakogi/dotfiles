#!/usr/bin/env fish

function fish_user_key_bindings
  bind \cy 'cd ../ ; echo -e "\n" ; commandline -f repaint'
  bind \cj myjump
  bind \cr search-history
  bind \cf nextd-or-forward-word
end
