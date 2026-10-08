import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/peradilan/data/models/lhkpn.dart';
import 'package:click_mk/features/peradilan/data/models/pejabat.dart';
import 'package:click_mk/features/peradilan/data/repositories/pejabat_repository.dart';

final pejabatRepositoryProvider = Provider<PejabatRepository>((ref) {
  return PejabatRepository(ref.watch(dioClientProvider));
});

// ── List pejabat (family by jabatan + status) ──────
final pejabatListProvider = FutureProvider.family
    .autoDispose<
      List<Pejabat>,
      ({PejabatJabatan jabatan, PejabatStatus status})
    >((ref, args) async {
      final repo = ref.watch(pejabatRepositoryProvider);
      return repo.getList(jabatan: args.jabatan, status: args.status);
    });

// ── Detail pejabat (family by id) ─────────────────
final pejabatDetailProvider = FutureProvider.family.autoDispose<Pejabat, int>((
  ref,
  id,
) async {
  final repo = ref.watch(pejabatRepositoryProvider);
  return repo.getDetail(id);
});

// ── LHKPN (family by pejabat id) ──────────────────
final pejabatLhkpnProvider = FutureProvider.family
    .autoDispose<List<Lhkpn>, int>((ref, id) async {
      final repo = ref.watch(pejabatRepositoryProvider);
      return repo.getLhkpn(id);
    });
