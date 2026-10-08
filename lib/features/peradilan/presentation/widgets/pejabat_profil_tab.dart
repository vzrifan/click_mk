import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/models/pejabat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PejabatProfilTab extends StatelessWidget {
  const PejabatProfilTab({super.key, required this.pejabat});

  final Pejabat pejabat;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: foto + nama + jabatan ──
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 140,
                    height: 180,
                    child: pejabat.profilePictureUrl.isEmpty
                        ? Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: pejabat.profilePictureUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  pejabat.nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pejabat.jabatan,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Info dasar ───────────────────────
          if (pejabat.alamat.isNotEmpty || pejabat.agama.isNotEmpty)
            _buildSection(
              title: 'Data Pribadi',
              children: [
                if (pejabat.alamat.isNotEmpty)
                  _buildRow('Alamat', pejabat.alamat),
                if (pejabat.agama.isNotEmpty) _buildRow('Agama', pejabat.agama),
                if (pejabat.organisasi.isNotEmpty)
                  _buildRow('Organisasi', pejabat.organisasi),
              ],
            ),

          // ── Profil (HTML) ────────────────────
          if (pejabat.profilHtml.isNotEmpty)
            _buildHtmlSection('Profil', pejabat.profilHtml),

          // ── Pendidikan (HTML) ────────────────
          if (pejabat.pendidikanHtml.isNotEmpty)
            _buildHtmlSection('Pendidikan', pejabat.pendidikanHtml),

          // ── Karir (HTML) ─────────────────────
          if (pejabat.karirHtml.isNotEmpty)
            _buildHtmlSection('Karir', pejabat.karirHtml),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const Text(':', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.text,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtmlSection(String title, String html) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          HtmlWidget(
            html,
            textStyle: const TextStyle(
              fontSize: 13,
              height: 1.6,
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
        ],
      ),
    );
  }
}
