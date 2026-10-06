import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/peraturan/providers/peraturan_provider.dart';
import 'package:click_mk/features/peraturan/presentation/widgets/peraturan_statistik_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PeraturanPage extends ConsumerWidget {
  const PeraturanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStatistik = ref.watch(peraturanStatistikProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Peraturan'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(peraturanStatistikProvider.notifier).refresh(),
        child: ListView(
          children: [
            asyncStatistik.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref
                            .read(peraturanStatistikProvider.notifier)
                            .refresh(),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (items) => PeraturanStatistikChart(items: items),
            ),

            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 8),

            _buildCategoryTile(
              context,
              icon: Icons.menu_book,
              title: 'Undang-Undang Dasar',
              subtitle: 'UUD Negara Republik Indonesia Tahun 1945',
              onTap: () => context.goNamed(AppRoutes.peraturanUudName),
            ),
            _buildCategoryTile(
              context,
              icon: Icons.rule,
              title: 'Peraturan MK',
              subtitle: 'Peraturan Mahkamah Konstitusi',
              onTap: () => context.goNamed(AppRoutes.peraturanMkName),
            ),
            _buildCategoryTile(
              context,
              icon: Icons.badge_outlined,
              title: 'Peraturan Ketua MK',
              subtitle: 'Peraturan Ketua Mahkamah Konstitusi',
              onTap: () => context.goNamed(AppRoutes.peraturanKetuaMkName),
            ),
            _buildCategoryTile(
              context,
              icon: Icons.description_outlined,
              title: 'Peraturan & Keputusan Sekjen',
              subtitle: 'Peraturan dan Keputusan Sekretaris Jenderal',
              onTap: () => context.goNamed(AppRoutes.peraturanSekjenName),
            ),
            _buildCategoryTile(
              context,
              icon: Icons.library_books,
              title: 'JDIH',
              subtitle: 'Jaringan Dokumentasi dan Informasi Hukum',
              onTap: () => UrlHelper.open('https://jdih.mkri.id'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
