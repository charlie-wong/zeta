# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 显示时间  -s 或 -S           设置标签  -t 或 -T "Title"
# 隐藏时间  -h 或 -H  默认     显示zeta  -z 或 -Z 默认隐藏
function @zeta:-message() {
  local title="$1" color="$2"; shift; shift

  # NOTE Reset shared environment variable used by `getopts`
  # https://unix.stackexchange.com/questions/233728
  # Bash do not reset OPTIND to 1 each time it exit from a
  # shell function, but zsh does it, so reset here for both
  local OPTIND=1 OPTARG OPTERR=1 # NOTE OPTIND=1 is the key

  # NOTE getopts 解析位置参数
  # help getopts, run-help getopts
  # 共享环境变量: OPTERR, OPTIND, OPTARG
  # OPTERR='' ZSH 默认, OPTERR=1 Bash 默认
  # 等于 1 则表示若解析错误显示相关诊断信息
  local showTS=0 _opt_ showZeta=0
  while getopts "SsHhZzT:t:" _opt_; do
    case "${_opt_}" in
      s|S) showTS=1   ;; # show timestamp
      h|H) showTS=0   ;; # hide timestamp
      z|Z) showZeta=1 ;; # 显示 zeta 字符串
      t|T) title="${OPTARG}" ;; # category
      *) ;;
    esac
  done

  local it idx=1 msg
  for it in "$@"; do
    (( idx >= ${OPTIND} )) && msg="${msg} ${it}"
    (( idx++ ))
  done

  if [[ ${showTS} -eq 1 ]]; then # timestamp in grey color
    builtin printf "\e[90m[%s]\e[0m " "$(date '+%FT%T%z')"
  fi

  if [[ ${showZeta} -eq 1 ]]; then
    builtin printf "\e[90mzeta:\e[0m ${color}${title}:\e[0m%s\n" "${msg}"
  else
    builtin printf "${color}${title}:\e[0m%s\n" "${msg}"
  fi
}

function @zeta:imsg() {
  [[ $# -eq 0 ]] && return # green
  @zeta:-message INFO '\e[32m' "$@"
}

function @zeta:wmsg() {
  [[ $# -eq 0 ]] && return # yellow
  { @zeta:-message WARN '\e[33m' "$@"; } 1>&2
}

function @zeta:emsg() {
  [[ $# -eq 0 ]] && return # red
  { @zeta:-message ERROR '\e[31m' "$@"; } 1>&2
}

function @zeta:note() {
  [[ $# -eq 0 || -z "$1" ]] && return # 命令浅黄(彩色参数)
  local _cmd_=$1; shift; @zeta:rainbow "\e[90m${_cmd_}\e[00m" $@
}
