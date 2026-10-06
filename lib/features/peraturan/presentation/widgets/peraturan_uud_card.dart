import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_uud.dart';
import 'package:flutter/material.dart';

class PeraturanUudCard extends StatelessWidget {
  const PeraturanUudCard({super.key, required this.peraturan});

  final PeraturanUud peraturan;

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
            Text(
              peraturan.judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.text,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),

            if (peraturan.createdDate != null)
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 11,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    DateFormatter.tanggalPendek(peraturan.createdDate),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Spacer(),
                if (peraturan.hasFile)
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await UrlHelper.open(
                        peraturan.supportingFileUrl,
                      );
                      if (!context.mounted) return;
                      if (!ok) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Gagal membuka file')),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.download,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${peraturan.downloadCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
