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
level = logging.DEBUG
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
    mkdir(CONFIG_HOME / 'i3' / 'workspaces')
    mkdir(HOME / 'Pictures' / 'screenshots' / 'grim')
    mkdir(HOME / 'Pictures' / 'screenshots' / 'swappy')


def install_linux() -> None:
    # Xinit/Xresources
    install(BASEDIR / 'xinitrc', HOME / '.xinitrc')
    install(BASEDIR / 'Xresources', HOME / '.Xresources')
    install(BASEDIR / 'Xresources', HOME / '.Xdefaults')  # for wayland

    # foot terminal for wayland
    install(BASEDIR / 'foot' / 'foot.ini', CONFIG_HOME / 'foot' / 'foot.ini')

    # pip (pip's --no-binary option for some packages on linux)
    install(BASEDIR / 'pip.conf', CONFIG_HOME / 'pip' / 'pip.conf')

    # google-chrome
    # flags for key storage and device factor
    install(BASEDIR / 'chrome-flags.conf', CONFIG_HOME / 'chrome-flags.conf')

    # Scripts for linux system
    SCRIPTSDIR = BASEDIR / 'scripts'
    install(SCRIPTSDIR / 'autostart.sh', BINDIR / 'autostart')
    install(SCRIPTSDIR / 'keyboard-setup.sh', BINDIR / 'keyboard-setup')
    install(SCRIPTSDIR / 'launch-terminal.sh', BINDIR / 'launch-terminal')
    install(SCRIPTSDIR / 'scratchterm-tmux.sh', BINDIR / 'scratchterm-tmux')
    install(SCRIPTSDIR / 'lock-screen.sh', BINDIR / 'lock-screen')
    install(SCRIPTSDIR / 'chrome.sh', BINDIR / 'chrome.sh')
    install(SCRIPTSDIR / 'kwin-first-empty.sh', BINDIR / 'kwin-first-empty')
    install(SCRIPTSDIR / 'krohnkite-control.sh', BINDIR / 'krohnkite-control')
    install(SCRIPTSDIR / 'kitty-music.sh', BINDIR / 'kitty-music')

    # i3 window manager
    I3SRC = BASEDIR / 'i3'
    I3DEST = CONFIG_HOME / 'i3'
    install(I3SRC / 'config.base', I3DEST / 'config.base')
    install(I3SRC / 'config.gaps', I3DEST / 'config.gaps')
    install(I3SRC / 'update_config.sh', I3DEST / 'update_config.sh')
    install(I3SRC / 'scratchterm.py', I3DEST / 'scratchterm.py')
    install(I3SRC / 'save_layout.sh', I3DEST / 'save_layout.sh')
    install(I3SRC / 'load_layouts.sh', I3DEST / 'load_layouts.sh')
    install(I3SRC / 'addws.py', I3DEST / 'addws.py')
    install(I3SRC / 'layout.py', I3DEST / 'layout.py')
    install(I3SRC / 'transparent.py', I3DEST / 'transparent.py')

    # BSPWM window manager
    BSPSRC = BASEDIR / 'bspwm'
    BSPDEST = CONFIG_HOME / 'bspwm'
    install(BSPSRC / 'bspwmrc', BSPDEST / 'bspwmrc')
    install(BSPSRC / 'sxhkdrc', BSPDEST / 'sxhkdrc')
    install(BSPSRC / 'layout.sh', BSPDEST / 'layout.sh')
    install(BSPSRC / 'scratchterm.sh', BSPDEST / 'scratchterm.sh')

    # Plasma/KDE
    install(
        SCRIPTSDIR / 'autostart.sh',
        CONFIG_HOME / 'autostart-scripts' / 'autostart.sh',
    )
    install(
        SCRIPTSDIR / 'kde-shutdown.sh',
        CONFIG_HOME / 'plasma-workspace' / 'shutdown' / 'kde-shutdown.sh',
    )

    # LXQt + KWin
    install(
        BASEDIR / 'autostart' / 'lxqt-autostart.desktop',
        CONFIG_HOME / 'autostart' / 'lxqt-autostart.desktop',
    )

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
    install(POLYSRC / 'nightcolor.sh', POLYDEST / 'nightcolor.sh')
    install(POLYSRC / 'ff-volume-check.sh', POLYDEST / 'ff-volume-check.sh')
    install(POLYSRC / 'ff-volume-fix.sh', POLYDEST / 'ff-volume-fix.sh')

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
    install(VIMBASE / 'pack.json', VIMDOTDIR / 'pack' / 'remote' / 'pack.json')
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

    # percol
    if not WINDOWS:
        install(BASEDIR / 'percolrc.py', HOME / '.percol.d' / 'rc.py')

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
    git_clone('https://github.com/zsh-users/zaw', ZDOTDIR / 'zaw')
    git_clone('https://github.com/lukechilds/zsh-nvm', ZDOTDIR / 'zsh-nvm')
    git_clone(
        'https://github.com/Tarrasch/zsh-autoenv',
        ZDOTDIR / 'zsh-autoenv',
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
