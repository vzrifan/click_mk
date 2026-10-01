import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_photo.dart';
import 'package:flutter/material.dart';

class HakimFeaturedCard extends StatelessWidget {
  const HakimFeaturedCard({
    super.key,
    required this.hakim,
    this.onTap,
    this.accentColor,
  });

  final Hakim hakim;
  final VoidCallback? onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? const Color(0xFF1E4E8C);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: Colors.black12,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HakimPhoto(url: hakim.profilePictureUrl),

            // Badge
            Container(
              color: accent,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                hakim.jabatan.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Nama
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Text(
                hakim.namaLengkap,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
