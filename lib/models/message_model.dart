import 'package:equatable/equatable.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

/// Message model representing chat messages
class MessageModel extends Equatable {
  final String messageId;
  final String content;
  final String fromUserId;
  final String toUserId;
  final DateTime timestamp;
  final MessageType messageType;
  final MessageDirection direction;
  final MessageStatus status;

  const MessageModel({
    required this.messageId,
    required this.content,
    required this.fromUserId,
    required this.toUserId,
    required this.timestamp,
    required this.messageType,
    required this.direction,
    required this.status,
  });

  factory MessageModel.fromEMMessage(EMMessage message) {
    String content = '';
    if (message.body.type == MessageType.TXT) {
      content = (message.body as EMTextMessageBody).content;
    } else if (message.body.type == MessageType.IMAGE) {
      content = '[图片消息]';
    } else if (message.body.type == MessageType.VOICE) {
      content = '[语音消息]';
    } else if (message.body.type == MessageType.VIDEO) {
      content = '[视频消息]';
    } else if (message.body.type == MessageType.FILE) {
      content = '[文件消息]';
    } else {
      content = '[未知消息]';
    }

    return MessageModel(
      messageId: message.msgId,
      content: content,
      fromUserId: message.from ?? '',
      toUserId: message.to ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(message.serverTime),
      messageType: message.body.type,
      direction: message.direction,
      status: message.status,
    );
  }

  @override
  List<Object?> get props => [
        messageId,
        content,
        fromUserId,
        toUserId,
        timestamp,
        messageType,
        direction,
        status,
      ];
}
