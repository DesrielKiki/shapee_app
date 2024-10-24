import 'package:flutter/material.dart';
import 'package:shapee_app/database_helper';

class DetailPage extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String sold;
  final String description;

  DetailPage({
    required this.image,
    required this.name,
    required this.price,
    required this.sold,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(image),
            SizedBox(height: 10),
            Text(name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(price, style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('$sold terjual', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            QuantitySelector(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Menambahkan produk ke keranjang
                DatabaseHelper().addToCart(
                    name, 1); // Ganti 1 dengan jumlah yang diinginkan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name ditambahkan ke keranjang')),
                );
              },
              child: Text('Tambah ke Keranjang'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: _decrement, icon: Icon(Icons.remove)),
        Text('$_quantity', style: TextStyle(fontSize: 20)),
        IconButton(onPressed: _increment, icon: Icon(Icons.add)),
      ],
    );
  }
}
