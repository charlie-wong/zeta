# APT

- <https://canonical-ubuntu-packaging-guide.readthedocs-hosted.com/en/latest/explanation/archive>

- <https://salsa.debian.org/apt-team/apt>
- <https://salsa.debian.org/apt-team/aptitude>
- <https://manpages.debian.org/buster/apt/sources.list.5.en.html>

- <https://wiki.debian.org/SecureApt>
- <https://wiki.debian.org/SourcesList>
- <https://wiki.debian.org/AptConfiguration>
- <https://wiki.debian.org/DebianRepository> 源的组织格式及结构

# Ubuntu 官方签名密钥

- `.gpg` 二进制公钥文件， `.asc` ASCII armored 公钥文件
  ```bash
  gpg --show-key path/to/key.gpg # 查看密钥信息
  cat key.asc | gpg --dearmor -vo key.gpg # 转换成二进制格式密钥
  ```

- 签名包 `apt-file list ubuntu-keyring`
  - `/etc/apt/trusted.gpg.d/ubuntu-keyring-*.gpg`
  - `/usr/share/keyrings/ubuntu-archive-*.gpg`
  - `/usr/share/keyrings/ubuntu-cloudimage-*.gpg`
  - `/usr/share/keyrings/ubuntu-master-keyring.gpg`

- Pro 工具 `apt-file list ubuntu-pro-client | grep .gpg$`
  - `/usr/share/keyrings/ubuntu-pro-*.gpg`

- 签名公钥位置
  - <https://askubuntu.com/questions/1437207>
  - <https://stackoverflow.com/questions/68992799>
  - `man apt-key` 和 `man apt-secure`
  - **NOTE** 按照 x.dep 软件包时其中可能包含如何保存其更新源和签名公钥的规则
  - `man 5 source.list` 的建议 `/etc/apt/keyrings/*.gpg`  系统管理员 **手动** 管理的公钥
  - `man 5 source.list` 的建议 `/usr/share/keyrings/*gpg` 包管理工具 **自动** 管理的公钥

# APT 配置文件

- 已弃用 ~~`/etc/apt/apt.conf`~~
- `/etc/apt/apt.conf.d/*`
  - APT drop-in 配置, 按字母表顺序生效
- `/etc/apt/preferences.d/*`
  - 偏好设置, 按字母表顺序生效(文件名任意)

- `/etc/apt/auth.conf.d/*`
  - 登陆配置文件

- 已弃用 ~~`/etc/apt/sources.list`~~
  - **CodeName**-`{updates, security, proposed, backports}`
  - 软件包的类型分组 `main, universe, restricted, multiverse`
  - `apt install --target-release 代码名-backports 软件包`

- `/etc/apt/sources.list.d/*` 软件源配置文件 [CodeName](https://wiki.ubuntu.com/Releases)
  - `/etc/apt/sources.list.d/ubuntu.sources` Ubuntu 默认源(取代 `/etc/apt/sources.list`)

- 已弃用 ~~`/etc/apt/trusted.gpg`~~
- **手动管理** 的软件包签名 GnuPG 公钥
  - `/etc/apt/keyrings/x.gpg` 关联 `/etc/apt/sources.list.d/x.sources`
- **自动管理** 的软件包签名 GnuPG 公钥
  - `/usr/share/keyrings/x.gpg` 关联 `/etc/apt/sources.list.d/x.sources`
  - `/etc/apt/trusted.gpg.d/x.gpg` 关联 `/etc/apt/sources.list.d/x.list`

- [查看指定源软件包的签名密钥](https://unix.stackexchange.com/questions/653279)
  - `file /var/lib/apt/lists/deb.xanmod.org_dists_releases_InRelease` 签名信息
  - `gpgv /var/lib/apt/lists/deb.xanmod.org_dists_releases_InRelease` 查看签名
  - `gpg --no-default-keyring --show-keys path/to/x.gpg` 查看 GnuPG 公钥信息
  ```bash
  for key in /usr/share/keyrings/*.gpg; do
    # -k,--list-public-keys; --with-subkey-fingerprint
    echo ${key}; gpg --no-default-keyring --show-keys ${key};
  done # -v,--verbose; -o,--output
  ```
