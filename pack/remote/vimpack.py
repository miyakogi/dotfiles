#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Install Vim Plugins
'''

import os
import json
import curses
import logging
import shutil
from pathlib import Path
import subprocess
from typing import Union

PROTO = 'https'
BASEDIR = Path(__file__).resolve().parent.resolve()
logger = logging.getLogger('VimPack')


class Formatter(logging.Formatter):
    _colors_int = {'red': 1, 'green': 2, 'orange': 3, 'blue': 4}
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.colors = {}
        curses.setupterm()
        try:
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
        config = {'level': rec.levelname, 'name': rec.name, 'msg': rec.msg}
        if rec.levelno >= logging.ERROR:
            config['color'] = self.colors['red']
        elif rec.levelno >= logging.WARN:
            config['color'] = self.colors['orange']
        elif rec.levelno >= logging.INFO:
            config['color'] = self.colors['green']
        elif rec.levelno >= logging.DEBUG:
            config['color'] = self.colors['blue']
        else:
            config['color'] = ''
        config['normal'] = self.colors['normal']
        return fmt.format(**config)


def setup_logger(logger):
    level = logging.DEBUG
    logger.setLevel(level)
    handler = logging.StreamHandler()
    handler.setLevel(level)
    handler.setFormatter(Formatter())
    logger.addHandler(handler)
    logger.propagate = False


def load_config_file(file:Union[Path, str]):
    if isinstance(file, Path):
        with file.open() as f:
            config = json.load(f)
    else:
        with open(file) as f:
            config = json.load(f)
    return config


def ensure_dir(path:Path):
    if not path.exists():
        path.mkdir()
        logger.info('{} created'.format(path))


class Installer:
    def __init__(self, dirpath:Path, config:dict):
        self.dir = dirpath
        self.config = config

    def install(self):
        for d in self.config:
            ensure_dir(self.dir / d)
            base = self.dir / d
            for domain in self.config[d]:
                host = Path(domain)
                for repo in self.config[d][domain]:
                    if repo.endswith('/'):
                        repo = Path(repo[:-1])
                    else:
                        repo = Path(repo)
                    if (base / repo.name).exists():
                        logger.info('{} already exists, skip'.format(repo))
                        continue
                    self.clone(host, repo, base / repo.name)
        logger.info('Install completed')

    def _make_url(self, url:Path):
        return '{0}://{1}'.format(PROTO, url)

    def clone(self, host, repo, target='.'):
        url = self._make_url(host / repo)
        logger.info('start clone {}'.format(repo))
        proc = subprocess.run(['git', 'clone', '--recursive', url, str(target)])
        if proc.returncode == 0:
            self.check_plugin_dir(target)
        else:
            logger.error('Failed to clone {}'.format(url))

    def update(self):
        for d in self.config:
            ensure_dir(self.dir / d)
            base = self.dir / d
            for plugin_dir in base.iterdir():
                self.pull(plugin_dir)

    def pull(self, path:Path):
        if (path / '.git').exists():
            logger.info('Update {}/{}'.format(path.parent.name, path.name))
            os.chdir(str(path))
            proc = subprocess.run(['git', 'pull'])
            if proc.returncode == 0:
                self.init_submodule(path)
                self.check_plugin_dir(path)
            else:
                logger.error('error on `git pull` on {}'.format(path.name))
        else:
            logger.info('Skip non-git directory {}'.format(path))

    def init_submodule(self, path):
        subprocess.run(['git', 'submodule', 'update', '--init', '--recursive'])

    def check_plugins(self):
        for d in self.config:
            base = self.dir / d
            for plugin in base.iterdir():
                self.check_plugin_dir(plugin)

    def check_plugin_dir(self, path:Path):
        plugin_dir = path / 'plugin'
        if not plugin_dir.is_dir():
            logger.info('make plugin dir on {}'.format(path))
            plugin_dir.mkdir()
        empty = True
        for _ in plugin_dir.glob('*.vim'):
            empty = False
        if empty:
            logger.info('make dummy _.vim file on {}'.format(path.name))
            dummy_file = plugin_dir / '_.vim'
            dummy_file.touch()


class Updater(object):
    def __init__(self, basedir, config):
        self.dir = basedir
        self.config = config


def check_commands():
    if not shutil.which('git'):
        raise OSError('git command not found')


def main():
    check_commands()
    setup_logger(logger)
    config = load_config_file(BASEDIR / 'vimpack.json')
    installer = Installer(BASEDIR, config)


if __name__ == '__main__':
    main()
