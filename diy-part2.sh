#!/bin/bash

# 1. 核心：放开根文件系统大小限制（设为 160MB 确保能装下 hplip 和 ghostscript）
# 这步是为了让编译器“敢于”生成那几个巨大的 .ipk 文件
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2.强制处理打印机包：物理拷贝大法
mkdir -p package/custom_printing
cp -r feeds/printing_packages/. package/custom_printing/

# 3. 更新并安装 feeds（保持常规流程）
./scripts/feeds update -a
./scripts/feeds install -a

# 4. 自检（换个方式查，查物理路径）
echo "======= 源码状态自检 ======="
if [ -f "package/custom_printing/net/cups/Makefile" ] || [ -f "package/custom_printing/luci-app-cupsd/Makefile" ]; then
    echo "✅ CUPS & Luci App 源码已强制就绪"
else
    echo "❌ 依然缺失，检查 diy-part1.sh 下载是否成功"
fi
