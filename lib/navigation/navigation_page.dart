import 'package:flutter/material.dart';
import 'package:shapee_app/view/color_config.dart';
import 'package:shapee_app/view/history/history_page.dart';
import 'package:shapee_app/view/profile/profile_page.dart';
import '../view/home/home_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  int _selectedIndex = 0;

  void changeIndexPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeIndexPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0
                    ? ColorConfig.primaryColor
                    : Colors.grey),
            label: _selectedIndex == 0 ? "Home" : "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color:
                  _selectedIndex == 1 ? ColorConfig.primaryColor : Colors.grey,
            ),
            label: _selectedIndex == 1 ? "History" : "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color:
                  _selectedIndex == 2 ? ColorConfig.primaryColor : Colors.grey,
            ),
            label: _selectedIndex == 2 ? "Profile" : "",
          ),
        ],
      ),
    );
  }
}
