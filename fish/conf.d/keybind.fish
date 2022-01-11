#!/usr/bin/env fish

function fish_user_key_bindings
  bind \cw backward-kill-word
  bind \cy 'commandline "cd ../" ; commandline -f execute'
  bind \cj myjump
  bind \cr search-history
  bind \cf nextd-or-forward-word
end
