import 'package:equatable/equatable.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'message_model.dart';

/// Conversation model representing chat conversations
class ConversationModel extends Equatable {
  final String conversationId;
  final String displayName;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime? lastActiveTime;
  final EMConversationType conversationType;

  const ConversationModel({
    required this.conversationId,
    required this.displayName,
    this.lastMessage,
    this.unreadCount = 0,
    this.lastActiveTime,
    required this.conversationType,
  });

  factory ConversationModel.fromEMConversation(
      EMConversation conversation, EMMessage? lastMessage) {
    return ConversationModel(
      conversationId: conversation.id,
      displayName: conversation.id, // Can be enhanced with user nicknames
      lastMessage:
          lastMessage != null ? MessageModel.fromEMMessage(lastMessage) : null,
      unreadCount: 0, // Will be set separately
      conversationType: conversation.type,
    );
  }

  ConversationModel copyWith({
    String? conversationId,
    String? displayName,
    MessageModel? lastMessage,
    int? unreadCount,
    DateTime? lastActiveTime,
    EMConversationType? conversationType,
  }) {
    return ConversationModel(
      conversationId: conversationId ?? this.conversationId,
      displayName: displayName ?? this.displayName,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      lastActiveTime: lastActiveTime ?? this.lastActiveTime,
      conversationType: conversationType ?? this.conversationType,
    );
  }

  @override
  List<Object?> get props => [
        conversationId,
        displayName,
        lastMessage,
        unreadCount,
        lastActiveTime,
        conversationType,
      ];
}
