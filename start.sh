#!/bin/bash

# Flutter应用启动脚本
echo "🚀 启动我的待办事项应用..."

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    exit 1
fi

# 检查是否在正确的目录
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 请在Flutter项目根目录下运行此脚本"
    exit 1
fi

# 获取依赖
echo "📦 获取依赖包..."
flutter pub get

# 检查可用的设备
echo "📱 检查可用设备..."
flutter devices

# 启动应用
echo "🎯 启动应用..."
echo "选择运行平台："
echo "1. Chrome浏览器 (Web)"
echo "2. iOS模拟器"
echo "3. Android模拟器"
echo "4. macOS应用"
echo "5. 自动选择第一个可用设备"

read -p "请选择 (1-5): " choice

case $choice in
    1)
        echo "🌐 在Chrome浏览器中启动..."
        flutter run -d chrome
        ;;
    2)
        echo "📱 在iOS模拟器中启动..."
        flutter run -d ios
        ;;
    3)
        echo "🤖 在Android模拟器中启动..."
        flutter run -d android
        ;;
    4)
        echo "🖥️ 在macOS中启动..."
        flutter run -d macos
        ;;
    5)
        echo "🔄 自动选择设备..."
        flutter run
        ;;
    *)
        echo "❌ 无效选择，使用默认设置..."
        flutter run
        ;;
esac 