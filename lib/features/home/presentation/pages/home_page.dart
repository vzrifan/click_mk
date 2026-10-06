import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/berita/presentation/widgets/berita_section.dart';
import 'package:click_mk/features/berita/providers/berita_provider.dart';
import 'package:click_mk/features/home/presentation/widgets/banner_carousel.dart';
import 'package:click_mk/features/home/presentation/widgets/jadwal_sidang_calendar.dart';
import 'package:click_mk/features/home/providers/banner_provider.dart';
import 'package:click_mk/features/home/providers/home_provider.dart';
import 'package:click_mk/features/pengumuman/data/providers/pengumuman_provider.dart';
import 'package:click_mk/features/pengumuman/presentation/widgets/pengumuman_highlight.dart';
import 'package:click_mk/features/video_mkri/presentation/widgets/video_mkri_section.dart';
import 'package:click_mk/features/video_mkri/providers/video_mkri_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            'assets/images/logo/garuda.png',
            errorBuilder: (c, e, s) =>
                const Icon(Icons.error, color: Colors.red),
          ),
        ),
        title: const Text('Mahkamah Konstitusi RI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BannerCarousel(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Info Perkara',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildMenuGrid(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const JadwalSidangCalendar(),
              const SizedBox(height: 16),
              const PengumumanHighlight(),
              const SizedBox(height: 16),
              const VideoMkriSection(),
              const SizedBox(height: 16),
              const BeritaSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    final now = DateTime.now();

    ref.invalidate(bannerListProvider);
    ref.invalidate(jadwalSidangProvider((month: now.month, year: now.year)));
    ref.invalidate(pengumumanHighlightProvider);
    ref.invalidate(videoMkriProvider);
    ref.invalidate(beritaHighlightProvider);

    try {
      await Future.wait([
        ref.read(bannerListProvider.future),
        ref.read(
          jadwalSidangProvider((month: now.month, year: now.year)).future,
        ),
        ref.read(pengumumanHighlightProvider.future),
        ref.read(videoMkriProvider.future),
        ref.read(beritaHighlightProvider.future),
      ]);
    } catch (_) {}
  }

  static const _menus = [
    (icon: Icons.gavel, title: 'Putusan', path: AppRoutes.putusanName),
    (
      icon: Icons.menu_book_outlined,
      title: 'Risalah',
      path: AppRoutes.risalahName,
    ),
    (
      icon: Icons.summarize_outlined,
      title: 'Ikhtisar',
      path: AppRoutes.ikhtisarName,
    ),
    (icon: Icons.edit_note, title: 'Anotasi', path: AppRoutes.anotasiName),
    (
      icon: Icons.cloud_upload_outlined,
      title: 'Permohonan Online',
      path: AppRoutes.permohonanOnlineName,
    ),
    (
      icon: Icons.library_books_outlined,
      title: 'PUU & SKLN',
      path: AppRoutes.puuSklnName,
    ),
    (
      icon: Icons.how_to_vote_outlined,
      title: 'Pilkada Serentak',
      path: AppRoutes.pilkadaSerentakName,
    ),
    (
      icon: Icons.bar_chart_outlined,
      title: 'PHPU & Pilpres',
      path: AppRoutes.phpuPilpresName,
    ),
  ];

  Widget _buildMenuGrid(BuildContext context) {
    const maxExtent = 100.0;
    const spacing = 12.0;
    const aspectRatio = 0.85;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final columns = (availableWidth / (maxExtent + spacing)).ceil().clamp(
          1,
          20,
        );
        final itemWidth = (availableWidth - spacing * (columns - 1)) / columns;
        final itemHeight = itemWidth / aspectRatio;

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final menu in _menus)
                SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: _buildMenuCard(
                    context,
                    icon: menu.icon,
                    title: menu.title,
                    path: menu.path,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String path,
  }) {
    return GestureDetector(
      onTap: () => context.goNamed(path),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                title,
                style: const TextStyle(fontSize: 11, color: AppColors.text),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
