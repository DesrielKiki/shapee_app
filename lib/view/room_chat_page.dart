import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart';

class RoomChatPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool fromListChat; // Menandai dari mana halaman ini dibuka

  const RoomChatPage(
      {super.key, required this.product, this.fromListChat = false});

  @override
  _RoomChatPageState createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  bool isLoading = true;

  // Daftar template pesan
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
    _loadMessages(); // Memuat pesan saat inisialisasi
  }

  Future<void> _loadMessages() async {
    print('Loading messages for product: ${widget.product['name']}');
    try {
      messages = await DatabaseHelper().getMessages(widget.product['name']);
      print('Messages loaded: $messages');

      if (mounted) {
        setState(() {
          isLoading = false; // Ubah status loading setelah data dimuat
        });
      }
    } catch (e) {
      print('Error loading messages: $e');
      if (mounted) {
        setState(() {
          isLoading = false; // Ubah status loading jika terjadi error
        });
      }
    }
  }

  Future<void> _sendMessage(String messageContent) async {
    if (messageContent.isNotEmpty) {
      print("Sending message: $messageContent");
      try {
        await DatabaseHelper()
            .insertMessage(widget.product['name'], messageContent);
        messageController.clear();
        await _loadMessages(); // Refresh the message list
        print("Messages reloaded after sending.");

        // Auto reply
        _autoReply(messageContent);
      } catch (e) {
        print('Error sending message: $e');
      }
    } else {
      print("Message is empty, not sending.");
    }
  }

  void _autoReply(String userMessage) async {
    // Simulasi delay untuk auto reply
    await Future.delayed(Duration(seconds: 1));
    String autoReplyMessage =
        "Terima kasih! Kami akan segera menghubungi Anda.";
    print("Auto replying with: $autoReplyMessage");

    await DatabaseHelper()
        .insertMessage(widget.product['name'], autoReplyMessage);
    await _loadMessages(); // Refresh the message list setelah auto reply
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
          : Column(
              children: [
                // Menampilkan foto produk dan informasi lainnya hanya jika bukan dari ListChatPage
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
                                widget.product['name'] ?? 'Nama Produk Kosong',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                // Tempat untuk tampilan chat
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUserMessage =
                          message['isUser'] == true; // Menandai pesan pengguna
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.lightBlue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: isUserMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['message'] ?? 'Pesan Kosong',
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
                              message['timestamp'] ?? 'Waktu Kosong',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Daftar template pesan dalam bentuk Row yang dapat di-scroll
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 50, // Set height untuk container template
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: messageTemplates.map((template) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              messageController.text =
                                  template; // Set template ke TextField
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.grey[200], // Background warna tombol
                              foregroundColor:
                                  Colors.black, // Warna teks tombol
                            ),
                            child:
                                Text(template, style: TextStyle(fontSize: 12)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Input untuk mengirim chat
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
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            filled: true,
                            fillColor:
                                Colors.grey[200], // Background warna TextField
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
    );
  }
}
