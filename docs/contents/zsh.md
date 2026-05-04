# Z-Shell

- 镜像仓库 <https://github.com/zsh-users/zsh>

```zsh
# 打开选项 set -o OptName  关闭选项 set +o    OptName
# 启用选项 setopt OptName  禁用选项 unsetopt  OptName

# 自带集成主题 /usr/share/zsh/functions/Prompts
prompt -l       # 列出可用主题列表
prompt -p       # 预览主题样式
prompt walters  # 使用 walters 主题

declare -p VAR # 定义状态
declare -g VAR # 全局变量 scalar
declare -i VAR # 数值变量 integer
declare -a VAR # 索引数组 array
declare -A VAR # 关联数组 association

eval "echo ok" # 表达求值

${VAR:l} # 变量内容全部大写转小写(lowercase)
${VAR:u} # 变量内容全部小写转大写(uppercase)

# Zsh 命令 `declare` 等同于 `typeset`, 兼容 Bash
# for x in "$*"; do echo $x; done 仅循环迭代一次

${(t)VAR} # 变量属性

local OPTERR  OPTARG  OPTIND=1  opt
while getopts 'aAilnrtuxZ' opt "-${attrs}"; do
  # 参见 Zsh 手册 14.3.1 节
  # keywords separated by hyphens(-)
  # 函数属性 function 别名属性 alias
  case "${opt}" in
    a) vtype='array'        ;;
    A) vtype='association'  ;;
    i) vtype='integer'      ;;
    l) vtype='lower'        ;;
    n) vtype='reference'    ;;
    r) vtype='readonly'     ;;
    t) vtype='trace'        ;;
    u) vtype='upper'        ;;
    x) vtype='export'       ;;
    Z) vtype='scalar'       ;;
  esac
done
```
