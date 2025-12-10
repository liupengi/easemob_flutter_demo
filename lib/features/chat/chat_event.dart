import '../../core/base_event.dart';

/// 表示副作用的聊天事件
abstract class ChatEvent extends BaseEvent {
  const ChatEvent();
}

/// 滚动到聊天底部的事件
class ScrollToBottomEvent extends ChatEvent {
  const ScrollToBottomEvent();
}

/// Event to show error message
class ShowChatErrorEvent extends ChatEvent {
  final String message;

  const ShowChatErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// 消息发送成功的事件
class MessageSentSuccessEvent extends ChatEvent {
  const MessageSentSuccessEvent();
}
