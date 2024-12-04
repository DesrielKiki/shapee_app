import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/firebase_helper.dart';
import 'package:shapee_app/view/chat/room_chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({Key? key}) : super(key: key);

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  List<Map<String, dynamic>> chatProfiles =
      []; // Untuk menyimpan daftar chat profile
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatProfiles();
  }

  // Fungsi untuk memuat daftar chat profile
  Future<void> _loadChatProfiles() async {
    try {
      final profiles = await FirebaseHelper().getChatProfiles();
      setState(() {
        chatProfiles = profiles;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading chat profiles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan chat terakhir dari setiap produk
  Future<String> _getLastMessage(String productName) async {
    try {
      final messages = await FirebaseHelper().getMessages(productName);
      if (messages.isNotEmpty) {
        return messages.last['message'] ?? 'No messages';
      }
      return 'No messages';
    } catch (e) {
      print("Error fetching last message: $e");
      return 'Error loading message';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Chat'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatProfiles.length,
              itemBuilder: (context, index) {
                final profile = chatProfiles[index];
                final productName =
                    profile['product_name'] ?? 'Unknown Product';

                return FutureBuilder<String>(
                  future: _getLastMessage(productName), // Ambil pesan terakhir
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    }

                    if (snapshot.hasError) {
                      return ListTile(
                        title: Text(productName),
                        subtitle: const Text('Error loading last message'),
                      );
                    }

                    return ListTile(
                      title: Text(productName),
                      subtitle: Text(snapshot.data ?? 'No messages'),
                      onTap: () {
                        // Navigasi ke RoomChatPage dengan produk yang dipilih
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomChatPage(
                              product: {'name': productName},
                              fromListChat: true,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
