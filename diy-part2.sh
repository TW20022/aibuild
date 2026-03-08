#!/bin/bash

# 1. 核心：放开根文件系统大小限制（设为 160MB 确保能装下 hplip 和 ghostscript）
# 这步是为了让编译器“敢于”生成那几个巨大的 .ipk 文件
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2. 强制更新 Feeds 并安装打印机包定义
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 【自检环节】在编译日志里打印结果，方便你后期排查
echo "======= 打印机源码拉取状态自检 ======="
if [ -d "feeds/printing_packages/net/cups" ]; then
    echo "✅ CUPS 源码已就绪"
else
    echo "❌ CUPS 源码缺失，请检查 diy-part1.sh"
fi

if [ -d "feeds/printing_packages/utils/hplip" ]; then
    echo "✅ HPLIP 源码已就绪"
else
    echo "❌ HPLIP 源码缺失"
fi
echo "===================================="


# 3. 修正 IP 和主机名
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/JDCloud-Printer/g' package/base-files/files/bin/config_generate

# 4. 无线配置 (CMCC-5G / 1234567890)
sed -i 's/ssid=OpenWrt/ssid=CMCC-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.encryption=none/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.ssid=CMCC-5G/a\                set wireless.default_radio${i}.encryption=psk2\n                set wireless.default_radio${i}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh
