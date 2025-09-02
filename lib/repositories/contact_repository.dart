import 'dart:async';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../models/contact_model.dart';

/// Repository for contact operations
class ContactRepository {
  static final ContactRepository _instance = ContactRepository._internal();
  factory ContactRepository() => _instance;
  ContactRepository._internal();

  /// Load all contacts
  Future<List<ContactModel>> loadContacts() async {
    try {
      List<EMContact> contacts =
          await EMClient.getInstance.contactManager.getAllContacts();

      if (contacts.isEmpty) {
        contacts = await EMClient.getInstance.contactManager.fetchAllContacts();
      }

      return contacts
          .map((contact) => ContactModel.fromEMContact(contact))
          .toList();
    } catch (e) {
      throw Exception('Failed to load contacts: $e');
    }
  }

  /// Add contact
  Future<void> addContact(String userId, {String? reason}) async {
    try {
      await EMClient.getInstance.contactManager
          .addContact(userId, reason: reason);
    } on EMError catch (e) {
      throw Exception('Failed to add contact: ${e.description}');
    }
  }

  /// Remove contact
  Future<void> removeContact(String userId,
      {bool keepConversation = false}) async {
    try {
      await EMClient.getInstance.contactManager
          .deleteContact(userId, keepConversation: keepConversation);
    } on EMError catch (e) {
      throw Exception('Failed to remove contact: ${e.description}');
    }
  }

  /// Accept contact invitation
  Future<void> acceptContactInvitation(String userId) async {
    try {
      await EMClient.getInstance.contactManager.acceptInvitation(userId);
    } on EMError catch (e) {
      throw Exception('Failed to accept invitation: ${e.description}');
    }
  }

  /// Decline contact invitation
  Future<void> declineContactInvitation(String userId) async {
    try {
      await EMClient.getInstance.contactManager.declineInvitation(userId);
    } on EMError catch (e) {
      throw Exception('Failed to decline invitation: ${e.description}');
    }
  }
}
