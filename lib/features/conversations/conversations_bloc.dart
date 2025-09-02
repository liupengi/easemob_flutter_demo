import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/chat_repository.dart';
import 'conversations_intent.dart';
import 'conversations_state.dart';
import 'conversations_event.dart';

/// BLoC for handling conversations functionality
class ConversationsBloc extends Bloc<ConversationsIntent, ConversationsState> {
  final ChatRepository _chatRepository;
  final StreamController<ConversationsEvent> _eventController =
      StreamController<ConversationsEvent>.broadcast();
  StreamSubscription? _conversationUpdateSubscription;

  Stream<ConversationsEvent> get eventStream => _eventController.stream;

  ConversationsBloc({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? ChatRepository(),
        super(const ConversationsInitialState()) {
    on<LoadConversationsIntent>(_onLoadConversations);
    on<RefreshConversationsIntent>(_onRefreshConversations);
    on<SelectConversationIntent>(_onSelectConversation);
    on<MarkConversationAsReadIntent>(_onMarkConversationAsRead);

    // Initialize chat listeners
    _chatRepository.initializeChatListeners();

    // Listen to conversation updates
    _conversationUpdateSubscription =
        _chatRepository.conversationUpdateStream.listen(
      (conversationId) {
        // Refresh conversations when new messages arrive
        add(const RefreshConversationsIntent());
      },
    );
  }

  Future<void> _onLoadConversations(
    LoadConversationsIntent intent,
    Emitter<ConversationsState> emit,
  ) async {
    emit(const ConversationsLoadingState());

    try {
      final conversations = await _chatRepository.loadConversations();

      if (conversations.isEmpty) {
        emit(const ConversationsEmptyState());
      } else {
        emit(ConversationsLoadedState(conversations: conversations));
      }
    } catch (e) {
      final errorMessage = 'Failed to load conversations: $e';
      emit(ConversationsErrorState(errorMessage: errorMessage));
      _eventController.add(ShowConversationsErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onRefreshConversations(
    RefreshConversationsIntent intent,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      final conversations = await _chatRepository.loadConversations();

      if (conversations.isEmpty) {
        emit(const ConversationsEmptyState());
      } else {
        emit(ConversationsLoadedState(conversations: conversations));
      }
    } catch (e) {
      final errorMessage = 'Failed to refresh conversations: $e';
      _eventController.add(ShowConversationsErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onSelectConversation(
    SelectConversationIntent intent,
    Emitter<ConversationsState> emit,
  ) async {
    _eventController
        .add(NavigateToChatEvent(conversationId: intent.conversationId));
  }

  Future<void> _onMarkConversationAsRead(
    MarkConversationAsReadIntent intent,
    Emitter<ConversationsState> emit,
  ) async {
    try {
      await _chatRepository.markConversationAsRead(intent.conversationId);
      // Refresh conversations to update unread count
      add(const RefreshConversationsIntent());
    } catch (e) {
      _eventController.add(
          ShowConversationsErrorEvent(message: 'Failed to mark as read: $e'));
    }
  }

  @override
  Future<void> close() {
    _conversationUpdateSubscription?.cancel();
    _eventController.close();
    return super.close();
  }
}
