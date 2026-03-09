#!/bin/bash
# 增加第三方打印包仓库，并置于首位
sed -i '1i\src-git printing_packages https://github.com/woniuzfb/openwrt-24-printing-packages.git' feeds.conf.default
# 隔离系统 pkg-config 污染
sed -i '/--keep-system-cflags\|--keep-system-libs/d' tools/pkgconf/files/pkg-config
