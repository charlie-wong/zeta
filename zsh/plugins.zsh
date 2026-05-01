# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

# Lazy Loading Just for Simple Plugin
source "${ZETA_DIR}/zsh/lib/lazy.zsh"
@zeta:lazy-register bd
@zeta:lazy-register goto
@zeta:lazy-register replace
@zeta:lazy-register color-pipe
@zeta:lazy-register cursor-style
@zeta:lazy-register ssh-add-keys
@zeta:lazy-register xcmd $(command ls --hide='*.*' "${ZETA_DIR}/zsh/bin")

# autoload -Uz hello
# -U  加载文件时禁用别名  -X 立即加载并执行
# -k  KSH 风格: 首次加载  执行 hello() 函数
# -z  ZSH 风格: 首次加载不执行 hello() 函数
# hello() { autoload -X; } 效果类似于 autoload -Uk hello
function @zeta:-load-plugins() {
  local name
  for name in "${ZETA_PLUGINS[@]}"; do
    [[ ${name} == lazy ]] && continue
    if [[ -f "${ZETA_DIR}/zsh/plugins/${name}/main.zsh" ]]; then
      autoload -Uz "${ZETA_DIR}/zsh/plugins/${name}/main.zsh"
    fi
  done
}

@zeta:-load-plugins
unset -f @zeta:-load-plugins
