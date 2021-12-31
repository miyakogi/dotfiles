#!/usr/bin/env fish

# ls color setting
set -x LSCOLORS Exfxcxdxbxegedabagacad
set -x LS_COLORS 'di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# set skim search command
if type -q sk
  set _search_cmd "sk --tac --no-sort --reverse --exact --tiebreak index --ansi -p 'skim>' --margin 2% --query (commandline -b)"
end

# save dirhist on pwd changed
set -x HIST_DIRS_FILE $HOME/.histdir
set -x HIST_DIRS_MAX 1000
function __chpwd --on-variable PWD; chpwd; end

# auto ls on cd
function __auto_ls --on-variable PWD; auto_ls; end

# direnv
if type -q direnv
  direnv hook fish | source
end

# prompt
# both -n and -z $DISPLAY return TRUE on TTY, so use ! -z $DISPLAY here
if type -q starship; and ! test -z $DISPLAY
  starship init fish | source
end
