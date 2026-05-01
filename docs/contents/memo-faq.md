# FAQ 备忘录

## systemd

- 系统服务 `.service`, 挂载位置 `.mount`, 设备文件 `.device`, 网络通信 `.socket`

```bash
# NOTE UMask 对于 systemd 的 .scope 无效，其仅对 .service 有效
# NOTE 若 drop-in 文件所在位置对应的 systemd 文件为符号连接则 drop-in 无效
# NOTE ~/.config/systemd/user/服务单元.d/...

systemctl --version # systemd 版本号
# 查看系统的<显示管理器>，KDE 默认 SDDM
systemctl status display-manager.service

# 系统启动耗时
systemd-analyze
systemd-analyze blame | head

systemctl --system status 单元  # 系统服务单元
systemctl          status 单元  # 隐藏参数 --system
systemctl --user   status 单元  # 用户服务单元

systemctl daemon-reload
systemctl list-units            # 显示 active 单元
systemctl list-units --all      # 显示所有单元
systemctl list-unit-files       # 显示单元文件及其状态

systemctl show        单元
systemctl cat         单元

systemctl reload      单元
systemctl restart     单元
systemctl start       单元
systemctl stop        单元

systemctl disable     单元
systemctl enable      单元
systemctl mask        单元
systemctl unmask      单元
systemctl is-enabled  单元

systemctl edit        单元  # 创建 drop-in
systemctl edit --full 单元  # 编辑单元文件

systemd-cgls | grep dolphin
systemctl --user --property=UMask show app-org.kde.dolphin
```

- 设置 `umask` Kubuntu 24.04(Plasma 5.27.12) 桌面环境生效
  - 文件默认权限‌: 666 (`rw-rw-rw-`)
  - 目录默认权限‌：777 (`rwxrwxrwx`)
  - umask 掩码值‌: 022 要‌屏蔽的权限
  - 无效 <https://wiki.archlinux.org/title/Umask>
  - 无效 <https://superuser.com/questions/1795551/change-default-umask-for-kde>

  ```bash
  # .bashrc 或 .zshrc 中的 umask 仅对文本终端有效(桌面 GUI 无效)
  # touch foo  权限 666 - 022 = 644, mkdir bar  权限 777 - 022 = 755

  # 显示指定用户运行的服务或程序所使用的 umask 的值
  # NOTE -I % 中的 % 表示占位符，读取标准输入(分隔符默认换行符)用其中的每一项替换后续命令参数中的 %
  #      构建一系列命令，即依次执行 echo PID=进程号, $(grep "^Umask:" "/proc/进程号/status"), ...
  ps -u charlie -o pid= | xargs -I % sh -c 'echo PID=%, $(grep "^Umask:" "/proc/%/status"), Process=$(ps -w -p % -o cmd=)'
  ```

## Rust

```bash
# Rust 目标三元组(target triple) `<arch><sub>-<vendor>-<sys>-<env>`，与 LLVM 策略相同
rustc --print target-list # 列出 rust 支持的所有平台
rustc -vV # host 显示当前平台的目标三元组(target triple)
# x86_64-unknown-linux-gnu 表示 X86/64 位 Linux 系统 glibc 标准 C 库
```

- <https://doc.rust-lang.org/stable> stable, beta, nightly
- <https://forge.rust-lang.org/infra/channel-layout.html>
- <https://rust-lang.github.io/rustup/concepts/components.html>
- <https://forge.rust-lang.org/infra/other-installation-methods.html>

```bash
# rustc            编译器和文档工具
# rust-std         标准库(交叉编译)
# cargo            依赖管理及构建发布

# rust-src         rust 标准库源码
# rust-docs        rust 文档

# rustfmt          Rust 代码格式化工具
# clippy           风格及质量检测 Lint
# rust-analyzer    编辑器(IDE)语法解析
```

## 杂七杂八

- 首次执行 `sudo` 后创建 `~/.sudo_as_admin_successful` 文件, 参考 `man sudo_root`

- Ubuntu 快捷键

| 按键 | TTY |
|------|-----|
| Ctrl + Alt + F1   | KDE 图像桌面 /dev/tty1   |
| Ctrl + Alt + F2~6 | /dev/tty2, ... /dev/tty6 |

- 抓取网站内容

  ```bash
  # --mirror 开启镜像模式，它会尝试下载站点上的所有内容
  # --convert-links 转换本地文件中的链接，使其指向本地文件
  # --adjust-extension 为每个下载的文件添加正确的扩展名
  # --page-requisites 下载显示 HTML 页面所需的所有组件，如图片、样式表和脚本
  # --no-parent 不向上追溯到父目录，用于避免下载整个互联网
  wget --mirror --convert-links --adjust-extension --page-requisites --no-parent http://example.com
  ```

- 校验/签名/加密

  ```bash
  shasum -a 256 文件名 # 显示文件 SHA256 校验码
  echo "SHA256校验码数据  文件名" | shasum -a 256 --check
  # 验证无误显示 => 文件名: OK

  gpg --detach-sign msg.txt # 分离式签名 msg.txt.asc
  gpg --verify 签名文件 原始文件 # 签名校验

  gpg --sign foo.txt # 压缩 foo.txt + 签名，结果 foo.txt.asc
  gpg --clear-sign foo.txt # NOTE 已经弃用，建议用分离式签名
  gpg -o foo1.txt foo.txt.asc               # 签名校验及信息还原
  gpg --verify -o foo2.txt foo.txt.asc      # 签名校验及信息还原
  gpg --out foo3.txt --decrypt foo.txt.asc  # 签名校验及信息还原
  ```

- SVG 字体 Base64 加密/解密

  ```bash
  base64    字体.woff2  > 字体.base64 # 将字体转换为 Base64 编码
  base64 -d 字体.base64 > 字体.woff2  # 还原二进制字体数据格式
  ```

  ```css
  /* ttf 格式 */
  @font-face {
    font-family: '字体名称';
    font-style: normal;
    font-weight: 400;
    font-display: fallback;
    src: url(data:font/truetype;base64,字体文本化数据 format('truetype');
  }

  /* woff2 格式 */
  @font-face {
    font-family: '字体名称';
    font-style: normal;
    font-weight: 400;
    font-display: fallback;
    src: url(data:font/woff2;base64,字体文本化数据 format('woff2');
  }
  ```

- GitHub Rest API

  - <https://docs.github.com/zh/rest/metrics/traffic>
  - 主页访问计数 <https://github.com/antonkomarev/github-profile-views-counter>
  - <https://komarev.com/ghpvc/?username=charlie-wong&color=orange&style=plastic&label=visitors>

    ```bash
    # GITHUB_TOKEN => 所有仓库/Administration权限
    curl --request GET \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      -H "X-GitHub-Api-Version: 2026-03-10" \
      -L https://api.github.com/repos/charlie-wong/charlie-wong/traffic/views
    ```

- 私有 IP 地址及 无类别域间路由 CIDR(Classless Inter Domain Routing)

  ```text
  CIDR 格式为：IP 地址/网络 ID 位数

  例如 IP 地址：202.194.20.138/19，表示地址 202.194.20.138 的前 19 位为网络前缀，后 13 位为主机号
                         vvvvv  vvvvvvvv   主机号
  11001010  11000010  00010100  10001010   202.194.20.138
  ^^^^^^^^  ^^^^^^^^  ^^^                  网络前缀

  IPv4 私有地址(4字节，32位)
  10.0.0.0/8     => 范围 10.0.0.0    ~ 10.255.255.255
  172.16.0.0/12  => 范围 172.16.0.0  ~ 172.31.255.255
  192.168.0.0/16 => 范围 192.168.0.0 ~ 192.168.255.255
  IPv6 私有地址(16字节, 128位)
  fc00::/7 => 1111 1100 0000 0000 ....
  +--------+-+------------+-----------+----------------------------+
  | 7 bits |1|  40 bits   |  16 bits  |          64 bits           |
  +--------+-+------------+-----------+----------------------------+
  | Prefix |L| Global ID  | Subnet ID |        Interface ID        |
  +--------+-+------------+-----------+----------------------------+
  ```

- TTY/终端

  - TTY (TeleTYpewrite) 电传打字电报机
  - `tty` is a regular terminal device
  - `pty` is a pseudo terminal, master device, `man pty`
  - `pts` is a pseudo terminal, slave  device, `man pts`

  - <https://www.tecmint.com/linux-tty-tty0-and-console>
  - <https://thevaluable.dev/guide-terminal-shell-console>
    /dev/tty[N] are virtual consoles that you can switch to from main terminal
    if you are running in a GUI system, where N represents the TTY number. By default,
    /dev/tty0 is the default virtual console. tty1 through tty63 are virtual terminals,
    alternatively known as VTs or Virtual Consoles.

  - <https://askubuntu.com/questions/902998>
  - <https://unix.stackexchange.com/questions/734242>
    `zsh -c 'echo $TTY'`, ZSH/Bash 均可用命令 `tty`, `who`, `who am i`
