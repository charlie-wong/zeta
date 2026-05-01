# Bash

- 自动补全 <https://github.com/scop/bash-completion>
- 源码仓库 <https://cgit.git.savannah.gnu.org/cgit/bash.git/>

```bash
# Shell 脚本 HERE 文档
cat << EOF >> output.file
# The output file contents
EOF

# 正则比较: 变量 =~ 正则常量(必须右侧)
[[ "${OSTYPE}" =~ ^linux  ]]
[[ "${OSTYPE}" =~ ^darwin ]]
[[ "$VAR" =~ ^[0-9]*([0-9])$ ]]
```

## Builtin

```bash
test      # 简写形式 [ ]
command   # 调用外部命令(忽略函数/别名及 builtin 命令)
```

## 特性选项

```bash
shopt -s extglob # <启用>选项
shopt -u extglob # <禁用>选项
shopt extglob | cut -f2 # 状态查看

if shopt -q login_shell; then
  function is-login-shell() { true; }
else
  function is-login-shell() { false; }
fi
```

## 变量扩展

```bash
# 非双引号内则效果相同，位于双引号内时
# @ 扩展结果是由参数项 item 构成的 word 列表
# * 扩展结果为 signle word 用 IFS 分割参数项
$@; $* # 函数参数

declare -a iARR
${#iARR} # 数组长度，即数组项的个数
iARR=('aa' 'bb' 'cc') # 索引数组，起始索引 0
declare -A aARR
aARR=('key1' 'val1'  'key2' 'val2')
echo "${aARR['key1']}"

# 非双引号内则效果相同，位于双引号内时
# @ 扩展结果是由数组 item 构成的 word 列表
# * 扩展结果为 signle word 用 IFS 分割数组项
${iARR[@]}; ${iARR[*]}

${VAR@u}  # 小写 -> 大写(仅首字母)
${VAR@U}  # 小写 -> 大写(全部)(Uppercase)
${VAR@L}  # 小写 <- 大写(全部)(Lowercase)

# NOTE 普通变量属性字符串为空
# -n 属性表示变量使用时自动间接引用
# -l 属性表示变量赋值时自动将 大写 -> 小写, 即变量值始终<小写>
# -u 属性表示变量赋值时自动将 大写 <- 小写, 即变量值始终<大写>
${VAR@a}  # 变量属性: i=整数 a=索引数组 A=关联数组
```

## 特殊变量

```bash
readlink /proc/$$/exe # $$ 当前进程的 PID

# 关于 Bash 的 $0 变量
# https://unix.stackexchange.com/questions/144514
#   /bin/bash -c 'echo "[$0] [$1]"' foo bar xyz
#   /bin/bash -c 'echo "[$0] [$@]"' foo bar xyz
THIS_DIR="$(dirname "${BASH_SOURCE[0]}")" # 被 source 脚本内

# 直接执行脚本时则 $0 自动设置为脚本文件名(包括路径)
# 位于 Bash 脚本文件开头，直接执行脚本(非 source 执行)
THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径
```

## 重定向

```bash
# 0 = stdin, 1 = stdout, 2 = stderr
# >          POSIX 重定向 stdout
# >>         POSIX 重定向 stdout 追加式
# &>      非 POSIX 重定向 stdin 和 stdout，记忆 and greater than
# >& foo  非 POSIX 重定向 stdin 和 stdout 到 foo 文件，等同于 &>
# >&2        POSIX 重定向 stdout 到 stderr
# 2>&1       POSIX 重定向 stderr 到 stdout
script.sh > output.log 2> error.log
script.sh &> backup.log     # 适用 Bash/Zsh
script.sh > backup.log 2>&1 # POSIX (works for sh/dash)
# 首先 stderr 重定向到 stdout, 当前 stdout 绑定的是 terminal
# 然后 stdout 重定向到文件 output.txt
# 结果: 仅 stdout 保存到文件，stderr 显示在终端
ls file.txt non-existent-file 2>&1 > output.txt
# 首先 stdout 重定向到文件 output.txt
# 然后 stderr 重定向到 stdout，当前 stdout 绑定的是 output.txt 文件
# 结果：stdout 和 stderr 同时保存到 output.txt 文件
ls file.txt non-existent-file > output.txt 2>&1

# 关于 sudo Permission denied 的问题
# 解决方式一: 执行 sudo -i 获取 root 权限
# 解决方式二: echo XYZ | sudo tee /some/file
# 解决方式三: sudo bash -c "echo 'XYZ' > /some/file"
# 重定向由 Shell 执行(非 echo 命令), sudo 仅作用于 echo 命令
sudo echo 'XYZ' > /some/file
```

## 脚本调试

```bash
function is-zsh()  { [[ -n "${ZSH_VERSION:-}"  ]]; }
function is-bash() { [[ -n "${BASH_VERSION:-}" ]]; }

# https://git.savannah.gnu.org/cgit/bash.git/refs/tags
# https://git.savannah.gnu.org/cgit/bash.git/tree/CHANGES
(( BASH_VERSINFO[0] < 5 ))

# 调试定位信息
echo "${LINENO}: BS=[${BASH_SOURCE[@]}] \$0=[$0] \$@=[$@]"
echo "${LINENO}: PID=$$, UID=${UID}, GID=${GID}, PWD=${PWD}"
```
