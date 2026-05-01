# Bash/Zsh 差异

## 特性选项

- <https://www.baeldung.com/linux/bash-zsh-loop-splitting-globbing>
- 用 IFS 进行字符串分割：Bash 默认启用，Zsh 默认禁用 `shwordsplit`
- 如果 GLOB 匹配失败显示空：Bash 默认启用, Zsh 报告错误 `nullglob`

## 变量扩展

- 间接引用：Bash 语法 `${!VAR}`， Zsh 语法 `${(P)VAR}`
- 变量属性: Bash 语法 `${VAR@a}`，Zsh 语法 `${(t)VAR}`

## 数组

- 数组索引：Bash 从 0 开始，Zsh 从 1 开始

## 杂七杂八

- 版本号：`${ZSH_VERSION:-}` 和 `${BASH_VERSINFO[*]:-}`
- `return` Bash 只能用于函数及被 source 脚本，Zsh 可用于更广范围
