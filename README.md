# Dotfiles

My dotfiles for Arch Linux.

- Main repository: https://codeberg.org/miyakogi/dotfiles

Display manager is not supported.
Use TTY login at tty-1 (default) and select Shell/DE/WM.

## Install

At first, confirm that `base` and `base-devel` packages are installed:

```
sudo pacman -S base base-devel
```

Then, on Arch Linux, install packages by run:

```
./arch-install.sh
```

This installs all required packages.
**Other Distributions (including Arch-Derivatives) are not supported**.
If you still want to try, check packages in `arch-install.sh` script and install them manually.

Then make config files for supported applications, run:

```sh
./install.py
```

## Setup

### Enable TTY Login

Disable display managers (e.g. SDDM or GDM) if enabled.

### Enable Systemd User Services

Enable systemd services for graphical session.

```sh
systemctl --user enable --now autotiling.service fnott.service fcitx5.service swayidle.service
```

### Set Wallpaper and Lock Screen Image

Use wallpaper for each WM as below:

- sway: `$XDG_CONFIG_HOME/sway/bg{,_4k}.png`
- hyprland: `$XDG_CONFIG_HOME/hypr/bg{,_4k}.png`

Monitor settings are hard-coded for my environment (DP-1 for 4K 144Hz main monitor and DP-2 for FHD 144Hz sub monitor).

### Font Setting

Add `~/.config/fontconfig/fonts.conf` if not exist, and add the below line in the `<fontconfig>` section:

```
<include ignore_missing="yes">conf.d</include>
```

### Keyboard Setting

This repository includes [keyd](https://github.com/rvaiya/keyd) setting file for better key setting.
To use this, you need to manually setup configuration.

WARNING: This setting change system-wide keyboard configuration, be careful.
WARNING: Before using this setup, read and understand [keyd document](https://github.com/rvaiya/keyd/blob/master/docs/keyd.scdoc).

1. Install `keyd`: `paru -S keyd`
2. Create Symlink to `/etc/keyd/default.conf`:

```
sudo mkdir -p /etc/keyd

cd /path/to/cloned/dotfiles

# bash
sudo ln -s -v "$(realpath keyd/default.conf)" /etc/keyd/default.conf 

# fish
sudo ln -s -v (realpath keyd/default.conf) /etc/keyd/default.conf 

sudo systemctl enable --now keyd.service
sudo keyd reload  # optional
```

### Python Environment

Install `python-pipx`:

```
  paru -S python-pipx
```

#### Package and Project Managers

Install `poetry` and `pdm`:

```
  pipx install poetry
  pipx install pdm
```

#### LSP Server for Helix

Install `python-lsp-server` with `mypy` and `ruff` support by `python-pipx`:

```
  pipx install python-lsp-server
  pipx inject python-lsp-server pylsp-mypy
  pipx inject --include-deps --include-apps python-lsp-server python-lsp-ruff
```
