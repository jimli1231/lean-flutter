# 我的待办事项 - Flutter应用

这是一个使用Flutter开发的现代化待办事项应用，具有简洁美观的用户界面和完整的功能。

## 功能特性

- ✅ 添加新的待办事项
- ✅ 标记任务为已完成/未完成
- ✅ 删除不需要的任务
- ✅ 实时统计任务总数和完成数量
- ✅ 现代化的Material Design 3界面
- ✅ 响应式设计，适配不同屏幕尺寸
- ✅ 空状态提示，提升用户体验

## 技术特点

- 使用Flutter 3.x和Dart语言开发
- 采用Material Design 3设计规范
- 状态管理使用Flutter内置的StatefulWidget
- 响应式UI设计
- 中文界面，本地化友好

## 运行应用

### 前提条件

确保您的系统已安装：
- Flutter SDK (版本 3.0.0 或更高)
- Dart SDK
- Android Studio 或 VS Code
- iOS开发需要Xcode (仅macOS)

### 运行步骤

1. 进入项目目录：
   ```bash
   cd my_flutter_app
   ```

2. 获取依赖包：
   ```bash
   flutter pub get
   ```

3. 运行应用：
   ```bash
   flutter run
   ```

### 支持的平台

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 项目结构

```
my_flutter_app/
├── lib/
│   └── main.dart          # 主应用文件
├── android/               # Android平台配置
├── ios/                   # iOS平台配置
├── web/                   # Web平台配置
├── windows/               # Windows平台配置
├── macos/                 # macOS平台配置
├── linux/                 # Linux平台配置
├── test/                  # 测试文件
├── pubspec.yaml           # 项目配置和依赖
└── README.md              # 项目说明文档
```

## 使用说明

1. **添加任务**：在顶部输入框中输入任务内容，然后点击"添加"按钮或按回车键
2. **完成任务**：点击任务前的复选框来标记任务为已完成
3. **删除任务**：点击任务右侧的删除图标来移除任务
4. **查看统计**：底部会显示总任务数和已完成任务数

## 开发说明

### 主要组件

- `MyApp`: 应用根组件，配置主题和路由
- `TodoListPage`: 主页面，包含待办事项列表和操作界面
- `TodoItem`: 数据模型，表示单个待办事项

### 状态管理

应用使用Flutter的StatefulWidget进行状态管理，主要状态包括：
- `_todos`: 待办事项列表
- `_textController`: 输入框控制器

### 主题配置

应用使用Material Design 3主题，支持：
- 动态颜色方案
- 自适应亮度
- 现代化的UI组件

## 未来改进

- [ ] 数据持久化存储
- [ ] 任务分类和标签
- [ ] 任务优先级设置
- [ ] 截止日期提醒
- [ ] 深色模式支持
- [ ] 多语言支持
- [ ] 云同步功能

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 许可证

MIT License
