import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/risalah/data/models/risalah.dart';
import 'package:click_mk/features/risalah/data/models/risalah_jenis.dart';
import 'package:click_mk/features/risalah/data/repositories/risalah_repository.dart';

final risalahRepositoryProvider = Provider<RisalahRepository>((ref) {
  return RisalahRepository(ref.watch(dioClientProvider));
});

class RisalahListState {
  final List<Risalah> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search; // ⬅ harus ada

  const RisalahListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
  });

  RisalahListState copyWith({
    List<Risalah>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
  }) {
    return RisalahListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
    );
  }
}

class RisalahListNotifier extends AsyncNotifier<RisalahListState> {
  RisalahListNotifier(this.arg);
  final RisalahJenis arg;
  static const _itemsPerPage = 10;

  @override
  Future<RisalahListState> build() async {
    return _fetch(1, '');
  }

  Future<RisalahListState> _fetch(int page, String search) async {
    final repo = ref.read(risalahRepositoryProvider);
    final result = await repo.getRisalah(
      jenis: arg,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return RisalahListState(
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

  /// ⬅ method baru
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

final risalahListProvider = AsyncNotifierProvider.family
    .autoDispose<RisalahListNotifier, RisalahListState, RisalahJenis>(
      RisalahListNotifier.new,
    );
