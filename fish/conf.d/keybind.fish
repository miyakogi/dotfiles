#!/usr/bin/env fish

function fish_user_key_bindings
  bind \cw backward-kill-word
  bind \cy 'commandline "cd ../" ; commandline -f execute'
  bind \cj myjump
  bind \cr search-history
  bind \cf nextd-or-forward-word

  # === keyd fixup ===
  # Caps+w -> Control+Backspace
  bind \cH backward-kill-word  # delete prev word by Control+Backspace
  # Caps+f -> C-f
  bind \e\[C nextd-or-forward-word
end
