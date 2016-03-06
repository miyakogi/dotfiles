########## FUNCTIONS ##########
function executable { which $1 &> /dev/null }

# Load file if exists
load_if_exists () {
  if [ -f $1 ]; then
    source $1
  fi
}

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

### zaw
# http://yagays.github.io/blog/2013/05/20/zaw-zsh/
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

load_if_exists $ZDOTDIR/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes # 絞り込みをcase-insensitiveに
# For Dolphin
if [ $DOLPHIN ]; then
  bindkey '^L' zaw-cdr # zaw-cdrをbindkey
elif [ $VIM ]; then
  bindkey '^L' zaw-cdr # zaw-cdrをbindkey
else
  bindkey '^J' zaw-cdr # zaw-cdrをbindkey
fi

bindkey '^R' zaw-history # zaw-historyをbindkey

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
# autoload predict-on
# predict-on

########## COMPLETION ##########
# http://d.hatena.ne.jp/oovu70/20120405/p1
autoload -Uz compinit; compinit -C
setopt list_packed
setopt list_types

bindkey "^[[Z" reverse-menu-complete

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

# # pip zsh completion start
# function _pip_completion {
#   local words cword
#   read -Ac words
#   read -cn cword
#   reply=( $( COMP_WORDS="$words[*]" \
#              COMP_CWORD=$(( cword-1 )) \
#              PIP_AUTO_COMPLETE=1 $words[1] ) )
# }
# compctl -K _pip_completion pip
# # pip zsh completion end

########## EDIT ##########
# Set keyword
autoload -Uz select-word-style
select-word-style default
# Add word separations (-,/,=,;,@,:,{,},|,',')
zstyle ':zle:*' word-chars " -/=;@:{},|"
zstyle ':zle:*' word-style unspecified

########## PROMPT ##########
autoload -U colors && colors
### Normal PROMPT
local p_base_ok_ssh="%F{blue}%n@${HOST}%f"
local p_base_ng_ssh="%F{magenta}%n@${HOST}%f"
# local p_base_ng_ssh="%{[38;5;222m%}%n@${HOST}%{[m%}"

local p_cdir="%{[38;5;246m%}[%/]%{[m%}"
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

# PROMPT="$p_mark "
PROMPT="$p_br$p_cdir$p_br$p_mark "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="$p_br$p_cdir_ssh$p_br$p_mark_ssh "

### RPROMPT
# Delete RPROMPT after commands
setopt transient_rprompt

## VCS information at RPROMPT
# http://qiita.com/mollifier/items/8d5a627d773758dd8078
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' formats '%c%u %s:%b│%r'
zstyle ':vcs_info:*' actionformats '%c%u %s:%b %m <!%a>'
zstyle ':vcs_info:*' unstagedstr '?'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:hg:*' check-for-changes true

function _update_vcs_info_msg() {
  local -a messages
  local p_vcs
  LANG=en_US.UTF-8 vcs_info

  if [[ -z ${vcs_info_msg_0_} ]]; then
    # vcs_info で何も取得していない場合はプロンプトを表示しない
    p_vcs=""
  else
    # vcs_info で情報を取得した場合
    # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
    # それぞれ緑、黄色、赤で表示する
    [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{cyan}${vcs_info_msg_0_}%f" )
    [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
    [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

    # 間にスペースを入れて連結する
    p_vcs="${(j: :)messages}"
  fi
  RPROMPT=$p_vcs
}
add-zsh-hook precmd _update_vcs_info_msg

function simple_prompt() {
  PROMPT=">>> "
  RPROMPT=
}

if [ $VIM ]; then
  simple_prompt
fi

########## TAB ##########
# Show Current directory on Tab
# precmd () {
#   echo -ne "\e]2;${PWD}\a"
#   echo -ne "\e]1;${PWD:t}\a"
# }

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
  export LSCOLORS=Exfxcxdxbxegedabagacad
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  export ZLS_COLORS=$LS_COLORS
  export CLICOLOR=true
  export LS_OPTIONS='--color=auto -xF' ;;
esac
if [ -f ~/.dircolors ]; then
  eval "`dircolors ~/.dircolors`"
fi
alias ls="ls $LS_OPTIONS"

# 補完候補に色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# . ~/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh
# ZSH_THEME="powerline"
alias gstatus="git status -s -b"
# http://qiita.com/syui/items/ed2d36698a5cc314557d
load_if_exists ~/.zsh/git-flow-completion/git-flow-completion.zsh

########## SYSTEM VARIABLES ##########
# For vim
# export COLORFGBG="15;0"

########## MACHINE LOCAL SETTING ##########
load_if_exists "$ZDOTDIR/.zshrc.local"

# vim: set et ts=2 sw=2:
