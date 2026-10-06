import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/jadwal_sidang/presentations/widgets/jadwal_sidang_card.dart';
import 'package:click_mk/features/jadwal_sidang/providers/jadwal_sidang_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JadwalSidangList extends ConsumerWidget {
  const JadwalSidangList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(jadwalSidangListProvider);
    final notifier = ref.read(jadwalSidangListProvider.notifier);

    return Column(
      children: [
        SearchField(
          hintText: 'Cari jadwal sidang...',
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
                            : 'Belum ada jadwal sidang',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  if (state.search.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${state.totalItems} hasil untuk "${state.search}"',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => notifier.refresh(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) =>
                            JadwalSidangCard(jadwal: state.items[i]),
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
    );
  }
}
