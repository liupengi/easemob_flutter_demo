import '../../core/base_intent.dart';

/// Conversations intents representing user actions
abstract class ConversationsIntent extends BaseIntent {
  const ConversationsIntent();
}

/// Intent to load conversations
class LoadConversationsIntent extends ConversationsIntent {
  const LoadConversationsIntent();
}

/// Intent to refresh conversations
class RefreshConversationsIntent extends ConversationsIntent {
  const RefreshConversationsIntent();
}

/// Intent to select a conversation
class SelectConversationIntent extends ConversationsIntent {
  final String conversationId;

  const SelectConversationIntent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// Intent to mark conversation as read
class MarkConversationAsReadIntent extends ConversationsIntent {
  final String conversationId;

  const MarkConversationAsReadIntent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
