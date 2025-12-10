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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // 头像
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                _avatarAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[800],
                    ),
                  );
                },
              ),
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              Text(
                conversationModel.lastMessage != null
                    ? conversationModel.lastMessage!.content
                    : '暂无消息',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              if (conversationModel.lastMessage != null)
                Text(
                  _formatTime(conversationModel.lastMessage!.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (conversationModel.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${conversationModel.unreadCount > 99 ? '99+' : conversationModel.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  // 格式化时间显示
  String _formatTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    
    // 如果是今天的消息，只显示时间
    if (now.day == dateTime.day && 
        now.month == dateTime.month && 
        now.year == dateTime.year) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    
    // 如果是昨天的消息，显示"昨天"
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.day == dateTime.day && 
        yesterday.month == dateTime.month && 
        yesterday.year == dateTime.year) {
      return '昨天';
    }
    
    // 其他情况显示日期
    return '${dateTime.month}/${dateTime.day}';
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
                      context.read<ConversationsBloc>().add(const RefreshConversationsIntent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
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
                padding: const EdgeInsets.only(top: 12),
                itemBuilder: (context, index) => _buildConversationItem(context, index, state.conversations[index]),
                itemCount: state.conversations.length,
              ),
            );
          } else if (state is ConversationsEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '暂无会话',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '开始与好友聊天吧',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
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