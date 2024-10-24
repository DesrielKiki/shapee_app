import 'package:flutter/material.dart';
import 'package:shapee_app/database_helper';

class DetailPage extends StatefulWidget {
  final String image;
  final String name;
  final String price;
  final String sold;
  final String description;

  const DetailPage({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.sold,
    required this.description,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    double itemPrice = double.tryParse(widget.price.replaceAll('Rp. ', '').replaceAll('.', '').trim()) ?? 0;
    double totalPrice = itemPrice * quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: const Color(0xFF90e0ef),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              widget.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Harga: ${widget.price}',
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Terjual: ${widget.sold}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jumlah:'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),
                          Text('$quantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Harga: Rp. ${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> cartItem = {
                        'name': widget.name,
                        'price': itemPrice,
                        'quantity': quantity,
                        'totalPrice': totalPrice,
                      };

                      await DatabaseHelper().insertCartItem(cartItem);

                      // Menampilkan pesan sukses
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.name} berhasil ditambahkan ke keranjang')),
                      );
                    },
                    child: const Text('Tambahkan ke Keranjang'),
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
