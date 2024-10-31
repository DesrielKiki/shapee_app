import 'package:flutter/material.dart';
import 'package:shapee_app/navigation/navigation_page.dart';
import 'package:shapee_app/view/auth/login_page.dart';
import 'package:shapee_app/view/auth/register_page.dart';
import 'package:shapee_app/view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shapee App',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const NavigationPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
