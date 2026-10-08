import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/providers/mkmk_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class MkmkHistoriTab extends ConsumerWidget {
  const MkmkHistoriTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(mkmkHistoriKelembagaanProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MkmkTabHeader(title: 'Histori Kelembagaan'),
        Expanded(
          child: asyncData.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      err.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(mkmkHistoriKelembagaanProvider),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
            data: (content) {
              if (content.contentHtml.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data histori kelembagaan',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(mkmkHistoriKelembagaanProvider),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: HtmlWidget(
                    content.contentHtml,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: AppColors.text,
                    ),
                    onTapUrl: (url) async {
                      final uri = Uri.tryParse(url);
                      if (uri == null) return false;
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                        return true;
                      }
                      return false;
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
