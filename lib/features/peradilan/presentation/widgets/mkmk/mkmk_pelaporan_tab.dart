import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_pelaporan.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_tab_header.dart';
import 'package:click_mk/features/peradilan/providers/mkmk_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MkmkPelaporanTab extends ConsumerWidget {
  const MkmkPelaporanTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(mkmkPelaporanProvider);
    final notifier = ref.read(mkmkPelaporanProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MkmkTabHeader(title: 'Pelaporan MKMK'),
        Expanded(
          child: Column(
            children: [
              SearchField(
                hintText: 'Cari pelaporan...',
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
                          'Belum ada pelaporan MKMK',
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
                            _PelaporanCard(pelaporan: state.items[i]),
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

class _PelaporanCard extends StatelessWidget {
  const _PelaporanCard({required this.pelaporan});

  final MkmkPelaporan pelaporan;

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Text(
                    pelaporan.nomorRegistrasi,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Text(
                  DateFormatter.tanggalPendek(pelaporan.tanggalPelaporan),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              pelaporan.judulPelaporan,
              style: const TextStyle(fontSize: 12, height: 1.4),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (pelaporan.pelapor.isNotEmpty)
              _buildListRow('Pelapor', pelaporan.pelapor),
            if (pelaporan.kuasa.isNotEmpty)
              _buildListRow('Kuasa', pelaporan.kuasa),
            if (pelaporan.supportingFiles.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Dokumen:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              for (final file in pelaporan.supportingFiles)
                if (file.hasFile)
                  InkWell(
                    onTap: () => UrlHelper.open(file.fileUrl),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 14,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              file.nama.isNotEmpty
                                  ? file.nama
                                  : file.jenisDokumen,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListRow(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const Text(':', style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              items.join(', '),
              style: const TextStyle(fontSize: 11, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
