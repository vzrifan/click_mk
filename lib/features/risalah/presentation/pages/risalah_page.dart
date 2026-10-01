import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/risalah/data/models/risalah_jenis.dart';
import 'package:click_mk/features/risalah/presentation/widgets/risalah_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RisalahPage extends StatefulWidget {
  const RisalahPage({super.key, this.initialJenis});
  final RisalahJenis? initialJenis;

  @override
  State<RisalahPage> createState() => _RisalahPageState();
}

class _RisalahPageState extends State<RisalahPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialJenis ?? RisalahJenis.all;
    _tab = TabController(
      length: RisalahJenis.values.length,
      vsync: this,
      initialIndex: RisalahJenis.values.indexOf(initial),
    );
    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      final jenis = RisalahJenis.values[_tab.index];
      context.goNamed(
        AppRoutes.risalahName,
        queryParameters: {'jenis': jenis.apiValue},
      );
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Risalah'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: RisalahJenis.values.map((e) {
            return Tab(
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(e.label)),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: RisalahJenis.values
            .map((jenis) => RisalahList(jenis: jenis))
            .toList(),
      ),
    );
  }
}
