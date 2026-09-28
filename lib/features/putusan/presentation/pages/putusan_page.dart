import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/putusan/data/models/putusan_jenis.dart';
import 'package:click_mk/features/putusan/presentation/widgets/putusan_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PutusanPage extends ConsumerStatefulWidget {
  const PutusanPage({super.key, this.initialJenis});
  final PutusanJenis? initialJenis;

  @override
  ConsumerState<PutusanPage> createState() => _PutusanPageState();
}

class _PutusanPageState extends ConsumerState<PutusanPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialJenis ?? PutusanJenis.all;
    _tab = TabController(
      length: PutusanJenis.values.length,
      vsync: this,
      initialIndex: PutusanJenis.values.indexOf(initial),
    );
    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      final jenis = PutusanJenis.values[_tab.index];
      context.goNamed(
        AppRoutes.putusanName,
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
        title: const Text('Putusan'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: PutusanJenis.values.map((e) {
            return Tab(
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(e.label)),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: PutusanJenis.values
            .map((jenis) => PutusanList(jenis: jenis))
            .toList(),
      ),
    );
  }
}
