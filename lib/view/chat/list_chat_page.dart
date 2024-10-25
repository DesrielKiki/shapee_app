import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/view/chat/room_chat_page.dart';

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
    chats = await DatabaseHelper().loadGroupedChats();
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
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                          chats[index]['product_name'] ?? 'Nama Produk Kosong'),
                      subtitle:
                          Text(chats[index]['message'] ?? 'Tidak ada pesan'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomChatPage(
                              product: {
                                'name': chats[index]['product_name'] ??
                                    'Nama Produk Kosong',
                                'image': chats[index]['image'] ??
                                    'path/to/default/image.png',
                                'price': chats[index]['price'] ?? 0.0,
                              },
                              fromListChat: true,
                            ),
                          ),
                        ).then((_) => _loadChats());
                      },
                      
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }
}
