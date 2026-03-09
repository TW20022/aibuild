#!/bin/bash

# 1. 优先使用自定义打印包仓库（放在 feeds.conf 第一行）
sed -i '1i\src-git printing_packages https://github.com/woniuzfb/openwrt-24-printing-packages.git' feeds.conf.default

# 2. 【关键】遵循指南，移除 pkg-config 对宿主机库的保留，防止交叉编译污染
# 这能解决 python3-dbus 链接到 x86_64 库的问题
sed -i '/--keep-system-cflags\|--keep-system-libs/d' tools/pkgconf/files/pkg-config
