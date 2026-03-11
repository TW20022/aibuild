#!/bin/bash
# 定位 HPLIP 路径
HPLIP_PATH="package/feeds/printing_packages/hplip"

# 1. 彻底清除 Makefile 中的 Python 依赖（包括编译和运行依赖）
# woniuzfb 的 Makefile 中使用了 python3, python3-dbus, python3-distro
sed -i 's/python3 //g' $HPLIP_PATH/Makefile
sed -i 's/+python3-mini//g' $HPLIP_PATH/Makefile
sed -i 's/+python3-dbus//g' $HPLIP_PATH/Makefile
sed -i 's/+python3-distro//g' $HPLIP_PATH/Makefile
sed -i 's/+python3//g' $HPLIP_PATH/Makefile

# 2. 修改配置参数：强制开启极简编译 (Lite Build)
# 禁用一切不需要的模块，只为获得 hpcups 过滤器
sed -i 's/--disable-fax-build/--disable-fax-build --enable-lite-build --disable-python-build --disable-dbus-build --disable-scan-build/g' $HPLIP_PATH/Makefile

# 3. 绕过 Build/Configure 阶段对宿主机 Python 的探测
# 将 CONFIGURE_ARGS 中的 PYTHON 定义指向一个虚假路径或留空，防止其触发 LONG_BIT 检测
sed -i 's/PYTHON=$(STAGING_DIR_HOSTPKG)\/bin\/python3/PYTHON=\/usr\/bin\/python3/g' $HPLIP_PATH/Makefile

# 4. 注释掉不需要的子包（scan 和 tools），防止它们拉起 Python 依赖
sed -i '/call BuildPackage,hplip-scan/s/^/#/' $HPLIP_PATH/Makefile
sed -i '/call BuildPackage,hplip-tools/s/^/#/' $HPLIP_PATH/Makefile

# 5. 额外安全检查：移除 PKG_BUILD_DEPENDS 里的 python3
sed -i 's/PKG_BUILD_DEPENDS:=python3/PKG_BUILD_DEPENDS:=/' $HPLIP_PATH/Makefile
