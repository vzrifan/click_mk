import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/anotasi/presentation/widgets/anotasi_list.dart';
import 'package:flutter/material.dart';

class AnotasiPage extends StatelessWidget {
  const AnotasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Anotasi'),
      ),
      body: const AnotasiList(),
    );
  }
}
