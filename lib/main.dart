import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

const appkey = 'easemob-demo#support';
const currentUserId = 'lp';
const currentUserPwd = '1';
const chatterId = 'lp1';
void main() {
  ChatUIKit.instance
      .init(options: Options(appKey: appkey, autoLogin: false))
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: (settings) {
        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                if (await ChatUIKit.instance.isLoginBefore()) {
                  ChatUIKit.instance.logout().then((value) => setState(() {}));
                } else {
                  ChatUIKit.instance
                      .loginWithPassword(
                      userId: currentUserId, password: currentUserPwd)
                      .then((value) => setState(() {}));
                }
              },
              child: false
                  ? const Text('Logout')
                  : const Text('Login'),
            ),
            if (true)
              const Expanded(child: ChatPage()),
          ],
        ),
      ),
    );
  }
}





class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MessagesView(profile: ChatUIKitProfile.contact(id: chatterId));
  }
}
