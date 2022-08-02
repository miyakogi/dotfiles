# Dotfiles

My dotfiles for Arch Linux.

Display manager is not supported.
Use TTY login at tty-1 (default) and select DE/WM.

## Supported Applications (contains config files in this repo)

These applications should be all installed.

### Command-Line Tool

- bash
- zsh
- fish
- git
- (g)vim/neovim
- tmux
- ctags
- mpd
- cava
- cargo (rustup + sccache)
- pip

### Desktop

- alacritty
- kitty
- dunst

#### Xorg

- i3-gaps
- bspwm
- sxhkd
- picom
- rofi
- polybar
- conky (currently not in use)
- xterm
- urxvt (rxvt-unicord)

#### Wayland

- sway
- foot
- mako (currently not in use)
- waybar (currently not in use)

## Required Applications (not listed above)

### Fonts

- Source Han Sans JP
- Fira Code
- Fira Code Nerd Fonts
- Iosevka
- Sarasa Gothic
- unifont
- Hack
- Raleway
- Nerd Font Symbols

### Command-Line Tool

- direnv
- poetry
- cookiecutter

##### for mpdcover script

- python-mpd2
- imagemagick
- ffmpegthumbnailer

#### Optional

- skim
- lsd (`ls` alternatives)
- bat (`cat` alternative)
- vimpager (`less` alternative, used for man page)
- starship (prompt generator)

### Desktop (Common)

- qt5ct (qt5 app theming)
- qt6ct (qt6 app theming)
- sway-launcher-desktop
- fcitx5
- fcitx5-mozc
- autotiling (i3/sway auto-tiling)
- i3status-rust (status block generator for i3bar/swaybar)
- python-i3ipc (scratchpad control and add workspace function for i3/sway)
- pulsemixer (volume check/fix)
- papirus-icon-theme (default icon)

#### Xorg

- xorg-server
- xorg-xinit
- xdotool
- wmctrl (check current WM)
- xorg-xset (display power management)
- numlockx
- dmenu
- i3lock-color (screen lock)
- redshift
- feh

#### Wayland

- xorg-xwayland
- bemenu
- bemenu-wayland
- grim
- slurp
- swappy
- gammastep
- wl-clipboard
- wl-clipboard-x11

## Install

On Arch Linux, run `./arch-install.sh`.
This script installs all required packages.

After installing all requirements, make `/etc/zsh/zshenv` file (on Arch Linux) as below:

```zsh
test -d $HOME/.zsh && test -f $HOME/.zsh/.zshenv && export ZDOTDIR=$HOME/.zsh
```

Then run:

```sh
# Install config files
./install.py

# Change defualt shell to zsh
# check if output of `which zsh` is included in `chsh -l` and then run:
chsh -s $(which zsh)
```

## Setup

### Enable TTY Login

Disable display managers (e.g. SDDM or GDM) if enabled.

### Enable Systemd User Services

Enable systemd services for mpd.

```sh
systemctl --user enable --now mpd.service
```

### Set Wallpaper and Lock Screen Image

Use wallpaper for each WM as below:

- i3: `$XDG_CONFIG_HOME/i3/bg.{jpg,png}`
- bspwm: `$XDG_CONFIG_HOME/bspwm/bg.{jpg,png}`
- sway: `$XDG_CONFIG_HOME/sway/bg.png`

Use lock images for each WM as below:

- i3: `$XDG_CONFIG_HOME/i3/lock.{jpg,png}`
- bspwm: `$XDG_CONFIG_HOME/bspwm/lock.{jpg,png}`
- sway: `$XDG_CONFIG_HOME/sway/lock.png`

If no image file is found, simply blur the desktop when locking screen.
