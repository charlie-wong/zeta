# vi-mode

To use it, add `vi-mode` to the plugins array in your zshrc file.

```zsh
ZETA_PLUGINS=( ... vi-mode ... )
```

- ESC 键进行模式切换 (默认插入模式)

- 命令模式 (vicmd) 按键映射

  | 按键 | 映射函数 | 备注 |
  | ---- | -------- | ---- |
  | i    | vi-insert                    | 进入插入模式 |
  | I    | vi-insert-bol                | 进入插入模式 (光标移动到行首非空字符) |
  | a    | vi-add-next                  | 进入插入模式 (光标移动到当前位置之后) |
  | A    | vi-add-eol                   | 进入插入模式 (光标移动到行尾) |
  | v    | visual-mode                  | visual selection mode |
  | V    | visual-line-mode             | visual selection mode |
  | R    | vi-replace                   | Enter overwrite mode |
  | r    | vi-replace-chars             | 替换当前光标处的字符 |

## 代码片段

```bash
# \e 表示 ESC
# ^[ 表示 ESC
# ^X 表示 Ctrl + X

# 未指定 keymap 时, 默认 keymap 是 main
# bindkey -l              显示可用 keymap 名字列表
# bindkey -M  <keymap>    显示 keymap 绑定命令和操作
# bindkey -LM <keymap>    以 bindkey 命令格式显示命令和操作列表
# bindkey -LM viins       显示 VI 插入模式按键及操作
# bindkey -LM vicmd       显示 VI 命令模式按键及操作

case "$(ps -p ${PPID} -o comm=)" in
  konsole) echo konsole; ;;
  yakuake) echo yakuake; ;;
  lapce)   echo lapce; ;;
esac

man ascii # 显示 ASCII 码表
man console_codes # 转义控制序列

# https://wiki.archlinux.org/title/Keyboard_input
sudo showkey -a # 显示按键码值

# 显示 terminfo 转义字符序列值
for key in ${(k)terminfo[*]}; do
  echo "${key}"
  echo -n "${terminfo[${key}]}" | hexyl
done
```

## 参考链接

- <https://man.archlinux.org/man/terminfo.5>
- <https://invisible-island.net/xterm/terminfo.html>
- <https://invisible-island.net/ncurses/terminfo.ti.html>
- <http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html>
- <https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/vi-mode>
