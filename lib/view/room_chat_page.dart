import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';

class RoomChatPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const RoomChatPage({Key? key, required this.product}) : super(key: key);

  @override
  _RoomChatPageState createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    _messages = await DatabaseHelper().getChatHistory();
    setState(() {});
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await DatabaseHelper()
          .saveChatHistory(widget.product['name'], _messageController.text);
      _messageController.clear();
      _fetchMessages(); // Memperbarui daftar pesan
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: isMe ? 50 : 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: isMe ? Radius.circular(20) : Radius.circular(0),
          topRight: Radius.circular(20),
          bottomLeft: isMe ? Radius.circular(20) : Radius.circular(0),
          bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message['message'],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            message['timestamp'], // Menampilkan timestamp
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
        backgroundColor: const Color(0xFF90e0ef),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isMe = message['product_name'] ==
                    widget
                        .product['name']; // Anda bisa menyesuaikan kondisi ini
                return _buildMessageBubble(message, isMe);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
