# XDG Base Directory Specification

- <https://specifications.freedesktop.org/>
- <https://specifications.freedesktop.org/basedir/latest/>
- <https://wiki.archlinux.org/title/XDG_Base_Directory>

# 桌面快捷启动方式

- <https://wiki.archlinux.org/title/Icons>
- <https://specifications.freedesktop.org/icon-naming-spec/latest>
- <https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html>

- 更新目录下图标文件后
  * 用户 Logout/Login 后系统相关菜单图标才能显示
  * 重启文件管理器后相关 .desktop 文件图标才能显示

```bash
# 系统图标文件存储位置, 修改后需要更新系统图标缓存
/usr/share/mime/
/usr/share/icons/hicolor/

# 相关命令更新
update-mime
update-mime-database
update-icon-caches
gtk-update-icon-cache
```
