#!/usr/bin/env bash

install_paru() {
  if ! type git &>/dev/null; then
    echo "Install git"
    sudo pacman -S git
  fi

  if ! type cargo &>/dev/null; then
    echo "Install cargo/rustc by rustup"
    sudo pacman -S rustup
    # install and set stable channel as defualt for rustc
    rustup default stable
  fi

  curdir=$PWD
  git clone https://aur.archlinux.org/paru.git /tmp/paru && cd /tmp/paru && makepkg -si
  cd "$curdir" || exit 1
}

if ! type paru &>/dev/null; then
  echo "Need \`paru\` AUR helper to be installed."
  echo -n "Automatically install paru now? [y/N]"
  read -r ans
  case $ans in
    [Yy]*)
      install_paru;;
    *)
      echo "You can manually install paru by below command:"
      echo "git clone https://aru.archlinux.org/paru.git && cd paru && makepkg -si"
      exit 1;;
  esac
fi

packages=(
  # shell
  python
  bash
  fish

  # terminals
  alacritty
  kitty
  foot
  tmux

  # cli tools
  git
  neovim
  python-pynvim  # neovim support package
  ctags
  ccache
  mold  # modern linker for clang, gcc, and rust
  sccache  # rustc cache support
  starship  # prompt manager
  direnv  # directory based env setting
  python-poetry  # python virtualenv/package manager
  lsd  # ls alternative
  bat  # cat alternative
  fzf  # fuzzy searcher
  fd  # find alternative written by rust
  pkgfile  # faster fish command failure support
  jq  # used in some scripts
  zoxide  # smart cd
  zk  # note taking tool
  git-delta  # better diff tool
  difftastic  # syntax-aware diff tool

  # wayland (sway) session
  xorg-xwayland
  sway
  swaybg
  swaylock
  swayidle
  dunst
  grim
  slurp
  swappy
  autotiling
  python-i3ipc
  i3status-rust  # status block generator for swaybar
  pulsemixer  # used by volume check/fix scripts on i3status-rust
  playerctl  # for audio control by keyboard on sway
  bemenu
  bemenu-wayland
  gammastep
  wl-clipbaord
  kvantaum  # qt theme setting

  # input method
  fcitx5
  fcitx5-configtool
  fcitx5-gtk
  mozc-ut
  fcitx5-mozc-ut

  # font/theme
  adobe-source-han-sans-jp-fonts
  adobe-source-han-mono-jp-fonts
  ttf-fira-code
  nerd-fonts-fira-code
  ttc-iosevka
  ttf-iosevka-nerd
  ttf-sarasa-gothic  # iosevka + source han sans font for CJK
  ttf-unifont
  ttf-nerd-fonts-symbols
  papirus-icon-theme
)

paru -S "${packages[@]}"
