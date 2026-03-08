#!/bin/bash
# 1. 修正 IP 和主机名
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/JDCloud-Printer/g' package/base-files/files/bin/config_generate

# 2. 针对 32MB 闪存的精确分区 (匹配你 mtd3 的 firmware 大小)
# 设置内核分区为 4MB (给驱动留余量)
sed -i 's/CONFIG_TARGET_KERNEL_PARTSIZE=.*$/CONFIG_TARGET_KERNEL_PARTSIZE=4/' .config
# 设置 Rootfs 为160MB (只是为了生成ipk，生成的.bin文件不可以直接刷机)
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 3. 无线配置 (CMCC-5G / 1234567890)
sed -i 's/ssid=OpenWrt/ssid=CMCC-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.encryption=none/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.ssid=CMCC-5G/a\                set wireless.default_radio${i}.encryption=psk2\n                set wireless.default_radio${i}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh
