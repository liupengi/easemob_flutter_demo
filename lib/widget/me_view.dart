import 'package:flutter/material.dart';

// 导入页面
import '../user_profile_page.dart';
import '../test_functions_page.dart';

/// 显示用户资料的现代化“我的”视图，带有简洁的界面
/// 
/// 该组件提供微信风格的“我的”页面，包含用户资料
/// 和快捷访问设置和测试功能。
class MeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeViewState();
}

/// “我的”视图的状态管理
class _MeViewState extends State<MeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 用户资料部分
            const UserProfilePage(),
            
            // 开发者工具部分
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.developer_mode,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      '\u5f00\u53d1\u8005\u5de5\u5177',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: const Text(
                      'SDK \u6d4b\u8bd5\u529f\u80fd',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TestFunctionsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}