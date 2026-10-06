import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/video_mkri/data/models/vicon_response.dart';
import 'package:click_mk/features/video_mkri/data/repositories/vicon_repository.dart';

final viconRepositoryProvider = Provider<ViconRepository>((ref) {
  return ViconRepository(ref.watch(dioClientProvider));
});

class ViconNotifier extends AsyncNotifier<ViconResponse> {
  @override
  Future<ViconResponse> build() async {
    final repo = ref.watch(viconRepositoryProvider);
    return repo.getVicon();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(viconRepositoryProvider);
      return repo.getVicon();
    });
  }
}

final viconProvider =
    AsyncNotifierProvider.autoDispose<ViconNotifier, ViconResponse>(
      ViconNotifier.new,
    );
