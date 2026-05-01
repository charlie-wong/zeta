# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 启动优化和延迟加载
# https://zhuanlan.zhihu.com/p/464117825
# https://blog.jonlu.ca/posts/speeding-up-zsh
# https://htr3n.github.io/2018/07/faster-zsh
# https://carlosbecker.com/posts/speeding-up-zsh
# https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load
# https://frederic-hemberger.de/notes/speeding-up-initial-zsh-startup-with-lazy-loading

# $1 源文件  $2 命令名
# $3...$N 命令简单参数, 创建一次性补全函数
function @zeta:-lazy-add-cmd() {
  [[ $# -lt 2 || -z "$1" || -z "$2" ]] && return 1

  local -a _cmd_args_
  local _src_="$1" _cmd_="$2"
  local _stub_="@zeta:lazy-load±$2"
  local _comp_="@zeta:lazy-comp±$2"

  [[ ! -f "${_src_}" ]] && {
    @zeta:wmsg "$(@G9 ${_src_}) file not exist."
    return 2
  }

  @zeta:has-cmd "${_cmd_}" && {
    @zeta:wmsg "$(@G9 ${_cmd_}) command already exist."
    return 3
  }

  [[ $# -gt 2 ]] && { shift; shift; _cmd_args_=( "$@" ); }

  eval "
    function ${_stub_}() {
      source "${_src_}";        # 插件加载器
    }

    function ${_cmd_}() {
      unset -f ${_cmd_}         # 删除占位函数
      if @zeta:has-cmd ${_comp_}; then
        compdef -d ${_cmd_}     # 注销占位补全
        unset -f ${_comp_}      # 删除补全占位
      fi

      ${_stub_}          # 加载源文件
      unset -f ${_stub_} # 删除加载器
      ${_cmd_} \"\$@\"   # 加载后执行
    }

    if [[ -n '${_cmd_args_[*]}' ]]; then
      function ${_comp_}() {
        local -a _xargs_=( ${_cmd_args_[@]} )
        _describe 'command' _xargs_
        compdef -d ${_cmd_}   # 注销占位补全
        unset -f ${_cmd_}     # 删除占位函数
        unset -f ${_comp_}    # 删除补全占位
        ${_stub_}             # 加载源文件
        unset -f ${_stub_}    # 删除加载器
      }

      # zsh/sched 模块, 延迟 1s 执行, 等待 compinit
      sched +1 compdef ${_comp_}  ${_cmd_}
    fi
  "
}

# NOTE This lazy loader is just for simple plugin
function @zeta:lazy-register() {
  local cmd=$1; shift
  @zeta:-lazy-add-cmd "${ZETA_DIR}/zsh/plugins/lazy/${cmd}" ${cmd} $@
}
