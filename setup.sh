#!/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2023 Charles Wong <charlie-wong@outlook.com>
# Repository: https://github.com/charlie-wong/zeta

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径
# printf "[${THIS_AFP}]\n[${THIS_DIR}] [${THIS_FNO}]\n"; exit

# ${0%/*}  仅删除 $0 结尾文件名(匹配最短)
# ${0##*/} 仅保留 $0 结尾文件名(匹配最长)

cp "${THIS_DIR}/zsh/extra/startup/1shenv"  "${HOME}/.zshenv"

cat > "${HOME}/.zshrc" <<EOF
###### 命令历史 ######
HISTFILE="${HOME}/.zsh-history"
HISTSIZE=3000 # 终端会话最多可保留历史命令行数
SAVEHIST=6000 # 历史命令 HISTFILE 最大保留行数

###### 自动补全 ######
# 命令补全 completion dump 缓存文件的保存位置
ZSH_COMPDUMP="${HOME}/.zsh-compdump"

###### 配置Zeta ######
# ZETA_STARTUP_LOG=OFF  # 保存 ZSH 启动日志(分析性能)
# ZETA_PLUGINS=()       # 激活 zsh/plugins/* 插件列表

###### 加载Zeta ######
[[ -f "${THIS_DIR}/zeta.zsh" ]] && source "${THIS_DIR}/zeta.zsh"

###### 主题风格 ######
if true; then
  # 自带集成主题 /usr/share/zsh/functions/Prompts
  autoload -Uz promptinit; promptinit; prompt adam1
fi

###### 用户配置 ######
[[ -f "/home/${USER}/.${USER}" ]] && source "/home/${USER}/.${USER}"
EOF
