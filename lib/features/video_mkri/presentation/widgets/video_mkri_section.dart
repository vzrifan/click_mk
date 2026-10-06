import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/video_mkri/data/models/video_status.dart';
import 'package:click_mk/features/video_mkri/providers/video_mkri_provider.dart';
import 'package:click_mk/features/video_mkri/presentation/widgets/video_mkri_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VideoMkriSection extends ConsumerWidget {
  const VideoMkriSection({super.key});

  static const _maxVisible = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(videoMkriProvider);

    return asyncList.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();

        final sorted = [...list]
          ..sort((a, b) {
            final priority = {
              VideoStatus.live: 0,
              VideoStatus.upcoming: 1,
              VideoStatus.onDemand: 2,
            };
            final pa = priority[a.status] ?? 3;
            final pb = priority[b.status] ?? 3;
            if (pa != pb) return pa.compareTo(pb);
            final da = a.publishtime ?? DateTime(1970);
            final db = b.publishtime ?? DateTime(1970);
            return db.compareTo(da);
          });

        final visibleItems = sorted.take(_maxVisible).toList();

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Live Streaming & Video',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed(AppRoutes.videoMkriName),
                      child: const Text(
                        'Selengkapnya',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleItems.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, i) =>
                      VideoMkriCard(video: visibleItems[i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
