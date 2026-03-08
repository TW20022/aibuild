#!/bin/bash
# 修改默认 IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改默认主题为 bootstrap (虽然默认通常是它，但强制指定一次)
sed -i 's/luci-theme-bootstrap/luci-theme-bootstrap/g' feeds/luci/collections/luci/Makefile

# 修改主机名
sed -i 's/OpenWrt/JDC/g' package/base-files/files/bin/config_generate

# 针对 256MB NAND 闪存的分区调整
# 内核分区给 16MB 足够了
sed -i 's/CONFIG_TARGET_KERNEL_PARTSIZE=.*$/CONFIG_TARGET_KERNEL_PARTSIZE=16/' .config
# 根文件系统分区给 160MB (剩下的空间预留给 UBI 损耗和管理)
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# --- 无线配置自定义 ---
# 1. 修改默认无线名称为 CMCC-5G
sed -i 's/ssid=OpenWrt/ssid=CMCC-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 2. 设置无线密码为 1234567890 (并强制开启 WPA2 加密)
sed -i '/set wireless.default_radio${i}.encryption=none/d' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${i}.ssid=CMCC-5G/a\                set wireless.default_radio${i}.encryption=psk2\n                set wireless.default_radio${i}.key=1234567890' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 针对可能存在的闭源驱动额外处理
find package/ -name "mt7615.lua" | xargs sed -i 's/ssid = "OpenWrt"/ssid = "CMCC-5G"/g' 2>/dev/null
find package/ -name "mt7615.lua" | xargs sed -i 's/encryption = "none"/encryption = "psk2"/g' 2>/dev/null
find package/ -name "mt7615.lua" | xargs sed -i '/encryption = "psk2"/a\                key = "1234567890"' 2>/dev/null
