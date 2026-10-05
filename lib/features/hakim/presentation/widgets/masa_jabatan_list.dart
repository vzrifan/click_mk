import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/hakim/data/models/masa_jabatan.dart';
import 'package:flutter/material.dart';

class MasaJabatanList extends StatelessWidget {
  const MasaJabatanList({super.key, required this.items});

  final List<MasaJabatan> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text(
        'Tidak ada data masa jabatan',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Masa Jabatan :',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 10),

        for (int i = 0; i < items.length; i++) ...[
          _buildRow(i + 1, items[i]),
          if (i < items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildRow(int nomor, MasaJabatan m) {
    final pengusul =
        (m.lembagaPengusul == null ||
            m.lembagaPengusul!.isEmpty ||
            m.lembagaPengusul!.toLowerCase() == 'null')
        ? '-'
        : m.lembagaPengusul!;

    final teks =
        '$nomor : ${m.jabatan} ${m.tahunMenjabat} s/d ${m.tahunSelesaiMenjabat}, '
        'Lembaga Pengusul : $pengusul';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 7, right: 8),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            teks,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }
}
