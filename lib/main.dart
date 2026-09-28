import 'package:click_mk/app/theme.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/hakim/hakim_page.dart';
import 'package:click_mk/features/hubungiMK/hubungi_mk_page.dart';
import 'package:click_mk/features/peradilan/peradilan_page.dart';
import 'package:click_mk/features/peraturan/peraturan_page.dart';
import 'package:flutter/material.dart';
import 'package:click_mk/features/home/presentation/pages/home_page.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  static const _items = [
    _NavItem(icon: Icons.account_balance, label: 'Home'),
    _NavItem(icon: Icons.balance, label: 'Peradilan'),
    _NavItem(icon: Icons.person, label: 'Hakim'),
    _NavItem(icon: Icons.privacy_tip, label: 'Peraturan'),
    _NavItem(icon: Icons.phone_in_talk_outlined, label: 'Hubungi MK'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_items.length, (index) {
                final isSelected = currentPageIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => currentPageIndex = index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _items[index].icon,
                          size: 24,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.navbar,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[index].label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.navbar,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      body: <Widget>[
        const HomePage(),
        const PeradilanPage(),
        const HakimPage(),
        const PeraturanPage(),
        const HubungiMKPage(),
      ][currentPageIndex],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
