import 'package:click_mk/core/constants/app_colors.dart';
import 'package:click_mk/core/widgets/pagination_bar.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_endpoint.dart';
import 'package:click_mk/features/peraturan/providers/peraturan_provider.dart';
import 'package:click_mk/features/peraturan/presentation/widgets/peraturan_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeraturanListPage extends ConsumerWidget {
  const PeraturanListPage({super.key, required this.endpoint});

  final PeraturanEndpoint endpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(peraturanListProvider(endpoint));
    final notifier = ref.read(peraturanListProvider(endpoint).notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(endpoint.title),
      ),
      body: PeraturanList(endpoint: endpoint),
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
