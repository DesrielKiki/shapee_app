import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart';
import 'package:shapee_app/view/payment/payment_page.dart';

class CartAndPurchaseBottomSheet extends StatefulWidget {
  final String name;
  final double price;
  final List<String> images;
  final bool isForPurchase;

  const CartAndPurchaseBottomSheet({
    super.key,
    required this.name,
    required this.price,
    required this.images,
    this.isForPurchase = false,
  });

  @override
  State<CartAndPurchaseBottomSheet> createState() =>
      _CartAndPurchaseBottomSheetState();
}

class _CartAndPurchaseBottomSheetState
    extends State<CartAndPurchaseBottomSheet> {
  int quantity = 1;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: quantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateTotal() {
    setState(() {
      quantity = int.tryParse(_quantityController.text) ?? 1;
      if (quantity < 1) {
        quantity = 1;
        _quantityController.text = quantity.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double itemPrice = widget.price;
    double totalPrice = itemPrice * quantity;

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
          child: SingleChildScrollView(
            controller: scrollController,
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
                        Text(Helper.formatCurrency(itemPrice),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${Helper.formatCurrency(totalPrice)}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) {
                            quantity--;
                            _quantityController.text = quantity.toString();
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
                          _updateTotal();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                          _quantityController.text = quantity.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.isForPurchase) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            name: widget.name,
                            price: widget.price,
                            images: widget.images,
                            quantity: quantity,
                          ),
                        ),
                      );
                    } else {
                      String firstImage =
                          widget.images.isNotEmpty ? widget.images[0] : '';
                      Map<String, dynamic> cartItem = {
                        'name': widget.name,
                        'price': widget.price,
                        'quantity': quantity,
                        'totalPrice': widget.price * quantity,
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
          ),
        );
      },
    );
  }
}
