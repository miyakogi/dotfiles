#!/usr/bin/env bash


# Check required install type: full or min (container)
declare _install_type
declare install_type

if [ -n "$1" ]; then
  _install_type="$1"
else
  echo -n "Choose install type from [min, distrobox, full]: "
  read -r _install_type
fi

case "$_install_type" in
  min*)
    install_type="min"
    echo -e "\e[1;32m=== Start minimal installation ===\e[m"
    echo "Press some key to continue, or press <C-c> to cancel"
    read -r _
    ;;
  distrobox)
    install_type="distrobox"
    echo -e "\e[1;32m=== Start installation for distrobox-container ===\e[m"
    echo "Press some key to continue, or press <C-c> to cancel"
    read -r _
    ;;
  full)
    install_type="full"
    echo -e "\e[1;32m=== Start full installation ===\e[m"
    echo "Press some key to continue, or press <C-c> to cancel"
    read -r _
    ;;
  *)
    echo -e "\e[1;31mERROR: Invalid option selected: $_install_type\e[m"
    echo -e "\e[1;31m       Choose from: [full, min, distrobox]\e[m"
    exit 1
    ;;
esac


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

# List minimal packages for distrobox environment with this dotfiles
packages=(
  ## Shell
  bash
  python
  fish
  pkgfile  # faster fish command failure support
  man-db  # man command

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
  ripgrep  # better grep
  zoxide  # smart cd
)

# Install minimal setup for non-graphical environment (e.g. ssh server or simple container)
if [ "$install_type" = "min" ]; then
  paru -S "${packages[@]}"
  exit
fi

# Add packages for distrobox environment
packages+=(
  ## Graphical Session (Wayland)
  wl-clipboard
  fcitx5-gtk
)

# Install for distrobox container
if [ "$install_type" = "distrobox" ]; then
  paru -S "${packages[@]}"
  exit
fi


# Add packages to be installed for full/base system
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
  xorg-xwayland
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
  ttc-iosevka
  ttf-recursive
  ttf-sarasa-gothic  # iosevka + source han sans font for CJK
  ttf-unifont
  ttf-nerd-fonts-symbols
  ttf-plemoljp
)

paru -S "${packages[@]}"
