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

  const RisalahListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
  });

  RisalahListState copyWith({
    List<Risalah>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
  }) {
    return RisalahListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class RisalahListNotifier extends AsyncNotifier<RisalahListState> {
  RisalahListNotifier(this.arg);

  final RisalahJenis arg;
  static const _itemsPerPage = 10;

  @override
  Future<RisalahListState> build() async {
    return _fetch(1);
  }

  Future<RisalahListState> _fetch(int page) async {
    final repo = ref.read(risalahRepositoryProvider);
    final result = await repo.getRisalah(
      jenis: arg,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
    );
    return RisalahListState(
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

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1));
  }
}

final risalahListProvider = AsyncNotifierProvider.family
    .autoDispose<RisalahListNotifier, RisalahListState, RisalahJenis>(
      RisalahListNotifier.new,
    );
