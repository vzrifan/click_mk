import 'package:click_mk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HakimPage extends StatelessWidget {
  const HakimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hakim Konstitusi',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryDark,
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildBanner()),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final judges = [
                {
                  'name': 'Dr. Anwar Usman, S.H., M.H.',
                  'term': '6 April 2016 s/d 6 April 2021',
                  'proposer': 'Mahkamah Agung',
                  'image': 'https://i.pravatar.cc/150?img=68',
                },
                {
                  'name': 'Prof. Dr. Arief Hidayat, S.H., M.S.',
                  'term': '27 Maret 2018 s/d 27 Maret 2023',
                  'proposer': 'Dewan Perwakilan Rakyat',
                  'image': 'https://i.pravatar.cc/150?img=69',
                },
                {
                  'name': 'Prof. Dr. Enny Nurbaningsih, S.H.,M.Hum.',
                  'term': '13 Agustus 2018 s/d 13 Agustus 2023',
                  'proposer': 'Presiden Joko Widodo',
                  'image': 'https://i.pravatar.cc/150?img=5',
                },
                {
                  'name': 'Dr. Daniel Yusmic Pancastaki Foekh, S.H., M.H.',
                  'term': '7 Januari 2020 s/d 7 Januari 2025',
                  'proposer': 'Presiden Joko Widodo',
                  'image': 'https://i.pravatar.cc/150?img=11',
                },
              ];
              final judge = judges[index];
              return _buildJudgeTile(
                judge['name']!,
                judge['term']!,
                judge['proposer']!,
                judge['image']!,
              );
            }, childCount: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3E5AB),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaderCard(
            'Dr. Suhartoyo, S.H., M.H.',
            'KETUA MK',
            'https://i.pravatar.cc/150?img=60',
          ),
          _buildLeaderCard(
            'Prof. Dr. Saldi Isra., S.H., MPA.',
            'WAKIL KETUA MK',
            'https://i.pravatar.cc/150?img=61',
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderCard(String name, String title, String imageUrl) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Container(
            width: 110,
            height: 140,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.secondary, width: 6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJudgeTile(
    String name,
    String term,
    String proposer,
    String imageUrl,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Hakim Konstitusi',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  term,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Lembaga Pengusul : $proposer',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
