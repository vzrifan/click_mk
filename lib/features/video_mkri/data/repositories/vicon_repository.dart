import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/video_mkri/data/models/vicon_response.dart';

class ViconRepository {
  final DioClient _client;
  ViconRepository(this._client);

  Future<ViconResponse> getVicon() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.vicon,
    );
    return ViconResponse.fromJson(response.data ?? const {});
  }
}
