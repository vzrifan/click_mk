import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:click_mk/core/network/dio_provider.dart';
import 'package:click_mk/features/video_mkri/data/models/video_mkri.dart';
import 'package:click_mk/features/video_mkri/data/repositories/video_mkri_repository.dart';

final videoMkriRepositoryProvider = Provider<VideoMkriRepository>((ref) {
  return VideoMkriRepository(ref.watch(dioClientProvider));
});

class VideoMkriNotifier extends AsyncNotifier<List<VideoMkri>> {
  @override
  Future<List<VideoMkri>> build() async {
    final repo = ref.watch(videoMkriRepositoryProvider);
    return repo.getVideos();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(videoMkriRepositoryProvider);
      return repo.getVideos();
    });
  }
}

final videoMkriProvider =
    AsyncNotifierProvider.autoDispose<VideoMkriNotifier, List<VideoMkri>>(
      VideoMkriNotifier.new,
    );
