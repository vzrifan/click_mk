import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_card.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_featured_card.dart';
import 'package:click_mk/features/hakim/providers/hakim_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HakimPage extends ConsumerWidget {
  const HakimPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHakim = ref.watch(hakimListProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Hakim Konstitusi'),
      ),
      body: asyncHakim.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(err.toString(), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(hakimListProvider.notifier).refresh(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada data hakim'));
          }

          // Pisahkan Ketua, Wakil, dan sisanya
          final ketua = list.firstWhere(
            (h) => h.isKetua,
            orElse: () => const Hakim(
              profileId: 0,
              namaLengkap: '',
              jabatan: '',
              profilePictureUrl: '',
              status: 0,
              profilHtml: '',
              nomorUrut: 0,
              masaJabatan: [],
            ),
          );
          final wakil = list.firstWhere(
            (h) => h.isWakilKetua,
            orElse: () => const Hakim(
              profileId: 0,
              namaLengkap: '',
              jabatan: '',
              profilePictureUrl: '',
              status: 0,
              profilHtml: '',
              nomorUrut: 0,
              masaJabatan: [],
            ),
          );

          final others = list
              .where((h) => !h.isKetua && !h.isWakilKetua)
              .toList();

          final hasFeatured = ketua.profileId != 0 || wakil.profileId != 0;

          return RefreshIndicator(
            onRefresh: () => ref.read(hakimListProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // ── Ketua & Wakil sejajar ───────────
                if (hasFeatured)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ketua.profileId != 0)
                        Expanded(
                          child: HakimFeaturedCard(
                            hakim: ketua,
                            accentColor: AppColors.primary,
                            onTap: () => _openDetail(context, ketua),
                          ),
                        ),
                      if (ketua.profileId != 0 && wakil.profileId != 0)
                        const SizedBox(width: 10),
                      if (wakil.profileId != 0)
                        Expanded(
                          child: HakimFeaturedCard(
                            hakim: wakil,
                            accentColor: AppColors.primary,
                            onTap: () => _openDetail(context, wakil),
                          ),
                        ),
                    ],
                  ),

                // ── Divider + label ─────────────────
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

                // ── Daftar hakim lainnya ────────────
                for (final h in others) ...[
                  HakimCard(hakim: h, onTap: () => _openDetail(context, h)),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, Hakim hakim) {
    context.pushNamed(
      AppRoutes.hakimDetailName,
      pathParameters: {'id': hakim.profileId.toString()},
      extra: hakim,
    );
  }
}
