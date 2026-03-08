#!/bin/bash

# 1. 修改根分区大小为 160MB
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2. 强制更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 源码位置自检
echo "======= 源码物理路径深度自检 ======="
# 检查刚才 git clone 出来的 Makefile 到底在哪
if [ -f "package/printing_packages/net/cups/Makefile" ]; then
    echo "✅ 路径 1 (net/cups) 已就绪"
elif [ -f "package/printing_packages/cups/Makefile" ]; then
    echo "✅ 路径 2 (cups) 已就绪"
else
    echo "❌ 依然缺失，请看下方 ls 输出结果"
    ls -R package/printing_packages | head -n 20
fi
