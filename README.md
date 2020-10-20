# Dotfiles

My dotfiles for Arch Linux.

Display manager is not supported.
Use TTY login at tty-1 (default) and select DE/WM.

## Supported Applications

These applications should be all installed.

### Terminal

- zsh
- git
- alacritty
- kitty
- vim/neovim
- tmux
- ctags
- (rust) cargo

### Desktop

- i3-gaps
- bspwm
- sxhkd
- picom (picom-ibhagwan-git)
- conky (conky-cairo)
- dunst
- polybar
- rofi
- plasma (X11)
- lxqt (kwin + krohnkite)

## Required Applications (not listed above)

### Fonts

- Source Han Sans JP
- Fira Code Nerd Font Mono
- Noto Emoji Nerd Font Mono
- unifont
- Hack
- Raleway

### Terminal

- (python) virtualenv/virtualenv-wrapper
- (python) cookiecutter

#### Optional

- skim/percol
- exa/lsd (`ls` alternatives)
- bat (`cat` alternative)
- vimpager (`less` alternative, used for man page)

### Desktop

- xorg-server
- xorg-xinit
- xdotool
- wmctrl (check current WM)
- kwallet-pam (password management)
- xorg-xset (display power management)
- numlockx
- autotiling (for i3 auto-tiling)
- i3lock-color (screen lock)
- dmenu
- redshift
- ibus
- ibus-mozc
- easystroke
- feh
- klipper
- perl-anyevent-i3 (save layout)
- perl-json-xs (save layout)
- python-i3ipc (scratchpad control and add workspace function)
- pulsemixer (polybar's volume check/fix)
- pavucontrol-qt
- mpd (polybar module)
- qt5ct (qt5 app theming)
- yakuake
- kwin-scripts-krohnkite-git
- numix-icon-theme-git (rofi leave script)

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
