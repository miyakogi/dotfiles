#!/usr/bin/env bash

# list terminals
terminals=(
  alacritty
  kitty
  konsole
  gnome-terminal
  urxvt
  xterm
)

if which st >/dev/null 2>&1; then
  if [[ $(wmctrl -m | grep "Name:" | sed 's/^Name: \(.\+\)$/\1/' | tr '[:upper:]' '[:lower:]') != "kwin" ]]; then
    terminals=(st ${terminals[@]})
  else
    terminals+=( st )
  fi
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  terminals=(foot ${terminals[@]})
fi

function list_terminals() {
  for t in ${terminals[@]}; do
    echo $t
  done
}

# set dmenu command options
dmenu_cmd=(
  dmenu
  -p "Launch Terminal:"  # prompt
  -fn "Fira Code:Regular:pixelsize=20"  # Font
  -nb "#161925"  # normal background color
  -nf "#c3c7d1"  # normal foreground color
  -sb "#00c1e1"  # selected background color
  -sf "#161925"  # selected foreground color
)

_terminal=$( list_terminals | "${dmenu_cmd[@]}" )
case $_terminal in
  foot)
    footclient &
    ;;
  st)
    st -e fish &
    ;;
  *)
    $_terminal &
    ;;
esac

if [[ $XDG_SESSION_TYPE != "wayland" ]]; then
  sleep 0.3
  xdotool key Muhenkan
fi
