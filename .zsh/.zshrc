########## HISTORY ##########
HISTFILE=~/.histfile
DIRSTACKSIZE=1000
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history
bindkey -e
setopt hist_verify
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "" history-beginning-search-backward-end
bindkey "" history-beginning-search-forward-end

### zsh-completions
# http://www.slideshare.net/mollifier/zsh-3?next_slideshow=1
fpath=($HOME/.zsh/zsh-completions/src(N-/) $fpath)

### Buffer stack
show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line
}
zle -N show_buffer_stack
setopt noflowcontrol
# bindkey '' show_buffer_stack

######### Shell options ##########
setopt correct
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
# autoload -U colors && colors
autoload -Uz is-at-least
# autoload predict-on
# predict-on

# 色設定
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true

########## COMPLETION ##########
# http://d.hatena.ne.jp/oovu70/20120405/p1
autoload -Uz compinit && compinit -C
setopt list_packed
setopt list_types

bindkey "^[[Z" reverse-menu-complete
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'
# 補完候補に色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

########## EDIT ##########
# Set keyword
autoload -Uz select-word-style
select-word-style default
# Add word separations (-,/,=,;,@,:,{,},|,',')
zstyle ':zle:*' word-chars " -/=;@:{},|"
zstyle ':zle:*' word-style unspecified

########## ALIAS ##########
alias vi="/usr/bin/vim --noplugin"
alias :q="exit"
alias tmux="tmux -2"

case "${OSTYPE}" in
# Mac(Unix)
darwin*)
  export LS_OPTIONS='-xFG' ;;
# Linux
linux*)
  export LS_OPTIONS='--color=auto -xF' ;;
esac
if [ -f ~/.dircolors ]; then
  eval "`dircolors ~/.dircolors`"
fi
alias ls="ls $LS_OPTIONS"

# . ~/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh
# ZSH_THEME="powerline"
alias gstatus="git status -s -b"
# http://qiita.com/syui/items/ed2d36698a5cc314557d

######### VCS information ###########
# http://qiita.com/mollifier/items/8d5a627d773758dd8078
autoload -Uz vcs_info
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' formats '%c%u %s:%b│%r'
zstyle ':vcs_info:*' actionformats '%c%u %s:%b %m <!%a>'
zstyle ':vcs_info:*' unstagedstr '?'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:hg:*' check-for-changes true

function _get_vcs_info() {
  # vcs_info で何も取得していない場合はプロンプトを表示しない
  [[ -z ${vcs_info_msg_0_} ]] && return 0

  # vcs_info で情報を取得した場合
  # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
  # それぞれ緑、黄色、赤で表示する
  local -a messages
  [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{cyan}${vcs_info_msg_0_}%f" )
  [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
  [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )
  # 間にスペースを入れて連結して標準出録へ
  echo -n "${messages[*]}"
}

function _get_env() {
  local -a res
  [[ -n "$DIRENV_DIR" ]] && res+=("direnv")
  [[ -n "$VIRTUAL_ENV" ]] && res+=("pyvenv")
  [[ $#res -gt 0 ]] && echo -n "(${res[*]})"
}

########## PROMPT ##########
### Normal PROMPT
SIMPLE_PROMPT_MODE=0
function _update_lprompt() {
  if [ $SIMPLE_PROMPT_MODE = 1 ]; then
    PROMPT=">>> "
    return 0
  fi
  local p_base_ok_ssh="%F{blue}%n@${HOST}%f"
  local p_base_ng_ssh="%F{magenta}%n@${HOST}%f"
  # local p_base_ng_ssh="%{[38;5;222m%}%n@${HOST}%{[m%}"

  local p_cdir="%{[38;5;246m%}[%/] `_get_env`%{[m%}"
  local p_cdir_ssh="%(?,$p_base_ok_ssh ,$p_base_ng_ssh )%(!,#,)%{[38;5;252m%}[%/]%{[m%}"
  local p_err_mark="%{[38;5;124m%}✘ %{[m%}"
  local p_cdir="$p_cdir%(?,,$p_err_mark)%(!,#,)"
  local p_cdir_ssh="$p_cdir_ssh%(?,,$p_err_mark)%(!,#,)"

  local p_br=$'\n'
  local p_mark_ok="%F{green}>>>%f"
  local p_mark_ok_ssh="%F{blue}>>>%f"
  local p_mark_ng="%F{yellow}>>>%f"
  local p_mark_ng_ssh="%F{magenta}>>>%f"
  local p_mark="%B%(?,$p_mark_ok,$p_mark_ng)%(!,#,)%b"
  local p_mark_ssh="%B%(?,$p_mark_ok_ssh,$p_mark_ng_ssh)%(!,#,)%b"

  if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]
  then PROMPT="$p_br$p_cdir_ssh$p_br$p_mark_ssh "
  else PROMPT="$p_br$p_cdir$p_br$p_mark "
  fi
}

### RPROMPT
# Delete RPROMPT after commands
setopt transient_rprompt
function _update_rprompt() {
  if [ $SIMPLE_PROMPT_MODE = 1 ]; then
    RPROMPT=""
    return
  fi
  LANG=en_US.UTF-8 vcs_info
  RPROMPT=`_get_vcs_info`
}

function _update_prompt() {
  _update_lprompt
  _update_rprompt
}
add-zsh-hook precmd _update_prompt

function simple_prompt() {
  SIMPLE_PROMPT_MODE=1
  _update_prompt
  _update_vcs_info_msg
}
[[ $VIM ]] && simple_prompt

########## SYSTEM VARIABLES ##########
# For vim
# export COLORFGBG="15;0"

# Load file if exists
function load_if_exists() { [[ -f $1 ]] && source $1 }

########## MACHINE LOCAL SETTING ##########
load_if_exists "$ZDOTDIR/.zshrc.local"

########## PythonZ ##########
load_if_exists $HOME/.pythonz/etc/bashrc

########## direnv ##########
which direnv > /dev/null && eval "$(direnv hook zsh)"

########## Plugin Settings ##########
load_if_exists $ZDOTDIR/git-flow-completion/git-flow-completion.zsh
### zsh-autoenv
load_if_exists $ZDOTDIR/zsh-autoenv/autoenv.zsh

# とても遅い。。。
# http://yagays.github.io/blog/2013/05/20/zaw-zsh/
# Save cd history
# autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
# add-zsh-hook chpwd chpwd_recent_dirs
# zstyle ':chpwd:*' recent-dirs-max 5000
# zstyle ':chpwd:*' recent-dirs-default yes
# zstyle ':completion:*' recent-dirs-insert both
recent_dirs_file=$HOME/.histdir
recent_dirs_max=5000
function cdhist() {
  python << EOS
from os import path
from itertools import chain
curdir = path.abspath('.') + '\n'
if path.isfile('${recent_dirs_file}'):
    with open('${recent_dirs_file}', 'r') as f:
        lines = f.readlines()
    if len(lines) > ${recent_dirs_max}:
        lines = lines[-${recent_dirs_max}:]
    if curdir in lines:
        lines.remove(curdir)
    lines.append(curdir)
    with open('${recent_dirs_file}', 'w') as f:
        f.write(''.join(lines))
EOS
}
add-zsh-hook chpwd cdhist

### percol
if which percol > /dev/null; then
  local percol_cmd='percol --reverse --query "$LBUFFER"'

  function percol-select-history() {
    BUFFER=$(history -n 1 | eval ${percol_cmd})
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N percol-select-history
  bindkey '^R' percol-select-history

  function myjump() {
    local destination=$([[ -e $recent_dirs_file ]] && cat $recent_dirs_file | eval ${percol_cmd})
    [[ -n "$destination" ]] && zle -U "cd $destination"
    zle reset-prompt
  }
else
  # percol is not available, use zaw
  load_if_exists $ZDOTDIR/zaw/zaw.zsh
  zstyle ':filter-select' case-insensitive yes # 絞り込みをcase-insensitiveに
  bindkey '^R' zaw-history # zaw-historyをbindkey
  function myjump() { zaw-cdr }
fi

zle -N myjump
if [ $DOLPHIN ]
then bindkey '^L' myjump
elif [ $VIM ]
then bindkey '^L' myjump
else bindkey '^J' myjump
fi

PROJECT_HOME=$HOME/Projects
PYVENV_DIR=$HOME/.pyvenv
function mkpj() {
  ! which pyvenv > /dev/null 2>&1 && echo "pyvenv is not installed." && return 1
  local pjdir=$PROJECT_HOME/$1
  local vdir=$PYVENV_DIR/$1
  [[ -e $pjdir ]] && echo "Target project ${pjdir} already exists." && return 1
  [[ -e $vdir ]] && echo "Target venv ${vdir} already exists." && return 1
  mkdir $pjdir
  cd $pjdir
  ! which autoenv_source_parent > /dev/null 2>&1 && return 1

  # make new venv
  echo "Preparing new venv (${vdir}) ......... "
  pyvenv "$vdir"
  [[ ! -e $vdir ]] && echo "Failed to make new venv" && return 1
  local activate_file=$vdir/bin/activate
  [[ ! -e $activate_file ]] && echo "Activation script $activate_file not exists" && return 1
  [[ -e $vdir/bin/pip ]] && $vdir/bin/pip install -U pip setuptools
  echo "done."

  # prepare scripts for zsh-autoenv
  cat << EOS > $pjdir/.autoenv.zsh
autostash PYVENV_NAME=${1}
[[ -e ${activate_file} ]] && echo "Activate Venv (\${PYVENV_NAME})" && source ${activate_file}
EOS
  cat << EOS > $pjdir/.autoenv_leave.zsh
[[ -n \${VIRTUAL_ENV} ]] && echo "Deactivate Venv (\${PYVENV_NAME})" && deactivate
EOS

  # authorize new script
  if which _autoenv_authorize > /dev/null 2>&1
  then _autoenv_authorize $pjdir/.autoenv.zsh && _autoenv_authorize $pjdir/.autoenv_leave.zsh
  else echo "Failed to automatically authorize autoenv script." && return 1
  fi

  # activate new env, hook autoenv chpwd handler
  which _autoenv_chpwd_handler > /dev/null 2>&1 && _autoenv_chpwd_handler
}

function rmvenv() {
  local vdir=$PYVENV_DIR/$1
  [[ ! -e $vdir ]] && echo "No such venv: $1 ($vdir)" && return 1
  echo -n "    Removing $vdir ......... "
  rm -r $vdir
  echo "done."
}

# vim: set et ts=2 sw=2:
