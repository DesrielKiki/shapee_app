import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart';
import 'package:shapee_app/view/chat/room_chat_page.dart';

class DetailPage extends StatefulWidget {
  final List<String> images;
  final String name;
  final String price;
  final int sold;
  final String description;

  const DetailPage({
    super.key,
    required this.images,
    required this.name,
    required this.price,
    required this.sold,
    required this.description,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  int currentIndex = 0;

  void _showBottomSheet(BuildContext context) {
    double itemPrice = double.tryParse(
            widget.price.replaceAll('Rp. ', '').replaceAll('.', '').trim()) ??
        0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Jumlah',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Text(
                        '$quantity',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
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
                  const SizedBox(height: 20),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Total Harga',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Helper.formatCurrency(itemPrice * quantity),
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  // Tombol Full Width
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 182, 0, 254),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
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
                          SnackBar(
                            content: Text(
                                '${widget.name} berhasil ditambahkan ke keranjang'),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Tambah ke Keranjang',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final soldFormatted = Helper.formatSold(widget.sold.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: widget.images.length,
                          itemBuilder: (context, index) {
                            return Image.asset(
                              widget.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: Colors.black54,
                          child: Text(
                            '${currentIndex + 1}/${widget.images.length}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              Helper.formatCurrency(double.tryParse(widget.price
                                      .replaceAll('Rp. ', '')
                                      .replaceAll('.', '')
                                      .trim()) ??
                                  0),
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Diskon 50%',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Terjual: $soldFormatted produk',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                    maxHeight: 50,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0096c7),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      double? price = double.tryParse(
                        widget.price
                            .replaceAll('Rp. ', '')
                            .replaceAll('.', '')
                            .replaceAll(',', '.')
                            .trim(),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomChatPage(
                            product: {
                              'name': widget.name,
                              'price': price ?? 0,
                              'image': widget.images.isNotEmpty
                                  ? widget.images[0]
                                  : '',
                            },
                          ),
                        ),
                      );
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Chat Sekarang',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                    maxHeight: 50,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0096c7),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ke Keranjang',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 50,
                    maxHeight: 50,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 182, 0, 254),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      // Tampilkan Snackbar ketika tombol "Beli Sekarang" ditekan
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.name} berhasil dibeli!'),
                        ),
                      );
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Beli Sekarang',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
