import '../../core/base_intent.dart';

/// Login intents representing user actions
abstract class LoginIntent extends BaseIntent {
  const LoginIntent();
}

/// Intent to perform login
class LoginSubmittedIntent extends LoginIntent {
  final String username;
  final String password;

  const LoginSubmittedIntent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

/// Intent to initialize login page
class LoginInitializedIntent extends LoginIntent {
  const LoginInitializedIntent();
}

/// Intent to navigate to registration
class NavigateToRegisterIntent extends LoginIntent {
  const NavigateToRegisterIntent();
}
