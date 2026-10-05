import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar.dart';
import 'package:click_mk/features/ikhtisar/data/models/ikhtisar_jenis.dart';
import 'package:click_mk/features/ikhtisar/data/repositories/ikhtisar_repository.dart';

final ikhtisarRepositoryProvider = Provider<IkhtisarRepository>((ref) {
  return IkhtisarRepository(ref.watch(dioClientProvider));
});

class IkhtisarListState {
  final List<Ikhtisar> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;

  const IkhtisarListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
  });

  IkhtisarListState copyWith({
    List<Ikhtisar>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
  }) {
    return IkhtisarListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
    );
  }
}

class IkhtisarListNotifier extends AsyncNotifier<IkhtisarListState> {
  IkhtisarListNotifier(this.arg);

  final IkhtisarJenis arg;
  static const _itemsPerPage = 10;

  @override
  Future<IkhtisarListState> build() async => _fetch(1, '');

  Future<IkhtisarListState> _fetch(int page, String search) async {
    final repo = ref.read(ikhtisarRepositoryProvider);
    final result = await repo.getIkhtisar(
      jenis: arg,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return IkhtisarListState(
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

final ikhtisarListProvider = AsyncNotifierProvider.family
    .autoDispose<IkhtisarListNotifier, IkhtisarListState, IkhtisarJenis>(
      IkhtisarListNotifier.new,
    );
