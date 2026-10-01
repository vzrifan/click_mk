import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/hakim/data/models/hakim_page.dart';

class HakimRepository {
  final DioClient _client;
  HakimRepository(this._client);

  Future<HakimPage> getHakim() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.hakim,
    );
    return HakimPage.fromJson(response.data ?? const {});
  }
}
