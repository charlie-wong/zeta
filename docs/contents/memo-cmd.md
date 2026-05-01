# 命令备忘

```bash
cat /etc/shells
chsh -s /bin/zsh
chsh --shell /usr/bin/zsh
cat /etc/passwd | grep ${USER}

printenv # 显示环境变量
manpath  # 显示 man 命令搜索路径
man --where ls # 显示 ls 命令手册文件
mokutil --sb-state # 查看 Secure Boot 状态

# -i,--ip-address  -I,--all-ip-addresses
hostname --ip-address
ip addr # 显示主机 IP 地址信息

sudo su         # 切 root 用户
uname -r        # 查看内核版本
lsb_release -a  # 查看 OS 版本
lscpu           # 查看 CPU 信息
hostnamectl     # 系统/内核/硬件

umask    # 显示权限掩码(数字版) 022
umask -S # 显示权限掩码(字符版) u=rwx,g=rx,o=rx

uname | tr '[:upper:]' '[:lower:]' # 全部大写转小写
uname | tr '[:lower:]' '[:upper:]' # 全部小写转大写

mimetype cat.jpg # MimeType 类型(.desktop 文件)

# GBK 编码 => UTF-8 编码
iconv -f GBK -t UTF-8 输入文件 -o 输出文件
```

## apt

```bash
apt --dry-run autoremove  # 试执行
apt depends linux-generic # 内核包依赖
apt-get --print-uris update # 显示软件包下载的 URI

apt search ^gcc-[0-9][0-9]$ # 正则形式的软件包名称
apt search ^linux-generic # 搜索软件包：指定开头前缀

# 显示已安装内核软件包
apt list --installed 'linux-*'
apt list --installed '*-hwe-*'
apt list --installed 'linux-generic-*'

hwe-support-status # 查看 HWE 状态
# HWE(Hardware Enablement) 内核元包
apt policy linux-generic-hwe-24.04
apt depends linux-generic-hwe-24.04

dpkg --list | grep linux-
dpkg --print-architecture
dpkg --list | grep -Ei 'linux-generic|linux-image|linux-headers|linux-modules'
dpkg -l | grep '^rc' # 显示卸载软件包后仍残留的配置文件
dpkg -l | grep '^rc' | awk '{print $2}' | sudo xargs dpkg --purge
```

## pacman

```bash

```

## 系统管理

```bash
ls -l /boot/
ls -l /usr/src/
ls -l /lib/modules

 # 显示内核启动参数
cat /proc/cmdline
sudo dmesg | grep 'command line'

# https://wiki.archlinux.org.cn/title/Systemd/Journal
journalctl -b             # 当前启动日志
journalctl -b -0          # 本次启动日志
journalctl -b -1          # 上次启动日志
journalctl --list-boots   # 列出日志编号

sudo dmesg -b -p3   # 显示系统启动日志
sudo dmesg | grep -iE "error|fail|warn" | head -20

# 显示动态内核模块列表
dkms status

ls -l /dev/disk # 查看磁盘设备文件
```
