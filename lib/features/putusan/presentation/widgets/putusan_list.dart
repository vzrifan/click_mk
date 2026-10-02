import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/putusan/data/models/putusan_jenis.dart';
import 'package:click_mk/features/putusan/presentation/widgets/putusan_download_button.dart';
import 'package:click_mk/features/putusan/providers/putusan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PutusanList extends ConsumerWidget {
  const PutusanList({super.key, required this.jenis});

  final PutusanJenis jenis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(putusanListProvider(jenis));
    final notifier = ref.read(putusanListProvider(jenis).notifier);

    return Column(
      children: [
        // ── Search bar (selalu tampil) ────────
        SearchField(
          hintText: 'Cari putusan...',
          onChanged: (value) => notifier.setSearch(value),
        ),

        // ── Konten ────────────────────────────
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
                            : 'Belum ada putusan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Info jumlah hasil
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
                        itemBuilder: (context, i) {
                          final p = state.items[i];
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => context.pushNamed(
                                'putusan-detail',
                                pathParameters: {
                                  'id': p.putusanCode.toString(),
                                },
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            p.jenisnya,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          p.status,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      p.noPerkara,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      p.pokokPerkara,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person_outline,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            p.pemohon,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        PutusanDownloadButton(
                                          url: p.supportingFile,
                                          downloadCount: p.downloadCount,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
