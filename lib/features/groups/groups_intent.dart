import '../../core/base_intent.dart';

/// Groups intents representing user actions in group management
/// 
/// These intents handle all user interactions related to group functionality
/// including loading groups, joining/leaving groups, and creating new groups.
abstract class GroupsIntent extends BaseIntent {
  const GroupsIntent();
}

/// Intent to load all groups that the user is a member of
class LoadGroupsIntent extends GroupsIntent {
  const LoadGroupsIntent();
}

/// Intent to refresh the groups list from server
class RefreshGroupsIntent extends GroupsIntent {
  const RefreshGroupsIntent();
}

/// Intent to join a group by group ID
class JoinGroupIntent extends GroupsIntent {
  final String groupId;
  final String? reason;

  const JoinGroupIntent({
    required this.groupId,
    this.reason,
  });

  @override
  List<Object?> get props => [groupId, reason];
}

/// Intent to leave a group
class LeaveGroupIntent extends GroupsIntent {
  final String groupId;

  const LeaveGroupIntent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Intent to create a new group
class CreateGroupIntent extends GroupsIntent {
  final String groupName;
  final String? description;
  final List<String> inviteUserIds;
  final bool isPublic;

  const CreateGroupIntent({
    required this.groupName,
    this.description,
    this.inviteUserIds = const [],
    this.isPublic = true,
  });

  @override
  List<Object?> get props => [groupName, description, inviteUserIds, isPublic];
}

/// Intent to select a group (navigate to group chat)
class SelectGroupIntent extends GroupsIntent {
  final String groupId;

  const SelectGroupIntent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}