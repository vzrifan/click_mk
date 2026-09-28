import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';

class HakimRepository {
  const HakimRepository(this._client);

  final DioClient _client;

  Future<dynamic> getHakim() async {
    final response = await _client.get(ApiEndpoints.hakim);

    return response.data;
  }
}
