#!/usr/bin/env python3

import logging
import os
from pathlib import Path
import shutil
import subprocess
import sys

if sys.platform.startswith('linux'):
    OS_NAME = 'Linux'
elif sys.platform.startswith('win'):
    OS_NAME = 'Windows'
elif sys.platform.startswith('darwin'):
    OS_NAME = 'Mac'
else:
    raise Exception(f'Unknown OS: {sys.platform}')

WINDOWS = OS_NAME == 'Windows'
LINUX = OS_NAME == 'Linux'

HOME = Path.home()
BASEDIR = Path(__file__).resolve().parent
CONFIG_HOME = Path(os.getenv('XDG_CONFIG_HOME', HOME / '.config'))
CONFIG_HOME_WIN = Path(os.getenv('XDG_CONFIG_HOME', HOME / 'AppData' / 'Roaming'))  # noqa
PICTURES_DIR = Path(os.getenv('XDG_PICTURES_DIR', HOME / 'Pictures'))
ZDOTDIR = Path(os.getenv('ZDOTDIR', HOME / '.zsh'))
BINDIR = HOME / 'bin'


class Formatter(logging.Formatter):
    _colors_int = {'red': 1, 'green': 2, 'yellow': 3, 'blue': 4}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.colors = {}
        try:
            import curses
            curses.setupterm()
            self.colors['normal'] = curses.tigetstr('sgr0').decode('utf-8')
            for color, val in self._colors_int.items():
                self.colors[color] = curses.tparm(
                    curses.tigetstr('setaf'), val).decode('utf-8')
        except Exception:
            self.colors['normal'] = ''
            for color in self._colors_int:
                self.colors[color] = ''

    def format(self, rec):
        fmt = '{color}[{level}:{name}]{normal} {msg}'
        config = {
            'level': rec.levelname[0],
            'name': rec.name,
            'msg': rec.msg,
            'normal': self.colors['normal'],
        }

        if rec.levelno >= logging.ERROR:
            config['color'] = self.colors['red']
        elif rec.levelno >= logging.WARNING:
            config['color'] = self.colors['yellow']
        elif rec.levelno >= logging.INFO:
            config['color'] = self.colors['green']
        elif rec.levelno >= logging.DEBUG:
            config['color'] = self.colors['blue']
        else:
            config['color'] = ''
        return fmt.format(**config)


# Make logger
logger = logging.getLogger('Install')
level = logging.INFO
logger.setLevel(level)
handler = logging.StreamHandler()
handler.setLevel(level)
handler.setFormatter(Formatter())
logger.addHandler(handler)
logger.propagate = False


def mkdir(p: Path) -> None:
    if not p.exists():
        p.mkdir(parents=True)
        logger.info(f'directory {p} created')
    elif p.is_dir():
        logger.debug(f'[skipped] directory {p} already exists')
    else:
        logger.warn(f"path {p} exists but not directory")


def install(src: Path, dest: Path) -> None:
    if not src.exists():
        logger.error(f'{src} not exists')
        return

    if not dest.parent.exists():
        mkdir(dest.parent)

    if dest.exists():
        if dest.is_symlink() and dest.resolve().samefile(src.resolve()):
            logger.debug(f'[skipped] symlink {dest} -> {src} exists')
            return
        else:
            logger.error(f'install target {dest} already exists')
            return

    dest.symlink_to(src, target_is_directory=src.is_dir())
    logger.info(f'symlink {dest} -> {src} created')


def git_clone(url: str, out: Path) -> None:
    if not shutil.which('git'):
        logger.error('could not find `git` command')
        return
    if out.exists():
        logger.debug(f'[skipped] {out} exists, skip git clone')
        return
    subprocess.run(['git', 'clone', url, str(out)])
    logger.info(f'cloned {url} to {out}')


def make_empty_directories() -> None:
    """
    These dirs don't contain config files but need to exist.
    """
    mkdir(HOME / '.vim' / 'backup')
    mkdir(HOME / '.vim' / 'doc')
    if not WINDOWS:
        mkdir(HOME / '.tmux' / 'plugins')


def make_empty_directories_linux() -> None:
    """
    These dirs don't contain config files but need to exist in linux systems.
    """
    mkdir(PICTURES_DIR / 'screenshots' / 'grim')
    mkdir(PICTURES_DIR / 'screenshots' / 'swappy')


def install_linux() -> None:
    # Xinit/Xresources
    install(BASEDIR / 'xinitrc', HOME / '.xinitrc')
    install(BASEDIR / 'Xresources', HOME / '.Xresources')
    install(BASEDIR / 'Xresources', HOME / '.Xdefaults')  # for wayland

    # pip (pip's --no-binary option for some packages on linux)
    install(BASEDIR / 'pip.conf', CONFIG_HOME / 'pip' / 'pip.conf')

    # mpd: Music Player Daemon
    install(BASEDIR / 'mpd' / 'mpd.conf', CONFIG_HOME / 'mpd' / 'mpd.conf')

    # cava: audio visualization
    install(BASEDIR / 'cava', CONFIG_HOME / 'cava')

    # Scripts for linux system
    SCRIPTSDIR = BASEDIR / 'scripts'
    install(SCRIPTSDIR / 'autostart.sh', BINDIR / 'autostart')
    install(SCRIPTSDIR / 'keyboard-setup.sh', BINDIR / 'keyboard-setup')
    install(SCRIPTSDIR / 'launch-terminal.sh', BINDIR / 'launch-terminal')
    install(SCRIPTSDIR / 'launch-foot.sh', BINDIR / 'launch-foot')
    install(SCRIPTSDIR / 'launch-menu.sh', BINDIR / 'launch-menu')
    install(SCRIPTSDIR / 'scratchterm-tmux.sh', BINDIR / 'scratchterm-tmux')
    install(SCRIPTSDIR / 'lock-screen.sh', BINDIR / 'lock-screen')
    install(SCRIPTSDIR / 'chromium-launcher.sh', BINDIR / 'chromium-launcher')
    install(SCRIPTSDIR / 'chromium-options.sh', BINDIR / 'chromium-options')
    install(SCRIPTSDIR / 'kitty-music.sh', BINDIR / 'kitty-music')
    install(SCRIPTSDIR / 'mpdplayer.sh', BINDIR / 'mpdplayer')
    install(SCRIPTSDIR / 'mpdcover.py', BINDIR / 'mpdcover')
    install(SCRIPTSDIR / 'ff-volume-watch.sh', BINDIR / 'ff-volume-watch')
    install(SCRIPTSDIR / 'ff-volume-toggle.sh', BINDIR / 'ff-volume-toggle')
    install(SCRIPTSDIR / 'mic-mute-watch.sh', BINDIR / 'mic-mute-watch')
    install(SCRIPTSDIR / 'mic-mute-toggle.sh', BINDIR / 'mic-mute-toggle')

    # i3 window manager
    I3SRC = BASEDIR / 'i3'
    I3DEST = CONFIG_HOME / 'i3'
    install(I3SRC / 'config', I3DEST / 'config')
    install(I3SRC / 'scratchterm.py', I3DEST / 'scratchterm.py')
    install(I3SRC / 'addws.py', I3DEST / 'addws.py')
    install(I3SRC / 'layout.py', I3DEST / 'layout.py')
    install(
        BASEDIR / 'i3status-rust' / 'main.toml',
        CONFIG_HOME / 'i3status-rust' / 'main.toml',
    )
    install(
        BASEDIR / 'i3status-rust' / 'sub.toml',
        CONFIG_HOME / 'i3status-rust' / 'sub.toml',
    )

    # BSPWM window manager
    BSPSRC = BASEDIR / 'bspwm'
    BSPDEST = CONFIG_HOME / 'bspwm'
    install(BSPSRC / 'bspwmrc', BSPDEST / 'bspwmrc')
    install(BSPSRC / 'sxhkdrc', BSPDEST / 'sxhkdrc')
    install(BSPSRC / 'layout.sh', BSPDEST / 'layout.sh')
    install(BSPSRC / 'scratchterm.sh', BSPDEST / 'scratchterm.sh')

    # picom
    install(
        BASEDIR / 'picom' / 'picom.conf',
        CONFIG_HOME / 'picom' / 'picom.conf',
    )

    # conky
    install(
        BASEDIR / 'conky' / 'conky.conf',
        CONFIG_HOME / 'conky' / 'conky.conf',
    )
    install(
        BASEDIR / 'conky' / 'rings.lua',
        CONFIG_HOME / 'conky' / 'rings.lua',
    )

    # dunst
    install(BASEDIR / 'dunst' / 'dunstrc', CONFIG_HOME / 'dunst' / 'dunstrc')

    # polybar
    POLYSRC = BASEDIR / 'polybar'
    POLYDEST = CONFIG_HOME / 'polybar'
    install(POLYSRC / 'config', POLYDEST / 'config')
    install(POLYSRC / 'launch.sh', POLYDEST / 'launch.sh')
    install(POLYSRC / 'rofi-calendar.sh', POLYDEST / 'rofi-calendar.sh')
    install(POLYSRC / 'rofi-menu.sh', POLYDEST / 'rofi-menu.sh')
    install(POLYSRC / 'updates.sh', POLYDEST / 'updates.sh')

    # rofi
    ROFISRC = BASEDIR / 'rofi'
    ROFIDEST = CONFIG_HOME / 'rofi'
    install(ROFISRC / 'config.rasi', ROFIDEST / 'config.rasi')
    install(ROFISRC / 'main-theme.rasi', ROFIDEST / 'main-theme.rasi')
    install(ROFISRC / 'menu-theme.rasi', ROFIDEST / 'menu-theme.rasi')
    install(ROFISRC / 'menu-theme-gaps.rasi', ROFIDEST / 'menu-theme-gaps.rasi')  # noqa
    install(ROFISRC / 'leave-theme.rasi', ROFIDEST / 'leave-theme.rasi')
    install(ROFISRC / 'calendar-theme.rasi', ROFIDEST / 'calendar-theme.rasi')
    install(ROFISRC / 'leave.sh', ROFIDEST / 'leave.sh')

    ###########
    # Wayland #
    ###########

    # sway
    install(BASEDIR / 'sway' / 'config', CONFIG_HOME / 'sway' / 'config')

    # foot terminal emulator for wayland
    install(BASEDIR / 'foot' / 'foot.ini', CONFIG_HOME / 'foot' / 'foot.ini')

    # waybar
    install(BASEDIR / 'waybar' / 'config', CONFIG_HOME / 'waybar' / 'config')
    install(BASEDIR / 'waybar' / 'style.css', CONFIG_HOME / 'waybar' / 'style.css')  # noqa
    install(BASEDIR / 'waybar' / 'launch.sh', CONFIG_HOME / 'waybar' / 'launch.sh')  # noqa

    # mako
    install(BASEDIR / 'mako' / 'config', CONFIG_HOME / 'mako' / 'config')

    # swappy
    install(BASEDIR / 'swappy' / 'config', CONFIG_HOME / 'swappy' / 'config')


def main() -> None:
    # Make empty directories
    make_empty_directories()
    if LINUX:
        make_empty_directories_linux()

    ##################
    # Install Starts #
    ##################

    # Shell defaults
    install(BASEDIR / 'profile', HOME / '.profile')

    # bash files
    install(BASEDIR / 'bashrc', HOME / '.bashrc')

    # zsh files (load this order on startup)
    ZSHBASE = BASEDIR / 'zsh'
    install(ZSHBASE / 'zshenv', ZDOTDIR / '.zshenv')
    install(ZSHBASE / 'zprofile', ZDOTDIR / '.zprofile')
    install(ZSHBASE / 'zshrc', ZDOTDIR / '.zshrc')
    install(ZSHBASE / 'prompt.zsh', ZDOTDIR / 'prompt.zsh')

    # fish shell
    install(BASEDIR / 'fish', CONFIG_HOME / 'fish')

    # PowerShell
    if WINDOWS:
        PWSH_HOME = HOME / 'Documents' / 'PowerShell'
    else:
        PWSH_HOME = CONFIG_HOME / 'powershell'
    install(
        BASEDIR / 'powershell' / 'profile.ps1',
        PWSH_HOME / 'Microsoft.PowerShell_profile.ps1',
    )

    # git
    install(BASEDIR / 'git' / 'gitignore', HOME / '.gitignore_global')
    install(BASEDIR / 'git' / 'gitconfig', HOME / '.gitconfig')
    install(BASEDIR / 'git' / 'bin' / 'git-workflow', BINDIR / 'git-workflow')

    # tmux
    if not WINDOWS:
        install(BASEDIR / 'tmux.conf', HOME / '.tmux.conf')

    # vim
    VIMBASE = BASEDIR / 'vim'
    VIMDOTDIR = HOME / '.vim'
    install(VIMBASE / 'vimrc', HOME / '.vimrc')
    install(VIMBASE / 'pack.ini', VIMDOTDIR / 'pack' / 'remote' / 'pack.ini')
    install(VIMBASE / 'rgb.txt', VIMDOTDIR / 'rgb.txt')
    install(VIMBASE / 'vimpack.py', BINDIR / 'vimpack')
    install(VIMBASE / 'after', VIMDOTDIR / 'after')
    install(VIMBASE / 'autoload', VIMDOTDIR / 'autoload')
    install(VIMBASE / 'colors', VIMDOTDIR / 'colors')
    install(VIMBASE / 'config', VIMDOTDIR / 'config')
    install(VIMBASE / 'ftdetect', VIMDOTDIR / 'ftdetect')
    install(VIMBASE / 'ftplugin', VIMDOTDIR / 'ftplugin')
    install(VIMBASE / 'plugin', VIMDOTDIR / 'plugin')
    install(VIMBASE / 'snippets', VIMDOTDIR / 'snippets')
    install(VIMBASE / 'syntax', VIMDOTDIR / 'syntax')

    # gvim
    if OS_NAME == 'Linux':
        install(VIMBASE / 'gvimrc_linux', HOME / '.gvimrc')
    elif OS_NAME == 'Mac':
        install(VIMBASE / 'gvimrc_mac', HOME / '.gvimrc')
    elif OS_NAME == 'Windows':
        install(VIMBASE / 'gvimrc_win', HOME / '.gvimrc')

    # vimpager
    if not WINDOWS:
        install(VIMBASE / 'vimpagerrc', VIMDOTDIR / 'vimpagerrc')

    # neovim
    if WINDOWS:
        NVIM_HOME = HOME / 'AppData' / 'Local' / 'nvim'
    else:
        NVIM_HOME = CONFIG_HOME / 'nvim'
    install(HOME / '.vim', NVIM_HOME)
    install(HOME / '.vimrc', NVIM_HOME / 'init.vim')
    if OS_NAME != 'Windows':
        install(VIMBASE / 'manrc', NVIM_HOME / 'manrc')

    # direnv
    install(BASEDIR / 'direnv', CONFIG_HOME / 'direnv')

    # pip update script
    install(BASEDIR / 'scripts' / 'pip-update', BINDIR / 'pip-update')

    # starship shell prompt
    install(BASEDIR / 'starship.toml', CONFIG_HOME / 'starship.toml')

    # alacritty terminal
    if WINDOWS:
        ALACRITTY_CONFIG = CONFIG_HOME_WIN / 'alacritty'
    else:
        ALACRITTY_CONFIG = CONFIG_HOME / 'alacritty'
    install(BASEDIR / 'alacritty.yml', ALACRITTY_CONFIG / 'alacritty.yml')

    # kitty terminal
    if not WINDOWS:
        install(BASEDIR / 'kitty.conf', CONFIG_HOME / 'kitty' / 'kitty.conf')

    #####################
    # Install for Linux #
    #####################
    if LINUX:
        install_linux()

    ###############################
    # Install plugins from github #
    ###############################

    # zsh
    git_clone(
        'https://github.com/zsh-users/zaw',
        ZDOTDIR / 'zaw'
    )
    git_clone(
        'https://github.com/zsh-users/zsh-completions',
        ZDOTDIR / 'zsh-completions',
    )
    git_clone(
        'https://github.com/bobthecow/git-flow-completion',
        ZDOTDIR / 'git-flow-completion',
    )
    git_clone(
        'https://github.com/zsh-users/zsh-autosuggestions',
        ZDOTDIR / 'zsh-autosuggestions',
    )
    git_clone(
        'https://github.com/zsh-users/zsh-syntax-highlighting',
        ZDOTDIR / 'zsh-syntax-highlighting',
    )
    git_clone(
        'https://github.com/hlissner/zsh-autopair',
        ZDOTDIR / 'zsh-autopair',
    )

    # tmux
    if not WINDOWS:
        git_clone(
            'https://github.com/tmux-plugins/tpm',
            HOME / '.tmux' / 'plugins' / 'tpm',
        )

    logger.info('Install Completed')


if __name__ == '__main__':
    main()
