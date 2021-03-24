#!/usr/bin/env fish

# vim-style exit
abbr --add --global :q "exit"

# mkdir -p
abbr --add --global mkdir "mkdir -p"

# tmux
abbr --add --global tmux "env TERM=xterm-256color tmux -2"

# ln -v
abbr --add --global ln "ln -v"

# vi
abbr --add --global vi "vim --no-plugin"

# git
abbr --add --global gstatus "git status -s -b"

# vim/nvim
if type -q nvim; and test $XDG_SESSION_TYPE = wayland
  abbr --add --global vim nvim
  set -x EDITOR nvim
end

# ls -> lsd/exa
if type -q lsd
  abbr --add --global ls lsd
else if type -q exa
  abbr --add --global ls "exa --icons"
end

# ssh
if test $TERM = "alacritty"; or test $TERM = "kitty"; or test $TERM = "foot"
  abbr --add --global ssh "env TERM=xterm-256color ssh"
end
