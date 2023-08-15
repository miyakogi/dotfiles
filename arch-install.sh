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
    sudo pacman -S --noconfirm git
  fi

  # Install AUR package by makepkg
  origdir="$(realpath "$(pwd)")"
  tmpdir="/tmp/${target}-$(uuidgen)"
  git clone "https://aur.archlinux.org/${target}.git" "${tmpdir}" && \
    cd "${tmpdir}" && \
    makepkg -si --noconfirm
  cd "$origdir" || exit 1
}

# Check `base-devel` installation
if ! pacman -Q | grep base-devel; then
  sudo pacman -S --noconfirm base-devel
fi

# Install packages by makepkg
# Use `-bin` package here to ignore make dependencies and build time
if ! type paru &>/dev/null; then
  echo "paru AUR helper is not installed - automatically install it"
  install_aur_package "paru-bin"
fi
if ! type lf &>/dev/null; then
  echo "lf file manager is not installed - automatically install it"
  sudo pacman -S --noconfirm lf
fi

# List minimal packages
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
  nodejs  # required for nvim-treesitter...

  # Termianl multiplexer
  tmux
  zellij

  # Command-line tools
  starship  # prompt manager
  direnv  # directory based env setting
  exa  # ls alternative
  lsd  # ls alternative
  bat  # cat alternative
  fzf  # fuzzy searcher
  fd  # find alternative written by rust
  ripgrep  # better grep
  zoxide  # smart cd
)

# Add packages both for distrobox and full desktop environment
if [ "$install_type" != "min" ]; then
  packages+=(
    ## Graphical Session (Wayland)
    wl-clipboard
    fcitx5-gtk
  )
fi

# Add packages for full desktop environment
if [ "$install_type" = "full" ]; then
  packages+=(
    # Terminals
    alacritty
    wezterm
    kitty
    foot

    # Command Line Tools
    python-poetry  # python virtualenv/package manager
    zk  # note taking tool

    # wayland
    dunst
    grim
    slurp
    swappy
    pngquant  # used for image compression (sscomp command)
    jq  # used in some scripts for sway/hyprland
    xorg-xwayland
    bemenu
    bemenu-wayland
    kvantaum  # qt theme setting

    # sway
    sway
    swaybg
    swayidle
    autotiling
    python-i3ipc  # used in some script for sway
    i3status-rust  # status block generator for sway-bar
    swaylock-effects  # fancy version of swaylock

    # hyprland
    hyprland
    hyprpaper
    waybar-git
    waybar-mpris-git

    # multimedia
    pulsemixer  # used by volume check/fix scripts on i3status-rust
    playerctl  # for audio control by keyboard on sway
    ffmpegthumbnailer  # for video thumbnail preview on file manager

    # input method
    fcitx5
    fcitx5-configtool
    fcitx5-mozc-ext-neologd

    # font/theme
    ttf-roboto
    ttf-genjyuu-gothic  # jp san-serif font
    morisawa-biz-ud-micho-fonts  # default jp serif font
    ttf-jetbrains-mono-nerd  # monospace font with ligatures support
    ttf-unifont
    ttf-nerd-fonts-symbols
  )
fi

# `--needed` flag prevents re-installing
paru -S --needed --noconfirm "${packages[@]}"
