# Git

- <https://git-scm.com/install/linux>
- <https://launchpad.net/~git-core/+archive/ubuntu/ppa>

Git 用户默认配置目录 `~/.config/git`, 默认配置文件 `~/.gitconfig`

## 关于 Git 操作时所需的账户和密码

- <https://git-scm.com/docs/gitcredentials>

- Without any credential helpers defined, git will try following strategies
  - 默认优先级 GIT_ASKPASS > core.askPass > SSH_ASKPASS > prompt-on-terminal

- Specify an external helper to be called when a credential is needed
  - Find a helper     `git help -a | grep credential-`
  - Read description  `git help credential-foo`
  - Tell git use it   `git config --global credential.helper foo`

- <https://git-scm.com/doc/credential-helpers>
  - Ubuntu 推荐安装 KDE 的密钥管理器 KDE Wallet
    - <https://wiki.archlinux.org/title/KDE_Wallet>
    - <https://docs.kde.org/stable5/en/kwalletmanager/kwallet5/index.html>
  - Git Credential Manager(内置于 Windows 版 Git)
    - 在首次发送邮件时要求输入账户密码(加密保存在系统)
    - <https://github.com/git-ecosystem/git-credential-manager>
    - <https://github.com/Microsoft/Git-Credential-Manager-for-Windows>
    - WIN11: 控制面板->用户帐户->凭据管理器->Windows凭证->普通凭证 git:smtp://...
