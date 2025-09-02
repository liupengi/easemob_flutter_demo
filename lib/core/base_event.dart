import 'package:equatable/equatable.dart';

/// Base class for all events in the MVI pattern
/// Events represent side effects that don't change state but trigger UI actions
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// Common event for navigation
class NavigationEvent extends BaseEvent {
  final String route;
  final dynamic arguments;

  const NavigationEvent({required this.route, this.arguments});

  @override
  List<Object?> get props => [route, arguments];
}

/// Common event for showing messages/toasts
class MessageEvent extends BaseEvent {
  final String message;
  final MessageType type;

  const MessageEvent({required this.message, required this.type});

  @override
  List<Object?> get props => [message, type];
}

enum MessageType { success, error, info, warning }
