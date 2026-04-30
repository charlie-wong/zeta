#!/usr/bin/bash

THIS_AFP="$(realpath "${0}")"        # 当前文件绝对路径(含名)
THIS_FNO="$(basename "${THIS_AFP}")" # 仅包含当前文件的文件名
THIS_DIR="$(dirname  "${THIS_AFP}")" # 当前文件所在的绝对路径

# NOTE 下载新版本解压后用此脚本将 Rust 组件整合到一起
echo "rust-1.95.0-x86_64-unknown-linux-gnu => DST=1.95.0"
exit # NOTE 修改为 Rust 目录及版本号然后再执行脚本整合
RUST_DIR=rust-1.95.0-x86_64-unknown-linux-gnu; DST=1.95.0

# NOTE
# 1. 从 other-installation-methods.html 页面查找最新稳定版本
# 2. 从<清华>dist/channel-rust-stable.toml 中找到国内镜像地址
# => 组件 版本   芯片   发行商  操作系统
#    rust-1.95.0-x86_64-unknown-linux-gnu.tar.xz
TARGET=x86_64-unknown-linux-gnu
# 官方 https://static.rust-lang.org
# 清华 https://mirrors.tuna.tsinghua.edu.cn/help/rustup
# 中科 https://mirrors.ustc.edu.cn/help/rust-static.html
# https://rust-lang.github.io/rustup/installation/other.html
# https://forge.rust-lang.org/infra/other-installation-methods.html

cd ${RUST_DIR}

# 编译器
mv rustc ${DST}
rm -f    ${DST}/manifest.in
rm -rf   ${DST}/share/doc

# 标准库
PKG=rust-std-${TARGET}
mv ${PKG}/lib/rustlib/${TARGET}/lib     ${DST}/lib/rustlib/${TARGET}/

# cargo 工程及包管理
PKG=cargo
mv ${PKG}/bin/*                         ${DST}/bin/
mv ${PKG}/etc/bash_completion.d         ${DST}/etc/
mv ${PKG}/share/zsh                     ${DST}/share/
mv ${PKG}/share/man/man1/*              ${DST}/share/man/man1/

# rust-docs 网页文档
echo "TODO: rust-docs"

# clippy 编码风格及质量检测
PKG=clippy-preview
mv ${PKG}/bin/*                         ${DST}/bin/

# rust-analyzer 编辑器(IDE)语法解析
PKG=rust-analyzer-preview
mv ${PKG}/bin/*                         ${DST}/bin/

# rustfmt 代码格式化工具
PKG=rustfmt-preview
mv ${PKG}/bin/*                         ${DST}/bin/

# llvm-tools
PKG=llvm-tools-preview
mv ${PKG}/lib/rustlib/${TARGET}/bin/*   ${DST}/lib/rustlib/${TARGET}/bin/
mv ${PKG}/lib/rustlib/${TARGET}/lib/*   ${DST}/lib/rustlib/${TARGET}/lib/

# llvm-bitcode-linker
PKG=llvm-bitcode-linker-preview
mv ${PKG}/lib/rustlib/${TARGET}/bin/*   ${DST}/lib/rustlib/${TARGET}/bin/
