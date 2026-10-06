import 'package:click_mk/core/widgets/search_field.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_endpoint.dart';
import 'package:click_mk/features/peraturan/providers/peraturan_provider.dart';
import 'package:click_mk/features/peraturan/presentation/widgets/peraturan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeraturanList extends ConsumerWidget {
  const PeraturanList({super.key, required this.endpoint});

  final PeraturanEndpoint endpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(peraturanListProvider(endpoint));
    final notifier = ref.read(peraturanListProvider(endpoint).notifier);

    return Column(
      children: [
        SearchField(
          hintText: 'Cari peraturan...',
          onChanged: (value) => notifier.setSearch(value),
        ),
        Expanded(
          child: asyncState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      err.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => notifier.refresh(),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
            data: (state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.search.isNotEmpty
                            ? 'Tidak ada hasil untuk "${state.search}"'
                            : 'Belum ada peraturan',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => notifier.refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      PeraturanCard(peraturan: state.items[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
