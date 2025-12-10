import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 导入 MVI 组件
import '../features/groups/groups_bloc.dart';
import '../features/groups/groups_intent.dart';
import '../features/groups/groups_state.dart';
import '../features/groups/groups_event.dart';
import '../features/chat/chat_bloc.dart';
import '../features/chat/chat_intent.dart';
import 'chat_page.dart';

/// 显示用户已加入群组列表的群组页面
/// 
/// 该页面提供微信风格的界面用于查看和管理
/// 群组，包括创建新群组和加入现有群组的选项。
class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
    
    // 页面初始化时加载群组
    context.read<GroupsBloc>().add(const LoadGroupsIntent());
    
    // 监听群组事件进行导航和消息处理
    context.read<GroupsBloc>().eventStream.listen((event) {
      if (event is NavigateToGroupChatEvent) {
        _navigateToGroupChat(event.groupId);
      } else if (event is ShowGroupsErrorEvent) {
        _showErrorMessage(event.message);
      } else if (event is ShowGroupsSuccessEvent) {
        _showSuccessMessage(event.message);
      }
    });
  }

  /// Navigate to group chat page
  void _navigateToGroupChat(String groupId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChatBloc()..add(InitializeChatIntent(conversationId: groupId)),
          child: ChatPage(conversationId: groupId),
        ),
      ),
    );
  }

  /// Show error message to user
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show success message to user
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show dialog to create a new group
  void _showCreateGroupDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    bool isPublic = true;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('创建群组'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '群组名称',
                        hintText: '请输入群组名称',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 50,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: '群组描述（可选）',
                        hintText: '请输入群组描述',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value ?? true;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text('公开群组（任何人都可以搜索和加入）'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      Navigator.of(dialogContext).pop();
                      context.read<GroupsBloc>().add(
                        CreateGroupIntent(
                          groupName: name,
                          description: descController.text.trim().isEmpty
                              ? null
                              : descController.text.trim(),
                          isPublic: isPublic,
                        ),
                      );
                    }
                  },
                  child: const Text('创建'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Show dialog to join a group by ID
  void _showJoinGroupDialog() {
    final TextEditingController groupIdController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('加入群组'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: groupIdController,
                  decoration: const InputDecoration(
                    labelText: '群组ID',
                    hintText: '请输入群组ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: '申请理由（可选）',
                    hintText: '请输入申请理由',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                final groupId = groupIdController.text.trim();
                if (groupId.isNotEmpty) {
                  Navigator.of(dialogContext).pop();
                  context.read<GroupsBloc>().add(
                    JoinGroupIntent(
                      groupId: groupId,
                      reason: reasonController.text.trim().isEmpty
                          ? null
                          : reasonController.text.trim(),
                    ),
                  );
                }
              },
              child: const Text('加入'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群组'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'create':
                  _showCreateGroupDialog();
                  break;
                case 'join':
                  _showJoinGroupDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'create',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline),
                    SizedBox(width: 8),
                    Text('创建群组'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'join',
                child: Row(
                  children: [
                    Icon(Icons.group_add),
                    SizedBox(width: 8),
                    Text('加入群组'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state is GroupsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GroupsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GroupsBloc>().add(const RefreshGroupsIntent());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          } else if (state is GroupsLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GroupsBloc>().add(const RefreshGroupsIntent());
              },
              child: ListView.builder(
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          group.groupName.isNotEmpty ? group.groupName[0].toUpperCase() : 'G',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      title: Text(
                        group.groupName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (group.description != null && group.description!.isNotEmpty)
                            Text(
                              group.description!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                group.memberCountText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (group.isOwner)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '群主',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              else if (group.isAdmin)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '管理员',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.read<GroupsBloc>().add(
                          SelectGroupIntent(groupId: group.groupId),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is GroupsEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无群组',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击右上角菜单创建或加入群组',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is GroupsJoiningState ||
                     state is GroupsLeavingState ||
                     state is GroupsCreatingState) {
            // Show loading overlay for operations
            List<dynamic> groups = [];
            if (state is GroupsJoiningState) {
              groups = state.groups;
            } else if (state is GroupsLeavingState) {
              groups = state.groups;
            } else if (state is GroupsCreatingState) {
              groups = state.groups;
            }
            
            return Stack(
              children: [
                // Show existing groups
                if (groups.isNotEmpty)
                  ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Text(
                              group.groupName.isNotEmpty ? group.groupName[0].toUpperCase() : 'G',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          title: Text(group.groupName),
                          subtitle: Text(group.memberCountText),
                          enabled: false, // Disable interaction during operation
                        ),
                      );
                    },
                  ),
                // Show loading overlay
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
          
          // Default state
          return const Center(
            child: Text(
              '初始化中...',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}