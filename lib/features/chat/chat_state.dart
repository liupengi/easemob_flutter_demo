import '../../core/base_state.dart';
import '../../models/message_model.dart';

/// Chat states representing the current state of chat
abstract class ChatState extends BaseState {
  const ChatState();
}

/// Initial state when chat page is first loaded
class ChatInitialState extends ChatState {
  const ChatInitialState();
}

/// State when chat is initialized with conversation info
class ChatInitializedState extends ChatState {
  final String conversationId;
  final List<MessageModel> messages;

  const ChatInitializedState({
    required this.conversationId,
    required this.messages,
  });

  @override
  List<Object?> get props => [conversationId, messages];
}

/// State when messages are being loaded
class ChatLoadingState extends ChatState {
  const ChatLoadingState();
}

/// State when messages are successfully loaded
class ChatLoadedState extends ChatState {
  final String conversationId;
  final List<MessageModel> messages;

  const ChatLoadedState({
    required this.conversationId,
    required this.messages,
  });

  @override
  List<Object?> get props => [conversationId, messages];
}

/// State when sending a message
class ChatSendingMessageState extends ChatState {
  final String conversationId;
  final List<MessageModel> messages;

  const ChatSendingMessageState({
    required this.conversationId,
    required this.messages,
  });

  @override
  List<Object?> get props => [conversationId, messages];
}

/// State when there's an error in chat
class ChatErrorState extends ChatState {
  final String conversationId;
  final List<MessageModel> messages;
  final String errorMessage;

  const ChatErrorState({
    required this.conversationId,
    required this.messages,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [conversationId, messages, errorMessage];
}
