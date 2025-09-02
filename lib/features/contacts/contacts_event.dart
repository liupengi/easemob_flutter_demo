import '../../core/base_event.dart';

/// 表示副作用的联系人事件
abstract class ContactsEvent extends BaseEvent {
  const ContactsEvent();
}

/// 导航到与联系人聊天的事件
class NavigateToChatWithContactEvent extends ContactsEvent {
  final String userId;

  const NavigateToChatWithContactEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// 显示错误消息的事件
class ShowContactsErrorEvent extends ContactsEvent {
  final String message;

  const ShowContactsErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// 显示成功消息的事件
class ShowContactsSuccessEvent extends ContactsEvent {
  final String message;

  const ShowContactsSuccessEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
