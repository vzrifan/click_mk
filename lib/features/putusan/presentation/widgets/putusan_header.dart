import 'package:click_mk/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PutusanHeader extends StatelessWidget {
  const PutusanHeader({super.key});

  static const _deskripsi =
      'Sidang Pengucapan Putusan merupakan tahap akhir dalam proses '
      'persidangan di MK. Sidang Pengucapan Putusan dilaksanakan dalam '
      'Sidang Pleno terbuka untuk umum yang dihadiri paling sedikit '
      '7 (tujuh) orang Hakim dan para pihak. Putusan MK, mempunyai '
      'kekuatan hukum mengikat sejak diucapkan dalam Sidang Pleno '
      'terbuka. Putusan yang telah diucapkan dalam Sidang Pleno '
      'diunggah pada laman MK (www.mkri.id) dan dapat diakses oleh '
      'masyarakat.';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Putusan Mahkamah Konstitusi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 6),
          const Text(_deskripsi, style: TextStyle(fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }
}
