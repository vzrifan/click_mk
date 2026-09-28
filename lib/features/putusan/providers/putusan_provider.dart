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

  const PutusanListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
  });

  PutusanListState copyWith({
    List<Putusan>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
  }) {
    return PutusanListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class PutusanListNotifier extends AsyncNotifier<PutusanListState> {
  PutusanListNotifier(this.arg);

  final PutusanJenis arg;
  static const _itemsPerPage = 10;

  @override
  Future<PutusanListState> build() async {
    return _fetch(1);
  }

  Future<PutusanListState> _fetch(int page) async {
    final repo = ref.read(putusanRepositoryProvider);
    final result = await repo.getPutusan(
      jenis: arg,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
    );
    return PutusanListState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
    );
  }

  Future<void> goToPage(int page) async {
    final current = state.asData?.value;
    if (current != null && current.currentPage == page) return;

    final maxPage = current?.totalPages ?? 1;
    if (page < 1 || page > maxPage) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(page));
  }

  Future<void> nextPage() async {
    final current = state.asData?.value;
    if (current == null) return;
    await goToPage(current.currentPage + 1);
  }

  Future<void> prevPage() async {
    final current = state.asData?.value;
    if (current == null) return;
    await goToPage(current.currentPage - 1);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1));
  }
}

final putusanListProvider = AsyncNotifierProvider.family
    .autoDispose<PutusanListNotifier, PutusanListState, PutusanJenis>(
      PutusanListNotifier.new,
    );
