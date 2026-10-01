import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/home/data/models/banner.dart';
import 'package:click_mk/features/home/data/repositories/banner_repository.dart';

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepository(ref.watch(dioClientProvider));
});

class BannerListNotifier extends AsyncNotifier<List<BannerItem>> {
  @override
  Future<List<BannerItem>> build() async {
    final repo = ref.watch(bannerRepositoryProvider);
    return repo.getBanners();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(bannerRepositoryProvider);
      return repo.getBanners();
    });
  }
}

final bannerListProvider =
    AsyncNotifierProvider<BannerListNotifier, List<BannerItem>>(
      BannerListNotifier.new,
    );
