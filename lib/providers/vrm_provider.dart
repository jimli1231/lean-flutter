import 'package:flutter/foundation.dart';
import '../models/vrm_model.dart';
import '../services/vrm_service.dart';

// VRM服务提供者
class VRMServiceProvider extends ChangeNotifier {
  final VRMService _vrmService = VRMService();
  List<VRMModel> _models = [];
  VRMModel? _currentModel;
  LoadingState _loadingState = LoadingState.idle;
  String? _error;

  // Getters
  List<VRMModel> get models => _models;
  VRMModel? get currentModel => _currentModel;
  LoadingState get loadingState => _loadingState;
  String? get error => _error;
  Map<String, dynamic> get stats => _vrmService.getStats();

  VRMServiceProvider() {
    _loadLocalModels();
  }

  // 加载本地模型
  Future<void> _loadLocalModels() async {
    try {
      _setLoadingState(LoadingState.loading);
      final models = await _vrmService.getLocalModels();
      _models = models;
      _setLoadingState(LoadingState.idle);
    } catch (error) {
      _setError(error.toString());
      _setLoadingState(LoadingState.error);
    }
  }

  // 从URL加载VRM模型
  Future<void> loadVRMFromUrl(String url) async {
    try {
      _setLoadingState(LoadingState.loading);
      _clearError();

      final model = await _vrmService.loadVRMFromUrl(url);
      if (model != null) {
        _currentModel = model;
        await _loadLocalModels(); // 刷新列表
      } else {
        throw Exception('Failed to load VRM model from URL');
      }

      _setLoadingState(LoadingState.idle);
    } catch (error) {
      _setError(error.toString());
      _setLoadingState(LoadingState.error);
    }
  }

  // 从文件加载VRM模型
  Future<void> loadVRMFromFile() async {
    try {
      _setLoadingState(LoadingState.loading);
      _clearError();

      final model = await _vrmService.loadVRMFromFile();
      if (model != null) {
        _currentModel = model;
        await _loadLocalModels(); // 刷新列表
      }

      _setLoadingState(LoadingState.idle);
    } catch (error) {
      _setError(error.toString());
      _setLoadingState(LoadingState.error);
    }
  }

  // 设置当前模型
  void setCurrentModel(VRMModel model) {
    _currentModel = model;
    notifyListeners();
  }

  // 删除模型
  Future<void> deleteModel(String modelId) async {
    try {
      final success = await _vrmService.deleteLocalModel(modelId);
      if (success) {
        await _loadLocalModels(); // 刷新列表
      }
    } catch (error) {
      _setError(error.toString());
    }
  }

  // 清除缓存
  void clearCache() {
    _vrmService.clearCache();
    _loadLocalModels();
  }

  // 刷新模型列表
  Future<void> refresh() async {
    await _loadLocalModels();
  }

  // 私有方法
  void _setLoadingState(LoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

// 加载状态枚举
enum LoadingState {
  idle,
  loading,
  error,
}

// 扩展方法
extension LoadingStateExtension on LoadingState {
  bool get isLoading => this == LoadingState.loading;
  bool get hasError => this == LoadingState.error;
  bool get isIdle => this == LoadingState.idle;
}
