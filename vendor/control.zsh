# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# RubyGems 第三方依赖软件包的安装位置 GEM_HOME
# https://jekyllrb.com/docs/installation/ubuntu
# 中科 https://mirrors.ustc.edu.cn/help/rubygems.html
# 清华 https://mirrors.tuna.tsinghua.edu.cn/help/rubygems
if @zeta:has-cmd ruby; then
  if [[ -d "${ZETA_DIR}/vendor/ruby/gems" ]]; then
    export GEM_HOME="${ZETA_DIR}/vendor/ruby/gems"
  fi
fi

# 终端显示 NodeJS 安装位置 $ npm config get prefix
# 中科 https://mirrors.ustc.edu.cn/help/node.html
# 清华 https://mirrors.tuna.tsinghua.edu.cn/help/nodejs-release
if @zeta:has-cmd node; then
  NODE_PATH="$(command -v node)" # NodeJS 模块查找路径
  NODE_PATH="$(realpath -eq "${NODE_PATH}")" # 冒号分割列表
  export NODE_PATH="${NODE_PATH%/bin/node}/lib/node_modules"
fi

# 终端显示当前 Go 环境变量 $ go env
if @zeta:has-cmd go; then
  GOROOT="$(command -v go)" # Go 语言的安装目录
  GOROOT="$(realpath -eq "${GOROOT}")" # => go/X.Y.Z/bin/go
  export GOROOT="${GOROOT%/bin/go}"    # => go/X.Y.Z

  [[ "${GOROOT}" =~ "^${ZETA_DIR}/vendor/go/[0-9.]*$" ]] && {
    export GO111MODULE=on # 启用 module-aware 模式
    # 模块包下载及安装, 目录结构 bin/ + pkg/ + src/
    export GOPATH="${GOROOT%/*}/modules" # => vendor/go/modules
  }

  # export GOENV=""   # 用户配置, 默认值 ~/.config/go/env
  # export GOCACHE="" # 编译缓存, 默认值 ~/.cache/go-build

  # Go 模块代理下载地址(国内加速镜像)
# export GOPROXY="https://goproxy.io,direct" # 官方地址
  export GOPROXY="https://goproxy.cn,direct" # 七牛 CDN
# export GOPROXY="https://mirrors.aliyun.com/goproxy,direct" # 阿里云
fi

# https://doc.rust-lang.org/stable/cargo/index.html
# 中科 https://mirrors.ustc.edu.cn/help/crates.io-index.html
# 清华 https://mirrors.tuna.tsinghua.edu.cn/help/crates.io-index
if [[ -d "${ZETA_DIR}/vendor/rust/cargo" ]]; then
  # 默认值 ~/.cargo 或 %USERPROFILE%/.cargo
  export CARGO_HOME="${ZETA_DIR}/vendor/rust/cargo"
fi

if @zeta:has-cmd java; then
  JAVA_HOME="$(command -v java)"
  JAVA_HOME="$(realpath -eq "${JAVA_HOME}")"
  export JAVA_HOME="${JAVA_HOME%/bin/java}"
  # Android Studio Java Development Kit
  export STUDIO_JDK="${JAVA_HOME}"
fi

[[ -n "${GOPATH:-}" && -d "${GOPATH}/bin" ]] && path-head-add "${GOPATH}/bin"
[[ -n "${GEM_HOME:-}" && -d "${GEM_HOME}/bin" ]] && path-head-add "${GEM_HOME}/bin"
[[ -n "${CARGO_HOME:-}" && -d "${CARGO_HOME}/bin" ]] && path-head-add "${CARGO_HOME}/bin"

function zman() {
  local vendorMAN  appMAN

  appMAN="$(@zeta:-vendor-pkg-path cmake)"
  [[ -n "${appMAN}" ]] && appMAN="$(realpath -eq "${appMAN}/../man")"
  vendorMAN="${appMAN}"

  appMAN="$(@zeta:-vendor-pkg-path java)"
  [[ -n "${appMAN}" ]] && appMAN="$(realpath -eq "${appMAN}/../man")"
  vendorMAN="${appMAN}:${vendorMAN}"

  appMAN="$(@zeta:-vendor-pkg-path node)"
  [[ -n "${appMAN}" ]] && appMAN="$(realpath -eq "${appMAN}/../share/man")"
  vendorMAN="${appMAN}:${vendorMAN}"

  appMAN="$(@zeta:-vendor-pkg-path rustc)"
  [[ -n "${appMAN}" ]] && appMAN="$(realpath -eq "${appMAN}/../share/man")"
  vendorMAN="${appMAN}:${vendorMAN}"

  appMAN="$(@zeta:-vendor-pkg-path gh)"
  [[ -n "${appMAN}" ]] && appMAN="$(realpath -eq "${appMAN}/man")"
  vendorMAN="${appMAN}:${vendorMAN}"

  # https://www.man7.org/linux/man-pages/man5/manpath.5.html
  MANPATH="${vendorMAN}:" man $@ # 默认搜索路径前追加
}

function @zeta:-is-vendor-pkg() {
  [[ "$1" =~ "^${ZETA_DIR}/vendor/*" ]]
}

function @zeta:-vendor-pkg-path() {
  local _path_; _path_="$(command -v $1)"
  [[ $? -ne 0 ]] && return
  _path_="$(realpath -eq "${_path_}")"; _path_="${_path_%/*}"
  @zeta:-is-vendor-pkg "${_path_}" && echo "${_path_}"
}

function @zeta:-vendor-pkg-version() {
  local app="${ZETA_DIR}/vendor/$1"
  if [[ -d "${app}" ]]; then
    # 参数 --hide='PATTERN' 和 --ignore='PATTERN' 可以多次重复使用
   command ls --hide='*'{.zip,.bz2,.gz,.xz} --hide='[^0-9]*' "${app}"
  fi
}

function @zeta:-vendor-create-link() {
  local sym="${ZETA_DIR}/bin/$1"
  local app="${ZETA_DIR}/vendor/$2"
  [[ -h "${app}" ]] && app="$(realpath -eq "${app}")"
  if [[ -n "${app}" && -f "${app}" ]]; then
    ln -sTf "${app}" "${sym}" # -s 符号链接 -f 若已存在则删除后重建
    printf "Create $(@D9 'zeta/bin/')$(@G3 "%-18s") " "$1"
    echo "$(@D9 '->') $(@Y3 "${app}")"
  fi
}

function @zeta:-vendor-delete-link() {
  local binEXE=$1  pkgBIN
  case $1 in
    rust) binEXE=rustc ;;
   helix) binEXE=hx    ;;
  esac

  # 读 binEXE 软链接, 找到 pkgBIN 目标路径
  pkgBIN="$(@zeta:-vendor-pkg-path ${binEXE})"
  [[ -z "${pkgBIN}" ]] && return

  local binDIR="${ZETA_DIR}/bin"

  if [[ "$1" == "helix" ]]; then
    [[ -h "${binDIR}/${binEXE}" ]] && {
      printf "Delete $(@D9 'zeta/bin/')$(@Y3 %-18s) $(@D9 '->') " ${binEXE}
      echo "$(@G3 "$(realpath -eq "${binDIR}/${binEXE}")")"
      # rm -f "${binDIR}/${binEXE}"
    }
    return
  fi

  for binEXE in $(ls "${pkgBIN}"); do
    [[ -h "${binDIR}/${binEXE}" ]] && {
      printf "Delete $(@D9 'zeta/bin/')$(@Y3 %-18s) $(@D9 '->') " ${binEXE}
      echo "$(@G3 "$(realpath -eq "${binDIR}/${binEXE}")")"
      # rm -f "${binDIR}/${binEXE}"
    }
  done
}

function @zeta:-zeta-switch() {
  [[ "$2" == "reset" ]] && {
    @zeta:-vendor-delete-link $1
    return
  }
  local app="$1"  selected="$2"  version
  for version in $(@zeta:-vendor-pkg-version ${app}); do
    [[ "${selected}" == "${version}" ]] && {
      if [[ "${app}" == "helix" ]]; then
        @zeta:-vendor-create-link hx "${app}/${version}/hx"
        return
      fi

      local pkgBIN="${app}/${version}/bin" binEXE
      for binEXE in $(ls "${ZETA_DIR}/vendor/${pkgBIN}"); do
        @zeta:-vendor-create-link ${binEXE} "${pkgBIN}/${binEXE}"
      done
      return
    }
  done
  echo "invalid version <$(@R3 $2)> for $(@D9 vendor/)$(@Y3 $1) package"
}

function @zeta:-switch-help() {
  local _PKGS_=( cmake  go  java  nim  node  rust  helix ) app version
  echo
  echo "-> $(@D9 zeta-switch) $(@R3 reset) $(@G3 PKG)"
  echo
  for app in ${_PKGS_[@]}; do
    for version in $(@zeta:-vendor-pkg-version ${app}); do
      printf -v app "%-5s" "${app}"
      echo "-> $(@D9 zeta-switch) $(@G3 "${app}") $(@Y3 ${version})"
    done
  done
  echo
}

function zeta-switch() {
  [[ $# -eq 0 || -z "$1" ]] && { @zeta:-switch-help; return; }

  if [[ "$1" == reset ]]; then
    case "$2" in
      cmake|go|java|nim|node|rust|helix)
        @zeta:-vendor-delete-link $2
        return
        ;;
      *) echo "invalid $(@D9 vendor/)$(@R3 $2) package"; return 1 ;;
    esac
  fi

  case "$1" in
    cmake) @zeta:-zeta-switch cmake "$2" ;; # cmake/$2/bin/*
       go) @zeta:-zeta-switch go    "$2" ;; #    go/$2/bin/*
     java) @zeta:-zeta-switch java  "$2" ;; #  java/$2/bin/*
      nim) @zeta:-zeta-switch nim   "$2" ;; #   nim/$2/bin/*
     node) @zeta:-zeta-switch node  "$2" ;; #  node/$2/bin/*
     rust) @zeta:-zeta-switch rust  "$2" ;; #  rust/$2/bin/*
    helix) @zeta:-zeta-switch helix "$2" ;; # helix/$2/hx
    *) echo "invalid $(@D9 vendor/)$(@R3 $1) package"; return 1 ;;
  esac

  if [[ "$1" == go ]]; then
    export GOROOT="${ZETA_DIR}/vendor/$1/$2"
  elif [[ "$1" == node ]]; then
    export NODE_PATH="${ZETA_DIR}/vendor/$1/$2/lib/node_modules"
  fi
}

function @zeta:comp-zeta-switch() {
  local -A opt_args
  local context state state_descr line
  local -a _apps_=( cmake  go  java  nim  node  rust  helix ) _keys_

  function comp±zeta-switch() {
    _keys_=( reset ${_apps_[@]} )
    _describe 'command' _keys_; unset -f comp±zeta-switch
  }

  # 语法 N:Message:Action 表示第 N 个参数执行 Action 行为
  # NOTE Action 可以是普通的 Shell 函数调用
  # NOTE Action 语法 ->XXX 表示将 state 设置为 XXX
  _arguments '1:参数壹:comp±zeta-switch' '2:参数贰:->todo'
  if [[ "todo" == "${state[1]}" ]]; then
    case "${line[1]}" in
      reset) _describe 'command' _apps_; return ;;
    esac
    _keys_=( $(@zeta:-vendor-pkg-version ${line[1]}) )
    _describe 'command' _keys_
  fi
}

# zsh/sched => 延迟 1s 执行, 等待 compinit 完成
sched +1 compdef @zeta:comp-zeta-switch zeta-switch
