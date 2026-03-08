#!/bin/bash

# 1. 核心：放开根文件系统大小限制（设为 160MB 确保能装下 hplip 和 ghostscript）
# 这步是为了让编译器“敢于”生成那几个巨大的 .ipk 文件
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2. 强制安装打印机相关包并覆盖默认冲突
./scripts/feeds update -a
./scripts/feeds install -p printing_packages -f cups hplip ghostscript luci-app-cupsd
./scripts/feeds install -a

# 3. 极简自检
[ -e "package/feeds/printing_packages/cups/Makefile" ] && echo "✅ CUPS Ready" || echo "❌ CUPS Missing"


# 3. 修正 IP 和主机名
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/JDCloud-Printer/g' package/base-files/files/bin/config_generate

# 4. 无线配置 (CMCC-5G / 1234567890)
sed -i 's/ssid=OpenWrt/ssid=CMCC-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.encryption=none/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.ssid=CMCC-5G/a\                set wireless.default_radio${i}.encryption=psk2\n                set wireless.default_radio${i}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh
