import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar.dart';
import 'package:flutter/material.dart';

class IkhtisarCard extends StatelessWidget {
  const IkhtisarCard({super.key, required this.ikhtisar});

  final Ikhtisar ikhtisar;

  @override
  Widget build(BuildContext context) {
    final perkara = ikhtisar.tbPerkara;

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (perkara != null && perkara.jenisPerkara.isNotEmpty)
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
                      perkara.jenisPerkara,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 11,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Text(
                  DateFormatter.tanggalPendek(ikhtisar.date),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              perkara?.noPerkara ?? '-',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              ikhtisar.pokokPerkara,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.text),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, size: 11, color: Colors.grey),
                const SizedBox(width: 3),
                Text(
                  DateFormatter.waktuWib(ikhtisar.date),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    perkara?.pemohon ?? 'Anonim',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: ikhtisar.hasPdf
                      ? () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final ok = await UrlHelper.open(
                            ikhtisar.supportingFile,
                          );
                          if (!context.mounted) return;
                          if (!ok) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Gagal membuka file'),
                              ),
                            );
                          }
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.download,
                          size: 16,
                          color: ikhtisar.hasPdf ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${ikhtisar.downloadCount}',
                          style: TextStyle(
                            fontSize: 11,
                            color: ikhtisar.hasPdf ? Colors.blue : Colors.grey,
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
