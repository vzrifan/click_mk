import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/core/utils/hit_helper.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/anotasi/data/models/anotasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnotasiCard extends ConsumerWidget {
  const AnotasiCard({super.key, required this.anotasi});

  final Anotasi anotasi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        HitHelper.fire(ref, anotasi.linkHit);

        final messenger = ScaffoldMessenger.of(context);
        final ok = await UrlHelper.open(anotasi.supportingFile);
        if (!context.mounted) return;
        if (!ok) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Gagal membuka file')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.description_outlined,
                size: 22,
                color: Color(0xFF1E4E8C),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    anotasi.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E6FD9),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        DateFormatter.tanggalWaktuWib(anotasi.date),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
