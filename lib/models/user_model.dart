import 'package:equatable/equatable.dart';

/// User model representing authenticated user data
class UserModel extends Equatable {
  final String userId;
  final String? nickname;
  final String? avatarUrl;
  final bool isOnline;

  const UserModel({
    required this.userId,
    this.nickname,
    this.avatarUrl,
    this.isOnline = false,
  });

  UserModel copyWith({
    String? userId,
    String? nickname,
    String? avatarUrl,
    bool? isOnline,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [userId, nickname, avatarUrl, isOnline];
}
