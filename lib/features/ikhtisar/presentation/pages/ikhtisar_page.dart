import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_jenis.dart';
import 'package:click_mk/features/ikhtisar/presentation/widgets/ikhtisar_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IkhtisarPage extends StatefulWidget {
  const IkhtisarPage({super.key, this.initialJenis});
  final IkhtisarJenis? initialJenis;

  @override
  State<IkhtisarPage> createState() => _IkhtisarPageState();
}

class _IkhtisarPageState extends State<IkhtisarPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialJenis ?? IkhtisarJenis.all;
    _tab = TabController(
      length: IkhtisarJenis.values.length,
      vsync: this,
      initialIndex: IkhtisarJenis.values.indexOf(initial),
    );
    _tab.addListener(() {
      if (_tab.indexIsChanging) return;
      final jenis = IkhtisarJenis.values[_tab.index];
      context.goNamed(
        AppRoutes.ikhtisarName,
        queryParameters: {'jenis': jenis.apiValue ?? 'ALL'},
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
        title: const Text('Ikhtisar'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: IkhtisarJenis.values.map((e) {
            return Tab(
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(e.label)),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: IkhtisarJenis.values
            .map((jenis) => IkhtisarList(jenis: jenis))
            .toList(),
      ),
    );
  }
}
