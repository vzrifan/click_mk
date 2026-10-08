import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/peradilan/providers/pejabat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PejabatLhkpnTab extends ConsumerWidget {
  const PejabatLhkpnTab({super.key, required this.pejabatId});

  final int pejabatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(pejabatLhkpnProvider(pejabatId));

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(err.toString(), textAlign: TextAlign.center),
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada data LHKPN',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final lhkpn = list[i];
            return Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: lhkpn.hasFile
                    ? () => UrlHelper.open(lhkpn.supportingFileUrl)
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
                              lhkpn.judul,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tahun ${lhkpn.tahun}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (lhkpn.hasFile)
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
        );
      },
    );
  }
}
