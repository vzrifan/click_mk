import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/home/presentation/widgets/carousel.dart';
import 'package:click_mk/features/home/presentation/widgets/jadwal_sidang_calendar.dart';
import 'package:flutter/material.dart';

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
                  ClipPath(
                    clipper: OvalBottomClipper(),
                    child: Carousel(
                      items: [
                        Image.network(
                          'https://placehold.net/1.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Image.network(
                          'https://placehold.net/2.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Image.network(
                          'https://placehold.net/3.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Image.network(
                          'https://placehold.net/4.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Image.network(
                          'https://placehold.net/5.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Image.network(
                          'https://placehold.net/6.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ],
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
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
    (Icons.gavel, 'Putusan', Colors.brown),
    (Icons.assignment, 'Risalah', Colors.blue),
    (Icons.description, 'Ikhtisar', Colors.redAccent),
    (Icons.edit_document, 'Anotasi', Colors.orange),
    (Icons.assignment, 'Permohonan Online', Colors.teal),
    (Icons.app_registration, 'PUU & SKLN', Colors.pink),
    (Icons.poll, 'Pilkada Serentak', Colors.green),
    (Icons.polyline, 'PHPU & Pilpres', Colors.red),
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
                  child: _buildMenuCard(context, menu.$1, menu.$2, menu.$3),
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
    BuildContext context,
    IconData icon,
    String title,
    Color color,
  ) {
    return Container(
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
