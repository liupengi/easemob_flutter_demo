import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 导入 MVI 组件
import 'features/home/home_bloc.dart';
import 'features/home/home_intent.dart';
import 'repositories/auth_repository.dart';

/// 显示当前用户信息的用户资料页面
/// 
/// 该页面显示已登录用户的资料信息，并提供
/// 账户管理、设置和退出登录功能的选项。
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthRepository _authRepository = AuthRepository();
  String? currentUserId;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  /// 加载当前用户信息
  void _loadUserInfo() async {
    final loggedIn = await _authRepository.isLoggedIn();
    setState(() {
      currentUserId = _authRepository.getCurrentUserId();
      isLoggedIn = loggedIn;
    });
  }

  /// Handle logout action
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('退出登录'),
          content: const Text('确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<HomeBloc>().add(const LogoutIntent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('退出'),
            ),
          ],
        );
      },
    );
  }

  /// Build profile header with avatar and basic info
  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue[100],
            child: Text(
              currentUserId?.isNotEmpty == true 
                  ? currentUserId![0].toUpperCase() 
                  : 'U',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUserId ?? '未知用户',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isLoggedIn ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLoggedIn ? '在线' : '离线',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit button (placeholder)
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('编辑功能正在开发中'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  /// Build settings menu items
  Widget _buildSettingsMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.account_circle_outlined,
            title: '账号与安全',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('账号与安全功能正在开发中'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: '消息通知',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('消息通知功能正在开发中'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: '隐私设置',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('隐私设置功能正在开发中'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: '语言设置',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('语言设置功能正在开发中'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build additional menu items
  Widget _buildAdditionalMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.help_outline,
            title: '帮助与反馈',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('帮助与反馈功能正在开发中'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: '关于应用',
            onTap: () {
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  /// Build individual menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey[700],
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// Build menu divider
  Widget _buildMenuDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 56,
      endIndent: 16,
    );
  }

  /// Show about dialog
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'EaseMob Flutter Demo',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.chat,
          size: 36,
          color: Colors.blue[800],
        ),
      ),
      children: [
        const SizedBox(height: 16),
        const Text(
          'A comprehensive Flutter chat application demonstrating real-time messaging capabilities using EaseMob SDK with modern MVI architecture pattern.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Text(
          'Features:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '• Real-time messaging\n'
          '• Conversation management\n'
          '• Contact management\n'
          '• Group chat support\n'
          '• MVI architecture pattern',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileHeader(),
        _buildSettingsMenu(),
        _buildAdditionalMenu(),
        // Logout button
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '退出登录',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}