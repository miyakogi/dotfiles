#!/usr/bin/env fish

# ls color setting
set -x LSCOLORS Exfxcxdxbxegedabagacad
set -x LS_COLORS 'di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# set fzf search command
if type -q fzf
  set -x FZF_DEFAULT_COMMAND "fd || find ."
  set -x FZF_DEFAULT_OPTS "--exact"
  set _search_cmd "fzf --tac --no-sort --reverse --exact --tiebreak index --ansi --prompt 'fzf> ' --margin 2% --query (commandline -b)"
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
if type -q starship; and test -n "$DISPLAY"
  starship init fish | source
else
  set -g fish_prompt_pwd_dir_length 0
  function fish_prompt
    printf '[%s] (fish)\n$ ' (prompt_pwd)
  end
end

# zoxide smarter `cd`
if type -q zoxide
  set -x _ZO_FZF_OPTS "--bind=ctrl-z:ignore --exit-0 --height=40% --info=inline --no-sort --reverse --select-1 --exact"
  zoxide init fish | source
end

# load machine local setting (~/.config/fish/local.fish)
if test -f ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end
