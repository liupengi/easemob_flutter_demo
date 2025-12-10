import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'login_intent.dart';
import 'login_state.dart';
import 'login_event.dart';

/// BLoC for handling login functionality
class LoginBloc extends Bloc<LoginIntent, LoginState> {
  final AuthRepository _authRepository;
  final StreamController<LoginEvent> _eventController =
      StreamController<LoginEvent>.broadcast();

  Stream<LoginEvent> get eventStream => _eventController.stream;

  LoginBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const LoginInitialState()) {
    on<LoginInitializedIntent>(_onInitialized);
    on<LoginSubmittedIntent>(_onLoginSubmitted);
    on<NavigateToRegisterIntent>(_onNavigateToRegister);
  }

  Future<void> _onInitialized(
    LoginInitializedIntent intent,
    Emitter<LoginState> emit,
  ) async {
    try {
      await _authRepository.initializeSDK();
      emit(const LoginInitialState());
    } catch (e) {
      emit(LoginFailureState(errorMessage: 'SDK initialization failed: $e'));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedIntent intent,
    Emitter<LoginState> emit,
  ) async {
    if (intent.username.isEmpty || intent.password.isEmpty) {
      emit(const LoginFailureState(
          errorMessage: 'Username and password cannot be empty'));
      _eventController.add(const ShowLoginErrorEvent(
          message: 'Username and password cannot be empty'));
      return;
    }

    emit(const LoginLoadingState());

    try {
      final user =
          await _authRepository.login(intent.username, intent.password);
      emit(LoginSuccessState(user: user));
      _eventController.add(const NavigateToHomeEvent());
    } catch (e) {
      final errorMessage = 'Login failed: $e';
      emit(LoginFailureState(errorMessage: errorMessage));
      _eventController.add(ShowLoginErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onNavigateToRegister(
    NavigateToRegisterIntent intent,
    Emitter<LoginState> emit,
  ) async {
    // Handle navigation to register - this could emit an event
    // For now, we'll just keep the current state
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}
