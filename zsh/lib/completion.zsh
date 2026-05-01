# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# 先更新 fpath 然后执行 compinit 命令
# NOTE 默认补全位置 /usr/share/zsh/* 和 /usr/local/share/zsh/*
if [[ -d  "${ZETA_DIR}/zsh/comps" ]]; then
  fpath=( "${ZETA_DIR}/zsh/comps" ${fpath[@]} )
fi

# TODO A Guide to Zsh Completion System with Examples
# https://thevaluable.dev/zsh-completion-guide-examples
autoload -Uz compaudit  compinit  zrecompile

zstyle ':completion:*:sudo:*' command-path \
  /usr/{s,}bin  "${ZETA_DIR}/bin"

function @zeta:-zsh-comp-cache() {
  local zcs_refresh=1
  local zcs_fpath="# Zsh fpath: ${fpath}"
  local zcs_times="# Timestamp: $(date --iso-8601=seconds)"

  [[ -z "${ZSH_COMPDUMP}" ]] && ZSH_COMPDUMP="${HOME}/.zsh-compdump"
  if [[ -f "${ZSH_COMPDUMP}" ]]; then
    if @zeta:has-cmd md5sum; then
      [[ -f "${ZSH_COMPDUMP}.md5" ]] && {
        local zcs_md5old=$(cat "${ZSH_COMPDUMP}.md5")
        local zcs_md5new=$(md5sum "${ZSH_COMPDUMP}" | cut -d' ' -f1)
        [[ "${zcs_md5old}" == "${zcs_md5new}" ]] && zcs_refresh=0
      }
    else # 默认值 IFS=' '$'\t'$'\n'$'\0'
      { IFS=$'\n'; local zcs_last2=( $(tail -2 "${ZSH_COMPDUMP}") ); unset IFS; }
      if [[ ${#zcs_last2[@]} -eq 2 ]]; then
        [[ "${zcs_fpath}" == "${zcs_last2[2]}" ]] && zcs_refresh=0
      fi
    fi
  fi

  # cmd-comp metadata changed, delete & re-create
  (( zcs_refresh )) && command rm -f "${ZSH_COMPDUMP}"

  # NOTE 先更新 fpath 然后执行 compinit 命令
  compinit -i -d "${ZSH_COMPDUMP}" # 加载: compdef

  if (( zcs_refresh )); then
    echo >> "${ZSH_COMPDUMP}"
    echo "${zcs_times}" >> "${ZSH_COMPDUMP}"
    echo "${zcs_fpath}" >> "${ZSH_COMPDUMP}"

    zrecompile -q -p "${ZSH_COMPDUMP}"
    command rm -f "${ZSH_COMPDUMP}.zwc.old"
  fi

  if @zeta:has-cmd md5sum; then
    local zcd_md5now=$(md5sum "${ZSH_COMPDUMP}" | cut -d' ' -f1)
    [[ "${zcd_md5now}" != "${zcs_md5new}" ]] && {
      echo "${zcd_md5now}" > "${ZSH_COMPDUMP}.md5"
    }
  fi
}

@zeta:-zsh-comp-cache
unset -f @zeta:-zsh-comp-cache
