import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/peradilan/providers/mkmk_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MkmkPeraturanTab extends ConsumerWidget {
  const MkmkPeraturanTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(mkmkPeraturanProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MkmkTabHeader(title: 'Peraturan MKMK'),
        Expanded(
          child: asyncData.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(err.toString(), textAlign: TextAlign.center),
              ),
            ),
            data: (list) {
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada peraturan MKMK',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(mkmkPeraturanProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final p = list[i];
                    return Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: p.hasFile
                            ? () => UrlHelper.open(p.supportingFileUrl)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.picture_as_pdf,
                                  size: 22,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nomor,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      p.tentang,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (p.hasFile)
                                const Icon(
                                  Icons.download,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
