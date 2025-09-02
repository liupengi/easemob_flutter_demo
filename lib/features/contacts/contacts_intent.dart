import '../../core/base_intent.dart';

/// Contacts intents representing user actions
abstract class ContactsIntent extends BaseIntent {
  const ContactsIntent();
}

/// Intent to load contacts
class LoadContactsIntent extends ContactsIntent {
  const LoadContactsIntent();
}

/// Intent to refresh contacts
class RefreshContactsIntent extends ContactsIntent {
  const RefreshContactsIntent();
}

/// Intent to add a new contact
class AddContactIntent extends ContactsIntent {
  final String userId;
  final String? reason;

  const AddContactIntent({
    required this.userId,
    this.reason,
  });

  @override
  List<Object?> get props => [userId, reason];
}

/// Intent to remove a contact
class RemoveContactIntent extends ContactsIntent {
  final String userId;

  const RemoveContactIntent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Intent to start chat with a contact
class StartChatWithContactIntent extends ContactsIntent {
  final String userId;

  const StartChatWithContactIntent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
