import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/models/jabatan.dart';
import 'package:flutter/material.dart';

class JabatanNodeCard extends StatelessWidget {
  const JabatanNodeCard({
    super.key,
    required this.jabatan,
    required this.onTap,
  });

  final Jabatan jabatan;
  final VoidCallback onTap;

  Color get _color {
    if (jabatan.isHakim) return const Color(0xFF1E4E8C);
    if (jabatan.isPejabat) return const Color(0xFF3B7DB8);
    return const Color(0xFF5BA3D0);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border(left: BorderSide(color: _color, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                jabatan.isHakim
                    ? Icons.gavel
                    : jabatan.isPejabat
                    ? Icons.badge_outlined
                    : Icons.person_outline,
                size: 18,
                color: _color,
              ),
              const SizedBox(height: 6),

              Text(
                _formatJabatan(jabatan.jabatan),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Lihat detail',
                    style: TextStyle(
                      fontSize: 9,
                      color: _color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, size: 14, color: _color),
                ],
              ),
            ],
          ),
        ),
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
