import '../../core/base_state.dart';

/// Home states representing the current state of home page
abstract class HomeState extends BaseState {
  const HomeState();
}

/// Initial state when home page is first loaded
class HomeInitialState extends HomeState {
  const HomeInitialState();
}

/// State representing current tab selection
class HomeTabChangedState extends HomeState {
  final int selectedTabIndex;

  const HomeTabChangedState({required this.selectedTabIndex});

  @override
  List<Object?> get props => [selectedTabIndex];
}

/// State when logout is in progress
class HomeLoggingOutState extends HomeState {
  final int selectedTabIndex;

  const HomeLoggingOutState({required this.selectedTabIndex});

  @override
  List<Object?> get props => [selectedTabIndex];
}
