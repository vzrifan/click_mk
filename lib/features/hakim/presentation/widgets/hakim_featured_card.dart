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
    final accent = accentColor ?? AppColors.primary;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.black12,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Foto (kecil, di tengah) ─────────
              Center(
                child: HakimPhoto(
                  url: hakim.profilePictureUrl,
                  height: 120, // ⬅ dari 180+ → 120
                  borderRadius: 10,
                ),
              ),
              const SizedBox(height: 8),

              // ── Badge jabatan ───────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(20),
                ),
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
              const SizedBox(height: 6),

              // ── Nama ────────────────────────────
              Text(
                hakim.namaLengkap,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
