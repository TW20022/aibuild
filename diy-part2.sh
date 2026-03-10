#!/bin/bash
# 定位 HPLIP 路径 (根据 immortalwrt 目录结构)
HPLIP_PATH="package/feeds/printing_packages/hplip"

# 1. 强行删除 Makefile 中的 Python 依赖，防止系统尝试安装 python3-dbus
sed -i 's/+python3-mini//g' $HPLIP_PATH/Makefile
sed -i 's/+python3//g' $HPLIP_PATH/Makefile

# 2. 修改配置参数：彻底禁用 Python、SANE(扫描) 和 GUI
# 仅保留核心的 hpcups 安装
sed -i 's/--enable-python-build/--disable-python-build/g' $HPLIP_PATH/Makefile
sed -i 's/--enable-sane-build/--disable-sane-build/g' $HPLIP_PATH/Makefile
sed -i 's/--enable-gui-build/--disable-gui-build/g' $HPLIP_PATH/Makefile
sed -i 's/--enable-qt5/--disable-qt5/g' $HPLIP_PATH/Makefile
sed -i 's/--enable-hpcups-install/--enable-hpcups-install/g' $HPLIP_PATH/Makefile
