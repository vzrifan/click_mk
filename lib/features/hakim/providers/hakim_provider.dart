import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/hakim/data/hakim_repository.dart';
import 'package:click_mk/features/hakim/data/models/hakim.dart';
import 'package:click_mk/features/hakim/data/models/jabatan_filter.dart';

final hakimRepositoryProvider = Provider<HakimRepository>((ref) {
  return HakimRepository(ref.watch(dioClientProvider));
});

class HakimSekarangNotifier extends AsyncNotifier<List<Hakim>> {
  @override
  Future<List<Hakim>> build() async {
    final repo = ref.watch(hakimRepositoryProvider);
    return repo.getHakim();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(hakimRepositoryProvider);
      return repo.getHakim();
    });
  }
}

final hakimSekarangProvider =
    AsyncNotifierProvider.autoDispose<HakimSekarangNotifier, List<Hakim>>(
      HakimSekarangNotifier.new,
    );

class HakimSebelumnyaNotifier extends AsyncNotifier<List<Hakim>> {
  HakimSebelumnyaNotifier(this.jabatan);

  final JabatanFilter jabatan;

  @override
  Future<List<Hakim>> build() async {
    final repo = ref.watch(hakimRepositoryProvider);
    return repo.getHakimPeriodeSebelumnya(jabatan: jabatan);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(hakimRepositoryProvider);
      return repo.getHakimPeriodeSebelumnya(jabatan: jabatan);
    });
  }
}

final hakimSebelumnyaProvider = AsyncNotifierProvider.family
    .autoDispose<HakimSebelumnyaNotifier, List<Hakim>, JabatanFilter>(
      HakimSebelumnyaNotifier.new,
    );

final hakimDetailProvider = FutureProvider.family<Hakim, int>((ref, id) async {
  final repo = ref.watch(hakimRepositoryProvider);
  return repo.getHakimDetail(id);
});
