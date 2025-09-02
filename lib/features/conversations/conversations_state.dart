import '../../core/base_state.dart';
import '../../models/conversation_model.dart';

/// Conversations states representing the current state of conversations
abstract class ConversationsState extends BaseState {
  const ConversationsState();
}

/// Initial state when conversations page is first loaded
class ConversationsInitialState extends ConversationsState {
  const ConversationsInitialState();
}

/// State when conversations are being loaded
class ConversationsLoadingState extends ConversationsState {
  const ConversationsLoadingState();
}

/// State when conversations are successfully loaded
class ConversationsLoadedState extends ConversationsState {
  final List<ConversationModel> conversations;

  const ConversationsLoadedState({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

/// State when there's an error loading conversations
class ConversationsErrorState extends ConversationsState {
  final String errorMessage;

  const ConversationsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// State when conversations are empty
class ConversationsEmptyState extends ConversationsState {
  const ConversationsEmptyState();
}
