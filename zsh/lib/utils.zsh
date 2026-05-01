# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# NOTE `which` can not found alias or shell function
function @zeta:has-cmd() {  command -v "$1" > /dev/null 2>&1; }
function @zeta:no-cmd() { ! command -v "$1" > /dev/null 2>&1; }

function @zeta:req-cmd() {
  if ! command -v "$1" > /dev/null 2>&1; then # 红色 \e[31m
    printf "\e[90mzeta:\e[0m not found required \e[31m$1\e[0m command.\n" >&2
    return 1
  fi
}

# 启动参数包含 l 表示 login
if [[ $- == *l* ]]; then
  function @zeta:is-login-shell() { true; }
else
  function @zeta:is-login-shell() { false; }
fi

function @zeta:is-color-enable() {
  case "${TERM}" in
    xterm-color|*-256color) return ;;
  esac

  # assume it's compliant with Ecma-48 (ISO/IEC-6429).
  # Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    return
  fi

  return 1
}

# https://github.com/termstandard/colors
function @zeta:is-truecolor() {
  case "${COLORTERM}" in
    truecolor|24bit) return ;;
  esac

  case "${TERM}" in
    iterm|*-truecolor) return ;;
  esac

  return 1
}

# The [ -t 0 ] check only works when it is not called from a subshell, like
# `$(...)` or `(...)`, so this hack defines the function at top level to make
# sure always return false when stdin is not a tty. 0=stdin, 1=stdout, 2=stderr
if [ -t 0 ]; then
  # true if `stdin` connected to a terminal
  function @zeta:is-stdin-tty() { true;  }
else
  function @zeta:is-stdin-tty() { false; }
fi

if [ -t 1 ]; then
  # true if `stdout` connected to a terminal
  function @zeta:is-stdout-tty() { true;  }
else
  function @zeta:is-stdout-tty() { false; }
fi

if [ -t 2 ]; then
  # true if `stderr` connected to a terminal
  function @zeta:is-stderr-tty() { true;  }
else
  function @zeta:is-stderr-tty() { false; }
fi

# 四种分割符 => ␜  换行␝  制表␞  空格␟
function @zeta:tab-holder()       { builtin printf "$1" | sed -z 's/\x09/␞/g'; }
function @zeta:tab-restore()      { builtin printf "$1" | sed -z 's/␞/\x09/g'; }
function @zeta:space-holder()     { builtin printf "$1" | sed -z 's/\x20/␟/g'; }
function @zeta:space-restore()    { builtin printf "$1" | sed -z 's/␟/\x20/g'; }
function @zeta:newline-holder()   { builtin printf "$1" | sed -z 's/\x0a/␝/g'; }
function @zeta:newline-restore()  { builtin printf "$1" | sed -z 's/␝/\x0a/g'; }

function @zeta:upper-first-char() {
  local rest="$1" char1="${1[1]}"
  rest[1]='' # 删除字符串的首个字符
  echo "${char1:u}${rest}" # 首字母大小
}

# $1 原始字符串  $2 期望包含字符
function @zeta:has-sub-str() {
  [[ -z "$1" || -z "$2" ]] && return 1
  # 删除期望字符后若二者不相等则表示包含
  [[ "$(echo "$1" | sed "s#$2##")" != "$1" ]]
}

# 数字检测
function @zeta:is-binnum() { # binary
  [[ $# -eq 0 ]] && return 1
  [[ -n "$1" && -z "${1//[0-1]/}" ]]
}

function @zeta:is-octnum() { # octave
  [[ $# -eq 0 ]] && return 1
  [[ -n "$1" && -z "${1//[0-7]/}" ]]
}

function @zeta:is-decnum() { # decimal
  [[ $# -eq 0 ]] && return 1
  [[ -n "$1" && -z "${1//[0-9]/}" ]]
  #[[ $(echo "$1" | wc -l) -gt 1 ]] && return 1
  #[[ -n "$(echo "$1" | sed -n "/^[0-9]\+$/p")" ]]
}

function @zeta:is-hexnum() { # hexadecimal
  [[ $# -eq 0 ]] && return 1
  [[ -n "$1" && -z "${1//[0-9A-Fa-f]/}" ]]
  #[[ $(echo "$1" | wc -l) -gt 1 ]] && return 1
  #[[ -n "$(echo "$1" | sed -n "/^[0-9A-Fa-f]\+$/p")" ]]
}

function @zeta:is-number() {
  [[ $# -eq 0 ]] && return 1
  [[ -n "$1" && -z "${1//[0-9A-Fa-f]/}" ]]
}

function @zeta:is-inside-git-repo() {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function @zeta:get-repo-url() {
  ! git rev-parse --is-inside-work-tree &> /dev/null && return
  local url=$(git remote --verbose | head -1 | cut -d' ' -f1 | cut -f2)
  if @zeta:has-sub-str "${url}" "git@github.com:"; then
    url=$(echo "${url}" | sed 's#git@github.com:#https://github.com/#')
  fi
  url="${url%.git}" # 删除结尾的 .git 字符串
  if @zeta:has-sub-str "${url}" "https://github.com/"; then
    # GitHubUserRepo="${url#https://github.com/}" # 开头 % 结尾
    # GitHubRepoName="${GitHubUserRepo#*/}"
    # GitHubUserName="${GitHubUserRepo%/*}"
    echo "${url}"
  fi
}
