import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

// Import MVI components
import '../features/contacts/contacts_bloc.dart';
import '../features/contacts/contacts_intent.dart';
import '../features/contacts/contacts_state.dart';
import '../features/contacts/contacts_event.dart';
import '../chat_page.dart';
import '../features/chat/chat_bloc.dart';
import '../features/chat/chat_intent.dart';
//渲染逻辑，仍然是不可以变的！！
class ContactsView extends StatefulWidget {
  const ContactsView({super.key});
  
  @override
  State<StatefulWidget> createState() =>  _ContactsViewState();
}

// 状态管理者
class _ContactsViewState extends State<ContactsView>{
  @override
  void initState() {
    super.initState();
    
    // Load contacts on initialization
    context.read<ContactsBloc>().add(const LoadContactsIntent());
    
    // Listen to contact events
    context.read<ContactsBloc>().eventStream.listen((event) {
      if (event is NavigateToChatWithContactEvent) {
        _navigateToChat(event.userId);
      } else if (event is ShowContactsErrorEvent) {
        _showErrorMessage(event.message);
      } else if (event is ShowContactsSuccessEvent) {
        _showSuccessMessage(event.message);
      }
    });
  }

  void _navigateToChat(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ChatBloc()..add(InitializeChatIntent(conversationId: userId)),
          child: ChatPage(conversationId: userId),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
  Widget _itemForRow(BuildContext context, int index, contactModel){
    return InkWell(
      onTap: () {
        context.read<ContactsBloc>().add(
          StartChatWithContactIntent(userId: contactModel.userId),
        );
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                contactModel.nickname ?? contactModel.userId,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ContactsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ContactsBloc>().add(const RefreshContactsIntent());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          } else if (state is ContactsLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ContactsBloc>().add(const RefreshContactsIntent());
              },
              child: ListView.builder(
                itemBuilder: (context, index) => _itemForRow(context, index, state.contacts[index]),
                itemCount: state.contacts.length,
              ),
            );
          } else if (state is ContactsEmptyState) {
            return const Center(
              child: Text(
                '暂无联系人',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else if (state is ContactsAddingState || state is ContactsRemovingState) {
            return Stack(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    final contacts = state is ContactsAddingState 
                        ? state.contacts 
                        : (state as ContactsRemovingState).contacts;
                    return _itemForRow(context, index, contacts[index]);
                  },
                  itemCount: state is ContactsAddingState 
                      ? state.contacts.length 
                      : (state as ContactsRemovingState).contacts.length,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          
          return const Center(
            child: Text(
              '初始化中...',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

}
