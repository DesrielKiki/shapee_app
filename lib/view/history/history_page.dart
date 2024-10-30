import 'package:flutter/material.dart';
import 'package:shapee_app/database/helper/database_helper.dart';
import 'package:shapee_app/database/helper/helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> purchaseHistory = [];

  @override
  void initState() {
    super.initState();
    _loadPurchaseHistory();
  }

  Future<void> _loadPurchaseHistory() async {
    List<Map<String, dynamic>> history =
        await DatabaseHelper().getPurchaseHistory();
    setState(() {
      purchaseHistory = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pembelian'),
      ),
      body: purchaseHistory.isEmpty
          ? const Center(child: Text('Belum ada riwayat pembelian.'))
          : ListView.builder(
              itemCount: purchaseHistory.length,
              itemBuilder: (context, index) {
                final item = purchaseHistory[index];
                return Card(
                  elevation: 4, // Added elevation for shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8), // Rounded image corners
                      child: Image.asset(
                        item['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['product_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Jumlah: ${item['quantity']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total: ${Helper.formatCurrency(item['total_price'])}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                        Text(
                          'Tanggal: ${Helper.formatDate(item['purchase_date'])}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Metode Pembayaran: ${item['payment_method']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
