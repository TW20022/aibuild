#!/bin/bash
# 移除旧的打印机包定义
sed -i '/printing_packages/d' feeds.conf.default

# 【核心改动】直接把源码克隆到 package 目录下，跳过 feed 系统
# 这样无论 feeds 怎么更新，编译时都会在本地 package 目录找到这些包
git clone --depth 1 https://github.com/woniuzfb/openwrt-24-printing-packages package/printing_packages
