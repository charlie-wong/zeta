# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 系统预定义环境变量
# echo "HOSTTYPE=$HOSTTYPE, OSTYPE=$OSTYPE"
# echo "MACHTYPE=$MACHTYPE, HOSTNAME=$HOSTNAME"

function @zeta:host-is-linux()        { false; }
function @zeta:host-is-arch()         { false; }
function @zeta:host-is-debian()       { false; }
function @zeta:host-is-ubuntu()       { false; }

function @zeta:host-is-windows()      { false; }
function @zeta:host-is-msys()         { false; }
function @zeta:host-is-mingw()        { false; }
function @zeta:host-is-cygwin()       { false; }

#    Arch: x86, x86_64, arm, mips, thumb
#  Endian: BE(Big Endian), LE(Little Endian)
# SubArch: v7, v8, v9m
declare _ZETA_HOST_CPU

# Vendor: microsoft, arch, debian, ubuntu
declare _ZETA_HOST_VENDOR

# Operating System: linux, macos, windows
declare _ZETA_HOST_OS

#   ABI: gnu(glibc), musl(libc), eabi(Embedded ABI), msvc, mysy, cygwin, mingw
# Extra: hf(Hardware Float Point)
declare _ZETA_HOST_EXTRA

# https://www.binarytides.com/linux-command-to-check-distro/
# -> cat /proc/version
#    contains info about kernel and distro
# -> Ubuntu/Debian Based      CentOS/Fedora Based
#    cat /etc/issue           /etc/centos-release
#    cat /etc/issue.net       /etc/redhat-release
#    cat /etc/os-release      /etc/system-release
#    cat /etc/lsb-release     cat /etc/lsb-release
# -> Portable Command
#    uname -a || lsb_release -a
#    cat /etc/[A-Za-z]*[_-][vr]e[rl]*
#    cat /etc/*-release | uniq -u
#    cat /etc/*version /etc/*release /proc/version* | uniq -u

function @zeta:-init-host-triplet() {
  _ZETA_HOST_CPU="$(uname -m)"
  _ZETA_HOST_CPU="${_ZETA_HOST_CPU:l}"

  _ZETA_HOST_VENDOR="$(lsb_release -is)"
  _ZETA_HOST_VENDOR="${_ZETA_HOST_VENDOR:l}"
  eval "function @zeta:host-is-${_ZETA_HOST_VENDOR}() { true; }"

  _ZETA_HOST_OS="$(uname -s)"
  _ZETA_HOST_OS="${_ZETA_HOST_OS:l}"
  eval "function @zeta:host-is-${_ZETA_HOST_OS}() { true; }"

  case "${_ZETA_HOST_VENDOR}" in
    msys|mingw|cygwin)
      function @zeta:host-is-windows() { true; }
      _ZETA_HOST_EXTRA=${_ZETA_HOST_VENDOR}
      _ZETA_HOST_VENDOR=windows
    ;;
  esac

  if @zeta:host-is-linux; then
    _ZETA_HOST_EXTRA='gnu'; # https://musl.libc.org
    ldd --version 2>&1 | grep -q 'musl' && _ZETA_HOST_EXTRA="musl"

    # ELF 可执行文件格式 https://man.archlinux.org/man/elf.5.en
    # https://www.kernel.org/doc/html/latest/filesystems/proc.html
    # Architecture detection without dependencies beyond coreutils
    # NOTE `printf` like dash only supports octal escape sequences
    if test -L /proc/self/exe; then
      # ELF file magic 4-bytes header is \x7fELF
      [[ "$(head -c 4 /proc/self/exe)" == "$(printf '\177ELF')" ]] && {
        local _bits_=$(head -c 5 /proc/self/exe | tail -c 1)
        if [[ "${_bits_}" == "$(printf '\001')" ]]; then
          _bits_=32 # 0x01 表示 32-bit 体系结构
        elif [[ "${_bits_}" == "$(printf '\002')" ]]; then
          _bits_=64 # 0x02 表示 64-bit 体系结构
        fi

        # 数据<低字节>内存<低地址>  数据 0x12345678 => 内存 78 53 34 12
        # 数据<高字节>内存<低地址>  数据 0x12345678 => 内存 12 34 56 78
        local _endian_="$(head -c 6 /proc/self/exe | tail -c 1)"
        if [[ "${_endian_}" == "$(printf '\001')" ]]; then
          _endian_=le # 0x01 小端序 little-endian
        elif [[ "${_endian_}" == "$(printf '\002')" ]]; then
          _endian_=be # 0x02 大端序 big-endian => 网络字节顺序
        fi

        local _bei_
        [[ -n "${_bits_}" ]] && _bei_=".${_bits_}"
        [[ -n "${_endian_}" ]] && _bei_+=".${_endian_}"
      }
    fi
  fi

  # Fedora 可选架构 https://alt.fedoraproject.org/alt
  # 1978 -> X86, 1981 -> MIPS, 1983 -> ARM, 1991 -> PowerPC
  # https://uapi-group.org/specifications/specs/extension_image/#architecture
  case "${_ZETA_HOST_CPU}" in
    # https://www.sandpile.org/x86/cpuid.htm
    i386|i486|i586|i686|i786|x86)   _ZETA_HOST_CPU=x86${_bei_} ;;
    x86_64|x86-64|amd64|x64)        _ZETA_HOST_CPU=x86${_bei_} ;;
    # https://developer.arm.com/architectures
    arm*)                           _ZETA_HOST_CPU=arm${_bei_} ;;
    # https://apple.fandom.com/wiki/PowerPC
    ppc*)                           _ZETA_HOST_CPU=ppc${_bei_} ;;
    # https://mips.com
    mips*)                          _ZETA_HOST_CPU=mips${_bei_} ;;
    # https://riscv.org/technical/specifications
    riscv*)                         _ZETA_HOST_CPU=riscv${_bei_} ;;
    # https://www.loongson.cn/system/loongarch 龙架构
    loongarch*)                     _ZETA_HOST_CPU=loongarch${_bei_} ;;
  esac
}

@zeta:-init-host-triplet
unset -f @zeta:-init-host-triplet

# https://clang.llvm.org/docs/CrossCompilation.html
# https://llvm.org/doxygen/classllvm_1_1Triple.html
# https://doc.rust-lang.org/nightly/rustc/platform-support.html

# https://wiki.osdev.org/Target_Triplet
# 命令 gcc -dumpmachine 显示当前平台三元组
# Three-Field Triplet 结构 Machine-Vendor-OperatingSystem

# NOTE 构建无歧义三元组：- 分割三元组字符串，. 分割字段内字符串
# x86.64.le-ubuntu-linux.gnu, x86.64.le-arch-linux.musl

function host-triplet() {
  local triplet="${_ZETA_HOST_CPU}"
  triplet+="-${_ZETA_HOST_VENDOR}"
  triplet+="-${_ZETA_HOST_OS}"

  if [[ -n "${_ZETA_HOST_EXTRA}" ]]; then
    triplet+=".${_ZETA_HOST_EXTRA}"
  fi

  echo "${triplet}"
}
