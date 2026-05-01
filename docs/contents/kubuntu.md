# 安装 KUbuntu 24.04.4

- Ventoy 最小化安装 kubuntu-desktop-24.04.4-lts
- <http://help.ubuntu.com/community/UpgradeNotes>
- 调整 grub
- 调整 fstab
- 调整 hosts
- 调整 journald
- 调整 updatedb
- 调整 apt
- 调整 fcitx5
- SWAP 分区的使用频率
- 工具链 build-essential
- 系统软件更新及安装(切换SH)
- 内核及显卡驱动
- 更纱黑体及桌面调整

## 内核更新及清理

- <https://xanmod.org>
- <https://www.kernel.org>

- <https://wiki.archlinux.org/title/Microcode>
  *  Arch  包名 `intel-ucode` 和 `amd-ucode`
  * Ubuntu 包名 `intel-microcode` 和 `amd64-microcode`

- `linux-firmware` 内核驱动固件(商业/非开源设备驱动固件)
  - <https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git>

```bash
# https://ubuntu.com/kernel/lifecycle
# GA(General Availability) 常见通用内核
sudo apt install linux-generic

# 更新 HWE(Hardware Enablement) 内核和头文件
sudo apt-get install --install-recommends linux-generic-hwe-24.04
# 禁用 HWE(Hardware Enablement) 功能
sudo apt remove linux-{image,headers}-generic-hwe-'*'

# 搜索 XanMod 内核 v6.1.x 版本软件包
apt search "linux-image-6\\.12\\..*-x64v3-xanmod1"
# 构建内核模块所需依赖包
sudo apt install --no-install-recommends dkms libdw-dev clang lld llvm
# 安装 XanMod 内核元包
sudo apt install linux-xanmod-lts-x64v3
# 安装 XanMod 固定版本内核
sudo apt install linux-{image,headers}-内核版本-x64v3-xanmod1

# 清理冗余内核
sudo apt remove linux-image-内核版本 linux-headers-内核版本
sudo apt remove linux-{image,headers}-内核版本-x64v3-xanmod1
sudo update-grub # 内核变更后由 hook 自动执行
```

## 英伟达显卡(GeForce RTX 3060 Laptop GPU)

- <https://www.techpowerup.com/vgabios>
- <https://wiki.archlinux.org/title/GPGPU>
- <https://wiki.archlinux.org/title/NVIDIA>

- <https://wiki.archlinux.org/title/OpenGL>
- <https://wiki.archlinuxcn.org/wiki/Vulkan>

- <https://www.nvidia.com/en-us/technologies>
- <https://nouveau.freedesktop.org/CodeNames.html>

- <https://www.nvidia.com/en-us/drivers/unix>
- <https://docs.nvidia.com/datacenter/tesla/index.html>

- <https://github.com/NVIDIA/debian-packaging-nvidia-driver>
- <https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa>

- <https://endoflife.date/nvidia>
- <https://endoflife.date/nvidia-gpu>
- <https://docs.nvidia.com/datacenter/tesla/drivers/driver-lifecycle.html>

- <https://docs.nvidia.com/datacenter/tesla/driver-installation-guide>
- <https://ubuntu.com/server/docs/how-to/graphics/install-nvidia-drivers>
- <https://documentation.ubuntu.com/project/how-ubuntu-is-made/concepts/version-strings>

```bash
### NOTE ###
# https://wiki.archlinux.org/title/Hybrid_graphics
# https://wiki.archlinux.org/title/NVIDIA/Troubleshooting
# BIOS/UEFI    独显模式(Discrete Graphic)   NVIDIA
# -> 独显直接驱动显示器(集显通常不参与图形信号的输出)
# BIOS/UEFI    混合模式(Hybrid Graphics)    Intel + NVIDIA
# -> 显示器信号通常由集显输出(独显处理完图形后交由集显转发)
#
# => 推荐在 BIOS/UEFI 中设置为 NVIDIA 独显模式
# 故障原因排查(无法正常启动时) /var/log/...
# 双显卡(混合模式)的 NVIDIA PRIME 解决方案技术不成熟
### NOTE ###

xrandr # 查看屏幕可用分辨率
xrandr | grep '*' # 查看当前分辨率
switcherooctl list # 显卡名称及环境变量
xdpyinfo | grep 'dimensions:' # 查看当前分辨率
# GLX(OpenGL Extension to the X Window System)
# 用于 X11 创建和管理 OpenGL 渲染上下文的接口
glxinfo | grep OpenGL

# 查看显卡硬件及当前驱动信息
# GeForce RTX 3060 Mobile / Max-Q
lspci -nn | grep VGA # 显示系统所有显卡的简要信息
lspci -k  | grep VGA -A3 # 显示系统所有显卡的简要信息
lspci -vvv -s 01:00.0 # 查看 BUS 接口 01:00.0 上的显卡信息

# 显示显卡详细信息(Capabilities ...)
sudo lshw -numeric -C display
lspci -vv | grep GA106M -A15
lspci -vv | grep GA106M -A86

apt list --installed '*nvidia*'
lsmod | grep nouveau  # xorg 开源驱动
lsmod | grep nvidia   # 英伟达显卡驱动
ubuntu-drivers list     # 显示可用驱动列表
ubuntu-drivers devices  # 显示可用驱动列表

sudo apt install nvidia-driver-580-open
sudo apt install xserver-xorg-video-nouveau

# prime-select 双显卡(混合模式)调度管理机制
prime-select query # 查看显卡当前工作模式
sudo prime-select on-demand  # 按需自动选择
sudo prime-select intel  # 选择 Intel  显卡
sudo prime-select nvidia # 选择 Nvidia 显卡
sudo nvidia-settings # 英伟达显卡图形设置面板

man modprobe.d        # 内核模块加载设置
modinfo nvidia        # nvidia.ko 驱动信息
modprobe nvidia       # 内核模块的添加或删除
modinfo nvidia | grep license   # NVIDIA 开源驱动显示 open
cat /proc/driver/nvidia/version # 驱动版本/编译时间及 GCC 版本
cat /proc/driver/nvidia/params | sort # 显示 nvidia 驱动参数

# 查看 NVIDIA 显卡型号及 GPU-UUID
nvidia-debugdump --list
nvidia-smi # 查看显卡驱动状态
nvidia-xconfig --query-gpu-info
nvidia-smi -q -d TEMPERATURE # 显卡主板温度
nvidia-settings -q gpucoretemp # 显卡主板温度
nvidia-smi --query-gpu=gpu_name,vbios_version --format=csv
# 显示 NVIDIA GeForce RTX 3060 Laptop GPU, 94.06.34.00.42

# MOK(Machine Owner Key)
ls -l /var/lib/shim-signed/mok
# 新装内核触发 MOK 签名 NVIDIA 内核模块
ls -l /etc/kernel/header_postinst.d
# MOK 签名的内核模块
ls -l /var/lib/dkms/nvidia
ls -l /lib/modules/$(uname -r)/kernel
ls -l /lib/modules/$(uname -r)/updates/dkms

# 内核及驱动源码
ls -l /usr/src
# 显卡内核模块参数
grep nvidia /etc/modprobe.d/* /lib/modprobe.d/*
# 安全启动 + 英伟达显卡
# Step 1 - Enabled Secure Boot in UEFI/BIOS
# Step 2 - Sign Nvidia GPU Driver by reconfigure driver package
cat /etc/default/linux-modules-nvidia
```

## 锁定稳定 Kernel + Nvidia 版本

```bash
sudo apt-mark hold linux-generic-hwe-24.04  # 虚拟 stub 软件包
sudo apt-mark hold nvidia-driver-580-open   # 虚拟 stub 软件包
# 锁定后 sudo apt upgrade 不会再升级更新 kernel 和 nvidia 软件包
apt-mark showhold
sudo apt-mark unhold linux-generic-hwe-24.04 # 解锁后恢复可更新状态
```

## 常用应用软件

```bash
sudo apt install bcompare
sudo apt install libreoffice
sudo apt install microsoft-edge-stable
sudo apt install gcc clang git curl wget 7zip

sudo apt install build-essential                    # 构建 deb 必备
sudo apt install apt-file                           # 搜索 APT 包内容
sudo apt install kcachegrind                        # 性能数据可视化前端
sudo apt install ghostwriter                        # Markdown 文本编辑器(无法启动)

sudo apt install gdisk                              # GPT 工具
sudo apt install partitionmanager                   # 分区管理
sudo apt install kgpg                               # 管理/查看 GnuPG 密钥
sudo apt install kleopatra                          # 证书管理及加密服务前端

sudo apt install yakuake                            # 下拉式终端
sudo apt install ktimer                             # 倒计时启动器

sudo apt install okular                             # PDF 阅读器
sudo apt install elisa                              # 音乐播放器
sudo apt install haruna                             # 视频播放器

sudo apt install kdeconnect                         # 手机连接
sudo apt install ktorrent                           # BT 下载器
sudo apt install konversation                       # IRC客户端

# https://launchpad.net/~mozillateam/+archive/ubuntu/ppa
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update && sudo apt install thunderbird
sudo add-apt-repository --remove ppa:mozillateam/ppa
sudo apt remove --autoremove thunderbird
# https://www.thunderbird.net/en-US/thunderbird/releases
# https://support.mozilla.org/en-US/kb/installing-thunderbird-linux
# 下载 thunderbird-版本号.tar.xz
sudo mv thunderbird /opt # 解压/移动
sudo ln -s /opt/thunderbird/thunderbird /usr/bin/thunderbird
# https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop
sudo mv thunderbird.desktop /usr/share/applications

# https://gitlab.com/graphviz/graphviz/-/releases
# 下载安装 ubuntu_版本_graphviz-版本-cmake.deb
```

## Ubuntu Issue Workaround

- **Issue** 启动时 `gpu-manager.service` 耗时接近 2 分钟
  - <https://github.com/canonical/ubuntu-drivers-common/tree/master/share/hybrid>
  - ubuntu-drivers-common 包的 `gpu-manager` 命令卡顿执行很慢
  - `ls -lh /var/log/gpu-*`
  - `apt show ubuntu-drivers-common`
  - `apt-file search /usr/bin/gpu-manager`
  - 解决方式: 启动时禁用 /usr/bin/gpu-manager 命令
  ```bash
  sudo nano /etc/default/grub
       GRUB_CMDLINE_LINUX="nogpumanager"
  sudo update-grub
  reboot
  ```

- **Issue** 蓝牙 `profiles/sap/server.c:sap_server_register() Sap driver initialization failed.`
  - 分析 https://github.com/bluez/bluez/issues/441
  - 分析 https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=803265
  - 源码 https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/profiles/sap/server.c
  - 源码 https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/profiles/sap/sap-dummy.c
  - 解决方式: 添加 `--noplugin=sap` 参数禁用 SAP 蓝牙插件
    - `systemctl cat bluetooth` 定位 systemd unit 蓝牙文件
    - `ExecStart=/usr/libexec/bluetooth/bluetoothd --noplugin=sap`
    - 重新加载 `sudo systemctl daemon-reload`
    - 重启服务 `sudo systemctl restart bluetooth`
    - 服务状态 `systemctl status bluetooth`
    - 查看日志 `journalctl -b | grep bluetooth`

- **Issue** `ACPI BIOS Error (bug): Could not resolve symbol [\_TZ.ETMD], AE_NOT_FOUND`
- **Issue** `ACPI Error: Aborting method \_SB.IETM._OSC due to previous error (AE_NOT_FOUND)`
  - https://bugzilla.kernel.org/show_bug.cgi?id=218269
