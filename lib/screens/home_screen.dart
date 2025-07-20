import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vrm_provider.dart';
import '../widgets/vrm_viewer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<VRMServiceProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'VRM Viewer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  provider.refresh();
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  _showSettingsDialog(context, provider);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // 统计信息栏
              _buildStatsBar(provider),

              // 主要内容区域
              Expanded(
                child: _selectedIndex == 0
                    ? _buildViewerTab(context, provider)
                    : _buildLibraryTab(context, provider),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: _buildFloatingActionButton(context, provider),
        );
      },
    );
  }

  Widget _buildStatsBar(VRMServiceProvider provider) {
    final stats = provider.stats;
    final loadingState = provider.loadingState;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.model_training,
            label: '模型',
            value: '${stats['cachedModels'] ?? 0}',
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            icon: Icons.storage,
            label: '缓存',
            value:
                '${((stats['totalDataSize'] ?? 0) / 1024 / 1024).toStringAsFixed(1)}MB',
          ),
          const Spacer(),
          if (loadingState.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildViewerTab(BuildContext context, VRMServiceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // VRM查看器
          Expanded(
            child: VRMViewer(
              onModelLoaded: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('VRM模型加载成功！'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              onError: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('VRM模型加载失败'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 快速操作按钮
          _buildQuickActions(context, provider),
        ],
      ),
    );
  }

  Widget _buildLibraryTab(BuildContext context, VRMServiceProvider provider) {
    final models = provider.models;
    final loadingState = provider.loadingState;
    final error = provider.error;

    if (loadingState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.refresh();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return _buildModelList(context, provider, models);
  }

  Widget _buildModelList(BuildContext context, VRMServiceProvider provider,
      List<VRMModel> models) {
    if (models.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '暂无VRM模型',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击下方按钮添加VRM模型',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: models.length,
      itemBuilder: (context, index) {
        final model = models[index];
        return _buildModelCard(context, provider, model, index);
      },
    );
  }

  Widget _buildModelCard(BuildContext context, VRMServiceProvider provider,
      VRMModel model, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.view_in_ar,
            color: Colors.blue[700],
          ),
        ),
        title: Text(
          model.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildTagChip('${model.stats.vertexCount}顶点'),
                const SizedBox(width: 4),
                _buildTagChip('${model.stats.fileSize.toStringAsFixed(1)}MB'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                provider.setCurrentModel(model);
                setState(() {
                  _selectedIndex = 0;
                });
                break;
              case 'delete':
                _showDeleteDialog(context, provider, model);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('查看'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, VRMServiceProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              provider.loadVRMFromFile();
            },
            icon: const Icon(Icons.folder_open),
            label: const Text('从文件加载'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showUrlInputDialog(context, provider);
            },
            icon: const Icon(Icons.link),
            label: const Text('从URL加载'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_in_ar),
          label: '查看器',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: '模型库',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, VRMServiceProvider provider) {
    return FloatingActionButton(
      onPressed: () {
        _showAddModelDialog(context, provider);
      },
      child: const Icon(Icons.add),
    );
  }

  void _showAddModelDialog(BuildContext context, VRMServiceProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '添加VRM模型',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      provider.loadVRMFromFile();
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('从文件选择'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showUrlInputDialog(context, provider);
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('从URL加载'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUrlInputDialog(BuildContext context, VRMServiceProvider provider) {
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('输入VRM模型URL'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            hintText: 'https://example.com/model.vrm',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                Navigator.pop(context);
                provider.loadVRMFromUrl(url);
              }
            },
            child: const Text('加载'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, VRMServiceProvider provider, VRMModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除模型 "${model.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteModel(model.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, VRMServiceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('清除缓存'),
              onTap: () {
                Navigator.pop(context);
                provider.clearCache();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('缓存已清除')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
