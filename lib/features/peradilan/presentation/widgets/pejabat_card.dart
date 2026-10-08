import 'package:cached_network_image/cached_network_image.dart';
import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/peradilan/data/models/pejabat.dart';
import 'package:flutter/material.dart';

class PejabatCard extends StatelessWidget {
  const PejabatCard({super.key, required this.pejabat, required this.onTap});

  final Pejabat pejabat;
  final VoidCallback onTap;

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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Foto
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 80,
                  child: pejabat.profilePictureUrl.isEmpty
                      ? Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.grey,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: pejabat.profilePictureUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: Colors.grey.shade100),
                          errorWidget: (_, _, _) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pejabat.nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                        pejabat.jabatan,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
