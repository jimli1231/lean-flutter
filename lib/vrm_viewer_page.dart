import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

/// 一个简单的VRM模型查看页面，使用Unity来渲染模型。
class VRMViewerPage extends StatefulWidget {
  const VRMViewerPage({super.key});

  @override
  State<VRMViewerPage> createState() => _VRMViewerPageState();
}

class _VRMViewerPageState extends State<VRMViewerPage> {
  UnityWidgetController? _controller;

  void _onUnityCreated(UnityWidgetController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VRM模型演示')),
      body: UnityWidget(
        onUnityCreated: _onUnityCreated,
      ),
    );
  }
}
