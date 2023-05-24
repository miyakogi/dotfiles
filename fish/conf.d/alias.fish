#!/usr/bin/env fish

# vim-style exit
abbr --add --global :q "exit"

# mv -i (ask on overwrite)
abbr --add --global mv "mv -i"

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

# nvim
if type -q nvim
  abbr --add --global vim nvim
  abbr --add --global vi "nvim --noplugin"
end

# editor
if type -q "$EDITOR"
  abbr --add --global e $EDITOR
end

# ls -> lsd
abbr --add --global lsa "ls --all"
abbr --add --global lsl "ls --long -h"
abbr --add --global lsal "ls --all --long -h"
alias tree="ls --tree 2>/dev/null || command tree"

# ssh
if test $TERM = "alacritty"; or test $TERM = "foot"; or string match -q "*kitty" $TERM
  abbr --add --global ssh "env TERM=xterm-256color ssh"
end

# difftastic
if type -q difft
  abbr --add --global difft "difft --color always --display side-by-side-show-both"
end
