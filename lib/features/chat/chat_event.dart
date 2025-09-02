import '../../core/base_event.dart';

/// Chat events representing side effects
abstract class ChatEvent extends BaseEvent {
  const ChatEvent();
}

/// Event to scroll to bottom of chat
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

/// Event to show message sent successfully
class MessageSentSuccessEvent extends ChatEvent {
  const MessageSentSuccessEvent();
}
