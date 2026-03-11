#!/bin/bash

# 1. 自动定位 HPLIP 路径 (适配 feeds 软链接或实际目录)
HPLIP_PATH=$(find feeds/ package/ -name hplip -type d | head -n 1)

if [ -n "$HPLIP_PATH" ]; then
    echo "Found HPLIP at: $HPLIP_PATH"
    echo "Starting surgery to remove Python dependencies..."

    # 2. 移除 Makefile 中的所有 Python 相关依赖 (阻止编译 python3-dbus 等)
    # 针对 woniuzfb 的 Makefile 结构进行精确匹配删除
    sed -i 's/python3-dbus//g' $HPLIP_PATH/Makefile
    sed -i 's/python3-distro//g' $HPLIP_PATH/Makefile
    sed -i 's/python3-mini//g' $HPLIP_PATH/Makefile
    sed -i 's/python3 //g' $HPLIP_PATH/Makefile
    
    # 修正可能残余的加号和空格 (例如 +python3 -> +)
    sed -i 's/+\s*+/+/g' $HPLIP_PATH/Makefile
    sed -i 's/DEPENDS:=+/DEPENDS:=/g' $HPLIP_PATH/Makefile

    # 3. 强制配置为极简模式 (Lite Build) 并禁用 Python 编译
    # 在 CONFIGURE_ARGS 中插入关键开关
    sed -i '/--disable-fax-build/a \	--enable-lite-build \\\n	--disable-python-build \\\n	--disable-dbus-build' $HPLIP_PATH/Makefile

    # 4. 绕过 Build/Configure 阶段对宿主机 Python 的探测 (解决 LONG_BIT 报错的关键)
    # 将 PYTHON 指向目标系统路径而非宿主机路径
    sed -i 's|PYTHON=$(STAGING_DIR_HOSTPKG)/bin/python3|PYTHON=/usr/bin/python3|g' $HPLIP_PATH/Makefile

    # 5. 注释掉扫描和命令行工具包，只保留核心打印功能 (防止拉起额外依赖)
    sed -i '/call BuildPackage,hplip-scan/s/^/#/' $HPLIP_PATH/Makefile
    sed -i '/call BuildPackage,hplip-tools/s/^/#/' $HPLIP_PATH/Makefile

    # 6. 移除 PKG_BUILD_DEPENDS 里的 python3
    sed -i 's/PKG_BUILD_DEPENDS:=python3/PKG_BUILD_DEPENDS:=/' $HPLIP_PATH/Makefile

    echo "Surgery completed successfully."
else
    echo "Error: Could not find HPLIP directory in feeds or package!"
fi

# --- 补充：隔离系统 pkg-config 污染 (确保编译环境纯净) ---
sed -i '/--keep-system-cflags\|--keep-system-libs/d' tools/pkgconf/files/pkg-config
