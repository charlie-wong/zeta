#!/usr/bin/env bash

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径

# [系统设置] -> [地域设置] -> [输入法] -> [Pinyin] - [Punctuation]
sudo cp "${THIS_DIR}/fcitx5.punc" /usr/share/fcitx5/punctuation/punc.mb.zh_CN
exit

############
### NOTE ###
############
# https://github.com/fcitx
# Fcitx5 基本分三部内容: 主程序, 语言引擎(IM), 图形化配置程序,
# KDE 系统设置界面/设置输入法 => 添加 pinyin 后即可生效
apt depends fcitx5
apt list --installed | grep fcitx5

sudo apt install fcitx5 # 输入法核心程序包
sudo apt install kde-config-fcitx5 # KDE 桌面集成
sudo apt install fcitx5-chinese-addons # 中文模块
