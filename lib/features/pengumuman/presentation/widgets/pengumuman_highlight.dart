import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/router/routes.dart';
import 'package:click_mk/features/pengumuman/data/providers/pengumuman_provider.dart';
import 'package:click_mk/features/pengumuman/presentation/widgets/pengumuman_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PengumumanHighlight extends ConsumerStatefulWidget {
  const PengumumanHighlight({super.key});

  @override
  ConsumerState<PengumumanHighlight> createState() =>
      _PengumumanHighlightState();
}

class _PengumumanHighlightState extends ConsumerState<PengumumanHighlight> {
  static const _maxVisible = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(pengumumanHighlightProvider);

    return asyncList.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();

        final hasMore = list.length > _maxVisible;
        final visibleItems = _expanded ? list : list.take(_maxVisible).toList();
        final remaining = list.length - _maxVisible;

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pengumuman',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.goNamed(AppRoutes.pengumumanName),
                    child: const Text(
                      'Selengkapnya',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              for (int i = 0; i < visibleItems.length; i++) ...[
                PengumumanCard(pengumuman: visibleItems[i]),
                if (i < visibleItems.length - 1) const SizedBox(height: 8),
              ],

              if (hasMore)
                Center(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    icon: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                    label: Text(
                      _expanded ? 'Sembunyikan' : 'Lihat $remaining lainnya',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
