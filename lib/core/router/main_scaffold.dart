import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:click_mk/core/constants/app_colors.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
      body: navigationShell,
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
                final isSelected = navigationShell.currentIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    ),
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
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
