# XDG 目录规范

- <https://specifications.freedesktop.org/>
- <https://wiki.archlinux.org/title/XDG_Base_Directory>
- <https://specifications.freedesktop.org/basedir/latest>

## 桌面快捷启动方式

- <https://wiki.archlinux.org/title/Icons>
- <https://specifications.freedesktop.org/desktop-entry/latest>
- <https://specifications.freedesktop.org/icon-naming-spec/latest>
- <https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html>

- 更新目录下图标文件后
  - 用户 Logout/Login 后系统相关菜单图标才能显示
  - 重启文件管理器后相关 .desktop 文件图标才能显示

```bash
/usr/share/applications/

# 系统图标文件存储位置(修改后需要更新图标缓存)
/usr/share/mime/
/usr/share/icons/hicolor/

man update-icon-caches
man gtk-update-icon-cache

# 相关命令更新
man update-mime
man update-mime-database
man update-desktop-database
man xdg-desktop-menu
```

## FAQ

- 开始菜单内不显示 /usr/share/applications/foo.desktop 的问题

  0. <https://unix.stackexchange.com/questions/66555>
  1. `desktop-file-validate path/to/foo.desktop` # 验证 .desktop 文件合法性
  2. `Exec 及 TryExec 的值是否有效, Icon 能否正常显示`
  3. `xdg-desktop-menu install foo.desktop` 尝试安装 .desktop 文件
  4. foo.desktop 重命名为 vendor-foo.desktop 后则正常显示
