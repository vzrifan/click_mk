import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_menu.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/struktur_organisasi_view.dart';
import 'package:click_mk/features/peradilan/providers/peradilan_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/peradilan_content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class PeradilanPage extends ConsumerStatefulWidget {
  const PeradilanPage({super.key});

  @override
  ConsumerState<PeradilanPage> createState() => _PeradilanPageState();
}

class _PeradilanPageState extends ConsumerState<PeradilanPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: PeradilanMenu.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Peradilan'),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: PeradilanMenu.values
              .map((menu) => Tab(text: menu.title))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        physics: const NeverScrollableScrollPhysics(),
        children: PeradilanMenu.values
            .map((menu) => _buildTabContent(menu))
            .toList(),
      ),
    );
  }

  Widget _buildTabContent(PeradilanMenu menu) {
    switch (menu) {
      case PeradilanMenu.peradilan:
        return const _InfoTab();
      case PeradilanMenu.sejarahPerkembangan:
        return _ContentTab(
          menu: menu,
          provider: peradilanSejarahPerkembanganProvider,
        );
      case PeradilanMenu.visiMisi:
        return _ContentTab(menu: menu, provider: peradilanVisiMisiProvider);
      case PeradilanMenu.kedudukanKewenangan:
        return _ContentTab(
          menu: menu,
          provider: peradilanKedudukanKewenanganProvider,
        );
      case PeradilanMenu.strukturOrganisasi:
        return StrukturOrganisasiView();
      default:
        return _PlaceholderTab(menu: menu);
    }
  }
}

class _InfoTab extends ConsumerWidget {
  const _InfoTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(peradilanSejarahProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        error: err,
        onRetry: () => ref.read(peradilanSejarahProvider.notifier).refresh(),
      ),
      data: (data) {
        if (data.contentHtml.isEmpty) {
          return const Center(
            child: Text(
              'Konten belum tersedia',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(peradilanSejarahProvider.notifier).refresh(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mahkamah Konstitusi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 12),
                HtmlWidget(
                  data.contentHtml,
                  textStyle: const TextStyle(
                    fontSize: 13,
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
                if (data.updatedAt != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.update, size: 11, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Diperbarui: '
                        '${DateFormatter.tanggalWaktuWib(data.updatedAt)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContentTab extends ConsumerWidget {
  const _ContentTab({required this.menu, required this.provider});

  final PeradilanMenu menu;
  final AsyncNotifierProvider<PeradilanContentNotifier, PeradilanContent>
  provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(provider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorView(
        error: err,
        onRetry: () => ref.read(provider.notifier).refresh(),
      ),
      data: (content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              menu.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
                height: 1.3,
              ),
            ),
          ),

          Expanded(
            child: PeradilanContentView(
              content: content,
              onRefresh: () => ref.read(provider.notifier).refresh(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.menu});

  final PeradilanMenu menu;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              menu.icon,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              menu.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Konten belum tersedia',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      ),
    );
  }
}
