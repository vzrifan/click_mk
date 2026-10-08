import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_histori_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_jadwal_sidang_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_keputusan_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_pelaporan_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_peraturan_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_profil_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_risalah_sidang_tab.dart';
import 'package:flutter/material.dart';

class MkmkPage extends StatelessWidget {
  const MkmkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        children: [
          // ── TabBar (scrollable) ────────────
          Material(
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: 'Profil MKMK'),
                Tab(text: 'Peraturan MKMK'),
                Tab(text: 'Pelaporan MKMK'),
                Tab(text: 'Jadwal Sidang MKMK'),
                Tab(text: 'Risalah Sidang MKMK'),
                Tab(text: 'Keputusan MKMK'),
                Tab(text: 'Histori Kelembagaan'),
              ],
            ),
          ),

          // ── TabBarView ─────────────────────
          const Expanded(
            child: TabBarView(
              children: [
                MkmkProfilTab(),
                MkmkPeraturanTab(),
                MkmkPelaporanTab(),
                MkmkJadwalSidangTab(),
                MkmkRisalahSidangTab(),
                MkmkKeputusanTab(),
                MkmkHistoriTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
