import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat_repository.dart';
import '../../models/message_model.dart';
import 'chat_intent.dart';
import 'chat_state.dart';
import 'chat_event.dart';

/// BLoC for handling chat functionality
class ChatBloc extends Bloc<ChatIntent, ChatState> {
  final ChatRepository _chatRepository;
  final StreamController<ChatEvent> _eventController =
      StreamController<ChatEvent>.broadcast();
  StreamSubscription? _messageSubscription;

  String? _currentConversationId;

  Stream<ChatEvent> get eventStream => _eventController.stream;

  ChatBloc({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? ChatRepository(),
        super(const ChatInitialState()) {
    on<InitializeChatIntent>(_onInitializeChat);
    on<LoadMessagesIntent>(_onLoadMessages);
    on<SendTextMessageIntent>(_onSendTextMessage);
    on<RefreshMessagesIntent>(_onRefreshMessages);
    on<MarkMessagesAsReadIntent>(_onMarkMessagesAsRead);
  }

  Future<void> _onInitializeChat(
    InitializeChatIntent intent,
    Emitter<ChatState> emit,
  ) async {
    _currentConversationId = intent.conversationId;

    // Cancel previous message subscription
    _messageSubscription?.cancel();

    // Listen to new messages for this conversation
    _messageSubscription = _chatRepository.messageStream.listen(
      (message) {
        if (message.toUserId == _currentConversationId ||
            message.fromUserId == _currentConversationId) {
          add(const RefreshMessagesIntent());
          _eventController.add(const ScrollToBottomEvent());
        }
      },
    );

    emit(const ChatLoadingState());

    try {
      final messages =
          await _chatRepository.loadMessages(intent.conversationId);
      emit(ChatInitializedState(
        conversationId: intent.conversationId,
        messages: messages,
      ));
      _eventController.add(const ScrollToBottomEvent());
    } catch (e) {
      emit(ChatErrorState(
        conversationId: intent.conversationId,
        messages: [],
        errorMessage: 'Failed to initialize chat: $e',
      ));
      _eventController
          .add(ShowChatErrorEvent(message: 'Failed to load chat: $e'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessagesIntent intent,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null) return;

    emit(const ChatLoadingState());

    try {
      final messages =
          await _chatRepository.loadMessages(_currentConversationId!);
      emit(ChatLoadedState(
        conversationId: _currentConversationId!,
        messages: messages,
      ));
    } catch (e) {
      emit(ChatErrorState(
        conversationId: _currentConversationId!,
        messages: [],
        errorMessage: 'Failed to load messages: $e',
      ));
      _eventController
          .add(ShowChatErrorEvent(message: 'Failed to load messages: $e'));
    }
  }

  Future<void> _onSendTextMessage(
    SendTextMessageIntent intent,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null || intent.content.trim().isEmpty) return;

    final currentState = state;
    List<MessageModel> currentMessages = [];

    if (currentState is ChatLoadedState) {
      currentMessages = currentState.messages;
    } else if (currentState is ChatInitializedState) {
      currentMessages = currentState.messages;
    }

    emit(ChatSendingMessageState(
      conversationId: _currentConversationId!,
      messages: currentMessages,
    ));

    try {
      final sentMessage = await _chatRepository.sendTextMessage(
        _currentConversationId!,
        intent.content.trim(),
      );

      final updatedMessages = [...currentMessages, sentMessage];
      emit(ChatLoadedState(
        conversationId: _currentConversationId!,
        messages: updatedMessages,
      ));

      _eventController.add(const MessageSentSuccessEvent());
      _eventController.add(const ScrollToBottomEvent());
    } catch (e) {
      emit(ChatErrorState(
        conversationId: _currentConversationId!,
        messages: currentMessages,
        errorMessage: 'Failed to send message: $e',
      ));
      _eventController
          .add(ShowChatErrorEvent(message: 'Failed to send message: $e'));
    }
  }

  Future<void> _onRefreshMessages(
    RefreshMessagesIntent intent,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null) return;

    try {
      final messages =
          await _chatRepository.loadMessages(_currentConversationId!);
      emit(ChatLoadedState(
        conversationId: _currentConversationId!,
        messages: messages,
      ));
    } catch (e) {
      _eventController
          .add(ShowChatErrorEvent(message: 'Failed to refresh messages: $e'));
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsReadIntent intent,
    Emitter<ChatState> emit,
  ) async {
    if (_currentConversationId == null) return;

    try {
      await _chatRepository.markConversationAsRead(_currentConversationId!);
    } catch (e) {
      _eventController.add(
          ShowChatErrorEvent(message: 'Failed to mark messages as read: $e'));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _eventController.close();
    return super.close();
  }
}
