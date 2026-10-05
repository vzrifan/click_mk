import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/presentation/widgets/hakim_card.dart';
import 'package:flutter/material.dart';

class HakimPlainList extends StatelessWidget {
  const HakimPlainList({
    super.key,
    required this.list,
    required this.onRefresh,
    required this.onTapHakim,
  });

  final List<Hakim> list;
  final Future<void> Function() onRefresh;
  final void Function(Hakim) onTapHakim;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada data hakim'));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final h = list[i];
          return HakimCard(
            hakim: h,
            showJabatan: false,
            onTap: () => onTapHakim(h),
          );
        },
      ),
    );
  }
}
