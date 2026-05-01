# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 当前 SHELL 启动参数 $- 包含 i 则表示交互式(Interactive Shell)
[[ $- == *i* ]] || return # 非交互式则直接返回

if [[ -z "${ZSH_VERSION:-}" ]]; then
  echo "This is not Z-Shell, exit right now."
  return
fi

# 保存 ZSH 启动日志(查看组件模块加载时间)
if [[ -n "${ZETA_STARTUP_LOG:-}" ]]; then
  # https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
  if false; then
    PS4=$'%D{%H:%M:%S-%N} %N:%i -> '
  else
    zmodload zsh/datetime
    PS4=$'${EPOCHREALTIME} %N:%i -> '
    # 无参数调用 zmodload 则显示已加载模块列表
  fi
  # https://tldp.org/LDP/abs/html/io-redirection.html
  # `exec` with no cmd, redirection for current shell
  # 0 = stdin, 1 = stdout, 2 = stderr
  exec  3>&2  2>  ${HOME}/zsh-startup-$$.log
  setopt xtrace prompt_subst
fi

# => zsh -xv # 启用 (x)traceing 和 (v)erbose output
# => time zsh -i -c exit 和 time zsh --no-rcs -i -c exit
_ltnow1_=$(date +%s%N) # 简单计算 Shell 大概启动加载耗时

# https://zsh.sourceforge.io/releases.html
# https://sourceforge.net/p/zsh/code/ref/master/tags/
autoload is-at-least && { is-at-least 5.9 || return; }

# NOTE Z-Shell Benchmark -> 命令 zprof 显示内容格式
# https://wiki.zshell.dev/zh-Hans/docs/guides/benchmark
# ZSH 内置性能分析模块, 执行 zporf 命令显示性能分析报告
# => 查看 Zsh 源码 => zsh/Src/Modules/zprof.c
# => num  calls  time/1 time/2 time/3  self/1 self/2 self/3  函数名=F
# num=序号 calls=F函数调用次数
# time/1=F总的执行时间(毫秒)     self/1=F自身代码总执行时间(不含调用F执行时间)
# time/2=F平均执行时间(毫秒)     self/2=F函数自身代码的平均行时间
# time/3=F总执行时间/启动耗时    self/3=F自身代码总执行时间/启动耗时
zmodload zsh/zprof

# 权限, POSIX ACL(Access Control Lists)
# - https://savannah.nongnu.org/projects/acl
# - https://wiki.archlinux.org/title/Access_Control_Lists
# - https://wiki.archlinux.org/title/File_permissions_and_attributes
# - 软件包 apt show acl 包含的命令 getfacl, setfacl 和 chacl
# - NOTE 若 ls -l 命令显示的权限标志中包含 + 则表示已设置 ACL
#
# FAQs ^_^ https://www.redhat.com/sysadmin/suid-sgid-sticky-bit
# By default, most Linux Distro set it to 002, focus on sharing
# 002 -> new file with 664, and new folder with 775 permissions
# 022 -> new file with 644, and new folder with 755 permissions
umask -S u=rwx,g=rx,o=rx > /dev/null # 新文件=0644, 新目录=0755

# Make less more friendly for non-text input files
# https://manpages.debian.org/bookworm/less/lesspipe.1.en.html
# TODO https://github.com/wofr06/lesspipe 版和 debian 版的关系
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
#echo "LESSOPEN=[$LESSOPEN], LESSCLOSE=[$LESSCLOSE]"

# ZSH 的 $0 动态变化, 函数中表示函数名，非函数中则表示文件名
export ZETA_DIR="$(dirname "$0")"

source "${ZETA_DIR}/zsh/lib/utils.zsh"
source "${ZETA_DIR}/zsh/lib/host.zsh"
source "${ZETA_DIR}/zsh/lib/path.zsh"
source "${ZETA_DIR}/zsh/lib/color.zsh"
source "${ZETA_DIR}/zsh/lib/message.zsh"
source "${ZETA_DIR}/zsh/lib/getopts.zsh"
source "${ZETA_DIR}/zsh/lib/completion.zsh"

source "${ZETA_DIR}/zsh/alias.zsh"
source "${ZETA_DIR}/zsh/export.zsh"
source "${ZETA_DIR}/zsh/options.zsh"
source "${ZETA_DIR}/zsh/plugins.zsh"

source "${ZETA_DIR}/zsh/extra/help.zsh"
source "${ZETA_DIR}/zsh/extra/memo.zsh"
source "${ZETA_DIR}/vendor/control.zsh"

# 1s = 1000ms, 1ms = 1000μs, 1us = 1000ns, 1ns = 1000ps
# ms(millisecond), μs(microsecond), ns(nanosecond), ps(picosecond)
_ltnow2_=$(date +%s%N) # 简单计算 Shell 大概的启动加载耗时
_ltnow3_="$(@R3 $(( (${_ltnow2_} - ${_ltnow1_}) / 1000000 )))$(@D9 ms)"
echo
echo "$(@D9 '#########################################')"
echo "$(@D9 '#') 👽 $(@Y9 一路繁花赴山海) · $(@G9 不负韶华行且知) 👽 $(@D9 '#') => ${_ltnow3_}"
echo "$(@D9 '#########################################')"
echo
unset -v _ltnow1_  _ltnow2_  _ltnow3_

if [[ -n "${ZETA_STARTUP_LOG}" ]]; then
  unsetopt xtrace
  exec  2>&3  3>&-
fi

# comp-  hook-  priv-  ±help  ±once  ±todo
alias ls-zeta-vars='ls-sh-vars | grep -i zeta'     # 环境变量
alias ls-zeta-func='ls-sh-func-names | grep zeta:' # 函数列表
