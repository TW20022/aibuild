#!/bin/bash
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 取消下面两行的注释可以添加额外的插件源（如果默认源中没有的话）
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

# 确保打印机驱动相关的 packages 仓库处于激活状态
echo 'src-git printing_packages https://github.com/woniuzfb/openwrt-24-printing-packages' >> feeds.conf.default
