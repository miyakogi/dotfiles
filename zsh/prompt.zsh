#!/usr/bin/env zsh
# ============================================
#  Prompt Setting for ZSH
# ============================================

_ZSH_STARTUP=1

if [[ $OSNAME == Windows ]]; then
  # Windows terminal does not have $DISPLAY
  PROMPT_SIMPLE_MODE=0
elif [[ -n $SSH_CONNECTION ]]; then
  PROMPT_SIMPLE_MODE=0
elif [[ -n $DISPLAY ]]; then
  PROMPT_SIMPLE_MODE=0
else
  PROMPT_SIMPLE_MODE=1
fi
BR=$'\n'

# insert newline after commands (before prompt)
function cmdsep() {
  if [[ -z $_ZSH_STARTUP ]] && [[ $PROMPT_SIMPLE_MODE == 0 ]]; then
    echo ""
  else
    unset _ZSH_STARTUP
  fi
}
add-zsh-hook -Uz precmd cmdsep

### configure lprompt
function _update_lprompt() {
  if [[ $PROMPT_SIMPLE_MODE == 1 ]]; then
    local venv
    if [[ -n "$VIRTUAL_ENV" ]]; then
      venv="($(basename $VIRTUAL_ENV))"
    fi
    PROMPT="${venv}[%~]$BR$ "
    return
  fi

  ### set icon
  local _icon
  if [[ $OSNAME == Mac ]]; then
    _icon=$'\ue711 '  # mac 
  elif [[ $OSNAME == Windows ]]; then
    _icon=' '
  elif [[ $OSNAME == Ubuntu ]]; then
    _icon=$'\uf31b '  # ubuntu 
  elif [[ $OSNAME == Arch ]]; then
    _icon=$'\uf303 '  # Arch 
  else  # other linux
    # icon="🐧"  # penguin
    _icon=$'\uf17c '  # tux 
  fi

  local _icon_sep=$'\ue621'  # separator 
  local _mark
  if [[ $OSNAME == Windows ]]; then
    _mark="$ "
  else
    _mark="└─▶ "
  fi

  local _success_front _success_back
  if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    _success_front="%F{cyan}"
    _success_back="%K{cyan}"
  else
    _success_front="%F{green}"
    _success_back="%K{green}"
  fi
  local _icon_color="%F{008}%(?,$_success_back,%K{yellow})"
  local _icon_dash="%K{008}%(?,%F{green},%F{yellow}) "

  if [[ -n "$VIRTUAL_ENV" ]]; then
    local icon=$'\ue235 '  # python 
    # local icon="🐍"  # snake
    if [[ $OSTYPE == darwin* ]]; then
      local icon="${icon} "
    fi
    local icon="$icon$_icon_sep$(basename $VIRTUAL_ENV) "
  else
    local icon=$_icon
  fi

  if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    local ssh_icon=$'\uf023'  # 
    local icon="$ssh_icon %M $_icon_sep $icon "
  fi

  local mark="%(?,$_success_front$_mark%f,%F{yellow}$_mark%f)%(!,#,)"
  PROMPT="$_icon_color $icon$_icon_dash%F{007}%~ %k$BR$mark"
}

### RPROMPT
### get vcs info
autoload -Uz vcs_info
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats "%u%c %s:%b │%r"
zstyle ':vcs_info:*' actionformats "%u%c %s:%b%F{009} %m <!%a>"
zstyle ':vcs_info:*' unstagedstr "%F{011}?"
zstyle ':vcs_info:*' stagedstr "%F{012}+"
zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:hg:*' check-for-changes true

function _get_vcs_info() {
  # not prompt if vcs_info get nothing
  [[ -z ${vcs_info_msg_0_} ]] && return 0

  # if get info by vcs_info, show $vcs_info_msg_0_, $vcs_info_msg_1_ and $vcs_info_msg_2_
  local -a messages
  [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{white}${vcs_info_msg_0_}" )
  [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}" )
  [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}" )
  # Return to stdout with spaces on each info
  echo -n ${messages[*]}
}

function _get_time() {
  local time=$(date "+%H:%M:%S"$'\ue621'"%Y/%m/%d")
  echo "$time"
}

### configure rprompt
function _update_rprompt() {
  [[ $PROMPT_SIMPLE_MODE -eq 1 ]] && RPROMPT="" && return
  LANG=en_US.UTF-8 vcs_info
  local rinfo
  local gitinfo="$(_get_vcs_info)"
  if [[ -n ${gitinfo} ]]; then
    rinfo=${gitinfo}
  else
    rinfo="%F{007}$(_get_time)"
  fi
  RPROMPT="%K{008} ${rinfo} %f%k"
}

# Delete RPROMPT after commands
# setopt transient_rprompt
function _reupdate_rprompt() {
  if [[ $PROMPT_SIMPLE_MODE -eq 1 ]]; then
    # cannot early return
    RPROMPT=""
  else
    RPROMPT="%F{246}%K{234} $(_get_time) %f%k"
  fi
  zle .accept-line
  zle .reset-prompt
}
# show datetime at old line
zle -N accept-line _reupdate_rprompt

function _update_prompt() {
  _update_lprompt
  _update_rprompt
}

function prompt_simple() {
  PROMPT_SIMPLE_MODE=1
}

function prompt_fancy() {
  PROMPT_SIMPLE_MODE=0
}

### Enable prompt
add-zsh-hook precmd _update_prompt

# vim: set et ts=2 sw=2:
