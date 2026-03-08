#!/bin/bash
# 移除旧源
sed -i '/printing_packages/d' feeds.conf.default
# 添加打印机包（此仓库已支持 24.xx 版本）
echo 'src-git printing_packages https://github.com/woniuzfb/openwrt-24-printing-packages' >> feeds.conf.default
