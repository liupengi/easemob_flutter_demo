import 'package:equatable/equatable.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

/// Contact model representing user contacts
class ContactModel extends Equatable {
  final String userId;
  final String? nickname;
  final String? avatarUrl;
  final bool isOnline;

  const ContactModel({
    required this.userId,
    this.nickname,
    this.avatarUrl,
    this.isOnline = false,
  });

  factory ContactModel.fromEMContact(EMContact contact) {
    return ContactModel(
      userId: contact.userId,
      nickname: contact.userId, // Can be enhanced with user info
      isOnline: false, // Will be updated with presence info
    );
  }

  ContactModel copyWith({
    String? userId,
    String? nickname,
    String? avatarUrl,
    bool? isOnline,
  }) {
    return ContactModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [userId, nickname, avatarUrl, isOnline];
}
