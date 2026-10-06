import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/features/berita/data/models/berita.dart';
import 'package:flutter/material.dart';

class BeritaCard extends StatelessWidget {
  const BeritaCard({
    super.key,
    required this.berita,
    this.onTap,
    this.width = 260,
    this.height,
  });

  final Berita berita;
  final VoidCallback? onTap;
  final double width;
  final double? height;

  static const double sectionHeight = 220;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: berita.imageUrl.isEmpty
                      ? Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: berita.imageUrl,
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
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Flexible(
                    child: Text(
                      DateFormatter.tanggalWaktuWib(berita.date),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (berita.isHighlight) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'HIGHLIGHT',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),

              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const lineHeight = 18.2;
                    final maxLines = constraints.maxHeight.isFinite
                        ? (constraints.maxHeight / lineHeight).floor()
                        : 3;

                    return Text(
                      berita.judul,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        height: 1.4,
                      ),
                      maxLines: maxLines.clamp(1, 3),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
