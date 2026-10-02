import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/putusan/data/models/putusan_jenis.dart';
import 'package:click_mk/features/putusan/data/models/putusan_page.dart';

class PutusanRepository {
  final DioClient _client;
  PutusanRepository(this._client);

  Future<PutusanPage> getPutusan({
    PutusanJenis jenis = PutusanJenis.all,
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.putusan,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        'jenis': jenis.apiValue,
        if (search.isNotEmpty) 'search': search,
      },
    );

    return PutusanPage.fromJson(response.data ?? const {});
  }
}
