import 'package:flutter/material.dart';
import 'package:shapee_app/product_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapee App'),
        backgroundColor: const Color(0xFF90e0ef),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
          IconButton(icon: const Icon(Icons.message), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Produk Populer",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: ProductData.popularProduct.length,
              itemBuilder: (context, index) {
                final product = ProductData.popularProduct[index];
                return Card(
                  child: Column(
                    children: [
                      Image.asset(
                        product['image']!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(product['name']!),
                      Text(product['price']!),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
