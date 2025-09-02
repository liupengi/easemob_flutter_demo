import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../chat_page.dart';

// 导入 MVI 组件
import '../features/conversations/conversations_bloc.dart';
import '../features/conversations/conversations_intent.dart';
import '../features/conversations/conversations_state.dart';
import '../features/conversations/conversations_event.dart';
import '../features/chat/chat_bloc.dart';
import '../features/chat/chat_intent.dart';

// 会话列表视图组件
class ConversationsView extends StatefulWidget {
  const ConversationsView({super.key});
  
  @override
  State<StatefulWidget> createState() => _ConversationsViewState();
}

// 状态管理类
class _ConversationsViewState extends State<ConversationsView> {
  // 头像资源路径常量
  static const String _avatarAsset = 'assets/images/me.png';

  @override
  void initState() {
    super.initState();
    
  // 初始化时加载会话
    context.read<ConversationsBloc>().add(const LoadConversationsIntent());
    
    // 监听会话事件
    context.read<ConversationsBloc>().eventStream.listen((event) {
      if (event is NavigateToChatEvent) {
        _navigateToChat(context, event.conversationId);
      } else if (event is ShowConversationsErrorEvent) {
        _showErrorMessage(event.message);
      }
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  // 构建会话列表项
  Widget _buildConversationItem(BuildContext context, int index, conversationModel) {
    return InkWell(
      onTap: () {
        context.read<ConversationsBloc>().add(
          SelectConversationIntent(conversationId: conversationModel.conversationId),
        );
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListTile(
          // 头像
          leading: Container(
            padding: const EdgeInsets.all(5),
            child: Image.asset(
              _avatarAsset,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          // 标题（会话ID/名称）
          title: Text(
            conversationModel.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 副标题（最新消息内容）
          subtitle: conversationModel.lastMessage != null
              ? Text(
                  conversationModel.lastMessage!.content,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                )
              : const Text('无消息', style: TextStyle(fontSize: 14)),
          trailing: conversationModel.unreadCount > 0
              ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${conversationModel.unreadCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  // 导航到聊天页面
  void _navigateToChat(BuildContext context, String conversationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChatBloc()..add(InitializeChatIntent(conversationId: conversationId)),
          child: ChatPage(conversationId: conversationId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<ConversationsBloc, ConversationsState>(
        builder: (context, state) {
          if (state is ConversationsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ConversationsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConversationsBloc>().add(const RefreshConversationsIntent());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          } else if (state is ConversationsLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ConversationsBloc>().add(const RefreshConversationsIntent());
              },
              child: ListView.builder(
                itemBuilder: (context, index) => _buildConversationItem(context, index, state.conversations[index]),
                itemCount: state.conversations.length,
              ),
            );
          } else if (state is ConversationsEmptyState) {
            return const Center(
              child: Text(
                '暂无会话',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          
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