# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

function @zeta:host-is-linux()        { false; }
function @zeta:host-is-arch()         { false; }
function @zeta:host-is-debian()       { false; }
function @zeta:host-is-ubuntu()       { false; }

function @zeta:host-is-msys()         { false; }
function @zeta:host-is-mingw()        { false; }
function @zeta:host-is-cygwin()       { false; }
function @zeta:host-is-windows()      { false; }

# 命令 gcc -dumpmachine 显示当前平台的 triplet
# https://wiki.osdev.org/Target_Triplet
# https://clang.llvm.org/docs/CrossCompilation.html
# https://llvm.org/doxygen/classllvm_1_1Triple.html
# https://doc.rust-lang.org/nightly/rustc/platform-support.html

#    Arch: x86, x64, arm, mips, thumb
# SubArch: v7, v8, v9m
#  Endian: BE(Big Endian), LE(Little Endian)
declare _ZETA_HOST_CPU_ID="$(uname -m)"

# OS: windows, linux, arch, debian, ubuntu
declare _ZETA_HOST_SYSTEM="$(uname -s)"

#   ABI: gnu(glibc), musl(libc), eabi(Embedded ABI), msvc, mysy, cygwin, mingw
# Extra: hf(Hardware Float Point)
declare _ZETA_HOST_OS_ENV

# https://www.binarytides.com/linux-command-to-check-distro/
# -> uname, lsb_release
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
  # 环境变量 HOSTTYPE, OSTYPE, MACHTYPE, HOSTNAME
  case "${_ZETA_HOST_SYSTEM}" in
    Linux)      _ZETA_HOST_SYSTEM=linux     ;;
    MSYS*)      _ZETA_HOST_SYSTEM=msys      ;;
    MINGW*)     _ZETA_HOST_SYSTEM=mingw     ;;
    CYGWIN*)    _ZETA_HOST_SYSTEM=cygwin    ;;
    Windows_NT) _ZETA_HOST_SYSTEM=windows   ;;
  esac

  eval "function @zeta:host-is-${_ZETA_HOST_SYSTEM}() { true; }"

  case "${_ZETA_HOST_SYSTEM}" in
    msys|mingw|cygwin)
      function @zeta:host-is-windows() { true; }
      _ZETA_HOST_OS_ENV=${_ZETA_HOST_SYSTEM}
      _ZETA_HOST_SYSTEM=windows
    ;;
  esac

  if @zeta:host-is-linux; then
    @zeta:has-cmd lsb_release && {
      local distributorID="$(lsb_release -is)"
      if [[ -n "${ZSH_VERSION}" ]]; then
        eval 'distributorID="${distributorID:l}"' # 大写转小写
      elif [[ -n "${BASH_VERSION}" ]]; then
        eval 'distributorID="${distributorID@L}"' # 大写转小写
      fi
      eval "function @zeta:host-is-${distributorID}() { true; }"
    }

    _ZETA_HOST_OS_ENV='gnu'; # https://musl.libc.org
    ldd --version 2>&1 | grep -q 'musl' && _ZETA_HOST_OS_ENV="musl"

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

        if [[ -n "${_bits_}" && -n "${_endian_}" ]]; then
          local _xinfo_="${_bits_}${_endian_}"
        fi
      }
    fi
  fi

  # https://alt.fedoraproject.org/alt
  # 1978 -> X86, 1981 -> MIPS, 1983 -> ARM, 1991 -> PowerPC
  case "${_ZETA_HOST_CPU_ID}" in
    # https://www.sandpile.org/x86/cpuid.htm
    i386|i486|i586|i686|i786|x86)   _ZETA_HOST_CPU_ID=x86 ;;
    x86_64|x86-64|amd64|x64)        _ZETA_HOST_CPU_ID=x64 ;;
    # https://apple.fandom.com/wiki/PowerPC
    ppc*)                           _ZETA_HOST_CPU_ID=ppc${_xinfo_}   ;;
    # https://mips.com
    mips*)                          _ZETA_HOST_CPU_ID=mips${_xinfo_}  ;;
    # https://riscv.org/technical/specifications
    riscv*)                         _ZETA_HOST_CPU_ID=riscv${_xinfo_} ;;
    # 龙架构 https://www.loongson.cn/system/loongarch
    loongarch*)                     _ZETA_HOST_CPU_ID=lsa${_xinfo_}   ;;
    # https://developer.arm.com/architectures
    arm*|aarch*|xscale)             _ZETA_HOST_CPU_ID=arm${_xinfo_}   ;;
  esac
}

@zeta:-init-host-triplet
unset -f @zeta:-init-host-triplet

# x64-linux-gnu, x64-macos-musl, arm64v8be-linux-eabihf
function host-triplet() {
  if [[ -z "${_ZETA_HOST_OS_ENV}" ]]; then
     echo "${_ZETA_HOST_CPU_ID}-${_ZETA_HOST_SYSTEM}"
  else
    echo "${_ZETA_HOST_CPU_ID}-${_ZETA_HOST_SYSTEM}-${_ZETA_HOST_OS_ENV}"
  fi
}
