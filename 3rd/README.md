# FAQs + Memo

- 首次执行 `sudo` 后创建 `~/.sudo_as_admin_successful` 文件, `man sudo_root`

```bash
# GBK 编码 => UTF-8 编码
iconv -f GBK -t UTF-8 输入文件 -o 输出文件

# Shell 脚本 HERE 文档
cat << EOF >> output.file
# The output file contents
EOF

# 关于 sudo Permission denied 的问题
# 解决方式一: 执行 sudo -i 获取 root 权限
# 解决方式二: echo XYZ | sudo tee /some/file
# 解决方式三: sudo bash -c "echo XYZ > /some/file"
# NOTE 重定向由 shell 执行, 非 echo 命令, sudo 仅作用于 echo 命令
sudo echo XYZ > /some/file
```

## Favor Tools

```bash
# apt search   ^gcc-[0-9][0-9]$
# apt search ^clang-[0-9][0-9]$
sudo apt install  gcc  clang  git
sudo apt install  build-essential

# APT 包文件搜索/显示工具
sudo apt install apt-file
sudo apt-file update # 更新缓存

# 默认 shell 切换到 Zsh
IS_DEFAULT_ZSH="$(cat /etc/passwd | grep ${USER} | grep zsh)"
if [[ -z "${IS_DEFAULT_ZSH}" ]]; then
  sudo apt install zsh; chsh --shell /usr/bin/zsh
fi

sudo apt install curl wget
sudo apt install bcompare # kompare
sudo apt install 7zip 7zip-rar
sudo apt install microsoft-edge-stable
```
