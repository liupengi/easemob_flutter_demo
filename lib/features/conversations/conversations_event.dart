import '../../core/base_event.dart';

/// 表示副作用的会话事件
abstract class ConversationsEvent extends BaseEvent {
  const ConversationsEvent();
}

/// Event to navigate to chat page
class NavigateToChatEvent extends ConversationsEvent {
  final String conversationId;

  const NavigateToChatEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

/// Event to show error message
class ShowConversationsErrorEvent extends ConversationsEvent {
  final String message;

  const ShowConversationsErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
