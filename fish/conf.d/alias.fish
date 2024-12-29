#!/usr/bin/env fish

# vim-style exit
abbr --add --global :q "exit"

# short ls
abbr --add --global l "ls"


# short cd
abbr --add --global c "cd"

# mv -i (ask on overwrite)
abbr --add --global mv "mv -i"

# mkdir -p
abbr --add --global mkdir "mkdir -p"

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

if type -q helix
  abbr --add --global h helix
else if type -q hx
  abbr --add --global h hx
end

# ls -> eza
abbr --add --global lsa "ls --all"
abbr --add --global lsl "ls -l -h"
abbr --add --global lsal "ls --all -l -h"

# ssh
if string match -q -r "(alacritty|foot|.*kitty)" $TERM
  abbr --add --global ssh "env TERM=xterm-256color ssh"
end

# difftastic
if type -q difft
  abbr --add --global difft "difft --color always --display side-by-side-show-both"
end
