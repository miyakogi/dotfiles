#!/usr/bin/env zsh

if ! which yay > /dev/null; then
  echo "Need `yay` to install requirements."
  exit 1
fi

yay -S \
  zsh \
  git \
  alacritty \
  kitty \
  gvim \
  neovim \
  tmux \
  ctags \
  i3-gaps \
  bspwm \
  sxhkd \
  picom-git \
  conky-cairo \
  dunst \
  polybar \
  rofi \
  plasma \
  lxqt \
  adobe-source-han-sans-jp-fonts \
  bdf-unifont \
  nerd-fonts-complete \
  ttf-raleway \
  xorg-server \
  xorg-xinit \
  xlogin \
  wmctrl \
  kwallet-pam \
  xorg-xset \
  numlockx \
  autotiling \
  i3lock-color \
  dmenu \
  redshift \
  ibus \
  ibus-mozc \
  easystroke \
  feh \
  klipper \
  perl-anyevent-i3 \
  perl-json-xs \
  python-i3ipc \
  pulsemixer \
  pavucontrol-qt \
  qt5ct \
  yakuake \
  kwin-scripts-krohnkite-git
