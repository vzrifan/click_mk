import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/providers/pejabat_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/pejabat_lhkpn_tab.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/pejabat_profil_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PejabatDetailPage extends ConsumerStatefulWidget {
  const PejabatDetailPage({super.key, required this.pejabatId});

  final int pejabatId;

  @override
  ConsumerState<PejabatDetailPage> createState() => _PejabatDetailPageState();
}

class _PejabatDetailPageState extends ConsumerState<PejabatDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(pejabatDetailProvider(widget.pejabatId));

    return asyncData.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(err.toString())),
      ),
      data: (pejabat) => Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        appBar: AppBar(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          title: const Text('Profil Pejabat'),
          bottom: TabBar(
            controller: _tab,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: 'Profil'),
              Tab(text: 'LHKPN'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tab,
          children: [
            PejabatProfilTab(pejabat: pejabat),
            PejabatLhkpnTab(pejabatId: pejabat.id),
          ],
        ),
      ),
    );
  }
}
