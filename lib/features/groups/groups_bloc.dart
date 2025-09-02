import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/group_repository.dart';
import '../../models/group_model.dart';
import 'groups_intent.dart';
import 'groups_state.dart';
import 'groups_event.dart';

/// 处理群组管理功能的 BLoC
/// 
/// 该 BLoC 管理所有与群组相关的操作，包括加载群组、
/// 加入/退出群组、创建新群组和处理群组交互。
/// 它遵循 MVI 模式，通过处理 Intent 并发出适当的状态。
class GroupsBloc extends Bloc<GroupsIntent, GroupsState> {
  final GroupRepository _groupRepository;
  final StreamController<GroupsEvent> _eventController = StreamController<GroupsEvent>.broadcast();

  /// UI 监听的事件流（导航、消息等）
  Stream<GroupsEvent> get eventStream => _eventController.stream;

  GroupsBloc({GroupRepository? groupRepository}) 
      : _groupRepository = groupRepository ?? GroupRepository(),
        super(const GroupsInitialState()) {
    
    // 为每种 Intent 类型注册事件处理程序
    on<LoadGroupsIntent>(_onLoadGroups);
    on<RefreshGroupsIntent>(_onRefreshGroups);
    on<JoinGroupIntent>(_onJoinGroup);
    on<LeaveGroupIntent>(_onLeaveGroup);
    on<CreateGroupIntent>(_onCreateGroup);
    on<SelectGroupIntent>(_onSelectGroup);
  }

  /// Handles loading groups from local storage and server
  Future<void> _onLoadGroups(
    LoadGroupsIntent intent,
    Emitter<GroupsState> emit,
  ) async {
    emit(const GroupsLoadingState());
    
    try {
      final groups = await _groupRepository.loadGroups();
      
      if (groups.isEmpty) {
        emit(const GroupsEmptyState());
      } else {
        emit(GroupsLoadedState(groups: groups));
      }
    } catch (e) {
      final errorMessage = 'Failed to load groups: $e';
      emit(GroupsErrorState(errorMessage: errorMessage));
      _eventController.add(ShowGroupsErrorEvent(message: errorMessage));
    }
  }

  /// Handles refreshing groups from server
  Future<void> _onRefreshGroups(
    RefreshGroupsIntent intent,
    Emitter<GroupsState> emit,
  ) async {
    try {
      final groups = await _groupRepository.loadGroups();
      
      if (groups.isEmpty) {
        emit(const GroupsEmptyState());
      } else {
        emit(GroupsLoadedState(groups: groups));
      }
    } catch (e) {
      final errorMessage = 'Failed to refresh groups: $e';
      _eventController.add(ShowGroupsErrorEvent(message: errorMessage));
    }
  }

  /// Handles joining a group
  Future<void> _onJoinGroup(
    JoinGroupIntent intent,
    Emitter<GroupsState> emit,
  ) async {
    final currentState = state;
    List<GroupModel> currentGroups = [];
    
    if (currentState is GroupsLoadedState) {
      currentGroups = currentState.groups;
    }

    emit(GroupsJoiningState(
      groups: currentGroups,
      joiningGroupId: intent.groupId,
    ));

    try {
      await _groupRepository.joinGroup(intent.groupId, reason: intent.reason);
      _eventController.add(const ShowGroupsSuccessEvent(
        message: 'Successfully joined group! You may need to wait for approval.',
      ));
      
      // Refresh groups list to show the newly joined group
      add(const RefreshGroupsIntent());
    } catch (e) {
      emit(GroupsLoadedState(groups: currentGroups));
      final errorMessage = 'Failed to join group: $e';
      _eventController.add(ShowGroupsErrorEvent(message: errorMessage));
    }
  }

  /// Handles leaving a group
  Future<void> _onLeaveGroup(
    LeaveGroupIntent intent,
    Emitter<GroupsState> emit,
  ) async {
    final currentState = state;
    List<GroupModel> currentGroups = [];
    
    if (currentState is GroupsLoadedState) {
      currentGroups = currentState.groups;
    }

    emit(GroupsLeavingState(
      groups: currentGroups,
      leavingGroupId: intent.groupId,
    ));

    try {
      await _groupRepository.leaveGroup(intent.groupId);
      _eventController.add(const ShowGroupsSuccessEvent(
        message: 'Successfully left the group.',
      ));
      
      // Refresh groups list to remove the left group
      add(const RefreshGroupsIntent());
    } catch (e) {
      emit(GroupsLoadedState(groups: currentGroups));
      final errorMessage = 'Failed to leave group: $e';
      _eventController.add(ShowGroupsErrorEvent(message: errorMessage));
    }
  }

  /// Handles creating a new group
  Future<void> _onCreateGroup(
    CreateGroupIntent intent,
    Emitter<GroupsState> emit,
  ) async {
    final currentState = state;
    List<GroupModel> currentGroups = [];
    
    if (currentState is GroupsLoadedState) {
      currentGroups = currentState.groups;
    }

    emit(GroupsCreatingState(groups: currentGroups));

    try {
      final newGroup = await _groupRepository.createGroup(
        groupName: intent.groupName,
        description: intent.description,
        inviteUserIds: intent.inviteUserIds,
        isPublic: intent.isPublic,
      );
      
      _eventController.add(ShowGroupsSuccessEvent(
        message: 'Successfully created group \"${newGroup.groupName}\"!',
      ));
      
      // Refresh groups list to show the newly created group
      add(const RefreshGroupsIntent());
    } catch (e) {
      emit(GroupsLoadedState(groups: currentGroups));
      final errorMessage = 'Failed to create group: $e';
      _eventController.add(ShowGroupsErrorEvent(message: errorMessage));
    }
  }

  /// Handles selecting a group (navigate to group chat)
  Future<void> _onSelectGroup(
    SelectGroupIntent intent,
    Emitter<GroupsState> emit,
  ) async {
    _eventController.add(NavigateToGroupChatEvent(groupId: intent.groupId));
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}