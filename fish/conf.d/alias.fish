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
if __which nvim; and test $XDG_SESSION_TYPE = wayland
  abbr --add --global vim nvim
  set -x EDITOR nvim
end

# ls -> exa/lsd
if __which exa
  abbr --add --global ls "exa --icons"
else if __which lsd
  abbr --add --global ls lsd
end

# cat -> bat
if __which bat
  abbr --add --global cat "env PAGER=less bat"
end

# ssh
if test $TERM = "alacritty"; or test $TERM = "kitty"; or test $TERM = "foot"
  abbr --add --global ssh "env TERM=xterm-256color ssh"
end
