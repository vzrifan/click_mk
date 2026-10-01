import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class HakimDetailPage extends StatelessWidget {
  const HakimDetailPage({super.key, required this.hakim});

  final Hakim hakim;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil Hakim'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),

            // ── Riwayat Jabatan ────────────────
            if (hakim.masaJabatan.isNotEmpty) ...[
              _buildSection(
                title: 'Riwayat Jabatan',
                child: Column(
                  children: hakim.masaJabatan
                      .map((m) => _buildMasaJabatanRow(m))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // ── Profil (HTML) ──────────────────
            if (hakim.profilHtml.isNotEmpty)
              _buildSection(
                title: 'Profil',
                child: HtmlWidget(
                  hakim.profilHtml,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
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

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          HakimPhoto(
            url: hakim.profilePictureUrl,
            height: 180,
            borderRadius: 12,
          ),
          const SizedBox(height: 16),
          Text(
            hakim.namaLengkap,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              hakim.jabatan,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section wrapper ─────────────────────────
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ── Baris masa jabatan ──────────────────────
  Widget _buildMasaJabatanRow(dynamic m) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.badge_outlined,
              size: 14,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.jabatan as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${m.tahunMenjabat} – ${m.tahunSelesaiMenjabat}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                if (m.lembagaPengusul != null &&
                    (m.lembagaPengusul as String).isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Diusulkan: ${m.lembagaPengusul}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
