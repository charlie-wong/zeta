# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# ${COLUMNS}, ${ROWS}

# https://www.asciiart.eu/text-to-ascii-art
function @zeta:ascii-art-zeta() {
  echo # ANSI Shadow, 14pt, Double corners
  echo "$1╔─────────────────────────────────╗$2"
  echo "$1│███████╗███████╗████████╗ █████╗ │$2"
  echo "$1│╚══███╔╝██╔════╝╚══██╔══╝██╔══██╗│$2"
  echo "$1│  ███╔╝ █████╗     ██║   ███████║│$2"
  echo "$1│ ███╔╝  ██╔══╝     ██║   ██╔══██║│$2"
  echo "$1│███████╗███████╗   ██║   ██║  ██║│$2"
  echo "$1│╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝│$2"
  echo "$1╚─────────────────────────────────╝$2"
  echo
}

function @zeta:ascii-art-welcome() {
  echo # ANSI Shadow, 14pt, Double corners
  echo "$1╔──────────────────────────────────────────────────────────────╗$2"
  echo "$1│██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗│$2"
  echo "$1│██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝│$2"
  echo "$1│██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗  │$2"
  echo "$1│██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  │$2"
  echo "$1│╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗│$2"
  echo "$1│ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝│$2"
  echo "$1╚──────────────────────────────────────────────────────────────╝$2"
  echo
}

function @zeta:ascii-art-charles() {
  echo # ANSI Shadow, 14pt, Double corners
  echo "$1╔──────────────────────────────────────────────────────────────────────────────────────────────────╗$2"
  echo "$1│ ██████╗██╗  ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗    ██╗    ██╗ ██████╗ ███╗   ██╗ ██████╗ │$2"
  echo "$1│██╔════╝██║  ██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝    ██║    ██║██╔═══██╗████╗  ██║██╔════╝ │$2"
  echo "$1│██║     ███████║███████║██████╔╝██║     █████╗  ███████╗    ██║ █╗ ██║██║   ██║██╔██╗ ██║██║  ███╗│$2"
  echo "$1│██║     ██╔══██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║    ██║███╗██║██║   ██║██║╚██╗██║██║   ██║│$2"
  echo "$1│╚██████╗██║  ██║██║  ██║██║  ██║███████╗███████╗███████║    ╚███╔███╔╝╚██████╔╝██║ ╚████║╚██████╔╝│$2"
  echo "$1│ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝     ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ │$2"
  echo "$1╚──────────────────────────────────────────────────────────────────────────────────────────────────╝$2"
  echo
}

function @zeta:-ascii-art-random() {
  # bash 数组下标 0 开始; zsh 数组下标 1 开始
  local fi aaf=(
    @zeta:ascii-art-zeta
    @zeta:ascii-art-welcome
    @zeta:ascii-art-charles
  )
  local color=( 31 32 33 34 35 36 37 90 91 92 93 94 95 96)
  local idx=$(( ${RANDOM} % ${#color[@]} + 1 ))

  fi=$(( ${RANDOM} % ${#aaf[@]} + 1 ))

  case $(( ${RANDOM} % 2 )) in
    0) ${aaf[${fi}]} "\e[0;${color[${idx}]}m"   "\e[0m" ;;
    1) ${aaf[${fi}]} "\e[0;${color[${idx}]};5m" "\e[0m" ;;
  esac
}

function ascii-art() {
  if [[ $# -eq 0 ]]; then
    @zeta:-ascii-art-random
    return
  fi

  case "$1" in
       zeta) @zeta:ascii-art-zeta    ;;
    welcome) @zeta:ascii-art-welcome ;;
    charles) @zeta:ascii-art-charles ;;
     random) @zeta:-ascii-art-random ;;
          *) @zeta:-ascii-art-random ;;
  esac
}

function @zeta:comp-ascii-art() {
  local arts=( zeta welcome charles random )
  _describe 'command' arts
}

compdef @zeta:comp-ascii-art ascii-art
