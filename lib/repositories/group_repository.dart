import 'dart:async';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../models/group_model.dart';

/// Repository for group operations
/// 
/// This repository abstracts all group-related operations from the EaseMob SDK,
/// providing a clean interface for the business logic layer to interact with
/// group functionality without directly depending on the SDK.
class GroupRepository {
  static final GroupRepository _instance = GroupRepository._internal();
  factory GroupRepository() => _instance;
  GroupRepository._internal();

  /// Load all groups that the current user is a member of
  /// 
  /// Returns a list of groups from local storage first, then fetches
  /// from server if local data is empty or outdated.
  Future<List<GroupModel>> loadGroups() async {
    try {
      // First try to get groups from local storage
      List<EMGroup> localGroups = await EMClient.getInstance.groupManager.getJoinedGroups();
      
      // If no local groups, fetch from server
      if (localGroups.isEmpty) {
        List<EMGroup> serverResult = await EMClient.getInstance.groupManager
            .fetchJoinedGroupsFromServer(pageSize: 20,pageNum: 0,needMemberCount: false,needRole: false);
        localGroups = serverResult;
      }

      // Convert EMGroup objects to GroupModel objects
      return localGroups.map((group) => GroupModel.fromEMGroup(group)).toList();
    } catch (e) {
      throw Exception('Failed to load groups: $e');
    }
  }

  /// Join a group by group ID
  /// 
  /// [groupId] - The unique identifier of the group to join
  /// [reason] - Optional reason for joining (for groups requiring approval)
  Future<void> joinGroup(String groupId, {String? reason}) async {
    try {
      await EMClient.getInstance.groupManager.requestToJoinPublicGroup(
        groupId,
        reason: reason,
      );
    } on EMError catch (e) {
      throw Exception('Failed to join group: ${e.description}');
    }
  }

  /// Leave a group
  /// 
  /// [groupId] - The unique identifier of the group to leave
  Future<void> leaveGroup(String groupId) async {
    try {
      await EMClient.getInstance.groupManager.leaveGroup(groupId);
    } on EMError catch (e) {
      throw Exception('Failed to leave group: ${e.description}');
    }
  }

  /// Create a new group
  /// 
  /// [groupName] - Name of the group to create
  /// [description] - Optional description for the group
  /// [inviteUserIds] - List of user IDs to invite to the group
  /// [isPublic] - Whether the group should be public or private
  /// 
  /// Returns the created group model
  Future<GroupModel> createGroup({
    required String groupName,
    String? description,
    List<String> inviteUserIds = const [],
    bool isPublic = true,
  }) async {
    try {
      // Configure group options
      EMGroupOptions options = EMGroupOptions(
        style: isPublic ? EMGroupStyle.PublicOpenJoin : EMGroupStyle.PrivateMemberCanInvite,
        maxCount: 200,
        inviteNeedConfirm: !isPublic,
      );

      // Create the group
      EMGroup group = await EMClient.getInstance.groupManager.createGroup(
        groupName: groupName,
        desc: description ?? '',
        inviteMembers: inviteUserIds,
        inviteReason: 'Welcome to $groupName',
        options: options,
      );

      return GroupModel.fromEMGroup(group);
    } on EMError catch (e) {
      throw Exception('Failed to create group: ${e.description}');
    }
  }

  /// Get detailed information about a specific group
  /// 
  /// [groupId] - The unique identifier of the group
  Future<GroupModel> getGroupInfo(String groupId) async {
    try {
      EMGroup group = await EMClient.getInstance.groupManager.fetchGroupInfoFromServer(groupId);
      return GroupModel.fromEMGroup(group);
    } on EMError catch (e) {
      throw Exception('Failed to get group info: ${e.description}');
    }
  }

  /// Search for public groups by name
  /// 
  /// [keyword] - Search term to find groups
  /// [pageSize] - Number of results to return (default: 20)
  Future<List<GroupModel>> searchPublicGroups(String keyword, {int pageSize = 20}) async {
    try {
      EMCursorResult<EMGroupInfo> result = await EMClient.getInstance.groupManager
          .fetchPublicGroupsFromServer(pageSize: pageSize);
      
      // Filter by keyword (since SDK doesn't support keyword search directly)
      List<EMGroupInfo> filteredGroups = result.data.where((groupInfo) {
        return groupInfo.name?.toLowerCase().contains(keyword.toLowerCase()) ?? false;
      }).toList();

      // Convert to GroupModel (note: EMGroupInfo has limited data)
      return filteredGroups.map((groupInfo) => GroupModel(
        groupId: groupInfo.groupId,
        groupName: groupInfo.name ?? groupInfo.groupId,
        description: groupInfo.name ?? '', // EMGroupInfo doesn't have description field
        memberCount: 0, // EMGroupInfo doesn't have memberCount field
        isPublic: true,
      )).toList();
    } on EMError catch (e) {
      throw Exception('Failed to search groups: ${e.description}');
    }
  }

  /// Get list of group members
  /// 
  /// [groupId] - The unique identifier of the group
  /// [pageSize] - Number of members to fetch (default: 50)
  Future<List<String>> getGroupMembers(String groupId, {int pageSize = 50}) async {
    try {
      EMCursorResult<String> result = await EMClient.getInstance.groupManager
          .fetchMemberListFromServer(groupId, pageSize: pageSize);
      return result.data;
    } on EMError catch (e) {
      throw Exception('Failed to get group members: ${e.description}');
    }
  }
}