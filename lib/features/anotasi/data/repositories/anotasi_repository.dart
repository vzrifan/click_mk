import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/anotasi/data/models/anotasi_response.dart';

class AnotasiRepository {
  final DioClient _client;
  AnotasiRepository(this._client);

  Future<AnotasiResponse> getAnotasi({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.anotasi,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return AnotasiResponse.fromJson(response.data ?? const {});
  }
}
