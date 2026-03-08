#!/bin/bash
# 移除旧的源（如果有），确保干净
sed -i '/printing_packages/d' feeds.conf.default

# 添加前人指路的打印机驱动精准源
echo 'src-git printing_packages https://github.com/woniuzfb/openwrt-24-printing-packages' >> feeds.conf.default
