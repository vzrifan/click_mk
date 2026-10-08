import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/utils/date_formatter.dart';
import 'package:click_mk/features/peradilan/providers/mkmk_provider.dart';
import 'package:click_mk/features/peradilan/presentation/widgets/mkmk/mkmk_tab_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MkmkProfilTab extends ConsumerWidget {
  const MkmkProfilTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(mkmkProfilProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MkmkTabHeader(title: 'Profil MKMK'),
        Expanded(
          child: asyncData.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(err.toString(), textAlign: TextAlign.center),
              ),
            ),
            data: (list) {
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data profil MKMK',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _MkmkProfilCard(profil: list[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MkmkProfilCard extends StatelessWidget {
  const _MkmkProfilCard({required this.profil});

  final dynamic profil;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 80,
                    height: 100,
                    child: profil.profilePictureUrl.isEmpty
                        ? Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: profil.profilePictureUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profil.nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          profil.jabatan,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (profil.masaJabatan.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Masa jabatan: ${profil.masaJabatan}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (profil.alamat.isNotEmpty) _buildRow('Alamat', profil.alamat),
            if (profil.agama.isNotEmpty) _buildRow('Agama', profil.agama),
            if (profil.tempatTanggalLahir != null)
              _buildRow(
                'Tempat, Tanggal Lahir',
                DateFormatter.tanggalPanjang(profil.tempatTanggalLahir),
              ),
            if (profil.profilHtml.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              HtmlWidget(
                profil.profilHtml,
                textStyle: const TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: AppColors.text,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const Text(':', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
