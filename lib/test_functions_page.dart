import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

/// Test functions page containing SDK testing functionality
/// 
/// This page contains various testing functions for the EaseMob SDK,
/// moved from the original me_view.dart for development and testing purposes.
class TestFunctionsPage extends StatefulWidget {
  const TestFunctionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _TestFunctionsPageState();
}

/// State management for test functions page
class _TestFunctionsPageState extends State<TestFunctionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('SDK 测试功能'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              '以下为 EaseMob SDK 测试功能',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            // Test buttons
            TestButton(
              onPressed: _fetchMemberAttributes,
              text: "获取单个群成员所有自定义属性",
            ),
            TestButton(
              onPressed: _fetchHistoryMessagesByOption,
              text: "从服务端获取历史消息",
            ),
            TestButton(
              onPressed: _fetchHistoryMessages,
              text: "从本地取历史消息",
            ),
            TestButton(
              onPressed: _deleteLoadConversations,
              text: "删除本地会话",
            ),
            TestButton(
              onPressed: _modifyMessage,
              text: "修改消息",
            ),
            TestButton(
              onPressed: _sendMessage,
              text: "发送消息",
            ),
            TestButton(
              onPressed: _sendGroupMessageReceipt,
              text: "发送群回执",
            ),
            TestButton(
              onPressed: _testFunction,
              text: "测试功能1",
            ),
            TestButton(
              onPressed: _testFunction,
              text: "测试功能2",
            ),
            TestButton(
              onPressed: _testFunction,
              text: "测试功能3",
            ),
            TestButton(
              onPressed: _testFunction,
              text: "测试功能4",
            ),
            TestButton(
              onPressed: _testFunction,
              text: "测试功能5",
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Generic test function placeholder
  static void _testFunction() {
    debugPrint('Test function called');
  }
}

/// Reusable test button widget
class TestButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const TestButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[50],
          foregroundColor: Colors.blue[800],
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Test function implementations
void _sendGroupMessageReceipt() async {
  debugPrint('Send group message receipt called');
}

void _fetchHistoryMessages() async {
  debugPrint('Fetch history messages called');
}

void _fetchMemberAttributes() async {
  try {
    Map<String, String> map = await EMClient.getInstance.groupManager
        .fetchMemberAttributes(groupId: "274999171678209", userId: "p0");
    debugPrint('Member attributes: ${map.toString()}');
  } catch (e) {
    debugPrint('Error fetching member attributes: $e');
  }
}

void _modifyMessage() async {
  try {
    // Create a test text message
    final msg = EMMessage.createTxtSendMessage(
      targetId: "lp1",
      content: 'hello',
      chatType: ChatType.Chat,
    );
    
    final handler = ChatMessageEvent(
      onSuccess: (msgId, msg) {
        debugPrint("Message sent successfully: $msgId, server message id: ${msg.msgId}");
      },
      onProgress: (msgId, progress) {},
      onError: (msgId, msg, error) {
        debugPrint("Message send failed: $msgId, error: $error");
      },
    );

    // Add message event listener
    EMClient.getInstance.chatManager.addMessageEvent('TEST_HANDLER', handler);
    
    // Send message
    EMClient.getInstance.chatManager.sendMessage(msg);
  } catch (e) {
    debugPrint('Error in modify message: $e');
  }
}

void _deleteLoadConversations() async {
  try {
    EMClient.getInstance.chatManager.deleteConversation("");
    debugPrint('Delete conversation called');
  } catch (e) {
    debugPrint('Error deleting conversation: $e');
  }
}

void _fetchHistoryMessagesByOption() async {
  const fetchMessageOptions = FetchMessageOptions(
    needSave: true,
    direction: EMSearchDirection.Up,
  );

  try {
    EMCursorResult<EMMessage> message = await EMClient.getInstance.chatManager
        .fetchHistoryMessagesByOption(
      "lp1",
      EMConversationType.Chat,
      options: fetchMessageOptions,
      cursor: "",
      pageSize: 20,
    );
    
    List<EMMessage> data = message.data;
    for (var i = 0; i < data.length; i++) {
      debugPrint("Fetched message from server: ${data[i].toJson()}");
    }
  } on EMError catch (e) {
    debugPrint("Failed to fetch messages from server: ${e.code} - ${e.description}");
  }
}

void _sendMessage() async {
  try {
    Map<String, dynamic> attributes = {
      "11111": "qwer",
      "22222": "23455"
    };
    
    var msg = EMMessage.createTxtSendMessage(
      targetId: "288428783632387",
      content: "Test message from Flutter",
    );
    
    msg.attributes = attributes;
    msg.chatType = ChatType.GroupChat;
    
    EMClient.getInstance.chatManager.addMessageEvent(
      "TEST_MESSAGE_HANDLER",
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          debugPrint("Message sent: $msgId, server id: ${msg.msgId}");
        },
        onError: (msgId, msg, error) {
          debugPrint("Send failed: $msgId, error: $error");
        },
        onProgress: (msgId, progress) {
          debugPrint("Send progress: $msgId, progress: $progress");
        },
      ),
    );
    
    EMClient.getInstance.chatManager.sendMessage(msg);
  } catch (e) {
    debugPrint('Error sending message: $e');
  }
}
