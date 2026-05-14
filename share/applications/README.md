# 快捷方式

- <https://wiki.archlinux.org/title/Icons>
- <https://specifications.freedesktop.org/desktop-entry/latest-single>
- <https://specifications.freedesktop.org/menu/latest-single/>
- <https://specifications.freedesktop.org/icon-naming-spec/latest>
- <https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html>

- 更新系统图标后可能需要 Logout/Login 操作
- `~/Desktop/` 桌面目录，快捷方式 **.desktop** 需 x 权限

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

  1. <https://unix.stackexchange.com/questions/66555>
  1. <https://specifications.freedesktop.org/desktop-entry/latest-single/#file-naming>
  1. `desktop-file-validate path/to/foo.desktop` # 验证 .desktop 文件合法性
  1. `Exec 及 TryExec 的值是否有效, Icon 能否正常显示`
  1. `xdg-desktop-menu install foo.desktop` 尝试安装 .desktop 文件
  1. foo.desktop 重命名为 vendor-foo.desktop 后则正常显示

- 关于 foo.desktop 图标上显示 <橘色感叹号> 标记的说明

  1. `/usr/share/applications/*.desktop` 及 `~/.local/share/applications/*.desktop` 不需要 x 权限
  1. 其它位置的 **.desktop** 文件相当于快捷方式，赋予 x 权限后鼠标双击即可启动相关软件
  1. 常规 **.desktop** 文件显示 <橘色感叹号> 表示此文件缺失 x 权限

- `~/Desktop/foo.desktop` 桌面不显示的原因

  1. Exec 及 TryExec 的值若无效，则桌面不显示相应 *.desktop 文件
