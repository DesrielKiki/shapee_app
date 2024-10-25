import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart';

class RoomChatPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool fromListChat;

  const RoomChatPage(
      {super.key, required this.product, this.fromListChat = false});

  @override
  _RoomChatPageState createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  bool isLoading = true;

  final List<String> messageTemplates = [
    "Terima kasih atas informasinya!",
    "Apakah masih tersedia?",
    "Bisa tolong berikan diskon?",
    "Saya ingin tahu lebih banyak tentang produk ini.",
    "Kapan bisa diambil?",
  ];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      messages = await DatabaseHelper().getMessages(widget.product['name']);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage(String messageContent) async {
    if (messageContent.isNotEmpty) {
      await DatabaseHelper()
          .insertMessage(widget.product['name'], messageContent, true);
      messageController.clear();
      await _loadMessages();
      _autoReply(messageContent);
    }
  }

  void _autoReply(String userMessage) async {
    await Future.delayed(Duration(seconds: 1));
    String autoReplyMessage =
        "Terima kasih! Kami akan segera menghubungi Anda.";
    await DatabaseHelper()
        .insertMessage(widget.product['name'], autoReplyMessage, false);
    await _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'] ?? 'Nama Produk Kosong'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[300]!, // Warna biru muda
                    Colors.blue[100]!, // Warna biru lebih terang
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  if (!widget.fromListChat) ...[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Image.asset(
                            widget.product['image'] ??
                                'path/to/default/image.png',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product['name'] ??
                                      'Nama Produk Kosong',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Harga: ${Helper.formatCurrency(widget.product['price'] ?? 0.0)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUserMessage = message['is_user'] == 1;

                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: isUserMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.75, // 75% max width
                                ),
                                child: Card(
                                  // Tambahkan Card di sini
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // Atur radius sudut jika diinginkan
                                  ),
                                  elevation:
                                      3, // Atur elevasi untuk efek bayangan
                                  child: CustomPaint(
                                    painter: ChatBubblePainter(
                                        isUserMessage: isUserMessage),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: isUserMessage
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message['message'] ??
                                                'Pesan Kosong',
                                            style: TextStyle(
                                              color: isUserMessage
                                                  ? Colors.black
                                                  : Colors.black87,
                                              fontWeight: isUserMessage
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            message['timestamp'] ??
                                                'Waktu Kosong',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: messageTemplates.map((template) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                messageController.text = template;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                              ),
                              child: Text(template,
                                  style: TextStyle(fontSize: 12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.red),
                          onPressed: () => _sendMessage(messageController.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ChatBubblePainter extends CustomPainter {
  final bool isUserMessage;

  ChatBubblePainter({required this.isUserMessage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isUserMessage ? Colors.blue[100]! : Colors.grey[200]!
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUserMessage) {
      path.moveTo(10, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, 10);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width - 10, 0);
      path.lineTo(size.width, 10);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
