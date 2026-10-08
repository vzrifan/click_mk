import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/hit_helper.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/peradilan/providers/mkmk_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MkmkKeputusanTab extends ConsumerWidget {
  const MkmkKeputusanTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(mkmkKeputusanProvider);
    final notifier = ref.read(mkmkKeputusanProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MkmkTabHeader(title: 'Keputusan MKMK'),
        Expanded(
          child: Column(
            children: [
              SearchField(
                hintText: 'Cari keputusan...',
                onChanged: (value) => notifier.setSearch(value),
              ),
              Expanded(
                child: asyncState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(err.toString(), textAlign: TextAlign.center),
                    ),
                  ),
                  data: (state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.items.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada keputusan MKMK',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => notifier.refresh(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final k = state.items[i];
                          return Card(
                            elevation: 1,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: k.hasFile
                                  ? () {
                                      HitHelper.fire(ref, k.linkHit);
                                      UrlHelper.open(k.supportingFile);
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            k.nomorKeputusan,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.text,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          DateFormatter.tanggalPendek(
                                            k.tanggal,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      k.keterangan,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        if (k.hasFile)
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.download,
                                                size: 16,
                                                color: Colors.blue,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${k.downloadCount}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
