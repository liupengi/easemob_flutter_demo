import 'dart:async';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

/// Repository for chat operations
class ChatRepository {
  static final ChatRepository _instance = ChatRepository._internal();
  factory ChatRepository() => _instance;
  ChatRepository._internal();

  final StreamController<MessageModel> _messageStreamController =
      StreamController<MessageModel>.broadcast();
  final StreamController<String> _conversationUpdateController =
      StreamController<String>.broadcast();

  Stream<MessageModel> get messageStream => _messageStreamController.stream;
  Stream<String> get conversationUpdateStream =>
      _conversationUpdateController.stream;

  /// Initialize chat listeners
  void initializeChatListeners() {
    // Add message listener
    EMClient.getInstance.chatManager.addEventHandler(
      "MVI_CHAT_HANDLER",
      EMChatEventHandler(
        onMessagesReceived: (messages) {
          for (var msg in messages) {
            final messageModel = MessageModel.fromEMMessage(msg);
            _messageStreamController.add(messageModel);
            _conversationUpdateController.add(msg.conversationId!);
          }
        },
        onConversationsUpdate: () {
          // Handle conversation updates
        },
      ),
    );

    // Add connection listener
    EMClient.getInstance.addConnectionEventHandler(
      "MVI_CONNECTION_HANDLER",
      EMConnectionEventHandler(
        onConnected: () {
          print("Connected to EaseMob server");
        },
        onDisconnected: () {
          print("Disconnected from EaseMob server");
        },
      ),
    );
  }

  /// Send text message
  Future<MessageModel> sendTextMessage(String toUserId, String content) async {
    final msg = EMMessage.createTxtSendMessage(
      targetId: toUserId,
      content: content,
      chatType: ChatType.Chat,
    );

    EMClient.getInstance.chatManager.sendMessage(msg);
    return MessageModel.fromEMMessage(msg);
  }

  /// Load messages for a conversation
  Future<List<MessageModel>> loadMessages(String conversationId,
      {int count = 50}) async {
    try {
      final conversation = await EMClient.getInstance.chatManager
          .getConversation(conversationId);
      if (conversation == null) return [];

      final messages =
          await conversation.loadMessages(startMsgId: "", loadCount: count);
      return messages?.map((msg) => MessageModel.fromEMMessage(msg)).toList() ??
          [];
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  /// Load conversations
  Future<List<ConversationModel>> loadConversations() async {
    try {
      List<EMConversation> conversations =
          await EMClient.getInstance.chatManager.loadAllConversations();

      if (conversations.isEmpty) {
        final serverResult =
            await EMClient.getInstance.chatManager.fetchConversationsByOptions(
          options: ConversationFetchOptions(pageSize: 50),
        );
        conversations = serverResult.data;
      }

      List<ConversationModel> conversationModels = [];
      for (var conv in conversations) {
        final lastMessage = await conv.latestMessage();
        final unreadCount = await conv.unreadCount();

        final model = ConversationModel.fromEMConversation(conv, lastMessage)
            .copyWith(unreadCount: unreadCount);
        conversationModels.add(model);
      }

      return conversationModels;
    } catch (e) {
      throw Exception('Failed to load conversations: $e');
    }
  }

  /// Mark conversation as read
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      final conversation = await EMClient.getInstance.chatManager
          .getConversation(conversationId);
      await conversation?.markAllMessagesAsRead();
    } catch (e) {
      throw Exception('Failed to mark conversation as read: $e');
    }
  }

  /// Dispose repository
  void dispose() {
    EMClient.getInstance.chatManager.removeEventHandler("MVI_CHAT_HANDLER");
    EMClient.getInstance.removeConnectionEventHandler("MVI_CONNECTION_HANDLER");
    _messageStreamController.close();
    _conversationUpdateController.close();
  }
}
