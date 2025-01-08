#!/usr/bin/env fish

function fish_user_key_bindings
  if test $__fish_initialized -lt 3800  # for old fish
    bind \cw backward-kill-word
    bind \b backward-kill-word  # Ctrl+Backspace for old fish
    bind \cy 'commandline "cd ../" ; commandline -f execute'
    bind \cj myjump
    bind \cf nextd-or-forward-word

    # disable C-d to close shell on terminal multiplexer
    if [ -n "$ZELLIJ" ] || [ -n "$TMUX" ]
      bind \cd delete-char
    end
  else  # for new, rusty fish
    bind ctrl-w backward-kill-word
    if test "$TERM" = "xterm-ghostty"
      bind ctrl-Backspace backward-kill-word  # (not working on fish-4.0b1)
      bind \b backward-kill-word  # Ctrl+Backspace for old fish
    end
    bind ctrl-y 'commandline "cd ../" ; commandline -f execute'
    bind ctrl-j myjump
    bind ctrl-f nextd-or-forward-word

    # disable C-d to close shell on terminal multiplexer
    if [ -n "$ZELLIJ" ] || [ -n "$TMUX" ]
      bind ctrl-d delete-char
    end
  end
end
