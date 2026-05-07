#!/usr/bin/env zsh
# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2026 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# https://man.archlinux.org/man/terminfo.5
# https://invisible-island.net/xterm/terminfo.html
# https://invisible-island.net/ncurses/terminfo.ti.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html

# 未指定 keymap 时, 默认 keymap 是 main
# bindkey -l              显示可用 keymap 名字列表
# bindkey -M  <keymap>    显示 keymap 绑定命令和操作
# bindkey -LM <keymap>    以 bindkey 命令格式显示命令和操作列表
# bindkey -LM viins       显示 VI 插入模式按键及操作
# bindkey -LM vicmd       显示 VI 命令模式按键及操作

# \e 表示 ESC
# ^[ 表示 ESC
# ^X 表示 Ctrl + X

if false; then
  man ascii # 显示 ASCII 码表
  man console_codes # 转义控制序列
  # https://wiki.archlinux.org/title/Keyboard_input
  sudo showkey -a # 显示按键码值，
fi

for key in ${(k)terminfo[*]}; do
  echo "${key}"
  echo -n "${terminfo[${key}]}" | hexyl
done
