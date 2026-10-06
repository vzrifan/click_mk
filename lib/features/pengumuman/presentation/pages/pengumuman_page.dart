import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/pengumuman/data/providers/pengumuman_provider.dart';
import 'package:click_mk/features/pengumuman/presentation/widgets/pengumuman_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PengumumanPage extends ConsumerWidget {
  const PengumumanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(pengumumanListProvider);
    final notifier = ref.read(pengumumanListProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Pengumuman'),
      ),
      body: Column(
        children: [
          SearchField(
            hintText: 'Cari pengumuman...',
            onChanged: (value) => notifier.setSearch(value),
          ),
          Expanded(
            child: asyncState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(err.toString(), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => notifier.refresh(),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
              data: (state) {
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
                              : 'Belum ada pengumuman',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => notifier.refresh(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, i) =>
                              PengumumanCard(pengumuman: state.items[i]),
                        ),
                      ),
                    ),
                    PaginationBar(
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                      onPageSelected: (page) => notifier.goToPage(page),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
