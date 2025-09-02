import '../../core/base_event.dart';

/// Home events representing side effects
abstract class HomeEvent extends BaseEvent {
  const HomeEvent();
}

/// Event to navigate back to login
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
