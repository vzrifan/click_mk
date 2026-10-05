import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/anotasi/data/models/anotasi.dart';
import 'package:click_mk/features/anotasi/data/repositories/anotasi_repository.dart';

final anotasiRepositoryProvider = Provider<AnotasiRepository>((ref) {
  return AnotasiRepository(ref.watch(dioClientProvider));
});

class AnotasiListState {
  final List<Anotasi> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;

  const AnotasiListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
  });

  AnotasiListState copyWith({
    List<Anotasi>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
  }) {
    return AnotasiListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
    );
  }
}

class AnotasiListNotifier extends AsyncNotifier<AnotasiListState> {
  static const _itemsPerPage = 10;

  @override
  Future<AnotasiListState> build() async => _fetch(1, '');

  Future<AnotasiListState> _fetch(int page, String search) async {
    final repo = ref.read(anotasiRepositoryProvider);
    final result = await repo.getAnotasi(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return AnotasiListState(
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

final anotasiListProvider =
    AsyncNotifierProvider.autoDispose<AnotasiListNotifier, AnotasiListState>(
      AnotasiListNotifier.new,
    );
