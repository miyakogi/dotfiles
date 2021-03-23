#!/usr/bin/env fish

# vim-style exit
alias :q "exit"

# mkdir -p
alias mkdir "mkdir -p"

# tmux
alias tmux "env TERM=xterm-256color tmux -2"

# ln -v
alias ln "ln -v"

# vi
alias vi "vim --no-plugin"

# git
alias gstatus "git status -s -b"

# vim/nvim
if __which nvim; and test $XDG_SESSION_TYPE = wayland
  alias vim nvim
  set -x EDITOR nvim
end

# ls -> exa/lsd
if __which exa
  alias ls "exa --icons"
else if __which lsd
  alias ls lsd
end

# cat -> bat
if __which bat
  alias cat "env PAGER=less bat"
end

# ssh
if test $TERM = "alacritty"; or test $TERM = "kitty"; or test $TERM = "foot"
  alias ssh "env TERM=xterm-256color ssh"
end
