import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_pelaporan_ringkas.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_risalah_sidang.dart';
import 'package:click_mk/features/peradilan/providers/mkmk_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MkmkRisalahSidangTab extends ConsumerWidget {
  const MkmkRisalahSidangTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(mkmkRisalahSidangProvider);
    final notifier = ref.read(mkmkRisalahSidangProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MkmkTabHeader(title: 'Risalah Sidang MKMK'),
        Expanded(
          child: Column(
            children: [
              SearchField(
                hintText: 'Cari risalah sidang...',
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
                          'Belum ada risalah sidang MKMK',
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
                        itemBuilder: (context, i) =>
                            _RisalahCard(risalah: state.items[i]),
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

class _RisalahCard extends StatelessWidget {
  const _RisalahCard({required this.risalah});

  final MkmkRisalahSidang risalah;

  @override
  Widget build(BuildContext context) {
    final pelaporan = risalah.tbPelaporan;

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.tanggalWaktuWib(risalah.tanggalSidangMulai),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (risalah.acaraSidang.isNotEmpty)
              Text(
                risalah.acaraSidang,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  height: 1.4,
                ),
              ),
            if (risalah.tempat.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      risalah.tempat,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
            if (pelaporan != null) ...[
              const SizedBox(height: 12),
              _buildPelaporanBox(pelaporan),
            ],
            if (risalah.hasPdf || risalah.hasAudio) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (risalah.hasPdf)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => UrlHelper.open(risalah.supportingFile),
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 16,
                        ),
                        label: const Text(
                          'Lihat PDF',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                  if (risalah.hasPdf && risalah.hasAudio)
                    const SizedBox(width: 8),
                  if (risalah.hasAudio)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            UrlHelper.open(risalah.supportingAudioFile),
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text(
                          'Putar Audio',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPelaporanBox(MkmkPelaporanRingkas p) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.nomorRegistrasi,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            p.judulPelaporan,
            style: const TextStyle(fontSize: 11, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (p.pelapor.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Pelapor: ${p.pelapor.join(", ")}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (p.kuasa.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              'Kuasa: ${p.kuasa.join(", ")}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
