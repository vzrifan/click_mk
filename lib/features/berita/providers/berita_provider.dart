import 'package:click_mk/features/berita/data/models/berita_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/berita/data/models/berita.dart';
import 'package:click_mk/features/berita/data/models/berita_kategori.dart';
import 'package:click_mk/features/berita/data/repositories/berita_repository.dart';

final beritaRepositoryProvider = Provider<BeritaRepository>((ref) {
  return BeritaRepository(ref.watch(dioClientProvider));
});

class BeritaHighlightState {
  final List<Berita> items;
  final BeritaKategori kategori;
  final bool isLoading;

  const BeritaHighlightState({
    this.items = const [],
    this.kategori = BeritaKategori.sidang,
    this.isLoading = false,
  });

  BeritaHighlightState copyWith({
    List<Berita>? items,
    BeritaKategori? kategori,
    bool? isLoading,
  }) {
    return BeritaHighlightState(
      items: items ?? this.items,
      kategori: kategori ?? this.kategori,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BeritaHighlightNotifier extends AsyncNotifier<BeritaHighlightState> {
  @override
  Future<BeritaHighlightState> build() async {
    final repo = ref.watch(beritaRepositoryProvider);
    final result = await repo.getList(
      kategori: BeritaKategori.sidang,
      itemsPerPage: 5,
    );
    return BeritaHighlightState(
      items: result.items,
      kategori: BeritaKategori.sidang,
    );
  }

  Future<void> setKategori(BeritaKategori kategori) async {
    final current = state.asData?.value;
    if (current != null && current.kategori == kategori) return;

    if (current != null) {
      state = AsyncData(current.copyWith(kategori: kategori, isLoading: true));
    }

    try {
      final repo = ref.read(beritaRepositoryProvider);
      final result = await repo.getList(kategori: kategori, itemsPerPage: 5);

      state = AsyncData(
        BeritaHighlightState(
          items: result.items,
          kategori: kategori,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final current = state.asData?.value;
    final kategori = current?.kategori ?? BeritaKategori.sidang;

    if (current != null) {
      state = AsyncData(current.copyWith(isLoading: true));
    }

    try {
      final repo = ref.read(beritaRepositoryProvider);
      final result = await repo.getList(kategori: kategori, itemsPerPage: 5);

      state = AsyncData(
        BeritaHighlightState(
          items: result.items,
          kategori: kategori,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final beritaHighlightProvider =
    AsyncNotifierProvider.autoDispose<
      BeritaHighlightNotifier,
      BeritaHighlightState
    >(BeritaHighlightNotifier.new);

class BeritaListState {
  final List<Berita> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final BeritaKategori kategori;
  final String search;
  final DateTime? tanggalAwal;
  final DateTime? tanggalAkhir;
  final bool isLoading;

  const BeritaListState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.kategori = BeritaKategori.sidang,
    this.search = '',
    this.tanggalAwal,
    this.tanggalAkhir,
    this.isLoading = false,
  });

  BeritaListState copyWith({
    List<Berita>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    BeritaKategori? kategori,
    String? search,
    DateTime? tanggalAwal,
    DateTime? tanggalAkhir,
    bool? isLoading,
    bool clearTanggal = false,
  }) {
    return BeritaListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      kategori: kategori ?? this.kategori,
      search: search ?? this.search,
      tanggalAwal: clearTanggal ? null : (tanggalAwal ?? this.tanggalAwal),
      tanggalAkhir: clearTanggal ? null : (tanggalAkhir ?? this.tanggalAkhir),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BeritaListNotifier extends AsyncNotifier<BeritaListState> {
  static const _itemsPerPage = 10;

  @override
  Future<BeritaListState> build() async => _fetch(
    page: 1,
    kategori: BeritaKategori.sidang,
    search: '',
    tanggalAwal: null,
    tanggalAkhir: null,
  );

  Future<BeritaListState> _fetch({
    required int page,
    required BeritaKategori kategori,
    required String search,
    DateTime? tanggalAwal,
    DateTime? tanggalAkhir,
  }) async {
    final repo = ref.read(beritaRepositoryProvider);
    final result = await repo.getList(
      kategori: kategori,
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );
    return BeritaListState(
      items: result.items,
      currentPage: result.currentPage,
      totalPages: result.totalPages,
      totalItems: result.totalItems,
      kategori: kategori,
      search: search,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );
  }

  Future<void> _reload(BeritaListState next) async {
    state = AsyncData(next.copyWith(isLoading: true));

    try {
      final result = await _fetch(
        page: next.currentPage,
        kategori: next.kategori,
        search: next.search,
        tanggalAwal: next.tanggalAwal,
        tanggalAkhir: next.tanggalAkhir,
      );

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

    state = AsyncData(current.copyWith(currentPage: page, isLoading: true));

    try {
      final result = await _fetch(
        page: page,
        kategori: current.kategori,
        search: current.search,
        tanggalAwal: current.tanggalAwal,
        tanggalAkhir: current.tanggalAkhir,
      );
      state = AsyncData(result.copyWith(isLoading: false));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setKategori(BeritaKategori kategori) async {
    final current = state.asData?.value;
    if (current == null || current.kategori == kategori) return;
    await _reload(current.copyWith(kategori: kategori, currentPage: 1));
  }

  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current == null || current.search == search) return;
    await _reload(current.copyWith(search: search, currentPage: 1));
  }

  Future<void> setTanggal({DateTime? awal, DateTime? akhir}) async {
    final current = state.asData?.value;
    if (current == null) return;
    await _reload(
      current.copyWith(
        tanggalAwal: awal,
        tanggalAkhir: akhir,
        clearTanggal: awal == null && akhir == null,
        currentPage: 1,
      ),
    );
  }

  Future<void> refresh() async {
    final current = state.asData?.value;
    if (current == null) return;
    await _reload(current.copyWith(currentPage: 1));
  }
}

final beritaListProvider =
    AsyncNotifierProvider.autoDispose<BeritaListNotifier, BeritaListState>(
      BeritaListNotifier.new,
    );

final beritaDetailProvider = FutureProvider.family<BeritaDetail, int>((
  ref,
  id,
) async {
  final repo = ref.watch(beritaRepositoryProvider);
  return repo.getDetail(id);
});
