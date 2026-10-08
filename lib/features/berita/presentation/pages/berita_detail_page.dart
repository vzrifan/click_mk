import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/berita/data/models/berita_detail.dart';
import 'package:click_mk/features/berita/providers/berita_provider.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class BeritaDetailPage extends ConsumerStatefulWidget {
  const BeritaDetailPage({super.key, required this.id});

  final int id;

  @override
  ConsumerState<BeritaDetailPage> createState() => _BeritaDetailPageState();
}

class _BeritaDetailPageState extends ConsumerState<BeritaDetailPage> {
  bool _hasHit = false;

  Future<void> _hitView(BeritaDetail berita) async {
    if (_hasHit) return;
    if (berita.linkHit.isEmpty) return;

    _hasHit = true;

    try {
      final client = ref.read(dioClientProvider);
      await client.patch<dynamic>(berita.linkHit);
      debugPrint('Hit sent: ${berita.linkHit}');
    } catch (e) {
      debugPrint('Hit error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<BeritaDetail>>(beritaDetailProvider(widget.id), (
      previous,
      next,
    ) {
      next.whenData((berita) => _hitView(berita));
    });

    final asyncData = ref.watch(beritaDetailProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Berita MKRI'),
      ),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(beritaDetailProvider(widget.id)),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (berita) => _buildContent(context, berita),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BeritaDetail berita) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (berita.images.isNotEmpty)
            BeritaImageCarousel(images: berita.images),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
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
                      DateFormatter.tanggalWaktuWib(berita.date),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.visibility_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${berita.viewCount}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  berita.judul,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                    height: 1.4,
                  ),
                ),

                if (berita.subJudul.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    berita.subJudul,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                if (berita.noPerkara.isNotEmpty || berita.hasPutusan) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (berita.noPerkara.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.gavel,
                                size: 14,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Perkara: ${berita.noPerkara}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        if (berita.hasPutusan) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => UrlHelper.open(berita.linkPutusan),
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.picture_as_pdf_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Lihat Putusan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 16),
                ],

                HtmlWidget(
                  berita.contentHtml,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: AppColors.text,
                  ),
                  onTapUrl: (url) async {
                    final uri = Uri.tryParse(url);
                    if (uri == null) return false;
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      return true;
                    }
                    return false;
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
