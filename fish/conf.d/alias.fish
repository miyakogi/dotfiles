#!/usr/bin/env fish

# vim-style exit
abbr --add --global :q "exit"

# short cd
abbr --add --global c "cd"

# short ls
abbr --add --global l "ls"

# mv -i (ask on overwrite)
abbr --add --global mv "mv -i"

# mkdir -p
abbr --add --global mkdir "mkdir -p"

# ln -v
abbr --add --global ln "ln -v -s"

# git
abbr --add --global gstatus "git status -s -b"

# editor
abbr --add --global e edit

# nvim
if type -q nvim
  abbr --add --global vim nvim
  abbr --add --global n nvim
  abbr --add --global vi "nvim --noplugin"
end

# helix
if type -q helix
  abbr --add --global h helix
else if type -q hx
  abbr --add --global h hx
end

# ls -> eza
abbr --add --global lsa "ls --all"
abbr --add --global lsl "ls -l -h"
abbr --add --global lsal "ls --all -l -h"

# top
if type -q btop
  abbr --add --global t btop
else if type -q btm
  abbr --add --global t btm
end
if type -q btm
  abbr --add --global b btm
end
