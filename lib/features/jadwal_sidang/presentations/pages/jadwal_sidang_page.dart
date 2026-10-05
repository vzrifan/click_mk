import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/jadwal_sidang/presentations/widgets/jadwal_sidang_list.dart';
import 'package:flutter/material.dart';

class JadwalSidangPage extends StatelessWidget {
  const JadwalSidangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Jadwal Sidang'),
      ),
      body: const JadwalSidangList(),
    );
  }
}
