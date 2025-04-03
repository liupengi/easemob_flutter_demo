import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
//渲染逻辑，仍然是不可以变的！！
class ConversationsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>  _SMDState();
}

// 状态管理者
class _SMDState  extends State<ConversationsView>{
   List<EMConversation>? loadAllConversations = [] ;
  @override
  void initState() {
    super.initState();
    loadAllConversation();
  }
  void loadAllConversation() async{
    List<EMConversation> loadConversations = await EMClient.getInstance.chatManager.loadAllConversations();
    setState(() {
      loadAllConversations = loadConversations;
    });
    if(loadConversations.length == 0){
      EMCursorResult<EMConversation> loadConversations = await   EMClient.getInstance.chatManager.fetchConversationsByOptions(options: ConversationFetchOptions(pageSize: 50),);
      List<EMConversation> loadConversationsFromServer = loadConversations.data;
      setState(() {
        loadAllConversations = loadConversationsFromServer;
      });
    }

  }
  Widget _itemForRow(BuildContext context, int index){
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child:  Row(
        children: <Widget>[
     // Image.network("https://img0.baidu.com/it/u=2931243091,718249849&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1734454800&t=27aab8a597bcdbc7ad41f0ec5cdfc06e"),
        Container(height: 10,
        ),
        Text(loadAllConversations![index].id,
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
          ),)
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemBuilder: _itemForRow,
        itemCount: loadAllConversations?.length,
      ),
    );
  }

}
