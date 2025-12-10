import 'package:easemob_flutter_demo/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'dart:core';

import 'package:intl/intl.dart';

// 导入 BLoCs（业务逻辑组件，管理不同模块的状态）
import 'features/login/login_bloc.dart';
import 'features/home/home_bloc.dart';
import 'features/conversations/conversations_bloc.dart';
import 'features/contacts/contacts_bloc.dart';
import 'features/chat/chat_bloc.dart';
import 'features/groups/groups_bloc.dart';

// 导入仓库（数据访问层，封装API调用和本地存储逻辑）
import 'repositories/auth_repository.dart';
import 'repositories/chat_repository.dart';
import 'repositories/contact_repository.dart';
import 'repositories/group_repository.dart';

/// 应用入口函数
void main() {
  runApp(const MyApp());
}

/// 应用根组件
/// 负责初始化全局状态管理(BLoC)和应用基础配置
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 多BLoC提供者：集中管理应用所需的所有BLoC，提供跨组件状态共享
    return MultiBlocProvider(
      providers: [
        // 登录状态BLoC：管理用户认证相关状态（登录/注册/登出）
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            authRepository: AuthRepository(),
          ),
        ),
        // 首页状态BLoC：管理首页导航和全局用户状态
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            authRepository: AuthRepository(),
          ),
        ),
        // 会话列表BLoC：管理聊天会话数据（加载/更新/删除会话）
        BlocProvider<ConversationsBloc>(
          create: (context) => ConversationsBloc(
            chatRepository: ChatRepository(),
          ),
        ),
        // 联系人BLoC：管理联系人列表（加载/搜索/添加联系人）
        BlocProvider<ContactsBloc>(
          create: (context) => ContactsBloc(
            contactRepository: ContactRepository(),
          ),
        ),
        // 聊天BLoC：管理单个聊天窗口状态（发送/接收消息、消息状态）
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            chatRepository: ChatRepository(),
          ),
        ),
        // 群组BLoC：管理群组相关操作（创建/加入/退出群组、群聊消息）
        BlocProvider<GroupsBloc>(
          create: (context) => GroupsBloc(
            groupRepository: GroupRepository(),
          ),
        ),
      ],
      // 应用核心配置：设置主题、标题和初始页面
      child: MaterialApp(
        title: 'CHAT', // 应用标题
        theme: ThemeData(
          primarySwatch: Colors.blue, // 应用主题色
        ),
        home: const MyHomePage(title: 'Chat Demo'), // 初始显示的首页
      ),
    );
  }
}