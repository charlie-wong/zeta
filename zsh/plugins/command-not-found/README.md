# command-not-found

This plugin provide suggested packages to be installed if a command can not be found.

To use it, add `command-not-found` to the plugins array in your zshrc file.

```zsh
ZETA_PLUGINS=( ... command-not-found ... )
```

An example of how this plugin works in Ubuntu

```
$ mutt
Command 'mutt' not found, but can be installed with:
sudo apt install mutt
```

Supported Platforms

- [Ubuntu](https://launchpad.net/ubuntu/+source/command-not-found)
- [Debian](https://packages.debian.org/search?keywords=command-not-found)
- [Arch Linux](https://wiki.archlinux.org/title/Zsh#pkgfile_"command_not_found"_handler)

## 参考链接

- <https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/command-not-found>
