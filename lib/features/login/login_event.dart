import '../../core/base_event.dart';

/// 表示副作用的登录事件
abstract class LoginEvent extends BaseEvent {
  const LoginEvent();
}

/// 登录成功后导航到主页的事件
class NavigateToHomeEvent extends LoginEvent {
  const NavigateToHomeEvent();
}

/// Event to show login error message
class ShowLoginErrorEvent extends LoginEvent {
  final String message;

  const ShowLoginErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
