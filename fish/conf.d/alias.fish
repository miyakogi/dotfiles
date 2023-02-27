#!/usr/bin/env fish

# vim-style exit
abbr --add --global :q "exit"

# mkdir -p
abbr --add --global mkdir "mkdir -p"

# tmux
abbr --add --global tmux "env TERM=xterm-256color tmux -2"

# ln -v
abbr --add --global ln "ln -v -s"

# git
abbr --add --global gstatus "git status -s -b"

# python unittest
abbr --add --global pyunit "python -m unittest discover"

# vim/nvim
if type -q nvim
  abbr --add --global vim nvim
  abbr --add --global vi "nvim --noplugin"
end

# editor
if type -q "$EDITOR"
  abbr --add --global e $EDITOR
end

if type -q helix
  abbr --add --global h helix
end

# ls -> lsd
if type -q lsd; and test -n "$DISPLAY"
  abbr --add --global ls "lsd"
  abbr --add --global lsa "lsd --all"
  abbr --add --global lsl "lsd --long"
  abbr --add --global tree "lsd --tree"
else
  abbr --add --global ls "ls -v --color --group-directories-first"
  abbr --add --global lsa "ls -v --color --group-directories-first --all"
  abbr --add --global lsl "ls -v --color --group-directories-first -hl"
end

# ssh
if test $TERM = "alacritty"; or test $TERM = "kitty"; or test $TERM = "foot"
  abbr --add --global ssh "env TERM=xterm-256color ssh"
end

# difftastic
if type -q difft
  abbr --add --global difft "difft --color always --display side-by-side-show-both"
end
