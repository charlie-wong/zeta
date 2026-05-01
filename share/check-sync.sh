#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# ${0%/*}  仅删除 $0 结尾文件名(匹配最短)
# ${0##*/} 仅保留 $0 结尾文件名(匹配最长)
THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径

ZETA_DIR="$(realpath "${THIS_DIR}/..")"
source "${ZETA_DIR}/zsh/lib/color.zsh"

function is-host-arch()    { false; }
function is-host-ubuntu()  { false; }

function has-cmd() {  command -v "$1" > /dev/null; }
function no-cmd() { ! command -v "$1" > /dev/null; }

if [[ "$(lsb_release -is)" == 'Ubuntu' ]]; then
  function is-host-ubuntu() { true; }
elif [[ "$(lsb_release -is)" == 'Arch' ]]; then
  function is-host-arch()   { true; }
fi

if ! is-host-ubuntu && ! is-host-arch; then
  exit 1
fi

function tree-like-status() {
  local xDIR="$2" orgSRC="$3" dstSYS="$4" MAX=$5 hashZ hashS zfile
  if [[ -n "${xDIR}" ]]; then
    zfile="${ZETA_DIR}/share/${xDIR}/${orgSRC}"
  else
    zfile="${ZETA_DIR}/share/${orgSRC}"
  fi
  [[ ! -f "${zfile}" ]] && return

  hashZ=$(md5sum "${zfile}" | cut -d' ' -f1)
  [[ -f "${dstSYS}" ]] && hashS=$(md5sum "${dstSYS}" | cut -d' ' -f1)

  local symbol
  case "$1" in
    BEG) symbol="├─ " ;;
    MID) symbol="├─ " ;;
    END) symbol="└─ " ;;
    ONE) symbol="└─ " ;; # ┹─
      *) return ;;
  esac

  [[ -z "${MAX}" ]] && MAX=50

  if [[ ! -f "${dstSYS}" ]]; then
    printf "${symbol}$(@R3 diff) $(@Y3 "%-${MAX}s") -> $(@D9 ${dstSYS})\n" "${orgSRC}"
  elif [[ "${hashZ}" == "${hashS}" ]]; then
    printf "${symbol}$(@G3 sync) $(@Y3 "%-${MAX}s") -> $(@C3 ${dstSYS})\n" "${orgSRC}"
  else
    printf "${symbol}$(@R3 diff) $(@Y3 "%-${MAX}s") -> $(@C3 ${dstSYS})\n" "${orgSRC}"
  fi
}

function check-sync-status-apt() {
  ! is-host-ubuntu && return
  echo "$(@D9 ${ZETA_DIR}/share/)$(@B3 apt)"

  local srcZ="$(lsb_release -sr)-$(lsb_release -sc)"
  local srcR="${ZETA_DIR}/share/apt/${srcZ}"
  [[ ! -d "${srcR}" ]] && return

  local maxcnt count orgSRC dstSYS

  maxcnt=$(ls "${srcR}" | wc -l); count=0
  for it in $(ls "${srcR}"); do
    orgSRC="${srcR}/${it}"
    dstSYS="$(cat "${orgSRC}" | head -1 | cut -d' ' -f2)"
    if (( count++, count == maxcnt )); then
        tree-like-status END "apt" "${srcZ}/${it}" "${dstSYS}"
    else
      if (( count == 1 )); then
        tree-like-status BEG "apt" "${srcZ}/${it}" "${dstSYS}"
      else
        tree-like-status MID "apt" "${srcZ}/${it}" "${dstSYS}"
      fi
    fi
  done
  echo
  srcZ="gpg-keyrings"
  srcR="${ZETA_DIR}/share/apt/${srcZ}"
  maxcnt=$(ls "${srcR}" | wc -l); count=0
  for it in $(ls "${srcR}"); do
    orgSRC="${srcR}/${it}"
    dstSYS="/etc/apt/keyrings/${it}"
    if (( count++, count == maxcnt )); then
        tree-like-status END "apt" "${srcZ}/${it}" "${dstSYS}"
    else
      if (( count == 1 )); then
        tree-like-status BEG "apt" "${srcZ}/${it}" "${dstSYS}"
      else
        tree-like-status MID "apt" "${srcZ}/${it}" "${dstSYS}"
      fi
    fi
  done
  echo
}

function check-sync-status-fstab() {
  if ! is-host-ubuntu && ! is-host-arch; then
    return
  fi

  local srcZ="ubuntu"
  if is-host-arch; then
    srcZ="arch"
  fi

  echo "$(@D9 ${ZETA_DIR}/share/)$(@B3 fstab)"
  tree-like-status ONE "fstab" "${srcZ}" "/etc/fstab"
  echo
}

function check-sync-status-misc() {
  echo "$(@D9 ${ZETA_DIR}/share/)$(@B3 '*')"
  local orgSRC dstSYS

  orgSRC="fcitx5.punc"
  dstSYS="/usr/share/fcitx5/punctuation/punc.mb.zh_CN"
  tree-like-status BEG "" "${orgSRC}" "${dstSYS}"

  orgSRC="journald.conf"
  dstSYS="/etc/systemd/journald.conf"
  tree-like-status MID "" "${orgSRC}" "${dstSYS}"

  orgSRC="sysctl.conf"
  dstSYS="/etc/sysctl.conf"
  tree-like-status MID "" "${orgSRC}" "${dstSYS}"

  orgSRC="updatedb.conf"
  dstSYS="/etc/updatedb.conf"
  tree-like-status END "" "${orgSRC}" "${dstSYS}"
  echo
}

function check-home-symlink() {
  local symlink="$1" linksrc

  [[ ! -f "${HOME}/${symlink}" &&  ! -d ${HOME}/${symlink} ]] && return

  if [[ -h "${HOME}/${symlink}" ]]; then
    linksrc="$(readlink "${HOME}/${symlink}")"
    printf "$(@D9 "${HOME}/")$(@G3 "%-44s") -> $(@Y3 "${linksrc}")\n"  "${symlink}"
  else
    echo "$(@D9 "${HOME}/")$(@D9 ${symlink})"
  fi
}

check-sync-status-apt
check-sync-status-fstab
check-sync-status-misc

check-home-symlink ".ssh"
check-home-symlink ".gnupg"
check-home-symlink ".npmrc"
check-home-symlink ".inputrc"
check-home-symlink ".gitconfig"
echo
check-home-symlink ".config/git"
check-home-symlink ".config/nvim"
check-home-symlink ".config/ov"
check-home-symlink ".config/Code/User/settings.json"
echo
check-home-symlink ".local/share/fonts"
echo
