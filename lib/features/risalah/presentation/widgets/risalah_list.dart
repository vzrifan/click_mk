import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/risalah/data/models/risalah.dart';
import 'package:click_mk/features/risalah/data/models/risalah_jenis.dart';
import 'package:click_mk/features/risalah/presentation/widgets/risalah_audio_control.dart';
import 'package:click_mk/features/risalah/providers/risalah_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RisalahList extends ConsumerWidget {
  const RisalahList({super.key, required this.jenis});

  final RisalahJenis jenis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(risalahListProvider(jenis));
    final notifier = ref.read(risalahListProvider(jenis).notifier);

    return Column(
      children: [
        SearchField(
          hintText: 'Cari risalah...',
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
                            : 'Belum ada risalah',
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
                            _RisalahCard(risalah: state.items[i]),
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

class _RisalahCard extends StatelessWidget {
  const _RisalahCard({required this.risalah});

  final Risalah risalah;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    risalah.jenisPerkara,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${risalah.downloadCount} unduhan',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              risalah.noPerkara,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),

            Text(
              risalah.acaraSidang,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              risalah.pokokPerkara,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.tanggalWaktuWib(risalah.date),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),

            if (risalah.hasPdf) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => UrlHelper.open(risalah.supportingFile),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  label: const Text('File PDF', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(0, 36),
                  ),
                ),
              ),
            ],

            if (risalah.hasAudio)
              RisalahAudioControl(
                url: risalah.supportingFileAudio,
                title: risalah.noPerkara,
              ),
          ],
        ),
      ),
    );
  }
}
