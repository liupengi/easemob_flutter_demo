import 'package:equatable/equatable.dart';

/// Base class for all states in the MVI pattern
/// States represent the current state of the UI
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// Common state for loading scenarios
class LoadingState extends BaseState {
  const LoadingState();
}

/// Common state for error scenarios
class ErrorState extends BaseState {
  final String message;
  final dynamic error;

  const ErrorState({required this.message, this.error});

  @override
  List<Object?> get props => [message, error];
}
