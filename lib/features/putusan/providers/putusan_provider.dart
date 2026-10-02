import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/putusan/data/models/putusan.dart';
import 'package:click_mk/features/putusan/data/models/putusan_jenis.dart';
import 'package:click_mk/features/putusan/data/repositories/putusan_repository.dart';

final putusanRepositoryProvider = Provider<PutusanRepository>((ref) {
  return PutusanRepository(ref.watch(dioClientProvider));
});

class PutusanListState {
  final List<Putusan> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;

  const PutusanListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
  });

  PutusanListState copyWith({
    List<Putusan>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
  }) {
    return PutusanListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
    );
  }
}

class PutusanListNotifier extends AsyncNotifier<PutusanListState> {
  PutusanListNotifier(this.arg);

  final PutusanJenis arg;
  static const _itemsPerPage = 10;

  @override
  Future<PutusanListState> build() async {
    return _fetch(1, '');
  }

  Future<PutusanListState> _fetch(int page, String search) async {
    final repo = ref.read(putusanRepositoryProvider);
    final result = await repo.getPutusan(
      jenis: arg,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return PutusanListState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
      search: search,
    );
  }

  /// Ganti halaman — pertahankan search.
  Future<void> goToPage(int page) async {
    final current = state.asData?.value;
    if (current != null && current.currentPage == page) return;

    final maxPage = current?.totalPages ?? 1;
    if (page < 1 || page > maxPage) return;

    final search = current?.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(page, search));
  }

  /// Update search — reset ke halaman 1.
  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current != null && current.search == search) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1, search));
  }

  Future<void> refresh() async {
    final search = state.asData?.value.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1, search));
  }
}

final putusanListProvider = AsyncNotifierProvider.family
    .autoDispose<PutusanListNotifier, PutusanListState, PutusanJenis>(
      PutusanListNotifier.new,
    );
