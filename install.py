#!/usr/bin/env python3

import logging
import os
from pathlib import Path
import shutil
import subprocess
import sys

if not sys.platform.startswith('linux'):
    raise Exception(f'This script only supports Linux\nUnsupported OS: {sys.platform}')

HOME = Path.home()
BASEDIR = Path(__file__).resolve().parent
CONFIG_HOME = Path(os.getenv('XDG_CONFIG_HOME', HOME / '.config'))
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
    mkdir(HOME / '.tmux' / 'plugins')
    mkdir(PICTURES_DIR / 'screenshots' / 'grim')
    mkdir(PICTURES_DIR / 'screenshots' / 'swappy')


def install_linux() -> None:


def main() -> None:
    # Make empty directories
    make_empty_directories()

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

    # git
    install(BASEDIR / 'git' / 'gitignore', HOME / '.gitignore_global')
    install(BASEDIR / 'git' / 'gitconfig', HOME / '.gitconfig')
    install(BASEDIR / 'git' / 'bin' / 'git-workflow', BINDIR / 'git-workflow')

    # rust/cargo
    install(BASEDIR / 'cargo.toml', HOME / '.cargo' / 'config')

    # pip (pip's --no-binary option for some packages on linux)
    install(BASEDIR / 'pip.conf', CONFIG_HOME / 'pip' / 'pip.conf')

    # tmux
    install(BASEDIR / 'tmux.conf', HOME / '.tmux.conf')

    # vim
    VIMBASE = BASEDIR / 'vim'
    VIMDOTDIR = HOME / '.vim'
    install(VIMBASE / 'vimrc', HOME / '.vimrc')
    install(VIMBASE / 'pack.ini', VIMDOTDIR / 'pack' / 'remote' / 'pack.ini')
    install(VIMBASE / 'rgb.txt', VIMDOTDIR / 'rgb.txt')
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
    install(VIMBASE / 'gvimrc_linux', HOME / '.gvimrc')

    # neovim
    NVIM_HOME = CONFIG_HOME / 'nvim'
    install(HOME / '.vim', NVIM_HOME)
    install(HOME / '.vimrc', NVIM_HOME / 'init.vim')
    install(VIMBASE / 'manrc', NVIM_HOME / 'manrc')

    # direnv
    install(BASEDIR / 'direnv', CONFIG_HOME / 'direnv')

    # starship shell prompt
    install(BASEDIR / 'starship.toml', CONFIG_HOME / 'starship.toml')

    ##############################
    # Install for Desktop System #
    ##############################

    # Xinit/Xresources
    install(BASEDIR / 'xinitrc', HOME / '.xinitrc')
    install(BASEDIR / 'Xresources', HOME / '.Xresources')
    install(BASEDIR / 'Xresources', HOME / '.Xdefaults')  # for wayland

    # Scripts for desktop system
    SCRIPTSDIR = BASEDIR / 'scripts'
    install(SCRIPTSDIR / 'launch-terminal.sh', BINDIR / 'launch-terminal')
    install(SCRIPTSDIR / 'launch-foot.sh', BINDIR / 'launch-foot')
    install(SCRIPTSDIR / 'launch-menu.sh', BINDIR / 'launch-menu')
    install(SCRIPTSDIR / 'leave.sh', BINDIR / 'leave')
    install(SCRIPTSDIR / 'sway-scratchterm.py', BINDIR / 'sway-scratchterm')
    install(SCRIPTSDIR / 'scratchterm-tmux.sh', BINDIR / 'scratchterm-tmux')
    install(SCRIPTSDIR / 'lock-screen.sh', BINDIR / 'lock-screen')
    install(SCRIPTSDIR / 'chromium-launcher.sh', BINDIR / 'chromium-launcher')
    install(SCRIPTSDIR / 'chromium-options.sh', BINDIR / 'chromium-options')
    install(SCRIPTSDIR / 'ff-volume-watch.sh', BINDIR / 'ff-volume-watch')
    install(SCRIPTSDIR / 'ff-volume-toggle.sh', BINDIR / 'ff-volume-toggle')
    install(SCRIPTSDIR / 'mic-mute-watch.sh', BINDIR / 'mic-mute-watch')
    install(SCRIPTSDIR / 'mic-mute-toggle.sh', BINDIR / 'mic-mute-toggle')
    install(SCRIPTSDIR / 'sway-idle-watch.sh', BINDIR / 'sway-idle-watch')
    install(SCRIPTSDIR / 'sway-idle-toggle.sh', BINDIR / 'sway-idle-toggle')
    install(SCRIPTSDIR / 'sway-addws.py', BINDIR / 'sway-addws')
    install(SCRIPTSDIR / 'vimpack.py', BINDIR / 'vimpack')

    ### Desktop
    # sway
    install(BASEDIR / 'sway' / 'config', CONFIG_HOME / 'sway' / 'config')

    # alacritty terminal
    ALACRITTY_CONFIG = CONFIG_HOME / 'alacritty'
    install(BASEDIR / 'alacritty.yml', ALACRITTY_CONFIG / 'alacritty.yml')

    # kitty terminal
    install(BASEDIR / 'kitty.conf', CONFIG_HOME / 'kitty' / 'kitty.conf')

    # foot terminal emulator for wayland
    install(BASEDIR / 'foot' / 'foot.ini', CONFIG_HOME / 'foot' / 'foot.ini')

    # dunst
    install(BASEDIR / 'dunst' / 'dunstrc', CONFIG_HOME / 'dunst' / 'dunstrc')

    # swappy
    install(BASEDIR / 'swappy' / 'config', CONFIG_HOME / 'swappy' / 'config')

    ####################
    # Systemd Services #
    ####################
    SERVICE_DIR = BASEDIR / 'services'
    TARGET_DIR = CONFIG_HOME / 'systemd' / 'user'
    mkdir(TARGET_DIR)

    def install_service(service: str) -> None:
        install(SERVICE_DIR / service, TARGET_DIR / service)

    # Install targets
    install_service('user-graphical-session.target')
    install_service('sway-graphical-session.target')

    # WM/DE independent
    install_service('fcitx5.service')
    install_service('input-remapper-autoload.service')

    # for Sway
    install_service('autotiling.service')
    install_service('gammastep.service')
    install_service('swayidle.service')
    install_service('dunst-notification.service')

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
    git_clone(
        'https://github.com/tmux-plugins/tpm',
        HOME / '.tmux' / 'plugins' / 'tpm',
    )

    logger.info('Install Completed')


if __name__ == '__main__':
    main()
