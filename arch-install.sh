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
  cd $curdir
}

if ! type paru &>/dev/null; then
  echo "Need \`paru\` AUR helper to be installed."
  echo -n "Automatically install paru now? [y/N]"
  read ans
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
  python
  bash
  zsh
  fish
  git
  locale  # need to run xterm with utf8 mode
  xterm
  rxvt-unicode
  alacritty
  kitty
  foot
  tmux
  #gvim  # normal vim packages does not support clipboard
  neovim
  python-pynvim  # neovim support package
  ctags
  i3-gaps  # gap-supported version
  bspwm
  sxhkd
  sway
  swaybg
  swaylock
  swayidle
  picom-git
  conky-cairo  # currently not in use
  dunst
  mako  # currently not in use
  polybar
  waybar  # currently not in use
  rofi
  grim
  slurp
  swappy
  adobe-source-han-sans-jp-fonts
  adobe-source-han-mono-jp-fonts
  ttf-fira-code
  nerd-fonts-fira-code
  ttc-iosevka
  ttf-iosevka-nerd
  ttf-sarasa-gothic  # iosevka + source han sans font for CJK
  ttf-unifont
  ttf-hack
  ttf-raleway
  ttf-nerd-fonts-symbols
  xorg-server
  xorg-xinit
  xorg-xset
  xorg-xwayland
  xdotool
  wmctrl
  numlockx
  xbindkeys
  autotiling
  i3lock-color
  i3status-rust  # status block generator for i3bar/swaybar
  xautolock
  dmenu
  bemenu
  bemenu-wayland
  sway-launcher-desktop
  redshift
  gammastep
  fcitx5
  fcitx5-gtk
  fcitx5-qt
  fcitx5-mozc
  fcitx5-config-qt
  feh
  wl-clipbaord
  wl-clipbaord-x11
  python-i3ipc
  pulsemixer  # used by volume check/fix scripts
  pavucontrol
  mpd
  mpdris2
  ncmpcpp
  cava
  python-mpd2  # for mpdcovoer script
  imagemagick  # for mpdcovoer script
  ffmpegthumbnailer  # for mpdcovoer script
  qt5ct
  qt6ct
  qt5-tools
  qt6-tools
  kvantaum
  papirus-icon-theme
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
)

paru -S "${packages[@]}"
