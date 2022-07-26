#!/usr/bin/env fish

# vim-style exit
abbr --add --global :q "exit"

# mkdir -p
abbr --add --global mkdir "mkdir -p"

# tmux
abbr --add --global tmux "env TERM=xterm-256color tmux -2"

# ln -v
abbr --add --global ln "ln -v -s"

# vi
abbr --add --global vi "vim --noplugin"

# git
abbr --add --global gstatus "git status -s -b"

# python unittest
abbr --add --global pyunit "python -m unittest discover"

# vim/nvim
if type -q nvim
  abbr --add --global vim nvim
  set -x EDITOR nvim
end

# ls -> lsd/exa
if type -q lsd; and test -n "$DISPLAY"
  abbr --add --global ls "lsd"
  abbr --add --global lsa "lsd --all"
  abbr --add --global lsl "lsd --long"
  abbr --add --global tree "lsd --tree"
else if type -q exa; and test -n "$DISPLAY"
  abbr --add --global ls "exa --icons"
  abbr --add --global lsa "exa --icons --all"
  abbr --add --global lsl "exa --icons --long"
  abbr --add --global tree "exa --icons --tree"
else
  abbr --add --global ls "ls -v --color --group-directories-first"
  abbr --add --global lsa "ls -v --color --group-directories-first --all"
  abbr --add --global lsl "ls -v --color --group-directories-first -hl"
end

# ssh
if test $TERM = "alacritty"; or test $TERM = "kitty"; or test $TERM = "foot"
  abbr --add --global ssh "env TERM=xterm-256color ssh"
end
