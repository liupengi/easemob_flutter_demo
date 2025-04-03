import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

//渲染逻辑，仍然是不可以变的！！
class MeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SMDState();
}

// 状态管理者
class _SMDState extends State<MeView> {
  late List<EMConversation> loadAllConversations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: const Column(
          children: [
            TextButton(onPressed: _fetchMemberAttributes, child: Text("获取单个群成员所有自定义属性")),
            TextButton(
              onPressed: _sendMessage,
              child: Text("发送消息"),
            ),
          ],
        ),
      ),
    );
  }
}

void _fetchMemberAttributes() async {
  Map<String, String> map = await EMClient.getInstance.groupManager
      .fetchMemberAttributes(groupId: "274999171678209", userId: "p0");
  print(map.toString());
}

void _sendMessage() async {
  Map map = new Map();
  map.putIfAbsent("1111", () => "22222");
  var msg = EMMessage.createTxtSendMessage(
    targetId: "",
    content: "111",
  );
  msg.attributes = {"11111": "qwer", "22222": "23455"};

  EMClient.getInstance.chatManager.sendMessage(msg);
}
void _signOut() async {




  // EMConversation? emConversation =await EMClient.getInstance.chatManager.getConversation("p1");
  // emConversation?.deleteMessagesWithTs(1738391124716, 1743315924716);







  // EMGroup? emGroup =await EMClient.getInstance.groupManager.getGroupWithId("1111111111");
  //
  // print("emGroup---------->${emGroup?.groupId}");

  // for (var i = 0; i < loadAllConversations.length; i++) {
  //   print(loadAllConversations[i].toString());
  //   print("----------------------------------");
  // }



  // EMClient.getInstance.chatRoomManager.joinChatRoom("201705207693314");
  //
  // EMCursorResult<String> list =await EMClient.getInstance.chatRoomManager.fetchChatRoomMembers("201705207693314",cursor: "",pageSize: 20);
  // List<String> lists = list.data;
  // for (var i = 0; i < lists.length; i++){
  //   debugPrint("=================================================================================================================================================");
  //   debugPrint("通过漫游获取的消息: ${lists[i].toString()}");
  // }
  //
  // EMChatRoom emChatRoom =await  EMClient.getInstance.chatRoomManager.fetchChatRoomInfoFromServer("201705207693314");
  // EMClient.getInstance.pushManager.fetchConversationSilentMode(conversationId: "lp1", type: EMConversationType.Chat);



  // List<EMMessage> messages = await  EMClient.getInstance.chatManager.loadMessagesWithKeyword("你");
  //   for (var i = 0; i < messages.length; i++){
  //     debugPrint("=================================================================================================================================================");
  //     debugPrint("loadMessagesWithKeyword搜索到的消息: ${messages[i].toJson()}");
  //
  //
  //
  //   }



  // FetchMessageOptions fetchMessageOptions = const FetchMessageOptions(
  //     needSave: true,
  //     direction:EMSearchDirection.Up
  // );
  //
  // try {
  //   EMCursorResult<EMMessage> message = await EMClient.getInstance.chatManager.fetchHistoryMessagesByOption("p1",
  //       EMConversationType.Chat,
  //       options: fetchMessageOptions,
  //       cursor: "",
  //       pageSize: 20);
  //   List<EMMessage> data = message.data;
  //   for (var i = 0; i < data!.length; i++){
  //     debugPrint("=================================================================================================================================================");
  //     debugPrint("通过漫游获取的消息: ${data[i].toJson()}");
  //
  //
  //
  //   }
  // } on EMError catch (e) {
  //   print("获取的漫游消息失败：${e.code}======${e.description}");
  // }



  // EMClient.getInstance.groupManager.fetchMuteListFromServer("265049485672455");
  // try {
  //   EMGroup group = await EMClient.getInstance.groupManager.fetchGroupInfoFromServer("265049485672455");
  //
  //
  //   List<String>? muteList  = group.muteList;
  //
  //
  //   print(muteList.toString());
  // } on EMError catch (e) {
  // }





  // try {
  //   await EMClient.getInstance.groupManager
  //       .requestToJoinPublicGroup("264950694084612");
  // } on EMError catch (e) {
  //   print(e.toString());
  // }

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
void _signUp() async {
  // List<EMConversation> conversation = await EMClient.getInstance.chatManager
  //     .fetchConversationListFromServer(pageNum: 1, pageSize: 20);
  //
  // print("");



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