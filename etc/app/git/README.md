# Personal Git Setup

Git 用户默认配置目录 `~/.config/git`, 默认配置文件 `~/.gitconfig`

`git init --template path/to/foo` 会将 foo 目录下的非<点>开头的文件拷贝复制到新建仓库的 .git 目录，
若需要将文件拷贝至 worktree 则做如下配置即可：
1. 创建一个新仓库 bar
2. 添加一些模板文件: worktree 或 .git/hooks
3. 执行 `git add .; git commit -m 'init commit'`
4. 将仓库的 bar/.git 目录作为模板使用即可(利用拷贝至新建仓库的 .git 目录特性)
5. `git init --template path/to/bar/.git && git reset --hard`


- The latest upstream stable git version Ubuntu PPA
  - <https://git-scm.com/download/linux>
  - <https://launchpad.net/~git-core/+archive/ubuntu/ppa>
  - `sudo add-apt-repository ppa:git-core/ppa; sudo apt update`

- 关于 Git 操作时所需的账户和密码
  - <https://git-scm.com/docs/gitcredentials>
  - 进行 GPG 签名操作时: commit, tag, push
  - 提交到远程仓库时: http:// 或 https:// 或 ssh:// 或 git@
  - Without any credential helpers defined, git will try following strategies
    - 默认优先级 GIT_ASKPASS > core.askPass > SSH_ASKPASS > prompt-on-terminal
  - Specify an external helper to be called when a credential is needed
    - Find a helper     `git help -a | grep credential-`
    - Read description  `git help credential-foo`
    - Tell git use it   `git config --global credential.helper foo`
  - 主要平台可用的软件列表
    - <https://git-scm.com/doc/credential-helpers>
    - Ubuntu 推荐安装 KDE 的密钥管理器 KDE Wallet
      - <https://wiki.archlinux.org/title/KDE_Wallet>
      - <https://docs.kde.org/stable5/en/kwalletmanager/kwallet5/index.html>
    - Git Credential Manager(内置于 Windows 版 Git)
      - 在首次发送邮件时要求输入账户密码(加密保存在系统)
      - <https://github.com/git-ecosystem/git-credential-manager>
      - <https://github.com/Microsoft/Git-Credential-Manager-for-Windows>
      - WIN11: 控制面板->用户帐户->凭据管理器->Windows凭证->普通凭证 git:smtp://...
