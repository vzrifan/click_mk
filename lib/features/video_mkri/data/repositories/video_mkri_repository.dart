import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/video_mkri/data/models/video_mkri.dart';

class VideoMkriRepository {
  final DioClient _client;
  VideoMkriRepository(this._client);

  Future<List<VideoMkri>> getVideos() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.videoMkri,
    );
    final items = (response.data?['items'] as List<dynamic>? ?? []);
    return items
        .map((e) => VideoMkri.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
