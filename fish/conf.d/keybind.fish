#!/usr/bin/env fish

function fish_user_key_bindings
  bind \cw backward-kill-word
  bind \b backward-kill-word  # Ctrl+Backspace
  bind \cy 'commandline "cd ../" ; commandline -f execute'
  bind \cj myjump
  bind \cf nextd-or-forward-word

  # disable C-d to close shell on terminal multiplexer
  if [ -n "$ZELLIJ" ] || [ -n "$TMUX" ]
    bind \cd delete-char
  end
end
