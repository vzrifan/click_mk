import 'package:click_mk/core/network/api_endpoints.dart';
import 'package:click_mk/core/network/dio_client.dart';
import 'package:click_mk/features/pengumuman/data/models/pengumuman.dart';
import 'package:click_mk/features/pengumuman/data/models/pengumuman_response.dart';

class PengumumanRepository {
  final DioClient _client;
  PengumumanRepository(this._client);

  Future<List<Pengumuman>> getHighlight() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.pengumumanHighlight,
    );
    final data = response.data ?? [];
    return data
        .map((e) => Pengumuman.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PengumumanResponse> getList({
    int currentPage = 1,
    int itemsPerPage = 10,
    String search = '',
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.pengumuman,
      queryParameters: {
        'current_page': currentPage,
        'items_per_page': itemsPerPage,
        if (search.isNotEmpty) 'search': search,
      },
    );
    return PengumumanResponse.fromJson(response.data ?? const {});
  }
}
