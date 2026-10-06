import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/features/peraturan/providers/peraturan_provider.dart';
import 'package:click_mk/features/peraturan/presentation/widgets/peraturan_uud_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeraturanUudPage extends ConsumerWidget {
  const PeraturanUudPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(peraturanUudProvider);
    final notifier = ref.read(peraturanUudProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Undang-Undang Dasar'),
      ),
      body: const PeraturanUudList(),
      bottomNavigationBar: asyncState.maybeWhen(
        data: (state) {
          if (state.items.isEmpty || state.isLoading) return null;
          return SizedBox(
            height: 56,
            child: PaginationBar(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              onPageSelected: (page) => notifier.goToPage(page),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}
