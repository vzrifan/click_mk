import 'package:flutter/material.dart';

class BeritaSkeleton extends StatelessWidget {
  const BeritaSkeleton({super.key, this.width = 260, this.height = 200});

  final double width;
  final double height;

  static const double defaultHeight = 200;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(aspectRatio: 16 / 9, child: _shimmerBox()),
          ),
          const SizedBox(height: 10),

          _shimmerBox(height: 12, width: 100),
          const SizedBox(height: 8),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _shimmerBox(height: 14, width: width * 0.9),
                const SizedBox(height: 6),
                _shimmerBox(height: 14, width: width * 0.6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class BeritaSkeletonList extends StatelessWidget {
  const BeritaSkeletonList({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: BeritaSkeleton.defaultHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => const BeritaSkeleton(
          width: 240,
          height: BeritaSkeleton.defaultHeight,
        ),
      ),
    );
  }
}
