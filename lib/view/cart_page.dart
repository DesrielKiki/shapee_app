import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart'; // Import Helper class

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  List<int> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() async {
    cartItems = await DatabaseHelper().getCartItems();
    setState(() {});
  }

  void _deleteSelectedItems() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
              'Apakah Anda yakin ingin menghapus item yang dipilih?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                for (var id in selectedItems) {
                  await DatabaseHelper().deleteCartItem(id);
                }
                selectedItems.clear();
                Navigator.of(context).pop(); // Close dialog
                _loadCartItems();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          // Menampilkan ikon delete hanya jika ada item yang dipilih
          if (selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedItems,
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Keranjang Anda Kosong',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final isSelected = selectedItems.contains(item['id']);

                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(item['id']);
                      } else {
                        selectedItems.add(item['id']);
                      }
                    });
                  },
                  child: Card(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.white,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset(
                              item['image'] ?? '', // Ensure image is not null
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? 'Tanpa Nama', // Default text if name is null
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Jumlah: ${item['quantity'] ?? 0} pcs', // Default to 0 if quantity is null
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Harga per pcs: ${Helper.formatCurrency(item['price'] ?? 0.0)}', // Use formatCurrency from Helper
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total: ${Helper.formatCurrency(item['totalPrice'] ?? 0.0)}', // Use formatCurrency from Helper
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
