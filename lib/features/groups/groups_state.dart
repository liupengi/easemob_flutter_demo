import '../../core/base_state.dart';
import '../../models/group_model.dart';

/// Groups states representing the current state of group management
/// 
/// These states control what the UI displays for group-related screens
/// and provide all data needed to render the groups interface.
abstract class GroupsState extends BaseState {
  const GroupsState();
}

/// Initial state when groups page is first loaded
class GroupsInitialState extends GroupsState {
  const GroupsInitialState();
}

/// State when groups are being loaded from server or local storage
class GroupsLoadingState extends GroupsState {
  const GroupsLoadingState();
}

/// State when groups are successfully loaded and ready to display
class GroupsLoadedState extends GroupsState {
  /// List of groups the user is a member of
  final List<GroupModel> groups;

  const GroupsLoadedState({required this.groups});

  @override
  List<Object?> get props => [groups];
}

/// State when there's an error loading or managing groups
class GroupsErrorState extends GroupsState {
  /// Error message to display to the user
  final String errorMessage;

  const GroupsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// State when the user has no groups
class GroupsEmptyState extends GroupsState {
  const GroupsEmptyState();
}

/// State when joining a group is in progress
class GroupsJoiningState extends GroupsState {
  /// Current list of groups (to maintain UI state)
  final List<GroupModel> groups;
  /// ID of the group being joined
  final String joiningGroupId;

  const GroupsJoiningState({
    required this.groups,
    required this.joiningGroupId,
  });

  @override
  List<Object?> get props => [groups, joiningGroupId];
}

/// State when leaving a group is in progress
class GroupsLeavingState extends GroupsState {
  /// Current list of groups (to maintain UI state)
  final List<GroupModel> groups;
  /// ID of the group being left
  final String leavingGroupId;

  const GroupsLeavingState({
    required this.groups,
    required this.leavingGroupId,
  });

  @override
  List<Object?> get props => [groups, leavingGroupId];
}

/// State when creating a new group is in progress
class GroupsCreatingState extends GroupsState {
  /// Current list of groups (to maintain UI state)
  final List<GroupModel> groups;

  const GroupsCreatingState({required this.groups});

  @override
  List<Object?> get props => [groups];
}