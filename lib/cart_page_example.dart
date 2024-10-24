import 'package:flutter/material.dart';
import 'package:shapee_app/database_helper';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    List<Map<String, dynamic>> items = await DatabaseHelper().getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: const Color(0xFF90e0ef),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Keranjang Anda kosong'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Jumlah: ${item['quantity']}'),
                    trailing: Text(
                      'Total: Rp. ${item['totalPrice'].toStringAsFixed(2).replaceAll('.', ',')}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
