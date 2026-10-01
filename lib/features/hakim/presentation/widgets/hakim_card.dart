import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_photo.dart';
import 'package:flutter/material.dart';

class HakimCard extends StatelessWidget {
  const HakimCard({super.key, required this.hakim, this.onTap});

  final Hakim hakim;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HakimPhoto(url: hakim.profilePictureUrl, width: 56),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hakim.namaLengkap,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        hakim.jabatan,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hakim.masaJabatan.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '${hakim.masaJabatan.first.tahunMenjabat}'
                        ' – ${hakim.masaJabatan.first.tahunSelesaiMenjabat}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
