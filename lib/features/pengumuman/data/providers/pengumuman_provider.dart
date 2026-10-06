import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/pengumuman/data/models/pengumuman.dart';
import 'package:click_mk/features/pengumuman/data/repositories/pengumuman_repository.dart';

final pengumumanRepositoryProvider = Provider<PengumumanRepository>((ref) {
  return PengumumanRepository(ref.watch(dioClientProvider));
});

class PengumumanHighlightNotifier extends AsyncNotifier<List<Pengumuman>> {
  @override
  Future<List<Pengumuman>> build() async {
    final repo = ref.watch(pengumumanRepositoryProvider);
    return repo.getHighlight();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(pengumumanRepositoryProvider);
      return repo.getHighlight();
    });
  }
}

final pengumumanHighlightProvider =
    AsyncNotifierProvider.autoDispose<
      PengumumanHighlightNotifier,
      List<Pengumuman>
    >(PengumumanHighlightNotifier.new);

class PengumumanListState {
  final List<Pengumuman> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;

  const PengumumanListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
  });

  PengumumanListState copyWith({
    List<Pengumuman>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
  }) {
    return PengumumanListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
    );
  }
}

class PengumumanListNotifier extends AsyncNotifier<PengumumanListState> {
  static const _itemsPerPage = 10;

  @override
  Future<PengumumanListState> build() async => _fetch(1, '');

  Future<PengumumanListState> _fetch(int page, String search) async {
    final repo = ref.read(pengumumanRepositoryProvider);
    final result = await repo.getList(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return PengumumanListState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
      search: search,
    );
  }

  Future<void> goToPage(int page) async {
    final current = state.asData?.value;
    if (current != null && current.currentPage == page) return;

    final maxPage = current?.totalPages ?? 1;
    if (page < 1 || page > maxPage) return;

    final search = current?.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(page, search));
  }

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

final pengumumanListProvider =
    AsyncNotifierProvider.autoDispose<
      PengumumanListNotifier,
      PengumumanListState
    >(PengumumanListNotifier.new);
