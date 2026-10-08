import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PeradilanContentView extends StatelessWidget {
  const PeradilanContentView({
    super.key,
    required this.content,
    this.title,
    this.onRefresh,
  });

  final PeradilanContent content;
  final String? title;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (content.contentHtml.isEmpty) {
      return const Center(
        child: Text(
          'Konten belum tersedia',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final scrollView = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Judul ────────────────────────────
          if (title != null && title!.isNotEmpty) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Konten HTML ──────────────────────
          HtmlWidget(
            content.contentHtml,
            textStyle: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: AppColors.text,
            ),
            onTapUrl: (url) async {
              final uri = Uri.tryParse(url);
              if (uri == null) return false;
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return true;
              }
              return false;
            },
            customWidgetBuilder: (element) {
              // ── Sembunyikan link "Lihat Peta Lebih Besar" ──
              if (element.localName == 'small') {
                final text = element.text.toLowerCase();
                if (text.contains('lihat peta lebih besar') ||
                    text.contains('view larger map')) {
                  return const SizedBox.shrink();
                }
              }

              // ── Handle iframe ────────────────────
              if (element.localName != 'iframe') return null;

              final src = element.attributes['src'] ?? '';

              // YouTube
              final youtubeId = _extractYoutubeId(src);
              if (youtubeId != null) {
                return _YoutubeThumbnail(videoId: youtubeId);
              }

              // Google Maps → tombol "Lihat Peta"
              if (src.contains('google.com/maps') ||
                  src.contains('maps.google.com') ||
                  src.contains('maps.google.co.id')) {
                return _MapButton(mapsUrl: src);
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh!, child: scrollView);
    }
    return scrollView;
  }

  String? _extractYoutubeId(String url) {
    final regExp = RegExp(r'(?:youtube\.com\/embed\/|youtu\.be\/)([^?&]+)');
    return regExp.firstMatch(url)?.group(1);
  }
}

// ─────────────────────────────────────────────────────────────────
// Tombol "Lihat Peta" — buka Google Maps di browser/app
// ─────────────────────────────────────────────────────────────────
class _MapButton extends StatelessWidget {
  const _MapButton({required this.mapsUrl});
  final String mapsUrl;

  /// Ambil URL Google Maps yang bersih (tanpa parameter embed).
  /// Convert ke format yang bisa dibuka di app Google Maps.
  String _cleanMapsUrl() {
    // Kalau URL asli dari embed, ambil parameter `q` atau `ll`
    final uri = Uri.tryParse(mapsUrl);

    // Coba `q` dulu (query pencarian)
    final q = uri?.queryParameters['q'];
    if (q != null && q.isNotEmpty) {
      return 'https://www.google.com/maps/search/?api=1&query='
          '${Uri.encodeComponent(q)}';
    }

    // Coba `ll` (koordinat)
    final ll = uri?.queryParameters['ll'];
    if (ll != null && ll.isNotEmpty) {
      return 'https://www.google.com/maps/search/?api=1&query=$ll';
    }

    // Fallback: URL asli
    return mapsUrl.replaceFirst('http://', 'https://');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.icon(
          onPressed: () => UrlHelper.open(_cleanMapsUrl()),
          icon: const Icon(Icons.map_outlined, size: 18, color: Colors.white),
          label: const Text(
            'Lihat Peta',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            minimumSize: const Size(0, 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// YouTube — thumbnail + halaman player
// ─────────────────────────────────────────────────────────────────
class _YoutubeThumbnail extends StatelessWidget {
  const _YoutubeThumbnail({required this.videoId});
  final String videoId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoWidth = screenWidth > 700 ? 560.0 : (screenWidth - 64);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: videoWidth,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _YoutubePlayerPage(videoId: videoId),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: Colors.black87,
                        child: const Center(
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.25)),
                    Center(
                      child: Container(
                        width: 64,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _YoutubePlayerPage extends StatefulWidget {
  const _YoutubePlayerPage({required this.videoId});
  final String videoId;

  @override
  State<_YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<_YoutubePlayerPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Video'),
      ),
      body: Center(
        child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
      ),
    );
  }
}
