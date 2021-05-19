# Dotfiles

My dotfiles for Arch Linux.

Display manager is not supported.
Use TTY login at tty-1 (default) and select DE/WM.

## Supported Applications (contains config files in this repo)

These applications should be all installed.

### Terminal

- zsh
- git
- fish
- alacritty
- kitty
- foot
- vim/neovim
- tmux
- ctags
- (python) pip
- (rust) cargo (rustup + sccache)

### Desktop (X11)

- i3-gaps
- plasma (X11)
- lxqt (kwin + krohnkite)
- bspwm
- sxhkd
- picom
- conky (conky-cairo)
- dunst
- polybar

### Desktop (Wayland)

- sway
- mako
- waybar
- swappy

### Desktop (common)

- rofi

## Required Applications (not listed above)

### Fonts

- Nerd Font Symbols
- Source Han Sans JP
- Fira Code
- Fira Code Nerd Fonts
- unifont
- Hack
- Raleway

### Terminal

- (python) virtualenv/virtualenv-wrapper
- (python) virtualfish
- (python) cookiecutter

#### Optional

- skim/percol
- exa/lsd (`ls` alternatives)
- bat (`cat` alternative)
- vimpager (`less` alternative, used for man page)
- starship (prompt)
- direnv

### Desktop (X11)

- xorg-server
- xorg-xinit
- xdotool
- wmctrl (check current WM)
- kwallet-pam (password management)
- xorg-xset (display power management)
- numlockx
- dmenu
- autotiling (for i3 auto-tiling)
- i3lock-color (screen lock)
- redshift
- easystroke
- feh
- klipper
- perl-anyevent-i3 (save layout)
- perl-json-xs (save layout)
- pulsemixer (polybar's volume check/fix)
- yakuake
- kwin-scripts-krohnkite-git
- zafiro-icon-theme-git (rofi default icon)
- numix-icon-theme-git (rofi leave script)

### Desktop (Wayland)

- xorg-xwayland
- sway-launcher-desktop
- bemenu
- bemenu-wayland
- grim
- slurp
- gammastep
- wl-clipboard
- wl-clipboard-x11

### Desktop (common)

- fcitx5
- fcitx5-mozc
- python-i3ipc (scratchpad control and add workspace function for i3/sway)
- mpd (polybar module)
- qt5ct (qt5 app theming)

## Install

After installing all requirements, make `/etc/zsh/zshenv` (on Arch Linux) as below:

```zsh
test -d $HOME/.zsh && test -f $HOME/.zsh/.zshenv && export ZDOTDIR=$HOME/.zsh
```

Then run:

```sh
# Install config files
./install.sh

# Change defualt shell to zsh
# check if output of `which zsh` is included in `chsh -l` and then run:
chsh -s $(which zsh)
```

## Setup

### Enable TTY Login

Disable display managers (e.g. SDDM or GDM) if enabled.

### Kwallet auto unlock

In `/etc/pam.d/login`, add:

```
auth optional pam_kwallet5.so
session optional pam_kwallet5.so auto_start
```

### Set Wallpaper and Lock Screen Image

Use wallpaper for each WM as below:

- i3: `$XDG_CONFIG_HOME/i3/bg.{jpg,png}`
- bspwm: `$XDG_CONFIG_HOME/bspwm/bg.{jpg,png}`

For LXQt and KDE, set wallpaper by those settings.

Use lock images for each WM as below:

- i3: `$XDG_CONFIG_HOME/i3/lock.{jpg,png}`
- bspwm: `$XDG_CONFIG_HOME/bspwm/lock.{jpg,png}`
- LXQt: `$XDG_CONFIG_HOME/lxqt/lock.{jpg,png}`

If no image file is found, simply blur the desktop when lock screen.

### Plasma/LXQt Manual Setup

In LXQt session settings, set window manager to `kwin_x11`.

#### Krohnkite

Add kwin window rule to disable title bars on LXQt session (krohnkite is enabled).

`KDE System Settings` -> `Window Management` -> `Window Rules` -> press `Add New`, then set:

- Description: MUST include `Titlebar`
- Window class (application): select `Regular Expression`, set `.*`
- Appearance & Fixes: `No titlebar and frame`, select `Force`, select `Yes`

When re-login to the LXQt session, titlebars will be removed.
In plasma session, this setting will be automatically disabled.
