import 'package:flutter/material.dart';
import '../view/home_page.dart'; // Ganti dengan path yang sesuai

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePage(), // Tampilkan HomePage sebagai halaman default
    );
  }
}
