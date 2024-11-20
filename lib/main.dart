import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'flutter demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  String _username = "";
  String _password = "";
  String _messageContent = "";
  String _chatId = "";
  late String _thumbnaillocalPath =
      "/storage/emulated/0/Android/data/com.appbyme.app194772/1137220225110285#demo/files/p0/p1/thumb_480e9d90-409b-11ee-a5ac-a7aad79ca0bb";

  final List<String> _logText = [];
  String _string = "";

  @override
  void initState() {
    super.initState();
    _initSDK();
    _addChatListener();
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
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: _signOut,
                    child: const Text("创建群组"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: _button,
                    child: const Text("发送消息"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _joinChatRoom,
                    child: const Text("获取本地消息"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _joinChatRoom,
                    child: const Text("加入聊天室"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: createAccount,
                    child: const Text("注册用户"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter the username you want to send"),
              onChanged: (chatId) => _chatId = chatId,
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Enter content"),
              onChanged: (msg) => _messageContent = msg,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _sendMessage,
              child: const Text("SEND TEXT"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initSDK() async {
    EMOptions options = EMOptions(
      appKey: "easemob-demo#support",
      autoLogin: false,
      debugMode: true,
      requireAck: true,
    );
    await EMClient.getInstance.init(options);
    // 通知 SDK UI 已准备好。该方法执行后才会收到 `EMChatRoomEventHandler`、`EMContactEventHandler` 和 `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
  }

  void _addChatListener() {
    EMClient.getInstance.groupManager.addEventHandler("identifier",
        EMGroupEventHandler(
          onMemberJoinedFromGroup: (groupid,member){
            print("有用户加入群组了" + groupid + "====" + member);
          },
          onAutoAcceptInvitationFromGroup:(groupId , inviter,inviteMessage){

            print("您加入了群组" + groupId + "====" + inviter+"====="+inviteMessage.toString());
          },

        )
    );



// 添加聊天室事件监听
    EMClient.getInstance.chatRoomManager.addEventHandler(
      "identifier",
      EMChatRoomEventHandler(
        onMemberJoinedFromChatRoom: (roomId, participant, ext) {
          print("有用户加入聊天室了" + participant + "====" + ext.toString());
        },
      ),
    );
    EMClient.getInstance.startCallback();

    EMClient.getInstance.addConnectionEventHandler(
        "UNIQUE_HANDLER_ID",
        EMConnectionEventHandler(
          onConnected: () {
            _addLogToConsole("onConnected---------");
            print("-------------------------onConnected");
          },
          onDisconnected: () {
            _addLogToConsole("onDisconnected---------");
          },
        ));

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      // EMChatEventHandler 对应的 key。
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessageReactionDidChange: (events) async {
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
        },
        onMessagesReceived: (messages) async {
          for (var msg in messages) {
            print("======================");
            print(msg.chatType);
            print("======================");

            List<EMConversation> loadAllConversations =
            await EMClient.getInstance.chatManager.loadAllConversations();
            for (var i = 0; i < loadAllConversations.length; i++) {
              print(loadAllConversations[i].type);
              print("----------------------------------");
            }

            switch (msg.body.type) {
              case MessageType.TXT:
                {
                  EMTextMessageBody body = msg.body as EMTextMessageBody;
                  Map? map = msg.attributes;
                  String combineID = '';
                  print(map!['name']);
                  _addLogToConsole(
                    "receive text message: ${body.content}, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.IMAGE:
                EMClient.getInstance.chatManager.downloadAttachment(msg);

                {
                  _addLogToConsole(
                    "receive image message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VIDEO:
                {
                  _addLogToConsole(
                    "receive video message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.LOCATION:
                {
                  _addLogToConsole(
                    "receive location message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VOICE:
                {
                  print("收到了语音消息");
                  _addLogToConsole(
                    "receive voice message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.FILE:
                {
                  _addLogToConsole(
                    "receive image message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CUSTOM:
                EMCustomMessageBody body = msg.body as EMCustomMessageBody;
                Map<String, String>? params = body.params;
                print(params?["name"]);
                print(params?["1111"]);

                {
                  _addLogToConsole(
                    "receive custom message, from: ${msg.from}",
                  );
                }
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
        },
      ),
    );
    // EMClient.getInstance.chatManager.addMessageEvent("UNIQUE_HANDLER_ID", EMMessageReactionEvent(
    //
    // ));

    EMClient.getInstance.chatRoomManager.addEventHandler(
        "UNIQUE_HANDLER_ID",
        EMChatRoomEventHandler(
          onRemovedFromChatRoom: (roomId, roomName, participant, reason) => {
            // ignore: avoid_print
            print("----------------------------------------------"),
            print(reason)
          },
        ));

    // 添加消息状态变更监听
    EMClient.getInstance.chatManager.addMessageEvent(
      // ChatMessageEvent 对应的 key。
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {
            _addLogToConsole("send message succeed");
            Map? map = msg.attributes;
            print("------------------成功");
            print(map);
          },
          onProgress: (msgId, progress) {
            _addLogToConsole("send message succeed");
          },
          onError: (msgId, msg, error) {
            _addLogToConsole(
              "send message failed, code: ${error.code}, desc: ${error.description}",
            );
          },
        ));
  }

  void _signIn() async {
    if (_username.isEmpty || _password.isEmpty) {
      _addLogToConsole("username or password is null");
      return;
    }

    try {
      await EMClient.getInstance.login(_username, _password);
      _addLogToConsole("sign in succeed, username: $_username");
    } on EMError catch (e) {
      _addLogToConsole("sign in failed, e: ${e.code} , ${e.description}");
    }
  }

  void _signOut() async {
    try {
      await EMClient.getInstance.groupManager
          .requestToJoinPublicGroup("264950694084612");
    } on EMError catch (e) {
      print(e.toString());
    }

    //EMClient.getInstance.chatManager.pinConversation(conversationId: "10000005", isPinned: true);

    // EMClient.getInstance.chatManager.fetchConversation(
    //     cursor:"",
    //     pageSize:1);
    // EMCursorResult<String> list = await EMClient.getInstance.chatRoomManager.fetchChatRoomMembers("roomId");
    // List<String> data = list.data;

    // EMClient.getInstance.pushManager.updatePushNickname("111111");

    // List<EMConversation> conversations = [];

    // EMConversation? emConversation= await EMClient.getInstance.chatManager.getConversation("234992452042757");
    //conversations.add(emConversation!);

    // try{
    //     List<EMConversation> conversations= await EMClient.getInstance.chatManager.getConversationsFromServer();
    //     // print("======================");
    //     // print(conversations.length);
    //     // print("======================");

    // Map<String, ChatSilentModeResult> fetchConversationSilentMode = await  EMClient.getInstance.pushManager.fetchSilentModeForConversations(conversations);

    // }on EMError catch (e){
    //   print("======================");
    //   print(e.toString());
    //   print("======================");
    // }

    //  try {
    //       await EMClient.getInstance.chatRoomManager.joinChatRoom("201709904265218");
    //   } on EMError catch (e) {
    //       debugPrint(e.toString());
    //   }

    //底部弹出
    // showModalBottomSheet(
    //     context: context,
    //     builder: (BuildContext con) => Container(
    //           height: 160,
    //           padding: EdgeInsets.all(20),
    //           color: Colors.white,
    //           child: Expanded(
    //             child: ListView(
    //               children: [createItem(true, "拍照"), createItem(false, "相册")],
    //             ),
    //           ),
    //         ));

    // EMCursorResult<String> list =  await EMClient.getInstance.groupManager.fetchMemberListFromServer("220197783928833",cursor:"",pageSize:100);
    // List<String> list1 = list.data;
    // for (var i = 0; i < list1.length; i++){
    //   print(list1[i].toString());
    //   print("----------------------------------");
    // }

    //   EMGroupOptions options =EMGroupOptions(
    //     style: EMGroupStyle.PublicOpenJoin,
    //     maxCount: 100,
    //     inviteNeedConfirm:true
    //   );
    //   EMGroup group = await EMClient.getInstance.groupManager.createGroup(groupName: "flutter 创建群组", options: options,desc: "测试",inviteReason:"");
    //   _string = group.groupId;

    // EMTextMessageBody textBody = EMTextMessageBody(content: "content");

    // EMMessage emMessage = EMMessage.createReceiveMessage(body: textBody);

    // emMessage.from = "em_system";
    // emMessage.status = MessageStatus.SUCCESS;

    // EMClient.getInstance.chatManager.importMessages([emMessage]);

    // try {
    //   await EMClient.getInstance.logout(true);
    //   _addLogToConsole("sign out succeed");
    // } on EMError catch (e) {
    //   _addLogToConsole(
    //       "sign out failed, code: ${e.code}, desc: ${e.description}");
    // }
  }

  void createAccount() async {
    try {
      await EMClient.getInstance.createAccount("lp", "1");
      _addLogToConsole("sign up succeed, username: $_username");
    } on EMError catch (e) {
      _addLogToConsole("sign up failed, e: ${e.code} , ${e.description}");
    }
  }

  void _joinChatRoom() async {
    await EMClient.getInstance.chatRoomManager.joinChatRoom("205354411556871");

    // EMConversation? emConversation =await EMClient.getInstance.chatManager.getConversation('1805212823417192449_employee');
    // List<EMMessage>? message =await emConversation?.loadMessages(
    //   startMsgId: "",
    //     loadCount:20,
    //   direction: EMSearchDirection.Up
    // );
    // for (var i = 0; i < message!.length; i++){
    //
    //   print("======================");
    //   print(message[i].hasRead);
    //   print("======================");
    // }
  }

  Future<void> _getConversationFromServer() async {
    //  ConversationFetchOptions conversationFetchOptions = ConversationFetchOptions.pinned();
    // EMCursorResult<EMConversation> conversation = await EMClient.getInstance.chatManager.fetchConversationsByOptions(options:conversationFetchOptions) ;
    //  var data = conversation.data;

    List<String> list = ["10000015"];
    Map<String, EMUserInfo> userInfos =
    await EMClient.getInstance.userInfoManager.fetchUserInfoById(list);

    print("");

    print("");
  }

  void _signUp() async {
    List<EMConversation> conversation = await EMClient.getInstance.chatManager
        .fetchConversationListFromServer(pageNum: 1, pageSize: 20);

    print("");

    // FetchMessageOptions fetchMessageOptions = FetchMessageOptions(
    //   from: "1805212823417192449_employee",
    //   startTs: -1,
    //   endTs: -1,
    //   direction: EMSearchDirection.Up,
    //   needSave: true
    //
    //   );
    // EMCursorResult<EMMessage> message = await EMClient.getInstance.chatManager.fetchHistoryMessagesByOption("1805212823417192449_employee", EMConversationType.Chat,cursor: "",pageSize: 50);
    // List<EMMessage> data = message.data;
    //
    // for (var i = 0; i < data!.length; i++){
    //
    //   print("======================");
    //   print(data[i].hasRead);
    //   print("======================");
    // }

    // var searchMsgFromDB2 = EMClient.getInstance.chatManager.searchMsgFromDB("",
    // timestamp:DateTime.now().millisecondsSinceEpoch,
    // maxCount :20,
    // from: "",
    // direction: EMSearchDirection.Up
    // );
    // EMGroup group = await EMClient.getInstance.groupManager.fetchGroupInfoFromServer("225470093262852");
    // print("-----------------------");
    // print(group.extension);

    // if (_username.isEmpty || _password.isEmpty) {
    //   _addLogToConsole("username or password is null");
    //   return;
    // }

    // try {
    //   await EMClient.getInstance.createAccount(_username, _password);
    //   _addLogToConsole("sign up succeed, username: $_username");
    // } on EMError catch (e) {
    //   _addLogToConsole("sign up failed, e: ${e.code} , ${e.description}");
    // }
  }

  void _button() {
    EMTextMessageBody textBody = EMTextMessageBody(content: "content");

    EMMessage emMessage =
    EMMessage.createTxtSendMessage(targetId: _string, content: "content");

    emMessage.chatType = ChatType.GroupChat;
    EMClient.getInstance.chatManager.sendMessage(emMessage);
    print("--------------------------------");
  }

  void _sendMessage() async {
    if (_chatId.isEmpty || _messageContent.isEmpty) {
      _addLogToConsole("single chat id or message content is null");
      return;
    }
    Map map = new Map();
    map.putIfAbsent("1111", () => "22222");
    var msg = EMMessage.createTxtSendMessage(
      targetId: _chatId,
      content: _messageContent,
    );
    msg.attributes = {"11111": "qwer", "22222": "23455"};

    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  void _addLogToConsole(String log) {
    _logText.add(_timeString + ": " + log);
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
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
