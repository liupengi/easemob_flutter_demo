import 'package:easemob_flutter_demo/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'dart:core';

import 'package:intl/intl.dart';

// Import BLoCs
import 'features/login/login_bloc.dart';
import 'features/home/home_bloc.dart';
import 'features/conversations/conversations_bloc.dart';
import 'features/contacts/contacts_bloc.dart';
import 'features/chat/chat_bloc.dart';

// Import repositories
import 'repositories/auth_repository.dart';
import 'repositories/chat_repository.dart';
import 'repositories/contact_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authRepository: AuthRepository(),
          ),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            authRepository: AuthRepository(),
          ),
        ),
        BlocProvider<ConversationsBloc>(
          create: (context) => ConversationsBloc(
            chatRepository: ChatRepository(),
          ),
        ),
        BlocProvider<ContactsBloc>(
          create: (context) => ContactsBloc(
            contactRepository: ContactRepository(),
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            chatRepository: ChatRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'EaseMob Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'EaseMob Demo'),
      ),
    );
  }
}
