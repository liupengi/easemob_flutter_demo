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
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'EaseMob Demo')),
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
            title: const Text('EasemobDemo'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: state is HomeLoggingOutState
                    ? null
                    : () => context.read<HomeBloc>().add(const LogoutIntent()),
              ),
            ],
          ),
          body: Center(
            child: _widgetOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: '消息',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '通讯录',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: '我的',
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
