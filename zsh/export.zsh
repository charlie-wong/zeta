# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# `gpg-agent` is a daemon to manage private keys for GnuPG
export GPG_TTY=$(tty)

# 优先级: GIT_EDITOR > core.editor > VISUAL > EDITOR > Git 编译时指定默认值 vi
if @zeta:has-cmd hx; then
  export VISUAL=hx # helix
elif @zeta:has-cmd nvim; then
  export VISUAL=nvim
elif @zeta:has-cmd vim; then
  export VISUAL=vim
elif @zeta:has-cmd nano; then
  export VISUAL=nano
fi

if [ -n "${VISUAL}" ]; then
  export EDITOR="${VISUAL:-}"
  export GIT_EDITOR="${VISUAL:-}"
fi

if [ -f ~/.config/git/xcompare ]; then
  export ZETA_XCOMPARE=~/.config/git/xcompare
fi

# https://wiki.archlinux.org/title/Locale  显示当前本地化设置 locale
# 格式文件 => /usr/share/i18n/locales      显示可用本地化设置 locale -a
# 值的格式: [语言[_地域][.字符集][@修正值] 显示当前本地化设置 localectl status
#
# 优先级：LC_ALL > 十二个 LC_* 变量 > LANG
# - 若设置 LC_ALL 则其会覆盖其余所有设置
# - LANG 的值则是 LC_* 未设置时的默认值
#
# NOTE POSIX 规范, 7 Locale
# => https://pubs.opengroup.org/onlinepubs/9699919799/
# LANG=C 设置的起源 https://superuser.com/questions/219945
#
# NOTE 显示当前时间格式信息 locale -k LC_TIME
# 仅当前命令指定时间格式 LC_TIME=zh_CN.UTF-8 date

# LANG=C 或 POSIX 则表示关闭本地化, 关闭后终端中文显示异常
export LANG=en_US.UTF-8

# gettext 翻译器的备选语言列表; 左->右(左侧优先); git 的消息翻译器
# NOTE 许多应用的英语 locale 未命名或设置 en/en_US 别名而使用 C 作为默认 locale, 非英语 locale 位
# 于英语 locale 之后时, 即 en_US:en:zh_CN, 则程序因不能识别 en_US 和 en 导致用 zh_CN 进行翻译显示
# NOTE 若 LC_ALL 或 LANG 设置为 C, 则忽略 LANGUAGE
#unset -v LANGUAGE            # NOTE 方式1: 禁止翻译[英文] -> [中文]
#export LANGUAGE=en_US        # NOTE 方式2: 禁止翻译[英文] -> [中文]
export LANGUAGE=en_US:C:zh_CN # NOTE 方式3: 禁止翻译[英文] -> [中文]

# -F,--quit-if-one-screen  -R,--RAW-CONTROL-CHARS
[ -z "${PAGER}" ] && export PAGER="less -R --tabs=2"

# 优先级: GIT_PAGER > core.pager > PAGER > 默认值 less
if @zeta:no-cmd ov && @zeta:no-cmd diff-so-fancy; then
  # NOTE 覆盖 git 全局配置 pager.<cmd> 选项
  [ -z "${GIT_PAGER}" ] && export GIT_PAGER="less -R --tabs=2"
fi
