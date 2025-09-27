#!/usr/bin/env bash

: << COMMENTOUT
Run default terminal.

Available options:
  - alacritty
  - foot
  - ghostty
  - havoc
  - kitty
  - rio
  - wezterm
COMMENTOUT

# Load Environment Variables from SystemD
eval "$(systemctl --user show-environment)"

# Set fallback terminals
case "$XDG_CURRENT_DESKTOP" in
  Hyprland)
    # Hyprland default terminal
    _term_fallback=kitty
    ;;
  sway*)
    # Sway default terminal
    _term_fallback=alacritty
    ;;
  *)
    _term_fallback=alacritty
    ;;
esac

# Set terminal from env var
_term=${TERMINAL:-$_term_fallback}

cmd=("$_term")

# Set initial command options if needed
case "$_term" in
  ghostty)
    # disable +new-window if --class/-e is specified (currently not supported)
    if [ "$1" != "--class" ] && [ "$1" != "-e" ]; then
      cmd+=(+new-window)
    fi
    ;;
  wezterm)
    cmd+=(start --always-new-process)
    ;;
  *)
    ;;
esac

# Set class/app-id
if [ "$1" = "--class" ]; then
  case "$_term" in
    alacritty)
      cmd+=(--class "$2")
      ;;
    foot)
      cmd+=(--app-id "$2")
      ;;
    ghostty)
      cmd+=("--class=com.ghostty.$2")
      ;;
    havoc)
      cmd+=(-i "$2")
      ;;
    kitty)
      cmd+=(--app-id "$2")
      ;;
    rio)
      cmd+=(--title-placeholder "$2")
      ;;
    wezterm)
      cmd+=(--class "$2")
      ;;
    *)
      cmd+=(--class "$2")
      ;;
  esac
  shift 2
fi

# Set command
if [ "$1" = "-e" ]; then
  case "$_term" in
    alacritty)
      # must
      ;;
    foot)
      # optional
      shift
      ;;
    ghostty)
      # must
      ;;
    havoc)
      # should not exist
      shift
      ;;
    kitty)
      # optional
      shift
      ;;
    rio)
      # must
      ;;
    wezterm)
      # optional
      shift
      ;;
    *)
      # do nothing
      ;;
  esac
fi

# Test
# notify-send "Terminal Test" "${cmd[*]} $*"

exec "${cmd[@]}" "$@"
