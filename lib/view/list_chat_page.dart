import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart'; // Pastikan ini diakhiri dengan .dart
import 'package:shapee_app/view/room_chat_page.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  _ListChatPageState createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  List<Map<String, dynamic>> chatList = [];

  @override
  void initState() {
    super.initState();
    _fetchChatList();
  }

  Future<void> _fetchChatList() async {
    // Mengambil data chat dari database
    List<Map<String, dynamic>> chats = await DatabaseHelper().getChatHistory();
    setState(() {
      chatList = chats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Chat'),
        backgroundColor: const Color(0xFF90e0ef),
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          final productName = chat['product_name']; // Mengambil nama produk dari riwayat chat
          final lastMessage = chat['message']; // Pesan terakhir dalam chat
          final timestamp = chat['timestamp']; // Timestamp dari pesan

          // Anda mungkin ingin mengambil gambar produk dari database jika ada
          // Misalnya, jika ada tabel produk lain di database atau gambar disimpan di tempat lain
          final productImage = ''; // Ganti dengan logika untuk mendapatkan gambar produk sesuai kebutuhan

          return GestureDetector(
            onTap: () {
              // Navigasi ke RoomChatPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomChatPage(
                    product: {
                      'name': productName,
                      'images': [productImage], // Menyertakan gambar produk jika ada
                    }, // Mengirim data produk ke RoomChatPage
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: productImage.isNotEmpty
                    ? Image.asset(
                        productImage, // Mengambil gambar produk
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(width: 50, height: 50), // Placeholder jika tidak ada gambar
                title: Text(productName ?? 'Unknown Product'), // Menampilkan nama produk
                subtitle: Text('$lastMessage\n$timestamp'), // Menampilkan pesan terakhir dan timestamp
              ),
            ),
          );
        },
      ),
    );
  }
}
