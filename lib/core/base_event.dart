import 'package:equatable/equatable.dart';

/// MVI 模式中所有 Event 的基类
/// 
/// Event 表示不改变状态但触发 UI 操作的副作用，
/// 例如导航、显示对话框或显示消息。
/// 
/// Event 用于不应在状态中持续存在的一次性操作。
/// 
/// 示例：
/// ```dart
/// class ShowErrorMessageEvent extends BaseEvent {
///   final String message;
///   
///   const ShowErrorMessageEvent({required this.message});
/// }
/// ```
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// 导航的通用事件
/// 用于在不改变当前状态的情况下导航到不同的屏幕
class NavigationEvent extends BaseEvent {
  final String route;
  final dynamic arguments;

  const NavigationEvent({required this.route, this.arguments});

  @override
  List<Object?> get props => [route, arguments];
}

/// 显示消息/提示的通用事件
/// 用于向用户显示临时消息
class MessageEvent extends BaseEvent {
  final String message;
  final MessageType type;

  const MessageEvent({required this.message, required this.type});

  @override
  List<Object?> get props => [message, type];
}

/// 可以显示的消息类型
enum MessageType { 
  success,  // 绿色成功消息
  error,    // 红色错误消息
  info,     // 蓝色信息消息
  warning   // 橙色警告消息
}
