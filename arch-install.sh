#!/usr/bin/env bash

# Install paru and lf
install_aur_package() {
  # Check argument
  if [ -z "$1" ]; then
    echo "ERROR: package name to install is required."
    exit 1
  fi
  target="$1"

  # Check `git` command
  if ! type git &>/dev/null; then
    echo "Installing Git"
    sudo pacman -S git
  fi

  # Install AUR package by makepkg
  origdir="$(realpath "$(pwd)")"
  tmpdir="/tmp/${target}-$(uuidgen)"
  git clone "https://aur.archlinux.org/${target}.git" "${tmpdir}" && \
    cd "${tmpdir}" && \
    makepkg -si
  cd "$origdir" || exit 1
}

# Install packages by makepkg
# Use `-bin` package here to ignore make dependencies and build time
if ! type paru &>/dev/null; then
  echo "paru AUR helper is not installed - automatically isntall it"
  install_aur_package "paru-bin"
fi
if ! type lf &>/dev/null; then
  echo "lf file manager is not installed - automatically isntall it"
  install_aur_package "lf-bin"  # required for paru's PKGBUILD review
fi

# Pickup minimal packages for distrobox environment with this dotfiles
packages=(
  ## Shell
  bash
  python
  fish
  pkgfile  # faster fish command failure support

  ## Build Tools
  # PKGBUILD
  ccache  # for better makepkg build like mesa-git, obs-studio-*, ...
  # Rust
  clang  # for rust packages
  mold  # modern linker for clang, gcc, and rust, used by cargo
  sccache  # rust cache support

  ## Command Line Tools
  # Git
  git
  git-delta  # better diff tool (used by git config)
  difftastic  # syntax-aware diff tool (used by git config)
  gitui  # terminal git ui (used by nvim)

  # Neovim
  neovim
  python-pynvim  # neovim support package
  nodejs  # required for nvim-treesitter...

  # Command-line
  starship  # prompt manager
  direnv  # directory based env setting
  lsd  # ls alternative
  bat  # cat alternative
  fzf  # fuzzy searcher
  fd  # find alternative written by rust
  zoxide  # smart cd

  ## Graphical Session (Wayland)
  xorg-xwayland
  wl-clipbaord
  fcitx5-gtk
)


# List packages to be installed
packages+=(
  ## Terminals
  alacritty
  kitty
  foot
  tmux

  # Command Line Tools
  python-poetry  # python virtualenv/package manager
  zk  # note taking tool
  tig  # simple terminal git ui

  # wayland (sway) session
  sway
  swaybg
  swaylock
  swayidle
  dunst
  grim
  slurp
  swappy
  jq  # used in some scripts for sway
  autotiling
  python-i3ipc  # used in some script for sway
  i3status-rust  # status block generator for sway-bar
  pulsemixer  # used by volume check/fix scripts on i3status-rust
  playerctl  # for audio control by keyboard on sway
  bemenu
  bemenu-wayland
  gammastep
  kvantaum  # qt theme setting

  # input method
  fcitx5
  fcitx5-configtool
  mozc-ut
  fcitx5-mozc-ut

  # font/theme
  adobe-source-han-sans-jp-fonts
  adobe-source-han-serif-jp-fonts
  adobe-source-han-mono-jp-fonts
  ttf-fira-code
  nerd-fonts-fira-code
  ttc-iosevka
  ttf-iosevka-nerd
  ttf-sarasa-gothic  # iosevka + source han sans font for CJK
  ttf-unifont
  ttf-nerd-fonts-symbols
)

paru -S "${packages[@]}"
