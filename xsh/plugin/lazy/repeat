# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# Zsh like `repeat` command for Bash
# => repeat 10 echo foo
function repeat() {
  (( $# < 2 )) && {
    echo "  Syntax: $(@G9 repeat) $(@R3 max) $(@Y9 codes-to-repeat)"
    echo "Example1: $(@G9 repeat) $(@R3 5) $(@Y9 echo) $(@D9 '\${idx} - Hello')"
    echo "Example2: $(@G9 repeat) $(@R3 5) $(@Y9 echo) '$(@D9 '${idx} - Hello')'"
    echo "NOTE => $(@B3 idx) is internel counter, from $(@R3 1) to $(@R3 max)"
    return
  }

  local idx nums="$1" max=$1; shift
  if shopt -q extglob; then
    # NOTE +(PAT) is for match one or more PAT
    nums="${nums##+([0-9])}" # remove leading numbers
    nums="${nums%%+([0-9])}" # remove tailing numbers
    [[ -n "${nums}" ]] && return 2
  else
    (
      shopt -s extglob
      nums="${nums##+([0-9])}" # remove leading numbers
      nums="${nums%%+([0-9])}" # remove tailing numbers
      [[ -n "${nums}" ]] && return 1
    )
    [[ $? -ne 0 ]] && return 2
  fi

  for idx in $(seq 1 ${max}); do eval "$@"; done
}
