import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/berita/providers/berita_provider.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_card.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_chip_bar.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BeritaSection extends ConsumerWidget {
  const BeritaSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(beritaHighlightProvider);
    final notifier = ref.read(beritaHighlightProvider.notifier);

    return asyncData.when(
      loading: () => _buildSkeleton(),
      error: (_, _) => const SizedBox.shrink(),
      data: (state) {
        if (state.items.isEmpty) return const SizedBox.shrink();
        return _buildContent(context, state, notifier);
      },
    );
  }

  Widget _buildSkeleton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 32,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) => Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const BeritaSkeletonList(),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BeritaHighlightState state,
    BeritaHighlightNotifier notifier,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Berita MKRI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.beritaName),
                  child: const Text(
                    'Selengkapnya',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          BeritaChipBar(
            selected: state.kategori,
            onSelected: (k) => notifier.setKategori(k),
            onSiaranPersTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Siaran Pers belum tersedia')),
            ), // TODO: navigasi ke halaman siaran pers
          ),
          const SizedBox(height: 12),

          if (state.isLoading)
            const BeritaSkeletonList()
          else
            SizedBox(
              height: BeritaCard.sectionHeight,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) => BeritaCard(
                  berita: state.items[i],
                  width: 240,
                  height: BeritaCard.sectionHeight,
                  onTap: () => UrlHelper.open(state.items[i].webUrl),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
