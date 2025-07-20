# VRM Viewer - 高性能VRM模型查看器

一个基于Flutter开发的高性能VRM（Virtual Reality Model）模型查看器应用，支持3D模型的加载、查看和管理。

## 🚀 功能特性

### 核心功能
- **VRM模型加载**: 支持从URL和本地文件加载VRM模型
- **3D模型查看**: 高性能的3D模型渲染和交互
- **模型管理**: 本地模型库管理，支持增删改查
- **性能优化**: 使用Provider进行状态管理，确保流畅的用户体验

### 技术特性
- **跨平台支持**: 支持Web、iOS、Android、macOS、Linux、Windows
- **高性能渲染**: 优化的3D渲染引擎
- **响应式设计**: 适配不同屏幕尺寸
- **现代化UI**: Material Design 3设计语言

## 📱 界面预览

### 主界面
- **查看器标签页**: 3D模型展示区域
- **模型库标签页**: 本地模型管理
- **统计信息栏**: 显示模型数量和缓存大小
- **快速操作**: 一键加载模型

### 功能区域
- **VRM查看器**: 支持旋转、缩放、平移等交互
- **模型信息**: 显示顶点数、材质数、文件大小等统计
- **控制按钮**: 全屏、截图、分享等功能

## 🛠️ 技术架构

### 依赖包
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理
  provider: ^6.0.5
  
  # 网络和文件
  http: ^0.13.6
  path_provider: ^2.1.1
  
  # UI组件
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  
  # 工具类
  json_annotation: ^4.8.1
  uuid: ^3.0.7
```

### 项目结构
```
lib/
├── models/          # 数据模型
│   └── vrm_model.dart
├── services/        # 业务服务
│   └── vrm_service.dart
├── providers/       # 状态管理
│   └── vrm_provider.dart
├── widgets/         # UI组件
│   └── vrm_viewer.dart
├── screens/         # 页面
│   └── home_screen.dart
├── utils/           # 工具类
└── main.dart        # 应用入口
```

## 🚀 快速开始

### 环境要求
- Flutter SDK: >=2.19.6
- Dart SDK: >=2.19.6
- 支持平台: Web, iOS, Android, macOS, Linux, Windows

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd my_flutter_app
```

2. **安装依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
flutter packages pub run build_runner build
```

4. **运行应用**
```bash
# Web平台（推荐）
flutter run -d chrome

# 其他平台
flutter run -d macos    # macOS
flutter run -d ios      # iOS模拟器
flutter run -d android  # Android设备
```

## 📖 使用指南

### 加载VRM模型

1. **从URL加载**
   - 点击"从URL加载"按钮
   - 输入VRM文件的URL地址
   - 点击"加载"按钮

2. **从文件加载**
   - 点击"从文件加载"按钮
   - 选择本地VRM文件
   - 文件将自动加载并保存到本地

### 管理模型库

1. **查看模型**
   - 切换到"模型库"标签页
   - 点击模型卡片查看详情
   - 选择"查看"进入3D查看器

2. **删除模型**
   - 在模型库中点击模型卡片的菜单按钮
   - 选择"删除"选项
   - 确认删除操作

### 3D交互

- **旋转**: 拖拽模型进行旋转
- **缩放**: 双指缩放或滚轮缩放
- **平移**: 拖拽背景进行平移
- **重置**: 点击重置按钮恢复默认视角

## 🔧 开发说明

### 状态管理
使用Provider模式进行状态管理：
- `VRMServiceProvider`: 管理VRM模型数据和状态
- `LoadingState`: 加载状态枚举
- 响应式UI更新

### 数据模型
```dart
class VRMModel {
  final String id;
  final String name;
  final String description;
  final VRMMetadata metadata;
  final VRMStats stats;
  // ...
}
```

### 服务层
- `VRMService`: 处理VRM文件的加载、解析、存储
- 支持本地缓存和网络加载
- 错误处理和状态管理

## 🎯 性能优化

### 渲染优化
- 使用高效的3D渲染引擎
- 模型LOD（细节层次）管理
- 纹理压缩和缓存

### 内存管理
- 智能缓存策略
- 内存使用监控
- 自动垃圾回收

### 网络优化
- 断点续传支持
- 压缩传输
- 缓存策略

## 🔮 未来计划

### 功能增强
- [ ] VRM 2.0规范支持
- [ ] 动画播放功能
- [ ] 材质编辑功能
- [ ] 导出功能

### 性能提升
- [ ] WebGL 2.0支持
- [ ] 多线程渲染
- [ ] GPU加速计算

### 用户体验
- [ ] 手势识别优化
- [ ] 自定义主题
- [ ] 多语言支持

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

### 开发环境设置
1. Fork项目
2. 创建功能分支
3. 提交代码
4. 创建Pull Request

### 代码规范
- 遵循Dart代码规范
- 添加适当的注释
- 编写单元测试

## 📄 许可证

本项目基于MIT许可证开源。

## 🙏 致谢

- [UniVRM](https://github.com/vrm-c/UniVRM) - VRM格式实现
- [Flutter](https://flutter.dev) - 跨平台开发框架
- [Provider](https://pub.dev/packages/provider) - 状态管理

---

**VRM Viewer** - 让3D模型查看更简单、更高效！ 🎨✨
