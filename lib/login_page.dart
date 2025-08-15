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
      EMClient.getInstance.chatManager.addEventHandler(
        // EMChatEventHandler 对应的 key。
        "UNIQUE_HANDLER_ID",
        EMChatEventHandler(onConversationsUpdate: () {
          EMClient.getInstance.chatManager.loadAllConversations();
        }, onMessageReactionDidChange: (events) async {
          for (var i = 0; i < events.length; i++) {
            print(events[i].messageId);
            EMMessage? loadMessage = await EMClient.getInstance.chatManager
                .loadMessage(events[i].messageId);
            List<EMMessageReaction>? reactionList =
            await loadMessage?.reactionList();
            print("======================");
            for (var p = 0; p < reactionList!.length; p++) {
              print(reactionList?[p].reaction.toString());
            }
            print("======================");
          }
        }, onMessagesRecalledInfo: (recallMessageInfo) {
          for (var msg in recallMessageInfo) {
            print("onMessagesRecalledInfo======================" +
                msg.recallMessageId);
          }
        }, onMessagesReceived: (messages) async {
          for (var msg in messages) {
            print("onMessagesReceived======================${msg.toString()}");
// // 指定需要翻译的目标语言
//             List<String> languages = ["en"];
//             try {
//               // 执行消息内容的翻译，`textMessage`：收到的文本消息
//               EMMessage translatedMessage = await EMClient.getInstance.chatManager
//                   .translateMessage(msg: msg, languages: languages);
//
//               EMTextMessageBody body = translatedMessage.body as EMTextMessageBody;
//               print("translation: ${body.translations}");
//
//             } on EMError catch (e) {
//             }

            //  print(msg.status);

            // List<EMConversation> loadAllConversations =
            // await EMClient.getInstance.chatManager.loadAllConversations();
            // for (var i = 0; i < loadAllConversations.length; i++) {
            //   print(loadAllConversations[i].type);
            //   print("----------------------------------");
            // }

            switch (msg.body.type) {
              case MessageType.TXT:
              // {
              //   EMTextMessageBody body = msg.body as EMTextMessageBody;
              //   Map? map = msg.attributes;
              //   String combineID = '';
              //   print(map!['name']);
              //   _addLogToConsole(
              //     "receive text message: ${body.content}, from: ${msg.from}",
              //   );
              // }
                break;
              case MessageType.IMAGE:
                EMClient.getInstance.chatManager.downloadAttachment(msg);

                break;
              case MessageType.VIDEO:
                break;
              case MessageType.LOCATION:
                break;
              case MessageType.VOICE:
                break;
              case MessageType.FILE:
                break;
              case MessageType.CUSTOM:
                EMCustomMessageBody body = msg.body as EMCustomMessageBody;
                Map<String, String>? params = body.params;
                print(params?["name"]);
                print(params?["1111"]);

                break;
              case MessageType.CMD:
                {
                  // 当前回调中不会有 CMD 类型消息，CMD 类型消息通过 `EMChatEventHandler#onCmdMessagesReceived` 回调接收
                }
                break;
              case MessageType.COMBINE:
              // TODO: Handle this case.
            }
          }
        }, onMessagesRead: (messages) {
          for (var msg in messages) {
            print("onMessagesRead------${msg.hasReadAck}");
          }
        }, onGroupMessageRead: (messages) async {
          for (var msg in messages) {
            print("onMessagesRead------${msg.readCount}");
            EMCursorResult<EMGroupMessageAck> list =
            await EMClient.getInstance.chatManager.fetchGroupAcks("", "");
            List<EMGroupMessageAck> groupMessageAcklist = list.data;
          }
        }, onMessageContentChanged: (message, operatorId, operationTime) {
          print("onMessageContentChanged------${message.msgId}");
        }),
      );
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
