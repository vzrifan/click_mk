import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/home/data/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/features/home/data/models/jadwal_sidang.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(dioClientProvider));
});

final jadwalSidangProvider =
    FutureProvider.family<List<JadwalSidang>, ({int month, int year})>((
      ref,
      args,
    ) async {
      final repo = ref.watch(homeRepositoryProvider);
      return repo.getJadwalSidang(args.month, args.year);
    });
