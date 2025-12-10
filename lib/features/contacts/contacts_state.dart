import '../../core/base_state.dart';
import '../../models/contact_model.dart';

/// Contacts states representing the current state of contacts
abstract class ContactsState extends BaseState {
  const ContactsState();
}

/// Initial state when contacts page is first loaded
class ContactsInitialState extends ContactsState {
  const ContactsInitialState();
}

/// State when contacts are being loaded
class ContactsLoadingState extends ContactsState {
  const ContactsLoadingState();
}

/// State when contacts are successfully loaded
class ContactsLoadedState extends ContactsState {
  final List<ContactModel> contacts;

  const ContactsLoadedState({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}

/// State when there's an error loading contacts
class ContactsErrorState extends ContactsState {
  final String errorMessage;

  const ContactsErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

/// State when contacts list is empty
class ContactsEmptyState extends ContactsState {
  const ContactsEmptyState();
}

/// State when adding a contact
class ContactsAddingState extends ContactsState {
  final List<ContactModel> contacts;

  const ContactsAddingState({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}

/// State when removing a contact
class ContactsRemovingState extends ContactsState {
  final List<ContactModel> contacts;

  const ContactsRemovingState({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}
