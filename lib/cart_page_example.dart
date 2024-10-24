import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Simulasi daftar produk dalam keranjang
  List<Map<String, dynamic>> cartItems = [];

  void addToCart(String name, String price) {
    setState(() {
      cartItems.add({'name': name, 'price': price});
    });
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
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
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(cartItems[index]['name']),
                    subtitle: Text(cartItems[index]['price']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeFromCart(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logika untuk menambah item ke keranjang dapat ditambahkan di sini
          // Misalnya, menambah produk dengan nama dan harga tertentu
          addToCart('Contoh Produk', '\$100');
        },
        backgroundColor: const Color(0xFF90e0ef),
        child: const Icon(Icons.add),
      ),
    );
  }
}
