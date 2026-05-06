# Zeta

- 全局变量均以 **ZETA_** 或 **_ZETA_** 为前缀
- 函数名前缀 **@zeta:**，非命令行函数
- 函数名前缀 **@zeta:-**，文件内部函数

## 环境变量

```bash
export ZETA_DIR=
export ZETA_XCOMPARE=

ZETA_PLUGINS=
ZETA_GOTO_MAPS=
ZETA_STARTUP_LOG=

_ZETA_HOST_CPU_ID=
_ZETA_HOST_SYSTEM=
_ZETA_HOST_OS_ENV=

HISTFILE=         # 命令历史
ZSH_COMPDUMP=     # 补全缓存

# 软件包环境变量
NODE_PATH=        # NodeJS 包安装位置
GOROOT=           # Go 安装位置
GOPATH=           # Go 模块安装位置
GOPROXY=          # Go 模块下载地址
CARGO_HOME=       # Cargo 包安装位置
GEM_HOME=         # Ruby Gems 包安装位置
JAVA_HOME=        # Java 安装位置

# 系统环境变量
OSTYPE=
MACHTYPE=
HOSTTYPE=
HOSTNAME=
export GPG_TTY=
export VISUAL=
export EDITOR=
export GIT_EDITOR=
export LANG=
export LANGUAGE=
export PAGER=
export GIT_PAGER=
```

## Shell 函数

```bash
zeta-switch     # 软件(vendor)版本切换

xcmd ...        # 执行 zsh/bin 目录脚本文件
zman ...        # 追加搜索 vendor 软件的手册
extract

ls-dot-files    # 显示隐藏文件
ls-gpg-keys     # 显示 GGP 密钥
ls-path         # 列表显示 PATH 内容

find-file-regex # 搜索当前目录下文件
find-dirs-regex # 搜索当前目录下目录

ls-x509-crt
ls-x509-csr
ls-x509-crl
ls-x509-skid-rsa
ls-x509-skid-ed25519
ls-x509-https-cert-chain

path-head-add
desktop-alert-when-done

host-triplet # 显示 host 三元组
zeta-color-preview # 终端颜色示例
```

## 命令别名

```bash
a
b
c # clean
d # dirs -v
e
f
g
h
i
j # jobs -l
k
l
m
n
o
p
q
r
s
t
u
v
w
x
y
z

now # 函数 timestamp-iso-8601-now

ls-etc-passwd
ls-disk-layout
ls-alt-selections
ls-disk-block-size
```

# 参考链接

- man 搜索路径 <https://modules.readthedocs.io/en/stable/cookbook/man-path.html>
- man 默认搜索路径 <https://www.man7.org/linux/man-pages/man5/manpath.5.html>

- <https://gitlab.com/ft/etc-zsh>
- <https://wiki.archlinux.org/title/Zsh>
- <https://grml.org/zsh/zsh-lovers.html>
- <https://wiki.archlinux.org/title/Command-line_shell>

- <https://dotfiles.github.io>
- <https://wiki.archlinux.org/title/Dotfiles>
- <https://github.com/webpro/awesome-dotfiles>
- <https://github.com/ibraheemdev/modern-unix>
- <https://github.com/durgeshsamariya/awesome-github-profile-readme-templates>
