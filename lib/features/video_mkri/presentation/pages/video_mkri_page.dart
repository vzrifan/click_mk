import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/video_mkri/data/models/video_status.dart';
import 'package:click_mk/features/video_mkri/presentation/widgets/vicon_section.dart';
import 'package:click_mk/features/video_mkri/providers/video_mkri_provider.dart';
import 'package:click_mk/features/video_mkri/presentation/widgets/live_streaming_view.dart';
import 'package:click_mk/features/video_mkri/presentation/widgets/video_mkri_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoMkriPage extends ConsumerWidget {
  const VideoMkriPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(videoMkriProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Live Streaming & Video'),
      ),
      body: asyncList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(err.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada video'));
          }

          final liveVideos = list.where((v) => v.isLive).toList();
          final others =
              list.where((v) => v.status != VideoStatus.live).toList()
                ..sort((a, b) {
                  final da = a.publishtime ?? DateTime(1970);
                  final db = b.publishtime ?? DateTime(1970);
                  return db.compareTo(da);
                });

          return RefreshIndicator(
            onRefresh: () => ref.read(videoMkriProvider.notifier).refresh(),
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              'Live Streaming Dan Video Conference',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                                height: 1.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => UrlHelper.open(
                              'https://www.youtube.com/@MahkamahKonstitusiRI',
                            ),
                            icon: const Icon(
                              Icons.smart_display,
                              size: 14,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Watch on YouTube',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              minimumSize: const Size(0, 30),
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      InkWell(
                        onTap: () => UrlHelper.open(
                          'https://www.mkri.id/public/content/persidangan/vicon/Tata%20Cara%20Pelayanan%20VICON.pdf',
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tata Cara Pelayanan Persidangan Jarak Jauh Melalui Video Conference',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.open_in_new,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                LiveStreamingView(videos: liveVideos),
                const SizedBox(height: 24),

                if (others.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Video Lainnya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: VideoMkriCard.cardHeight,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: others.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, i) =>
                          VideoMkriCard(video: others[i]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const ViconSection(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
