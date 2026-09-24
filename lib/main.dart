import 'package:click_mk/Hakim/hakim_page.dart';
import 'package:click_mk/HubungiMK/hubungi_mk_page.dart';
import 'package:click_mk/Peradilan/peradilan_page.dart';
import 'package:click_mk/TanyaJawab/tanya_jawab_page.dart';
import 'package:click_mk/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:click_mk/Home/home_page.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: AppColors.accent),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.gavel, color: AppColors.accent),
            icon: Icon(Icons.gavel),
            label: 'Peradilan',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: AppColors.accent),
            icon: Icon(Icons.person),
            label: 'Hakim',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.accent),
            icon: Icon(Icons.chat_bubble),
            label: 'Tanya Jawab',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.contact_phone, color: AppColors.accent),
            icon: Icon(Icons.contact_phone),
            label: 'Hubungi MK',
          ),
        ],
      ),
      body: <Widget>[
        HomePage(),
        PeradilanPage(),
        HakimPage(),
        TanyaJawabPage(),
        HubungiMKPage(),
      ][currentPageIndex],
    );
  }
}
