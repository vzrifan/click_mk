import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/berita/data/models/berita_kategori.dart';
import 'package:click_mk/features/berita/providers/berita_provider.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_card.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_chip_bar.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BeritaPage extends ConsumerWidget {
  const BeritaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(beritaListProvider);
    final notifier = ref.read(beritaListProvider.notifier);

    final currentState = asyncState.asData?.value;
    final selectedKategori = currentState?.kategori ?? BeritaKategori.sidang;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Berita MKRI'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 4),
            child: Column(
              children: [
                SearchField(
                  hintText: 'Cari berita...',
                  onChanged: (value) => notifier.setSearch(value),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: BeritaChipBar(
                    selected: selectedKategori,
                    onSelected: (k) => notifier.setKategori(k),
                    onSiaranPersTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Halaman Siaran Pers belum tersedia',
                          ), // TODO: implementasi halaman Siaran Pers
                        ),
                      );
                    },
                  ),
                ),

                _buildDateFilter(
                  context,
                  currentState?.tanggalAwal,
                  currentState?.tanggalAkhir,
                  (awal, akhir) =>
                      notifier.setTanggal(awal: awal, akhir: akhir),
                ),
              ],
            ),
          ),

          Expanded(
            child: asyncState.when(
              loading: () => _buildSkeletonList(),

              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => notifier.refresh(),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),

              data: (state) {
                if (state.isLoading) {
                  return _buildSkeletonList();
                }

                if (state.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.search.isNotEmpty
                              ? 'Tidak ada hasil untuk "${state.search}"'
                              : 'Belum ada berita',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => notifier.refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, i) => BeritaCard(
                      berita: state.items[i],
                      width: double.infinity,
                      onTap: () => context.pushNamed(
                        AppRoutes.beritaDetailName,
                        pathParameters: {
                          'id': state.items[i].beritaId.toString(),
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: asyncState.maybeWhen(
        data: (state) {
          if (state.items.isEmpty) return null;
          return SizedBox(
            height: 56,
            child: PaginationBar(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              onPageSelected: (page) => notifier.goToPage(page),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, i) => LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxWidth / (16 / 9);
          final totalHeight = imageHeight + 10 + 12 + 8 + 14 + 6 + 14;
          return BeritaSkeleton(width: double.infinity, height: totalHeight);
        },
      ),
    );
  }

  Widget _buildDateFilter(
    BuildContext context,
    DateTime? awal,
    DateTime? akhir,
    void Function(DateTime? awal, DateTime? akhir) onChanged,
  ) {
    final hasFilter = awal != null || akhir != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _pickDateRange(context, awal, akhir, onChanged),
              icon: const Icon(Icons.date_range, size: 16),
              label: Text(
                hasFilter ? '${_fmt(awal)} – ${_fmt(akhir)}' : 'Filter Tanggal',
                style: const TextStyle(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: const Size(0, 36),
              ),
            ),
          ),
          if (hasFilter) ...[
            const SizedBox(width: 6),
            IconButton(
              onPressed: () => onChanged(null, null),
              icon: const Icon(Icons.close, size: 18),
              tooltip: 'Hapus filter',
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                minimumSize: const Size(36, 36),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    DateTime? awal,
    DateTime? akhir,
    void Function(DateTime?, DateTime?) onChanged,
  ) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: (awal != null && akhir != null)
          ? DateTimeRange(start: awal, end: akhir)
          : null,
      locale: const Locale('id', 'ID'),
    );

    if (picked != null) {
      onChanged(picked.start, picked.end);
    }
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
