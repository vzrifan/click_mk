import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class PeradilanContentView extends StatelessWidget {
  const PeradilanContentView({
    super.key,
    required this.content,
    this.onRefresh,
  });

  final PeradilanContent content;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (content.contentHtml.isEmpty) {
      return const Center(
        child: Text(
          'Konten belum tersedia',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final child = SingleChildScrollView(
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
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return true;
          }
          return false;
        },
      ),
    );

    if (onRefresh != null) {
      return RefreshIndicator(onRefresh: onRefresh!, child: child);
    }

    return child;
  }
}
