import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_jenis.dart';
import 'package:click_mk/features/ikhtisar/presentation/widgets/ikhtisar_card.dart';
import 'package:click_mk/features/ikhtisar/providers/ikhtisar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IkhtisarList extends ConsumerWidget {
  const IkhtisarList({super.key, required this.jenis});

  final IkhtisarJenis jenis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(ikhtisarListProvider(jenis));
    final notifier = ref.read(ikhtisarListProvider(jenis).notifier);

    return Column(
      children: [
        SearchField(
          hintText: 'Cari perkara...',
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
                            : 'Belum ada ikhtisar',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.search.isNotEmpty
                            ? 'Jumlah : ${state.totalItems} (hasil "${state.search}")'
                            : 'Jumlah : ${state.totalItems}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
                            IkhtisarCard(ikhtisar: state.items[i]),
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
