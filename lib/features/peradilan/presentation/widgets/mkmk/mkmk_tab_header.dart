import 'package:click_mk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MkmkTabHeader extends StatelessWidget {
  const MkmkTabHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
          height: 1.3,
        ),
      ),
    );
  }
}
