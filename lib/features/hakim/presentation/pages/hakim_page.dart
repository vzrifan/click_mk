import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/data/models/jabatan_filter.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_plain_list.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_section.dart';
import 'package:click_mk/features/hakim/providers/hakim_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HakimPage extends ConsumerStatefulWidget {
  const HakimPage({super.key});

  @override
  ConsumerState<HakimPage> createState() => _HakimPageState();
}

class _HakimPageState extends ConsumerState<HakimPage>
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

  void _openDetail(Hakim hakim) {
    context.pushNamed(
      AppRoutes.hakimDetailName,
      pathParameters: {'id': hakim.idHakim.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Hakim Konstitusi'),
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
            Tab(text: 'Hakim Konstitusi'),
            Tab(text: 'Hakim Periode Sebelumnya'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _TabSekarang(onTapHakim: _openDetail),

          _TabSebelumnya(onTapHakim: _openDetail),
        ],
      ),
    );
  }
}

class _TabSekarang extends ConsumerWidget {
  const _TabSekarang({required this.onTapHakim});

  final void Function(Hakim) onTapHakim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(hakimSekarangProvider);

    return asyncList.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        error: err,
        onRetry: () => ref.read(hakimSekarangProvider.notifier).refresh(),
      ),
      data: (list) => HakimSection(
        list: list,
        onRefresh: () => ref.read(hakimSekarangProvider.notifier).refresh(),
        onTapHakim: onTapHakim,
      ),
    );
  }
}

class _TabSebelumnya extends StatefulWidget {
  const _TabSebelumnya({required this.onTapHakim});

  final void Function(Hakim) onTapHakim;

  @override
  State<_TabSebelumnya> createState() => _TabSebelumnyaState();
}

class _TabSebelumnyaState extends State<_TabSebelumnya>
    with SingleTickerProviderStateMixin {
  late final TabController _subTab;
  static const _filters = [
    JabatanFilter.ketua,
    JabatanFilter.wakil,
    JabatanFilter.hakimKonstitusi,
  ];

  @override
  void initState() {
    super.initState();
    _subTab = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _subTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: TabBar(
            controller: _subTab,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            tabs: _filters.map((f) => Tab(text: f.label)).toList(),
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _subTab,
            children: _filters
                .map(
                  (f) =>
                      _SubTabHakim(jabatan: f, onTapHakim: widget.onTapHakim),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SubTabHakim extends ConsumerWidget {
  const _SubTabHakim({required this.jabatan, required this.onTapHakim});

  final JabatanFilter jabatan;
  final void Function(Hakim) onTapHakim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(hakimSebelumnyaProvider(jabatan));

    return asyncList.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        error: err,
        onRetry: () =>
            ref.read(hakimSebelumnyaProvider(jabatan).notifier).refresh(),
      ),
      data: (list) => HakimPlainList(
        list: list,
        onRefresh: () =>
            ref.read(hakimSebelumnyaProvider(jabatan).notifier).refresh(),
        onTapHakim: onTapHakim,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
