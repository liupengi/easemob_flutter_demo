import '../../core/base_intent.dart';

/// Home intents representing user actions
abstract class HomeIntent extends BaseIntent {
  const HomeIntent();
}

/// Intent to change tab in bottom navigation
class ChangeTabIntent extends HomeIntent {
  final int tabIndex;

  const ChangeTabIntent({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

/// Intent to initialize home page
class InitializeHomeIntent extends HomeIntent {
  const InitializeHomeIntent();
}

/// Intent to logout
class LogoutIntent extends HomeIntent {
  const LogoutIntent();
}
