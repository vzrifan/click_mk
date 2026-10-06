import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/hit_helper.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/pengumuman/data/models/jenis_supporting_file.dart';
import 'package:click_mk/features/pengumuman/data/models/pengumuman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PengumumanCard extends ConsumerWidget {
  const PengumumanCard({super.key, required this.pengumuman});

  final Pengumuman pengumuman;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: pengumuman.hasFile
            ? () {
                HitHelper.fire(ref, pengumuman.linkHitClean);
                UrlHelper.open(pengumuman.supportingFile);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengumuman.judul,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildMetadata(),
                  ],
                ),
              ),
              if (pengumuman.hasFile)
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 2),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata() {
    final hasDate = pengumuman.date != null;
    final hasDownload = pengumuman.downloadCount > 0;

    if (!hasDate && !hasDownload) return const SizedBox.shrink();

    return Row(
      children: [
        if (hasDate) ...[
          const Icon(
            Icons.calendar_today_outlined,
            size: 11,
            color: Colors.grey,
          ),
          const SizedBox(width: 3),
          Text(
            DateFormatter.tanggalPendek(pengumuman.date),
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
        if (hasDate && hasDownload) const SizedBox(width: 10),
        if (hasDownload) ...[
          const Icon(Icons.download_outlined, size: 11, color: Colors.grey),
          const SizedBox(width: 3),
          Text(
            '${pengumuman.downloadCount}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildIcon() {
    final (icon, color) = switch (pengumuman.jenisSupportingFile) {
      JenisSupportingFile.pdf => (Icons.picture_as_pdf, Colors.red),
      JenisSupportingFile.img => (Icons.image_outlined, Colors.green),
      JenisSupportingFile.link => (Icons.link, Colors.blue),
      JenisSupportingFile.none => (Icons.article_outlined, Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 22, color: color),
    );
  }
}
