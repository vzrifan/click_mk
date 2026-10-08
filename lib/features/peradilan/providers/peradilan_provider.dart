import 'package:click_mk/features/peradilan/data/models/jabatan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_sejarah.dart';
import 'package:click_mk/features/peradilan/data/repositories/peradilan_repository.dart';

final peradilanRepositoryProvider = Provider<PeradilanRepository>((ref) {
  return PeradilanRepository(ref.watch(dioClientProvider));
});

class PeradilanSejarahNotifier extends AsyncNotifier<PeradilanSejarah> {
  @override
  Future<PeradilanSejarah> build() async {
    final repo = ref.watch(peradilanRepositoryProvider);
    return repo.getSejarah();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(peradilanRepositoryProvider);
      return repo.getSejarah();
    });
  }
}

final peradilanSejarahProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanSejarahNotifier,
      PeradilanSejarah
    >(PeradilanSejarahNotifier.new);

class PeradilanContentNotifier extends AsyncNotifier<PeradilanContent> {
  PeradilanContentNotifier(this.fetcher);
  final Future<PeradilanContent> Function(PeradilanRepository) fetcher;

  @override
  Future<PeradilanContent> build() async {
    final repo = ref.watch(peradilanRepositoryProvider);
    return fetcher(repo);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(peradilanRepositoryProvider);
      return fetcher(repo);
    });
  }
}

final peradilanSejarahPerkembanganProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getSejarahPerkembangan()));

final peradilanVisiMisiProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getVisiMisi()));

final peradilanKedudukanKewenanganProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getKedudukanKewenangan()));

class PeradilanJabatanNotifier extends AsyncNotifier<List<Jabatan>> {
  @override
  Future<List<Jabatan>> build() async {
    final repo = ref.watch(peradilanRepositoryProvider);
    return repo.getJabatan();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(peradilanRepositoryProvider);
      return repo.getJabatan();
    });
  }
}

final peradilanJabatanProvider =
    AsyncNotifierProvider.autoDispose<PeradilanJabatanNotifier, List<Jabatan>>(
      PeradilanJabatanNotifier.new,
    );

final peradilanEmblemHymneMarsProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getEmblemHymneMars()));

final peradilanJanjiHakimKonstitusiProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getJanjiHakimKonstitusi()));

final peradilanLokasiProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getLokasi()));

final peradilanTugasPokokFungsiProvider =
    AsyncNotifierProvider.autoDispose<
      PeradilanContentNotifier,
      PeradilanContent
    >(() => PeradilanContentNotifier((repo) => repo.getTugasPokokFungsi()));
