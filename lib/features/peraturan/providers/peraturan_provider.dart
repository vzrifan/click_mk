import 'package:click_mk/features/peraturan/data/models/peraturan_statistik.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_uud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_endpoint.dart';
import 'package:click_mk/features/peraturan/data/models/peraturan_item.dart';
import 'package:click_mk/features/peraturan/data/repositories/peraturan_repository.dart';

final peraturanRepositoryProvider = Provider<PeraturanRepository>((ref) {
  return PeraturanRepository(ref.watch(dioClientProvider));
});

class PeraturanStatistikNotifier
    extends AsyncNotifier<List<PeraturanStatistik>> {
  @override
  Future<List<PeraturanStatistik>> build() async {
    final repo = ref.watch(peraturanRepositoryProvider);
    final result = await repo.getGrafikPeraturan();
    return result.items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(peraturanRepositoryProvider);
      final result = await repo.getGrafikPeraturan();
      return result.items;
    });
  }
}

final peraturanStatistikProvider =
    AsyncNotifierProvider.autoDispose<
      PeraturanStatistikNotifier,
      List<PeraturanStatistik>
    >(PeraturanStatistikNotifier.new);

class PeraturanListState {
  final List<PeraturanItem> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;
  final bool isLoading;

  const PeraturanListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
    this.isLoading = false,
  });

  PeraturanListState copyWith({
    List<PeraturanItem>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
    bool? isLoading,
  }) {
    return PeraturanListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PeraturanListNotifier extends AsyncNotifier<PeraturanListState> {
  PeraturanListNotifier(this.endpoint);

  final PeraturanEndpoint endpoint;
  static const _itemsPerPage = 10;

  @override
  Future<PeraturanListState> build() async {
    return _fetch(page: 1, search: '');
  }

  Future<PeraturanListState> _fetch({
    required int page,
    required String search,
  }) async {
    final repo = ref.read(peraturanRepositoryProvider);
    final result = await repo.getList(
      endpoint.path,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return PeraturanListState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
      search: search,
    );
  }

  Future<void> _reload(PeraturanListState next) async {
    state = AsyncData(next.copyWith(isLoading: true));
    try {
      final result = await _fetch(page: next.currentPage, search: next.search);
      state = AsyncData(result.copyWith(isLoading: false));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> goToPage(int page) async {
    final current = state.asData?.value;
    if (current == null) return;
    if (current.currentPage == page) return;
    if (page < 1 || page > current.totalPages) return;
    await _reload(current.copyWith(currentPage: page));
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

final peraturanListProvider = AsyncNotifierProvider.family
    .autoDispose<PeraturanListNotifier, PeraturanListState, PeraturanEndpoint>(
      PeraturanListNotifier.new,
    );

class PeraturanUudState {
  final List<PeraturanUud> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;
  final bool isLoading;

  const PeraturanUudState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
    this.isLoading = false,
  });

  PeraturanUudState copyWith({
    List<PeraturanUud>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
    bool? isLoading,
  }) {
    return PeraturanUudState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PeraturanUudNotifier extends AsyncNotifier<PeraturanUudState> {
  static const _itemsPerPage = 10;

  @override
  Future<PeraturanUudState> build() async {
    return _fetch(page: 1, search: '');
  }

  Future<PeraturanUudState> _fetch({
    required int page,
    required String search,
  }) async {
    final repo = ref.read(peraturanRepositoryProvider);
    final result = await repo.getUud(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
    return PeraturanUudState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
      search: search,
    );
  }

  Future<void> _reload(PeraturanUudState next) async {
    state = AsyncData(next.copyWith(isLoading: true));
    try {
      final result = await _fetch(page: next.currentPage, search: next.search);
      state = AsyncData(result.copyWith(isLoading: false));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> goToPage(int page) async {
    final current = state.asData?.value;
    if (current == null) return;
    if (current.currentPage == page) return;
    if (page < 1 || page > current.totalPages) return;
    await _reload(current.copyWith(currentPage: page));
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

final peraturanUudProvider =
    AsyncNotifierProvider.autoDispose<PeraturanUudNotifier, PeraturanUudState>(
      PeraturanUudNotifier.new,
    );
