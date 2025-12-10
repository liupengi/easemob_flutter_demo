import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'home_intent.dart';
import 'home_state.dart';
import 'home_event.dart';

/// BLoC for handling home navigation functionality
class HomeBloc extends Bloc<HomeIntent, HomeState> {
  final AuthRepository _authRepository;
  final StreamController<HomeEvent> _eventController =
      StreamController<HomeEvent>.broadcast();

  Stream<HomeEvent> get eventStream => _eventController.stream;

  HomeBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const HomeInitialState()) {
    on<InitializeHomeIntent>(_onInitializeHome);
    on<ChangeTabIntent>(_onChangeTab);
    on<LogoutIntent>(_onLogout);
  }

  Future<void> _onInitializeHome(
    InitializeHomeIntent intent,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeTabChangedState(selectedTabIndex: 0));
  }

  Future<void> _onChangeTab(
    ChangeTabIntent intent,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeTabChangedState(selectedTabIndex: intent.tabIndex));
  }

  Future<void> _onLogout(
    LogoutIntent intent,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    int currentTab = 0;

    if (currentState is HomeTabChangedState) {
      currentTab = currentState.selectedTabIndex;
    }

    emit(HomeLoggingOutState(selectedTabIndex: currentTab));

    try {
      await _authRepository.logout();
      _eventController.add(const NavigateToLoginEvent());
    } catch (e) {
      emit(HomeTabChangedState(selectedTabIndex: currentTab));
      _eventController.add(ShowHomeErrorEvent(message: 'Logout failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}
