import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'chat_presenter.dart';
import 'home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  String _username = "";
  String _password = "";
  @override
  void initState() {
    super.initState();
    ChatPresenter().initSDK();
    ChatPresenter().addChatListener();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 100),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter username"),
              onChanged: (username) => _username = username,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter password"),
              onChanged: (password) => _password = password,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _signIn,
                    child: const Text("登录"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _signIn() async {

    if (_username.isEmpty || _password.isEmpty) {
      return;
    }



    try {
      await EMClient.getInstance.login("lp","1");
      // EMClient.getInstance.chatManager.addMessageEvent("UNIQUE_HANDLER_ID", EMMessageReactionEvent(
      //
      // ));
      _startHomePage();

    } on EMError catch (e) {
      print("${e.code}---------${e.description}");
      if(e.code == 200){
        _startHomePage();
      }
    }
  }

  void _startHomePage(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return new HomePage();
    }));
  }


  @override
  void dispose() {
    // 移除消息状态监听
    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    // 移除收消息监听
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");

    super.dispose();
  }
}
