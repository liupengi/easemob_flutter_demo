import '../../core/base_intent.dart';

/// Chat intents representing user actions
abstract class ChatIntent extends BaseIntent {
  const ChatIntent();
}

/// Intent to initialize chat with a specific conversation
class InitializeChatIntent extends ChatIntent {
  final String conversationId;

  const InitializeChatIntent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// Intent to load messages for the current conversation
class LoadMessagesIntent extends ChatIntent {
  const LoadMessagesIntent();
}

/// Intent to send a text message
class SendTextMessageIntent extends ChatIntent {
  final String content;

  const SendTextMessageIntent({required this.content});

  @override
  List<Object?> get props => [content];
}

/// Intent to refresh messages
class RefreshMessagesIntent extends ChatIntent {
  const RefreshMessagesIntent();
}

/// Intent to mark messages as read
class MarkMessagesAsReadIntent extends ChatIntent {
  const MarkMessagesAsReadIntent();
}
