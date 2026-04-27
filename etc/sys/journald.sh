#!/usr/bin/env bash

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径

sudo cp "${THIS_DIR}/journald.conf" /etc/systemd/journald.conf
exit

############
### NOTE ###
############

man journald.conf # 配置文件语法
journalctl --disk-usage # 日志占有存储空间大小
journalctl -b -u systemd-journald # 查看日志存储空间状态
systemd-analyze cat-config systemd/journald.conf # 显示配置

# NOTE Journal 文件必须已被轮换并变为非活动状态，然后才能被 vacuum 命令修剪
journalctl --rotate
# 删除归档的 Journal 文件，直到它们占用的磁盘空间低于 100M
journalctl --vacuum-size=100M
# 删除归档的 Journal 文件中早于 2 周前之前的日志
journalctl --vacuum-time=2weeks

# SystemMaxUse=  表示日志存储空间为文件系统所在分区大小的 10%，但上限为 4 GiB
# RuntimeMaxUse= 表示运行时日志存储空间 -> 所在分区大小的 10%，但上限为 4 GiB
