import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/view/room_chat_page.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  _ListChatPageState createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  List<Map<String, dynamic>> chats = [];

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    List<Map<String, dynamic>> allChats = await DatabaseHelper().getChatHistory();
    print('All Chats: $allChats'); // Log untuk debug

    Map<String, Map<String, dynamic>> groupedChats = {};

    for (var chat in allChats) {
      String? productName = chat['product_name'];
      if (productName != null) {
        // Jika produk belum ada dalam kelompok, tambahkan
        if (!groupedChats.containsKey(productName)) {
          groupedChats[productName] = chat;
        } else {
          // Jika produk sudah ada, bandingkan waktu dan ambil yang terbaru
          if (DateTime.parse(chat['timestamp']).isAfter(DateTime.parse(groupedChats[productName]?['timestamp']))) {
            groupedChats[productName] = chat;
          }
        }
      }
    }

    chats = groupedChats.values.toList();
    print('Grouped Chats: $chats'); // Log untuk debug
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Chat'),
      ),
      body: chats.isEmpty
          ? const Center(child: Text('Tidak ada chat tersedia.'))
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chats[index]['product_name'] ?? 'Nama Produk Kosong'),
                  subtitle: Text(chats[index]['message'] ?? 'Tidak ada pesan'),
                  onTap: () {
                    // Memanggil RoomChatPage dengan data yang sesuai
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomChatPage(
                          product: {
                            'name': chats[index]['product_name'] ?? 'Nama Produk Kosong',
                            'image': chats[index]['image'] ?? 'path/to/default/image.png', // Ganti dengan default image jika null
                            'price': chats[index]['price'] ?? 0.0, // Ganti dengan nilai default jika null
                          },
                          fromListChat: true, // Menandai bahwa ini dibuka dari ListChatPage
                        ),
                      ),
                    ).then((_) => _loadChats()); // Refresh setelah kembali
                  },
                );
              },
            ),
    );
  }
}
