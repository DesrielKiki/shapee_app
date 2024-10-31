import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart';
import 'package:shapee_app/navigation/navigation_page.dart';

class PaymentPage extends StatefulWidget {
  final String name;
  final double price;
  final List<String> images;
  final int quantity;
  final int? cartItemId;

  const PaymentPage({
    super.key,
    required this.name,
    required this.price,
    required this.images,
    required this.quantity,
    this.cartItemId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    double itemPrice = widget.price;
    double totalPrice = itemPrice * widget.quantity;
    String formattedTotalPrice = Helper.formatCurrency(totalPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color.fromARGB(255, 114, 236, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 114, 236, 255).withOpacity(0.3),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.images.isNotEmpty
                        ? widget.images[0]
                        : 'assets/placeholder.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Harga Satuan : ${Helper.formatCurrency(widget.price)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jumlah : ${widget.quantity} Pcs',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Total : $formattedTotalPrice',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: DropdownButton<String>(
                  hint: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Pilih Metode Pembayaran'),
                  ),
                  value: selectedPaymentMethod,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'Kartu Kredit/Debit',
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.credit_card),
                            SizedBox(width: 8),
                            Text('Kartu Kredit/Debit'),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Transfer Bank',
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.account_balance),
                            SizedBox(width: 8),
                            Text('Transfer Bank'),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Dompet Digital',
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.wallet),
                            SizedBox(width: 8),
                            Text('Dompet Digital'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Nama Barang'),
                          Text(widget.name),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Jumlah'),
                          Text('${widget.quantity} Pcs'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          Text(formattedTotalPrice),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Informasi Pembayaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan pilih metode pembayaran yang sesuai dengan kebutuhan Anda.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Jika Anda memiliki pertanyaan, silakan hubungi kami melalui email atau telepon.',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 114, 236, 255),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              if (selectedPaymentMethod != null) {
                await DatabaseHelper().confirmPayment(
                  productName: widget.name,
                  quantity: widget.quantity,
                  totalPrice: totalPrice,
                  image: widget.images.isNotEmpty ? widget.images[0] : '',
                  paymentMethod: selectedPaymentMethod!,
                );

                if (widget.cartItemId != null) {
                  await DatabaseHelper().deleteCartItem(widget.cartItemId!);
                }

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const NavigationPage()),
                    (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Silakan pilih metode pembayaran.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 114, 236, 255),
            ),
            child: const Text(
              'Konfirmasi Pembayaran',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
