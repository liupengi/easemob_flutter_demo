import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

// Import MVI components
import 'features/chat/chat_bloc.dart';
import 'features/chat/chat_intent.dart';
import 'features/chat/chat_state.dart';
import 'features/chat/chat_event.dart';


class ChatPage extends StatefulWidget {
  final String conversationId;
  const ChatPage({super.key, required this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 输入框控制器
  final TextEditingController _textController = TextEditingController();
  // 滚动控制器（用于消息列表滚动到底部）
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialize chat
    context.read<ChatBloc>().add(InitializeChatIntent(conversationId: widget.conversationId));
    
    // Listen to chat events
    context.read<ChatBloc>().eventStream.listen((event) {
      if (event is ScrollToBottomEvent) {
        _scrollToBottom();
      } else if (event is ShowChatErrorEvent) {
        _showErrorMessage(event.message);
      } else if (event is MessageSentSuccessEvent) {
        _textController.clear();
      }
    });
  }

  // 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 发送消息
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(SendTextMessageIntent(content: text));
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 聊天对象标题（居中显示）
        title: Text(widget.conversationId),
        centerTitle: true,
        // 添加返回按钮
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoadingState || state is ChatInitialState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChatErrorState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) => _buildMessageItem(state.messages[index]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red[50],
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildInputArea(state is ChatSendingMessageState),
              ],
            );
          } else {
            List<dynamic> messages = [];
            bool isSending = false;
            
            if (state is ChatInitializedState) {
              messages = state.messages;
            } else if (state is ChatLoadedState) {
              messages = state.messages;
            } else if (state is ChatSendingMessageState) {
              messages = state.messages;
              isSending = true;
            }
            
            return Column(
              children: [
                // 消息列表
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => _buildMessageItem(messages[index]),
                  ),
                ),
                // 底部输入区域
                _buildInputArea(isSending),
              ],
            );
          }
        },
      ),
    );
  }

  // 构建消息气泡
  Widget _buildMessageItem(dynamic message) {
    // 区分发送方和接收方
    final isMe = message.direction;
    final content = message.content;
    
    // 创建消息气泡组件
    Widget messageBubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7, // 最大宽度限制
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe == MessageDirection.SEND ? const Color(0xFF95EC69) : Colors.white, // 微信绿/白色气泡
          borderRadius: BorderRadius.circular(18),
          // 接收方气泡添加左侧尖角
          border: isMe != MessageDirection.RECEIVE ? Border.all(color: Colors.grey[200]!) : null,
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isMe == MessageDirection.SEND ? Colors.black : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );

    // 添加长按手势识别
    messageBubble = GestureDetector(
      onLongPress: () => _showMessageActions(message),
      child: messageBubble,
    );
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        // 发送的消息右对齐，接收的左对齐
        mainAxisAlignment: isMe == MessageDirection.SEND ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // 接收方显示头像（发送方不需要）
          if (isMe == MessageDirection.RECEIVE) ...[
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/me.png'),
            ),
            const SizedBox(width: 8),
          ],
          // 消息气泡
          messageBubble,
          if (isMe == MessageDirection.SEND) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/me.png'), // 发送方头像（可替换为自己的头像）
            ),
          ],
        ],
      ),
    );
  }

  // 显示消息操作菜单
  void _showMessageActions(dynamic message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.thumb_up),
                title: const Text('点赞'),
                onTap: () {
                  Navigator.pop(context);
                  // 在这里添加点赞逻辑
                  _handleMessageAddReaction(message, '{\"type\":0,\"from\":\"c57821be-6a0a-4c4c-b8cd-42c0cdef92fd\",\"to\":\"c57821be-6a0a-4c4c-b8cd-42c0cdef92fd\",\"content\":\"test111\",\"timestamp\":1760683012366}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('取消点赞'),
                onTap: () {
                  Navigator.pop(context);
                  // 在这里添加回复逻辑
                  _handleMessageRemoveReaction(message, '{\"type\":0,\"from\":\"c57821be-6a0a-4c4c-b8cd-42c0cdef92fd\",\"to\":\"c57821be-6a0a-4c4c-b8cd-42c0cdef92fd\",\"content\":\"test111\",\"timestamp\":1760683012366}');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 处理消息操作
  void _handleMessageAddReaction(dynamic message, String action) {
    // 调用 SDK 添加 Reaction

    EMClient.getInstance.chatManager.addReaction(
      messageId: message.messageId,
      reaction: action,
    ).then((value) {
      print('添加 Reaction 成功');
    }).catchError((error) {
      print('添加 Reaction 失败: $error');
    });

  }


  void _handleMessageRemoveReaction(dynamic message, String action) {
    EMClient.getInstance.chatManager.removeReaction(
      messageId: message.messageId,
      reaction: action,
    ).then((value) {
      print('删除 Reaction 成功');
    }).catchError((error) {
      print('删除 Reaction 失败: $error');
    });
  }

  // 构建底部输入区域
  Widget _buildInputArea(bool isSending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // 输入框
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isSending,
              decoration: InputDecoration(
                hintText: "输入消息...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              maxLines: null, // 支持多行输入
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ),
          const SizedBox(width: 8),
          // 发送按钮
          isSending
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
