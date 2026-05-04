# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 显示已启用选项 setopt           显示未禁用选项 unsetopt
setopt hist_ignore_dups           # ignore commands that was just recorded
setopt hist_ignore_all_dups       # delete old recorded if new entry is a duplicate one
setopt hist_expire_dups_first     # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_space          # ignore commands that start with space
setopt hist_save_no_dups          # delete older commands that duplicate newer ones in HISTFILE
setopt hist_reduce_blanks         # delete superfluous blanks before write to HISTFILE
setopt hist_verify                # show command with history expansion to user before running it
setopt share_history              # share command history data between all shell sessions
setopt extended_history           # Write HISTFILE file in ":start:elapsed;command" format

setopt auto_pushd                 # make `cd` auto push old path onto the dirstack
setopt cd_silent                  # never print the working directory after a `cd`
setopt pushd_ignore_dups          # do not push multiple copies onto directory stack
setopt pushd_silent               # do not print the directory stack after pushd or popd
DIRSTACKSIZE=10                   # 目录栈索引有效区间 [0, 9]
setopt pushd_minus                # 交换 cd +N 和 cd -N 含义, 使 cd -N 匹配 dirs -v 显示索引

setopt warn_create_global         # 函数内创建全局变量(非 declare -g 形式)时显示警告信息
setopt prompt_subst               # 启用后可执行(不影响命令返回值): 变量扩展/算术运算/函数调用

# Causes field splitting to be performed on unquoted parameter expansions.
setopt shwordsplit




