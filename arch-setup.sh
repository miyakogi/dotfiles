#!/usr/bin/env zsh

if ! which yay > /dev/null; then
  echo "Need `yay` to install requirements. Install yay by below command:"
  echo "git clone https://aur.archlinux.org/yay.git && cd yay && makepgk -si"
  exit 1
fi

packages=(
  zsh
  git
  alacritty-ligatures-git  # ligature-supported version of alacritty
  kitty
  gvim  # normal vim packages does not support clipboard
  neovim
  python-pynvim  # neovim support package
  tmux
  ctags
  i3-gaps  # gap-supported version
  bspwm
  sxhkd
  sway
  swaybg
  swaylock
  swayidle
  picom-ibhagwan-git  # support rounded-corners and blur
  conky-cairo
  dunst
  mako
  polybar
  waybar
  rofi
  grim
  slurp
  swappy
  plasma
  lxqt
  adobe-source-han-sans-jp-fonts
  nerd-fonts-fira-code
  ttf-unifont
  ttf-raleway
  ttf-nerd-fonts-symbols
  xorg-server
  xorg-xinit
  xorg-xwayland
  xdotool
  wmctrl
  kwallet-pam
  xorg-xset
  numlockx
  autotiling
  i3lock-color
  xautolock
  dmenu
  redshift
  gammastep
  fcitx5
  fcitx5-gtk
  fcitx5-qt
  fcitx5-mozc
  fcitx5-config-qt
  easystroke
  feh
  klipper
  wl-clipbaord
  wl-clipbaord-x11
  perl-anyevent-i3
  perl-json-xs
  python-i3ipc
  pulsemixer
  pavucontrol-qt
  mpd
  ncmpcpp
  cava
  qt5ct
  qt5-tools
  yakuake
  kwin-scripts-krohnkite-git
  ksuperkey
  xbindkeys
  zafiro-icon-theme-git
  numix-icon-theme-git
)

yay -S "${packages[@]}"
