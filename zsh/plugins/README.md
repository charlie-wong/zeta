# Zsh Plugin

- <https://github.com/jeffreytse/zsh-vi-mode>
- <https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html>

```zsh
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

source "${0:h}/main.zsh"

# 语法解释
ZSH_ARGZERO=      # Zsh 预定义
${name:h}         # 14.1.4 Modifiers
${name:-word}     # 14.3 Parameter Expansion
${name:#pattern}  # 14.3 Parameter Expansion
${(%):-%N}        # 14.3.1 Parameter Expansion Flags
```
