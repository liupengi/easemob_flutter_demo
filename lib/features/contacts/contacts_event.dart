import '../../core/base_event.dart';

/// Contacts events representing side effects
abstract class ContactsEvent extends BaseEvent {
  const ContactsEvent();
}

/// Event to navigate to chat with a contact
class NavigateToChatWithContactEvent extends ContactsEvent {
  final String userId;

  const NavigateToChatWithContactEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to show error message
class ShowContactsErrorEvent extends ContactsEvent {
  final String message;

  const ShowContactsErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Event to show success message
class ShowContactsSuccessEvent extends ContactsEvent {
  final String message;

  const ShowContactsSuccessEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
