import 'package:flutter/material.dart';
import 'home_page.dart'; // Ganti dengan path yang sesuai
import 'detail_page.dart'; // Ganti dengan path yang sesuai
import 'product_data.dart'; // Ganti dengan path yang sesuai

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(), // Tampilkan HomePage sebagai halaman default
    );
  }
}
