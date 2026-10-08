import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_jadwal_sidang.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_keputusan.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_pelaporan.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_peraturan.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_risalah_sidang.dart';
import 'package:click_mk/features/peradilan/data/models/peradilan_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/peradilan/data/models/mkmk/mkmk_profil.dart';
import 'package:click_mk/features/peradilan/data/repositories/mkmk_repository.dart';

final mkmkRepositoryProvider = Provider<MkmkRepository>((ref) {
  return MkmkRepository(ref.watch(dioClientProvider));
});

final mkmkProfilProvider = FutureProvider.autoDispose<List<MkmkProfil>>((
  ref,
) async {
  final repo = ref.watch(mkmkRepositoryProvider);
  return repo.getProfil();
});

final mkmkPeraturanProvider = FutureProvider.autoDispose<List<MkmkPeraturan>>((
  ref,
) async {
  final repo = ref.watch(mkmkRepositoryProvider);
  return repo.getPeraturan();
});

class MkmkKeputusanState {
  final List<MkmkKeputusan> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;
  final bool isLoading;

  const MkmkKeputusanState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
    this.isLoading = false,
  });

  MkmkKeputusanState copyWith({
    List<MkmkKeputusan>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
    bool? isLoading,
  }) {
    return MkmkKeputusanState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MkmkKeputusanNotifier extends AsyncNotifier<MkmkKeputusanState> {
  static const _itemsPerPage = 10;

  @override
  Future<MkmkKeputusanState> build() async {
    final items = await _fetch(1, '');
    return MkmkKeputusanState(items: items);
  }

  Future<List<MkmkKeputusan>> _fetch(int page, String search) async {
    final repo = ref.read(mkmkRepositoryProvider);
    return repo.getKeputusan(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
  }

  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current == null || current.search == search) return;
    state = AsyncData(current.copyWith(isLoading: true, search: search));
    try {
      final items = await _fetch(1, search);
      state = AsyncData(
        current.copyWith(
          items: items,
          currentPage: 1,
          search: search,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final search = state.asData?.value.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = await _fetch(1, search);
      return MkmkKeputusanState(items: items, search: search);
    });
  }
}

final mkmkKeputusanProvider =
    AsyncNotifierProvider.autoDispose<
      MkmkKeputusanNotifier,
      MkmkKeputusanState
    >(MkmkKeputusanNotifier.new);

class MkmkPelaporanState {
  final List<MkmkPelaporan> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;
  final bool isLoading;

  const MkmkPelaporanState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
    this.isLoading = false,
  });

  MkmkPelaporanState copyWith({
    List<MkmkPelaporan>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
    bool? isLoading,
  }) {
    return MkmkPelaporanState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MkmkPelaporanNotifier extends AsyncNotifier<MkmkPelaporanState> {
  static const _itemsPerPage = 10;

  @override
  Future<MkmkPelaporanState> build() async {
    final items = await _fetch(1, '');
    return MkmkPelaporanState(items: items);
  }

  Future<List<MkmkPelaporan>> _fetch(int page, String search) async {
    final repo = ref.read(mkmkRepositoryProvider);
    return repo.getPelaporan(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
  }

  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current == null || current.search == search) return;
    state = AsyncData(current.copyWith(isLoading: true, search: search));
    try {
      final items = await _fetch(1, search);
      state = AsyncData(
        current.copyWith(
          items: items,
          currentPage: 1,
          search: search,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final search = state.asData?.value.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = await _fetch(1, search);
      return MkmkPelaporanState(items: items, search: search);
    });
  }
}

final mkmkPelaporanProvider =
    AsyncNotifierProvider.autoDispose<
      MkmkPelaporanNotifier,
      MkmkPelaporanState
    >(MkmkPelaporanNotifier.new);

class MkmkJadwalSidangState {
  final List<MkmkJadwalSidang> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;
  final bool isLoading;

  const MkmkJadwalSidangState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
    this.isLoading = false,
  });

  MkmkJadwalSidangState copyWith({
    List<MkmkJadwalSidang>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
    bool? isLoading,
  }) {
    return MkmkJadwalSidangState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MkmkJadwalSidangNotifier extends AsyncNotifier<MkmkJadwalSidangState> {
  static const _itemsPerPage = 10;

  @override
  Future<MkmkJadwalSidangState> build() async {
    final items = await _fetch(1, '');
    return MkmkJadwalSidangState(items: items);
  }

  Future<List<MkmkJadwalSidang>> _fetch(int page, String search) async {
    final repo = ref.read(mkmkRepositoryProvider);
    return repo.getJadwalSidang(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
  }

  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current == null || current.search == search) return;
    state = AsyncData(current.copyWith(isLoading: true, search: search));
    try {
      final items = await _fetch(1, search);
      state = AsyncData(
        current.copyWith(
          items: items,
          currentPage: 1,
          search: search,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final search = state.asData?.value.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = await _fetch(1, search);
      return MkmkJadwalSidangState(items: items, search: search);
    });
  }
}

final mkmkJadwalSidangProvider =
    AsyncNotifierProvider.autoDispose<
      MkmkJadwalSidangNotifier,
      MkmkJadwalSidangState
    >(MkmkJadwalSidangNotifier.new);

class MkmkRisalahSidangState {
  final List<MkmkRisalahSidang> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final String search;
  final bool isLoading;

  const MkmkRisalahSidangState({
    this.items = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.search = '',
    this.isLoading = false,
  });

  MkmkRisalahSidangState copyWith({
    List<MkmkRisalahSidang>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    String? search,
    bool? isLoading,
  }) {
    return MkmkRisalahSidangState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MkmkRisalahSidangNotifier extends AsyncNotifier<MkmkRisalahSidangState> {
  static const _itemsPerPage = 10;

  @override
  Future<MkmkRisalahSidangState> build() async {
    final items = await _fetch(1, '');
    return MkmkRisalahSidangState(items: items);
  }

  Future<List<MkmkRisalahSidang>> _fetch(int page, String search) async {
    final repo = ref.read(mkmkRepositoryProvider);
    return repo.getRisalahSidang(
      currentPage: page,
      itemsPerPage: _itemsPerPage,
      search: search,
    );
  }

  Future<void> setSearch(String search) async {
    final current = state.asData?.value;
    if (current == null || current.search == search) return;
    state = AsyncData(current.copyWith(isLoading: true, search: search));
    try {
      final items = await _fetch(1, search);
      state = AsyncData(
        current.copyWith(
          items: items,
          currentPage: 1,
          search: search,
          isLoading: false,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() async {
    final search = state.asData?.value.search ?? '';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final items = await _fetch(1, search);
      return MkmkRisalahSidangState(items: items, search: search);
    });
  }
}

final mkmkRisalahSidangProvider =
    AsyncNotifierProvider.autoDispose<
      MkmkRisalahSidangNotifier,
      MkmkRisalahSidangState
    >(MkmkRisalahSidangNotifier.new);

final mkmkHistoriKelembagaanProvider =
    FutureProvider.autoDispose<PeradilanContent>((ref) async {
      final repo = ref.watch(mkmkRepositoryProvider);
      return repo.getHistoriKelembagaan();
    });
