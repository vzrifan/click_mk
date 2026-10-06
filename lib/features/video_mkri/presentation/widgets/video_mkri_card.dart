import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/video_mkri/data/models/video_mkri.dart';
import 'package:click_mk/features/video_mkri/data/models/video_status.dart';
import 'package:flutter/material.dart';

class VideoMkriCard extends StatelessWidget {
  const VideoMkriCard({super.key, required this.video});

  final VideoMkri video;

  static const double cardHeight = 220;
  static const double cardWidth = 260;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => UrlHelper.open(video.youtubeUrl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: video.videoThumbnail.isEmpty
                        ? Container(color: Colors.grey.shade200)
                        : CachedNetworkImage(
                            imageUrl: video.videoThumbnail,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                Container(color: Colors.grey.shade100),
                            errorWidget: (_, _, _) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                  ),

                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),

                  Positioned(bottom: 8, right: 8, child: _buildBadge()),

                  if (video.status == VideoStatus.live)
                    Positioned(top: 8, left: 8, child: _buildLiveBadge()),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        video.relativeTime,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    final label = switch (video.status) {
      VideoStatus.live => 'Sedang Live',
      VideoStatus.upcoming => 'Segera',
      VideoStatus.onDemand => 'Siaran Ulang',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'LIVE',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
