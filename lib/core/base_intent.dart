import 'package:equatable/equatable.dart';

/// Base class for all intents in the MVI pattern
/// Intents represent user actions and events that trigger state changes
abstract class BaseIntent extends Equatable {
  const BaseIntent();

  @override
  List<Object?> get props => [];
}
