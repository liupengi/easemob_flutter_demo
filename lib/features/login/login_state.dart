import '../../core/base_state.dart';
import '../../models/user_model.dart';

/// Login states representing the current state of login process
abstract class LoginState extends BaseState {
  const LoginState();
}

/// Initial state when login page is first loaded
class LoginInitialState extends LoginState {
  const LoginInitialState();
}

/// State when login is in progress
class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

/// State when login is successful
class LoginSuccessState extends LoginState {
  final UserModel user;

  const LoginSuccessState({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when login fails
class LoginFailureState extends LoginState {
  final String errorMessage;

  const LoginFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
