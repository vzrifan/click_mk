import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/jadwal_sidang/data/models/jadwal_sidang.dart';
import 'package:click_mk/features/jadwal_sidang/data/repositories/jadwal_sidang_repository.dart';

final jadwalSidangListRepositoryProvider = Provider<JadwalSidangListRepository>(
  (ref) {
    return JadwalSidangListRepository(ref.watch(dioClientProvider));
  },
);

class JadwalSidangListState {
  final List<JadwalSidangDetail> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int? tahun;
  final String search;

  const JadwalSidangListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.tahun,
    this.search = '',
  });

  JadwalSidangListState copyWith({
    List<JadwalSidangDetail>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? tahun,
    String? search,
    bool clearTahun = false,
  }) {
    return JadwalSidangListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      tahun: clearTahun ? null : (tahun ?? this.tahun),
      search: search ?? this.search,
    );
  }
}

class JadwalSidangListNotifier extends AsyncNotifier<JadwalSidangListState> {
  static const _itemsPerPage = 10;

  @override
  Future<JadwalSidangListState> build() async {
    return _fetch(page: 1, tahun: null, search: '');
  }

  Future<JadwalSidangListState> _fetch({
    required int page,
    required int? tahun,
    required String search,
  }) async {
    final repo = ref.read(jadwalSidangListRepositoryProvider);
    final result = await repo.getJadwalSidang(
      tahun: tahun,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return JadwalSidangListState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
      tahun: tahun,
      search: search,
    );
  }

  Future<void> _reload(JadwalSidangListState next) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetch(
        page: next.currentPage,
        tahun: next.tahun,
        search: next.search,
      ),
    );
  }

  Future<void> goToPage(int page) async {
    final current = state.asData?.value;
    if (current == null) return;
    if (current.currentPage == page) return;
    if (page < 1 || page > current.totalPages) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _fetch(page: page, tahun: current.tahun, search: current.search),
    );
  }

  Future<void> setTahun(int? tahun) async {
    final current = state.asData?.value;
    if (current == null || current.tahun == tahun) return;
    await _reload(
      current.copyWith(tahun: tahun, currentPage: 1, clearTahun: tahun == null),
    );
  }

  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current == null || current.search == search) return;
    await _reload(current.copyWith(search: search, currentPage: 1));
  }

  Future<void> refresh() async {
    final current = state.asData?.value;
    if (current == null) return;
    await _reload(current.copyWith(currentPage: 1));
  }
}

final jadwalSidangListProvider =
    AsyncNotifierProvider.autoDispose<
      JadwalSidangListNotifier,
      JadwalSidangListState
    >(JadwalSidangListNotifier.new);
