import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart'; // Pastikan untuk mengimpor Helper

class CartAndPurchaseBottomSheet extends StatefulWidget {
  final String name;
  final String price; // harga dalam string
  final List<String> images;
  final bool isForPurchase; // parameter untuk menentukan tujuan

  const CartAndPurchaseBottomSheet({
    super.key,
    required this.name,
    required this.price,
    required this.images,
    this.isForPurchase = false,
  });

  @override
  _CartAndPurchaseBottomSheetState createState() =>
      _CartAndPurchaseBottomSheetState();
}

class _CartAndPurchaseBottomSheetState
    extends State<CartAndPurchaseBottomSheet> {
  int quantity = 1; // Jumlah barang yang ingin dibeli
  late TextEditingController _quantityController; // Controller untuk TextField

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose(); // Dispose controller ketika tidak digunakan
    super.dispose();
  }

  void _updateTotal() {
    setState(() {
      quantity = int.tryParse(_quantityController.text) ??
          1; // Mengupdate quantity berdasarkan input
      if (quantity < 1) {
        quantity = 1; // Pastikan quantity tidak kurang dari 1
        _quantityController.text = quantity.toString(); // Update TextField
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double itemPrice = double.tryParse(
            widget.price.replaceAll('Rp', '').replaceAll('.', '').trim()) ??
        0.0; // Mengonversi harga ke double
    double totalPrice = itemPrice * quantity; // Menghitung total harga

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    widget.images.isNotEmpty
                        ? widget.images[0]
                        : 'assets/placeholder.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rp${widget.price}',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Total: ${Helper.formatCurrency(totalPrice)}', // Menggunakan formatCurrency dari Helper
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--; // Mengurangi jumlah jika lebih dari 1
                          _quantityController.text =
                              quantity.toString(); // Update TextField
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      controller: _quantityController,
                      onChanged: (value) {
                        _updateTotal(); // Memperbarui total setiap kali jumlah diubah
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++; // Menambah jumlah
                        _quantityController.text =
                            quantity.toString(); // Update TextField
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (widget.isForPurchase) {
                    String firstImage =
                        widget.images.isNotEmpty ? widget.images[0] : '';

                    Map<String, dynamic> purchaseHistory = {
                      //buy
                      'product_name': widget.name,
                      'quantity': quantity,
                      'total_price': itemPrice * quantity,
                      'image': firstImage,
                      'purchase_date': DateTime.now().toIso8601String(),
                    };

                    await DatabaseHelper()
                        .insertPurchaseHistory(purchaseHistory);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Barang berhasil dibeli.')),
                    );
                    Navigator.pop(context);
                  } else {
                    //cart
                    String firstImage =
                        widget.images.isNotEmpty ? widget.images[0] : '';
                    Map<String, dynamic> cartItem = {
                      'name': widget.name,
                      'price': itemPrice,
                      'quantity': quantity,
                      'totalPrice': itemPrice * quantity,
                      'image': firstImage,
                    };
                    await DatabaseHelper().insertCartItem(cartItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Barang berhasil ditambahkan ke keranjang.'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                ),
                child: Text(widget.isForPurchase
                    ? 'Beli Sekarang'
                    : 'Tambahkan ke Keranjang'),
              ),
            ],
          ),
        );
      },
    );
  }
}
