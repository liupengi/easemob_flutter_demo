import 'package:equatable/equatable.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

/// Group model representing chat groups/communities
/// 
/// This model contains all the information needed to display and manage
/// a group in the application, including basic info, member count, and permissions.
class GroupModel extends Equatable {
  /// Unique group identifier
  final String groupId;
  
  /// Display name of the group
  final String groupName;
  
  /// Optional group description
  final String? description;
  
  /// URL for group avatar/icon
  final String? avatarUrl;
  
  /// Current number of members in the group
  final int memberCount;
  
  /// Maximum number of members allowed
  final int maxMemberCount;
  
  /// Whether the current user is the group owner
  final bool isOwner;
  
  /// Whether the current user is an admin
  final bool isAdmin;
  
  /// Group creation timestamp
  final DateTime? createTime;
  
  /// Whether the group is public (can be searched and joined)
  final bool isPublic;

  const GroupModel({
    required this.groupId,
    required this.groupName,
    this.description,
    this.avatarUrl,
    this.memberCount = 0,
    this.maxMemberCount = 200,
    this.isOwner = false,
    this.isAdmin = false,
    this.createTime,
    this.isPublic = true,
  });

  /// Creates a GroupModel from EaseMob's EMGroup object
  factory GroupModel.fromEMGroup(EMGroup group) {
    return GroupModel(
      groupId: group.groupId,
      groupName: group.name ?? group.groupId,
      description: group.description,
      avatarUrl: null, // EaseMob doesn't provide avatar URL directly
      memberCount: group.memberCount ?? 0,
      maxMemberCount: group.maxUserCount ?? 200,
      isOwner: group.permissionType == EMGroupPermissionType.Owner,
      isAdmin: group.permissionType == EMGroupPermissionType.Admin,
      isPublic: group.settings?.style == EMGroupStyle.PublicOpenJoin ||
                group.settings?.style == EMGroupStyle.PublicJoinNeedApproval,
    );
  }

  /// Creates a copy of this model with updated fields
  GroupModel copyWith({
    String? groupId,
    String? groupName,
    String? description,
    String? avatarUrl,
    int? memberCount,
    int? maxMemberCount,
    bool? isOwner,
    bool? isAdmin,
    DateTime? createTime,
    bool? isPublic,
  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      memberCount: memberCount ?? this.memberCount,
      maxMemberCount: maxMemberCount ?? this.maxMemberCount,
      isOwner: isOwner ?? this.isOwner,
      isAdmin: isAdmin ?? this.isAdmin,
      createTime: createTime ?? this.createTime,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  /// Returns a formatted member count string (e.g., \"15/200\")
  String get memberCountText => '$memberCount/$maxMemberCount';
  
  /// Returns the role of the current user in this group
  String get userRole {
    if (isOwner) return 'Owner';
    if (isAdmin) return 'Admin';
    return 'Member';
  }

  @override
  List<Object?> get props => [
        groupId,
        groupName,
        description,
        avatarUrl,
        memberCount,
        maxMemberCount,
        isOwner,
        isAdmin,
        createTime,
        isPublic,
      ];
}