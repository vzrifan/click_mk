import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/models/jabatan.dart';
import 'package:flutter/material.dart';

class JabatanDetailSheet extends StatelessWidget {
  const JabatanDetailSheet({super.key, required this.jabatan});

  final Jabatan jabatan;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                _formatJabatan(jabatan.jabatan),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _jenisColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _jenisLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: _jenisColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildRow('Jabatan ID', '${jabatan.jabatanId}'),
              _buildRow('Pejabat ID', '${jabatan.pejabatId}'),
              _buildRow('Eselon', _jenisLabel),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  String get _jenisLabel {
    if (jabatan.isHakim) return 'Hakim';
    if (jabatan.isPejabat) return 'Pejabat Struktural';
    return 'Pegawai';
  }

  Color get _jenisColor {
    if (jabatan.isHakim) return const Color(0xFF1E4E8C);
    if (jabatan.isPejabat) return const Color(0xFF3B7DB8);
    return const Color(0xFF5BA3D0);
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatJabatan(String raw) {
    return raw
        .split(' ')
        .map(
          (w) => w.isEmpty
              ? w
              : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
