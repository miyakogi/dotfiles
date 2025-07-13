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

case "$XDG_CURRENT_DESKTOP" in
  Hyprland)
    # Hyprland default terminal
    _term=kitty
    ;;
  sway)
    # Sway default terminal
    _term=foot
    ;;
  *)
    _term=alacritty
    ;;
esac

if [ "$_term" = foot ] && [ -e "$XDG_RUNTIME_DIR/foot-$WAYLAND_DILPLAY.sock" ]; then
  cmd=(footclient)
else
  cmd=("$_term")
fi

case "$_term" in
  # kitty)
  #   # single instance mode
  #   cmd+=(--single-instance)
  #   ;;
  wezterm)
    cmd+=(start --always-new-process)
    ;;
  *)
    ;;
esac

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

if [ "$1" = "-e" ]; then
  case "$_term" in
    alacritty)
      # must
      ;;
    foot)
      # optional
      shift
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
      ;;
  esac
fi

exec "${cmd[@]}" "$@"
