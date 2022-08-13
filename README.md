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
- neovim
- tmux
- ctags
- cargo (rustup + sccache)
- pip

### Terminal

- alacritty
- kitty
- foot

### Desktop

- sway
- xorg-xwayland
- dunst
- autotiling (sway auto-tiling)
- i3status-rust (status block generator for i3bar/swaybar)
- python-i3ipc (scratchpad control and add workspace function for i3/sway)
- fcitx5
- fcitx5-mozc
- pulsemixer (volume check/fix)
- papirus-icon-theme (default icon)

## Required Applications (not listed above)

### Fonts

- Source Han Sans JP
- Fira Code
- Fira Code Nerd Fonts
- Iosevka
- Sarasa Gothic
- unifont
- Nerd Font Symbols

### Command-Line Tool

- direnv
- poetry
- fzf
- lsd (`ls` alternatives)
- bat (`cat` alternative)
- starship (prompt generator)

### Desktop

- bemenu
- bemenu-wayland
- grim
- slurp
- swappy
- gammastep
- wl-clipboard

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

Enable systemd services for graphical session.

```sh
systemctl --user enable autotiling.service dunst-notification.service fcitx5.service gammastep.service sway-idle.service
```

Then logout/login or reboot.

### Set Wallpaper and Lock Screen Image

Use wallpaper for each WM as below:

- sway: `$XDG_CONFIG_HOME/sway/bg{,_4k}.png`

Use lock images for each WM as below:

- sway: `$XDG_CONFIG_HOME/sway/lock{,_4k}.{png,jpg}`
