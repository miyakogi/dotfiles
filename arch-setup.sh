#!/usr/bin/env zsh

if ! which yay > /dev/null 2>&1; then
  echo "Need \`yay\` to be installed. Install yay by below command:"
  echo "git clone https://aur.archlinux.org/yay.git && cd yay && makepgk -si"
  exit 1
fi

packages=(
  zsh
  git
  fish
  alacritty-ligatures-git  # ligature-supported version of alacritty
  kitty
  foot
  gvim  # normal vim packages does not support clipboard
  neovim-git
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
  picom-git
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
  adobe-source-han-mono-jp-fonts
  ttf-fira-code
  nerd-fonts-fira-code
  ttf-iosevka
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
  mpdris2
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
  rustup
  sccache  # rustc cache support
  starship
  direnv  # directory based env setting
  python-virtualenvwrapper
  virtualfish  # python venv manager for fish shell
  lsd  # ls alternative
  exa  # ls alternative
  bat  # cat alternative
  skim  # fuzzy searcher written in rust
  pkgfile  # faster fish command failure support
)

yay -S "${packages[@]}"
