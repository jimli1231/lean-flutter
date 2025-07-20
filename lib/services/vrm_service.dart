import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/vrm_model.dart';

class VRMService {
  static final VRMService _instance = VRMService._internal();
  factory VRMService() => _instance;
  VRMService._internal();

  final Map<String, VRMModel> _cachedModels = {};
  final Map<String, Uint8List> _modelData = {};

  // 获取本地存储目录
  Future<Directory> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();
    final vrmDir = Directory('${directory.path}/vrm_models');
    if (!await vrmDir.exists()) {
      await vrmDir.create(recursive: true);
    }
    return vrmDir;
  }

  // 从网络加载VRM模型
  Future<VRMModel?> loadVRMFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final modelData = response.bodyBytes;
        return await _processVRMData(modelData, url);
      }
    } catch (e) {
      print('Error loading VRM from URL: $e');
    }
    return null;
  }

  // 从本地文件加载VRM模型（模拟）
  Future<VRMModel?> loadVRMFromFile() async {
    try {
      // 模拟文件选择，创建一个示例模型
      final modelData = Uint8List.fromList(List.generate(1024, (i) => i % 256));
      return await _processVRMData(modelData, 'local_file.vrm');
    } catch (e) {
      print('Error loading VRM from file: $e');
    }
    return null;
  }

  // 处理VRM数据
  Future<VRMModel?> _processVRMData(Uint8List data, String source) async {
    try {
      // 这里应该解析VRM文件格式
      // 由于VRM是二进制格式，需要专门的解析器
      // 暂时返回模拟数据
      final model = VRMModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'VRM Model',
        description: 'Loaded from $source',
        modelUrl: source,
        metadata: VRMMetadata(
          version: '1.0',
          title: 'VRM Model',
          violentUsage: false,
          sexualUsage: false,
          commercialUsage: false,
          otherPermissionUrl: false,
          showUserAvatar: true,
          showUserAvatarName: true,
        ),
        tags: ['3D', 'VRM'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        stats: VRMStats(
          vertexCount: 1000,
          materialCount: 5,
          meshCount: 10,
          boneCount: 50,
          blendShapeCount: 20,
          fileSize: data.length / 1024 / 1024, // MB
          format: 'VRM',
        ),
      );

      _cachedModels[model.id] = model;
      _modelData[model.id] = data;

      // 保存到本地
      await _saveModelLocally(model, data);

      return model;
    } catch (e) {
      print('Error processing VRM data: $e');
      return null;
    }
  }

  // 保存模型到本地
  Future<void> _saveModelLocally(VRMModel model, Uint8List data) async {
    try {
      final dir = await _localDir;
      final file = File('${dir.path}/${model.id}.vrm');
      await file.writeAsBytes(data);
    } catch (e) {
      print('Error saving model locally: $e');
    }
  }

  // 获取本地保存的模型列表
  Future<List<VRMModel>> getLocalModels() async {
    try {
      final dir = await _localDir;
      final files = dir.listSync().where((file) => file.path.endsWith('.vrm'));

      final models = <VRMModel>[];
      for (final file in files) {
        final modelId = file.path.split('/').last.replaceAll('.vrm', '');
        if (_cachedModels.containsKey(modelId)) {
          models.add(_cachedModels[modelId]!);
        }
      }

      return models;
    } catch (e) {
      print('Error getting local models: $e');
      return [];
    }
  }

  // 获取缓存的模型数据
  Uint8List? getModelData(String modelId) {
    return _modelData[modelId];
  }

  // 清除缓存
  void clearCache() {
    _cachedModels.clear();
    _modelData.clear();
  }

  // 删除本地模型
  Future<bool> deleteLocalModel(String modelId) async {
    try {
      final dir = await _localDir;
      final file = File('${dir.path}/$modelId.vrm');
      if (await file.exists()) {
        await file.delete();
        _cachedModels.remove(modelId);
        _modelData.remove(modelId);
        return true;
      }
    } catch (e) {
      print('Error deleting local model: $e');
    }
    return false;
  }

  // 获取模型统计信息
  Map<String, dynamic> getStats() {
    return {
      'cachedModels': _cachedModels.length,
      'totalDataSize':
          _modelData.values.fold<int>(0, (sum, data) => sum + data.length),
    };
  }
}
