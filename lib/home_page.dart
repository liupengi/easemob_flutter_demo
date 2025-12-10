import 'package:easemob_flutter_demo/widget/contacts_view.dart';
import 'package:easemob_flutter_demo/widget/conversations_view.dart';
import 'package:easemob_flutter_demo/widget/me_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import MVI components
import 'features/home/home_bloc.dart';
import 'features/home/home_intent.dart';
import 'features/home/home_state.dart';
import 'features/home/home_event.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const InitializeHomeIntent()),
      child: const BottomNavigationDemo(),
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  const BottomNavigationDemo({super.key});
  
  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final List<Widget> _widgetOptions = <Widget>[
    const ConversationsView(),
    const ContactsView(),
    MeView(),
  ];

  @override
  void initState() {
    super.initState();
    
    // Listen to home events
    context.read<HomeBloc>().eventStream.listen((event) {
      if (event is NavigateToLoginEvent) {
        _navigateToLogin();
      } else if (event is ShowHomeErrorEvent) {
        _showErrorMessage(event.message);
      }
    });
  }

  void _onItemTapped(int index) {
    context.read<HomeBloc>().add(ChangeTabIntent(tabIndex: index));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'CHAT-DEMO')),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        int selectedIndex = 0;
        
        if (state is HomeTabChangedState) {
          selectedIndex = state.selectedTabIndex;
        } else if (state is HomeLoggingOutState) {
          selectedIndex = state.selectedTabIndex;
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'EaseMob 聊天',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  // 搜索功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('搜索功能正在开发中'),
                      backgroundColor: Colors.blue,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                ),
                onPressed: state is HomeLoggingOutState
                    ? null
                    : () => context.read<HomeBloc>().add(const LogoutIntent()),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined),
                  activeIcon: Icon(Icons.message),
                  label: '消息',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contacts_outlined),
                  activeIcon: Icon(Icons.contacts),
                  label: '通讯录',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: '我的',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
        );
      },
    );
  }
}