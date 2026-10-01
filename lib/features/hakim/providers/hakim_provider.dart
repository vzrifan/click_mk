import 'package:click_mk/features/hakim/data/hakim_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';

final hakimRepositoryProvider = Provider<HakimRepository>((ref) {
  return HakimRepository(ref.watch(dioClientProvider));
});

class HakimListNotifier extends AsyncNotifier<List<Hakim>> {
  @override
  Future<List<Hakim>> build() async {
    final repo = ref.watch(hakimRepositoryProvider);
    final page = await repo.getHakim();
    return page.items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(hakimRepositoryProvider);
      final page = await repo.getHakim();
      return page.items;
    });
  }
}

final hakimListProvider =
    AsyncNotifierProvider.autoDispose<HakimListNotifier, List<Hakim>>(
      HakimListNotifier.new,
    );
