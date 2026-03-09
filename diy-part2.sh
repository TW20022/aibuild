#!/bin/bash

# 1. 修改根分区大小为 160MB
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 2. 【核心修复】解决 python3-dbus 32位编译错误
# 强制在 python3-dbus 的编译配置中注入 32位参数
# 这样即便它在 64位宿主机上运行，也会乖乖按 32位 MIPS 编译
find package/printing_packages/ -name Makefile -path "*/python3-dbus/*" -exec sed -i 's/CONFIGURE_VARS +=/CONFIGURE_VARS += py_cv_long_bit=32 /g' {} +

# 3. 补齐 .config 缺失项
# 移除之前的 is not set，强制开启
sed -i '/CONFIG_PACKAGE_python3-dbus/d' .config
echo "CONFIG_PACKAGE_python3-dbus=y" >> .config
echo "CONFIG_PACKAGE_python3-light=y" >> .config

# 4. 强制更新 feeds 并安装 (这一步必须在修改 .config 前后保持同步)
./scripts/feeds update -a
./scripts/feeds install -a

# 5. 源码位置自检 (保留你之前的逻辑)
echo "======= 源码物理路径深度自检 ======="
if [ -f "package/printing_packages/net/cups/Makefile" ]; then
    echo "✅ 路径 1 (net/cups) 已就绪"
elif [ -f "package/printing_packages/cups/Makefile" ]; then
    echo "✅ 路径 2 (cups) 已就绪"
else
    echo "❌ 依然缺失，请看下方 ls 输出结果"
    ls -R package/printing_packages | head -n 20
fi
