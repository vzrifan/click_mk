import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/core/utils/url_helper.dart';
import 'package:click_mk/features/home/presentation/widgets/banner_slide.dart';
import 'package:click_mk/features/home/presentation/widgets/carousel.dart';
import 'package:click_mk/features/home/presentation/widgets/jadwal_sidang_calendar.dart';
import 'package:click_mk/features/home/providers/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Mahkamah Konstitusi RI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final asyncBanner = ref.watch(bannerListProvider);

                      return asyncBanner.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (banners) {
                          if (banners.isEmpty) return const SizedBox.shrink();

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            for (final b in banners) {
                              precacheImage(
                                CachedNetworkImageProvider(b.imageUrl),
                                context,
                              );
                            }
                          });

                          return Carousel(
                            items: banners
                                .map((b) => BannerSlide(banner: b))
                                .toList(),
                            height: MediaQuery.of(context).size.height * 0.25,
                            onItemTap: (i) {
                              final url = banners[i].actionUrlAbsolute;
                              if (url != null) UrlHelper.open(url);
                            },
                          );
                        },
                      );
                    },
                  ),
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
            _buildHorizontalSection('Portal Mahkamah Konstitusi', [
              _buildImageCard(
                'https://picsum.photos/250?image=10',
                'simpel.mkri.id',
                'Sistem Informasi Penanganan Perkara Elektronik',
              ),
              _buildImageCard(
                'https://picsum.photos/250?image=11',
                'Pilkada Serentak 2020',
                'Portal Informasi Perkara Pemilihan Umum 2019',
              ),
              _buildImageCard(
                'https://picsum.photos/250?image=12',
                'Pengujian UU',
                'Portal Informasi Pengujian Undang-undang',
              ),
            ]),
            const SizedBox(height: 8),
            _buildHorizontalSection('Administrasi Umum Mahkamah Konstitusi', [
              _buildImageCard(
                'https://picsum.photos/250?image=13',
                'Informasi',
                'Informasi lainnya terkait Mahkamah Konstitusi',
              ),
              _buildImageCard(
                'https://picsum.photos/250?image=14',
                'Permohonan Informasi',
                'Pejabat Pengelola Informasi dan Dokumentasi (PPID)',
              ),
              _buildImageCard(
                'https://picsum.photos/250?image=15',
                'Akuntabilitas',
                'Informasi akuntabilitas publik Mahkamah Konstitusi',
              ),
            ]),
            const SizedBox(height: 8),
            _buildHorizontalSection('Publikasi Mahkamah Konstitusi', [
              _buildImageCard(
                'https://picsum.photos/250?image=16',
                'Majalah Konstitusi',
                'Majalah bulanan Mahkamah Konstitusi',
              ),
              _buildImageCard(
                'https://picsum.photos/250?image=17',
                'Buku MK',
                'Kumpulan buku terbitan Mahkamah Konstitusi',
              ),
              _buildImageCard(
                'https://picsum.photos/250?image=18',
                'Jurnal Konstitusi',
                'Jurnal ilmiah tentang konstitusi',
              ),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static const _menus = [
    (
      icon: Icons.gavel,
      title: 'Putusan',
      color: AppColors.primary,
      path: AppRoutes.putusanName,
    ),
    (
      icon: Icons.assignment,
      title: 'Risalah',
      color: AppColors.primary,
      path: AppRoutes.risalahName,
    ),
    (
      icon: Icons.description,
      title: 'Ikhtisar',
      color: AppColors.primary,
      path: AppRoutes.ikhtisarName,
    ),
    (
      icon: Icons.edit_document,
      title: 'Anotasi',
      color: AppColors.primary,
      path: AppRoutes.anotasiName,
    ),
    (
      icon: Icons.text_snippet,
      title: 'Permohonan Online',
      color: AppColors.primary,
      path: AppRoutes.permohonanOnlineName,
    ),
    (
      icon: Icons.app_registration,
      title: 'PUU & SKLN',
      color: AppColors.primary,
      path: AppRoutes.puuSklnName,
    ),
    (
      icon: Icons.poll,
      title: 'Pilkada Serentak',
      color: AppColors.primary,
      path: AppRoutes.pilkadaSerentakName,
    ),
    (
      icon: Icons.polyline,
      title: 'PHPU & Pilpres',
      color: AppColors.primary,
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
                    color: menu.color,
                    path: menu.path,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalSection(String title, List<Widget> items) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) => items[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, String title, String subtitle) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required String path,
  }) {
    return GestureDetector(
      onTap: () => context.go(path),
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
            Icon(icon, size: 32, color: color),
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

class OvalBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
