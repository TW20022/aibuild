#!/bin/bash

# 1. 修改分区大小以容纳 Ghostscript 和 HPLIP
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2. 注入 32位 架构参数到 python3-dbus (针对 MT7621)
# 指南中虽未明说，但在 32位 MIPS 上这是必做的
find package/feeds/printing_packages/ -name Makefile -path "*/python3-dbus/*" -exec sed -i 's/CONFIGURE_VARS +=/CONFIGURE_VARS += py_cv_long_bit=32 /g' {} +

# 3. 补充必要的依赖开关，确保 HPLIP 编译环境完整
cat >> .config <<EOF
CONFIG_PACKAGE_dbus=y
CONFIG_PACKAGE_libdbus=y
CONFIG_PACKAGE_python3-light=y
CONFIG_PACKAGE_python3-base=y
CONFIG_PACKAGE_python3-dbus=y
CONFIG_PACKAGE_libcups=y
CONFIG_PACKAGE_cups=y
EOF
