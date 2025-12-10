import '../../core/base_event.dart';

/// 群组管理中表示副作用的群组事件
/// 
/// 这些事件触发不改变状态的 UI 操作，
/// 但为用户提供反馈或导航到其他屏幕。
abstract class GroupsEvent extends BaseEvent {
  const GroupsEvent();
}

/// Event to navigate to group chat page
class NavigateToGroupChatEvent extends GroupsEvent {
  /// 要打开聊天的群组ID
  final String groupId;

  const NavigateToGroupChatEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Event to show error message related to group operations
class ShowGroupsErrorEvent extends GroupsEvent {
  /// 要显示的错误消息
  final String message;

  const ShowGroupsErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Event to show success message for group operations
class ShowGroupsSuccessEvent extends GroupsEvent {
  /// 要显示的成功消息
  final String message;

  const ShowGroupsSuccessEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Event to show group creation dialog
class ShowCreateGroupDialogEvent extends GroupsEvent {
  const ShowCreateGroupDialogEvent();
}

/// Event to show group join dialog
class ShowJoinGroupDialogEvent extends GroupsEvent {
  const ShowJoinGroupDialogEvent();
}