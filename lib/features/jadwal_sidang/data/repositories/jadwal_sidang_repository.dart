import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/jadwal_sidang/data/models/jadwal_sidang_response.dart';

class JadwalSidangListRepository {
  final DioClient _client;
  JadwalSidangListRepository(this._client);

  Future<JadwalSidangResponse> getJadwalSidang({
    int? tahun,
    String? tanggal,
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.jadwalSidangList,
      queryParameters: {
        if (tahun != null) 'tahun': tahun.toString(),
        if (tanggal != null && tanggal.isNotEmpty) 'tanggal': tanggal,
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return JadwalSidangResponse.fromJson(response.data ?? const {});
  }
}
