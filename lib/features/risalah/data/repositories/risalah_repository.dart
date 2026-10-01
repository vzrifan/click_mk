import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/risalah/data/models/risalah_jenis.dart';
import 'package:click_mk/features/risalah/data/models/risalah_page.dart';

class RisalahRepository {
  final DioClient _client;
  RisalahRepository(this._client);

  Future<RisalahPage> getRisalah({
    RisalahJenis jenis = RisalahJenis.all,
    int currentPage = 1,
    int itemsPerPage = 10,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.risalah,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        'jenis': jenis.apiValue,
      },
    );

    return RisalahPage.fromJson(response.data ?? const {});
  }
}
