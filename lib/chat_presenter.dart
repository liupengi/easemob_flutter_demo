import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatPresenter{
  void addChatListener() {
    EMClient.getInstance.groupManager.addEventHandler("identifier",
        EMGroupEventHandler(
            onMemberJoinedFromGroup: (groupid,member){
              print("有用户加入群组了" + groupid + "====" + member);
            },
            onAutoAcceptInvitationFromGroup:(groupId , inviter,inviteMessage){

              print("您加入了群组" + groupId + "====" + inviter+"====="+inviteMessage.toString());
            },
            onSpecificationDidUpdate: (group){

            },
            onAnnouncementChangedFromGroup: (groupid,announcement){
              print("公告更新了" + groupid + "====" + announcement!);

            }
          //onSpecificationDidUpdate


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

            print("-------------------------onConnected");
          },
          onDisconnected: () {
            EMClient.getInstance.logout(true);

          },
          onOfflineMessageSyncStart: (){
            print("-------------------------onOfflineMessageSyncStart");
          },

          onOfflineMessageSyncFinish: (){
            print("-------------------------onOfflineMessageSyncFinish");
          },

        ));

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      // EMChatEventHandler 对应的 key。
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
          onConversationsUpdate: (){
            EMClient.getInstance.chatManager.loadAllConversations();
          },
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
          onMessagesRecalledInfo:(recallMessageInfo) {
            for (var msg in recallMessageInfo) {
              print("onMessagesRecalledInfo======================"+msg.recallMessageId);
            }



          } ,
          onMessagesReceived: (messages) async {

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
          },
          onMessagesRead: (messages) {
            for (var msg in messages) {
              print("onMessagesRead------${msg.hasReadAck}");
            }
          },
          onGroupMessageRead: (messages) async {
            for (var msg in messages) {
              print("onMessagesRead------${msg.readCount}");
              EMCursorResult<EMGroupMessageAck> list =await  EMClient.getInstance.chatManager.fetchGroupAcks("","");
              List<EMGroupMessageAck> groupMessageAcklist =list.data;


            }
          }
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
          onSuccess: (msgId, msg) async {
            Map? map = msg.attributes;
            print("------------------成功");
            // 消息发送动作完成。
            EMTextMessageBody body = msg.body as EMTextMessageBody;

            print("translation: ${body.translations}");


            List<String> languages = ["en"];
            try {
              // 执行消息内容的翻译，`textMessage`：收到的文本消息
              EMMessage translatedMessage = await EMClient.getInstance.chatManager
                  .translateMessage(msg: msg, languages: languages);

              EMTextMessageBody body = translatedMessage.body as EMTextMessageBody;
              print("translation: ${body.translations}");
            } on EMError catch (e) {
            }
          },
          onProgress: (msgId, progress) {
          },
          onError: (msgId, msg, error) {

          },
        ));
  }

  void initSDK() async{
    EMOptions options = EMOptions.withAppKey(
      "easemob-demo#support",
      autoLogin: true,
      debugMode: true,
      requireAck: true,
      extSettings: {
        ExtSettings.kAppIDForOhOS: "111703463",
      },

    );
    await EMClient.getInstance.init(options);
    // 通知 SDK UI 已准备好。该方法执行后才会收到 `EMChatRoomEventHandler`、`EMContactEventHandler` 和 `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
  }

  void isLoginBefore() async {
    EMClient.getInstance.isLoginBefore();
}
}