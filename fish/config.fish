#!/usr/bin/env fish

# disable fish greeting message
set fish_greeting

# set skim/percol search command
if __which sk
  set _search_cmd "sk --tac --no-sort --reverse --exact --tiebreak index --ansi -p 'skim>' --margin 2% --query (commandline -b)"
else if __which percol
  set _search_cmd "percol --reverse --query (commandline -b)"
end

# save dirhist on pwd changed
set -x HIST_DIRS_FILE $HOME/.histdir
set -x HIST_DIRS_MAX 5000
function __chpwd --on-variable PWD; chpwd; end

# auto ls on cd
function __auto_ls --on-variable PWD; auto_ls; end

# VirtualFish
set -x VIRTUALFISH_HOME $HOME/.virtualenvs/arch

# prompt
if __which starship
  starship init fish | source
end
