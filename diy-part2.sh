#!/bin/bash
# 1. 修改默认 IP (可选)
# sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 2. 扩容 rootfs 分区到 160MB (满足 Ghostscript 体积需求)
sed -i 's/CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=160/' .config

# 3. 注入 32位 MIPS 适配参数 (解决 python3-dbus 核心报错)
find package/feeds/printing_packages/ -name Makefile -path "*/python3-dbus/*" -exec sed -i 's/CONFIGURE_VARS +=/CONFIGURE_VARS += py_cv_long_bit=32 /g' {} +

# 4. 强制开启 Strip 模式减小二进制体积
echo "CONFIG_USE_STRIP=y" >> .config
echo "CONFIG_STRIP_KERNEL_EXPORTS=y" >> .config

# 5. 确保核心打印依赖被勾选
echo "CONFIG_PACKAGE_dbus=y" >> .config
echo "CONFIG_PACKAGE_libdbus=y" >> .config
