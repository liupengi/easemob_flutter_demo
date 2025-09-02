import '../../core/base_event.dart';

/// Login events representing side effects
abstract class LoginEvent extends BaseEvent {
  const LoginEvent();
}

/// Event to navigate to home page after successful login
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
