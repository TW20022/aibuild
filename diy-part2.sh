#!/bin/bash
# 修改默认IP和主机名
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/JDCloud-Printer/g' package/base-files/files/bin/config_generate

# 强行修改该机型的编译镜像限制 (从默认可能只有32MB扩充)
# 注意：这需要根据源码中的路径调整，以下是针对大多数LEDE源码的改法
sed -i 's/IMAGE_SIZE := .*/IMAGE_SIZE := 250000k/g' target/linux/ramips/image/mt7621.mk

# 设置 Rootfs 大小
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 无线设置
sed -i 's/ssid=OpenWrt/ssid=CMCC-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 开启加密和密码
sed -i '/set wireless.default_radio${i}.encryption=none/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.ssid=CMCC-5G/a\                set wireless.default_radio${i}.encryption=psk2\n                set wireless.default_radio${i}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh
