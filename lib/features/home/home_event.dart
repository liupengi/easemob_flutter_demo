import '../../core/base_event.dart';

/// 表示副作用的主页事件
abstract class HomeEvent extends BaseEvent {
  const HomeEvent();
}

/// 返回登录的事件
class NavigateToLoginEvent extends HomeEvent {
  const NavigateToLoginEvent();
}

/// Event to show error message
class ShowHomeErrorEvent extends HomeEvent {
  final String message;

  const ShowHomeErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
