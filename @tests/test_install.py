"""Run with python -m unittest discover -s @tests. No live desktop changes."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]

class Installer(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.home = Path(self.tmp.name)
        self.repo = self.home / 'dotfiles'
        self.repo.mkdir()
        shutil.copy(ROOT / 'dotfiles', self.repo / 'dotfiles')
        self.env = dict(os.environ, HOME=str(self.home))

    def tearDown(self):
        self.tmp.cleanup()

    def file(self, path, contents, executable=False):
        p = self.repo / path
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(contents)
        if executable:
            p.chmod(0o755)
        return p

    def run_install(self, *args):
        return subprocess.run(['bash', str(self.repo / 'dotfiles'), *args],
                              env=self.env, input='y\n' * 20, text=True,
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    def test_existing_parent_gets_new_dependency_and_reapply(self):
        self.file('parent/.parent', 'parent')
        self.assertEqual(self.run_install('stow', 'parent').returncode, 0)
        self.file('child/.child', 'child')
        self.file('parent/@depends', 'child\n')
        self.file('@hooks/parent/post-restow', '#!/bin/bash\ntouch "$HOME/reapplied"\n', True)
        result = self.run_install('stow', 'parent')
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertTrue((self.home / '.child').is_symlink())
        self.assertTrue((self.home / 'reapplied').exists())

    def test_conflict_preserves_file_and_skips_hooks(self):
        self.file('parent/.parent', 'repo')
        (self.home / '.parent').write_text('personal')
        self.file('@hooks/parent/pre-stow', '#!/bin/bash\ntouch "$HOME/hook"\n', True)
        result = self.run_install('stow', 'parent')
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.home / '.parent').read_text(), 'personal')
        self.assertFalse((self.home / 'hook').exists())

    def test_failed_dependency_stops_parent(self):
        self.file('parent/.parent', 'parent')
        self.file('parent/@depends', 'child\n')
        self.file('child/.child', 'child')
        self.file('@hooks/child/pre-stow', '#!/bin/bash\nexit 17\n', True)
        result = self.run_install('stow', 'parent')
        self.assertEqual(result.returncode, 17, result.stdout)
        self.assertFalse((self.home / '.parent').exists())

    def test_simulate_skips_hooks_and_links_in_dependencies(self):
        self.file('parent/.parent', 'parent')
        self.file('parent/@depends', 'child\n')
        self.file('child/.child', 'child')
        self.file('@hooks/child/pre-stow', '#!/bin/bash\nexit 17\n', True)
        result = self.run_install('stow', 'parent', '--simulate')
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertFalse((self.home / '.parent').exists())
        self.assertFalse((self.home / '.child').exists())

    def test_multiple_packages_and_restow_hook(self):
        for name in ['first', 'second']:
            self.file(f'{name}/.{name}', name)
            self.file(f'@hooks/{name}/post-restow', f'#!/bin/bash\ntouch "$HOME/{name}-hook"\n', True)
        result = self.run_install('restow', 'first', 'second')
        self.assertEqual(result.returncode, 0, result.stdout)
        for name in ['first', 'second']:
            self.assertTrue((self.home / f'.{name}').is_symlink())
            self.assertTrue((self.home / f'{name}-hook').exists())


class Preferences(unittest.TestCase):
    def test_reapply_keeps_original_backup_and_cursor(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            env = dict(os.environ, HOME=temp, XDG_CONFIG_HOME=str(home / '.config'),
                       DOTFILES_CONFIG_DIR=str(home / '.config/dotfiles'),
                       GSETTINGS_BACKEND='keyfile')
            for file in ['gtk-3.0/settings.ini', 'gtk-4.0/gtk.css', 'kdeglobals',
                         'kitty/current-theme.conf', 'tmux/wombat.conf']:
                path = home / '.config' / file
                path.parent.mkdir(parents=True, exist_ok=True)
                path.touch()
            command = '''
set -eu
gsettings set org.gnome.desktop.interface icon-theme Adwaita
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.interface cursor-size 24
"$1"
"$1"
test "$(cat "$DOTFILES_CONFIG_DIR/plain-i3/icon-theme.before")" = "'Adwaita'"
test "$(gsettings get org.gnome.desktop.interface icon-theme)" = "'Papirus-Dark'"
test "$(gsettings get org.gnome.desktop.interface cursor-theme)" = "'Adwaita'"
test "$(gsettings get org.gnome.desktop.interface cursor-size)" = 24
'''
            result = subprocess.run(['dbus-run-session', '--', 'bash', '-c', command,
                                     'test', str(ROOT / '@hooks/plain-i3/post-stow')],
                                    env=env, text=True, stdout=subprocess.PIPE,
                                    stderr=subprocess.STDOUT)
            self.assertEqual(result.returncode, 0, result.stdout)

class SystemPackages(unittest.TestCase):
    def test_only_missing_packages_are_installed_and_failure_propagates(self):
        with tempfile.TemporaryDirectory() as temp:
            bindir = Path(temp)
            pacman = bindir / 'pacman'
            pacman.write_text('#!/bin/bash\n[[ "$2" != papirus-icon-theme ]]\n')
            sudo = bindir / 'sudo'
            sudo.write_text('#!/bin/bash\nprintf "%s\\n" "$@" > "$CALL_LOG"\nexit 23\n')
            pacman.chmod(0o755)
            sudo.chmod(0o755)
            log = bindir / 'calls'
            env = dict(os.environ, PATH=f'{bindir}:' + os.environ['PATH'], CALL_LOG=str(log))
            result = subprocess.run([str(ROOT / '@hooks/plain-i3/pre-stow')], env=env,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            self.assertEqual(result.returncode, 23, result.stdout)
            self.assertEqual(log.read_text().splitlines(),
                             ['pacman', '-S', '--needed', 'papirus-icon-theme'])

if __name__ == '__main__':
    unittest.main()
