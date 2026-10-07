import 'package:click_mk/core/utils/hit_helper.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PutusanDownloadButton extends ConsumerWidget {
  const PutusanDownloadButton({
    super.key,
    required this.url,
    required this.linkHit,
    required this.downloadCount,
  });

  final String url;
  final String linkHit;
  final int downloadCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () async {
        HitHelper.fire(ref, linkHit);

        final messenger = ScaffoldMessenger.of(context);
        final ok = await UrlHelper.open(url);
        if (!context.mounted) return;
        if (!ok) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                url.isEmpty ? 'Link file tidak tersedia' : 'Gagal membuka file',
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.download, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              '$downloadCount',
              style: const TextStyle(fontSize: 11, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
