# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 解析 Bash/Zsh 位置参数(支持长选项 & 短选项)
# => https://github.com/Anvil/bash-argsparse
# => https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html

# 解析 SH 位置参数候选工具不推荐 /usr/bin/getopt
# Bash & Zsh 的 builtin 命令 getopts 无法解析长选项
# zparseopts 源码 Src/Modules/zutil.c, 模块 zmodload zsh/zutil

# $1 非空则<启用命令自动补全功能>
#    非空有效值 => 字母(大小写), 数字,下划线
# $2 参数格式: <类型>端选项|长选项,<类型>端选项|长选项
#        类型: +必需  :可选  ~开关
#              长短选项分隔符 |  选项间分割符 ,
#    示例参数: "+S1,:S2|L2,~|L3" => +短,:短|长,~|长
# $3 ... 等待解析的位置参数
#
# - return 0 正常, 其它值则错误
function @zeta:getopts() {
  [[ $# -eq 0 || $# -eq 1 || -z "$1" ]] && return 1
  local _xSpec_="$1"; shift 1; local _xMAX_=$#
  local _IdxArg_  _xNxtArg_  __zIDX__=0  _idx_
  local _oS_ _oL_ _oI_  _val_ _xit_  _bF1_ _bF2_ _rob_

  ! declare -p _ZETA_GETOPTS_InitSpec > /dev/null 2>&1 && {
    declare -g _ZETA_GETOPTS_InitSpec=0
    declare -ga _ZETA_GETOPTS_{S,L}_ # 短选项(S) 长选项(L)
    if ! declare -p _ZETA_GETOPTS_IDX > /dev/null 2>&1; then
      declare -g _ZETA_GETOPTS_{IDX=0,NXT=1,ARG,VAL}
    fi
  }

  function getopts±clean() {
    unset -v _ZETA_GETOPTS_InitSpec  _ZETA_GETOPTS_{S,L}_  _ZETA_GETOPTS_{IDX,NXT,ARG,VAL}
    [[ $# -ge 2 ]] && { # Bash/Zsh 预定义变量 LINENO 更具可读性
      # NOTE Bash 的 LINENO 值忽略纯注释(空白)行, 行号 22 函数定义
      local lineNo=$1 xLN; shift; (( lineNo += 22 ))
      xLN="LN=${lineNo} "; @zeta:wmsg -T '@zeta:getopts' "${xLN}$@"
    }; unset -f getopts±clean
  }

  if (( _ZETA_GETOPTS_NXT > 0 )); then
    (( _ZETA_GETOPTS_IDX = _ZETA_GETOPTS_NXT, _ZETA_GETOPTS_NXT++ ))
  else
    _ZETA_GETOPTS_IDX=-1; _ZETA_GETOPTS_NXT=-1; getopts±clean; return 1
  fi

  [[ -z "${_ZETA_GETOPTS_IDX}" || ${_ZETA_GETOPTS_IDX} -gt ${_xMAX_} ]] && {
    _ZETA_GETOPTS_IDX=-1; _ZETA_GETOPTS_NXT=-1; getopts±clean; return 1
  }

  # NOTE Zsh 数组索引 1 开始, Bash 数组索引 0 开始
  [[ -n "${ZSH_VERSION:-}" ]] && __zIDX__=1

  ##################
  # 参数<规范>解析 #
  ###################
  (( _ZETA_GETOPTS_InitSpec == 0 )) && {
    _xSpec_="$(builtin printf "${_xSpec_}" | sed 's/,/\t/g')"
    if [[ -z "${_xSpec_}" ]]; then
      getopts±clean ${LINENO} "invalid empty args-spec"; return 1;
    fi

    (( _idx_ = __zIDX__ )); for _xit_ in ${_xSpec_}; do
      _rob_="${_xit_:0:1}" # 第 1 个字节表示类型
      case "${_rob_}" in
        "+") _val_="${_xit_:1}" ;; # 必须
        ":") _val_="${_xit_:1}" ;; # 可选
        "~") _val_="${_xit_:1}" ;; # 开关
          *) _val_="${_xit_}"; _rob_="~" ;;
      esac
      # echo "调试 [${_rob_}] -> [${_xit_}]"

      # NOTE 删除<开头>最短匹配符 #    删除<结尾>最短匹配符 %
      _oS_="${_val_%|*}"; _oL_="${_val_#*|}"

      if [[ -z "${_oS_}" && -z "${_oL_}" ]]; then
        getopts±clean ${LINENO} "invalid args-spec $(@R3 ${_xit_})"; return 1
      elif [[ "${_oS_}" == "${_oL_}" && "${_oS_}" == "${_val_}" ]]; then
        _oL_="" # 规范 => +短选项   :短选项   ~短选项
      elif [[ "${_val_:0:1}" == "|" && "${_oL_}" == "${_val_:1}" ]]; then
        _oS_="" # 规范 => +|长选项  :|长选项  ~|长选项
      fi
      # 规范 => +短选项|长选项  :短选项|长选项  ~短选项|长选项
      [[ -n "${_oL_}" && "${_oS_}" != "${_val_%|${_oL_}}" ]] && {
        getopts±clean ${LINENO} "invalid args-spec $(@R3 ${_xit_})"; return 1
      }
      [[ -n "${_oS_}" && "${_oL_}" != "${_val_#${_oS_}|}" ]] && {
        if [[ "${_oS_}" != "${_val_}" ]]; then
          getopts±clean ${LINENO} "invalid args-spec $(@R3 ${_xit_})"; return 1
        fi
      }
      # echo "调试 [${_rob_}] -> S[${_oS_}] L[${_oL_}]"; echo

      # ␜ 数组内容有效性检测字符(Magic Byte)
      _ZETA_GETOPTS_S_[${_idx_}]="␜${_rob_}${_oS_}"
      _ZETA_GETOPTS_L_[${_idx_}]="␜${_rob_}${_oL_}"; (( _idx_++ ))
    done; _ZETA_GETOPTS_InitSpec=1 # 参数规范解析初始化完成

    # echo "调试 _ZETA_GETOPTS_S_ => [${_ZETA_GETOPTS_S_[@]}]"
    # echo "调试 _ZETA_GETOPTS_L_ => [${_ZETA_GETOPTS_L_[@]}]"
  }

  ######################
  # 解析扫描命令行参数 #
  ######################
  [[ -n "${BASH_VERSION}" ]] && {
    eval '_IdxArg_="'${!_ZETA_GETOPTS_IDX}'"'
    if (( _ZETA_GETOPTS_NXT > 0 && _ZETA_GETOPTS_NXT <= _xMAX_ )); then
      eval '_xNxtArg_="'${!_ZETA_GETOPTS_NXT}'"'
    else
      _ZETA_GETOPTS_NXT=-1; _xNxtArg_=
    fi
  }
  [[ -n "${ZSH_VERSION}"  ]] && {
    eval '_IdxArg_="'${(P)_ZETA_GETOPTS_IDX}'"'
    if (( _ZETA_GETOPTS_NXT > 0 && _ZETA_GETOPTS_NXT <= _xMAX_ )); then
      eval '_xNxtArg_="'${(P)_ZETA_GETOPTS_NXT}'"'
    else
      _ZETA_GETOPTS_NXT=-1; _xNxtArg_=
    fi
  }

  # _ZETA_GETOPTS_IDX              _ZETA_GETOPTS_NXT
  # _ZETA_GETOPTS_ARG -> _IdxArg_    _ZETA_GETOPTS_VAL -> _xNxtArg_
  _ZETA_GETOPTS_ARG="${_IdxArg_}"; _ZETA_GETOPTS_VAL="${_xNxtArg_}"
  [[ -z "${_IdxArg_}" ]] && {
    getopts±clean ${LINENO} "invalid empty argument"; return 1
  }

  # 获取选项字符串的第 1 个字节和第 2 个字节
  _bF1_="${_IdxArg_:0:1}"; _bF2_="${_IdxArg_:1:1}"
  # echo "调试 [${_IdxArg_}] => AB1=[${_bF1_}] AB2=[${_bF2_}]"
  [[ "${_bF1_}" != - ]] && {
    getopts±clean ${LINENO} "argument must begin with dash, but got $(@R3 ${_bF1_})"
    return 1
  }
  if [[ "${_bF2_}" == - ]]; then
    _IdxArg_="${_IdxArg_:2}" # 长选项 --XXX
    [[ -z "${_IdxArg_}" ]] && {
      getopts±clean ${LINENO} "invalid empty long argument"; return 1
    }; (( _idx_ = __zIDX__ )); _oI_=
    while (( _idx_ <= ${#_ZETA_GETOPTS_L_[@]} )); do
      _val_="${_ZETA_GETOPTS_L_[${_idx_}]}"
      [[ "${_val_:2}" == "${_IdxArg_}" ]] && {
        (( _oI_ = _idx_ )); _rob_="${_val_:1:1}"; break
      }; (( _idx_++ ))
    done
  else
    _IdxArg_="${_IdxArg_:1}" # 短选项 -XXX
    [[ -z "${_IdxArg_}" ]] && {
      getopts±clean ${LINENO} "invalid empty short argument"; return 1
    }; (( _idx_ = __zIDX__ )); _oI_=
    while (( _idx_ <= ${#_ZETA_GETOPTS_S_[@]} )); do
      _val_="${_ZETA_GETOPTS_S_[${_idx_}]}"
      [[ "${_val_:2}" == "${_IdxArg_}" ]] && {
        (( _oI_ = _idx_ )); _rob_="${_val_:1:1}"; break
      }; (( _idx_++ ))
    done
  fi
  [[ -z "${_oI_}" ]] && {
    getopts±clean ${LINENO} "Unknown option ${_IdxArg_}"; return 1;
  }

  # echo "调试 [${_rob_}] ARG=[${_ZETA_GETOPTS_ARG}] VAL=[${_ZETA_GETOPTS_VAL}]"

  case "${_rob_}" in
    "+") # 必须
      if [[  -z "${_xNxtArg_}" || "${_xNxtArg_:0:1}" == - ]]; then
        getopts±clean ${LINENO} "$(@R3 ${_IdxArg_}) required value"; return 1
      fi; (( _ZETA_GETOPTS_NXT > 0 )) && (( _ZETA_GETOPTS_NXT++ ))
      ;;
    ":") # 可选
      if [[ "${_xNxtArg_:0:1}" == - ]]; then
        _ZETA_GETOPTS_VAL=
      else
        (( _ZETA_GETOPTS_NXT > 0 )) && (( _ZETA_GETOPTS_NXT++ ))
      fi
      ;;
    "~") _ZETA_GETOPTS_VAL= ;; # 开关
    *) getopts±clean ${LINENO} "internal error"; return 1 ;;
  esac; (( _ZETA_GETOPTS_NXT > _xMAX_ )) && _ZETA_GETOPTS_NXT=-1; return 0
}

return

# 长短位置参数解析调用示例
function @zeta:getopts-sample() { # 必须+  可选:  ~开关
  local _opts_="+S1,:S2|L2,~|L3,S4,S5|L5,|L6,+X1|X1"
  [[ $# -eq 0 ]] && { echo "=> ${_opts_}"; return; }

  local xIdx  xNxt
  local _ZETA_GETOPTS_{IDX=0,NXT=1,ARG,VAL}
  while @zeta:getopts "${_opts_}"  "$@"; do
    printf -v xIdx "%02d" "${_ZETA_GETOPTS_IDX}"
    printf -v xNxt "%02d" "${_ZETA_GETOPTS_NXT}"
    # echo "IDX=[${xIdx}] ARG=[${_ZETA_GETOPTS_ARG}]"
    # echo "NXT=[${xNxt}] VAL=[${_ZETA_GETOPTS_VAL}]"; echo
    case "${_ZETA_GETOPTS_ARG}" in
       -S1) echo "[${xIdx}]  -S1 参数(必需) [${xNxt}] -> [${_ZETA_GETOPTS_VAL}]" ;;
      --S2) echo "[${xIdx}]  -S2 参数(可选) [${xNxt}] -> [${_ZETA_GETOPTS_VAL}]" ;;
      --L2) echo "[${xIdx}] --L2 参数(可选) [${xNxt}] -> [${_ZETA_GETOPTS_VAL}]" ;;
      --L3) echo "[${xIdx}] --L3 参数(开关) [${xNxt}]" ;;
       -S4) echo "[${xIdx}]  -S4 参数(开关) [${xNxt}]" ;;
       -S5) echo "[${xIdx}]  -S5 参数(开关) [${xNxt}]" ;;
      --L5) echo "[${xIdx}] --L5 参数(开关) [${xNxt}]" ;;
      --L6) echo "[${xIdx}] --L6 参数(开关) [${xNxt}]" ;;
       -X1) echo "[${xIdx}]  -X1 参数(必需) [${xNxt}] -> [${_ZETA_GETOPTS_VAL}]";;
      --X1) echo "[${xIdx}] --X1 参数(必需) [${xNxt}] -> [${_ZETA_GETOPTS_VAL}]" ;;
    esac
  done
}

# @zeta:getopts-sample -S1 x --L2 --L3 -S4 -S5 --L6 -X1 zz --X1 yy
# @zeta:getopts-sample -S1 'yy zz' --L2 'zb cx' --L3 -S4 -S5 --L6 -X1 'zz bb' --X1 yy
