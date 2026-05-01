# XDG Desktop Specification

- <https://www.freedesktop.org/wiki>
- <https://wiki.archlinux.org/title/Xdg-utils>
- <https://specifications.freedesktop.org/basedir/latest/>

- 以 `XDG_` 开头的环境变量的值必须使用绝对路径

| XDG 环境变量       | 默认值               | 功能描述      |
| ------------------ | -------------------- | ------------- |
| `$XDG_CACHE_HOME`  | `$HOME/.cache`       | single folder |
| `$XDG_CONFIG_HOME` | `$HOME/.config`      | single folder |
| `$XDG_DATA_HOME`   | `$HOME/.local/share` | single folder |
| `$XDG_STATE_HOME`  | `$HOME/.local/state` | single folder |
|                    | `$HOME/.local/bin`   | single folder |
| `$XDG_RUNTIME_DIR` |                      | single folder |
| `$XDG_DATA_DIRS`   |                      | folders list  |
| `$XDG_CONFIG_DIRS` |                      | folders list  |

## 桌面启动器

- <https://wiki.archlinux.org/title/Desktop_entries>
- <https://develop.kde.org/docs/features/desktop-file>

- <https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html>
- <https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html>
- <https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html>

<!-- MIME = Multipurpose Internet Mail Extensions 网站搜索 https://www.iana.org/protocols -->
- <https://doc.qt.io/qt-6/qmimetype.html>
- <https://www.iana.org/assignments/media-types/media-types.xhtml>
- <https://www.freedesktop.org/wiki/Specifications/shared-mime-info-spec>

```bash
xdg-mime query    filetype      photo.jpeg
xdg-mime query    default       image/jpeg
xdg-mime default  foo.desktop   image/jpeg # ~/.config/mimeapps.list
```

A `.desktop` file is a simple text file that holds information about a program. It is usually
placed in `~/.local/share/applications` or `/usr/share/applications/`, depending on whether you
want the launcher to be accessible for your local account only or for everyone.

```bash
# 标签 Name= 和 Type= 必须设置
# 示例 /usr/share/applications/*.desktop
[Desktop Entry]
Name=AppName
Name[en_US]=AppName

# Application, Directory, Link
Type=Application

# Whether app runs in terminal
Terminal=false

# Display it in the menu or not
NoDisplay=true

# Tooltip shows up in system menu aside
Comment=View sites on Internet

# Categories in which the entry should be shown in a menu
# 候选值 Audio, Video, Game, Graphics, Network, Settings, System, Development
# 候选值 Building, Debugger, TextEditor, Documentation, KDE, GNOME, GTK, Qt, Java
Categories=Qt;KDE;Development;

# Icon to display in file manager, menus, etc.
Icon=/path/to/app/icon

# The program to execute, possibly with arguments
Exec=/path/to/app/executable

# If not absolute path, looked up in $PATH, ignored if fail
TryExec=app-executable

# If `Type=Application`, working directory to run the program in
Path=

# MIME type(s) supported by this application
MimeType=application/beyond.compare.snapshot;
```

Environment variable `XDG_CURRENT_DESKTOP=KDE` for KDE Plasma desktop.
`$desktop` is equal to `$XDG_CURRENT_DESKTOP`

- `$XDG_CONFIG_HOME/$desktop-mimeapps.list`
- `$XDG_CONFIG_HOME/mimeapps.list`
- `$XDG_CONFIG_DIRS/$desktop-mimeapps.list`
- `$XDG_CONFIG_DIRS/mimeapps.list`
- `$XDG_DATA_HOME/applications/$desktop-mimeapps.list`
- `$XDG_DATA_HOME/applications/mimeapps.list`
- `$XDG_DATA_DIRS/applications/$desktop-mimeapps.list`
- `$XDG_DATA_DIRS/applications/mimeapps.list`

```shell
# This groups may only appear in files named "mimeapps.list"
# defines additional associations of applications with mimetypes,
# as if the .desktop file was listing this mimetype in the first place
[Added Associations]
mimetype1=foo1.desktop;
mimetype2=foo2.desktop;bar.desktop;

# This groups may only appear in files named "mimeapps.list"
# removes associations of applications with mimetypes,
# as if the .desktop file was NOT listing this mimetype
[Removed Associations]
mimetype1=what.desktop;

# indicates the default application to be used for a given mimetype,
# It will start associated app when double-click on a file in file manager
[Default Applications]
mimetype1=default1.desktop;default2.desktop;
```
