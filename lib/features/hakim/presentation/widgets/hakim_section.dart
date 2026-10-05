import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_card.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_featured_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HakimSection extends ConsumerWidget {
  const HakimSection({
    super.key,
    required this.list,
    required this.onRefresh,
    required this.onTapHakim,
  });

  final List<Hakim> list;
  final Future<void> Function() onRefresh;
  final void Function(Hakim) onTapHakim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada data hakim'));
    }

    final ketua = list.firstWhere((h) => h.isKetua, orElse: () => _empty());
    final wakil = list.firstWhere(
      (h) => h.isWakilKetua,
      orElse: () => _empty(),
    );
    final hasKetua = ketua.namaLengkap.isNotEmpty;
    final hasWakil = wakil.namaLengkap.isNotEmpty;
    final others = list.where((h) => !h.isKetua && !h.isWakilKetua).toList();

    final hasFeatured = hasKetua || hasWakil;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (hasFeatured)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ketua.idHakim != 0)
                      Expanded(
                        child: HakimFeaturedCard(
                          hakim: ketua,
                          onTap: () => onTapHakim(ketua),
                        ),
                      ),
                    if (ketua.idHakim != 0 && wakil.idHakim != 0)
                      const SizedBox(width: 12),
                    if (wakil.idHakim != 0)
                      Expanded(
                        child: HakimFeaturedCard(
                          hakim: wakil,
                          onTap: () => onTapHakim(wakil),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          if (hasFeatured && others.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Hakim Konstitusi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
          ],

          for (final h in others) ...[
            HakimCard(hakim: h, onTap: () => onTapHakim(h)),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  static Hakim _empty() => const Hakim(
    nomorUrut: 0,
    idHakim: 0,
    namaLengkap: '',
    profilePictureUrl: '',
    jabatan: '',
    masaJabatan: [],
    status: 0,
    profilHtml: '',
  );
}
