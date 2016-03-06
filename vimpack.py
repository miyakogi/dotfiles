#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Install/Update/Check Vim Plugins
'''

import os
import json
import curses
import logging
import shutil
import argparse
from pathlib import Path
import subprocess
from typing import Union

PROTO = 'https'
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


def make_parser():
    desc = 'Vim Package Helper'
    parser = argparse.ArgumentParser(description=desc, prog='VimPack')
    subparsers = parser.add_subparsers(dest='command')
    install_parser = subparsers.add_parser('install')
    update_parser = subparsers.add_parser('update')
    check_parser = subparsers.add_parser('check')

    _conf = 'pack.json'
    install_parser.add_argument('config_file', default=_conf, nargs='?')
    update_parser.add_argument('config_file', default=_conf, nargs='?')
    check_parser.add_argument('config_file', default=_conf, nargs='?')
    return parser


def ensure_dir(path:Path):
    if not path.exists():
        path.mkdir()
        logger.info('{} created'.format(path))


class Installer:
    def __init__(self, config_file:Path):
        self.dir = config_file.parent
        self.vimhome = self.find_vimhome()
        self.config = self.load_config_file(config_file)

    def load_config_file(self, file:Union[Path, str]):
        if isinstance(file, Path):
            with file.open() as f:
                config = json.load(f)
        else:
            with open(file) as f:
                config = json.load(f)
        return config

    def find_vimhome(self):
        unix_style_vimhome = Path.home() / '.vim'
        win_style_vimhome = Path.home() / '_vim'
        if unix_style_vimhome.exists():
            return unix_style_vimhome
        if win_style_vimhome.exists():
            return win_style_vimhome

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
                        logger.info('Skip existing {}'.format(repo))
                        continue
                    self.clone(host, repo, base / repo.name)
        logger.info('Install completed')

    def _make_url(self, url:Path):
        return '{0}://{1}'.format(PROTO, url)

    def clone(self, host, repo, target='.'):
        url = self._make_url(host / repo)
        logger.info('start clone {}'.format(repo))
        proc = subprocess.run([
            'git', 'clone', '--recursive', url, str(target)])
        if proc.returncode == 0:
            self.check_plugin_dir(target)
        else:
            logger.error('Failed to clone {}'.format(url))

    def update(self):
        for d in self.config:
            ensure_dir(self.dir / d)
            base = self.dir / d
            for plugin_dir in base.iterdir():
                if plugin_dir.is_dir():
                    self.pull(plugin_dir)
        logger.info('Update completed')

    def pull(self, path:Path):
        if (path / '.git').exists():
            logger.info('Update {}/{}'.format(path.parent.name, path.name))
            os.chdir(str(path))
            proc = subprocess.run(['git', 'pull'])
            if proc.returncode == 0:
                self.init_submodule(path)
                self.check_plugin_dir(path)
            else:
                logger.error('error on `git pull` on {}'.format(path))
        else:
            logger.info('Skip non-git directory {}'.format(path))

    def init_submodule(self, path):
        subprocess.run(['git', 'submodule', 'update', '--init', '--recursive'])

    def check(self):
        ensure_dir(self.vimhome / 'doc')
        for d in self.config:
            base = self.dir / d
            for plugin in base.iterdir():
                if plugin.is_dir():
                    self.check_plugin_dir(plugin)
                    self.link_doc(plugin)
        self.helptags()
        logger.info('Check done')

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

    def link_doc(self, path:Path):
        doc_dir = path / 'doc'
        if doc_dir.is_dir():
            for doc in doc_dir.iterdir():
                if doc.match('*.txt') or doc.match('*.*x'):
                    target = self.vimhome / 'doc' / doc.name
                    if not target.exists():
                        target.symlink_to(doc)

    def helptags(self):
        cmd = ['vim', '-c', 'helptags {} | qa'.format(self.vimhome / 'doc')]
        proc = subprocess.run(cmd)
        if proc.returncode == 0:
            logger.info('helptags done')
        else:
            logger.error('Failed to make helptags')


def check_commands():
    if not shutil.which('git'):
        raise OSError('git command not found')


def main():
    check_commands()
    setup_logger(logger)
    parser = make_parser()
    args = parser.parse_args()
    conf_path = Path(args.config_file)
    if not conf_path.is_absolute():
        conf_path = Path.cwd() / conf_path
    installer = Installer(conf_path)
    if args.command == 'install':
        installer.install()
    elif args.command == 'update':
        installer.update()
    elif args.command == 'check':
        installer.check()


if __name__ == '__main__':
    main()
