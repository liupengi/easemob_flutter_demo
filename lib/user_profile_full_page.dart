import 'package:flutter/material.dart';
import 'user_profile_page.dart';

/// 用户资料的完整页面版本
/// 
/// 该页面提供用户资料的完整页面实现，
/// 包含自己的 Scaffold 和导航栏。
class UserProfileFullPage extends StatelessWidget {
  const UserProfileFullPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('个人资料'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: const SingleChildScrollView(
        child: UserProfilePage(),
      ),
    );
  }
}