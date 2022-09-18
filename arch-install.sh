#!/usr/bin/env bash

# Install paru and lf
install_aur_package() {
  # Check argument
  if [ -z "$1" ]; then
    echo "ERROR: package to install is required."
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
install_aur_package "paru-bin"
install_aur_package "lf-bin"  # required for paru's PKGBUILD review

# List packages to be installed
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
  gitui  # terminal git ui (used by nvim)
  tig  # simple terminal git ui
  nodejs  # required for nvim-treesitter...

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
