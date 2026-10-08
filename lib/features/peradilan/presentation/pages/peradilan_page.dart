import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_menu.dart';
import 'package:click_mk/features/peradilan/presentation/pages/mkmk_page.dart';
import 'package:click_mk/features/peradilan/presentation/pages/pejabat_page.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/struktur_organisasi_view.dart';
import 'package:click_mk/features/peradilan/providers/peradilan_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/peradilan_content_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
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
      body: NestedScrollView(
        // ⬇ AppBar pinned → tidak bisa tertutup platform view
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
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
        ],
        body: TabBarView(
          controller: _tab,
          children: PeradilanMenu.values
              .map((menu) => _buildTabContent(menu))
              .toList(),
        ),
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
      case PeradilanMenu.emblemHymneMars:
        return _ContentTab(
          menu: menu,
          provider: peradilanEmblemHymneMarsProvider,
        );
      case PeradilanMenu.strukturOrganisasi:
        return const StrukturOrganisasiView(); // TODO: Add Struktur Organisasi
      case PeradilanMenu.profilPejabat:
        return const PejabatPage();
      case PeradilanMenu.sumpahJanjiHakim:
        return _ContentTab(
          menu: menu,
          provider: peradilanJanjiHakimKonstitusiProvider,
        );
      case PeradilanMenu.lokasi:
        return _ContentTab(menu: menu, provider: peradilanLokasiProvider);
      case PeradilanMenu.tugasPokokFungsi:
        return _ContentTab(
          menu: menu,
          provider: peradilanTugasPokokFungsiProvider,
        );
      case PeradilanMenu.majelisKehormatan:
        return const MkmkPage();
    }
  }
}

// ── Tab Info (sejarah singkat) ──────────────────────
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

// ── Tab konten generik ──────────────────────────────
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
      data: (content) => PeradilanContentView(
        title: menu.title,
        content: content,
        onRefresh: () => ref.read(provider.notifier).refresh(),
      ),
    );
  }
}

// ── Error view ──────────────────────────────────────
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
