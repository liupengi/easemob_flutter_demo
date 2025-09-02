import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/contact_repository.dart';
import '../../models/contact_model.dart';
import 'contacts_intent.dart';
import 'contacts_state.dart';
import 'contacts_event.dart';

/// BLoC for handling contacts functionality
class ContactsBloc extends Bloc<ContactsIntent, ContactsState> {
  final ContactRepository _contactRepository;
  final StreamController<ContactsEvent> _eventController =
      StreamController<ContactsEvent>.broadcast();

  Stream<ContactsEvent> get eventStream => _eventController.stream;

  ContactsBloc({ContactRepository? contactRepository})
      : _contactRepository = contactRepository ?? ContactRepository(),
        super(const ContactsInitialState()) {
    on<LoadContactsIntent>(_onLoadContacts);
    on<RefreshContactsIntent>(_onRefreshContacts);
    on<AddContactIntent>(_onAddContact);
    on<RemoveContactIntent>(_onRemoveContact);
    on<StartChatWithContactIntent>(_onStartChatWithContact);
  }

  Future<void> _onLoadContacts(
    LoadContactsIntent intent,
    Emitter<ContactsState> emit,
  ) async {
    emit(const ContactsLoadingState());

    try {
      final contacts = await _contactRepository.loadContacts();

      if (contacts.isEmpty) {
        emit(const ContactsEmptyState());
      } else {
        emit(ContactsLoadedState(contacts: contacts));
      }
    } catch (e) {
      final errorMessage = 'Failed to load contacts: $e';
      emit(ContactsErrorState(errorMessage: errorMessage));
      _eventController.add(ShowContactsErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onRefreshContacts(
    RefreshContactsIntent intent,
    Emitter<ContactsState> emit,
  ) async {
    try {
      final contacts = await _contactRepository.loadContacts();

      if (contacts.isEmpty) {
        emit(const ContactsEmptyState());
      } else {
        emit(ContactsLoadedState(contacts: contacts));
      }
    } catch (e) {
      final errorMessage = 'Failed to refresh contacts: $e';
      _eventController.add(ShowContactsErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onAddContact(
    AddContactIntent intent,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    List<ContactModel> currentContacts = [];

    if (currentState is ContactsLoadedState) {
      currentContacts = currentState.contacts;
    }

    emit(ContactsAddingState(contacts: currentContacts));

    try {
      await _contactRepository.addContact(intent.userId, reason: intent.reason);
      _eventController.add(const ShowContactsSuccessEvent(
          message: 'Contact request sent successfully'));

      // Refresh contacts list
      add(const RefreshContactsIntent());
    } catch (e) {
      final errorMessage = 'Failed to add contact: $e';
      emit(ContactsErrorState(errorMessage: errorMessage));
      _eventController.add(ShowContactsErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onRemoveContact(
    RemoveContactIntent intent,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    List<ContactModel> currentContacts = [];

    if (currentState is ContactsLoadedState) {
      currentContacts = currentState.contacts;
    }

    emit(ContactsRemovingState(contacts: currentContacts));

    try {
      await _contactRepository.removeContact(intent.userId);
      _eventController.add(const ShowContactsSuccessEvent(
          message: 'Contact removed successfully'));

      // Refresh contacts list
      add(const RefreshContactsIntent());
    } catch (e) {
      final errorMessage = 'Failed to remove contact: $e';
      emit(ContactsErrorState(errorMessage: errorMessage));
      _eventController.add(ShowContactsErrorEvent(message: errorMessage));
    }
  }

  Future<void> _onStartChatWithContact(
    StartChatWithContactIntent intent,
    Emitter<ContactsState> emit,
  ) async {
    _eventController.add(NavigateToChatWithContactEvent(userId: intent.userId));
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}
