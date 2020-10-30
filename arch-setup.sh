#!/usr/bin/env zsh

if ! which yay > /dev/null; then
  echo "Need `yay` to install requirements."
  exit 1
fi

yay -S \
  zsh \
  git \
  alacritty-ligatures-git \
  kitty \
  gvim \
  neovim \
  python-pynvim \
  tmux \
  ctags \
  i3-gaps \
  bspwm \
  sxhkd \
  picom-ibhagwan-git \
  conky-cairo \
  dunst \
  polybar \
  rofi \
  plasma \
  lxqt \
  adobe-source-han-sans-jp-fonts \
  nerd-fonts-fira-code \
  ttf-unifont \
  ttf-raleway \
  ttf-nerd-fonts-symbols \
  xorg-server \
  xorg-xinit \
  xdotool \
  wmctrl \
  kwallet-pam \
  xorg-xset \
  numlockx \
  autotiling \
  i3lock-color \
  xautolock \
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
  mpd \
  qt5ct \
  qt5-tools \
  yakuake \
  kwin-scripts-krohnkite-git \
  ksuperkey \
  xbindkeys \
  numix-icon-theme-git