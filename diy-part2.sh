#!/bin/bash

# 1. 修改根分区大小 (保持你之前的逻辑)
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2. 移除 .config 中可能存在的“不编译”指令，改为“强制编译”
sed -i '/CONFIG_PACKAGE_python3-dbus/d' .config
echo "CONFIG_PACKAGE_python3-dbus=y" >> .config
echo "CONFIG_PACKAGE_python3-light=y" >> .config

# 3. 【关键修复】解决 LONG_BIT 32位冲突
# 我们直接在克隆下来的 package/printing_packages 目录里寻找 Makefile
# 并注入 py_cv_long_bit=32 参数
find package/printing_packages/ -name Makefile -path "*/python3-dbus/*" -exec sed -i 's/CONFIGURE_VARS +=/CONFIGURE_VARS += py_cv_long_bit=32 /g' {} +

# 4. 强制更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 5. 路径自检 (保留你的调试逻辑)
echo "======= 源码路径自检 ======="
if [ -d "package/printing_packages/python3-dbus" ]; then
    echo "✅ python3-dbus 源码已定位，准备编译"
else
    echo "⚠️ 未发现 python3-dbus 独立目录，可能集成在 printing_packages 内部"
fi
