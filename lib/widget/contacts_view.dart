import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 导入 MVI 组件
import '../features/contacts/contacts_bloc.dart';
import '../features/contacts/contacts_intent.dart';
import '../features/contacts/contacts_state.dart';
import '../features/contacts/contacts_event.dart';
import '../features/groups/groups_bloc.dart';
import '../chat_page.dart';
import '../groups_page.dart';
import '../features/chat/chat_bloc.dart';
import '../features/chat/chat_intent.dart';
//渲染逻辑，仍然是不可以变的！！
/// 微信风格的联系人视图，顶部带有群组按钮
/// 
/// 该组件以微信风格的界面显示联系人列表，
/// 顶部带有包含群组导航的快捷访问按钮。
class ContactsView extends StatefulWidget {
  const ContactsView({super.key});
  
  @override
  State<StatefulWidget> createState() =>  _ContactsViewState();
}

// 状态管理者
/// 联系人视图的状态管理类
/// 
/// 管理联系人列表状态并处理用户交互，
/// 包括导航到聊天和群组。
class _ContactsViewState extends State<ContactsView>{
  @override
  void initState() {
    super.initState();
    
    // 初始化时加载联系人
    context.read<ContactsBloc>().add(const LoadContactsIntent());
    
    // 监听联系人事件
    context.read<ContactsBloc>().eventStream.listen((event) {
      if (event is NavigateToChatWithContactEvent) {
        _navigateToChat(event.userId);
      } else if (event is ShowContactsErrorEvent) {
        _showErrorMessage(event.message);
      } else if (event is ShowContactsSuccessEvent) {
        _showSuccessMessage(event.message);
      }
    });
  }

  /// 导航到与特定用户的聊天
  void _navigateToChat(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChatBloc()..add(InitializeChatIntent(conversationId: userId)),
          child: ChatPage(conversationId: userId),
        ),
      ),
    );
  }

  /// 导航到群组页面
  void _navigateToGroups() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => GroupsBloc(),
          child: const GroupsPage(),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// 构建微信风格的顶部快捷访问按钮
  Widget _buildQuickAccessButtons() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 群组按钮 - 微信风格
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.group,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: const Text(
              '群聊',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _navigateToGroups,
          ),
          Divider(
            height: 1,
            color: Colors.grey[200],
            indent: 56,
          ),
          // 如果需要，在这里添加更多快捷访问按钮
          // 新朋友按钮（占位符）
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: const Text(
              '新的朋友',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 导航到新朋友页面
              _showSuccessMessage('新朋友功能正在开发中');
            },
          ),
        ],
      ),
    );
  }

  /// 为联系人列表构建分组标题
  Widget _buildSectionHeader(String title) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  /// 构建具有微信风格设计的单个联系人项
  Widget _itemForRow(BuildContext context, int index, contactModel){
    return InkWell(
      onTap: () {
        context.read<ContactsBloc>().add(
          StartChatWithContactIntent(userId: contactModel.userId),
        );
      },
      child: Container(
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            radius: 22,
            child: Text(
              (contactModel.nickname ?? contactModel.userId).isNotEmpty 
                  ? (contactModel.nickname ?? contactModel.userId)[0].toUpperCase() 
                  : 'U',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                fontSize: 16,
              ),
            ),
          ),
          title: Text(
            contactModel.nickname ?? contactModel.userId,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: contactModel.isOnline 
              ? Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('在线', style: TextStyle(fontSize: 12)),
                  ],
                )
              : null,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoadingState) {
            return Column(
              children: [
                _buildQuickAccessButtons(),
                const SizedBox(height: 20),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          } else if (state is ContactsErrorState) {
            return Column(
              children: [
                _buildQuickAccessButtons(),
                Expanded(
                  child: Center(
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
                            context.read<ContactsBloc>().add(const RefreshContactsIntent());
                          },
                          child: const Text('重试'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ContactsLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ContactsBloc>().add(const RefreshContactsIntent());
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildQuickAccessButtons(),
                        const SizedBox(height: 10),
                        if (state.contacts.isNotEmpty)
                          _buildSectionHeader('联系人 (${state.contacts.length})'),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 1),
                          child: _itemForRow(context, index, state.contacts[index]),
                        );
                      },
                      childCount: state.contacts.length,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ContactsEmptyState) {
            return Column(
              children: [
                _buildQuickAccessButtons(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contacts_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无联系人',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '可以通过搜索添加新朋友',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ContactsAddingState || state is ContactsRemovingState) {
            return Column(
              children: [
                _buildQuickAccessButtons(),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          final contacts = state is ContactsAddingState 
                              ? state.contacts 
                              : (state as ContactsRemovingState).contacts;
                          return _itemForRow(context, index, contacts[index]);
                        },
                        itemCount: state is ContactsAddingState 
                            ? state.contacts.length 
                            : (state as ContactsRemovingState).contacts.length,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          
          return Column(
            children: [
              _buildQuickAccessButtons(),
              const Expanded(
                child: Center(
                  child: Text(
                    '初始化中...',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
